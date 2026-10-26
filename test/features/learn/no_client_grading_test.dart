import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The Learn UI never decides whether an answer is right.
///
/// ## Why this is a test and not a comment
///
/// The answer key ships to the client. It has to: `correctIndex` names the
/// right option and `modelAnswer` holds a good rewrite, and the player
/// reveals both AFTER answering, because that reveal is the teaching moment.
///
/// Which means a Dart object with a public `correctIndex` sits three lines
/// from a tap handler. The first person asked to make the check feel instant
/// will compare them locally and skip the round trip — and it will look like
/// an optimisation, not a hole. It is a hole: a unit could then be completed
/// without reading a word, and the post that comes out the far end is our
/// example sentences in the user's voice rather than theirs.
///
/// So grading stays on the server, and this test stops the shortcut being
/// taken by accident.
///
/// ## What is allowed
///
/// Reading the key to DISPLAY it once a server verdict is in hand. That is
/// why the rule is about comparison, not about mentioning the fields:
/// `exercise.correctIndex == i` inside a widget that already holds an
/// `ExerciseResult` is the reveal, and banning the field outright would ban
/// the feature.
///
/// The line this draws: no `==`, `contains`, `compareTo` or
/// `toLowerCase`-style normalisation between an answer and a key OUTSIDE a
/// reveal, and no local `correct:` being synthesised.
void main() {
  final Directory ui = Directory('lib/features/learn/presentation');

  String stripComments(String src) => src
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  List<File> dartFiles(Directory dir) => dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((File f) => f.path.endsWith('.dart'))
      .toList();

  test('no widget synthesises its own verdict', () {
    // Constructing an ExerciseResult in the UI means inventing a verdict the
    // server did not give. The only legitimate source is the submit response.
    final RegExp fabricated = RegExp(r'ExerciseResult\s*\(');
    final List<String> offenders = <String>[];

    for (final File f in dartFiles(ui)) {
      final String src = stripComments(f.readAsStringSync());
      if (fabricated.hasMatch(src)) {
        offenders.add(f.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These build an ExerciseResult in the UI. A verdict comes from the '
          'server or it does not exist.\n  ${offenders.join("\n  ")}',
    );
  });

  test('the answer key is never compared against the user answer', () {
    // LINE-BASED, not shape-based, and that is the second attempt.
    //
    // The first version listed the comparison shapes it could think of —
    // `correctIndex ==`, `== correctIndex`, `options[correctIndex] ==`. It
    // passed a planted shortcut on the first try:
    //
    //     value == exercise.options[exercise.correctIndex ?? 0]
    //
    // because the key is on the RIGHT of the operator, reached through an
    // index lookup. Enumerating shapes is a losing game; any line that holds
    // the key AND a comparison is the thing to look at.
    //
    // So: a line may mention the key, or compare, but not both — unless it
    // is the one reveal the player is built around.
    const Set<String> allowedReveal = <String>{
      'revealedCorrect:locked&&exercise.correctIndex==i,',
    };

    final RegExp key = RegExp(r'correctIndex|modelAnswer');
    final RegExp comparison = RegExp(
      r'==|!=|\.contains\(|\.compareTo\(|\.startsWith\(|\.indexOf\(',
    );
    final List<String> offenders = <String>[];

    for (final File f in dartFiles(ui)) {
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
          'These hold the answer key AND a comparison on one line, which is '
          'grading. Submit to /learn/level and render what comes back. If '
          'this is a new legitimate reveal, add its exact form to '
          'allowedReveal and say why here.\n  ${offenders.join("\n  ")}',
    );
  });

  test('the reveal that IS allowed is still present', () {
    // Guards the two assertions above. If the player stopped showing the
    // right answer after grading, the rules would pass vacuously and nobody
    // would notice the teaching moment had gone.
    final String views = File(
      'lib/features/learn/presentation/widgets/exercise_views.dart',
    ).readAsStringSync();

    expect(
      views.contains('correctIndex'),
      isTrue,
      reason:
          'the player no longer reveals the right answer — the explanation '
          'after answering is the point of the exercise',
    );
    expect(
      views.contains('verdict'),
      isTrue,
      reason: 'the reveal must still be gated on a server verdict',
    );
  });
}
