import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/data/learn_repositories.dart';
import 'package:plexaverse/features/learn/domain/learn_repository.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';
import 'package:plexaverse/features/learn/presentation/widgets/lesson_player.dart';

/// A level the learner cannot leave is worse than one that refuses.
///
/// The ladder is written by a model and arrives over a wire, so neither shape
/// below is hypothetical: `teach` is nullable on that wire and `exercises` is
/// a list the generator fills. Either one coming back empty used to produce a
/// screen with no bar under it — no Check, no Skip, no way to answer — and
/// because a day cannot advance past a level it never completes, backing out
/// and returning landed on the same dead level for ever.
class _Repo implements LearnRepository {
  _Repo(this.unit);

  final LearnUnit unit;

  @override
  Future<LearnUnit> fetchUnit({required int week, required int day}) async =>
      unit;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

LearnUnit _unitWith(LearnLevel level) => LearnUnit(
  id: 'unit-1',
  season: 1,
  weekNumber: 4,
  dayIndex: 0,
  kind: DayKind.post,
  title: 'Why most onboarding docs go unread',
  nextLevelIndex: 0,
  levels: <LearnLevel>[
    level,
    const LearnLevel(index: 1, kind: LevelKind.draft, title: 'Write the post'),
  ],
);

Future<void> _pump(WidgetTester tester, LearnUnit unit, {int? openAt}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        learnRepositoryProvider.overrideWithValue(_Repo(unit)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LessonPlayer(
            unit: unit,
            week: 4,
            day: 0,
            openAt: openAt,
            onClose: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

LearnUnit _draftedUnit({required String hook, required String post}) => LearnUnit(
  id: 'unit-1',
  season: 1,
  weekNumber: 4,
  dayIndex: 0,
  kind: DayKind.post,
  title: 'Why most onboarding docs go unread',
  nextLevelIndex: 1,
  postContent: post,
  levels: <LearnLevel>[
    LearnLevel(
      index: 0,
      kind: LevelKind.hook,
      title: 'The first line',
      status: LevelStatus.complete,
      completedAt: '2026-10-29T00:00:00.000Z',
      exercises: const <Exercise>[
        Exercise(id: 'h1', type: 'compose', prompt: 'Write your opening.'),
      ],
      answers: <LevelAnswer>[LevelAnswer(exerciseId: 'h1', value: hook)],
    ),
    const LearnLevel(
      index: 1,
      kind: LevelKind.draft,
      title: 'Write the post',
      status: LevelStatus.complete,
      completedAt: '2026-10-29T00:00:00.000Z',
    ),
  ],
);

void main() {
  testWidgets('a level with no questions can still be finished', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      _unitWith(
        const LearnLevel(
          index: 0,
          kind: LevelKind.vocabulary,
          title: 'Words that carry',
          status: LevelStatus.available,
          teach: TeachBlock(
            rule: 'Name the thing, then say what changed.',
            why: 'A reader gives you one line.',
            before: 'We improved our processes.',
            after: 'We cut handover to three hours.',
          ),
          exercises: <Exercise>[],
        ),
      ),
    );

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    // Not "Check" — there is nothing to check. The level banks with an empty
    // answer set, which the server accepts.
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('a level with no teaching block still shows its bar', (
    WidgetTester tester,
  ) async {
    // The bar used to be gated on `taught`, which only ever becomes true by
    // pressing "Got it" on the teaching card. No card, no "Got it", no bar —
    // and the question sat there unanswerable.
    await _pump(
      tester,
      _unitWith(
        LearnLevel(
          index: 0,
          kind: LevelKind.hook,
          title: 'The first line',
          status: LevelStatus.available,
          exercises: <Exercise>[
            Exercise(
              id: 'h1',
              type: 'choice',
              prompt: 'Which opening makes you read line two?',
              options: const <ExerciseOption>[
                ExerciseOption(label: 'Today I want to talk about onboarding.'),
                ExerciseOption(label: 'Our new hire shipped on day three.'),
              ],
              correctIndex: 1,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Got it'), findsNothing);
    expect(find.text('Check'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('a dropped opening is said out loud, with both lines', (
    WidgetTester tester,
  ) async {
    // The failure that reached a real user: the post opened with the
    // planner's title while the line the author had just been taught to
    // write sat unused, and nothing on screen said so.
    await _pump(
      tester,
      _draftedUnit(
        hook: 'We deleted six onboarding screens and nobody noticed.',
        post: 'Most onboarding fails in week one.\n\nSome middle.',
      ),
      openAt: 1,
    );

    expect(find.text('YOUR LINES'), findsOneWidget);
    expect(
      find.text('Your opening — Plexa went another way.'),
      findsOneWidget,
    );
    expect(find.textContaining('You can put your own line back'), findsOneWidget);
  });

  testWidgets('a kept opening says so, and offers no apology', (
    WidgetTester tester,
  ) async {
    const String hook = 'We deleted six onboarding screens and nobody noticed.';
    await _pump(
      tester,
      _draftedUnit(hook: hook, post: '$hook\n\nSome middle.'),
      openAt: 1,
    );

    expect(find.text('Your opening — used word for word.'), findsOneWidget);
    expect(find.textContaining('You can put your own line back'), findsNothing);
  });
}
