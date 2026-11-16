import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The one comment stripper: the /learn guard's, which keeps strings and
// blanks comments with the same rules this scan needs.
import '../../core/router/no_learn_route_test.dart' show stripComments;

/// No promise of a way to cancel (owner, 17 Nov 2026: "hame koe subscription
/// cancellation ka option nahi dena hai"). The app's half of the web's
/// `__tests__/lib/no-cancel-promise.test.ts`, with the same pattern.
///
/// The product offers no cancellation, so nothing may say "cancel any time"
/// or "cancel from Settings". What it does say, where the free month is
/// offered and in Settings during it, is what cancelling the mandate at the
/// bank costs: the free month ends with it.
///
/// Nor "No card": finishing onboarding registers autopay in India or buys the
/// 30-day pass abroad, so a card or UPI is asked for.
///
/// Scans all of `lib/` — code only, comments stripped, generated files
/// skipped.
void main() {
  final RegExp promise = RegExp(
    r'cancel\s+any\s*time|cancel\s+from\s+settings|cancel\s+before\s+day|'
    r'\bno\s+card\b',
    caseSensitive: false,
  );

  List<File> files() => <File>[
    for (final FileSystemEntity e in Directory('lib').listSync(recursive: true))
      if (e is File &&
          e.path.endsWith('.dart') &&
          !e.path.endsWith('.g.dart') &&
          !e.path.endsWith('.freezed.dart'))
        e,
  ];

  test('scans the plan surfaces (a moved file must not make this pass)', () {
    expect(
      files().map((File f) => f.path),
      containsAll(<String>[
        'lib/features/onboarding/presentation/widgets/plan_panel.dart',
        'lib/features/pricing/presentation/widgets/plan_card.dart',
        'lib/features/settings/presentation/widgets/billing_section.dart',
      ]),
    );
  });

  test('nothing promises a way to cancel', () {
    final List<String> offenders = <String>[
      for (final File f in files())
        for (final (int i, String line) in stripComments(
          f.readAsStringSync(),
        ).split('\n').indexed)
          if (promise.hasMatch(line)) '${f.path}:${i + 1}: ${line.trim()}',
    ];
    expect(offenders, isEmpty);
  });
}
