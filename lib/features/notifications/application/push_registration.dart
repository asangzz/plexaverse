import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/platform/notifications_service.dart';
import '../../../core/router/app_router.dart';
import '../data/notification_repositories.dart';
import 'notification_controllers.dart';

part 'push_registration.g.dart';

/// Owns the FCM device-token lifecycle and notification-tap routing.
///
/// Called from the auth lifecycle:
///   - [register] after a successful sign-in (and at boot when a session is
///     already present) — requests permission, registers the current token
///     with the backend, and starts listening for token rotation + taps.
///   - [unregister] at the *start* of sign-out, before the session is
///     cleared (the DELETE needs the access token).
///
/// Everything here is best-effort: when Firebase isn't configured the token
/// is null and each step no-ops, so the rest of the app is unaffected. The
/// foreground push → banner → inbox path lives in [NotificationIngestor]
/// (bridged off the repository's `incoming` stream); this class only adds
/// token registration and background/terminated tap handling. Tapped pushes
/// are routed to `data['route']` (RULINGS #15).
@Riverpod(keepAlive: true)
class PushRegistration extends _$PushRegistration {
  StreamSubscription<String>? _refreshSub;
  StreamSubscription<PushMessage>? _openedSub;

  @override
  void build() {
    // Ensure the foreground FCM → inbox/banner bridge is subscribed for the
    // whole app lifetime (it's keepAlive; reading materialises it).
    ref.read(notificationIngestorProvider);
    ref.onDispose(() {
      unawaited(_refreshSub?.cancel());
      unawaited(_openedSub?.cancel());
    });
  }

  Future<void> register() async {
    try {
      // Reading the provider materialises FirebaseMessaging.instance, which
      // itself throws when no Firebase app is configured — so it must sit
      // inside the guard, not above it (an escaping throw from this
      // best-effort path would otherwise be logged as a fatal crash).
      final push = ref.read(notificationsServiceProvider);
      await push.requestPermission();
      final token = await push.deviceToken();
      if (token != null && token.isNotEmpty) {
        await ref
            .read(notificationRepositoryProvider)
            .registerDevice(token, platform: _platform);
      }

      // Re-register whenever FCM rotates the token.
      _refreshSub ??= push.tokenRefreshes.listen((rotated) async {
        try {
          await ref
              .read(notificationRepositoryProvider)
              .registerDevice(rotated, platform: _platform);
        } on Object catch (error, stack) {
          _log.warn('FCM token re-registration failed',
              error: error, stackTrace: stack);
        }
      });

      // Tap on a push while backgrounded → open its deep link.
      _openedSub ??= push.openedMessages.listen(_openFromTap);

      // The push that cold-started the app (terminated → tap).
      final initial = await push.initialMessage();
      if (initial != null) _openFromTap(initial);
    } on Object catch (error, stack) {
      // No Firebase config, denied permission, or a network blip — push is
      // simply off for this session; the inbox still works.
      _log.warn('Push registration skipped', error: error, stackTrace: stack);
    }
  }

  Future<void> unregister() async {
    try {
      final push = ref.read(notificationsServiceProvider);
      final token = await push.deviceToken();
      if (token != null && token.isNotEmpty) {
        await ref.read(notificationRepositoryProvider).unregisterDevice(token);
      }
      // Drop the token locally too, so a signed-out device stops receiving
      // push even if the server-side unregister didn't land.
      await push.deleteToken();
    } on Object catch (error, stack) {
      _log.warn('Push unregistration failed', error: error, stackTrace: stack);
    } finally {
      await _refreshSub?.cancel();
      _refreshSub = null;
      await _openedSub?.cancel();
      _openedSub = null;
    }
  }

  /// Routes a tapped push to its deep link. Navigation goes through the
  /// GoRouter instance (this runs outside the widget tree); the router's auth
  /// redirect handles the not-yet-signed-in case. The tapped push is also a
  /// live event, so it flows through the ingestor to land in the inbox.
  void _openFromTap(PushMessage message) {
    unawaited(
      ref
          .read(notificationIngestorProvider.notifier)
          .ingest(ApiNotificationRepository.fromPush(message)),
    );
    final link = message.data['route'];
    if (link != null && link.isNotEmpty) {
      ref.read(appRouterProvider).push(link);
    }
  }

  AppLogger get _log => ref.read(appLoggerProvider);

  String get _platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
}
