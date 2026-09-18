import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/interceptors/auth_signal.dart';
import '../security/secure_screen.dart';
import '../tenant/tenant_controller.dart';
import '../ui/pages/splash_page.dart';
import '../ui/pages/zave_styleguide_page.dart';
import '../ui/zave/zave_shell_host.dart';
import 'auth_gate.dart';
import 'redirect.dart';
import 'route_paths.dart';
import 'zave_routes.dart';

import '../../features/auth/application/app_lock_controller.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/unlock_page.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/calendar/presentation/pages/schedules_page.dart';
import '../../features/compose/presentation/pages/compose_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/pages/onboarding_chat_page.dart';
import '../../features/persona/presentation/pages/persona_page.dart';
import '../../features/planner/presentation/pages/planner_page.dart';
import '../../features/posts/presentation/pages/post_detail_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/settings/presentation/pages/accounts_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

/// The app's route tree.
///
/// **Paths are the web app's paths, byte for byte** (see [ZaveRoutes]). A deep
/// link, a push payload or a support instruction resolves to the same screen on
/// both platforms, and a route that exists on one side and not the other shows
/// up as a missing constant rather than as silent drift.
///
/// Shape:
///
///   /            — cold-start splash while session + onboarding resolve
///   /onboarding  — the Plexa Setup chat (pre-dashboard gate)
///   /login       — auth entry point (sign-in / create-account in one screen)
///   /unlock      — biometric re-auth for a locked signed-in session
///   /styleguide  — the Zave reference (public)
///
///   ── the signed-in shell (bottom bar) ──
///   /dashboard   — Season 1 roadmap or Season 2 dashboard
///   /planner     — the week
///   /calendar    — the month
///   /posts       — the library
///
///   ── pushed over the shell (no bottom bar) ──
///   /create · /company-post · /posts/:id · /schedules · /persona ·
///   /settings · /accounts
///
/// The four shell branches match [tabRoutes]; the bottom bar is built from the
/// same list, so the bar and the router cannot disagree.
///
/// `refreshListenable` re-runs the guard whenever the tenant, auth gate, app
/// lock or onboarding state changes, or the network layer forces a sign-out.

/// Root navigator — routes parented here cover the bottom bar.
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
      GoRoute(path: ZaveRoutes.splash, builder: (_, _) => const SplashPage()),

      // The onboarding chat. Held ahead of the dashboard until completed.
      GoRoute(
        path: ZaveRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingChatPage(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // Auth. Wrapped in SecureScreen so screenshots / screen recording are
      // blocked on the sign-in screen; the page itself stays plain + testable.
      GoRoute(
        path: ZaveRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SecureScreen(child: AuthPage()),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // Biometric / device-credential unlock gate. Sensitive → SecureScreen.
      GoRoute(
        path: ZaveRoutes.unlock,
        builder: (_, _) => const SecureScreen(child: UnlockPage()),
      ),

      // ── The signed-in shell ───────────────────────────────────────────────
      // Branch order is canonical and MUST match `tabRoutes`; ZaveShellHost
      // indexes into that list to name the current route. Tab switches use
      // NoTransitionPage — the shell owns any tab-switch animation.
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            ZaveShellHost(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: ZaveRoutes.dashboard,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: ZaveRoutes.planner,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const PlannerPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: ZaveRoutes.calendar,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const CalendarPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: ZaveRoutes.posts,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const PostsPage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen routes, parented to the root navigator so they cover
      // the bottom bar. Horizontal-slide entrance.
      // Compose. Two paths, one widget: it derives company mode from
      // preferences, mirroring the web's two nav items both labelled "Write".
      _fullScreen(ZaveRoutes.create, const ComposePage()),
      _fullScreen(ZaveRoutes.companyPost, const ComposePage()),
      _fullScreen(ZaveRoutes.schedules, const SchedulesPage()),
      _fullScreen(ZaveRoutes.persona, const PersonaPage()),
      _fullScreen(ZaveRoutes.settings, const SettingsPage()),
      _fullScreen(ZaveRoutes.accounts, const AccountsPage()),

      // A single post. Mirrors the web's /posts/[id].
      GoRoute(
        path: '${ZaveRoutes.posts}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: PostDetailPage(postId: state.pathParameters['id']!),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // The Zave design-system reference. Public (exempted in redirect.dart).
      _fullScreen(ZaveRoutes.styleguide, const ZaveStyleguidePage()),
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

/// A full-screen route: parented to the root navigator so it covers the bottom
/// bar, with the horizontal-slide entrance the app uses for pushed screens.
GoRoute _fullScreen(String path, Widget child) => GoRoute(
  path: path,
  parentNavigatorKey: _rootNavigatorKey,
  pageBuilder: (context, state) => CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: _slideTransition,
  ),
);
