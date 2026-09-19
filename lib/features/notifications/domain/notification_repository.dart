import 'notification_models.dart';

export 'notification_models.dart';

/// Thrown when a notifications transport call fails. The inbox itself is
/// Drift-backed and never depends on the network (RULINGS #15), so this only
/// ever surfaces from optional server sync — device registration swallows its
/// own failures (best-effort).
class NotificationsUnavailable implements Exception {
  const NotificationsUnavailable();
}

/// Seam between the Notifications module and the push backend; resolved
/// mock/real by `notificationRepositoryProvider` via `useFakeBackend`.
///
/// The persisted inbox (the drawer) lives in Drift (`NotificationDao`) and is
/// the local source of truth — this seam owns only the network-facing
/// concerns: FCM device registration, and (in the real impl) the live
/// foreground-push stream that gets mirrored into the inbox.
abstract class NotificationRepository {
  /// Register this device's FCM token for push delivery
  /// (`POST /notifications/devices`). Idempotent on the server — re-sending
  /// the same token just refreshes its last-seen timestamp.
  Future<void> registerDevice(String token, {String platform});

  /// Unregister an FCM token (`DELETE /notifications/devices?token=`).
  /// Unknown tokens are a no-op server-side.
  Future<void> unregisterDevice(String token);

  /// Live foreground pushes. FCM `onMessage` (mapped off the platform adapter)
  /// in production; an empty stream in the mock (no push backend) — the dev
  /// "simulate" action drives the in-app pipeline instead. Never errors;
  /// closing is fine.
  Stream<AppNotification> get incoming;

  /// The user's notifications from the SERVER, newest first.
  ///
  /// The inbox used to be the local Drift table and nothing else, which meant
  /// it only ever held foreground pushes this device happened to receive
  /// while running. Everything the server raised — an approval request, a
  /// publish result, a token expiring — was invisible on mobile, and the
  /// badge counted a number no one else could see. Drift is now a cache of
  /// this, not a substitute for it.
  ///
  /// [cursor] comes from a previous page's [NotificationPage.nextCursor].
  Future<NotificationPage> fetchInbox({String? cursor, int limit = 20});

  /// Unread count from the server, so the badge matches what web shows.
  Future<int> fetchUnreadCount();

  /// Marks one notification read. [id] is the SERVER id.
  Future<void> markRead(String id);

  /// Marks every notification read.
  Future<void> markAllRead();
}


/// One page of the server-side inbox.
class NotificationPage {
  const NotificationPage({
    required this.notifications,
    this.nextCursor,
    this.hasMore = false,
  });

  final List<AppNotification> notifications;

  /// Pass back as `cursor` to fetch the next page; null when there is none.
  final String? nextCursor;
  final bool hasMore;
}
