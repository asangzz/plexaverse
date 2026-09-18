import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/ui/widgets/in_app_notification_overlay.dart';
import '../data/notification_repositories.dart';
import '../domain/notification_repository.dart';

part 'notification_controllers.g.dart';

/// The persisted notification inbox, newest first — the single source of
/// truth for the drawer AND the bell badge. Backed by the encrypted Drift
/// [NotificationDao] (RULINGS #15: the inbox stays; FCM handles the system
/// tray in the background). Reactive: the DAO stream re-emits on every
/// insert / read / delete.
final notificationInboxProvider =
    StreamProvider.autoDispose<List<NotificationsTableData>>((ref) {
  return ref.watch(appDatabaseProvider).notificationDao.watchAllNotifications();
});

/// Live unread count — drives the badge on the bell icon. Derived from the
/// same DAO stream so it always stays in lockstep with the drawer.
final unreadNotificationCountProvider = StreamProvider.autoDispose<int>((ref) {
  final dao = ref.watch(appDatabaseProvider).notificationDao;
  return dao
      .watchAllNotifications()
      .map((list) => list.where((n) => !n.isRead).length);
});

/// Live foreground pushes (FCM in prod, empty in the mock). keepAlive so the
/// FCM stream subscription stays put — a push must never be dropped in a
/// listener gap. [NotificationIngestor] bridges this into the Drift inbox +
/// the in-app banner; rebuilds (re-subscribes) when the repository is
/// invalidated on sign-out.
@Riverpod(keepAlive: true)
Stream<AppNotification> incomingNotifications(Ref ref) {
  return ref.watch(notificationRepositoryProvider).incoming;
}

/// Bridges a live [AppNotification] (from FCM foreground, or the dev
/// "simulate" action) into both product surfaces:
///   1. persists it to the Drift inbox (so the drawer + badge update), and
///   2. raises the transient in-app banner via the core overlay controller.
///
/// keepAlive so a push that arrives on any screen is handled. The core
/// [InAppNotification] model is presentation-only, so we map onto it here;
/// the deep-link route rides along for tap-to-navigate.
@Riverpod(keepAlive: true)
class NotificationIngestor extends _$NotificationIngestor {
  @override
  void build() {
    // Auto-drain FCM foreground pushes into the pipeline.
    ref.listen<AsyncValue<AppNotification>>(
      incomingNotificationsProvider,
      (previous, next) {
        next.whenData(ingest);
      },
      fireImmediately: true,
    );
  }

  /// Persist [notification] to the inbox and raise the in-app banner. Used by
  /// the FCM foreground bridge and the debug "simulate" action.
  Future<void> ingest(AppNotification notification) async {
    await ref.read(appDatabaseProvider).notificationDao.insertNotification(
          NotificationsTableCompanion(
            remoteId: Value(notification.id),
            title: Value(notification.title),
            body: Value(notification.body),
            type: Value(notification.category.wire),
            payload: Value(notification.route),
            isRead: Value(notification.read),
            receivedAt: Value(notification.createdAt),
          ),
        );
    ref.read(inAppNotificationControllerProvider.notifier).show(
          InAppNotification(
            id: notification.id,
            title: notification.title,
            body: notification.body.isEmpty ? null : notification.body,
            route: notification.route,
          ),
        );
  }

  /// Debug-only: exercise the banner + inbox without a push server (the same
  /// path a real FCM foreground push takes). Wired to a debug-only action in
  /// the notification drawer.
  Future<void> simulate() {
    final now = clock.now();
    return ingest(
      AppNotification(
        id: 'sim-${now.microsecondsSinceEpoch}',
        title: 'Your video is ready',
        body: 'Your avatar video just finished rendering.',
        category: NotificationCategory.postPublished,
        createdAt: now,
        read: false,
        // Deep-link to a LIVE shell branch — '/posts' is no longer routed
        // (HeyGen re-skin shell: home/videos/avatars only).
        route: RoutePaths.videos,
      ),
    );
  }
}
