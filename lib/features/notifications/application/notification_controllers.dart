import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/zave_routes.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/dao/notification_dao.dart';
import '../../../core/ui/widgets/in_app_notification_overlay.dart';
import '../data/notification_repositories.dart';
import '../domain/notification_repository.dart';

part 'notification_controllers.g.dart';

/// The notification inbox, newest first — what the drawer and the bell badge
/// both read.
///
/// **The server is the source of truth; Drift is the cache.** It used to be
/// the other way round, which meant the inbox only ever held foreground
/// pushes this device happened to receive while running. Everything the
/// server raised — an approval request, a publish result, a LinkedIn token
/// about to expire — never appeared on the phone at all, and the badge
/// counted a number nobody else could see.
///
/// Reading stays on the Drift stream on purpose. It re-emits on every write,
/// so the drawer and badge update the instant something is marked read,
/// without a refetch; and when the network is gone the last synced page is
/// still there instead of an empty list. [notificationSyncProvider] is
/// watched here so opening the drawer triggers a refresh.
final notificationInboxProvider =
    StreamProvider.autoDispose<List<NotificationsTableData>>((ref) {
  ref.watch(notificationSyncProvider);
  return ref.watch(appDatabaseProvider).notificationDao.watchAllNotifications();
});

/// Pulls the server inbox into the cache. Watched by
/// [notificationInboxProvider], so it runs when the inbox is first read.
///
/// A failure is deliberately NOT surfaced as an error state: the cached page
/// below is still worth showing, and an offline user staring at an error
/// where their notifications used to be is worse than slightly stale ones.
@riverpod
Future<void> notificationSync(Ref ref) async {
  final NotificationRepository repo = ref.watch(notificationRepositoryProvider);
  final dao = ref.watch(appDatabaseProvider).notificationDao;
  try {
    final NotificationPage page = await repo.fetchInbox();
    await dao.upsertFromServer(<RemoteNotification>[
      for (final AppNotification n in page.notifications)
        RemoteNotification(
          remoteId: n.id,
          title: n.title,
          body: n.body,
          type: n.category.wire,
          isRead: n.read,
          receivedAt: n.createdAt,
          route: n.route,
        ),
    ]);
    // Only prune against a COMPLETE first page. With more pages behind the
    // cursor, anything not in page one is not absent — it is just further
    // down, and dropping it would delete the user's older notifications.
    if (!page.hasMore) {
      await dao.pruneMissing(
        page.notifications.map((AppNotification n) => n.id).toSet(),
      );
    }
  } on Object {
    // Cached page stands. See the doc comment.
  }
}

/// Marking read, on the server AND in the cache.
///
/// The drawer used to call the DAO directly, so a notification read on the
/// phone stayed unread everywhere else and came back unread on the next
/// sync — read state belongs to the account, not the device.
@riverpod
class NotificationReads extends _$NotificationReads {
  @override
  void build() {}

  Future<void> markRead(NotificationsTableData row) async {
    final dao = ref.read(appDatabaseProvider).notificationDao;
    // Locally first: the drawer should tick instantly, and the server call
    // is idempotent, so a failure leaves the two out of step only until the
    // next sync corrects it.
    await dao.markAsRead(row.id);
    final String? remoteId = row.remoteId;
    if (remoteId == null) return; // an unsynced foreground push
    try {
      await ref.read(notificationRepositoryProvider).markRead(remoteId);
    } on Object {
      // Next sync reconciles.
    }
  }

  Future<void> markAllRead() async {
    await ref.read(appDatabaseProvider).notificationDao.markAllAsRead();
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
    } on Object {
      // Next sync reconciles.
    }
  }
}

/// Live unread count — drives the badge on the bell icon. Derived from the
/// same DAO stream so it always stays in lockstep with the drawer.
///
/// Watches the sync as well, because the badge is read on every screen and
/// the drawer on almost none: without this the count would only become true
/// after the user opened the thing the count is supposed to make them open.
final unreadNotificationCountProvider = StreamProvider.autoDispose<int>((ref) {
  ref.watch(notificationSyncProvider);
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
        // Plexaverse copy. This used to read "Your video is ready / Your
        // avatar video just finished rendering" and deep-link to a videos tab
        // — leftover from the skin this app was cloned from, in a dev action
        // that is the quickest way to eyeball the notification pipeline.
        title: 'Your post is live',
        body: 'Today\'s post just published to LinkedIn.',
        category: NotificationCategory.postPublished,
        createdAt: now,
        read: false,
        route: ZaveRoutes.posts,
      ),
    );
  }
}
