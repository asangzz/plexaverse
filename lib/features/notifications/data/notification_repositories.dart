import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/mock/mock_api.dart';
import '../../../core/platform/notifications_service.dart';
import '../domain/notification_repository.dart';

/// Mock push backend. There is no push server behind the mock, so device
/// registration is a silent no-op and `incoming` is empty — the dev
/// "simulate" action on the inbox page drives the in-app pipeline instead.
/// The persisted inbox is Drift-backed regardless of this repo, so the drawer
/// works unchanged in dev.
/// The fixture the mock inbox reads. Same payload shape the server returns,
/// so `AppNotification.fromJson` is exercised by both flavors.
const String _kInboxAsset = 'assets/mock/notifications/notifications.json';

class MockNotificationRepository implements NotificationRepository {
  const MockNotificationRepository();

  @override
  Future<void> registerDevice(String token, {String platform = 'android'}) async {}

  @override
  Future<void> unregisterDevice(String token) async {}

  @override
  Stream<AppNotification> get incoming => const Stream<AppNotification>.empty();

  @override
  Future<NotificationPage> fetchInbox({String? cursor, int limit = 20}) async {
    // One page only — the mock has no cursor store, and pretending otherwise
    // would let an infinite-scroll bug pass here and fail against the server.
    if (cursor != null) return const NotificationPage(notifications: <AppNotification>[]);
    final List<dynamic> raw = await MockApi.loadArray(_kInboxAsset);
    return NotificationPage(
      notifications: raw
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList(growable: false),
    );
  }

  @override
  Future<int> fetchUnreadCount() async {
    final NotificationPage page = await fetchInbox();
    return page.notifications.where((AppNotification n) => !n.read).length;
  }

  @override
  Future<void> markRead(String id) async {}

  @override
  Future<void> markAllRead() async {}
}

/// Real impl of the push-backend seam: registers/unregisters the FCM device
/// token over Dio and maps foreground pushes off the platform adapter into
/// neutral [AppNotification]s (which the controller mirrors into the Drift
/// inbox + raises as an in-app banner).
class ApiNotificationRepository implements NotificationRepository {
  const ApiNotificationRepository(this._push, this._client);

  final NotificationsService _push;
  final DioClient _client;

  @override
  Future<NotificationPage> fetchInbox({String? cursor, int limit = 20}) async {
    final response = await _client.get<dynamic>(
      ApiPaths.notifications,
      queryParameters: <String, dynamic>{
        'limit': limit,
        'cursor': ?cursor,
      },
    );
    // The envelope seam hands back `data` already unwrapped, and `meta`
    // carries the cursor. DioClient exposes meta via its unwrapped envelope,
    // so a list body and a `{items, meta}` body both have to be handled.
    final Object? body = response.data;
    final List<dynamic> raw = switch (body) {
      final List<dynamic> list => list,
      final Map<String, dynamic> map =>
        (map['notifications'] as List<dynamic>?) ??
            (map['items'] as List<dynamic>?) ??
            const <dynamic>[],
      _ => const <dynamic>[],
    };
    final Map<String, dynamic>? meta = response.extra['meta'] is Map<String, dynamic>
        ? response.extra['meta'] as Map<String, dynamic>
        : null;
    final Map<String, dynamic>? page =
        meta?['pagination'] as Map<String, dynamic>?;

    return NotificationPage(
      notifications: raw
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList(growable: false),
      nextCursor: page?['cursor'] as String?,
      hasMore: page?['hasMore'] == true,
    );
  }

  @override
  Future<int> fetchUnreadCount() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.notificationsUnreadCount,
    );
    final Object? count = response.data?['count'] ?? response.data?['unread'];
    return count is int ? count : 0;
  }

  @override
  Future<void> markRead(String id) =>
      _client.patch<Map<String, dynamic>>(
        '${ApiPaths.notifications}/$id',
        data: <String, dynamic>{'isRead': true},
      );

  @override
  Future<void> markAllRead() =>
      _client.post<Map<String, dynamic>>(ApiPaths.notificationsMarkAllRead);

  // Both of these intentionally do nothing.
  //
  // The mobile API has NO device-registration endpoint. These used to POST and
  // DELETE against `/notifications/devices`, which meant every launch fired a
  // request that 404ed — swallowed by the caller's best-effort catch, so the
  // app looked like it had push registered when it never did.
  //
  // Push notifications cannot work until that route is added server-side. Doing
  // nothing is the honest behaviour until then; a silent 404 per launch is not.
  @override
  Future<void> registerDevice(String token, {String platform = 'android'}) async {}

  @override
  Future<void> unregisterDevice(String token) async {}

  @override
  Stream<AppNotification> get incoming => _push.incomingMessages.map(fromPush);

  /// Maps a foreground [PushMessage] to an [AppNotification]. The FCM payload
  /// carries the in-app deep link in `data['route']` (RULINGS #15) and the
  /// product category in `data['type']`. Public for testing the mapping.
  static AppNotification fromPush(PushMessage m) {
    return AppNotification(
      id: m.id ?? 'push-${clock.now().microsecondsSinceEpoch}',
      title: m.title ?? '',
      body: m.body ?? '',
      category: NotificationCategoryX.fromWire(m.data['type']),
      createdAt: clock.now(),
      read: false,
      route: m.data['route'],
    );
  }
}

/// Mock ↔ real switch on `useFakeBackend`; release builds can never get the
/// mock. Override in tests with `overrideWithValue`.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return const MockNotificationRepository();
  }
  return ApiNotificationRepository(
    ref.watch(notificationsServiceProvider),
    ref.watch(dioClientProvider),
  );
});
