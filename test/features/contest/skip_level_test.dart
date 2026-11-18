import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';
import 'package:plexaverse/features/contest/presentation/widgets/skip_level.dart';

/// Skip on a level's own page — the web's `SkipLevel`, held to it: shown only
/// on the level the server marks `canSkip`, a ghost pill with the note under
/// it, and after a skip on to the next open level.
void main() {
  setUp(FakeContestWorld.reset);

  Future<void> pump(WidgetTester tester, PathNodeKind kind) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final GoRouter router = GoRouter(
      initialLocation: '/level',
      routes: <RouteBase>[
        GoRoute(
          path: '/level',
          builder: (_, _) => Scaffold(body: ContestSkipLevel(kind: kind)),
        ),
        GoRoute(
          path: ZaveRoutes.contest,
          builder: (_, _) => const Scaffold(body: Text('THE PATH')),
        ),
        GoRoute(
          path: ZaveRoutes.contestFeedComments,
          builder: (_, _) => const Scaffold(body: Text('THE FEED')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          contestRepositoryProvider.overrideWithValue(
            FakeContestRepository(latency: Duration.zero),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
  }

  testWidgets('a level behind the open one has no Skip', (
    WidgetTester tester,
  ) async {
    // The running fixture: lesson part 2 is open, the comment locked.
    await pump(tester, PathNodeKind.comment);
    expect(find.text(kSkipLabel), findsNothing);
    expect(find.text(kSkipNote), findsNothing);
  });

  testWidgets('the open level: a ghost pill and the note; a skip goes on to '
      'the next open level', (WidgetTester tester) async {
    final FakeContestRepository repo = FakeContestRepository(
      latency: Duration.zero,
    );
    await repo.skipLevel('2026-11-11:lesson:2');
    await repo.skipLevel('2026-11-11:lesson:3');
    await pump(tester, PathNodeKind.comment);

    expect(find.text(kSkipLabel), findsOneWidget);
    expect(find.text(kSkipNote), findsOneWidget);
    await tester.tap(find.text(kSkipLabel));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
    expect(find.text('THE FEED'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
