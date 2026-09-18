import 'package:flutter/material.dart';

import '../../theme/skin_colors.dart';

/// Gradient-filled text — a [ShaderMask] over a plain [Text].
///
/// Matches the "Make video" card titles in screenshot 2353 ("Photo to
/// Video", "Prompt to Video", …): bold 17sp glyphs filled with the cyan
/// ramp #3FC0E7 → #149CC5 running left → right.
///
/// The [style]'s own color is forced to white before masking so the shader
/// modulates at full brightness (a translucent base would dim the gradient).
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    this.colors = const [SkinColors.titleGradStart, SkinColors.titleGradEnd],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.maxLines,
    this.overflow,
    super.key,
  });

  /// The string to render.
  final String text;

  /// Base text style; its color is overridden by the gradient.
  final TextStyle style;

  /// Gradient stops — defaults to the Make-video cyan title ramp.
  final List<Color> colors;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ).createShader(Offset.zero & bounds.size),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
