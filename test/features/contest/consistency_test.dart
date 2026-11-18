import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/widgets/rail/consistency_card.dart';
import 'package:plexaverse/features/contest/presentation/widgets/stats_bar.dart';

import 'contest_home_harness.dart';

/// The consistency meter (owner, 17 Nov 2026) — the web's
/// `ConsistencyCard`, its `consistencyLines` and the stats bar's figure.
///
/// Measurement only: no line, in any state, names a price.
void main() {
  setUp(FakeContestWorld.reset);

  final ConsistencyWindow november = ConsistencyWindow(
    from: DateTime.utc(2026, 10, 31, 18, 30),
    to: DateTime.utc(2026, 11, 30, 18, 30),
    basis: 'calendar',
  );

  ConsistencyView measuring({
    bool above = false,
    int pending = 0,
    bool paused = false,
    ConsistencyToday? today,
  }) => ConsistencyView(
    state: ConsistencyState.measuring,
    percent: above ? 82 : 68,
    atOrAbove: above,
    earned: above ? 2200 : 1820,
    available: 2680,
    pending: pending,
    toLine: above ? 0 : 190,
    window: november,
    today: today,
    scoringPaused: paused,
    days: const <ConsistencyDay>[ConsistencyDay(dayKey: '2026-11-18')],
  );

  group('the wire', () {
    test('snake-case states, and an unknown one shows nothing', () {
      for (final (String wire, ConsistencyState want)
          in <(String, ConsistencyState)>[
            ('off', ConsistencyState.off),
            ('no_contest', ConsistencyState.noContest),
            ('not_joined', ConsistencyState.notJoined),
            ('no_tasks', ConsistencyState.noTasks),
            ('measuring', ConsistencyState.measuring),
            ('priced', ConsistencyState.off),
          ]) {
        final ConsistencyView v = ConsistencyView.fromJson(<String, dynamic>{
          'state': wire,
          'mode': 'on',
        });
        expect(v.state, want, reason: wire);
      }
      expect(
        ConsistencyView.fromJson(<String, dynamic>{'mode': 'later'}).mode,
        ConsistencyMode.shadow,
      );
    });

    test('the hidden states are off, no_contest and not_joined', () {
      expect(
        ConsistencyState.values.where((ConsistencyState s) => s.isHidden),
        <ConsistencyState>[
          ConsistencyState.off,
          ConsistencyState.noContest,
          ConsistencyState.notJoined,
        ],
      );
    });

    test('the stats bar figure exists only while measuring', () {
      expect(
        measuring().figure,
        const ConsistencyFigure(percent: 68, atOrAbove: false),
      );
      expect(
        measuring(above: true).figure,
        const ConsistencyFigure(percent: 82, atOrAbove: true),
      );
      expect(
        const ConsistencyView(state: ConsistencyState.noTasks).figure,
        isNull,
      );
      expect(
        const ConsistencyView(state: ConsistencyState.measuring).figure,
        isNull,
        reason: 'no percent, no figure',
      );
    });
  });

  group('the lines', () {
    test('dates are on India time, the end the instant before it', () {
      expect(shortIst(DateTime.utc(2026, 10, 31, 18, 30)), '1 Nov');
      expect(
        shortIst(
          DateTime.utc(2026, 11, 30, 18, 30),
          minus: const Duration(milliseconds: 1),
        ),
        '30 Nov',
      );
    });

    test('below the line: the sum, and how much more puts you on it', () {
      expect(consistencyLines(measuring()), <String>[
        '1,820 of 2,680 XP on offer since 1 Nov.',
        '190 XP more puts you on the 75% line.',
      ]);
    });

    test('above the line: keep it there until the window’s last day', () {
      expect(consistencyLines(measuring(above: true)), <String>[
        '2,200 of 2,680 XP on offer since 1 Nov.',
        'You’re above the 75% line. Keep it there until 30 Nov.',
      ]);
    });

    test('today, pending and paused, in the web’s order', () {
      expect(
        consistencyLines(
          measuring(
            pending: 80,
            paused: true,
            today: const ConsistencyToday(earned: 60, available: 340),
          ),
        ).skip(2),
        <String>[
          'Today: 60 of 340 XP so far.',
          '80 XP waiting for review isn’t counted yet.',
          'Scoring is paused, so paused days are left out.',
        ],
      );
      // Nothing on offer today says nothing about today.
      expect(
        consistencyLines(
          measuring(today: const ConsistencyToday(available: 0)),
        ),
        hasLength(2),
      );
    });

    test('no_tasks says the % starts with the next contest day', () {
      expect(
        consistencyLines(
          const ConsistencyView(state: ConsistencyState.noTasks),
        ),
        <String>[
          'Nothing on offer yet this month. Your % starts with your next '
              'contest day.',
        ],
      );
    });

    test('no contest running, with counted days: they don’t count', () {
      final ConsistencyView ended = measuring().copyWith(
        noContestRunning: true,
      );
      expect(
        consistencyLines(ended).last,
        'No contest is running. Days without one don’t count.',
      );
      expect(
        consistencyLines(
          ended.copyWith(days: const <ConsistencyDay>[]),
        ).contains('No contest is running. Days without one don’t count.'),
        isFalse,
      );
    });

    test('a skipped level, and a comment with no topics, from the path', () {
      final ContestPath path = ContestPath(
        status: ContestPathStatus.running,
        days: <PathDay>[
          const PathDay(
            isToday: true,
            nodes: <PathNode>[
              PathNode(
                id: 'd:lesson:1',
                kind: PathNodeKind.lesson,
                state: PathNodeState.skipped,
              ),
              PathNode(
                id: 'd:comment',
                kind: PathNodeKind.comment,
                state: PathNodeState.unavailable,
                detail: 'Choose your post topics in Settings first',
              ),
            ],
          ),
        ],
      );
      expect(consistencyLines(measuring(), path).skip(2), <String>[
        'Skipped levels still count as on offer. Come back to them today.',
        'Today’s comment still counts as on offer — choose your post topics '
            'in Settings to get one.',
      ]);
      // A path that is not running adds nothing.
      expect(
        consistencyLines(
          measuring(),
          path.copyWith(status: ContestPathStatus.ended),
        ),
        hasLength(2),
      );
    });

    test('no line in any state names a price', () {
      final List<ConsistencyView> views = <ConsistencyView>[
        measuring(),
        measuring(above: true),
        measuring(
          pending: 1,
          paused: true,
          today: const ConsistencyToday(available: 5),
        ).copyWith(mode: ConsistencyMode.on, noContestRunning: true),
        const ConsistencyView(state: ConsistencyState.noTasks),
      ];
      for (final ConsistencyView v in views) {
        for (final String line in consistencyLines(v)) {
          expect(line, isNot(contains('₹')));
          expect(line.toLowerCase(), isNot(contains('refund')));
          expect(line.toLowerCase(), isNot(contains('next month is')));
        }
      }
    });
  });

  group('the fake world plays the server', () {
    test('running: measuring, with today read off its own path', () {
      final FakeContestWorld w = FakeContestWorld.of(
        FakeContestScenario.running,
      );
      final ConsistencyView v = w.consistency();
      expect(v.state, ConsistencyState.measuring);
      expect(v.window, isNotNull);
      expect(v.today, isNotNull);
      expect(v.today!.available, greaterThan(0));
      expect(v.days.where((ConsistencyDay d) => d.today), hasLength(1));
      expect(v.percent, (100 * v.earned) ~/ v.available);
      expect(v.atOrAbove, v.earned * 100 >= 75 * v.available);
      expect(v.noContestRunning, isFalse);
    });

    test('a skipped level is still on offer, and the card says so', () {
      final FakeContestWorld w = FakeContestWorld.of(
        FakeContestScenario.running,
      );
      final int before = w.consistency().available;
      final PathNode open = w.path().today!.nodes.firstWhere(
        (PathNode n) => n.canSkip,
      );
      w.skip(open.id);
      final ConsistencyView after = w.consistency();
      expect(after.available, before);
      expect(
        consistencyLines(after, w.path()),
        contains(
          'Skipped levels still count as on offer. Come back to them today.',
        ),
      );
    });

    test('skipping a part-done feed-comments level keeps its paid shares '
        'earned', () {
      final FakeContestWorld w = FakeContestWorld.of(
        FakeContestScenario.running,
      );
      PathNode feed() => w.path().today!.nodes.firstWhere(
        (PathNode n) => n.kind == PathNodeKind.feedComments,
      );
      // Skip the levels ahead of it until feed comments is the current one.
      while (!feed().canSkip) {
        w.skip(w.path().today!.nodes.firstWhere((PathNode n) => n.canSkip).id);
      }
      final int before = w.consistency().earned;
      w.submitFeedComment(
        'https://www.linkedin.com/feed/update/urn:li:activity:7300001',
      );
      w.submitFeedComment(
        'https://www.linkedin.com/feed/update/urn:li:activity:7300002',
      );
      final ConsistencyView posted = w.consistency();
      expect(posted.earned, before + 40);
      w.skip(feed().id);
      expect(feed().state, PathNodeState.skipped);
      final ConsistencyView after = w.consistency();
      expect(after.earned, posted.earned);
      expect(after.available, posted.available);
      expect(after.today!.earned, posted.today!.earned);
      expect(after.percent, posted.percent);
    });

    test('the states the card hides, and the ones it keeps', () {
      ConsistencyState of(FakeContestScenario s) =>
          FakeContestWorld.of(s).consistency().state;
      expect(of(FakeContestScenario.noContest), ConsistencyState.noContest);
      expect(of(FakeContestScenario.notJoined), ConsistencyState.notJoined);
      expect(of(FakeContestScenario.upcoming), ConsistencyState.noContest);
      final ConsistencyView ended = FakeContestWorld.of(
        FakeContestScenario.ended,
      ).consistency();
      expect(ended.state, ConsistencyState.measuring);
      expect(ended.noContestRunning, isTrue);
      final ConsistencyView paused = FakeContestWorld.of(
        FakeContestScenario.paused,
      ).consistency();
      expect(paused.scoringPaused, isTrue);
      expect(paused.today?.available, 0);
    });
  });

  group('the card', () {
    Future<void> pumpCard(WidgetTester tester, Override meter) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[meter],
          retry: (int retryCount, Object error) => null,
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ConsistencyCard()),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    Override serves(ConsistencyView v) =>
        contestConsistencyProvider.overrideWith((Ref ref) async => v);

    testWidgets('measuring: the percent, the line and the sum', (
      WidgetTester tester,
    ) async {
      await pumpCard(tester, serves(measuring()));
      expect(find.text('Consistency'), findsOneWidget);
      expect(find.text('68%'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(
        find.text('1,820 of 2,680 XP on offer since 1 Nov.'),
        findsOneWidget,
      );
      expect(
        find.text('190 XP more puts you on the 75% line.'),
        findsOneWidget,
      );
    });

    testWidgets('no_tasks: the line alone, no figure', (
      WidgetTester tester,
    ) async {
      await pumpCard(
        tester,
        serves(const ConsistencyView(state: ConsistencyState.noTasks)),
      );
      expect(find.text('Consistency'), findsOneWidget);
      expect(find.textContaining('%'), findsOneWidget);
      expect(find.text('75%'), findsNothing);
    });

    for (final ConsistencyState hidden in <ConsistencyState>[
      ConsistencyState.off,
      ConsistencyState.noContest,
      ConsistencyState.notJoined,
    ]) {
      testWidgets('${hidden.name}: nothing at all', (
        WidgetTester tester,
      ) async {
        await pumpCard(tester, serves(ConsistencyView(state: hidden)));
        expect(find.text('Consistency'), findsNothing);
      });
    }

    testWidgets('loading or failed: nothing at all', (
      WidgetTester tester,
    ) async {
      await pumpCard(
        tester,
        contestConsistencyProvider.overrideWith(
          (Ref ref) =>
              Future<ConsistencyView>.error(const ContestUnavailable()),
        ),
      );
      expect(find.text('Consistency'), findsNothing);
    });

    // Riverpod 3 keeps the last value on a failed re-read; the web hides the
    // card on any isError, so a stale figure never shows.
    testWidgets('a failed re-read hides the older meter', (
      WidgetTester tester,
    ) async {
      int reads = 0;
      await pumpCard(
        tester,
        contestConsistencyProvider.overrideWith((Ref ref) async {
          reads++;
          if (reads > 1) throw const ContestUnavailable();
          return measuring();
        }),
      );
      expect(find.text('68%'), findsOneWidget);

      final ProviderContainer c = ProviderScope.containerOf(
        tester.element(find.byType(ConsistencyCard)),
      );
      c.invalidate(contestConsistencyProvider);
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      final AsyncValue<ConsistencyView> after = c.read(
        contestConsistencyProvider,
      );
      expect(reads, 2, reason: '$after');
      expect(after.hasError, isTrue, reason: '$after');
      expect(after.value, isNotNull, reason: 'Riverpod keeps the old value');
      expect(find.text('Consistency'), findsNothing);
      expect(find.text('68%'), findsNothing);
    });
  });

  group('the stats bar', () {
    Future<void> pumpBar(WidgetTester tester, StatsBar bar) =>
        tester.pumpWidget(MaterialApp(home: Scaffold(body: bar)));

    testWidgets('the figure shows only when given, and links to the card', (
      WidgetTester tester,
    ) async {
      await pumpBar(tester, const StatsBar(streak: 3, total: 1200));
      expect(find.textContaining('%'), findsNothing);

      int taps = 0;
      await pumpBar(
        tester,
        StatsBar(
          streak: 3,
          total: 1200,
          consistency: const ConsistencyFigure(percent: 68, atOrAbove: false),
          onConsistencyTap: () => taps++,
        ),
      );
      expect(find.text('68%'), findsOneWidget);
      expect(
        find.bySemanticsLabel('68% consistency this month'),
        findsOneWidget,
      );
      await tester.tap(find.text('68%'));
      expect(taps, 1);
    });
  });

  group('the contest page', () {
    testWidgets('running: the figure in the bar, the card on the rail', (
      WidgetTester tester,
    ) async {
      await pumpContestPage(tester);
      final ConsistencyView v = FakeContestWorld.of(
        FakeContestScenario.running,
      ).consistency();
      expect(find.text('${v.percent}%'), findsWidgets);
      expect(allText(tester), contains('Consistency'));

      // The card sits under the path, out of view; the figure in the stats
      // bar brings it into view — the web's link to #consistency.
      final double screen =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final Finder figure = find.text('${v.percent}%').first;
      await tester.ensureVisible(figure);
      await settle(tester);
      expect(
        tester.getTopLeft(find.text('Consistency')).dy,
        greaterThan(screen),
      );
      await tester.tap(figure);
      await settle(tester);
      expect(
        tester.getTopLeft(find.text('Consistency')).dy,
        inInclusiveRange(0, screen),
      );
    });

    testWidgets('no contest, or not joined: no meter anywhere', (
      WidgetTester tester,
    ) async {
      for (final FakeContestScenario s in <FakeContestScenario>[
        FakeContestScenario.noContest,
        FakeContestScenario.notJoined,
      ]) {
        FakeContestWorld.reset();
        await pumpContestPage(tester, scenario: s);
        expect(allText(tester), isNot(contains('Consistency')), reason: s.name);
      }
    });
  });
}
