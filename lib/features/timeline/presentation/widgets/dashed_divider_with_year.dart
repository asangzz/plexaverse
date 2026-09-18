import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../domain/timeline_era.dart';

/// Center dashed rule + big "current year" readout for the Global Timeline
/// viewport.
///
/// Ports Wonderous's `_DashedDividerWithYear` (a private class living inside
/// `timeline_screen.dart`) verbatim: the incoming [year] is rounded to the
/// nearest 10 (`yrGap = 10`) before display, and negative years render their
/// absolute value with a `BCE` suffix from [yearSuffix] (see
/// `../../domain/timeline_era.dart`) — this rounding/suffix logic is
/// untouched timeline math, not a presentational choice.
///
/// Wonderous laid this out as `Center(child: DashedLine())` under a
/// `CenterRight`-aligned year label nudged up by half its own height via
/// `FractionalTranslation`. The shared `TimelineDashedLine` widget (per the
/// port manifest's `dashed_line.dart`) had not landed in the repo yet when
/// this file was authored, so the horizontal dash rule below is a small
/// private `_HorizontalDashedLine` with the exact same 3px-dash/3px-gap
/// `CustomPainter` math (scaled via `.r` like every other presentational
/// constant in this port). Once `dashed_line.dart` exists, swap that private
/// widget out for `TimelineDashedLine(vertical: false)` to de-duplicate —
/// see the future Plexaverse-data integration guide for the swap-in note.
class DashedDividerWithYear extends StatelessWidget {
  const DashedDividerWithYear(this.year, {super.key});

  /// The raw (unrounded) year the timeline is currently scrolled to.
  final int year;

  @override
  Widget build(BuildContext context) {
    const yrGap = 10;
    final roundedYr = (year / yrGap).round() * yrGap;
    return Stack(
      children: [
        const Center(child: _HorizontalDashedLine()),
        Align(
          alignment: Alignment.centerRight,
          child: FractionalTranslation(
            translation: const Offset(0, -.5),
            child: MergeSemantics(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${roundedYr.abs()}',
                    style: AppTextTheme.headlineLarge.copyWith(
                      color: Colors.white,
                      shadows: _textShadow,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    yearSuffix(roundedYr),
                    style: AppTextTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      shadows: _textShadowStrong,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Ported verbatim from Wonderous's `$styles.shadows.text` (dark 60%-alpha
/// drop shadow, 2px down / 2px blur) so the big year readout stays legible
/// over the timeline's shifting background art.
const _textShadow = [
  Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 2),
];

/// Ported verbatim from Wonderous's `$styles.shadows.textStrong` (dark
/// 60%-alpha drop shadow, 4px down / 6px blur) — used for the smaller
/// BCE/CE suffix, which needs a stronger halo to read at its size.
const _textShadowStrong = [
  Shadow(color: Color(0x99000000), offset: Offset(0, 4), blurRadius: 6),
];

/// Horizontal 3px-dash / 3px-gap rule, ported from Wonderous's
/// `DashedLine`/`_DashedLinePainter` (`lib/ui/common/dashed_line.dart`).
///
/// This is a private stand-in for the shared `TimelineDashedLine` widget
/// (see the class doc comment above) — same painter math, just scoped to
/// this file until `dashed_line.dart` lands.
class _HorizontalDashedLine extends StatelessWidget {
  const _HorizontalDashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 2.h,
      child: CustomPaint(painter: _HorizontalDashedLinePainter()),
    );
  }
}

class _HorizontalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dashPx = 3.r, gapPx = 3.r;
    var pos = 0.0;
    final paint = Paint()..color = Colors.white;
    while (pos < size.width) {
      canvas.drawLine(Offset(pos, 0), Offset(pos + dashPx, 0), paint);
      pos += dashPx + gapPx;
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalDashedLinePainter oldDelegate) => false;
}
