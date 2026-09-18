import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../motion/spring_press.dart';

/// White circular FAB with a black hand-painted plus — the 4th slot of the
/// bottom nav row in screenshots 2353/2354/2369 (opens the Create sheet,
/// 2377).
///
/// Pure-white circle Ø56 with a subtle drop shadow; the `+` glyph is a
/// [CustomPainter] (required per spec) drawing two 24dp strokes at 2.5
/// width with rounded caps — crisper than any icon-font plus at this size.
class SkinFab extends StatelessWidget {
  const SkinFab({
    required this.onTap,
    this.size = 56,
    this.glyphSize = 24,
    this.strokeWidth = 2.5,
    super.key,
  });

  final VoidCallback onTap;

  /// Circle diameter in design dp.
  final double size;

  /// Plus glyph extent (arm-to-arm) in design dp.
  final double glyphSize;

  /// Plus stroke width in design dp.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final d = size.r;
    return SpringPress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _PlusPainter(
              glyphSize: glyphSize.r,
              strokeWidth: strokeWidth.r,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter({required this.glyphSize, required this.strokeWidth});

  final double glyphSize;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final c = size.center(Offset.zero);
    final half = glyphSize / 2;
    canvas.drawLine(c - Offset(half, 0), c + Offset(half, 0), paint);
    canvas.drawLine(c - Offset(0, half), c + Offset(0, half), paint);
  }

  @override
  bool shouldRepaint(_PlusPainter old) =>
      old.glyphSize != glyphSize || old.strokeWidth != strokeWidth;
}
