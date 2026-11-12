import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/lesson_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/contest_words.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_lesson_page.dart';
import 'package:plexaverse/features/contest/presentation/widgets/lesson/choice_view.dart';

/// `/contest/lesson`, every screen it can show, at the narrowest phone the
/// app ships on — in the web's words.
///
/// The running lesson plays against the mock flavor's own server
/// ([FakeContestRepository]), which grades as the real one does; the other
/// states are stood up by hand, because each is one answer from the server
/// and nothing more.
void main() {
  setUp(FakeContestWorld.reset);

  group('before there is a lesson', () {
    testWidgets('while the day opens: the player in outline, saying what it '
        'waits for, with the way out', (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      final Completer<void> open = Completer<void>();
      await _pump(tester, _Stub(quiz: _finished(), hold: open));

      expect(
        find.bySemanticsLabel('Getting today’s lesson ready'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Leave the lesson'), findsOneWidget);
      expect(tester.takeException(), isNull);

      open.complete();
      await _settle(tester);
      semantics.dispose();
    });

    testWidgets('could not load: one sentence, and a way to try again', (
      WidgetTester tester,
    ) async {
      final _Stub stub = _Stub(
        fail: const ContestUnavailable(
          'No connection. Check your network and try again.',
        ),
      );
      await _pump(tester, stub);

      expect(find.text('Could not load today’s lesson'), findsOneWidget);
      expect(
        find.text('No connection. Check your network and try again.'),
        findsOneWidget,
      );
      expect(find.text('Back to the contest'), findsOneWidget);
      expect(tester.takeException(), isNull);

      stub
        ..fail = null
        ..quiz = _finished();
      await _tap(tester, find.text('Try again'));
      expect(find.text('Could not load today’s lesson'), findsNothing);
    });

    final Map<String, (TodayQuiz, String, String)>
    statuses = <String, (TodayQuiz, String, String)>{
      'no contest': (
        const TodayQuiz(
          status: QuizStatus.noContest,
          reason: QuizReason.noContest,
        ),
        'No contest right now',
        'The daily lesson runs inside a contest. The next one will show up on the contest page.',
      ),
      'an entrant before day 1': (
        const TodayQuiz(
          status: QuizStatus.upcoming,
          reason: QuizReason.notStarted,
        ),
        'Not open yet',
        'The daily lesson opens on day 1 of the contest.',
      ),
      'ended': (
        const TodayQuiz(
          status: QuizStatus.ended,
          reason: QuizReason.contestEnded,
        ),
        'The contest has ended',
        'The daily lesson closed with it. The final standings are on the contest page.',
      ),
      'the band’s questions ran out': (
        const TodayQuiz(
          status: QuizStatus.noQuizToday,
          reason: QuizReason.bankEnded,
          day: 51,
          tomorrow: false,
        ),
        'No lesson today',
        'The lesson questions for your level have run out, so there is no lesson today.',
      ),
      'no lesson at this level': (
        const TodayQuiz(status: QuizStatus.noQuizToday, day: 51),
        'No lesson today',
        'There is no lesson at your level today.',
      ),
      'a status this build does not know': (
        const TodayQuiz(status: QuizStatus.ready, day: 11),
        'No lesson today',
        'There is no lesson at your level today.',
      ),
    };
    for (final MapEntry<String, (TodayQuiz, String, String)> s
        in statuses.entries) {
      testWidgets('${s.key}: the web’s words, and the way back', (
        WidgetTester tester,
      ) async {
        final (TodayQuiz quiz, String title, String line) = s.value;
        await _pump(tester, _Stub(quiz: quiz, fail: const ContestNotRunning()));

        expect(find.text(title), findsOneWidget);
        expect(find.text(line), findsOneWidget);
        expect(find.text('Back to the contest'), findsOneWidget);
        expect(find.text('See the contest'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('not joined, while it runs: join and the lesson opens at once', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        FakeContestRepository(
          scenario: FakeContestScenario.notJoined,
          latency: Duration.zero,
        ),
      );

      expect(find.text('Join the contest first'), findsOneWidget);
      expect(
        find.text(
          'The daily lesson is for entrants. Joining is free, and the lesson opens straight away.',
        ),
        findsOneWidget,
      );
      await _tap(tester, find.text('See the contest'));
      expect(find.text('THE PATH'), findsOneWidget);
    });

    testWidgets('not joined, before it starts: day 1’s date, as the contest '
        'counts it', (WidgetTester tester) async {
      await _pump(
        tester,
        FakeContestRepository(
          scenario: FakeContestScenario.upcoming,
          latency: Duration.zero,
        ),
      );

      expect(find.text('Join the contest first'), findsOneWidget);
      expect(
        find.text(
          'The daily lesson is for entrants. Joining is free, and the lesson opens on day 1 of the contest, 15 Nov 2026.',
        ),
        findsOneWidget,
      );
    });
  });

  group('the questions', () {
    testWidgets('the first unanswered question, in the web’s words; Check '
        'sends the pick and the verdict is the server’s', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _running());

      // Seven answered on an earlier visit: the eighth, in part 2.
      expect(
        find.text('VOCABULARY · QUESTION 8 OF 15 · PART 2 OF 3'),
        findsOneWidget,
      );
      expect(find.text('A “stakeholder” is someone who ___.'), findsOneWidget);
      expect(find.text('For your work'), findsNothing);
      expect(find.text('CHECK'), findsOneWidget);

      await _tap(
        tester,
        find.text('has an interest in how a project turns out'),
      );
      await _tap(tester, find.text('CHECK'));

      expect(find.text('Nicely done.'), findsOneWidget);
      expect(
        find.text(
          'A stakeholder is anyone affected by, or interested in, the outcome.',
        ),
        findsOneWidget,
      );
      expect(find.text('+12 XP'), findsOneWidget);
      expect(find.text('3 IN A ROW'), findsOneWidget);

      // The next one was written for the learner's own work.
      await _tap(tester, find.text('CONTINUE'));
      expect(
        find.text('GRAMMAR · QUESTION 9 OF 15 · PART 2 OF 3'),
        findsOneWidget,
      );
      expect(find.text('For your work'), findsOneWidget);

      await _tap(
        tester,
        find.text('We have shipped the first version last week.'),
      );
      await _tap(tester, find.text('CHECK'));
      expect(find.text('Not quite.'), findsOneWidget);
      expect(
        find.textContaining('We shipped the first version last week.'),
        findsWidgets,
      );
      expect(find.text('−2 XP'), findsOneWidget);
      expect(find.text('3 IN A ROW'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a checkpoint between parts, in the web’s words', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _running());

      // The rest of part 2, right.
      for (final String right in <String>[
        'has an interest in how a project turns out',
        'We shipped the first version last week.',
        'approves',
      ]) {
        await _tap(tester, find.text(right));
        await _tap(tester, find.text('CHECK'));
        await _tap(tester, find.text('CONTINUE'));
      }

      expect(find.text('Checkpoint 2 of 3 done'), findsOneWidget);
      expect(find.text('5 of 5 right in this part'), findsOneWidget);
      expect(
        find.text(
          'Part 3 has 5 questions. Your answers are saved — finish all 3 parts to complete the day.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _tap(tester, find.text('KEEP GOING'));
      expect(find.text('Checkpoint 2 of 3 done'), findsNothing);
      expect(
        find.text('SAYING IT AT WORK · QUESTION 11 OF 15 · PART 3 OF 3'),
        findsOneWidget,
      );
    });

    testWidgets('scoring paused: said over a question still to answer, and '
        'an answer given then reads "Not scored."', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        FakeContestRepository(
          scenario: FakeContestScenario.paused,
          latency: Duration.zero,
        ),
      );

      expect(find.text('Scoring paused'), findsOneWidget);
      expect(find.text(kQuizPausedLine), findsOneWidget);

      await _tap(
        tester,
        find.text('has an interest in how a project turns out'),
      );
      await _tap(tester, find.text('CHECK'));

      expect(find.text('Scoring paused'), findsNothing);
      expect(find.text('Not scored.'), findsOneWidget);
    });

    testWidgets('✕ leaves the lesson for the contest', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await _pump(tester, _running());

      await _tap(tester, find.bySemanticsLabel('Leave the lesson'));
      expect(find.text('THE PATH'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('the colours are the server’s verdict, not a guess', (
      WidgetTester tester,
    ) async {
      // The learner picked "b"; the server says it was wrong and "c" is
      // right. Nothing here may decide otherwise.
      final SemanticsHandle semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChoiceView(
              prompt: 'Pick one.',
              options: <String>['a', 'b', 'c', 'd'],
              picked: null,
              verdict: LessonAnswer(
                value: 'b',
                correct: false,
                correctOption: 'c',
                explain: '',
              ),
              onPick: null,
            ),
          ),
        ),
      );

      expect(tester.getSemantics(find.text('c')).value, 'Right answer');
      expect(tester.getSemantics(find.text('b')).value, 'Your answer');
      expect(tester.getSemantics(find.text('a')).value, isEmpty);
      semantics.dispose();
    });
  });

  group('every width the app ships on', () {
    const Map<String, Size> sizes = <String, Size>{
      'iPhone SE': Size(375, 667),
      'iPhone 16 Pro': Size(402, 874),
      'iPhone Pro Max': Size(430, 932),
    };
    final Map<String, ContestRepository Function()> screens =
        <String, ContestRepository Function()>{
          'a question': _running,
          'paused': () => FakeContestRepository(
            scenario: FakeContestScenario.paused,
            latency: Duration.zero,
          ),
          'the score': () => _Stub(
            quiz: _finished(right: 7),
            overview: _overview(streak: 10),
            path: const ContestPath(
              weekReward: WeekReward(points: 500, earned: true, paid: 500),
            ),
          ),
          'not joined': () => FakeContestRepository(
            scenario: FakeContestScenario.upcoming,
            latency: Duration.zero,
          ),
          'could not load': () =>
              _Stub(fail: const ContestUnavailable('No connection.')),
        };
    for (final MapEntry<String, Size> size in sizes.entries) {
      for (final MapEntry<String, ContestRepository Function()> screen
          in screens.entries) {
        testWidgets('${screen.key} at ${size.key}', (
          WidgetTester tester,
        ) async {
          await _pump(tester, screen.value(), size: size.value);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('the score', () {
    testWidgets('the day done: the count, the lesson’s XP, the streak, what '
        'was learnt, and the way on', (WidgetTester tester) async {
      await _pump(
        tester,
        _Stub(
          quiz: _finished(),
          overview: _overview(streak: 10),
          path: const ContestPath(
            weekReward: WeekReward(points: 500, earned: true, paid: 500),
          ),
        ),
      );

      expect(find.text('TODAY’S LESSON · DONE'), findsOneWidget);
      expect(find.text('12 of 15 right'), findsOneWidget);
      expect(find.text('Day 11 lesson · B1'), findsOneWidget);
      expect(find.text('XP from today’s lesson'), findsOneWidget);
      // 12 right at 12, 3 wrong at −4, and the finishing bonus.
      expect(find.text('+152'), findsOneWidget);
      expect(find.text('Week complete! +500 XP'), findsOneWidget);
      expect(find.text('Day 10 streak'), findsOneWidget);
      expect(find.text('What you learnt today'), findsOneWidget);
      expect(find.text('Review these (3)'), findsOneWidget);
      expect(find.text('You got these (12)'), findsOneWidget);
      expect(find.text('Back to the path'), findsOneWidget);
      expect(
        find.text(
          'A new lesson tomorrow. Pick a question above to read its answer again.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('short of the bonus bar, it says what the bonus needs', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _Stub(quiz: _finished(right: 7)));

      expect(find.text('7 of 15 right'), findsOneWidget);
      expect(
        find.text('No bonus for finishing today: it needs 9 right.'),
        findsOneWidget,
      );
      expect(find.text('Week complete! +500 XP'), findsNothing);
    });

    testWidgets('every answer given while paused: not scored, and where the '
        'plans are', (WidgetTester tester) async {
      await _pump(tester, _Stub(quiz: _finished(paid: false, paused: true)));

      expect(find.text('Not scored'), findsOneWidget);
      expect(find.text(kQuizUnscoredLine), findsOneWidget);
      expect(find.text('XP from today’s lesson'), findsNothing);
      await _tap(tester, find.text('See plans'));
      expect(find.text('PLANS'), findsOneWidget);
    });

    testWidgets('an answered question opens again from the steps, revealed', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await _pump(tester, _Stub(quiz: _finished()));

      await _tap(tester, find.bySemanticsLabel('Question 2, wrong'));
      expect(find.text('Not quite.'), findsOneWidget);
      expect(find.text('FINISH'), findsNothing);
      expect(find.text('CONTINUE'), findsOneWidget);
      semantics.dispose();
    });
  });
}

/// The mock flavor's running contest: today's lesson half done.
FakeContestRepository _running() =>
    FakeContestRepository(latency: Duration.zero);

Future<GoRouter> _pump(
  WidgetTester tester,
  ContestRepository repo, {
  Size size = const Size(375, 667),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final GoRouter router = GoRouter(
    initialLocation: ZaveRoutes.contestLesson,
    routes: <RouteBase>[
      GoRoute(
        path: ZaveRoutes.contest,
        builder: (_, _) => const Scaffold(body: Text('THE PATH')),
      ),
      GoRoute(
        path: ZaveRoutes.contestLesson,
        builder: (_, _) => const ContestLessonPage(),
      ),
      GoRoute(
        path: ZaveRoutes.pricing,
        builder: (_, _) => const Scaffold(body: Text('PLANS')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[contestRepositoryProvider.overrideWithValue(repo)],
      // As the app's container: a failed read stays failed.
      retry: (int retryCount, Object error) => null,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await _settle(tester);
  return router;
}

/// Every answer crosses a few frames — a future, a rebuild, a still. Pumped
/// in steps rather than settled: the outline shimmers, and a shimmer never
/// settles.
Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 30));
  }
}

/// Scroll it to the middle of the screen, then tap it: the result bar sits
/// over the foot of the question.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder.first), alignment: 0.5);
  await tester.pump();
  await tester.tap(finder.first);
  await _settle(tester);
}

/// A finished day of fifteen: [right] of them right, each paid unless
/// [paid] is false.
TodayQuiz _finished({int right = 12, bool paid = true, bool paused = false}) {
  final List<PublicQuizItem> questions = <PublicQuizItem>[
    for (int i = 0; i < 15; i++)
      PublicQuizItem(
        id: i % 3 == 2 ? 'ai-11-${i ~/ 3 + 1}' : 'qz-b1-${i + 1}',
        skill: QuizSkill.values[i % 4],
        prompt: 'Question ${i + 1}',
        options: <String>['a$i', 'b$i', 'c$i', 'd$i'],
      ),
  ];
  // The wrong ones on the even questions first — 2, 4, 6 … — so the steps
  // have a wrong answer to reopen near the top.
  final Set<int> wrong = <int>[
    for (int i = 1; i < 15; i += 2) i,
    for (int i = 0; i < 15; i += 2) i,
  ].take(15 - right).toSet();
  return TodayQuiz(
    status: QuizStatus.ready,
    day: 11,
    band: 'B1',
    started: true,
    tomorrow: true,
    ownQuestions: 5,
    questions: questions,
    answered: <QuizAnswerView>[
      for (int i = 0; i < 15; i++)
        QuizAnswerView(
          itemId: questions[i].id,
          value: wrong.contains(i) ? 'a$i' : 'b$i',
          correct: !wrong.contains(i),
          correctOption: 'b$i',
          explain: 'Why b$i.',
          pointsApplied: paid ? (wrong.contains(i) ? -4 : 12) : null,
        ),
    ],
    completed: true,
    score: QuizScore(
      correct: right,
      wrong: 15 - right,
      points: paid ? right * 12 - (15 - right) * 4 + (right >= 9 ? 20 : 0) : 0,
    ),
    finishBonus: const FinishBonus(points: 20, minCorrect: 9),
    scoringPaused: paused,
  );
}

ContestOverview _overview({required int streak}) => ContestOverview(
  contest: ContestInfo(
    startsAt: DateTime.utc(2026, 10, 31, 18, 30),
    endsAt: DateTime.utc(2027, 2, 8, 18, 30),
    firstDayKey: '2026-11-01',
    lastDayKey: '2027-02-08',
  ),
  phase: ContestPhase.running,
  dayNumber: 11,
  entry: ContestEntryView(
    joinedAt: DateTime.utc(2026, 11, 1, 4),
    streak: streak,
  ),
);

/// One answer from the server for each read the page makes.
class _Stub implements ContestRepository {
  _Stub({
    this.quiz,
    this.overview,
    this.path = const ContestPath(),
    this.fail,
    this.hold,
  });

  TodayQuiz? quiz;
  ContestOverview? overview;
  ContestPath path;

  /// Every read and the open refuse with this.
  Object? fail;

  /// The open waits on this.
  Completer<void>? hold;

  @override
  Future<TodayQuiz> startLesson() async {
    final Completer<void>? h = hold;
    if (h != null) await h.future;
    final Object? f = fail;
    if (f != null) throw f;
    return quiz!;
  }

  @override
  Future<TodayQuiz> fetchTodayQuiz() async {
    final Object? f = fail;
    if (f != null && f is! ContestNotRunning) throw f;
    return quiz!;
  }

  @override
  Future<ContestOverview?> fetchOverview() async => overview;

  @override
  Future<ContestPath> fetchPath() async => path;

  @override
  Future<BoardResult> fetchBoard({int? limit}) async => const BoardResult();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}
