import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/app_router.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/auth/application/app_lock_controller.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_claim_page.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_lesson_page.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_page.dart';
import 'package:plexaverse/features/engagement/presentation/pages/connections_page.dart';
import 'package:plexaverse/features/home/presentation/pages/home_page.dart';
import 'package:plexaverse/features/onboarding/application/onboarding_controller.dart';
import 'package:plexaverse/features/placement/presentation/pages/placement_page.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';
import 'package:plexaverse/l10n/gen/app_localizations.dart';

/// The contest's addresses land on the contest's screens.
///
/// ## Why the real router, resolved
///
/// A path is a string: the analyzer is happy with one nothing registers, and
/// every widget test pumps its page directly rather than through the router.
/// The lesson reminder's notification carries `/contest/lesson` as its route
/// and the in-app banner hands it straight to `router.push` — so a lesson
/// page that was built and never registered is a reminder that opens "Page
/// not found", every evening, and the suite stays green.
///
/// So each address is run through the app's own router — its guard first,
/// then the route's own redirect, then the match — for a signed-in, set-up,
/// unlocked user, and the page at the end is checked by type.
///
/// ## The old addresses
///
/// `/dashboard`, `/learn` and `/contest/quiz` are only redirects now, as on
/// the web, and stored notifications and sent emails still name all three.
/// Where they go is pinned here; that `/learn` may exist only as a redirect is
/// `no_learn_route_test`'s.
void main() {
  late GoRouter router;

  setUp(() async {
    final ProviderContainer container = ProviderContainer(
      overrides: _signedInAndSetUp(),
    );
    addTearDown(container.dispose);
    router = container.read(appRouterProvider);

    // The guard holds every address on the splash until these resolve.
    await container.read(authGateProvider.future);
    await container.read(appLockProvider.future);
    await container.read(onboardingControllerProvider.future);
    await container.read(preferencesControllerProvider.future);
  });

  /// Where [location] ends up after the guard and every route redirect.
  RouteMatchList resolve(String location) {
    final RouteConfiguration config = router.configuration;
    return config.redirect(
          _NoContext(),
          config.findMatch(Uri.parse(location)),
          redirectHistory: <RouteMatchList>[],
        )
        as RouteMatchList;
  }

  /// The page the resolved route builds.
  Widget pageAt(String location) {
    final RouteMatchList matches = resolve(location);
    expect(
      matches.isError,
      isFalse,
      reason: '$location is "Page not found": ${matches.error}',
    );
    final RouteMatch leaf = matches.last;
    final GoRoute route = leaf.route;
    final GoRouterState state = leaf.buildState(router.configuration, matches);
    final Page<Object?> page = route.pageBuilder!(_NoContext(), state);
    return switch (page) {
      final CupertinoPage<Object?> p => p.child,
      final NoTransitionPage<Object?> p => p.child,
      _ => throw StateError('$location builds a ${page.runtimeType}'),
    };
  }

  test("the lesson reminder's link opens the lesson", () {
    // The `lesson_reminder` task's route, pushed as the banner pushes it.
    expect(pageAt(ZaveRoutes.contestLesson), isA<ContestLessonPage>());
  });

  group('the old addresses', () {
    test('/dashboard is the contest, the home since 11 Nov 2026', () {
      expect(resolve(ZaveRoutes.dashboard).uri.path, ZaveRoutes.contest);
      expect(pageAt(ZaveRoutes.dashboard), isA<ContestPage>());
    });

    test('/learn is the contest, where the lesson went', () {
      expect(resolve('/learn').uri.path, ZaveRoutes.contest);
    });

    test('/contest/quiz is the lesson it grew into', () {
      expect(
        resolve(ZaveRoutes.contestQuiz).uri.path,
        ZaveRoutes.contestLesson,
      );
      expect(pageAt(ZaveRoutes.contestQuiz), isA<ContestLessonPage>());
    });
  });

  test('the roadmap is the journey screen that used to be home', () {
    expect(pageAt(ZaveRoutes.roadmap), isA<HomePage>());
  });

  test('every level the path can open has a page', () {
    // contestLevelRoute dispatches on the node's kind, never its href — so
    // what has to be registered is exactly what it returns, kind by kind.
    for (final PathNodeKind kind in PathNodeKind.values) {
      if (kind == PathNodeKind.unknown) continue;
      final PathNode node = PathNode(
        id: 'probe',
        kind: kind,
        state: PathNodeState.today,
        href: '/the-web-path',
        claim: kind.isClaim
            ? NodeClaim(
                kind: kind == PathNodeKind.article
                    ? ClaimKind.article
                    : ClaimKind.video,
                occurrence: '6:1:2',
              )
            : null,
      );
      final String? route = contestLevelRoute(node);
      expect(route, isNotNull, reason: '$kind opens nothing');
      pageAt(route!);
    }
  });

  test('the claim level reads which piece from the query', () {
    final Widget page = pageAt(contestClaimRoute(ClaimKind.video, '6:1:2')!);
    expect(page, isA<ContestClaimPage>());
    page as ContestClaimPage;
    expect(page.kind, 'video');
    expect(
      page.occurrence,
      '6:1:2',
      reason: 'the occurrence is opaque and must come back as it went',
    );
  });

  test('connect opens the sprint in contest mode, and only from the path', () {
    final Widget contest = pageAt('${ZaveRoutes.connections}?from=contest');
    expect((contest as ConnectionsPage).fromContest, isTrue);

    final Widget roadmap = pageAt(ZaveRoutes.connections);
    expect((roadmap as ConnectionsPage).fromContest, isFalse);
  });

  test('the placement test, which the join card and the lesson open', () {
    expect(pageAt(ZaveRoutes.placement), isA<PlacementPage>());
  });

  testWidgets(
    'a launch opens on the contest, and the reminder pushes over it',
    (WidgetTester tester) async {
      // The same router, mounted: the splash forwards to home, the shell builds
      // all five branches, and the banner's `router.push` lands the lesson on
      // top — the whole road a reminder tap travels, on the mock's fakes.
      tester.view.physicalSize = const Size(402, 874) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      Future<void> settle() async {
        // The fakes answer after a delay, and the moments never settle.
        for (int i = 0; i < 12; i++) {
          await tester.pump(const Duration(milliseconds: 120));
          expect(tester.takeException(), isNull);
        }
      }

      // Its own scope, as the app has: unmounting it disposes every provider
      // the five branches started, polling timers included.
      late GoRouter mounted;
      await tester.pumpWidget(
        ProviderScope(
          overrides: _signedInAndSetUp(),
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, _) =>
                MaterialApp.router(
                  // The splash reads its copy from these before anything
                  // else, as the app's own MaterialApp provides.
                  localizationsDelegates: AppL10n.localizationsDelegates,
                  supportedLocales: AppL10n.supportedLocales,
                  routerConfig: mounted = ref.watch(appRouterProvider),
                ),
          ),
        ),
      );
      await settle();
      expect(
        mounted.routerDelegate.currentConfiguration.uri.path,
        ZaveRoutes.contest,
      );
      expect(find.byType(ContestPage), findsOneWidget);

      unawaited(mounted.push(ZaveRoutes.contestLesson));
      await settle();
      expect(find.byType(ContestLessonPage), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await settle();
    },
  );
}

/// A signed-in, set-up, unlocked user on the mock's fakes — everything the
/// guard waits for before it lets anyone past the splash.
List<Override> _signedInAndSetUp() => <Override>[
  envProvider.overrideWithValue(Env.mock),
  authGateProvider.overrideWith(
    (Ref ref) async => const AuthGate(signedIn: true),
  ),
  appLockProvider.overrideWith(_Unlocked.new),
  onboardingControllerProvider.overrideWith(_SetUp.new),
];

/// The redirects and page builders under test take a context and read
/// nothing from it.
class _NoContext extends Fake implements BuildContext {}

class _Unlocked extends AppLock {
  @override
  Future<bool> build() async => false;
}

class _SetUp extends OnboardingController {
  @override
  Future<bool> build() async => true;
}
