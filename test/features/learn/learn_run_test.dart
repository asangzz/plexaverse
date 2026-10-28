import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/application/learn_controllers.dart';
import 'package:plexaverse/features/learn/data/learn_repositories.dart';
import 'package:plexaverse/features/learn/domain/learn_repository.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';

/// The quiz is one question to a screen, and nothing banks until the last.
///
/// ## Why these are pinned
///
/// The level used to be a form: every exercise on one page, one Check, and a
/// level that banked only on a clean run. The rebuild changed four things at
/// once — questions one at a time, a verdict from the server per question,
/// five hearts that mistakes are allowed to spend, and a Skip that costs one
/// — and every one of them is invisible in a diff. A reader of this file
/// should be able to see the contract without reading the player.
class _Repo implements LearnRepository {
  _Repo(this.unit);

  LearnUnit unit;

  /// Exercise ids this fake calls correct. Everything else is a miss.
  Set<String> right = <String>{};

  /// The server refuses to bank the level.
  bool refuseBank = false;

  final List<String> graded = <String>[];
  final List<List<LevelAnswer>> submitted = <List<LevelAnswer>>[];

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async =>
      unit;

  @override
  Future<AnswerVerdict> gradeAnswer({
    required String unitId,
    required int levelIndex,
    required String exerciseId,
    required String value,
  }) async {
    graded.add(exerciseId);
    final bool correct = right.contains(exerciseId);
    return AnswerVerdict(
      correct: correct,
      message: correct ? 'Nicely done.' : 'Not quite.',
      solution: correct ? null : 'The whole corrected line.',
    );
  }

  @override
  Future<SubmitResult> submitLevel({
    required String unitId,
    required int levelIndex,
    required List<LevelAnswer> answers,
  }) async {
    submitted.add(answers);
    if (refuseBank) throw const LearnOutOfHearts('server said no');
    return SubmitResult(unit: unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

Exercise _choice(String id) => Exercise(
  id: id,
  type: 'choice',
  prompt: 'Which line does more work?',
  options: const <ExerciseOption>[
    ExerciseOption(label: 'the weak one'),
    ExerciseOption(label: 'the strong one'),
  ],
  correctIndex: 1,
);

LearnUnit _unitOf(int questions) => LearnUnit(
  id: 'unit-1',
  season: 1,
  weekNumber: 4,
  dayIndex: 0,
  kind: DayKind.post,
  title: 'Why most onboarding docs go unread',
  nextLevelIndex: 0,
  levels: <LearnLevel>[
    LearnLevel(
      index: 0,
      kind: LevelKind.vocabulary,
      title: 'Words that carry',
      status: LevelStatus.available,
      exercises: <Exercise>[
        for (int i = 0; i < questions; i++) _choice('q$i'),
      ],
    ),
  ],
);

Future<(ProviderContainer, _Repo, LearnUnit)> _open(int questions) async {
  final LearnUnit unit = _unitOf(questions);
  final _Repo repo = _Repo(unit);
  final ProviderContainer container = ProviderContainer(
    overrides: <Override>[learnRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  // The run seeds itself from the ladder, so the unit has to be in hand
  // before it is first read — which is exactly the player's own order.
  await container.read(learnUnitControllerProvider(4, 0).future);
  container.listen(learnRunProvider(4, 0), (_, _) {});
  return (container, repo, unit);
}

void main() {
  test('a wrong answer spends a heart and breaks the streak', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);

    final LearnRunState state = c.read(learnRunProvider(4, 0));
    expect(state.heartsLeft, kMistakeBudget - 1);
    expect(state.streak, 0);
    expect(state.verdict?.correct, isFalse);
    // The whole corrected line, not the missing word — the result bar's one
    // job beyond saying "no".
    expect(state.verdict?.solution, isNotNull);
  });

  test('a right answer keeps every heart and builds the streak', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    repo.right = <String>{'q0', 'q1'};
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);
    await run.advance(unit: unit, level: level);
    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[1]);

    final LearnRunState state = c.read(learnRunProvider(4, 0));
    expect(state.heartsLeft, kMistakeBudget);
    expect(state.streak, 2);
  });

  test('nothing is banked until the last question', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    repo.right = <String>{'q0'};
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);
    final LearnStep step = await run.advance(unit: unit, level: level);

    expect(step, LearnStep.next);
    expect(c.read(learnRunProvider(4, 0)).questionIndex, 1);
    expect(
      repo.submitted,
      isEmpty,
      reason:
          'the level is banked once, at the end — a per-question write would '
          'let a half-climbed level count as finished',
    );
  });

  test('the last question banks every answer, blanks included', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    repo.right = <String>{'q0', 'q2'};
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);
    await run.advance(unit: unit, level: level);

    // Skipped: recorded unanswered, not graded.
    await run.skip(unit: unit, level: level, exercise: level.exercises[1]);

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[2]);
    final LearnStep step = await run.advance(unit: unit, level: level);

    expect(step, LearnStep.banked);
    expect(repo.submitted, hasLength(1));
    expect(
      repo.submitted.single.map((LevelAnswer a) => a.exerciseId).toList(),
      <String>['q0', 'q1', 'q2'],
    );
    expect(repo.submitted.single[1].value, '');
  });

  test('skip costs a heart and never asks the grader', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    final LearnStep step = await run.skip(
      unit: unit,
      level: level,
      exercise: level.exercises[0],
    );

    expect(step, LearnStep.next);
    // Grading a blank would print the right answer in the result bar — the
    // one thing the learner just asked not to see.
    expect(repo.graded, isEmpty);
    // A free skip is a button that finishes the level for you.
    expect(c.read(learnRunProvider(4, 0)).heartsLeft, kMistakeBudget - 1);
  });

  test('the fifth miss ends the run before the server is asked', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(6);
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    for (int i = 0; i < kMistakeBudget; i++) {
      run.setValue('the weak one');
      await run.check(unit: unit, level: level, exercise: level.exercises[i]);
      if (i < kMistakeBudget - 1) {
        await run.advance(unit: unit, level: level);
      }
    }

    expect(c.read(learnRunProvider(4, 0)).outOfHearts, isTrue);
    expect(c.read(learnRunProvider(4, 0)).heartsLeft, 0);
    expect(repo.submitted, isEmpty);
  });

  test('restarting a level gives the hearts back and clears the run', () async {
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(3);
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.teachRead();
    run.setValue('the weak one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);
    run.restart();

    final LearnRunState state = c.read(learnRunProvider(4, 0));
    expect(state.heartsLeft, kMistakeBudget);
    expect(state.questionIndex, 0);
    expect(state.answers, isEmpty);
    expect(state.verdict, isNull);
    // The teaching point is read again too. The level is being retaken
    // because the point did not land.
    expect(state.taught, isFalse);
  });

  test("the server's own refusal is what finally decides", () async {
    // The client's heart count is a pacing device. The count that matters is
    // made again in submitLevel, where it is written — so a client that
    // thought it was under budget still has to take no for an answer.
    final (ProviderContainer c, _Repo repo, LearnUnit unit) = await _open(1);
    repo.right = <String>{'q0'};
    repo.refuseBank = true;
    final LearnRun run = c.read(learnRunProvider(4, 0).notifier);
    final LearnLevel level = unit.levels[0];

    run.setValue('the strong one');
    await run.check(unit: unit, level: level, exercise: level.exercises[0]);
    final LearnStep step = await run.advance(unit: unit, level: level);

    expect(step, LearnStep.stopped);
    final LearnRunState state = c.read(learnRunProvider(4, 0));
    expect(state.outOfHearts, isTrue);
    expect(state.error, 'server said no');
  });

  test('the run opens on the level the ladder is actually at', () async {
    // A learner resuming a half-climbed day must not see level one, even for
    // a frame. The run seeds itself from the unit rather than from zero.
    final LearnUnit unit = _unitOf(2).copyWith(
      nextLevelIndex: 1,
      levels: <LearnLevel>[
        LearnLevel(
          index: 0,
          kind: LevelKind.vocabulary,
          title: 'Words that carry',
          status: LevelStatus.complete,
          completedAt: '2026-10-28T00:00:00.000Z',
          exercises: <Exercise>[_choice('q0')],
        ),
        LearnLevel(
          index: 1,
          kind: LevelKind.hook,
          title: 'The first line',
          status: LevelStatus.available,
          exercises: <Exercise>[_choice('q1')],
        ),
      ],
    );
    final ProviderContainer c = ProviderContainer(
      overrides: <Override>[
        learnRepositoryProvider.overrideWithValue(_Repo(unit)),
      ],
    );
    addTearDown(c.dispose);
    await c.read(learnUnitControllerProvider(4, 0).future);

    expect(c.read(learnRunProvider(4, 0)).levelIndex, 1);
  });
}
