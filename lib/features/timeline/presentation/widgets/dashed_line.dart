import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';

/// Shared 3px-dash / 3px-gap rule, drawable vertically or horizontally.
///
/// Ported verbatim from Wonderous's `DashedLine`/`_DashedLinePainter`
/// (`lib/ui/common/dashed_line.dart`): the dash/gap cadence and the
/// draw-lines-until-we-run-out-of-space loop are unchanged. The 3px dash and
/// 3px gap are presentational sizing constants (not timeline math), so they
/// are scaled with ScreenUtil's `.r` here, and the line's cross-axis
/// thickness uses `.w`/`.h` instead of Wonderous's raw `2`.
///
/// Used by [DashedDividerWithYear] (as the center rule under the big
/// "current year" readout) and [TimelineBottomScrubber] (as the vertical
/// draggable-viewport outline) per the port manifest. Note:
/// `dashed_divider_with_year.dart` currently ships its own private
/// `_HorizontalDashedLine` (authored before this file landed) with identical
/// painter math — a future cleanup pass can swap it out for
/// `TimelineDashedLine(vertical: false)` to de-duplicate.
class TimelineDashedLine extends StatelessWidget {
  const TimelineDashedLine({this.vertical = false, super.key});

  /// When `true`, draws a vertical dashed line filling the available
  /// height; otherwise draws a horizontal dashed line filling the available
  /// width.
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vertical ? 2.w : double.infinity,
      height: vertical ? double.infinity : 2.h,
      child: CustomPaint(painter: _TimelineDashedLinePainter(vertical)),
    );
  }
}

class _TimelineDashedLinePainter extends CustomPainter {
  _TimelineDashedLinePainter(this.vertical);

  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final dashPx = 3.r, gapPx = 3.r;
    var pos = 0.0;
    final paint = Paint()..color = Colors.white;
    if (vertical) {
      while (pos < size.height) {
        canvas.drawLine(Offset(0, pos), Offset(0, pos + dashPx), paint);
        pos += dashPx + gapPx;
      }
    } else {
      while (pos < size.width) {
        canvas.drawLine(Offset(pos, 0), Offset(pos + dashPx, 0), paint);
        pos += dashPx + gapPx;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineDashedLinePainter oldDelegate) =>
      oldDelegate.vertical != vertical;
}
