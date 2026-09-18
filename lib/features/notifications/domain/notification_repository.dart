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
}
