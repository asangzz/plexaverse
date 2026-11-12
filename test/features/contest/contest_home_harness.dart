import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_page.dart';

/// Every place the contest page can send the learner, stood up as a page
/// that says where it is — the router file is not this slice's.
const List<String> kContestDestinations = <String>[
  ZaveRoutes.contestLesson,
  ZaveRoutes.contestComment,
  ZaveRoutes.contestFeedComments,
  ZaveRoutes.contestInvites,
  ZaveRoutes.contestPlan,
  ZaveRoutes.contestClaim,
  ZaveRoutes.connections,
  ZaveRoutes.roadmap,
  ZaveRoutes.pricing,
  ZaveRoutes.placement,
];

/// A router whose `/` is [home], with every contest destination beside it.
GoRouter contestRouter(Widget home) => GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (_, _) => home),
    for (final String path in kContestDestinations)
      GoRoute(
        path: path,
        builder: (_, GoRouterState s) =>
            Scaffold(body: Center(child: Text('AT ${s.uri}'))),
      ),
  ],
);

/// The contest page at a phone's width, against the mock flavor's fakes —
/// the contest's for [scenario], or [repo] when a test needs to see what was
/// sent.
Future<GoRouter> pumpContestPage(
  WidgetTester tester, {
  FakeContestScenario scenario = FakeContestScenario.running,
  ContestRepository? repo,
  List<Override> overrides = const <Override>[],
  Size size = const Size(375, 667),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final GoRouter router = contestRouter(const ContestPage());
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        // Every other slice the page touches (the placement hint) on its fake.
        envProvider.overrideWithValue(Env.mock),
        contestRepositoryProvider.overrideWithValue(
          repo ??
              FakeContestRepository(scenario: scenario, latency: Duration.zero),
        ),
        ...overrides,
      ],
      // As the app's container: a failed read stays failed.
      retry: (int retryCount, Object error) => null,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await settle(tester);
  return router;
}

/// Pumped in steps rather than settled: a skeleton's shimmer and a busy
/// pill never settle, and the frames in between are where an overflow
/// lives — so each step also asserts nothing threw.
Future<void> settle(WidgetTester tester, {int steps = 12}) async {
  for (int i = 0; i < steps; i++) {
    await tester.pump(const Duration(milliseconds: 60));
    final Object? error = tester.takeException();
    expect(
      error,
      isNull,
      reason:
          'threw while settling:\n'
          '${error is FlutterError ? error.toStringDeep() : error}',
    );
  }
}

/// Bring [finder] to the middle of the screen, then tap it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

/// Every string on screen, scrolled into view or not.
List<String> allText(WidgetTester tester) => <String>[
  for (final Text t in tester.widgetList<Text>(find.byType(Text)))
    t.data ?? t.textSpan?.toPlainText() ?? '',
  for (final RichText t in tester.widgetList<RichText>(find.byType(RichText)))
    t.text.toPlainText(),
];

/// Where the router is now — the top-most route, pushed or gone to.
Uri locationOf(GoRouter router) => router.state.uri;
