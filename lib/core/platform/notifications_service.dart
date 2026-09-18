import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_service.g.dart';

/// A push, mapped off FCM's `RemoteMessage` so feature code never imports
/// `firebase_messaging` directly (the adapter keeps the platform package
/// contained — ProHealth §2.4 DIP). `data` carries the custom payload
/// (category, deepLink, …) the backend sends alongside the notification.
class PushMessage {
  const PushMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
  });

  final String? id;
  final String? title;
  final String? body;
  final Map<String, String> data;
}

/// FCM adapter (RULINGS §15 — FCM system tray handles background; the in-app
/// overlay + Drift inbox handle foreground/history). Push delivery is
/// best-effort: when Firebase isn't configured (no `firebase_options.dart` /
/// platform config), the token is null, the streams simply never emit, and
/// the inbox still works via the repository.
class NotificationsService {
  NotificationsService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// The current device token, or null when Firebase isn't configured.
  Future<String?> deviceToken() => _messaging.getToken();

  /// Invalidates the current token (called on sign-out so a signed-out
  /// device stops receiving push even if the server unregister is missed).
  Future<void> deleteToken() => _messaging.deleteToken();

  /// Emits whenever FCM rotates the token — the app must re-register it.
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;

  /// Foreground pushes mapped to the neutral [PushMessage]. Drives the
  /// in-app banner + inbox via the repository's `incoming` stream.
  Stream<PushMessage> get incomingMessages =>
      FirebaseMessaging.onMessage.map(_map);

  /// Pushes the user *tapped* while the app was backgrounded (not
  /// terminated). The app routes these to the payload's `deepLink`.
  Stream<PushMessage> get openedMessages =>
      FirebaseMessaging.onMessageOpenedApp.map(_map);

  /// The push that *launched* the app from a terminated state (cold-start
  /// tap), or null. Checked once after sign-in so the deep link is honoured.
  Future<PushMessage?> initialMessage() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _map(message);
  }

  static PushMessage _map(RemoteMessage m) => PushMessage(
        id: m.messageId,
        title: m.notification?.title,
        body: m.notification?.body,
        data: m.data.map((k, v) => MapEntry(k, '$v')),
      );
}

@Riverpod(keepAlive: true)
NotificationsService notificationsService(Ref ref) {
  return NotificationsService(FirebaseMessaging.instance);
}

/// Background/terminated **data** message handler. Notification-payload
/// pushes are rendered in the system tray by the OS automatically, so the
/// common case needs nothing here — this exists so data-only pushes aren't
/// dropped silently and there's an obvious place to handle them later
/// (e.g. badge sync). Must be a top-level/static function annotated for the
/// AOT entry-point, since it runs in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Intentionally a no-op for now. If this ever touches Firebase services
  // it must call `Firebase.initializeApp()` first (separate isolate).
}

/// Registers [firebaseMessagingBackgroundHandler] with FCM. Call once at
/// boot, after Firebase has initialised.
void registerBackgroundMessageHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}
