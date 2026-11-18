import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/application/lesson_controllers.dart';
import 'package:plexaverse/features/contest/application/skip_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/domain/lesson_parts.dart';

/// The lesson as one visit plays it: the open, the order, the reveal, and
/// the three ways a lesson can move under the learner.
///
/// Each rule here is one the server does NOT enforce, or one it enforces in
/// a way the player has to answer correctly:
///   * an answer that lands before the open fixes the day to the set
///     questions for good, and the server will happily take it;
///   * within a part the questions are answered in order, and a part the
///     learner skipped stays open beside the next (the server refuses a
///     locked part with LOCKED);
///   * a replay is the RECORDED answer, which may not be the pick;
///   * STALE_QUIZ and NOT_TODAY are both "the questions on screen are not
///     today's any more", and each has its own cure.
void main() {
  group('the open', () {
    test(
      'is sent once, and nothing can be answered until it has landed',
      () async {
        final _Server server = _Server()..holdOpen = Completer<void>();
        final ProviderContainer c = _container(server);
        c.listen(lessonRunProvider, (_, _) {});
        await pumpEventQueue();

        expect(c.read(lessonRunProvider).isLoading, isTrue);
        expect(c.read(lessonRunProvider).work, LessonWork.opening);
        await c.read(lessonRunProvider.notifier).answer('b0');
        expect(server.answers, isEmpty, reason: 'answered before the open');

        server.holdOpen!.complete();
        await pumpEventQueue();
        expect(c.read(lessonRunProvider).at, const AtQuestion(0));

        await c.read(lessonRunProvider.notifier).answer('b0');
        expect(server.calls.first, 'open');
        expect(server.answers, <String>['11:qz-b1-1=b0']);
        expect(server.calls.where((String x) => x == 'open'), hasLength(1));
      },
    );

    test('leaving mid-open and coming straight back does not open again — '
        'a second open is a second model call', () async {
      final _Server server = _Server()..holdOpen = Completer<void>();
      final ProviderContainer c = _container(server);
      final ProviderSubscription<LessonRunState> first = c.listen(
        lessonRunProvider,
        (_, _) {},
      );
      await pumpEventQueue();
      first.close();
      await pumpEventQueue();
      c.listen(lessonRunProvider, (_, _) {});
      await pumpEventQueue();
      server.holdOpen!.complete();
      await pumpEventQueue();

      expect(server.calls.where((String x) => x == 'open'), hasLength(1));
      expect(c.read(lessonRunProvider).questions, hasLength(15));
    });

    test('a new visit opens again, once the last one has gone', () async {
      final _Server server = _Server();
      final ProviderContainer c = _container(server);
      final ProviderSubscription<LessonRunState> visit = c.listen(
        lessonRunProvider,
        (_, _) {},
      );
      await pumpEventQueue();
      visit.close();
      await pumpEventQueue();
      c.listen(lessonRunProvider, (_, _) {});
      await pumpEventQueue();

      expect(server.calls.where((String x) => x == 'open'), hasLength(2));
    });

    test(
      'a refused open falls back to the read, which decides the screen',
      () async {
        final _Server server = _Server()
          ..status = QuizStatus.notJoined
          ..refuseOpen = const ContestNotEntered();
        final ProviderContainer c = _container(server);
        c.listen(lessonRunProvider, (_, _) {});
        await pumpEventQueue();

        expect(server.calls, <String>['open', 'read']);
        expect(c.read(lessonRunProvider).quiz?.status, QuizStatus.notJoined);
        expect(c.read(lessonRunProvider).loadError, isNull);
      },
    );

    test('a failed open with a working read: the set questions are the '
        'lesson, and a model hiccup never costs the day', () async {
      final _Server server = _Server()
        ..refuseOpen = const ContestUnavailable('That did not come through.');
      final ProviderContainer c = _container(server);
      c.listen(lessonRunProvider, (_, _) {});
      await pumpEventQueue();

      expect(c.read(lessonRunProvider).questions, hasLength(15));
      expect(c.read(lessonRunProvider).at, const AtQuestion(0));
    });

    test(
      'neither the open nor the read: one sentence, and Try again opens again',
      () async {
        final _Server server = _Server()
          ..refuseOpen = const ContestUnavailable('No connection.')
          ..refuseRead = const ContestUnavailable(
            'No connection. Check your network and try again.',
          );
        final ProviderContainer c = _container(server);
        c.listen(lessonRunProvider, (_, _) {});
        await pumpEventQueue();

        expect(
          c.read(lessonRunProvider).loadError,
          'No connection. Check your network and try again.',
        );

        server
          ..refuseOpen = null
          ..refuseRead = null;
        c.read(lessonRunProvider.notifier).retry();
        expect(c.read(lessonRunProvider).isLoading, isTrue);
        await pumpEventQueue();

        expect(c.read(lessonRunProvider).questions, hasLength(15));
        expect(server.calls.where((String x) => x == 'open'), hasLength(2));
      },
    );
  });

  group('answering', () {
    // Restated for Skip (17 Nov 2026): "the first unanswered question" is
    // now "the next to answer in a part that is open or skipped". With no
    // part skipped the two are the same question, so the expectations hold.
    test('in order within a part: only its next question to answer, as its '
        'option TEXT, with the day it was loaded for', () async {
      // Questions 1 and 3 were answered on another device — out of order.
      final _Server server = _Server()
        ..record('qz-b1-1', 'b0')
        ..record('qz-b1-3', 'a2');
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);

      expect(c.read(lessonRunProvider).firstUnanswered, 1);
      expect(c.read(lessonRunProvider).at, const AtQuestion(1));
      expect(c.read(lessonRunProvider).isReachable(3), isFalse);

      // A question not reached yet does not open.
      run.go(const AtQuestion(3));
      expect(c.read(lessonRunProvider).at, const AtQuestion(1));

      // An answered one does, revealed — and nothing can be sent from it.
      run.go(const AtQuestion(2));
      expect(c.read(lessonRunProvider).at, const AtQuestion(2));
      run.pick('b2');
      await run.answer('b2');
      expect(server.answers, isEmpty);

      run.go(const AtQuestion(1));
      run.pick('c1');
      expect(c.read(lessonRunProvider).pickFor('qz-b1-2'), 'c1');
      await run.answer('c1');
      expect(server.answers, <String>['11:qz-b1-2=c1']);
    });

    test('the reveal is the reply; a replay shows the RECORDED answer, not '
        'the pick', () async {
      // Answered on another device after this one loaded the lesson.
      final _Server server = _Server()..elsewhere['qz-b1-1'] = 'd0';
      final ProviderContainer c = await _opened(server);

      await c.read(lessonRunProvider.notifier).answer('b0');
      final LessonAnswer shown = c.read(lessonRunProvider).answers['qz-b1-1']!;

      expect(shown.value, 'd0');
      expect(shown.correct, isFalse);
      expect(shown.correctOption, 'b0');
      expect(shown.pointsApplied, -4);
      expect(shown.completed, isFalse);
      expect(shown.bonus, isNull);
    });

    test(
      'an answer recorded while scoring was paused reads "Not scored."',
      () async {
        final _Server server = _Server()..paused = true;
        final ProviderContainer c = await _opened(server);

        await c.read(lessonRunProvider.notifier).answer('b0');
        final LessonAnswer shown = c
            .read(lessonRunProvider)
            .answers['qz-b1-1']!;

        expect(shown.pointsApplied, isNull);
        expect(lessonPointsLine(shown), 'Not scored.');
      },
    );

    test('Check pins the reveal: the screen stays on the answered question '
        'until Continue', () async {
      final ProviderContainer c = await _opened(_Server());
      final LessonRun run = c.read(lessonRunProvider.notifier);

      await run.answer('b0');
      await pumpEventQueue();
      expect(c.read(lessonRunProvider).firstUnanswered, 1);
      expect(c.read(lessonRunProvider).at, const AtQuestion(0));

      run.next();
      expect(c.read(lessonRunProvider).at, const AtQuestion(1));
    });

    test('STALE_QUIZ re-reads the lesson and says the questions were '
        'updated — not an error', () async {
      final _Server server = _Server();
      final ProviderContainer c = await _opened(server);
      // A placement moved the band after the lesson loaded.
      server.band = 'a2';

      await c.read(lessonRunProvider.notifier).answer('b0');
      final LessonRunState s = c.read(lessonRunProvider);

      expect(server.calls.last, 'read');
      expect(s.redrawn, isTrue);
      expect(s.problem, isNull);
      expect(s.work, isNull);
      expect(s.questions.first.id, 'qz-a2-1');
      expect(s.at, const AtQuestion(0));
    });

    test('NOT_TODAY OPENS the new day: read alone, its first answer would '
        'fix it to the set questions', () async {
      final _Server server = _Server();
      final ProviderContainer c = await _opened(server);
      // Midnight passed with the lesson open.
      server
        ..day = 12
        ..opened = false;

      await c.read(lessonRunProvider.notifier).answer('b0');
      await pumpEventQueue();

      expect(server.calls.where((String x) => x == 'open'), hasLength(2));
      expect(c.read(lessonRunProvider).quiz?.day, 12);
      expect(c.read(lessonRunProvider).quiz?.started, isTrue);
      expect(c.read(lessonRunProvider).at, const AtQuestion(0));
    });

    test('any other refusal stays with its question, and the lesson is '
        're-read', () async {
      final _Server server = _Server()
        ..refuseAnswer = const ContestConflict(
          'That answer collided with another. Reload and try again.',
        );
      final ProviderContainer c = await _opened(server);

      await c.read(lessonRunProvider.notifier).answer('b0');
      final LessonRunState s = c.read(lessonRunProvider);

      expect(
        s.problemFor('qz-b1-1'),
        'That answer collided with another. Reload and try again.',
      );
      expect(s.problemFor('qz-b1-2'), isNull);
      expect(server.calls.last, 'read');
      expect(s.work, isNull);
    });

    test('an answer whose reply was lost shows as answered once the re-read '
        'is in', () async {
      final _Server server = _Server()
        ..loseReply = true
        ..refuseAnswer = const ContestUnavailable('That did not come through.');
      final ProviderContainer c = await _opened(server);

      await c.read(lessonRunProvider.notifier).answer('b0');
      final LessonRunState s = c.read(lessonRunProvider);

      expect(s.answers['qz-b1-1']?.correct, isTrue);
      expect(s.at, const AtQuestion(0));
    });

    test('a landed answer re-reads the standing it moved', () async {
      final _Server server = _Server();
      final ProviderContainer c = await _opened(server);
      c.listen(contestOverviewProvider, (_, _) {});
      await pumpEventQueue();
      expect(server.overviewReads, 1);

      await c.read(lessonRunProvider.notifier).answer('b0');
      await pumpEventQueue();

      expect(server.overviewReads, 2);
    });
  });

  group('skipped parts', () {
    test('a skipped part opens beside the open one, each at its next '
        'question to answer', () async {
      final _Server server = _Server()
        ..dayKey = '2026-11-11'
        ..skipped.add(1);
      final ProviderContainer c = await _opened(server);
      final LessonRunState s = c.read(lessonRunProvider);

      // A plain visit opens on the open part, not the skipped one.
      expect(s.at, const AtQuestion(5));
      expect(s.isReachable(0), isTrue);
      expect(s.isReachable(1), isFalse);
      expect(s.isReachable(5), isTrue);
      expect(s.isReachable(6), isFalse);
      expect(s.isReachable(10), isFalse);

      final LessonRun run = c.read(lessonRunProvider.notifier);
      run.go(const AtQuestion(0));
      expect(c.read(lessonRunProvider).at, const AtQuestion(0));
      await run.answer('b0');
      expect(server.answers, <String>['11:qz-b1-1=b0']);
    });

    test('?part=k opens that part when it is skipped', () async {
      final _Server server = _Server()
        ..dayKey = '2026-11-11'
        ..skipped.add(1);
      final ProviderContainer c = _container(server);
      c.listen(lessonRunProvider, (_, _) {});
      c.read(lessonRunProvider.notifier).request(1);
      await pumpEventQueue();
      expect(c.read(lessonRunProvider).at, const AtQuestion(0));
      // A part that is neither open nor skipped is not opened for asking.
      c.read(lessonRunProvider.notifier).request(3);
      await pumpEventQueue();
      expect(c.read(lessonRunProvider).at, const AtQuestion(5));
    });

    test('skipping the open part opens the next, and the guard holds the '
        'next Skip back', () async {
      final _Server server = _Server()..dayKey = '2026-11-11';
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);

      expect(await run.skipPart(1), isNull);
      expect(server.calls, contains('skip:2026-11-11:lesson:1'));
      final LessonRunState s = c.read(lessonRunProvider);
      expect(s.quiz!.skippedParts, <int>[1]);
      expect(s.at, const AtQuestion(5));
      expect(s.work, isNull);
      expect(c.read(skipCooldownProvider), isTrue);

      // Within the guard's window a second Skip sends nothing.
      expect(await run.skipPart(2), isNull);
      expect(
        server.calls.where((String x) => x.startsWith('skip:')),
        hasLength(1),
      );
    });

    test(
      'no part left to open: on to the path’s next level, else parked',
      () async {
        final _Server server = _Server()
          ..dayKey = '2026-11-11'
          ..skipped.addAll(<int>[1, 2])
          ..path = _pathWithOpen(PathNodeKind.comment);
        final ProviderContainer c = await _opened(server);
        expect(
          await c.read(lessonRunProvider.notifier).skipPart(3),
          '/contest/comment',
        );

        final _Server alone = _Server()
          ..dayKey = '2026-11-11'
          ..skipped.addAll(<int>[1, 2]);
        final ProviderContainer d = await _opened(alone);
        expect(await d.read(lessonRunProvider.notifier).skipPart(3), isNull);
        expect(d.read(lessonRunProvider).at, const AtParked());
      },
    );

    test('a refused skip is said under the question on screen', () async {
      final _Server server = _Server()
        ..dayKey = '2026-11-11'
        ..refuseSkip = const ContestWrongDay(
          'That day is over. Reload the path for today’s.',
        );
      final ProviderContainer c = await _opened(server);
      await c.read(lessonRunProvider.notifier).skipPart(1);
      final LessonRunState s = c.read(lessonRunProvider);
      expect(
        s.problemFor('qz-b1-1'),
        'That day is over. Reload the path for today’s.',
      );
      expect(s.work, isNull);
      expect(c.read(skipCooldownProvider), isFalse);
    });

    test(
      'no day key, no Skip: a server before Skip is never sent one',
      () async {
        final _Server server = _Server();
        final ProviderContainer c = await _opened(server);
        expect(await c.read(lessonRunProvider.notifier).skipPart(1), isNull);
        expect(
          server.calls.where((String x) => x.startsWith('skip:')),
          isEmpty,
        );
      },
    );

    // LOCKED is not "any other refusal": it means another device moved the
    // parts on, and the visit reopens where they now say — no problem line.
    test('LOCKED drops the pin and re-reads, with no line under the '
        'question', () async {
      final _Server server = _Server()
        ..refuseAnswer = const ContestLocked(
          'Finish or skip Lesson part 1 of 3 first.',
        );
      final ProviderContainer c = await _opened(server);
      await c.read(lessonRunProvider.notifier).answer('b0');
      final LessonRunState s = c.read(lessonRunProvider);
      expect(s.problem, isNull);
      expect(s.pin, isNull);
      expect(s.work, isNull);
      expect(server.calls.last, 'read');
    });
  });

  group('checkpoints', () {
    test('after the last question of a part answered on this visit', () async {
      final _Server server = _Server();
      for (int i = 0; i < 4; i++) {
        server.record('qz-b1-${i + 1}', 'b$i');
      }
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);
      expect(c.read(lessonRunProvider).at, const AtQuestion(4));

      await run.answer('b4');
      await pumpEventQueue();
      run.next();
      expect(
        c.read(lessonRunProvider).shownCheckpoint,
        const LessonPart(index: 0, start: 0, end: 5),
      );
      expect(c.read(lessonRunProvider).at, const AtQuestion(4));

      // "Keep going".
      run.next();
      expect(c.read(lessonRunProvider).shownCheckpoint, isNull);
      expect(c.read(lessonRunProvider).at, const AtQuestion(5));
    });

    test('not when the next part is skipped: on to the open part', () async {
      final _Server server = _Server()
        ..dayKey = '2026-11-11'
        ..skipped.add(2);
      for (int i = 0; i < 4; i++) {
        server.record('qz-b1-${i + 1}', 'b$i');
      }
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);
      expect(c.read(lessonRunProvider).at, const AtQuestion(4));

      await run.answer('b4');
      await pumpEventQueue();
      run.next();
      expect(c.read(lessonRunProvider).shownCheckpoint, isNull);
      expect(c.read(lessonRunProvider).at, const AtQuestion(10));
    });

    test('not for a part finished on an earlier visit', () async {
      final _Server server = _Server();
      for (int i = 0; i < 5; i++) {
        server.record('qz-b1-${i + 1}', 'b$i');
      }
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);

      run.go(const AtQuestion(4));
      run.next();

      expect(c.read(lessonRunProvider).shownCheckpoint, isNull);
      expect(c.read(lessonRunProvider).at, const AtQuestion(5));
    });

    test('never after the day’s last part: the last answer leads to the '
        'score, once the read says the day is done', () async {
      final _Server server = _Server();
      for (int i = 0; i < 14; i++) {
        server.record('qz-b1-${i + 1}', 'b$i');
      }
      final ProviderContainer c = await _opened(server);
      final LessonRun run = c.read(lessonRunProvider.notifier);

      await run.answer('b14');
      await pumpEventQueue();
      expect(c.read(lessonRunProvider).quiz?.completed, isTrue);
      run.next();

      expect(c.read(lessonRunProvider).shownCheckpoint, isNull);
      expect(c.read(lessonRunProvider).at, const AtScore());
    });
  });

  group('the finish', () {
    Future<LessonAnswer> finishWith({required int rightBefore}) async {
      final _Server server = _Server();
      for (int i = 0; i < 14; i++) {
        server.record('qz-b1-${i + 1}', i < rightBefore ? 'b$i' : 'a$i');
      }
      final ProviderContainer c = await _opened(server);
      await c.read(lessonRunProvider.notifier).answer('b14');
      return c.read(lessonRunProvider).answers['qz-b1-15']!;
    }

    test(
      'the bonus is earned by the server’s verdicts reaching its bar',
      () async {
        final LessonAnswer last = await finishWith(rightBefore: 8);
        expect(last.completed, isTrue);
        expect(last.bonus?.earned, isTrue);
        expect(lessonPointsLine(last), '+82 XP, with the bonus for finishing');
      },
    );

    test('short of the bar, it says what the bonus needs', () async {
      final LessonAnswer last = await finishWith(rightBefore: 7);
      expect(last.bonus?.earned, isFalse);
      expect(
        lessonPointsLine(last),
        '+62 XP. No bonus for finishing: it needs 9 right.',
      );
    });
  });

  group('the words', () {
    LessonAnswer answer({
      int? points,
      bool completed = false,
      FinishOutcome? bonus,
    }) => LessonAnswer(
      value: 'x',
      correct: true,
      correctOption: 'x',
      explain: '',
      pointsApplied: points,
      completed: completed,
      bonus: bonus,
    );

    test('the points line', () {
      expect(lessonPointsLine(answer()), 'Not scored.');
      expect(lessonPointsLine(answer(points: 0)), isNull);
      expect(lessonPointsLine(answer(points: 12)), '+12 XP');
      expect(lessonPointsLine(answer(points: -4)), '−4 XP');
      expect(
        lessonPointsLine(
          answer(
            points: 0,
            completed: true,
            bonus: const FinishOutcome(earned: false, minCorrect: 9),
          ),
        ),
        'No bonus for finishing: it needs 9 right.',
      );
      expect(
        lessonPointsLine(
          answer(
            points: 0,
            completed: true,
            bonus: const FinishOutcome(earned: true, minCorrect: 9),
          ),
        ),
        isNull,
      );
    });

    test('"N in a row" counts back from the question, by the server’s '
        'verdicts', () async {
      final _Server server = _Server()
        ..record('qz-b1-1', 'b0')
        ..record('qz-b1-2', 'a1')
        ..record('qz-b1-3', 'b2')
        ..record('qz-b1-4', 'b3');
      final ProviderContainer c = await _opened(server);
      final LessonRunState s = c.read(lessonRunProvider);

      expect(s.rightInARow(0), 1);
      expect(s.rightInARow(1), 0);
      expect(s.rightInARow(3), 2);
      // The question on screen, not answered yet, does not break the run.
      expect(s.rightInARow(4), 2);
    });
  });
}

/// A running path whose today has [kind] open after the lesson.
ContestPath _pathWithOpen(PathNodeKind kind) => ContestPath(
  status: ContestPathStatus.running,
  days: <PathDay>[
    PathDay(
      dayKey: '2026-11-11',
      weekday: 3,
      isToday: true,
      nodes: <PathNode>[
        const PathNode(
          id: '2026-11-11:lesson:3',
          kind: PathNodeKind.lesson,
          state: PathNodeState.skipped,
          href: '/contest/lesson?part=3',
        ),
        PathNode(
          id: '2026-11-11:${kind.wire}',
          kind: kind,
          state: PathNodeState.today,
          href: '/contest/x',
          canSkip: true,
        ),
      ],
    ),
  ],
);

ProviderContainer _container(_Server server) {
  final ProviderContainer c = ProviderContainer(
    overrides: <Override>[contestRepositoryProvider.overrideWithValue(server)],
  );
  addTearDown(c.dispose);
  return c;
}

/// A visit with the lesson open and on screen.
Future<ProviderContainer> _opened(_Server server) async {
  final ProviderContainer c = _container(server);
  c.listen(lessonRunProvider, (_, _) {});
  await pumpEventQueue();
  expect(c.read(lessonRunProvider).quiz, isNotNull);
  return c;
}

/// The server, as far as one learner's lesson goes: today's questions, the
/// key — which leaves this class only inside a verdict, after an answer —
/// and what has been recorded.
///
/// Every question's right option is its second. The player cannot know that,
/// and the tests that count on it are the ones proving it does not need to.
class _Server implements ContestRepository {
  final List<String> calls = <String>[];

  /// `<day>:<itemId>=<value>`, as sent.
  final List<String> answers = <String>[];
  final List<QuizAnswerView> _recorded = <QuizAnswerView>[];

  /// Answered on another device after the lesson was loaded here.
  final Map<String, String> elsewhere = <String, String>{};

  int day = 11;
  String band = 'b1';
  QuizStatus status = QuizStatus.ready;
  bool opened = false;
  bool paused = false;
  Completer<void>? holdOpen;
  Object? refuseOpen;
  Object? refuseRead;

  /// Thrown by the next answer, once.
  Object? refuseAnswer;

  /// The refused answer was recorded anyway — only its reply was lost.
  bool loseReply = false;
  int overviewReads = 0;

  /// Today's key — null, as from a server before Skip, unless a test sets it.
  String? dayKey;

  /// Skipped lesson parts, 1-based.
  final Set<int> skipped = <int>{};

  /// Thrown by the next skip.
  Object? refuseSkip;

  /// What the path reads after a skip.
  ContestPath path = const ContestPath();

  static const int size = 15;

  List<PublicQuizItem> get _items => <PublicQuizItem>[
    for (int i = 0; i < size; i++)
      PublicQuizItem(
        id: 'qz-$band-${i + 1}',
        skill: QuizSkill.values[i % 4],
        prompt: 'Question ${i + 1}',
        options: <String>['a$i', 'b$i', 'c$i', 'd$i'],
      ),
  ];

  String _key(String itemId) {
    final List<PublicQuizItem> items = _items;
    return items.firstWhere((PublicQuizItem q) => q.id == itemId).options[1];
  }

  /// Recorded before the visit, as on a resume.
  void record(String itemId, String value) {
    final bool right = value == _key(itemId);
    _recorded.add(
      QuizAnswerView(
        itemId: itemId,
        value: value,
        correct: right,
        correctOption: _key(itemId),
        explain: 'Because.',
        pointsApplied: paused ? null : (right ? 12 : -4),
      ),
    );
  }

  TodayQuiz get _quiz {
    if (status != QuizStatus.ready) {
      return TodayQuiz(status: status, reason: QuizReason.notJoined);
    }
    final int right = _recorded.where((QuizAnswerView a) => a.correct).length;
    return TodayQuiz(
      status: QuizStatus.ready,
      day: day,
      band: band.toUpperCase(),
      started: opened,
      tomorrow: true,
      questions: _items,
      answered: List<QuizAnswerView>.of(_recorded),
      completed: _recorded.length == size,
      score: QuizScore(
        correct: right,
        wrong: _recorded.length - right,
        points: right * 12,
      ),
      finishBonus: const FinishBonus(points: 20, minCorrect: 9),
      scoringPaused: paused,
      dayKey: dayKey,
      skippedParts: dayKey == null ? const <int>[] : (skipped.toList()..sort()),
    );
  }

  @override
  Future<SkipResult> skipLevel(String nodeId) async {
    calls.add('skip:$nodeId');
    final Object? refusal = refuseSkip;
    if (refusal != null) throw refusal;
    final int k = int.parse(nodeId.split(':').last);
    final bool again = !skipped.add(k);
    return SkipResult(nodeId: nodeId, alreadySkipped: again);
  }

  @override
  Future<TodayQuiz> startLesson() async {
    calls.add('open');
    final Completer<void>? hold = holdOpen;
    if (hold != null) await hold.future;
    final Object? refusal = refuseOpen;
    if (refusal != null) throw refusal;
    opened = true;
    return _quiz;
  }

  @override
  Future<TodayQuiz> fetchTodayQuiz() async {
    calls.add('read');
    final Object? refusal = refuseRead;
    if (refusal != null) throw refusal;
    return _quiz;
  }

  @override
  Future<QuizAnswerResult> answerQuiz({
    required int day,
    required String itemId,
    required String value,
  }) async {
    calls.add('answer');
    answers.add('$day:$itemId=$value');
    if (day != this.day) throw const ContestNotToday();
    if (!_items.any((PublicQuizItem q) => q.id == itemId)) {
      throw const ContestStale();
    }
    final String? earlier = elsewhere.remove(itemId);
    if (earlier != null) record(itemId, earlier);
    for (final QuizAnswerView a in _recorded) {
      if (a.itemId != itemId) continue;
      return QuizAnswerResult(
        value: a.value,
        correct: a.correct,
        correctOption: a.correctOption,
        explain: a.explain,
        completed: _recorded.length == size,
        pointsApplied: a.pointsApplied ?? 0,
        scored: a.pointsApplied != null,
        replay: true,
      );
    }
    final Object? refusal = refuseAnswer;
    refuseAnswer = null;
    if (refusal != null) {
      if (loseReply) record(itemId, value);
      throw refusal;
    }
    record(itemId, value);
    final QuizAnswerView mine = _recorded.last;
    final bool done = _recorded.length == size;
    final int rights = _recorded.where((QuizAnswerView a) => a.correct).length;
    // The finishing answer moves the day credit, and the bonus at 9 right.
    final int finish = done ? 50 + (rights >= 9 ? 20 : 0) : 0;
    return QuizAnswerResult(
      value: value,
      correct: mine.correct,
      correctOption: mine.correctOption,
      explain: mine.explain,
      completed: done,
      pointsApplied: paused ? 0 : (mine.pointsApplied ?? 0) + finish,
      scored: !paused,
    );
  }

  @override
  Future<ContestOverview?> fetchOverview() async {
    overviewReads++;
    return null;
  }

  @override
  Future<ContestPath> fetchPath() async => path;

  @override
  Future<BoardResult> fetchBoard({int? limit}) async => const BoardResult();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}
