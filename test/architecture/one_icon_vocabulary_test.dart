import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every icon in the app comes from [AppIcons], never from Material.
///
/// ## Why this is a test
///
/// `app_icons.dart` opens by calling itself "the app's single icon vocabulary"
/// and promising that "to restyle an icon app-wide, change it here once".
/// Neither was true: 198 call sites across 86 files drew stock Material
/// glyphs, and the file had no entry for the things screens reach for most —
/// a sparkle for "generate this", an external-link arrow, a copy glyph.
///
/// So the rule was not being broken by carelessness. It was being broken
/// because obeying it was impossible, and each miss was invisible on its own.
/// Together they were not: Font Awesome solid is a heavy geometric face and
/// Material's default is a thin outline face, so a row carrying one of each
/// reads as two different products. The settings list had a Font Awesome
/// person above a Material briefcase above a Material hash.
///
/// A missing glyph is now a one-line addition to `AppIcons` — which is the
/// point. This test fails on the Material glyph, so the next contributor adds
/// the entry instead of reaching past the file.
///
/// ## What this does NOT catch
///
/// An `IconData` built inline from a codepoint, an icon from some third
/// package, or an image standing in for an icon. It is a tripwire on the
/// common shape.
void main() {
  /// `Icons.foo`, but not `AppIcons.foo`.
  ///
  /// The negative lookbehind is load-bearing and was wrong first: without it
  /// the pattern matched `AppIcons.check` too, so an early count of this very
  /// problem read 240 instead of 198 and listed `Icons.slack` — a glyph that
  /// only ever existed on `AppIcons`.
  final RegExp materialIcon = RegExp(r'(?<!App)\bIcons\.([a-zA-Z0-9_]+)');

  /// Comments stripped, so prose naming the Material icon an entry replaced
  /// does not count as a use of it. `AppIcons` documents exactly that for
  /// every glyph, so without this the file fails its own rule.
  String stripComments(String src) => src
      .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
      .replaceAll(RegExp(r'//[^\n]*'), '');

  test('no file in lib/ draws a Material icon', () {
    final List<String> offenders = <String>[];

    for (final FileSystemEntity entity in Directory(
      'lib',
    ).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }

      final String src = stripComments(entity.readAsStringSync());
      for (final Match m in materialIcon.allMatches(src)) {
        offenders.add('${entity.path}  →  Icons.${m.group(1)}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These draw a stock Material glyph beside the app\'s Font Awesome '
          'ones. Add the glyph to AppIcons — codepoint read off the bundled '
          'font_awesome_flutter, not from memory — and use it here.\n  '
          '${offenders.join("\n  ")}',
    );
  });

  test('the scan can still see a Material icon', () {
    // Guards the assertion above. A regex that silently stopped matching
    // would make it pass forever — which is how the layering test's
    // allowlist check and the notifier disposal check both shipped broken.
    expect(
      materialIcon.hasMatch('Icon(Icons.arrow_back)'),
      isTrue,
      reason: 'the pattern no longer matches a real Material icon',
    );
    expect(
      materialIcon.hasMatch('Icon(AppIcons.back)'),
      isFalse,
      reason: 'the pattern matches AppIcons, so it would flag the fix itself',
    );
  });
}
