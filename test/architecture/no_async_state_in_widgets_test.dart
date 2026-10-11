import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// No widget may hold the in-flight or failure state of an async use case.
///
/// ARCHITECTURE.md: "application/ owns anything that outlives the widget or
/// that two parts of the app must agree on", and names in-flight flags and
/// call results as the first two examples.
///
/// ## Why this exists
///
/// Because the rule was enforced once, by hand, across 48 files — and that
/// does not survive the next contributor. Every one of these shipped as a
/// user-visible defect from a `bool _busy` or a `String? _error` on a widget:
///
///   * a login screen you could be signed in behind — the post-auth router
///     handoff ran on a page and was skipped once the page was disposed
///   * an unlock screen that discarded a SUCCESSFUL biometric unlock, because
///     the outcome was read after an `if (!mounted) return;`
///   * two concurrent season-advance writes, from three cards each holding
///     their own `_busy`
///   * 800 XP charged for a poster with no logo, from one operation's state
///     split across a widget and a controller
///   * a failed reschedule that vanished when the user left the screen
///
/// None of them looked wrong in review. Each was one plausible field on a
/// widget that already had ten.
///
/// ## What this does NOT catch
///
/// Plenty. It matches field DECLARATIONS by name, so it will miss state
/// spelled `_working`, state inside a record, or orchestration done without a
/// flag at all. It is a tripwire on the common shape, not a proof. The real
/// check is the question in the doc: if the widget were disposed
/// mid-operation, or a second screen asked, would the answer be wrong?
void main() {
  /// The one legitimate case, and why.
  ///
  /// `_PathCardState._busy` on the season-complete screen is SPINNER state,
  /// not a guard. The guard that stops a second irreversible
  /// `POST /season/advance` is the shared one on
  /// `seasonAdvanceControllerProvider` — three cards are built, and one tap
  /// has to close all three, which a per-card field cannot do. This flag only
  /// says which of the three the user tapped, so its own card spins and the
  /// other two merely disable. That is per-card visual state, and it is read
  /// alongside the shared guard: `(advancing || _busy)`.
  ///
  /// An addition here needs that standard of argument. "It is only small" is
  /// not one.
  const Map<String, String> allowed = <String, String>{
    'lib/features/missions/presentation/pages/season_complete_page.dart':
        'spinner-only; the real guard is on seasonAdvanceControllerProvider',
  };

  /// Comments stripped, so a field that has been commented out does not count
  /// as present and a commented-out one does not count as a violation.
  ///
  /// The disposal guard next door shipped without this and could not fail for
  /// the reason it existed.
  String stripComments(String src) => src
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  /// A field declaration whose NAME says it tracks an async operation.
  final RegExp asyncField = RegExp(
    r'^\s*(?:late\s+)?(?:final\s+)?(?:bool|String\?|Object\?|Exception\?)\s+'
    r'(_(?:busy|loading|saving|submitting|sending|uploading|deleting|'
    r'generating|error|failure))\b',
    multiLine: true,
  );

  test('no presentation widget declares async in-flight or failure state', () {
    final List<String> offenders = <String>[];

    for (final FileSystemEntity entity
        in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }
      // Only the UI layers. A controller in application/ SHOULD hold these.
      final bool isUi =
          entity.path.contains('/presentation/') ||
          entity.path.startsWith('lib/core/ui/');
      if (!isUi) continue;
      if (allowed.containsKey(entity.path)) continue;

      final String src = stripComments(entity.readAsStringSync());
      for (final Match m in asyncField.allMatches(src)) {
        offenders.add('${entity.path}  →  ${m.group(1)}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These hold the state of an async operation on a widget. A widget '
          'can be disposed mid-call, built more than once, or disagree with '
          'its sibling — put the flag and the result on the slice\'s '
          'application/ controller and have the widget read it.\n  '
          '${offenders.join("\n  ")}',
    );
  });

  test('the allowlist still describes real code', () {
    // An exemption outliving its reason is how an allowlist becomes a
    // loophole.
    for (final MapEntry<String, String> e in allowed.entries) {
      final File f = File(e.key);
      expect(f.existsSync(), isTrue, reason: '${e.key} no longer exists');
      expect(
        asyncField.hasMatch(stripComments(f.readAsStringSync())),
        isTrue,
        reason:
            '${e.key} no longer declares one — delete it from the allowlist '
            'rather than leaving a standing exemption nothing uses.',
      );
    }
  });
}
