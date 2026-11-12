import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

import 'placement_harness.dart';

/// The placement test never says whether an answer was right.
///
/// ## Why this is a test
///
/// A placement test that teaches mid-way measures the teaching. The web
/// holds this by construction — the item carries no key, and an answer
/// resolves to the next question — and so does this slice. But the lesson
/// player the contest needs, three folders over, DOES reveal answers: green
/// for the right option, red for a wrong pick, "Nicely done" and "Not quite".
/// The first person asked to make the placement "feel like the lesson" will
/// reach for exactly those. This fails on the attempt.
///
/// Two halves: the screen a learner sees after pressing Next, and the source
/// of every placement file a screen is built from.
void main() {
  /// Every colour that means a verdict somewhere in the app: Zave's green
  /// and mint (done, right), amber (waiting, a miss in the old learn
  /// player), and the contest's borrowed reds for a wrong answer.
  final Set<Color> verdictColours = <Color>{
    ZaveColors.green,
    ZaveColors.mint,
    ZaveColors.amber,
    Color(0xFFE5484D),
    Color(0xFFFF9592),
  };

  /// Every flat colour painted on screen: text, fills, borders, icons.
  Set<Color> paintedColours(WidgetTester tester) {
    final Set<Color> out = <Color>{};
    void addDecoration(Decoration? d) {
      if (d is! BoxDecoration) return;
      if (d.color case final Color c) out.add(c);
      final BoxBorder? border = d.border;
      if (border is Border) {
        out.addAll(<Color>[
          border.top.color,
          border.bottom.color,
          border.left.color,
          border.right.color,
        ]);
      }
    }

    for (final Widget w in tester.allWidgets) {
      switch (w) {
        case Text(:final TextStyle? style):
          if (style?.color case final Color c) out.add(c);
        case Container(:final Decoration? decoration):
          addDecoration(decoration);
        case DecoratedBox(:final Decoration decoration):
          addDecoration(decoration);
        case ColoredBox(:final Color color):
          out.add(color);
        case Icon(:final Color? color):
          if (color != null) out.add(color);
        default:
      }
    }
    return out;
  }

  testWidgets('after Next, the next question — no word, no colour', (
    WidgetTester tester,
  ) async {
    await pumpPlacement(tester, instantFake());
    await tapVisible(tester, find.text('Start the test'));

    // Nine answers: through two parts and into the reading, so a verdict
    // drawn on any kind of question would be on screen at some point.
    for (int i = 0; i < 9; i++) {
      await pickFirstOption(tester);
      await tapVisible(tester, find.text('Next'));

      final String text = allText(tester).toLowerCase();
      for (final String word in <String>[
        'correct',
        'wrong',
        'nicely done',
        'not quite',
        'right answer',
        'well done',
      ]) {
        expect(text, isNot(contains(word)), reason: 'after answer ${i + 1}');
      }
      expect(
        paintedColours(tester).intersection(verdictColours),
        isEmpty,
        reason: 'after answer ${i + 1}, a verdict colour is on screen',
      );
    }
    expect(find.text('Question 10 of about 12'), findsOneWidget);
  });

  test('the colour scan can still see a verdict colour', () {
    // Guards the assertion above: a scan that stopped seeing colours would
    // pass forever.
    expect(verdictColours, contains(ZaveColors.green));
  });

  group('no placement screen can mark an answer', () {
    /// Comments stripped: the files explain at length why they never say
    /// "correct", and prose about the rule is not a breach of it.
    String code(File f) => f
        .readAsStringSync()
        .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
        .replaceAll(RegExp(r'//[^\n]*'), '');

    /// Everything a screen is built from. `data/` is left out on purpose:
    /// the fake repository marks answers exactly where the server does, out
    /// of every screen's reach.
    List<File> sources() => <String>['domain', 'application', 'presentation']
        .expand(
          (String layer) => Directory(
            'lib/features/placement/$layer',
          ).listSync(recursive: true),
        )
        .whereType<File>()
        .where(
          (File f) =>
              f.path.endsWith('.dart') &&
              !f.path.endsWith('.g.dart') &&
              !f.path.endsWith('.freezed.dart'),
        )
        .toList();

    /// Anywhere in an identifier or a string: `isCorrect`, `showVerdict`,
    /// `'Wrong'` all count. "Something went wrong" is the web's sentence for
    /// a request that failed, and says nothing about an answer.
    final RegExp verdictWord = RegExp(
      r'correct|(?<!went )wrong|verdict',
      caseSensitive: false,
    );

    test('no verdict word in the code of any layer a screen reads', () {
      final List<File> files = sources();
      expect(files.length, greaterThan(8), reason: 'the scan lost the slice');
      final List<String> offenders = <String>[
        for (final File f in files)
          for (final Match m in verdictWord.allMatches(code(f)))
            '${f.path}: ${m.group(0)}',
      ];
      expect(offenders, isEmpty);
    });

    test('the question screen paints in no verdict colour', () {
      final String src = code(
        File(
          'lib/features/placement/presentation/widgets/placement_question.dart',
        ),
      );
      for (final String colour in <String>[
        'ZaveColors.green',
        'ZaveColors.mint',
        'ZaveColors.amber',
        'Color(0x',
      ]) {
        expect(src, isNot(contains(colour)));
      }
    });

    test('the scan can still see a verdict word', () {
      expect(verdictWord.hasMatch('final bool isCorrect = true;'), isTrue);
      expect(verdictWord.hasMatch('showVerdict(x)'), isTrue);
      expect(verdictWord.hasMatch("Text('Not quite. Wrong.')"), isTrue);
      expect(verdictWord.hasMatch("ZaveButton(label: 'Next')"), isFalse);
      expect(
        verdictWord.hasMatch("'Something went wrong. Try again.'"),
        isFalse,
      );
    });
  });
}
