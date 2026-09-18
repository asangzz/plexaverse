import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_text_theme.dart';

/// Left-side year labels for the Global Timeline's scrolling viewport.
///
/// Ported verbatim (math + thresholds) from Wonderous's `_YearMarkers` /
/// `_YearMarker` (`lib/ui/screens/timeline/widgets/_year_markers.dart`):
/// the marker interval adapts to the viewport's available height — 500yr
/// steps under 800px, 250yr steps under 1500px, 100yr steps otherwise — and
/// each marker's vertical position is a straight 0-1 normalization of its
/// year against [startYear]/[endYear]. Only presentational sizing (the
/// track width, text style) is ScreenUtil-scaled; the interval thresholds
/// and offset formula are numeric constants from Wonderous and are not
/// touched.
class TimelineYearMarkers extends StatelessWidget {
  const TimelineYearMarkers({
    required this.startYear,
    required this.endYear,
    super.key,
  });

  final int startYear;
  final int endYear;

  int get _totalYrs => endYear - startYear;

  /// Normalizes a given year to a value from 0 - 1, based on start and end yr.
  double _calculateOffsetY(int yr) => (yr - startYear) / _totalYrs;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (_, constraints) {
          int interval = 100;
          if (constraints.maxHeight < 800) {
            interval = 500;
          } else if (constraints.maxHeight < 1500) {
            interval = 250;
          }

          // If interval is 100 and time is 0 - 1000 yrs, make a list of 11
          // items: [0, 100, 200, ..., 1000 ]
          final int numMarkers = (_totalYrs / interval).round() + 1;
          final List<int> markers = List.generate(numMarkers, (i) {
            return startYear + i * interval;
          });

          return SizedBox(
            width: 100.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Stack(
                key: ValueKey(interval),
                children: markers.map((yr) {
                  return _YearMarker(yr, _calculateOffsetY(yr));
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _YearMarker extends StatelessWidget {
  const _YearMarker(this.yr, this.offset);

  final int yr;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Align(
        alignment: Alignment(0, -1 + offset * 2),

        // Use an OverflowBox wrapped in a zero-height SizedBox so that
        // alignment-based positioning stays accurate even at the edges of
        // the parent.
        child: SizedBox(
          height: 0,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: 100.h,
            maxWidth: 100.w,
            child: FractionalTranslation(
              translation: const Offset(0, -.5),
              child: Text(
                '${yr.abs()}',
                style: AppTextTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
