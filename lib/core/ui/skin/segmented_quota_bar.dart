import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/skin_colors.dart';

/// Segmented quota bar — the "Digital Twin" fixed-quota indicator in the
/// Subscription sheet (screenshot 2375): 5 rounded segments, height 16,
/// radius 8, 6dp gaps, first segment filled brand cyan, the rest in the
/// grey #454545 track color.
///
/// A [CustomPainter] draws [segments] equal-width rounded rects with
/// [gap]-wide spaces; the first [filled] are painted [fillColor], the rest
/// [trackColor].
class SegmentedQuotaBar extends StatelessWidget {
  const SegmentedQuotaBar({
    required this.segments,
    required this.filled,
    this.height = 16,
    this.gap = 6,
    this.radius = 8,
    this.fillColor = SkinColors.brandCyan,
    this.trackColor = SkinColors.quotaTrackGrey,
    super.key,
  }) : assert(segments > 0, 'segments must be positive'),
       assert(
         filled >= 0 && filled <= segments,
         'filled must be within 0..segments',
       );

  /// Total number of segments (5 in 2375).
  final int segments;

  /// Number of leading segments painted [fillColor] (1 in 2375).
  final int filled;

  /// Bar height in design dp.
  final double height;

  /// Gap between segments in design dp.
  final double gap;

  /// Segment corner radius in design dp.
  final double radius;

  final Color fillColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: CustomPaint(
        painter: _SegmentedQuotaPainter(
          segments: segments,
          filled: filled,
          gap: gap.w,
          radius: radius.r,
          fillColor: fillColor,
          trackColor: trackColor,
        ),
      ),
    );
  }
}

class _SegmentedQuotaPainter extends CustomPainter {
  const _SegmentedQuotaPainter({
    required this.segments,
    required this.filled,
    required this.gap,
    required this.radius,
    required this.fillColor,
    required this.trackColor,
  });

  final int segments;
  final int filled;
  final double gap;
  final double radius;
  final Color fillColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final segWidth = (size.width - gap * (segments - 1)) / segments;
    if (segWidth <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final r = Radius.circular(radius.clamp(0, size.height / 2).toDouble());

    for (var i = 0; i < segments; i++) {
      paint.color = i < filled ? fillColor : trackColor;
      final left = i * (segWidth + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, 0, segWidth, size.height),
          r,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SegmentedQuotaPainter old) =>
      old.segments != segments ||
      old.filled != filled ||
      old.gap != gap ||
      old.radius != radius ||
      old.fillColor != fillColor ||
      old.trackColor != trackColor;
}
