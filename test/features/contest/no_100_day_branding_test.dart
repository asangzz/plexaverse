import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The one comment stripper: the /learn guard's, which keeps strings and
// blanks comments with the same rules this scan needs.
import '../../core/router/no_learn_route_test.dart' show stripComments;

/// No "100 days" in the contest (owner, 11 Nov 2026: "we need to drop the
/// branding of 100 days from the contest"). The app's half of the web's
/// `__tests__/lib/no-100-day-branding.test.ts`, with the same patterns.
///
/// A contest's length is its dates, so nothing a learner reads may name a
/// hundred-day length, render an "n-day contest" from the length — which
/// reads as the same brand for a 100-day window — or count a day "of" it:
/// "DAY 1 OF 100" was the brand too.
///
/// ## What is scanned
///
/// The contest slice and the placement slice: their screens, their words and
/// the mock's fixtures, which are what this app is tested on by eye. Code
/// only — comments are stripped first, so the history may stay; strings are
/// code. Generated files hold no copy and are skipped. Most of what a learner
/// reads arrives from the server, whose sentences the web's guard scans.
void main() {
  const List<String> scanned = <String>[
    'lib/features/contest',
    'lib/features/placement',
  ];

  List<File> files() => <File>[
    for (final String dir in scanned)
      for (final FileSystemEntity e in Directory(dir).listSync(recursive: true))
        if (e is File &&
            e.path.endsWith('.dart') &&
            !e.path.endsWith('.g.dart') &&
            !e.path.endsWith('.freezed.dart'))
          e,
  ];

  List<String> offenders(RegExp pattern) => <String>[
    for (final File f in files())
      for (final (int i, String line) in stripComments(
        f.readAsStringSync(),
      ).split('\n').indexed)
        if (pattern.hasMatch(line)) '${f.path}:${i + 1}: ${line.trim()}',
  ];

  test('scans something (a moved directory must not make this pass)', () {
    expect(
      files().map((File f) => f.path),
      containsAll(<String>[
        'lib/features/contest/presentation/pages/contest_page.dart',
        'lib/features/contest/presentation/pages/contest_follow_page.dart',
        'lib/features/contest/presentation/widgets/path/path_view.dart',
        'lib/features/contest/domain/contest_words.dart',
        'lib/features/contest/data/fake_contest_world.dart',
        'lib/features/placement/presentation/pages/placement_page.dart',
      ]),
    );
  });

  test('no copy names a 100-day length', () {
    expect(offenders(hundredDays), isEmpty);
  });

  test('no copy brands the window as an "<n>-day contest"', () {
    expect(offenders(nDayBrand), isEmpty);
  });

  test('no copy counts a day "of" the contest’s length', () {
    expect(offenders(dayOfLength), isEmpty);
  });

  test('the patterns catch what they are for', () {
    expect(hundredDays.hasMatch("hint: 'The 100-day challenge'"), isTrue);
    expect(hundredDays.hasMatch('Day N of 100 days'), isTrue);
    expect(hundredDays.hasMatch('a hundred-day course'), isTrue);
    expect(hundredDays.hasMatch('top 100 learners'), isFalse);

    expect(nDayBrand.hasMatch(r"'${o.lengthDays}-day contest'"), isTrue);
    expect(nDayBrand.hasMatch(r"'$lengthDays-day challenge'"), isTrue);
    expect(nDayBrand.hasMatch("'A 5-day contest'"), isFalse);

    expect(dayOfLength.hasMatch(r"'Day $day of $lengthDays'"), isTrue);
    expect(
      dayOfLength.hasMatch(r"'Day ${path.dayNumber} of ${path.finalDay}'"),
      isTrue,
    );
    // A question or a part counted within the day is not the brand.
    expect(dayOfLength.hasMatch(r"'Question $i of $total'"), isFalse);
  });
}

/// "100-day", "100 day", "100 days", "hundred-day", "hundred days".
final RegExp hundredDays = RegExp(
  r'\b(100|hundred)[- ]?days?\b',
  caseSensitive: false,
);

/// A length rendered as a brand: the web's `}-day contest`, plus Dart's
/// bare `$n-day contest`, which has no brace.
final RegExp nDayBrand = RegExp(
  r'(\}|\$\w+)-day (contest|challenge)',
  caseSensitive: false,
);

/// "Day 15 of 100" — a day counted against the contest's last day or its
/// length.
final RegExp dayOfLength = RegExp(
  r'Day \$\{?[\w.]+\}? of \$\{?[\w.]*(finalDay|lengthDays)',
);
