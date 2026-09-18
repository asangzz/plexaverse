import 'package:flutter/material.dart';

/// Full-screen Home background matching screenshot 2353 (also 2372/2373 —
/// the Translate/Tools tabs share it; only the tab body swaps).
///
/// The reference background is NOT a single linear gradient. Pixel-sampling
/// the screenshot's clean edge strips shows three layers:
///
///   1. a vertical base: indigo `#1D1457` at the very top falling through
///      deep blue to effectively pure black `#010104` at the bottom;
///   2. a violet ELLIPTICAL glow anchored just off the top-right corner —
///      wide (spans the whole top edge, `#472B9C` still at x=30%) but short
///      (gone from the right edge by ~35% height). A circular radial cannot
///      satisfy both, so the painter draws it under a y-compressing canvas
///      scale;
///   3. a faint cyan-blue elliptical glow off the LEFT edge peaking around
///      35% height (`#043E61` — the left edge gets *brighter* going down
///      before fading, impossible with a top-down linear gradient).
///
/// Glow falloff uses a mid-stop to approximate a gaussian rather than the
/// radial gradient's default linear ramp. Constants were fitted against
/// pixel samples of the reference PNG (see the calibration probe test).
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: HomeBackgroundPainter(),
        size: Size.infinite,
      ),
    );
  }
}

@visibleForTesting
class HomeBackgroundPainter extends CustomPainter {
  const HomeBackgroundPainter();

  // ── Layer 1: vertical base (stops in fractions of height) ─────────────
  static const List<Color> _baseColors = [
    Color(0xFF1D1457), // 0.00 indigo
    Color(0xFF100E4E), // 0.10
    Color(0xFF0A0C3E), // 0.22
    Color(0xFF070827), // 0.32
    Color(0xFF05061A), // 0.42 deep navy
    Color(0xFF040413), // 0.55
    Color(0xFF02030D), // 0.70
    Color(0xFF010207), // 0.85
    Color(0xFF010103), // 1.00 near-black
  ];
  static const List<double> _baseStops = [
    0.0, 0.10, 0.22, 0.32, 0.42, 0.55, 0.70, 0.85, 1.0,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _baseColors,
          stops: _baseStops,
        ).createShader(rect),
    );

    // Violet glow — centre just past the top-right corner. Wide (spans the
    // top edge) and short (gone from the right edge by ~35% height). The
    // hue shifts violet → blue-violet with distance, matching the reference.
    // Parameters were least-squares fitted against 38 sampled points of the
    // reference PNG (mean |ΔRGB| ≈ 10.8 ≈ 3.6/channel).
    _drawEllipticalGlow(
      canvas,
      size,
      center: Offset(size.width * 1.113, -size.height * 0.023),
      semiAxisX: size.width * 1.161,
      semiAxisY: size.height * 0.263,
      colors: const [Color(0xFFB544BC), Color(0x707F3BD3), Color(0x007F3BD3)],
      stops: const [0.0, 0.62, 1.0],
    );

    // Teal-blue glow — off the left edge, peaking around 34% height. Teal
    // at the core shifting to blue outward (the reference's left edge shows
    // a distinctly green-tinted brightening around mid-height).
    _drawEllipticalGlow(
      canvas,
      size,
      center: Offset(-size.width * 0.199, size.height * 0.341),
      semiAxisX: size.width * 1.027,
      semiAxisY: size.height * 0.292,
      colors: const [Color(0xA3027F7A), Color(0x54005DCC), Color(0x00005DCC)],
      stops: const [0.0, 0.53, 1.0],
    );
  }

  /// Draws a radial gradient stretched into an ellipse by scaling the canvas
  /// vertically about [center], so `semiAxisX`/`semiAxisY` are true pixel
  /// semi-axes regardless of the paint box's aspect ratio.
  void _drawEllipticalGlow(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double semiAxisX,
    required double semiAxisY,
    required List<Color> colors,
    required List<double> stops,
  }) {
    final scaleY = semiAxisY / semiAxisX;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1, scaleY);

    // The screen rect expressed in the transformed (glow-local) space.
    final local = Rect.fromLTRB(
      -center.dx,
      (0 - center.dy) / scaleY,
      size.width - center.dx,
      (size.height - center.dy) / scaleY,
    );

    canvas.drawRect(
      local,
      Paint()
        // radius is a fraction of the shader rect's shortest side, which is
        // 2 * semiAxisX — so 0.5 yields a gradient radius of semiAxisX.
        ..shader = RadialGradient(
          radius: 0.5,
          colors: colors,
          stops: stops,
        ).createShader(
          Rect.fromCircle(center: Offset.zero, radius: semiAxisX),
        ),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HomeBackgroundPainter oldDelegate) => false;
}
