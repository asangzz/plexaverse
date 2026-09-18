import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap/error_handlers.dart';
import 'bootstrap/firebase_init.dart';
import 'bootstrap/plexaverse_app.dart';
import 'bootstrap/release_guards.dart';
import 'core/config/env.dart';
import 'core/logging/app_logger.dart';
import 'core/platform/notifications_service.dart';
import 'core/responsive/screen_util_init.dart';
import 'core/security/jailbreak_detector.dart';
import 'core/storage/media_cache_sweeper.dart';
import 'core/storage/session_store.dart';
import 'core/sync/sync_engine.dart';
import 'core/tenant/catalogue.dart';
import 'core/tenant/tenant_controller.dart';
import 'features/notifications/application/push_registration.dart';

/// Single boot path for every flavor. Each `main_<flavor>.dart` is a one-liner
/// `Future<void> main() => bootstrap(env: Env.<flavor>);` — the flavor selects
/// the API base URL and the fake/real repository split; all real logic lives
/// here (bootstrap-flavors.md).
///
/// Boot order:
///   1. Flutter init
///   2. Firebase + Crashlytics init (best-effort; see `initFirebase`), then
///      register the FCM background-message handler in the main isolate
///   3. Build the root ProviderContainer (env override + Riverpod retry off)
///   4. Build the logger and ATTACH the top-level error handlers
///      (RULINGS ruling 2 — the ProHealth wiring gap, fixed here)
///   5. Validate tenant catalogue (debug) + release config (prod-only)
///   6. Hydrate the tenant controller from SharedPreferences (single-tenant:
///      seed the default key when none is stored)
///   7. Start the sync engine (drains any leftover offline mutations)
///   8. Boot the RASP listener (non-blocking)
///   9. Fire-and-forget MediaCache sweep (§7.7)
///  10. runApp inside the responsive ScreenUtilInit frame (360 x 760)
///
/// The whole app runs inside `runZonedGuarded` so any error that escapes the
/// framework funnel still reaches Crashlytics in release.
Future<void> bootstrap({required Env env}) async {
  await runZonedGuarded<Future<void>>(() => _startApp(env), _onZoneError);
}

Future<void> _startApp(Env env) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase + Crashlytics, best-effort (see `initFirebase`). The FCM
  // background-message handler is registered only when init succeeds, and
  // must be wired in the main isolate before `runApp`.
  final firebaseReady = await initFirebase();
  if (firebaseReady) registerBackgroundMessageHandler();

  final container = _buildContainer(env);
  final logger = container.read(appLoggerProvider);

  // ProHealth defines `attachErrorHandlers` but never calls it (documented
  // wiring gap). Fix it here (RULINGS ruling 2): route FlutterError.onError
  // and PlatformDispatcher.onError through the PII-scrubbing logger, with
  // Crashlytics forwarding gated on `firebaseReady`, now that both the logger
  // and the firebaseReady flag exist.
  attachErrorHandlers(logger: logger, firebaseReady: firebaseReady);

  _runStartupAsserts(env, logger);
  await _hydrateTenant(container, logger);

  // RASP sweep — non-blocking (catches its own failure inside `start`).
  //
  // Dev escape hatch: `--dart-define=DISABLE_RASP=true` skips booting the
  // Talsec runtime entirely. Emulators are routinely flagged as
  // privileged/rooted, which makes `JailbreakDetector.isCompromised()` return
  // true and blocks login — so this lets you develop against an emulator
  // without the RASP gate. Defaults to OFF (RASP enabled); never weakens a
  // release build unless the flag is explicitly compiled in. Drop the flag to
  // restore normal behaviour — nothing to revert in source.
  const disableRasp = bool.fromEnvironment('DISABLE_RASP');
  if (disableRasp) {
    logger.warn(
      'RASP disabled via --dart-define=DISABLE_RASP — DEV ONLY, do not ship.',
    );
  } else {
    unawaited(container.read(jailbreakDetectorProvider).start());
  }
  // Disk cleanup — fire-and-forget with its own try/catch so a provider-init
  // failure doesn't surface as an unhandled zone error.
  unawaited(_runMediaCacheSweep(container));

  // Push registration — fire-and-forget, gated on Firebase being ready and a
  // restored session (auto-login). `register()` is itself best-effort (a null
  // FCM token or missing config no-ops), but we skip it entirely when signed
  // out so a signed-out device never registers. The FCM background handler is
  // already wired above; foreground pushes surface via the in-app overlay,
  // bridged by NotificationIngestor (materialised inside PushRegistration).
  if (firebaseReady) unawaited(_registerPushIfSignedIn(container));

  runApp(
    UncontrolledProviderScope(
      container: container,
      // Responsive scaler: the reference phone frame is the Plexaverse hi-fi
      // design's 360 x 760. Everything below resolves `.w` / `.h` / `.r` /
      // `.sp` against the live device size.
      child: const ScreenUtilInit(
        designSize: Size(360, 760),
        child: PlexaverseApp(),
      ),
    ),
  );
}

/// Registers this device for push when a session was restored at boot. Skips
/// the whole path when signed out so a signed-out device never registers.
/// Best-effort — swallows its own failures (a flaky network or absent Firebase
/// config must never block boot).
Future<void> _registerPushIfSignedIn(ProviderContainer container) async {
  try {
    final token = await container.read(sessionStoreProvider).activeAccessToken();
    if (token == null || token.isEmpty) return;
    await container.read(pushRegistrationProvider.notifier).register();
  } on Object catch (error, stack) {
    container.read(appLoggerProvider).warn(
          'Push registration at boot failed',
          error: error,
          stackTrace: stack,
        );
  }
}

Future<void> _runMediaCacheSweep(ProviderContainer container) async {
  // Disk cleanup runs in the background; both the provider materialisation
  // (MediaCache.create → secure storage + path_provider) and the sweep pass
  // can fail independently. Catching here covers the provider-init path that
  // `MediaCacheSweeper.sweep`'s own try/catch can't reach — without it any
  // failure surfaces as an unhandled zone error.
  try {
    final sweeper = await container.read(mediaCacheSweeperProvider.future);
    await sweeper.sweep();
  } on Object catch (error, stack) {
    container.read(appLoggerProvider).warn(
          'Media cache sweep failed at boot',
          error: error,
          stackTrace: stack,
        );
  }
}

ProviderContainer _buildContainer(Env env) {
  return ProviderContainer(
    overrides: [envProvider.overrideWithValue(env)],
    // Riverpod 3 auto-retries failed providers with backoff, which keeps an
    // errored AsyncValue flapping back to loading — so the designed error
    // states (retry surfaces) would never show, just an endless skeleton. The
    // app owns its retry story instead: the offline gate fast-fails,
    // InternetMonitor re-probes/auto-reloads on recovery, and every error
    // surface has an explicit "Try again".
    retry: (retryCount, error) => null,
  );
}

void _runStartupAsserts(Env env, AppLogger logger) {
  assert(() {
    assertTenantCatalogueComplete();
    return true;
  }());
  assertReleaseConfigSane(env, logger);
}

Future<void> _hydrateTenant(
  ProviderContainer container,
  AppLogger logger,
) async {
  final controller = container.read(tenantControllerProvider.notifier);
  await controller.restore();
  // Single-tenant boilerplate: if nothing was persisted, auto-select the
  // Plexaverse tenant so the app resolves a tenant immediately and the router
  // needs no tenant-selection screen (RULINGS §11).
  if (container.read(tenantControllerProvider) == null) {
    await controller.setKey(TenantCatalogue.defaultKey);
  }
  final tenant = container.read(tenantControllerProvider);
  if (tenant == null) return;
  logger.setContext(tenantKey: tenant.key);

  // NOTE (deviation from ProHealth): ProHealth pushes the env-derived base
  // URL into a `RefreshBaseUrl` notifier here to break a tenant→dio→auth→
  // tenant cycle. Plexaverse is single-brand with an env-derived base URL and
  // no such cycle, so the refresh Dio reads `apiBaseUrlProvider` directly
  // (see core/network/interceptors/refresh_dio.dart) — no wiring needed.

  // Drain any mutations left over from a previous session before the user
  // opens the first feature screen. With no tokens yet, the dispatcher
  // handlers skip and the engine spins down.
  unawaited(container.read(syncEngineProvider).start());
}

void _onZoneError(Object error, StackTrace stack) {
  debugPrint('Unhandled zone error: $error\n$stack');
  if (kDebugMode) return;
  try {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  } on Object {
    // Crashlytics may not have initialised — this guard only runs when every
    // other handler has already missed the error.
  }
}
