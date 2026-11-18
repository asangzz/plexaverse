import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:plexaverse/core/ui/app_icons.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/node_card.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/path_node.dart';
import 'package:plexaverse/features/contest/presentation/widgets/path/path_view.dart';

import 'contest_home_harness.dart';

/// A tap on the path opens a level by its KIND — never by its `href`, which
/// is the web's address for it — and a level with nothing to open opens
/// nothing.
///
/// Every node here carries an href no app route answers to. A dispatch that
/// read it would land on "Page not found"; landing on the kind's own route is
/// the proof that it was not read.
void main() {
  const String webOnly = '/somewhere/only/the/web/has';

  ContestPath weekOf(List<PathNode> nodes) => ContestPath(
    status: ContestPathStatus.running,
    dayNumber: 11,
    weekNumber: 2,
    days: <PathDay>[
      PathDay(
        dayNumber: 11,
        dayKey: '2026-11-11',
        weekday: 3,
        isToday: true,
        nodes: nodes,
      ),
    ],
    weekReward: const WeekReward(points: 500),
  );

  Future<GoRouter> pumpPath(
    WidgetTester tester,
    ContestPath path, {
    ContestRepository? repo,
  }) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final GoRouter router = contestRouter(
      Scaffold(
        body: ContestGround(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: PathView(path: path, title: 'Business English Contest'),
          ),
        ),
      ),
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          if (repo != null) contestRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await settle(tester);
    return router;
  }

  /// Open [node]'s card, then press its button.
  Future<void> openThroughCard(WidgetTester tester, String button) async {
    await tapVisible(tester, find.byType(PathNodeButton).first);
    // In the card: a lesson's button and the START bubble both say START.
    await tapVisible(
      tester,
      find.descendant(of: find.byType(NodeCard), matching: find.text(button)),
    );
  }

  final Map<PathNode, Uri> opens = <PathNode, Uri>{
    const PathNode(
      id: '2026-11-11:lesson:2',
      kind: PathNodeKind.lesson,
      state: PathNodeState.today,
      title: 'Lesson · part 2 of 3',
      href: webOnly,
      part: NodePart(index: 2, total: 3, start: 5, end: 10),
    ): Uri.parse(
      '/contest/lesson',
    ),
    const PathNode(
      id: '2026-11-11:comment',
      kind: PathNodeKind.comment,
      state: PathNodeState.today,
      title: 'Comment on a top voice',
      points: 40,
      href: webOnly,
    ): Uri.parse(
      '/contest/comment',
    ),
    // Skipped today: still open. A skipped lesson part opens on itself.
    const PathNode(
      id: '2026-11-11:lesson:3',
      kind: PathNodeKind.lesson,
      state: PathNodeState.skipped,
      title: 'Lesson · part 3 of 3',
      points: 50,
      href: webOnly,
      detail: 'You skipped this',
      part: NodePart(index: 3, total: 3, start: 10, end: 15),
    ): Uri(
      path: '/contest/lesson',
      queryParameters: <String, String>{'part': '3'},
    ),
    const PathNode(
      id: '2026-11-11:comment-skipped',
      kind: PathNodeKind.comment,
      state: PathNodeState.skipped,
      title: 'Comment on a top voice',
      points: 40,
      href: webOnly,
      detail: 'You skipped this',
    ): Uri.parse(
      '/contest/comment',
    ),
    const PathNode(
      id: '2026-11-11:feed_comments',
      kind: PathNodeKind.feedComments,
      state: PathNodeState.today,
      title: 'Post 5 valuable comments',
      points: 60,
      started: true,
      href: webOnly,
    ): Uri.parse(
      '/contest/feed-comments',
    ),
    const PathNode(
      id: '2026-11-11:weekly_invites',
      kind: PathNodeKind.weeklyInvites,
      state: PathNodeState.rejected,
      title: 'Weekly invites',
      points: 80,
      href: webOnly,
    ): Uri.parse(
      '/contest/invites',
    ),
    const PathNode(
      id: '2026-11-11:plan_week',
      kind: PathNodeKind.planWeek,
      state: PathNodeState.done,
      title: 'Plan this week',
      href: webOnly,
    ): Uri.parse(
      '/contest/plan',
    ),
    const PathNode(
      id: '2026-11-11:connect_leaders',
      kind: PathNodeKind.connectLeaders,
      state: PathNodeState.today,
      title: 'Connect with leaders',
      points: 60,
      href: webOnly,
    ): Uri.parse(
      '/connections?from=contest',
    ),
    const PathNode(
      id: '2026-11-11:article:6:1',
      kind: PathNodeKind.article,
      state: PathNodeState.pending,
      title: 'Share your article’s link',
      points: 150,
      href: webOnly,
      claim: NodeClaim(kind: ClaimKind.article, occurrence: '6:1'),
    ): Uri(
      path: '/contest/claim',
      queryParameters: <String, String>{'kind': 'article', 'occurrence': '6:1'},
    ),
    const PathNode(
      id: '2026-11-11:video:6:1:3',
      kind: PathNodeKind.video,
      state: PathNodeState.today,
      title: 'Share your video’s link',
      points: 100,
      href: webOnly,
      claim: NodeClaim(kind: ClaimKind.video, occurrence: '6:1:3'),
    ): Uri(
      path: '/contest/claim',
      queryParameters: <String, String>{'kind': 'video', 'occurrence': '6:1:3'},
    ),
  };

  for (final MapEntry<PathNode, Uri> c in opens.entries) {
    testWidgets('${c.key.kind.wire} (${c.key.state.name}) opens '
        '${c.value.path}, not its href', (WidgetTester tester) async {
      final GoRouter router = await pumpPath(tester, weekOf(<PathNode>[c.key]));
      await openThroughCard(tester, actionWord(c.key).toUpperCase());
      final Uri at = locationOf(router);
      expect(at.path, c.value.path);
      expect(at.queryParameters, c.value.queryParameters);
      expect(find.text('AT $webOnly'), findsNothing);
    });
  }

  final Map<PathNode, String> closed = <PathNode, String>{
    // Locked never opens, even with an href: a future day's level is not
    // there yet.
    const PathNode(
      id: '2026-11-11:comment',
      kind: PathNodeKind.comment,
      state: PathNodeState.locked,
      title: 'Comment on a top voice',
      points: 40,
      href: webOnly,
      detail: 'Unlocks after Lesson part 3 of 3',
    ): 'LOCKED',
    const PathNode(
      id: '2026-11-10:feed_comments',
      kind: PathNodeKind.feedComments,
      state: PathNodeState.missed,
      title: 'Post 5 valuable comments',
    ): 'NOTHING TO OPEN',
    const PathNode(
      id: '2026-11-11:comment-unavailable',
      kind: PathNodeKind.comment,
      state: PathNodeState.unavailable,
      title: 'Comment on a top voice',
    ): 'NOTHING TO OPEN',
    const PathNode(
      id: '2026-11-09:feed_comments',
      kind: PathNodeKind.feedComments,
      state: PathNodeState.revoked,
      title: 'Post 5 valuable comments',
      detail: 'Removed: Two of the links were the same comment — −110 XP',
    ): 'NOTHING TO OPEN',
    // A level this build has never heard of opens nothing, href or not.
    const PathNode(
      id: '2026-11-11:new_level',
      state: PathNodeState.today,
      title: 'A level from the future',
      href: webOnly,
    ): 'NOTHING TO OPEN',
    // A claim that lost its piece has nothing to send the link against.
    const PathNode(
      id: '2026-11-11:video',
      kind: PathNodeKind.video,
      state: PathNodeState.today,
      title: 'Share your video’s link',
      href: webOnly,
    ): 'NOTHING TO OPEN',
  };

  for (final MapEntry<PathNode, String> c in closed.entries) {
    testWidgets('${c.key.kind.wire} (${c.key.state.name}) shows its card and '
        'opens nothing', (WidgetTester tester) async {
      final GoRouter router = await pumpPath(tester, weekOf(<PathNode>[c.key]));
      await openThroughCard(tester, c.value);
      expect(locationOf(router).path, '/');
      expect(find.text(c.key.title), findsWidgets, reason: 'the card stays');
      expect(
        tester.getSemantics(
          find.bySemanticsLabel(
            c.value == 'LOCKED' ? 'Locked' : 'Nothing to open',
          ),
        ),
        isSemantics(isButton: true, isEnabled: false),
      );
    });
  }

  testWidgets('one card at a time: another node switches it, the same node '
      'and a press outside close it', (WidgetTester tester) async {
    const PathNode lesson = PathNode(
      id: '2026-11-11:lesson:1',
      kind: PathNodeKind.lesson,
      state: PathNodeState.today,
      title: 'Lesson · part 1 of 3',
      href: webOnly,
      detail: '5 questions',
    );
    const PathNode comment = PathNode(
      id: '2026-11-11:comment',
      kind: PathNodeKind.comment,
      state: PathNodeState.locked,
      title: 'Comment on a top voice',
      detail: 'Unlocks after Lesson part 3 of 3',
    );
    await pumpPath(tester, weekOf(<PathNode>[lesson, comment]));
    final Finder nodes = find.byType(PathNodeButton);

    await tapVisible(tester, nodes.at(0));
    expect(find.text('5 questions'), findsOneWidget);
    await tapVisible(tester, nodes.at(1));
    expect(find.text('5 questions'), findsNothing);
    expect(find.text('Unlocks after Lesson part 3 of 3'), findsOneWidget);
    await tapVisible(tester, nodes.at(1));
    expect(find.text('Unlocks after Lesson part 3 of 3'), findsNothing);

    await tapVisible(tester, nodes.at(0));
    expect(find.text('5 questions'), findsOneWidget);
    await tester.tapAt(const Offset(8, 600));
    await settle(tester);
    expect(find.text('5 questions'), findsNothing);
  });

  testWidgets('nothing on the path moves on its own: no pulse, no idle bob', (
    WidgetTester tester,
  ) async {
    await pumpPath(
      tester,
      weekOf(const <PathNode>[
        PathNode(
          id: '2026-11-11:lesson:1',
          kind: PathNodeKind.lesson,
          state: PathNodeState.today,
          title: 'Lesson · part 1 of 3',
          href: webOnly,
        ),
        PathNode(
          id: '2026-11-11:article:6:1',
          kind: PathNodeKind.article,
          state: PathNodeState.pending,
          title: 'Share your article’s link',
          href: webOnly,
          claim: NodeClaim(kind: ClaimKind.article, occurrence: '6:1'),
        ),
      ]),
    );
    // Past the scroll to today, the page asks for no frame at all: an
    // ambient animation would keep scheduling them (the July 2026 jank).
    await tester.pump(const Duration(seconds: 2));
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('the week trophy says what the server decided, and a missed '
      'week wears its red tag under the trophy', (WidgetTester tester) async {
    const PathNode lesson = PathNode(
      id: '2026-11-11:lesson:1',
      kind: PathNodeKind.lesson,
      state: PathNodeState.done,
      title: 'Lesson · part 1 of 3',
      href: webOnly,
    );
    await pumpPath(
      tester,
      weekOf(const <PathNode>[
        lesson,
      ]).copyWith(weekReward: const WeekReward(points: 500, missedDay: true)),
    );
    const String missed = '−500 XP missed · incomplete week';
    expect(find.bySemanticsLabel(missed), findsOneWidget);
    final Rect tag = tester.getRect(find.text(missed));
    final Rect cup = tester.getRect(find.byIcon(AppIcons.trophy));
    expect(tag.top, greaterThan(cup.bottom), reason: 'under the trophy');
    expect((tag.center.dx - cup.center.dx).abs(), lessThan(1));

    await pumpPath(
      tester,
      weekOf(const <PathNode>[lesson]).copyWith(
        weekReward: const WeekReward(points: 500, earned: true, paid: 500),
      ),
    );
    expect(find.bySemanticsLabel('Week complete · +500 XP'), findsOneWidget);
    expect(find.text(missed), findsNothing);
  });

  testWidgets('START sits on today’s first level still to do, and its card '
      'says what it pays', (WidgetTester tester) async {
    await pumpPath(
      tester,
      weekOf(const <PathNode>[
        PathNode(
          id: '2026-11-11:lesson:1',
          kind: PathNodeKind.lesson,
          state: PathNodeState.done,
          title: 'Lesson · part 1 of 3',
          href: webOnly,
        ),
        PathNode(
          id: '2026-11-11:lesson:2',
          kind: PathNodeKind.lesson,
          state: PathNodeState.today,
          title: 'Lesson · part 2 of 3',
          points: 50,
          href: webOnly,
        ),
      ]),
    );
    expect(find.text('START'), findsOneWidget);
    final PathNodeButton current = tester.widget<PathNodeButton>(
      find.byType(PathNodeButton).at(1),
    );
    expect(current.current, isTrue);
    expect(
      current.semanticsLabel,
      'Wed, day 11: Lesson · part 2 of 3. Open today.',
    );
    await tapVisible(tester, find.byType(PathNodeButton).at(1));
    expect(find.text('WED · DAY 11 · LESSON'), findsOneWidget);
    expect(find.text('START +50 XP'), findsOneWidget);
  });

  testWidgets('the open level’s card offers Skip; a skip closes the card '
      'and sends the node’s id', (WidgetTester tester) async {
    final _SkipRecorder repo = _SkipRecorder();
    const PathNode open = PathNode(
      id: '2026-11-11:comment',
      kind: PathNodeKind.comment,
      state: PathNodeState.today,
      title: 'Comment on a top voice',
      points: 40,
      href: webOnly,
      canSkip: true,
    );
    await pumpPath(tester, weekOf(const <PathNode>[open]), repo: repo);
    await tapVisible(tester, find.byType(PathNodeButton).first);
    final Finder skip = find.descendant(
      of: find.byType(NodeCard),
      matching: find.text(kSkipLabel),
    );
    expect(skip, findsOneWidget);
    await tapVisible(tester, skip);
    expect(repo.skipped, <String>['2026-11-11:comment']);
    expect(find.byType(NodeCard), findsNothing);
    // The guard's window passes.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('no Skip on a level the server did not mark', (
    WidgetTester tester,
  ) async {
    await pumpPath(
      tester,
      weekOf(const <PathNode>[
        PathNode(
          id: '2026-11-11:comment',
          kind: PathNodeKind.comment,
          state: PathNodeState.today,
          title: 'Comment on a top voice',
          href: webOnly,
        ),
      ]),
    );
    await tapVisible(tester, find.byType(PathNodeButton).first);
    expect(find.text(kSkipLabel), findsNothing);
  });

  testWidgets('a skipped level is drawn open, says so, and Starts', (
    WidgetTester tester,
  ) async {
    await pumpPath(
      tester,
      weekOf(const <PathNode>[
        PathNode(
          id: '2026-11-11:comment',
          kind: PathNodeKind.comment,
          state: PathNodeState.skipped,
          title: 'Comment on a top voice',
          points: 40,
          href: webOnly,
          detail: 'You skipped this',
        ),
      ]),
    );
    final PathNodeButton node = tester.widget<PathNodeButton>(
      find.byType(PathNodeButton).first,
    );
    // Nothing else is open, so START is back on it.
    expect(node.current, isTrue);
    expect(
      node.semanticsLabel,
      'Wed, day 11: Comment on a top voice. Skipped, still open today.',
    );
    expect(find.byIcon(AppIcons.skip), findsOneWidget);
    await tapVisible(tester, find.byType(PathNodeButton).first);
    expect(find.text('START +40 XP'), findsWidgets);
  });
}

/// Records skips; everything else is the fake contest.
class _SkipRecorder extends FakeContestRepository {
  _SkipRecorder() : super(latency: Duration.zero);

  final List<String> skipped = <String>[];

  @override
  Future<SkipResult> skipLevel(String nodeId) async {
    skipped.add(nodeId);
    return SkipResult(nodeId: nodeId);
  }
}
