import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/ui/app_icons.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_board_view.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_kit.dart';
import 'package:plexaverse/features/contest/presentation/widgets/rail/mini_board.dart';
import 'package:plexaverse/features/contest/presentation/widgets/stats_bar.dart';

import 'contest_home_harness.dart';

/// The board is hidden until the contest's last days, and the app shows no
/// rank before then — not the learner's own, not anyone's.
///
/// The SERVER enforces it (no rows, no rank in the overview); these pin that
/// the screens add nothing of their own: no "#–" placeholder, no empty
/// table, no other entrant's name. After the reveal, the board's rules: the
/// podium and you, "Participant" for anyone unnamed, and the viewer pinned
/// below the rows rather than spliced in.
void main() {
  setUp(FakeContestWorld.reset);

  /// Every name the fake board can hand out, besides the viewer's.
  const List<String> entrants = <String>[
    'Aarav Rao',
    'Sana Jain',
    'Kabir Mehta',
    'Ishita Bose',
    'Rohan Pillai',
  ];

  testWidgets('before the reveal: no rank anywhere, and the board says when '
      'it opens', (WidgetTester tester) async {
    await pumpContestPage(tester);
    final List<String> text = allText(tester);

    expect(
      text.where((String t) => t.startsWith('#')),
      isEmpty,
      reason: 'no rank before the reveal, not even a placeholder',
    );
    expect(
      find.descendant(
        of: find.byType(StatsBar),
        matching: find.byIcon(AppIcons.trophy),
      ),
      findsNothing,
      reason: 'no trophy waiting for a rank to fill it',
    );

    const String line =
        'The leaderboard opens on Saturday, 30 January — the last 10 days of '
        'the contest. Until then, it’s you against yesterday: keep your streak.';
    expect(
      find.descendant(of: find.byType(MiniBoard), matching: find.text(line)),
      findsOneWidget,
    );
    expect(find.text('Leaderboard hidden for now'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ContestBoardView),
        matching: find.text(line),
      ),
      findsOneWidget,
    );
    // Nothing to view all of, and nobody else named.
    expect(find.text('VIEW ALL'), findsNothing);
    for (final String name in entrants) {
      expect(find.text(name), findsNothing, reason: name);
    }
    // The count names and ranks nobody, so it stays.
    expect(find.text('1,284 entrants'), findsOneWidget);
  });

  testWidgets('after the reveal: the rank, the podium and you, and how far '
      'to the next place', (WidgetTester tester) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.revealed);

    expect(find.text('#7'), findsOneWidget);
    expect(find.text('Leaderboard hidden for now'), findsNothing);

    final Finder mini = find.byType(MiniBoard);
    expect(
      find.descendant(of: mini, matching: find.text('VIEW ALL')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: mini, matching: find.text('Aarav Rao')),
      findsOneWidget,
    );
    // The second place chose not to be named.
    expect(
      find.descendant(of: mini, matching: find.text('Participant')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: mini, matching: find.text('You')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: mini, matching: find.text('TOP 10 FINALISTS')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: mini,
        matching: find.textContaining(RegExp(r'^You are a finalist\. ')),
      ),
      findsOneWidget,
    );

    final Finder full = find.byType(ContestBoardView);
    expect(
      find.descendant(of: full, matching: find.text('Participant')),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: full,
        matching: find.text('Top 10 get featured'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: full, matching: find.text('···')),
      findsNothing,
      reason: 'the viewer is among the rows',
    );
  });

  Future<void> pumpBoard(WidgetTester tester, BoardResult board) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final GoRouter router = contestRouter(
      const Scaffold(
        body: ContestGround(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: ContestBoardView(
              entrants: 412,
              rewardTopN: 10,
              rewardMonths: 3,
            ),
          ),
        ),
      ),
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contestRepositoryProvider.overrideWithValue(_Board(board))],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await settle(tester);
  }

  BoardRow row(int rank, {String? name, bool viewer = false}) => BoardRow(
    rank: rank,
    name: name,
    isViewer: viewer,
    total: 5000 - rank * 100,
    streak: rank % 4,
  );

  testWidgets('an admin sees the rows early, told when entrants will', (
    WidgetTester tester,
  ) async {
    await pumpBoard(
      tester,
      BoardResult(
        revealsOn: '2027-01-30',
        revealDay: 91,
        rows: <BoardRow>[
          row(1, name: 'Aarav Rao'),
          row(2),
        ],
      ),
    );
    expect(
      find.text(
        'Admin view. Entrants see the board from Saturday, 30 January.',
      ),
      findsOneWidget,
    );
    expect(find.text('Aarav Rao'), findsOneWidget);
    expect(find.text('Leaderboard hidden for now'), findsNothing);
  });

  testWidgets('a viewer outside the rows is pinned below them, never '
      'spliced in', (WidgetTester tester) async {
    await pumpBoard(
      tester,
      BoardResult(
        revealed: true,
        revealsOn: '2027-01-30',
        revealDay: 91,
        rows: <BoardRow>[for (int r = 1; r <= 12; r++) row(r, name: 'Name $r')],
        viewer: row(40, name: 'Riya Kapoor', viewer: true),
      ),
    );
    final Rect gap = tester.getRect(find.text('···'));
    final Rect last = tester.getRect(find.text('Name 12'));
    final Rect you = tester.getRect(find.text('Riya Kapoor'));
    expect(gap.top, greaterThan(last.bottom));
    expect(you.top, greaterThan(gap.bottom));
    expect(find.text('40'), findsOneWidget);
    // The reward line sits under the last rewarded place.
    final Rect rule = tester.getRect(find.text('Top 10 get featured'));
    expect(rule.top, greaterThan(tester.getRect(find.text('Name 10')).bottom));
    expect(rule.bottom, lessThan(tester.getRect(find.text('Name 11')).top));
    // A streak of none is a dash, not a zero.
    expect(find.text('–'), findsWidgets);
  });
}

/// The running fake, answering the board with [board].
class _Board extends FakeContestRepository {
  _Board(this.board) : super(latency: Duration.zero);

  final BoardResult board;

  @override
  Future<BoardResult> fetchBoard({int? limit}) async => board;
}
