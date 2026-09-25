import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';

/// The circle at the head of a list row.
///
/// Every row in the reference opens with one — a filled violet disc for the
/// thing that happened, a glass disc for the rest, a photo where there is a
/// photo. It is what makes a column of rows scan as a list rather than as
/// stacked paragraphs, and it is the same 44pt across every screen so the
/// titles beside them line up down the page.
///
/// [tone] is not decoration. It says which of three things this row is, and
/// the palette rule still holds: colour names a status.
enum ZaveRowTone {
  /// Ordinary. A glass disc, the icon in ink-62.
  rest,

  /// Done, published, complete. Green, because green is this palette's word
  /// for finished.
  done,

  /// Happening now. Violet — the same "this is the one" the filled card uses,
  /// and just as rare.
  now,
}

class ZaveRowCircle extends StatelessWidget {
  const ZaveRowCircle({
    required this.icon,
    this.tone = ZaveRowTone.rest,
    super.key,
  }) : image = null;

  const ZaveRowCircle.image({required this.image, super.key})
    : icon = null,
      tone = ZaveRowTone.rest;

  final IconData? icon;
  final Widget? image;
  final ZaveRowTone tone;

  /// One size everywhere. A row whose circle is a different diameter from the
  /// row above it breaks the line the titles hang on.
  static const double size = 44;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipOval(
        child: SizedBox.square(dimension: size, child: image),
      );
    }

    final (Color fill, Color border, Color fg) = switch (tone) {
      ZaveRowTone.done => (
        ZaveColors.green,
        ZaveColors.green,
        // Ink on a solid fill, the same way a white pill carries ink letters.
        ZaveColors.ink,
      ),
      ZaveRowTone.now => (
        ZaveColors.violet,
        ZaveColors.violet,
        ZaveColors.white,
      ),
      ZaveRowTone.rest => (
        ZaveGlass.controlFill,
        ZaveColors.rule,
        ZaveColors.ink62,
      ),
    };

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }
}
