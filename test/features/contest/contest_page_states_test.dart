import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/contest_home_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/levels_words.dart';
import 'package:plexaverse/features/contest/presentation/widgets/contest_section_bar.dart';
import 'package:plexaverse/features/contest/presentation/widgets/rail/daily_quests.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_moment.dart';
import 'package:plexaverse/features/settings/data/settings_repositories.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';

import 'contest_home_harness.dart';

/// `/contest` — the learner's levels — in every state its overview and its
/// path can put it in, at the narrowest phone the app ships on.
///
/// Each state is the web's `ContestClient` branch of the same name, and
/// says the web's words. The fakes play the server; where a state needs an
/// overview no scenario has (a contest that ended without you), the read is
/// stood in directly.
void main() {
  setUp(FakeContestWorld.reset);

  ContestInfo info() => ContestInfo(
    id: 'c1',
    title: 'Levels · Nov 2026–Feb 2027',
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
    expect(find.bySemanticsLabel('Loading your levels'), findsOneWidget);
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
    expect(find.text('Could not load your levels'), findsOneWidget);
    expect(
      find.text('No connection. Check your network and try again.'),
      findsOneWidget,
    );
    expect(showsMoment(tester, PlexaMomentClip.oopsWrench), isTrue);
    await tester.tap(find.text('Try again'));
    await settle(tester);
    expect(reads, 2, reason: 'Try again reads the overview again');
  });

  testWidgets('no round: new levels are on the way, and the way back', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpContestPage(
      tester,
      scenario: FakeContestScenario.noContest,
    );
    expect(find.text('New levels are on the way'), findsOneWidget);
    expect(
      find.text(
        'Levels reset every 3 months, and the next round starts soon. Your roadmap carries on as usual.',
      ),
      findsOneWidget,
    );
    expect(showsMoment(tester, PlexaMomentClip.waitingRoom), isTrue);
    // No round, so no last day to name.
    expect(
      find.text(
        'Your 1000-day roadmap is the bigger goal, and it keeps going.',
      ),
      findsOneWidget,
    );
    // The last round's result lives in the Hall of Fame card.
    expect(find.text('Hall of Fame'), findsOneWidget);
    await tapVisible(tester, find.text('Back to your roadmap'));
    expect(locationOf(router).path, '/roadmap');
  });

  // Owner, 24 Nov 2026: no join card. Deliberately replaces the join card's
  // tests — reading the levels enters the learner, so the page a new
  // learner sees is the path itself.
  testWidgets('a learner new to the round: reading enters them, and the page '
      'is the path with Plexa’s ticket — no join step', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.notJoined);
    expect(find.text('DAY 11'), findsOneWidget);
    expect(find.text('WEEK 2 · DAY 11'), findsOneWidget);
    expect(find.text('Your levels'), findsOneWidget);
    expect(showsMoment(tester, PlexaMomentClip.contestJoined), isTrue);
    for (final String text in allText(tester)) {
      expect(text.toLowerCase().contains('join the'), isFalse, reason: text);
    }
  });

  testWidgets('the name switch is asked in context, starts off, and a tap '
      'is the consent, recorded in context', (WidgetTester tester) async {
    final _Consents consents = _Consents();
    await pumpContestPage(
      tester,
      scenario: FakeContestScenario.notJoined,
      overrides: <Override>[
        settingsRepositoryProvider.overrideWithValue(consents),
      ],
    );
    final Finder toggle = find.byWidgetPredicate(
      (Widget w) => w is ZaveSwitch && w.semanticLabel == kNameToggleLabel,
    );
    await Scrollable.ensureVisible(tester.element(toggle), alignment: 0.5);
    await settle(tester);
    expect(find.text(kNameToggleDetail), findsOneWidget);
    expect(
      tester.widget<ZaveSwitch>(toggle).value,
      isFalse,
      reason: 'consent is an act, so the switch starts off',
    );
    await tester.tap(toggle);
    await settle(tester);
    expect(consents.sent, <(String, bool, bool)>[
      ('contest_leaderboard', true, true),
    ]);
  });

  testWidgets('upcoming: you are in, and when Level 1 opens', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.upcoming);
    expect(find.text('OPENS 15 NOV 2026'), findsOneWidget);
    expect(
      find.text(
        'Level 1 opens on 15 Nov 2026. You are in: there is nothing to join.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('an ended round is never a page of its own: new levels are on '
      'the way, and its result is the Hall of Fame card', (
    WidgetTester tester,
  ) async {
    await pumpContestPage(tester, scenario: FakeContestScenario.ended);
    expect(find.text('New levels are on the way'), findsOneWidget);
    expect(find.text('Top learners'), findsNothing);
    expect(find.text('Hall of Fame'), findsOneWidget);
    expect(find.text('The round that ended 2 November 2026'), findsOneWidget);
    expect(showsMoment(tester, PlexaMomentClip.waitingRoom), isTrue);
  });

  testWidgets('running with no entry: the entry could not be made, and Try '
      'again reads again', (WidgetTester tester) async {
    int reads = 0;
    await pumpContestPage(
      tester,
      overrides: <Override>[
        contestOverviewProvider.overrideWith((Ref ref) async {
          reads++;
          return ContestOverview(
            contest: info(),
            phase: ContestPhase.running,
            dayNumber: 3,
          );
        }),
      ],
    );
    expect(find.text('Your levels are not ready yet'), findsOneWidget);
    expect(
      find.text('We could not open your levels just now.'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Try again'));
    expect(reads, 2);
  });

  testWidgets('entered, upcoming: when it opens, and the top learners hidden', (
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
    expect(find.text('OPENS 15 NOV 2026'), findsOneWidget);
    expect(find.text('Your levels'), findsOneWidget);
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
      'Top learners',
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
    await tester.tap(tab('Top learners'));
    await settle(tester);
    expect(tester.getRect(find.text('Top learners').last).top, lessThan(200));
    await tester.tap(tab('Path'));
    await settle(tester);
    expect(tester.getRect(find.text('WEEK 2 · DAY 11')).top, lessThan(200));
  });

  // Review of 24 Nov 2026 (FL1): there is no join card any more, and a learner
  // entered automatically never sees onboarding's step — so while the free
  // days run, the page itself says XP needs a plan after them (the web's
  // FreeDaysLine, word for word).
  group('the paid condition, while the free days run', () {
    testWidgets('said above the path, in the web’s words', (
      WidgetTester tester,
    ) async {
      await pumpContestPage(tester, repo: _FreeDaysLeft(12));
      expect(
        find.text(
          '12 free days of XP left in this round. After that, XP counts only '
          'while you have a Plexaverse plan — the lessons stay open either way.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('free-days-line')),
        findsOneWidget,
      );
      expect(find.text('Scoring paused'), findsNothing);
    });

    testWidgets('“1 free day”, singular', (WidgetTester tester) async {
      await pumpContestPage(tester, repo: _FreeDaysLeft(1));
      expect(freeDaysLine(1), startsWith('1 free day of XP left'));
      expect(find.text(freeDaysLine(1)), findsOneWidget);
    });

    testWidgets('gone once the days are used up', (WidgetTester tester) async {
      await pumpContestPage(tester, repo: _FreeDaysLeft(0));
      expect(
        find.byKey(const ValueKey<String>('free-days-line')),
        findsNothing,
      );
    });

    testWidgets('never beside the paused notice', (WidgetTester tester) async {
      await pumpContestPage(tester, scenario: FakeContestScenario.paused);
      expect(find.text('Scoring paused'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('free-days-line')),
        findsNothing,
      );
    });
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
    expect(find.text('Top 10 win a profile shoutout'), findsOneWidget);
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

/// The consent ledger, recording every decision sent: (purpose, granted,
/// in context).
class _Consents extends FakeSettingsRepository {
  final List<(String, bool, bool)> sent = <(String, bool, bool)>[];

  @override
  Future<ConsentLedger> setConsent({
    required String purpose,
    required bool granted,
    bool inContext = false,
  }) {
    sent.add((purpose, granted, inContext));
    return super.setConsent(
      purpose: purpose,
      granted: granted,
      inContext: inContext,
    );
  }
}

/// The running fake, with the entry's free days left set by the test.
class _FreeDaysLeft extends FakeContestRepository {
  _FreeDaysLeft(this.left) : super(latency: Duration.zero);

  final int left;

  @override
  Future<ContestOverview?> fetchOverview() async {
    final ContestOverview? o = await super.fetchOverview();
    final ContestEntryView? e = o?.entry;
    if (o == null || e == null) return o;
    return o.copyWith(entry: e.copyWith(freeDaysLeft: left));
  }
}
