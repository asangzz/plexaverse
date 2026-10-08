import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/theme/zave/zave.dart';

/// No implicit decoration animation may be handed a [ZaveEdgeBorder].
///
/// ## Why a source scan and not a widget test
///
/// Because the failure needs a GESTURE at a FRAME. `BoxDecoration.lerp` calls
/// `BoxBorder.lerp`, a static with hardcoded `is Border?` /
/// `is BorderDirectional?` checks — so a [ZaveEdgeBorder] cannot be
/// interpolated to, from, or between two of itself. It throws only while the
/// implicit animation is mid-flight: both settled states render perfectly, and
/// `pumpAndSettle` steps straight over the middle.
///
/// That is why it shipped three times. `ZaveChip` threw on every tap, which is
/// what the red flash on the Persona tabs was. `ZaveCard` threw 15ms into
/// every press, on every tappable card in the app. `ReplyLane`'s chip threw on
/// every onboarding reply. Each was found by a person looking at a screen, and
/// each time the fix was local and the next instance was still out there.
///
/// Pressing every widget in a widget test would catch them, but only the ones
/// somebody remembered to press. Reading the source catches the pattern.
///
/// ## What to do when this fails
///
/// Do not make [ZaveEdgeBorder] lerpable — `BoxBorder.lerp` never asks the
/// operands, so there is nothing to implement. Choose instead:
///
///   * rebuild the decoration per frame from interpolated INPUTS — gradients
///     with `Gradient.lerp`, shadows with `BoxShadow.lerpList` — driven by a
///     `TweenAnimationBuilder<double>` (what `ZaveCard` does);
///   * cross-fade two static `DecoratedBox`es (what `ZaveChip` does);
///   * or drop to a plain `Container` where the swap wants to be instant
///     (what `ReplyLane` does — `ZavePress` already animates the press).
void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // Reading Dart without a Dart parser
  // ══════════════════════════════════════════════════════════════════════════

  /// The source from [open] to its matching close bracket.
  String balanced(String src, int open) {
    int depth = 0;
    for (int i = open; i < src.length; i++) {
      final String c = src[i];
      if (c == '(' || c == '[' || c == '{') depth++;
      if (c == ')' || c == ']' || c == '}') {
        depth--;
        if (depth == 0) return src.substring(open, i + 1);
      }
    }
    return src.substring(open);
  }

  /// The expression passed to the named argument [label], bracket-aware so a
  /// ternary or a nested constructor is returned whole.
  String? namedArg(String call, String label) {
    final int at = call.indexOf(label);
    if (at < 0) return null;

    final StringBuffer out = StringBuffer();
    int depth = 0;
    for (int i = at + label.length; i < call.length; i++) {
      final String c = call[i];
      if (c == '(' || c == '[' || c == '{') depth++;
      if (c == ')' || c == ']' || c == '}') {
        if (depth == 0) break;
        depth--;
      }
      if (c == ',' && depth == 0) break;
      out.write(c);
    }
    return out.toString().trim();
  }

  /// The statement that assigns [ident], so `decoration: deco` can be followed
  /// back to the `BoxDecoration` built seventeen lines earlier.
  ///
  /// This indirection is the whole reason this is not a line-window grep: the
  /// pre-fix `ZaveCard` built its decoration into a local and the window never
  /// reached it, so a naive scan called the file clean.
  String assignmentOf(String src, String ident) {
    final Match? m = RegExp('\\b$ident\\s*=(?!=)').firstMatch(src);
    if (m == null) return '';

    final StringBuffer out = StringBuffer();
    int depth = 0;
    for (int i = m.end; i < src.length; i++) {
      final String c = src[i];
      if (c == '(' || c == '[' || c == '{') depth++;
      if (c == ')' || c == ']' || c == '}') depth--;
      if (c == ';' && depth == 0) break;
      out.write(c);
    }
    return out.toString();
  }

  /// The surfaces that carry a [ZaveEdgeBorder], read out of the source rather
  /// than listed here.
  ///
  /// A hand-written list is a second copy of the palette, and it rots the
  /// first time somebody adds a `_glass(...)` surface — silently, since a
  /// missing entry makes this test PASS.
  Set<String> borderedSurfaces() {
    final String src = File(
      'lib/core/theme/zave/zave_surfaces.dart',
    ).readAsStringSync();

    final Set<String> bordered = <String>{};
    for (final String chunk in src.split('static BoxDecoration get ').skip(1)) {
      final int arrow = chunk.indexOf('=>');
      if (arrow < 0) continue;
      final String name = chunk.substring(0, arrow).trim();
      final String body = chunk.substring(arrow);
      // `_glass` attaches one; `iconButton` builds its own inline.
      if (body.contains('_glass(') || body.contains('ZaveEdgeBorder(')) {
        bordered.add(name);
      }
    }
    return bordered;
  }

  // ══════════════════════════════════════════════════════════════════════════

  test('ZaveEdgeBorder is still not a Border — the whole premise', () {
    // If this ever changes, `BoxBorder.lerp` would handle it and this file can
    // go. Until then the scan below is load-bearing.
    const ZaveEdgeBorder edge = ZaveEdgeBorder(
      gradient: LinearGradient(
        colors: <Color>[Color(0xFFFFFFFF), Color(0x00FFFFFF)],
      ),
    );
    expect(edge, isNot(isA<Border>()));
    expect(edge, isNot(isA<BorderDirectional>()));
    expect(edge, isA<BoxBorder>());
  });

  test('the bordered surfaces were actually found', () {
    // Guards the scan itself: a parser that silently matched nothing would
    // make the real assertion below vacuous and green forever.
    final Set<String> bordered = borderedSurfaces();
    expect(bordered, contains('card'));
    expect(bordered, contains('chip'));
    expect(bordered, contains('iconButton'));
    // `chipSelected` is a bare gradient pill with no border at all — the auth
    // page's mode toggle animates to and from it legitimately, and a substring
    // match on `chip` wrongly flagged it once already.
    expect(bordered, isNot(contains('chipSelected')));
    expect(bordered, isNot(contains('navItemSelected')));
    // `header` draws a real `Border`, which lerps fine.
    expect(bordered, isNot(contains('header')));
  });

  test('no implicit animation interpolates a Zave bordered surface', () {
    final Set<String> bordered = borderedSurfaces();

    // Word-boundaried, so `ZaveSurface.chip` does not match
    // `ZaveSurface.chipSelected`.
    final List<RegExp> carriesBorder = <RegExp>[
      RegExp(r'ZaveEdgeBorder\s*\('),
      for (final String s in bordered) RegExp('ZaveSurface\\.$s\\b'),
    ];

    /// The widgets that lerp a `Decoration` for you, and so reach
    /// `BoxBorder.lerp`.
    const List<String> animators = <String>[
      'AnimatedContainer(',
      'DecorationTween(',
      'DecoratedBoxTransition(',
    ];

    final List<String> offenders = <String>[];

    for (final FileSystemEntity f in Directory('lib')
        .listSync(recursive: true)
        .where((FileSystemEntity e) => e.path.endsWith('.dart'))) {
      final String src = File(f.path).readAsStringSync();

      for (final String widget in animators) {
        for (int at = src.indexOf(widget); at >= 0;
            at = src.indexOf(widget, at + 1)) {
          final String call = balanced(src, at + widget.length - 1);

          // `DecorationTween` names them begin/end; the others, decoration.
          final List<String> args = <String>[
            for (final String label in <String>[
              'decoration:',
              'begin:',
              'end:',
            ])
              ?namedArg(call, label),
          ];
          if (args.isEmpty) continue;

          final bool hits = args.any((String arg) {
            // A bare identifier is a local — follow it to its assignment.
            final String text = RegExp(r'^[_a-zA-Z][_a-zA-Z0-9]*$')
                    .hasMatch(arg)
                ? assignmentOf(src, arg)
                : arg;
            return carriesBorder.any((RegExp p) => p.hasMatch(text));
          });

          if (hits) {
            final int line = '\n'.allMatches(src.substring(0, at)).length + 1;
            offenders.add('${f.path}:$line');
          }
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These interpolate a decoration whose border is a ZaveEdgeBorder, '
          'which throws "BoxBorder.lerp can only interpolate Border and '
          'BorderDirectional" for the whole length of the transition — a red '
          "box where the control should be. See this file's doc for the three "
          'ways out.\n  ${offenders.join("\n  ")}',
    );
  });
}
