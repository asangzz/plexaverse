import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/data/learn_repositories.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';
import 'package:plexaverse/features/learn/domain/learner_lines.dart';

/// A port of the web's `__tests__/lib/learn-learner-lines.test.ts`, minus the
/// prompt cases, which are the server's.
///
/// The promise this whole feature makes is that the post comes out of what
/// the learner wrote. It reached a real user broken — a post opened with the
/// planner's title while the opening the author had just been taught to write
/// sat unused, and nothing on screen said so. These are the checks that make
/// a departure visible.
void main() {
  group('openingLineOf / closingLineOf', () {
    const String post =
        '\n\nFirst real line.\n\nMiddle.\n\nThe closing ask?\n\n#AI #Product\n';

    test('finds the first line with anything on it', () {
      expect(openingLineOf(post), 'First real line.');
    });

    test('skips the hashtag block when finding the close', () {
      // The hashtag line is always last and is never the author's ask.
      expect(closingLineOf(post), 'The closing ask?');
    });

    test('survives a post with no hashtags', () {
      expect(closingLineOf('One.\n\nTwo.'), 'Two.');
    });
  });

  group('lineOutcome', () {
    const String mine = 'We deleted six onboarding screens and nobody noticed.';

    test('an exact match is kept, ignoring case and punctuation', () {
      expect(lineOutcome(mine, mine), LineOutcome.kept);
      expect(
        lineOutcome(mine, 'we deleted six onboarding screens and nobody noticed'),
        LineOutcome.kept,
      );
    });

    test('a light tidy is used, not a departure', () {
      // The prompt ASKS for this, so flagging it would train people to
      // distrust a correct result.
      expect(
        lineOutcome(mine, 'We deleted six onboarding screens, and nobody noticed.'),
        LineOutcome.kept,
      );
      expect(
        lineOutcome(
          mine,
          'We deleted six onboarding screens — and honestly nobody noticed.',
        ),
        LineOutcome.edited,
      );
    });

    test('filler alone cannot carry a match', () {
      // The stop-word filter is load-bearing, and the case above does not
      // actually test it — both lines are specific enough to come out
      // `replaced` either way. These two share nothing but grammar: count
      // "it", "is", "on", "to", "be", "in" and the score is 0.67, which
      // would hand the learner someone else's sentence as their own.
      const String padded = 'It is on you to be in the room.';
      const String different = 'It is on me to be in that meeting.';
      expect(lineOutcome(padded, different), LineOutcome.replaced);
    });

    test('a different opening is replaced', () {
      expect(
        lineOutcome(mine, 'Most AI projects fail for one reason.'),
        LineOutcome.replaced,
      );
    });

    test('a line that merely shares common words does not count', () {
      expect(
        lineOutcome(mine, 'We noticed that the team was busy.'),
        LineOutcome.replaced,
      );
    });

    test('their line is still theirs when the post adds to it', () {
      // Containment is measured against what THEY wrote, not against the
      // shipped line. Measured the other way round, a line that keeps every
      // one of their words and adds a clause scores low purely because the
      // post is longer — and the user is told their line was dropped while it
      // sits at the front of it.
      const String short = 'We deleted six screens.';
      const String expanded =
          'We deleted six screens last quarter, after the audit showed nobody '
          'finished onboarding.';
      expect(lineOutcome(short, expanded), LineOutcome.edited);
    });

    test('missing when they never wrote one', () {
      expect(lineOutcome(null, 'anything'), LineOutcome.missing);
      expect(lineOutcome('   ', 'anything'), LineOutcome.missing);
    });

    test('replaced rather than crashing on an empty post', () {
      expect(lineOutcome(mine, ''), LineOutcome.replaced);
    });
  });

  group('reportLearnerLines', () {
    List<LearnLevel> levels(String? hook, String? close) => <LearnLevel>[
      LearnLevel(
        index: 0,
        kind: LevelKind.hook,
        title: 'The first line',
        exercises: const <Exercise>[
          Exercise(id: 'h1', type: 'choice', prompt: 'pick'),
          Exercise(id: 'h2', type: 'compose', prompt: 'write it'),
        ],
        answers: <LevelAnswer>[
          const LevelAnswer(exerciseId: 'h1', value: 'an option', correct: true),
          if (hook != null) LevelAnswer(exerciseId: 'h2', value: hook),
        ],
      ),
      LearnLevel(
        index: 1,
        kind: LevelKind.close,
        title: 'The ask',
        exercises: const <Exercise>[
          Exercise(id: 'c1', type: 'compose', prompt: 'write it'),
        ],
        answers: <LevelAnswer>[
          if (close != null) LevelAnswer(exerciseId: 'c1', value: close),
        ],
      ),
    ];

    const String hook = 'We deleted six onboarding screens and nobody noticed.';
    const String close = 'What would you delete first?';

    test('reports both lines against the post that shipped', () {
      final LearnerLineReport? report = reportLearnerLines(
        levels(hook, close),
        '$hook\n\nSome middle.\n\n$close\n\n#Product',
      );

      expect(report!.hook.outcome, LineOutcome.kept);
      expect(report.close.outcome, LineOutcome.kept);
      expect(report.anyReplaced, isFalse);
      expect(report.isEmpty, isFalse);
    });

    test('flags the opening when the post went another way', () {
      final LearnerLineReport? report = reportLearnerLines(
        levels(hook, close),
        'Most onboarding fails in week one.\n\nMiddle.\n\n$close',
      );

      expect(report!.hook.outcome, LineOutcome.replaced);
      expect(report.anyReplaced, isTrue);
      // Their own words are kept, so the screen can show both sides.
      expect(report.hook.written, hook);
      expect(report.hook.shipped, 'Most onboarding fails in week one.');
    });

    test('only multiple-choice answers means nothing was written', () {
      final LearnerLineReport? report = reportLearnerLines(
        levels(null, null),
        'A post that came from somewhere else.',
      );

      expect(report!.isEmpty, isTrue);
    });

    test('nothing to report when there is no post yet', () {
      expect(reportLearnerLines(levels(hook, close), null), isNull);
      expect(reportLearnerLines(levels(hook, close), '  '), isNull);
    });
  });

  group('the mock can show this state', () {
    // A stand-in backend that cannot produce a state the real one produces
    // is a stand-in that hides a feature. This one banked a level and
    // remembered nothing of what was typed into it, so the report could
    // never appear in the flavor the app is demonstrated in.
    test('a banked level keeps the answers that banked it', () async {
      final FakeLearnRepository repo = FakeLearnRepository();
      final LearnUnit unit = await repo.fetchUnit(week: 4, day: 1);
      final LearnLevel hookLevel = unit.levels.firstWhere(
        (LearnLevel l) => l.kind == LevelKind.hook,
      );

      const String mine = 'Nobody had read the runbook. We found out at 2am.';
      final SubmitResult result = await repo.submitLevel(
        unitId: unit.id,
        levelIndex: hookLevel.index,
        answers: <LevelAnswer>[
          LevelAnswer(
            exerciseId: hookLevel.exercises[0].id,
            value: hookLevel.exercises[0].optionAt(
              hookLevel.exercises[0].correctIndex ?? 0,
            )!,
          ),
          LevelAnswer(exerciseId: hookLevel.exercises[1].id, value: mine),
        ],
      );

      final LearnLevel banked = result.unit.levels[hookLevel.index];
      expect(banked.isComplete, isTrue);
      expect(
        collectLearnerInput(result.unit.levels)[LevelKind.hook],
        <String>[mine],
      );
    });
  });
}
