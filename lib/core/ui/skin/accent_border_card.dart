import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';

/// Thumbnail treatment for the Home feature cards: a crisp, very thin
/// accent-colored border around the image plus a matching-color inner
/// shadow that intensifies toward the edge. No outer glow/halo — the
/// accent lives entirely at and inside the border, never bleeding past it.
///
/// The accent is either a single flat [color] (Translate = green, Video
/// tools = magenta — matching each tab's title color exactly) or a 2-stop
/// [gradientColors] (Make video = the cyan title gradient). Exactly one of
/// the two must be supplied.
class AccentBorderCard extends StatelessWidget {
  const AccentBorderCard({
    required this.child,
    this.color,
    this.gradientColors,
    this.radius = 16,
    this.borderWidth = 1.0,
    super.key,
  }) : assert(
         (color == null) != (gradientColors == null),
         'Supply exactly one of color or gradientColors',
       );

  /// Card content — typically a thumbnail image.
  final Widget child;

  /// Flat accent color for both the border and the inner shadow.
  final Color? color;

  /// 2-stop gradient accent (start → end) for both the border and the
  /// inner shadow.
  final List<Color>? gradientColors;

  /// Corner radius in design dp (scaled with `.r`).
  final double radius;

  /// Border stroke width in design dp — keep hairline-thin.
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final r = radius.r;
    final bw = borderWidth.r;
    return CustomPaint(
      foregroundPainter: _AccentBorderPainter(
        color: color,
        gradientColors: gradientColors,
        radius: r,
        borderWidth: bw,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            IgnorePointer(
              child: _AccentInnerShadow(
                color: color,
                gradientColors: gradientColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single crisp stroke centered on the rounded-rect edge — solid or
/// gradient, no blur, no halo bleeding outside the card.
class _AccentBorderPainter extends CustomPainter {
  const _AccentBorderPainter({
    required this.color,
    required this.gradientColors,
    required this.radius,
    required this.borderWidth,
  });

  final Color? color;
  final List<Color>? gradientColors;
  final double radius;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    if (gradientColors != null) {
      paint.shader = LinearGradient(
        colors: gradientColors!,
      ).createShader(rect);
    } else {
      paint.color = color!;
    }

    canvas.drawRRect(rrect.deflate(borderWidth / 2), paint);
  }

  @override
  bool shouldRepaint(_AccentBorderPainter old) =>
      old.color != color ||
      old.gradientColors != gradientColors ||
      old.radius != radius ||
      old.borderWidth != borderWidth;
}

/// Inner shadow — the accent color, transparent through the centre and
/// ramping to a moderate tint toward the edge (same falloff shape used
/// across every card: clean through ~68% of the centre-to-corner distance,
/// reaching its peak by ~87%). Kept restrained (peak alpha ~0.40) so it
/// reads as a shadow, not a solid overlay — the photo stays visible
/// throughout.
class _AccentInnerShadow extends StatelessWidget {
  const _AccentInnerShadow({required this.color, required this.gradientColors});

  final Color? color;
  final List<Color>? gradientColors;

  static const double _radius = 0.66;
  static const List<double> _stops = [0.78, 1.0];
  static const double _peakAlpha = 0.40;

  @override
  Widget build(BuildContext context) {
    final edgeColor = gradientColors != null
        ? Color.lerp(gradientColors![0], gradientColors!.last, 0.5)!
        : color!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: _radius,
          colors: [
            edgeColor.withValues(alpha: 0),
            edgeColor.withValues(alpha: _peakAlpha),
          ],
          stops: _stops,
        ),
      ),
    );
  }
}
