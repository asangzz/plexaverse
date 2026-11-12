import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/placement/data/placement_repositories.dart';
import 'package:plexaverse/features/placement/presentation/pages/placement_page.dart';

/// The placement page as the app reaches it: pushed over the contest, with
/// the lesson one route away. The router file is not this slice's, so the
/// routes are stood up here.
Future<GoRouter> pumpPlacement(
  WidgetTester tester,
  FakePlacementRepository repo, {
  Size size = const Size(375, 667),
  Widget underneath = const Scaffold(body: Text('CONTEST')),
  bool open = true,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final GoRouter router = GoRouter(
    initialLocation: ZaveRoutes.contest,
    routes: <RouteBase>[
      GoRoute(path: ZaveRoutes.contest, builder: (_, _) => underneath),
      GoRoute(
        path: ZaveRoutes.placement,
        builder: (_, _) => const PlacementPage(),
      ),
      GoRoute(
        path: ZaveRoutes.contestLesson,
        builder: (_, _) => const Scaffold(body: Text('LESSON')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        placementRepositoryProvider.overrideWithValue(repo),
      ],
      // As the app's container: a failed read stays failed.
      retry: (int retryCount, Object error) => null,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  if (open) router.push(ZaveRoutes.placement);
  await settle(tester);
  return router;
}

/// The fake answers with no delay here, but every answer still crosses a few
/// frames (a future, a rebuild, a moment's still image). Pumped in steps
/// rather than settled: a busy button spins, and a spinner never settles.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 30));
  }
}

/// Scroll it to the middle of the screen, then tap it. The middle, not the
/// edge: the page's header is glass over the scroll view, and a row scrolled
/// to the top edge sits under it, where a tap lands on the header.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

/// Pick the question's first option: the row whose number is "1". The tap
/// lands on the number, inside the row, which takes it.
Future<void> pickFirstOption(WidgetTester tester) =>
    tapVisible(tester, find.text('1'));

/// Every string on screen.
String allText(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

/// A fake with no delay, so a test reads as the steps a learner takes.
FakePlacementRepository instantFake({
  FakePlacementSeed seed = FakePlacementSeed.fresh,
}) => FakePlacementRepository(seed: seed, latency: Duration.zero);
