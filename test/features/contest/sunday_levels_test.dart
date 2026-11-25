import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';
import 'package:plexaverse/features/contest/domain/levels_words.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/node_card.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/path_node.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/path_view.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/sunday_tags.dart';

import 'contest_home_harness.dart';

/// The open-all-week Sunday levels on the path (25 Nov 2026): this planner
/// week's set-up steps, drawn as Sunday's own levels in orange, with their
/// tags above that Sunday's title only — outside the one-at-a-time order, so
/// never START while today's own level is open and never skipped; one whose
/// post day has gone is disabled and says why.
void main() {
  const String sundayKey = '2026-11-08';

  PathNode comment({
    String day = '2026-11-11',
    PathNodeState state = PathNodeState.today,
    bool canSkip = false,
  }) => PathNode(
    id: '$day:comment',
    kind: PathNodeKind.comment,
    state: state,
    title: 'Comment on a top voice',
    points: 40,
    href: state == PathNodeState.today ? '/levels/comment' : null,
    canSkip: canSkip,
  );

  PathNode step(
    int day,
    SetupStep which,
    PathNodeState state, {
    String? detail,
    bool canSkip = false,
  }) {
    const List<String> names = <String>['Monday', '', 'Wednesday'];
    final String weekday = names[day];
    return PathNode(
      id: '$sundayKey:plan_week:${which.wire}:$day',
      kind: PathNodeKind.planWeek,
      state: state,
      title: which == SetupStep.post
          ? 'Write $weekday’s post'
          : 'Add $weekday’s image',
      href: state == PathNodeState.today || state == PathNodeState.done
          ? '/planner?week=6&setup=1&day=$day&step=${which.wire}'
          : null,
      detail: detail,
      setup: NodeSetup(dayIndex: day, step: which),
      canSkip: canSkip,
      openAllWeek: true,
    );
  }

  final List<PathNode> sundayLevels = <PathNode>[
    step(0, SetupStep.post, PathNodeState.done, detail: 'Written'),
    step(
      0,
      SetupStep.image,
      PathNodeState.missed,
      detail: 'Day passed — Monday’s image was not added',
    ),
    step(2, SetupStep.post, PathNodeState.today),
    step(
      2,
      SetupStep.image,
      PathNodeState.locked,
      detail: 'Unlocks after Write Wednesday’s post',
    ),
  ];

  /// Sunday (past, holding the Sunday levels after its own comment), then
  /// today, a Wednesday.
  ContestPath week({List<PathNode>? sunday, List<PathNode>? today}) =>
      ContestPath(
        status: ContestPathStatus.running,
        dayNumber: 11,
        weekNumber: 2,
        days: <PathDay>[
          PathDay(
            dayNumber: 8,
            dayKey: sundayKey,
            weekday: 0,
            nodes:
                sunday ??
                <PathNode>[
                  comment(day: sundayKey, state: PathNodeState.done),
                  ...sundayLevels,
                ],
          ),
          PathDay(
            dayNumber: 11,
            dayKey: '2026-11-11',
            weekday: 3,
            isToday: true,
            nodes: today ?? <PathNode>[comment(canSkip: true)],
          ),
        ],
        weekReward: const WeekReward(points: 500),
      );

  Future<GoRouter> pumpPath(WidgetTester tester, ContestPath path) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final GoRouter router = contestRouter(
      Scaffold(
        body: ContestGround(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: PathView(path: path, title: 'Levels'),
          ),
        ),
      ),
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await settle(tester);
    return router;
  }

  PathNodeButton buttonFor(WidgetTester tester, String id) => tester
      .widgetList<PathNodeButton>(find.byType(PathNodeButton))
      .firstWhere((PathNodeButton b) => b.node.id == id);

  Finder nodeFinder(String id) => find.byWidgetPredicate(
    (Widget w) => w is PathNodeButton && w.node.id == id,
  );

  testWidgets('the tags sit above the title of the day that holds the Sunday '
      'levels, and nowhere else', (WidgetTester tester) async {
    await pumpPath(tester, week());
    expect(find.byType(SundayLevelTags), findsOneWidget);
    for (final String tag in kSundayLevelTags) {
      expect(find.text(tag.toUpperCase()), findsOneWidget);
    }
    expect(find.bySemanticsLabel(kSundayLevelTagsLabel), findsOneWidget);
    // Directly above Sunday's title, below nothing of the Wednesday's.
    final Rect tags = tester.getRect(find.byType(SundayLevelTags));
    final Rect sunday = tester.getRect(find.text('SUN · DAY 8'));
    final Rect wednesday = tester.getRect(find.text('WED · DAY 11 · TODAY'));
    expect(tags.bottom, lessThanOrEqualTo(sunday.top));
    expect(sunday.top - tags.bottom, lessThan(40));
    expect(tags.bottom, lessThan(wednesday.top));

    // A week whose Sunday holds no Sunday level has no tags at all.
    await pumpPath(tester, week(sunday: <PathNode>[comment(day: sundayKey)]));
    expect(find.byType(SundayLevelTags), findsNothing);
  });

  testWidgets('numbered on from the day’s own levels; open is orange and '
      'says "Open all week"', (WidgetTester tester) async {
    await pumpPath(tester, week());
    final PathNodeButton open = buttonFor(
      tester,
      '$sundayKey:plan_week:post:2',
    );
    expect(open.level, 4, reason: 'after the comment and Monday’s two');
    expect(
      open.semanticsLabel,
      'Sun, day 8: Level 4, Write Wednesday’s post. Open all week.',
    );
    expect(isOrange(open.node), isTrue);
    expect(
      isOrange(buttonFor(tester, '$sundayKey:plan_week:post:0').node),
      isTrue,
    );
    // An image waiting for its post is locked, and says what it waits for.
    expect(
      buttonFor(tester, '$sundayKey:plan_week:image:2').semanticsLabel,
      'Sun, day 8: Level 5, Add Wednesday’s image. Locked. Unlocks after '
      'Write Wednesday’s post.',
    );
  });

  testWidgets('START stays on today’s own level while it is open; the Sunday '
      'levels on a past Sunday are never START', (WidgetTester tester) async {
    await pumpPath(tester, week());
    expect(find.text('START'), findsOneWidget);
    expect(buttonFor(tester, '2026-11-11:comment').current, isTrue);
    for (final PathNode n in sundayLevels) {
      expect(buttonFor(tester, n.id).current, isFalse, reason: n.id);
    }
  });

  testWidgets('on its own Sunday, START waits for the day’s own level before '
      'it moves to a Sunday level', (WidgetTester tester) async {
    final ContestPath sundayToday = ContestPath(
      status: ContestPathStatus.running,
      dayNumber: 8,
      days: <PathDay>[
        PathDay(
          dayNumber: 8,
          dayKey: sundayKey,
          weekday: 0,
          isToday: true,
          nodes: <PathNode>[
            comment(day: sundayKey, canSkip: true),
            step(2, SetupStep.post, PathNodeState.today),
          ],
        ),
      ],
    );
    await pumpPath(tester, sundayToday);
    expect(buttonFor(tester, '$sundayKey:comment').current, isTrue);
    expect(buttonFor(tester, '$sundayKey:plan_week:post:2').current, isFalse);
  });

  testWidgets('a Sunday level never offers Skip, and its card is orange and '
      'opens the Planner on its day', (WidgetTester tester) async {
    // Even were the server to mark one, the card leaves Skip out.
    final GoRouter router = await pumpPath(
      tester,
      week(
        sunday: <PathNode>[
          step(2, SetupStep.post, PathNodeState.today, canSkip: true),
        ],
        today: <PathNode>[comment(state: PathNodeState.done)],
      ),
    );
    await tapVisible(tester, nodeFinder('$sundayKey:plan_week:post:2'));
    expect(find.byType(NodeCard), findsOneWidget);
    expect(find.text(kSkipLabel), findsNothing);
    expect(
      find.descendant(
        of: find.byType(NodeCard),
        matching: find.text('Open all week'),
      ),
      findsOneWidget,
    );
    final Container card = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(NodeCard),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((card.decoration! as BoxDecoration).color, ContestColors.sundayCard);

    await tapVisible(
      tester,
      find.descendant(of: find.byType(NodeCard), matching: find.text('START')),
    );
    // That day's sheet of this week: Wednesday is planner day 2.
    expect(locationOf(router).path, ZaveRoutes.planner);
    expect(locationOf(router).queryParameters['day'], '2');
  });

  testWidgets('a Sunday level whose day has passed is disabled: it says why, '
      'and a tap opens no card', (WidgetTester tester) async {
    await pumpPath(tester, week());
    const String id = '$sundayKey:plan_week:image:0';
    final PathNodeButton passed = buttonFor(tester, id);
    expect(passed.disabled, isTrue);
    expect(
      passed.semanticsLabel,
      'Sun, day 8: Level 3, Add Monday’s image. Day passed. Monday’s image '
      'was not added.',
    );
    expect(
      tester.getSemantics(nodeFinder(id)),
      isSemantics(isButton: true, isEnabled: false, hasEnabledState: true),
    );
    // "Day passed" under the node, as the web's phone draws it.
    expect(find.text(kSundayLevelDayPassed), findsOneWidget);

    await tapVisible(tester, nodeFinder(id));
    expect(find.byType(NodeCard), findsNothing);

    // An open card closes when the passed level is pressed.
    await tapVisible(tester, nodeFinder('$sundayKey:plan_week:post:2'));
    expect(find.byType(NodeCard), findsOneWidget);
    await tapVisible(tester, nodeFinder(id));
    expect(find.byType(NodeCard), findsNothing);
  });
}
