import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics.g.dart';

/// Whether `Firebase.initializeApp()` succeeded this session. Overridden in
/// `bootstrap()` with the bool returned by `initFirebase()`.
///
/// Defaults to false (instead of throwing like `envProvider`) because
/// analytics is fail-soft by design: a missed override, a test container, or
/// a fresh checkout without `flutterfire configure` should silently disable
/// analytics, never crash.
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) => false;

/// Product-analytics adapter (deliberate Plexaverse addition — the reference
/// architecture ships without analytics). Feature code depends on this
/// abstraction only; `firebase_analytics` types never leak past this file.
///
/// Every call is a no-op unless `firebaseReady && !kDebugMode`:
///   - firebaseReady — Firebase may legitimately be absent (fresh checkout
///     before `flutterfire configure`); touching `FirebaseAnalytics.instance`
///     then would throw.
///   - !kDebugMode — debug sessions must not pollute product metrics.
abstract class Analytics {
  /// Logs a custom event. [name] must follow Firebase rules (≤40 chars,
  /// alphanumeric + underscores, starting with a letter); parameter values
  /// must be String or num.
  void logEvent(String name, {Map<String, Object>? parameters});

  /// Logs a screen view. Call from router/navigation observers, not from
  /// individual pages, so coverage stays complete and uniform.
  void logScreenView(String screenName);

  /// Associates events with the signed-in user. Pass null on sign-out so
  /// the next session doesn't inherit the previous user's identity.
  void setUserId(String? userId);

  /// Applies the collection-enabled flag on the Firebase side. Called once
  /// from `bootstrap()` (fire-and-forget); safe to skip — events are gated
  /// client-side regardless.
  Future<void> start();
}

class FirebaseAnalyticsAdapter implements Analytics {
  FirebaseAnalyticsAdapter({
    required bool firebaseReady,
    FirebaseAnalytics? analytics,
  })  : _firebaseReady = firebaseReady,
        _injected = analytics;

  final bool _firebaseReady;

  /// Test seam. Left null in production and resolved lazily — reading
  /// `FirebaseAnalytics.instance` eagerly would throw when Firebase never
  /// initialised, which is exactly the case the gate exists for.
  final FirebaseAnalytics? _injected;

  bool get _enabled => _firebaseReady && !kDebugMode;

  FirebaseAnalytics get _analytics => _injected ?? FirebaseAnalytics.instance;

  @override
  void logEvent(String name, {Map<String, Object>? parameters}) {
    if (!_enabled) return;
    _guard(() => _analytics.logEvent(name: name, parameters: parameters));
  }

  @override
  void logScreenView(String screenName) {
    if (!_enabled) return;
    _guard(() => _analytics.logScreenView(screenName: screenName));
  }

  @override
  void setUserId(String? userId) {
    if (!_enabled) return;
    _guard(() => _analytics.setUserId(id: userId));
  }

  @override
  Future<void> start() async {
    // setAnalyticsCollectionEnabled(false) also tells the SDK to drop any
    // locally buffered events, so it runs for BOTH branches of the gate —
    // but only when Firebase actually initialised.
    if (!_firebaseReady) return;
    try {
      await _analytics.setAnalyticsCollectionEnabled(_enabled);
    } on Object catch (error) {
      debugPrint('Analytics.start failed: $error');
    }
  }

  /// Analytics must never crash the app — plugin calls are best-effort and
  /// failures are debug-visible only (logging them via Crashlytics would be
  /// circular noise for a non-essential subsystem).
  void _guard(Future<void> Function() call) {
    try {
      call().catchError((Object error) {
        debugPrint('Analytics call failed: $error');
      });
    } on Object catch (error) {
      debugPrint('Analytics call failed: $error');
    }
  }
}

@Riverpod(keepAlive: true)
Analytics analytics(Ref ref) {
  return FirebaseAnalyticsAdapter(
    firebaseReady: ref.watch(firebaseReadyProvider),
  );
}
