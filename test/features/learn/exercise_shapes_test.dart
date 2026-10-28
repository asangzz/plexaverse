import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/learn/domain/learn_unit.dart';

/// `options` has two wire shapes, and the awkward one is the point.
///
/// Five of the seven exercise types send `["a","b","c"]`. `pair` sends
/// `[{label, fills:[x,y]}]`, because its options are two words that belong
/// together and the sentence has two blanks. One Dart field has to read both
/// — and the answer travels back as the LABEL for every type, which is what
/// keeps the player off the union and the server's grader simple.
void main() {
  Exercise parse(Map<String, dynamic> json) => Exercise.fromJson(json);

  test('plain string options become labels with no fills', () {
    final Exercise e = parse(<String, dynamic>{
      'id': 'c1',
      'type': 'choice',
      'prompt': 'Which line does more work?',
      'options': <dynamic>['the weak one', 'the strong one'],
      'correctIndex': 1,
    });

    expect(e.optionLabels, <String>['the weak one', 'the strong one']);
    expect(e.options.every((ExerciseOption o) => o.fills.isEmpty), isTrue);
    expect(e.optionAt(1), 'the strong one');
  });

  test('a pair option keeps its label and both of its fills', () {
    final Exercise e = parse(<String, dynamic>{
      'id': 'p1',
      'type': 'pair',
      'prompt': 'Both halves.',
      'sentence': 'We ___ the doc and new hires ___ on day three.',
      'options': <dynamic>[
        <String, dynamic>{
          'label': 'rewrote … shipped',
          'fills': <dynamic>['rewrote', 'shipped'],
        },
        <String, dynamic>{
          'label': 'improved … performed',
          'fills': <dynamic>['improved', 'performed'],
        },
      ],
      'correctIndex': 0,
    });

    expect(e.isPair, isTrue);
    expect(e.optionLabels.first, 'rewrote … shipped');
    expect(e.options.first.fills, <String>['rewrote', 'shipped']);
    // The answer of record is the label — `gradeExercise`'s pair branch
    // compares by label, so an index or a fill would never match.
    expect(e.optionAt(0), 'rewrote … shipped');
  });

  test('both blanks fill in order, so the sentence reads as a sentence', () {
    final Exercise e = parse(<String, dynamic>{
      'id': 'p1',
      'type': 'pair',
      'prompt': '',
      'sentence': 'We ___ the doc and new hires ___ on day three.',
      'options': <dynamic>[
        <String, dynamic>{
          'label': 'rewrote … shipped',
          'fills': <dynamic>['rewrote', 'shipped'],
        },
      ],
      'correctIndex': 0,
    });

    expect(
      e.filled(e.options.first),
      'We rewrote the doc and new hires shipped on day three.',
    );
    // Nothing picked yet: the blanks stay blank rather than collapsing.
    expect(e.filled(null), contains('___'));
  });

  test('a single-blank gap fills from the option label', () {
    final Exercise e = parse(<String, dynamic>{
      'id': 'g1',
      'type': 'gap',
      'prompt': '',
      'sentence': 'The runbook cut our response to ___.',
      'options': <dynamic>['much faster', 'under 20 minutes'],
      'correctIndex': 1,
    });

    expect(
      e.filled(e.options[1]),
      'The runbook cut our response to under 20 minutes.',
    );
  });

  test('the pair shape survives a round trip', () {
    // Not academic: a unit that went through `toJson` and came back with
    // `[{label}]` flattened to `["label"]` would lose both fills, and the
    // sentence would draw with one blank filled and one empty.
    const Exercise e = Exercise(
      id: 'p1',
      type: 'pair',
      prompt: '',
      sentence: 'We ___ and they ___.',
      options: <ExerciseOption>[
        ExerciseOption(label: 'a … b', fills: <String>['a', 'b']),
        ExerciseOption(label: 'c'),
      ],
      correctIndex: 0,
    );

    final Exercise back = Exercise.fromJson(e.toJson());
    expect(back.options.first.fills, <String>['a', 'b']);
    expect(back.options.last.label, 'c');
    expect(back.options.last.fills, isEmpty);
  });

  test('all seven types this build draws are climbable', () {
    const List<String> types = <String>[
      'choice',
      'gap',
      'pair',
      'dialogue',
      'meaning',
      'rewrite',
      'compose',
    ];
    final LearnLevel level = LearnLevel(
      index: 0,
      kind: LevelKind.vocabulary,
      title: 'Words that carry',
      exercises: <Exercise>[
        for (final String t in types) Exercise(id: t, type: t, prompt: t),
      ],
    );

    expect(level.renderable, hasLength(types.length));
    expect(level.isClimbable, isTrue);
    expect(level.unsupportedTypes, isEmpty);
  });
}
