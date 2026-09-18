import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/platform/notifications_service.dart';
import '../domain/notification_repository.dart';

/// Mock push backend. There is no push server behind the mock, so device
/// registration is a silent no-op and `incoming` is empty — the dev
/// "simulate" action on the inbox page drives the in-app pipeline instead.
/// The persisted inbox is Drift-backed regardless of this repo, so the drawer
/// works unchanged in dev.
class MockNotificationRepository implements NotificationRepository {
  const MockNotificationRepository();

  @override
  Future<void> registerDevice(String token, {String platform = 'android'}) async {}

  @override
  Future<void> unregisterDevice(String token) async {}

  @override
  Stream<AppNotification> get incoming => const Stream<AppNotification>.empty();
}

/// Real impl of the push-backend seam: registers/unregisters the FCM device
/// token over Dio and maps foreground pushes off the platform adapter into
/// neutral [AppNotification]s (which the controller mirrors into the Drift
/// inbox + raises as an in-app banner).
class ApiNotificationRepository implements NotificationRepository {
  const ApiNotificationRepository(this._push);

  final NotificationsService _push;

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
  return ApiNotificationRepository(ref.watch(notificationsServiceProvider));
});
