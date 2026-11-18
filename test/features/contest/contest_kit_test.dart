import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';

/// The contest's shared chrome, at the narrowest phone the app ships on.
///
/// Every contest screen is built from these, so a pixel of overflow here is
/// one on every screen — and the words are the web's, so a level locked on
/// the web reads the same on a phone.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    ContestPath? path,
  }) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: ContestGround(
              child: Padding(padding: const EdgeInsets.all(16), child: child),
            ),
          ),
        ),
        GoRoute(
          path: ZaveRoutes.contest,
          builder: (_, _) => const Text('the path'),
        ),
        GoRoute(
          path: ZaveRoutes.contestComment,
          builder: (_, _) => const Text('the comment level'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          contestPathProvider.overrideWith(
            (Ref ref) async => path ?? const ContestPath(),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  testWidgets('a locked level says which level comes first, in the web’s '
      'words, and leads back to the path', (WidgetTester tester) async {
    await pump(
      tester,
      const LockedNotice(detail: 'Unlocks after Lesson part 3 of 3'),
    );
    expect(find.text('Not open yet'), findsOneWidget);
    expect(
      find.text(
        'Unlocks after Lesson part 3 of 3. Levels open one after another — finish or skip it first.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Back to the path'));
    await tester.pumpAndSettle();
    expect(find.text('the path'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the next level is named, and opens by its kind', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const NextLevelPill(from: PathNodeKind.lesson),
      path: const ContestPath(
        status: ContestPathStatus.running,
        days: <PathDay>[
          PathDay(
            dayNumber: 11,
            dayKey: '2026-11-11',
            weekday: 3,
            isToday: true,
            nodes: <PathNode>[
              PathNode(
                id: '2026-11-11:comment',
                kind: PathNodeKind.comment,
                state: PathNodeState.today,
                title: 'Comment on a top voice',
                points: 40,
                // The web's path for it — deliberately not one the app has.
                href: '/somewhere/on/the/web',
              ),
            ],
          ),
        ],
      ),
    );
    await tester.pump();
    expect(find.text('Next: Comment on a top voice'), findsOneWidget);
    await tester.tap(find.text('Next: Comment on a top voice'));
    await tester.pumpAndSettle();
    expect(find.text('the comment level'), findsOneWidget);
  });

  testWidgets('with nothing open today it leads back to the path', (
    WidgetTester tester,
  ) async {
    await pump(tester, const NextLevelPill(from: PathNodeKind.comment));
    await tester.pump();
    expect(find.text('Back to the path'), findsOneWidget);
  });

  testWidgets('XP is signed and named; a penalty carries a true minus', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const Column(children: <Widget>[XpTag(points: 60), XpTag(points: -110)]),
    );
    expect(find.bySemanticsLabel('+60 XP'), findsOneWidget);
    expect(find.bySemanticsLabel('−110 XP'), findsOneWidget);
  });

  testWidgets('every dot carries its word; pills hold their width while busy '
      'and never wrap at 375', (WidgetTester tester) async {
    await pump(
      tester,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final ContestTone tone in ContestTone.values)
            ContestDot(tone: tone, label: 'Tone ${tone.name}'),
          const ContestKicker('Today · comment level'),
          ContestPrimaryPill(
            label:
                'Next: Lesson part 3 of 3 — a label far longer than any phone',
            onPressed: () {},
          ),
          const ContestPrimaryPill(label: 'Join the contest', onPressed: null),
          ContestGhostPill(label: 'See plans', busy: true, onPressed: () {}),
          const ContestPanel(child: Text('panel')),
          const ContestTile(child: Text('tile')),
        ],
      ),
    );
    for (final ContestTone tone in ContestTone.values) {
      expect(find.text('Tone ${tone.name}'), findsOneWidget);
    }
    expect(find.text('TODAY · COMMENT LEVEL'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
