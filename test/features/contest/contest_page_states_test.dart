import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/contest_home_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_section_bar.dart';
import 'package:plexaverse/features/contest/presentation/widgets/rail/daily_quests.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_moment.dart';

import 'contest_home_harness.dart';

/// `/contest`, in every state its overview and its path can put it in, at
/// the narrowest phone the app ships on.
///
/// Each state is the web's `ContestClient` branch of the same name, and
/// says the web's words. The fakes play the server; where a state needs an
/// overview no scenario has (a contest that ended without you), the read is
/// stood in directly.
void main() {
  setUp(FakeContestWorld.reset);

  ContestInfo info() => ContestInfo(
    id: 'c1',
    title: 'Business English Contest',
    prizeTitle: 'a profile shoutout',
    startsAt: DateTime.utc(2026, 11, 14, 18, 30),
    endsAt: DateTime.utc(2027, 2, 22, 18, 30),
    firstDayKey: '2026-11-15',
    lastDayKey: '2027-02-22',
    weekComplete: 500,
  );

  Override overviewIs(ContestOverview? overview) =>
      contestOverviewProvider.overrideWith((Ref ref) async => overview);

  bool showsMoment(WidgetTester tester, PlexaMomentClip clip) => tester
      .widgetList<PlexaMoment>(find.byType(PlexaMoment))
      .any((PlexaMoment m) => m.moment == clip);

  group('the page’s own rules', () {
    final DateTime joined = DateTime.utc(2026, 11, 11, 9);
    ContestEntryView entry({int streak = 5, int best = 5}) =>
        ContestEntryView(joinedAt: joined, streak: streak, bestStreak: best);

    test(
      'Plexa’s moment: the ticket first, then the shrug, then the flame',
      () {
        final DateTime soon = joined.add(const Duration(minutes: 9));
        final DateTime later = joined.add(const Duration(minutes: 10));
        // The ticket wins for ten minutes, whatever the streak.
        expect(runningMoment(entry(streak: 0), soon), ContestMoment.joined);
        expect(
          runningMoment(entry(streak: 0), later),
          ContestMoment.streakReset,
        );
        // A streak that was never there is not a broken one.
        expect(runningMoment(entry(streak: 0, best: 0), later), isNull);
        for (final int s in <int>[3, 7, 14, 20]) {
          expect(
            runningMoment(entry(streak: s), later),
            ContestMoment.streakFlame,
          );
        }
        expect(runningMoment(entry(streak: 4), later), isNull);
        // A join stamped after the phone's clock greets nobody, as on the web.
        expect(
          runningMoment(entry(), joined.subtract(const Duration(seconds: 5))),
          isNull,
        );
      },
    );

    test('the quiet page: the finale once it has ended, the ticket before', () {
      final DateTime soon = joined.add(const Duration(minutes: 1));
      ContestOverview at(ContestPhase phase) =>
          ContestOverview(contest: info(), phase: phase, entry: entry());
      expect(quietMoment(at(ContestPhase.ended), soon), ContestMoment.finale);
      expect(
        quietMoment(at(ContestPhase.upcoming), soon),
        ContestMoment.joined,
      );
      expect(
        quietMoment(
          at(ContestPhase.upcoming),
          joined.add(const Duration(hours: 1)),
        ),
        isNull,
      );
    });

    test('the quests are read off the day: parts, right answers, and every '
        'level with something to do', () {
      PathNode lesson(int i, PathNodeState s) => PathNode(
        id: 'd:lesson:$i',
        kind: PathNodeKind.lesson,
        state: s,
        title: 'Lesson · part $i of 3',
      );
      final PathDay today = PathDay(
        isToday: true,
        nodes: <PathNode>[
          lesson(1, PathNodeState.done),
          lesson(2, PathNodeState.today),
          lesson(3, PathNodeState.locked),
          const PathNode(
            id: 'd:comment',
            kind: PathNodeKind.comment,
            state: PathNodeState.unavailable,
            title: 'Comment on a top voice',
          ),
          const PathNode(
            id: 'd:video',
            kind: PathNodeKind.video,
            state: PathNodeState.pending,
            title: 'Share your video’s link',
          ),
        ],
      );
      final List<Quest> quests = questsFor(
        today,
        lessonProgressOf(
          const TodayQuiz(
            status: QuizStatus.ready,
            questions: <PublicQuizItem>[
              PublicQuizItem(id: 'a'),
              PublicQuizItem(id: 'b'),
              PublicQuizItem(id: 'c'),
            ],
            answered: <QuizAnswerView>[
              QuizAnswerView(itemId: 'a', correct: true),
              QuizAnswerView(itemId: 'b'),
            ],
          ),
        ),
      );
      expect(
        quests.map((Quest q) => '${q.title} ${q.done}/${q.goal}').toList(),
        <String>[
          'Finish today’s lesson 1/3',
          'Get 3 answers right 1/3',
          'Share your video’s link 1/1',
        ],
        reason: 'nothing to do today is not a quest',
      );
      expect(quests.last.note, 'Waiting for review');
      // No lesson to read yet: no "right answers" quest at all.
      expect(lessonProgressOf(const TodayQuiz()), isNull);
    });

    test('a skipped part is not passed, and says it is still open; a skipped '
        'task says so too', () {
      PathNode lesson(int i, PathNodeState s) => PathNode(
        id: 'd:lesson:$i',
        kind: PathNodeKind.lesson,
        state: s,
        title: 'Lesson · part $i of 3',
      );
      final List<Quest> quests = questsFor(
        PathDay(
          isToday: true,
          nodes: <PathNode>[
            lesson(1, PathNodeState.skipped),
            lesson(2, PathNodeState.done),
            lesson(3, PathNodeState.done),
            const PathNode(
              id: 'd:comment',
              kind: PathNodeKind.comment,
              state: PathNodeState.skipped,
              title: 'Comment on a top voice',
            ),
          ],
        ),
        null,
      );
      // The old "last part done" rule read this as 3/3.
      expect(quests.first.done, 2);
      expect(quests.first.goal, 3);
      expect(quests.first.note, 'A part is skipped, still open today');
      expect(quests.last.done, 0);
      expect(quests.last.note, 'Skipped, still open today');
    });
  });

  testWidgets('loading draws the running page’s own shape', (
    WidgetTester tester,
  ) async {
    final Completer<ContestOverview?> never = Completer<ContestOverview?>();
    await pumpContestPage(
      tester,
      overrides: <Override>[
        contestOverviewProvider.overrideWith((Ref ref) => never.future),
      ],
    );
    expect(find.bySemanticsLabel('Loading the contest'), findsOneWidget);
    expect(find.text('Join the contest'), findsNothing);
  });

  testWidgets('a failed read is said in words, with a way to try again', (
    WidgetTester tester,
  ) async {
    int reads = 0;
    await pumpContestPage(
      tester,
      overrides: <Override>[
        contestOverviewProvider.overrideWith((Ref ref) async {
          reads++;
          throw const ContestUnavailable(
            'No connection. Check your network and try again.',
          );
        }),
      ],
    );
    expect(find.text('Could not load the contest'), findsOneWidget);
    expect(
      find.text('No connection. Check your network and try again.'),
      findsOneWidget,
    );
    expect(showsMoment(tester, PlexaMomentClip.oopsWrench), isTrue);
    await tester.tap(find.text('Try again'));
    await settle(tester);
    expect(reads, 2, reason: 'Try again reads the overview again');
  });

  testWidgets('no contest: the waiting room and the way back', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpContestPage(
      tester,
      scenario: FakeContestScenario.noContest,
    );
    expect(find.text('No contest right now'), findsOneWidget);
    expect(
      find.text(
        'The next one will show up here. Your lessons and your roadmap carry on as usual.',
      ),
      findsOneWidget,
    );
    expect(showsMoment(tester, PlexaMomentClip.waitingRoom), isTrue);
    // No contest, so no last day to name.
    expect(
      find.text(
        'Your 1000-day roadmap is the bigger goal, and it keeps going after.',
      ),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Back to your roadmap'));
    expect(locationOf(router).path, '/roadmap');
  });

  testWidgets('not joined, running: the join card, its rules and an empty '
      'consent box', (WidgetTester tester) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.notJoined);
    expect(find.text('1 NOV 2026 – 8 FEB 2027'), findsOneWidget);
    expect(find.text('Business English Contest'), findsOneWidget);
    expect(find.text('Day 11. You can join any day it runs.'), findsOneWidget);
    expect(find.text('a profile shoutout'), findsOneWidget);
    expect(find.text('1,283 people have joined.'), findsOneWidget);
    expect(find.text('How it scores'), findsOneWidget);
    for (final String rule in <String>[
      'Your streak weighs most',
      'Finish every day’s lesson in a week: +500 XP',
      'A lesson a day, partly written for you',
      'Harder levels earn more',
      'Only your first try counts',
      'LinkedIn tasks count',
      'The leaderboard opens for the last 10 days',
      'Published posts count',
      '30 days free, then a plan',
      'Top 10 get featured',
    ]) {
      expect(find.text(rule), findsOneWidget, reason: rule);
    }
    expect(
      find.text(
        'Joining is free. After your first free month, scoring needs a plan.',
      ),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(
        find.bySemanticsLabel('Show my name on the leaderboard'),
      ),
      isSemantics(hasCheckedState: true, isChecked: false),
      reason: 'consent is an act, so the box starts empty',
    );
    // A joiner has no board to see yet.
    expect(find.text('Leaderboard'), findsNothing);
  });

  testWidgets('joining sends exactly what was ticked, and the page becomes '
      'the path with Plexa’s ticket', (WidgetTester tester) async {
    final _RecordingJoin repo = _RecordingJoin(FakeContestScenario.notJoined);
    await pumpContestPage(tester, repo: repo);

    await tapVisible(tester, find.text('Join the contest'));
    expect(repo.sent, <bool>[false], reason: 'the box was left empty');
    expect(find.text('DAY 11'), findsOneWidget);
    expect(find.text('WEEK 2 · DAY 11'), findsOneWidget);
    expect(showsMoment(tester, PlexaMomentClip.contestJoined), isTrue);
  });

  testWidgets('ticking the box is the consent that is sent', (
    WidgetTester tester,
  ) async {
    final _RecordingJoin repo = _RecordingJoin(FakeContestScenario.notJoined);
    await pumpContestPage(tester, repo: repo);
    await tapVisible(
      tester,
      find.text('Show my name on the leaderboard').first,
    );
    await tapVisible(tester, find.text('Join the contest'));
    expect(repo.sent, <bool>[true]);
  });

  testWidgets('a join with nothing to join says so in the neutral tone', (
    WidgetTester tester,
  ) async {
    final _RecordingJoin repo = _RecordingJoin(
      FakeContestScenario.notJoined,
      refuse: const ContestNotRunning('There is no contest to join right now.'),
    );
    await pumpContestPage(tester, repo: repo);
    await tapVisible(tester, find.text('Join the contest'));
    expect(find.text('Nothing to join'), findsOneWidget);
    expect(find.text('There is no contest to join right now.'), findsOneWidget);
    expect(find.text('Not joined yet'), findsNothing);
  });

  testWidgets('not joined, upcoming: when it starts', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.upcoming);
    expect(
      find.text('Starts 15 Nov 2026. You can join now or any day it runs.'),
      findsOneWidget,
    );
    expect(find.text('Join the contest'), findsOneWidget);
  });

  testWidgets('not joined, ended: no join card and no board', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(
      tester,
      overrides: <Override>[
        overviewIs(
          ContestOverview(
            contest: info(),
            phase: ContestPhase.ended,
            dayNumber: 101,
            entrants: 1200,
          ),
        ),
      ],
    );
    expect(find.text('This contest has ended'), findsOneWidget);
    expect(find.text('Join the contest'), findsNothing);
    expect(find.text('Leaderboard'), findsNothing);
    expect(showsMoment(tester, PlexaMomentClip.waitingRoom), isTrue);
  });

  testWidgets('joined, ended: the final standings and the finale', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.ended);
    expect(find.text('ENDED'), findsOneWidget);
    expect(
      find.text(
        'Final standings. a profile shoutout goes to the top 10.',
      ),
      findsOneWidget,
    );
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('#14'), findsOneWidget);
    expect(
      find.text(
        'The contest’s last day is 2 Nov 2026. '
        'Your 1000-day roadmap is the bigger goal, and it keeps going after.',
      ),
      findsOneWidget,
    );
    expect(showsMoment(tester, PlexaMomentClip.contestFinale), isTrue);
    expect(find.text('Join the contest'), findsNothing);
  });

  testWidgets('joined, upcoming: when it starts, and the prize still to win', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(
      tester,
      overrides: <Override>[
        overviewIs(
          ContestOverview(
            contest: info(),
            dayNumber: -3,
            board: const BoardReveal(revealsOn: '2027-02-13', revealDay: 91),
            entry: ContestEntryView(
              joinedAt: DateTime.utc(2026, 11, 1),
              freeDaysLeft: 30,
            ),
            entrants: 40,
          ),
        ),
      ],
    );
    expect(find.text('STARTS 15 NOV 2026'), findsOneWidget);
    expect(
      find.text(
        'a profile shoutout for the top 10.',
      ),
      findsOneWidget,
    );
    expect(find.text('Leaderboard hidden for now'), findsOneWidget);
  });

  testWidgets('running: the standing, the week and START on today’s level, '
      'brought into view', (WidgetTester tester) async {
    await pumpContestPage(tester);
    expect(find.text('DAY 11'), findsOneWidget);
    expect(find.text('10'), findsWidgets, reason: 'the streak');
    expect(find.text('1,240 XP'), findsOneWidget);
    expect(find.text('WEEK 2 · DAY 11'), findsOneWidget);
    expect(find.text('WED · DAY 11 · TODAY'), findsOneWidget);
    expect(find.text('SUN · DAY 8'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    // Today's level is several days down the week, and the page opens on it.
    final Rect start = tester.getRect(find.text('START'));
    expect(start.top, greaterThan(0));
    expect(start.bottom, lessThan(667));
    // The rail and the board follow the path.
    for (final String title in <String>[
      'Top 10 win a profile shoutout',
      'Daily quests',
      'This week on LinkedIn',
      'Leaderboard',
    ]) {
      expect(find.text(title), findsWidgets, reason: title);
    }
    expect(find.text('Finish today’s lesson'), findsOneWidget);
    expect(find.text('Scoring paused'), findsNothing);
  });

  testWidgets('the section bar takes the learner to each section', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester);
    Finder tab(String label) => find.descendant(
      of: find.byType(ContestSectionBar),
      matching: find.text(label),
    );
    await tester.tap(tab('Quests'));
    await settle(tester);
    final double quests = tester.getRect(find.text('Daily quests')).top;
    expect(quests, lessThan(200), reason: 'brought to the top');
    await tester.tap(tab('Leaderboard'));
    await settle(tester);
    expect(tester.getRect(find.text('Leaderboard').last).top, lessThan(200));
    await tester.tap(tab('Path'));
    await settle(tester);
    expect(tester.getRect(find.text('WEEK 2 · DAY 11')).top, lessThan(200));
  });

  testWidgets('paused scoring is said above everything', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpContestPage(
      tester,
      scenario: FakeContestScenario.paused,
    );
    expect(find.text('Scoring paused'), findsOneWidget);
    expect(
      find.text(
        'Your 7 free days is over. Lessons stay open, but XP has stopped until you have a plan.',
      ),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('See plans'));
    expect(locationOf(router).path, '/pricing');
  });

  testWidgets('a path that disagrees with the overview says it is not ready, '
      'and the rail says the week is not in', (WidgetTester tester) async {
    await pumpContestPage(
      tester,
      overrides: <Override>[
        contestPathProvider.overrideWith(
          (Ref ref) async =>
              const ContestPath(status: ContestPathStatus.upcoming),
        ),
      ],
    );
    expect(
      find.text('This week’s path is not ready yet. Refresh in a moment.'),
      findsOneWidget,
    );
    expect(find.text('This week is not in yet.'), findsNWidgets(2));
    expect(find.text('START'), findsNothing);
  });

  testWidgets('a path that fails is said in words; the prize and board stay', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(
      tester,
      overrides: <Override>[
        contestPathProvider.overrideWith(
          (Ref ref) async =>
              throw const ContestUnavailable('That did not come through.'),
        ),
      ],
    );
    expect(find.text('Could not load this week'), findsOneWidget);
    expect(
      find.text('Top 10 win a profile shoutout'),
      findsOneWidget,
    );
    expect(find.text('This week is not in yet.'), findsNWidgets(2));
  });

  testWidgets('no state counts the contest’s length', (
    WidgetTester tester,
  ) async {
    final RegExp length = RegExp(
      r'\bDay \d+ of \d+|\b(100|hundred)[- ]?days?\b|\d+-day (contest|challenge)',
      caseSensitive: false,
    );
    for (final FakeContestScenario s in FakeContestScenario.values) {
      FakeContestWorld.reset();
      await pumpContestPage(tester, scenario: s);
      for (final String text in allText(tester)) {
        expect(length.hasMatch(text), isFalse, reason: '$s: "$text"');
      }
    }
  });

  for (final Size size in const <Size>[
    Size(375, 667),
    Size(402, 874),
    Size(430, 932),
  ]) {
    testWidgets('every scenario draws without overflow at ${size.width}', (
      WidgetTester tester,
    ) async {
      for (final FakeContestScenario s in FakeContestScenario.values) {
        FakeContestWorld.reset();
        // settle() fails the test on any exception, overflow included.
        await pumpContestPage(tester, scenario: s, size: size);
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -4000),
        );
        await settle(tester);
      }
    });
  }
}

/// The running scenario's fake, recording every consent the join sends.
class _RecordingJoin extends FakeContestRepository {
  _RecordingJoin(FakeContestScenario scenario, {this.refuse})
    : super(scenario: scenario, latency: Duration.zero);

  final ContestRefusal? refuse;
  final List<bool> sent = <bool>[];

  @override
  Future<void> join({required bool showName}) async {
    sent.add(showName);
    final ContestRefusal? no = refuse;
    if (no != null) throw no;
    return super.join(showName: showName);
  }
}
