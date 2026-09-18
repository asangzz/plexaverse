import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/interceptors/auth_signal.dart';
import '../security/secure_screen.dart';
import '../tenant/tenant_controller.dart';
import '../ui/pages/splash_page.dart';
import '../ui/pages/styleguide_page.dart';
import '../ui/widgets/app_scaffold.dart';
import 'auth_gate.dart';
import 'redirect.dart';
import 'route_paths.dart';

// Feature pages live at their feature-first manifest paths.
import '../../features/auth/application/app_lock_controller.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/unlock_page.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/videos/presentation/pages/videos_page.dart';
import '../../features/avatars/presentation/pages/avatars_page.dart';
import '../../features/timeline/presentation/pages/global_timeline_page.dart';
import '../../features/settings/presentation/pages/account_page.dart';

part 'app_router.g.dart';

/// Top-level router shape (§14).
///
///   /            — cold-start splash while the session + onboarding resolve
///   /onboarding  — first-run carousel (pre-auth gate)
///   /login       — auth entry point (dual-mode sign-in / create-account)
///   /unlock      — biometric re-auth gate for a locked signed-in session
///   /home        — post-auth landing, branch 0 of the three-tab shell
///   /styleguide  — design-system reference (public, dev aid)
///
/// `refreshListenable` re-runs the guard chain when any of:
///   - the tenant resolves / changes,
///   - the auth gate transitions (sign-in, sign-out, idle expiry),
///   - the app locks / unlocks (background-resume re-auth gate),
///   - onboarding is completed,
///   - the auth pipeline emits a forced sign-out (401 refresh failure).
///
/// Root navigator — full-screen routes (account) are parented here so they
/// cover the tab bar.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: false,
    refreshListenable: refresh,
    redirect: (context, state) => appRedirect(ref, state),
    routes: <RouteBase>[
      // Cold-start splash. No page-level navigation — the redirect owns it.
      GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashPage()),

      // First-run onboarding (pre-auth gate). Fade entrance preserved from the
      // legacy router.
      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingPage(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // Auth entry point. Wrapped in `SecureScreen` so screenshots / screen
      // recording are blocked on the sensitive sign-in / create-account
      // screen (the page itself stays plain + testable). Fade entrance
      // preserved from the legacy router.
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SecureScreen(child: AuthPage()),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // Biometric / device-credential unlock gate. Sensitive → SecureScreen,
      // like the sign-in screen. Shown over everything when a signed-in
      // session is locked.
      GoRoute(
        path: RoutePaths.unlock,
        builder: (_, _) => const SecureScreen(child: UnlockPage()),
      ),

      // The signed-in four-tab shell (HeyGen re-skin). Branch order is
      // canonical (Home 0 · Videos 1 · Avatars 2 · Timeline 3) and MUST match
      // the bottom navigation in AppScaffold. Tab switches use
      // NoTransitionPage (instant) — the shell owns any tab-switch animation.
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          // Branch 0 — Home.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.home,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          // Branch 1 — Videos.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.videos,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const VideosPage(),
                ),
              ),
            ],
          ),
          // Branch 2 — Avatars.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.avatars,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const AvatarsPage(),
                ),
              ),
            ],
          ),
          // Branch 3 — Global Timeline.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.timeline,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const GlobalTimelinePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes OUTSIDE the shell — no bottom nav. Parented to the
      // root navigator so they cover the tab bar. Account (screenshot 2374)
      // is opened from the Home header gear; horizontal-slide entrance.
      GoRoute(
        path: RoutePaths.account,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AccountPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Design-system style guide — public (see the exemption in
      // `redirect.dart`) so it opens without signing in.
      GoRoute(
        path: RoutePaths.styleguide,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const StyleguidePage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}

/// Bridges Riverpod state changes into go_router's `refreshListenable`, so any
/// auth / lock / tenant / onboarding transition re-runs the declarative guard
/// (never an imperative `go()`/`push()` from that code). Subscriptions are
/// collected as cancel callbacks and disposed via `ref.onDispose`.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    _subs.add(
      ref.listen(tenantControllerProvider, (_, _) => notifyListeners()).close,
    );
    _subs.add(ref.listen(authGateProvider, (_, _) => notifyListeners()).close);
    // Re-run the guard when the app locks/unlocks so the /unlock gate appears
    // on background-resume and clears on a successful unlock.
    _subs.add(ref.listen(appLockProvider, (_, _) => notifyListeners()).close);
    // Re-run when first-run onboarding is completed so the carousel gate
    // releases to the auth flow.
    _subs.add(
      ref
          .listen(onboardingControllerProvider, (_, _) => notifyListeners())
          .close,
    );
    // Forced sign-out from the network layer (401 refresh failure emits on
    // this broadcast stream) — turn it into a /login redirect.
    final sink = ref.read<AuthSignalSink>(authSignalSinkProvider);
    final signals = sink.stream.listen((_) => notifyListeners());
    _subs.add(signals.cancel);
  }

  final List<FutureOr<void> Function()> _subs = <FutureOr<void> Function()>[];

  @override
  void dispose() {
    for (final cancel in _subs) {
      cancel();
    }
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Page transitions — preserved from the legacy Plexaverse router.
// (ProHealth uses platform-default `builder:` transitions and animates only
// tab switches inside the shell; Plexaverse keeps its bespoke fade / slide
// entrances for onboarding, auth and the full-screen routes.)
// ---------------------------------------------------------------------------

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => FadeTransition(opacity: animation, child: child);

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => SlideTransition(
  position: animation.drive(
    Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)),
  ),
  child: child,
);
