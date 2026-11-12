import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/contest/domain/today_quiz.dart';

/// The contest's lesson never decides whether an answer is right.
///
/// A port of the deleted `test/features/learn/no_client_grading_test.dart`,
/// for the lesson that replaced `/learn`.
///
/// ## Why this is a test and not a comment
///
/// The lesson has it easier than `/learn` did: the key never reaches the app
/// before an answer. `PublicQuizItem` carries no `correctIndex`, and the
/// option to paint green arrives with the verdict, as `correctOption`. But
/// the reveal still puts the server's right option a few lines from a tap
/// handler, and the first person asked to make Check "feel instant" will
/// compare the pick with an earlier answer's `correctOption`, or keep a
/// verdict from one learner's reply for the next question. It would look
/// like an optimisation. It is a hole: the day's score would be the app's,
/// and the set questions are shared by everyone at a band.
///
/// ## What is allowed
///
/// Reading the server's right option to DISPLAY it once its verdict is in.
/// That is why the rule is about comparison, not about mentioning the field:
/// painting the option that equals `correctOption` green, inside a view that
/// already holds the verdict, IS the reveal — and banning the field would ban
/// the teaching moment the lesson is built around.
void main() {
  /// Everything above `data/` in the slice: the screens and the controllers.
  const List<String> roots = <String>[
    'lib/features/contest/presentation',
    'lib/features/contest/application',
  ];

  /// The lesson's own files, for the rules that only make sense there.
  bool isLesson(String path) =>
      path.endsWith('lesson_controllers.dart') ||
      path.endsWith('contest_lesson_page.dart') ||
      path.contains('/widgets/lesson/');

  String stripComments(String src) => src
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  List<File> dartFiles() => <File>[
    for (final String root in roots)
      ...Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (File f) =>
                f.path.endsWith('.dart') &&
                !f.path.endsWith('.g.dart') &&
                !f.path.endsWith('.freezed.dart'),
          ),
  ];

  test('the scan finds the lesson', () {
    // Guards the rules below: a scan that matched nothing would pass them
    // vacuously, and green forever.
    final List<String> lesson = <String>[
      for (final File f in dartFiles())
        if (isLesson(f.path)) f.path,
    ];
    expect(lesson, contains(endsWith('lesson_controllers.dart')));
    expect(lesson, contains(endsWith('contest_lesson_page.dart')));
    expect(lesson, contains(endsWith('choice_view.dart')));
    expect(lesson, contains(endsWith('lesson_shell.dart')));
  });

  test('no screen or controller synthesises a verdict', () {
    // Building a QuizAnswerResult or a QuizAnswerView above data/ means
    // inventing a verdict the server did not give. The only legitimate
    // source is the answer route's reply, or the lesson read's record.
    final RegExp fabricated = RegExp(
      r'\b(QuizAnswerResult|QuizAnswerView)\s*\(',
    );
    // And a `correct:` that is not read off the server's own object — the
    // reply or the record — is a verdict made here.
    final RegExp madeHere = RegExp(r'\bcorrect:(?!\s*\w+\.correct\b)');
    final List<String> offenders = <String>[];

    for (final File f in dartFiles()) {
      final String src = stripComments(f.readAsStringSync());
      if (fabricated.hasMatch(src)) offenders.add('${f.path}: builds one');
      if (isLesson(f.path)) {
        for (final RegExpMatch m in madeHere.allMatches(src)) {
          final int line = src.substring(0, m.start).split('\n').length;
          offenders.add('${f.path}:$line: a `correct:` made here');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'A verdict comes from the server or it does not exist.\n'
          '  ${offenders.join("\n  ")}',
    );
  });

  test(
    'the server’s right option is never compared, but in the one reveal',
    () {
      // LINE-BASED, not shape-based — the lesson /learn learnt. Its first
      // version listed the comparison shapes it could think of, and a planted
      // `value == exercise.options[exercise.correctIndex ?? 0]` walked past it
      // with the key on the right of the operator. Any line holding the key
      // AND a comparison is the thing to look at.
      const Set<String> allowedReveal = <String>{
        // choice_view.dart: paint the server's right option green, once its
        // verdict is in.
        'finalboolisRight=locked&&option==rightOption;',
      };
      final RegExp key = RegExp(r'correctOption|rightOption|correctIndex');
      final RegExp comparison = RegExp(
        r'==|!=|\.contains\(|\.compareTo\(|\.startsWith\(|\.endsWith\(|'
        r'\.indexOf\(|\.toLowerCase\(|\.trim\(',
      );
      final List<String> offenders = <String>[];

      for (final File f in dartFiles()) {
        final List<String> lines = stripComments(
          f.readAsStringSync(),
        ).split('\n');
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          if (!key.hasMatch(line) || !comparison.hasMatch(line)) continue;
          if (allowedReveal.contains(line.replaceAll(RegExp(r'\s'), ''))) {
            continue;
          }
          offenders.add('${f.path}:${i + 1}  →  ${line.trim()}');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'These hold the right option AND a comparison on one line, which '
            'is grading. Send the answer and draw what comes back. If this is '
            'a new legitimate reveal, add its exact form to allowedReveal and '
            'say why there.\n  ${offenders.join("\n  ")}',
      );
    },
  );

  test('nothing above data/ can reach the fake’s answer key', () {
    // The mock flavor's server lives in data/fake_contest_world.dart, key
    // and all. A screen that read it would grade in the mock build and
    // nowhere else — which is where this would be tested by hand.
    final RegExp fake = RegExp(r'FakeContestWorld|fake_contest_world');
    final List<String> offenders = <String>[
      for (final File f in dartFiles())
        if (fake.hasMatch(stripComments(f.readAsStringSync()))) f.path,
    ];
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });

  test('a question as the app holds it has no key in it', () {
    // Whatever a server sends, the app keeps only what the learner may see
    // before answering: a key on the wire is dropped at parse time.
    final PublicQuizItem item = PublicQuizItem.fromJson(<String, dynamic>{
      'id': 'qz-b1-0051',
      'skill': 'vocabulary',
      'prompt': 'Pick one.',
      'options': <String>['a', 'b', 'c', 'd'],
      'correctIndex': 1,
      'explain': 'Because.',
      'band': 'B1',
    });
    expect(item.toJson().keys.toSet(), <String>{
      'id',
      'skill',
      'passage',
      'prompt',
      'options',
    });
  });

  test('the reveal that IS allowed is still there', () {
    // Guards the rules above. If the player stopped painting the right
    // option, or the bar stopped printing it, they would pass vacuously and
    // nobody would notice the teaching moment had gone.
    final String choice = File(
      'lib/features/contest/presentation/widgets/lesson/choice_view.dart',
    ).readAsStringSync();
    expect(choice, contains('rightOption'));
    expect(choice, contains('verdict'));

    final String shell = File(
      'lib/features/contest/presentation/widgets/lesson/lesson_shell.dart',
    ).readAsStringSync();
    expect(
      shell,
      contains("'Correct: '"),
      reason:
          'the result bar no longer prints the right option, which is the '
          'one thing it exists to do beyond saying "Not quite."',
    );
    final String question = File(
      'lib/features/contest/presentation/widgets/lesson/lesson_question.dart',
    ).readAsStringSync();
    expect(question, contains('solution: answer.correctOption'));
  });
}
