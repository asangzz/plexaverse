import 'dart:async';

import 'package:expressive_m3/expressive_m3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import '../core/router/app_router.dart';
import '../core/security/privacy_mask_overlay.dart';
import '../core/sync/sync_engine.dart';
import '../core/tenant/tenant_config.dart';
import '../core/tenant/tenant_controller.dart';
import '../core/theme/zave/zave_theme.dart';
import '../core/ui/widgets/in_app_notification_overlay.dart';
import '../core/ui/widgets/offline_overlay.dart';
import '../l10n/gen/app_localizations.dart';

// The biometric app-lock lives in the auth feature slice (feature-auth.md):
// `AppLock` re-arms on background, `BiometricPrefs` records whether the user
// enabled it. These land with the auth migration agent — the import is
// expected-broken until then, exactly like `app_router.dart`'s feature-page
// imports (staged migration).
import '../features/auth/application/app_lock_controller.dart';
import '../features/auth/data/biometric_prefs.dart';

/// Root application widget.
///
/// A [ConsumerStatefulWidget] + [WidgetsBindingObserver] (ProHealth
/// `ProHealthApp` structure, Plexaverse brand values):
///
///   - **Lifecycle** — on `resumed` it drains the offline sync queue (so
///     returning from background flushes queued mutations without waiting for
///     a connectivity blip); on `paused` it re-arms the biometric app lock
///     when the user enabled it (the privacy mask hides content in the
///     app-switcher meanwhile).
///   - **Metrics** — `didChangeMetrics` rebuilds the theme on a true window
///     size change only (guarded against keyboard-inset churn) so the
///     responsive `.sp` / `.r` scaling tracks rotation / resize / foldable.
///   - **Theme** — the FIVE Plexaverse modes, **dark default** (RULINGS —
///     product identity). Base light/dark are supplied to `theme`/`darkTheme`
///     with dark forced via `themeMode`; the OS "increase contrast" setting
///     swaps in the WCAG-AAA high-contrast pair via `highContrastTheme` /
///     `highContrastDarkTheme`. The persisted user theme-mode + locale
///     switcher is owned by the settings feature slice — see the TODO seam in
///     `build`.
///   - **l10n** — en / es / fr delegates from the generated [AppL10n].
///   - **Overlays** — `MaterialApp.builder` mounts, outermost-first:
///     `MotionSchemeScope` (app-wide M3 Expressive spring matrix) >
///     `PrivacyMaskOverlay` (task-switcher cover) > `OfflineOverlay` (offline
///     pill, keeps the InternetMonitor alive from the first frame) >
///     `InAppNotificationOverlay` (foreground FCM banner). All sit above the
///     navigator and so navigate via the router, never `Navigator.of`.
class PlexaverseApp extends ConsumerStatefulWidget {
  const PlexaverseApp({super.key});

  @override
  ConsumerState<PlexaverseApp> createState() => _PlexaverseAppState();
}

class _PlexaverseAppState extends ConsumerState<PlexaverseApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // §7.3 "App foreground while online — drain queue from oldest, in order."
    // Without this hook, returning from background relied on a connectivity
    // blip to re-trigger the engine.
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(syncEngineProvider).drainNow());
    } else if (state == AppLifecycleState.paused) {
      // Re-arm the biometric lock when leaving the foreground so returning
      // requires re-authentication — only when the user enabled app lock. The
      // privacy mask already hides content in the app switcher meanwhile.
      unawaited(_armLockIfEnabled());
    }
  }

  Future<void> _armLockIfEnabled() async {
    final enabled = await ref.read(biometricPrefsProvider).isEnabled();
    if (enabled) ref.read(appLockProvider.notifier).lock();
  }

  Size? _lastWindowSize;

  @override
  void didChangeMetrics() {
    // The theme is built from the live screen size (responsive `.sp` / `.r` /
    // `.w` scaling in AppTheme). Rebuild so it re-resolves on rotation /
    // resize / foldable posture. `ScreenUtilInit` sits above this widget and
    // reconfigures `ScreenUtil` first (shallower elements rebuild first), so
    // `AppTheme` reads fresh scale factors here.
    //
    // Guard on the window size so inset-only changes (the keyboard opening)
    // don't churn the whole theme — only true size changes matter to the
    // scale factors.
    final size = View.maybeOf(context)?.physicalSize;
    if (size == null || size == _lastWindowSize) return;
    _lastWindowSize = size;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    // Keep the AppLogger tenant context in sync via `ref.listen` (never a
    // synchronous mutation during build() — that trips Riverpod's
    // modify-during-build assertion). The env-derived API base URL is wired
    // once in `bootstrap.dart`, so it isn't touched here.
    ref.listen<TenantConfig?>(
      tenantControllerProvider,
      (_, next) => _syncTenantWiring(next),
    );

    return MaterialApp.router(
      // Static string (the OS task-switcher label). `AppL10n.appName` is an
      // instance getter that needs a BuildContext with localizations in
      // scope, which isn't available at MaterialApp construction — the brand
      // name is locale-invariant here, matching ProHealth's literal title.
      title: 'Plexaverse',
      debugShowCheckedModeBanner: false,
      // FIVE modes, dark default (RULINGS — product identity). The base pair
      // is light/dark; `themeMode: dark` makes dark the identity. When the OS
      // "increase contrast" accessibility setting is on, Flutter substitutes
      // the WCAG-AAA high-contrast pair automatically.
      //
      // TODO(settings): the persisted user theme-mode switcher (the full
      // 5-mode `AppThemeMode` picker incl. explicit high-contrast selection)
      // and the persisted locale live in the settings feature slice
      // (lib/features/settings/…, per the shared manifest). When that slice
      // lands, watch its theme-mode + locale providers here and drive
      // `themeMode` / `locale` from them; until then dark is forced and the
      // system locale (within supportedLocales) is used.
      // Zave is dark-only, because the web app is. There is no light surface
      // to align to, so every slot gets the same theme and themeMode is
      // pinned — an OS light/contrast setting must not invent an appearance
      // the web does not have. (The pre-alignment app shipped five modes,
      // inherited from the skin it was cloned from; dropping them is part of
      // the alignment.)
      theme: ZaveTheme.dark,
      darkTheme: ZaveTheme.dark,
      highContrastTheme: ZaveTheme.dark,
      highContrastDarkTheme: ZaveTheme.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      // Online-first: the offline strip mounts above the navigator so it
      // overlays every route and keeps the InternetMonitor alive from the
      // first frame. The in-app notification banner mounts alongside it
      // (foreground FCM pushes → banner + inbox) — both sit above the
      // navigator and so navigate via the router, not Navigator.of. The
      // privacy mask is outermost so it covers the offline pill + banner too
      // when the app leaves the foreground. MotionSchemeScope pins the
      // app-wide M3 Expressive spring matrix — entrances (FadeSlideIn) and
      // press responses (SpringPress) read it.
      builder: (context, child) => MotionSchemeScope(
        scheme: ExpressiveSpringScheme.expressive,
        child: PrivacyMaskOverlay(
          child: OfflineOverlay(
            // Tapping a foreground banner opens its deep link via the router
            // (RULINGS #15 tap-to-navigate). The overlay sits above the
            // navigator, so it routes through the GoRouter instance rather
            // than `Navigator.of`.
            child: InAppNotificationOverlay(
              onOpen: (route) => router.push(route),
              child: child,
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }

  /// Keep the AppLogger context in sync with the current tenant. Invoked from
  /// `ref.listen` so the mutation lands after the build phase.
  void _syncTenantWiring(TenantConfig? tenant) {
    if (tenant == null) return;
    ref.read<AppLogger>(appLoggerProvider).setContext(tenantKey: tenant.key);
  }
}
