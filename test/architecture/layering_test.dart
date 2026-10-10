import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The inward dependency rule, enforced.
///
/// ARCHITECTURE.md: `presentation -> application -> domain <- data`, and
/// "presentation/ — pages and widgets. UI only; reads state from application/
/// controllers."
///
/// ## Why this is a test and not a convention
///
/// Because the convention lost. An audit found SIX presentation files reading
/// a repository directly, and in every case the same defect followed: with no
/// controller in the path, the operation's in-flight state had nowhere to live
/// but the widget, and a widget can be disposed mid-operation, built three
/// times, or disagree with its sibling. That produced a login screen you could
/// be signed in behind, two concurrent season-advance writes, an 800 XP charge
/// for a poster with no logo, and an account-deletion button that could not
/// succeed. The layering break and the bug were the same defect seen from two
/// sides.
///
/// None of those were caught by review, because each was one plausible-looking
/// import added to a file that already had twenty.
void main() {
  /// The one file still allowed to do this, and why.
  ///
  /// `PlexaChatController` is a plain `ChangeNotifier` constructed by hand in
  /// the sheet's field initializer, because the conversation is deliberately
  /// per-sheet rather than global — so the sheet must hand it a repository,
  /// which means importing `data/`. Converting it to an `@riverpod` notifier
  /// is a real design change, not a move, and it is tracked separately.
  ///
  /// Nothing else may be added here. A second entry means the rule has been
  /// renegotiated, and that is a conversation, not a diff.
  const Set<String> allowed = <String>{
    'lib/features/plexa/presentation/plexa_day_sheet.dart',
  };

  test('no presentation file imports a data layer', () {
    // Matches a data/ import whether it is this slice's (`../../data/`) or
    // another slice's (`../../../posts/data/`) — the cross-slice form is the
    // worse of the two and was the one most recently introduced.
    final RegExp dataImport = RegExp(
      r"""import\s+'(?:\.\./)+(?:[a-z_]+/)?data/""",
    );

    final List<String> offenders = <String>[];

    for (final FileSystemEntity entity
        in Directory('lib/features').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (!entity.path.contains('/presentation/')) continue;
      if (allowed.contains(entity.path)) continue;

      for (final String line in entity.readAsLinesSync()) {
        if (dataImport.hasMatch(line)) {
          offenders.add('${entity.path}\n      $line');
          break;
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These read a repository from presentation/, which reverses the '
          'dependency arrow and leaves the operation\'s state with nowhere to '
          'live but the widget. Put the call on an application/ controller '
          'and have the widget read it.\n  ${offenders.join("\n  ")}',
    );
  });

  test('the allowlist is still accurate', () {
    // An exemption for a file that no longer needs one is how an allowlist
    // quietly becomes a loophole.
    for (final String path in allowed) {
      final File f = File(path);
      expect(f.existsSync(), isTrue, reason: '$path no longer exists');
      expect(
        f.readAsStringSync(),
        contains("data/"),
        reason:
            '$path no longer imports data/ — delete it from the allowlist '
            'rather than leaving a standing exemption nothing uses.',
      );
    }
  });
}
