import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../domain/timeline_era.dart';
import '../../domain/wonder_marker.dart';
import '../../domain/wonder_type.dart';

/// A single wonder's construction-span entry, rendered inside a
/// [WondersTimelineTrackBuilder] track. Given the wonder's own
/// [startYr]/[endYr] and the year currently centered in the scrolling
/// viewport ([selectedYear]), it slides a rounded-pill thumbnail up/down
/// within its track slot to track scroll position.
///
/// Ported from Wonderous's `_TimelineSection`
/// (`lib/ui/screens/timeline/widgets/_timeline_section.dart`): the
/// `fraction`/`Alignment` math is kept verbatim (`fraction = clamp((year -
/// startYr) / (endYr - startYr), 0, 1)`, `Alignment(0, -1 + fraction * 2)`).
///
/// Two simplifications from the Wonderous source, both because this port
/// has no wonder-detail page to select a wonder from (see the manifest /
/// future integration guide for wiring a real selection source):
///   - Wonderous compared against a `selectedWonder` (`isSelected`) to
///     decide whether to reveal full color or apply a luminosity dim. That
///     signal doesn't exist here, so the luminosity dim is ALWAYS applied.
///   - `BlendMask(blendModes: ..., opacity: .6)` (a Wonderous package) is
///     replaced with a `ColorFiltered` luminosity filter plus a plain
///     `Opacity(.6)`, per the COMMON widget-replacement rules.
class TimelineMarkerEntry extends StatelessWidget {
  const TimelineMarkerEntry({required this.wonder, required this.selectedYear, super.key});

  /// The wonder this entry renders (construction span + thumbnail + color).
  final WonderMarker wonder;

  /// The year currently centered in the scrolling viewport, used to slide
  /// this entry's thumbnail within its track slot.
  final int selectedYear;

  @override
  Widget build(BuildContext context) {
    final int startYr = wonder.startYr;
    final int endYr = wonder.endYr;
    double fraction = (selectedYear - startYr) / (endYr - startYr);
    fraction = fraction.clamp(0, 1);

    return Semantics(
      label:
          '${wonder.title}, ${_formatYr(startYr)} - ${_formatYr(endYr)}',
      child: IgnorePointer(
        child: Container(
          alignment: Alignment(0, -1 + fraction * 2),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(color: wonder.type.fgColor),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            // Always dimmed — see the class doc comment above for why this
            // port drops Wonderous's isSelected-driven full-color reveal.
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.luminosity),
              child: Opacity(opacity: .6, child: _buildWonderImage()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWonderImage() {
    return Container(
      height: 160.h,
      color: wonder.type.bgColor,
      child: CachedNetworkImage(
        imageUrl: wonder.thumbnailUrl,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -.5),
        placeholder: (_, _) => Shimmer.fromColors(
          baseColor: SkinColors.cardNavyEnd,
          highlightColor: SkinColors.cardNavyStart,
          child: const ColoredBox(color: SkinColors.cardNavyEnd),
        ),
        errorWidget: (_, _, _) => const ColoredBox(color: SkinColors.cardNavyEnd),
      ),
    );
  }

  /// `'3000 BCE'` / `'2200 CE'` style formatting for the accessibility
  /// label, ported from Wonderous's `StringUtils.formatYr`.
  String _formatYr(int yr) => '${yr.abs()} ${yearSuffix(yr)}';
}
