import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/compose/domain/post_review.dart';
import 'package:plexaverse/features/compose/presentation/widgets/post_optimizer_card.dart';

/// The compose card runs the server's MANUAL review (25 Nov 2026), not
/// heuristics of its own: no hashtag rule either way, 100–220 words, no
/// markdown emphasis, the banned words and stock phrases, no "not just X".
void main() {
  /// [n] plain words, with no rule broken.
  String words(int n) =>
      List<String>.generate(n, (int i) => i.isEven ? 'notes' : 'helped').join(' ');

  final String clean = '${words(150)}\n\nWhat would you write down today?';

  group('the review', () {
    test('a clean 100–220 word post passes and scores 100', () {
      final PostReview r = reviewManualPost(clean);
      expect(r.ok, isTrue);
      expect(r.score, 100);
    });

    test('hashtags neither add nor take away, and are not counted as words', () {
      final PostReview r = reviewManualPost('$clean\n\n#career #growth');
      expect(r.ok, isTrue);
      expect(bodyWordCount('one two #three'), 2);
    });

    test('length is in words, as the server counts them', () {
      expect(
        reviewManualPost(words(60)).errors.single,
        'Lengthen the post. The post body is 60 words. It must be between '
        '100 and 220.',
      );
      expect(
        reviewManualPost(words(330)).errors.single,
        'Shorten the post. The post body is 330 words. It must be between '
        '100 and 220.',
      );
    });

    test('markdown emphasis is an error; a single * bullet is not', () {
      expect(
        reviewManualPost('$clean **bold**').errors.single,
        startsWith('Remove the markdown bold and italics'),
      );
      expect(reviewManualPost('$clean\n* a bullet').ok, isTrue);
    });

    test('a banned word and a stock struggle phrase name themselves', () {
      final PostReview r = reviewManualPost(
        '$clean We had to leverage it. I hit a wall.',
      );
      expect(r.errors, <String>[
        'Replace "leverage" with a plain word.',
        'Replace "hit a wall" with what actually happened.',
      ]);
      expect(r.score, 70);
    });

    test('"not just X, it\'s Y" is an error', () {
      expect(
        reviewManualPost("$clean It's not just a tool, it's a habit.").errors,
        contains(
          'Rewrite the "It\'s not just X, it\'s Y" sentence as one plain claim.',
        ),
      );
    });
  });

  test('the patterns are the server\'s own (lib/services/post-validator.ts)', () {
    final File web = File('../../lib/services/post-validator.ts');
    if (!web.existsSync()) {
      markTestSkipped('web repo not beside this checkout');
      return;
    }
    final String src = web.readAsStringSync();
    void same(RegExp mine, String name) {
      final RegExpMatch? m = RegExp(
        'export const $name =\\s*/(.+)/([a-z]*)\\n',
      ).firstMatch(src);
      expect(m, isNotNull, reason: '$name not found');
      expect(mine.pattern, m!.group(1), reason: '$name pattern');
      // The flags too: losing /i on the server and not here is a drift.
      final String flags = m.group(2)!;
      expect(!mine.isCaseSensitive, flags.contains('i'), reason: '$name /i');
      expect(mine.isUnicode, flags.contains('u'), reason: '$name /u');
      expect(mine.isDotAll, flags.contains('s'), reason: '$name /s');
      expect(mine.isMultiLine, flags.contains('m'), reason: '$name /m');
    }

    same(bannedWords, 'BANNED_WORDS');
    same(stockStruggle, 'STOCK_STRUGGLE');
    same(markdownEmphasis, 'MARKDOWN');
    same(notJustX, 'NOT_JUST_X');
    expect(src, contains('const MIN_WORDS = $minPostWords'));
    expect(src, contains('const MAX_WORDS = $maxPostWords'));

    // The words the user reads are reviewManual's (lib/post-review.ts).
    final File review = File('../../lib/post-review.ts');
    final String r = review.readAsStringSync();
    final String manual = r.substring(r.indexOf('function reviewManual'));
    for (final String words in <String>[
      'Remove the markdown bold and italics — LinkedIn shows the asterisks as they are.',
      'with a plain word.',
      'with what actually happened.',
      "sentence as one plain claim.",
      'Lengthen the post. ',
      'Shorten the post. ',
    ]) {
      expect(manual, contains(words), reason: 'reviewManual wording: $words');
    }
    expect(src, contains('The post body is \${words} words. It must be between'));
  });

  testWidgets('the card shows the review, and says nothing about hashtags', (
    WidgetTester tester,
  ) async {
    Future<void> pump(String text) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: PostOptimizerCard(content: text)),
        ),
      ),
    );

    await pump(clean);
    expect(find.text('Post review'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('Passes the review.'), findsOneWidget);
    expect(find.textContaining('hashtag'), findsNothing);

    await pump(words(40));
    expect(find.textContaining('Lengthen the post.'), findsOneWidget);
    expect(find.text('85'), findsOneWidget);

    await pump('');
    expect(find.text('Start typing to see the review.'), findsOneWidget);
  });
}
