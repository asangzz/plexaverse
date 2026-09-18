import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../domain/wonder_marker.dart';
import 'dashed_line.dart';
import 'wonders_timeline_builder.dart';

/// Draggable mini-timeline scrubber pinned to the bottom of the Global
/// Timeline screen: a horizontal [WondersTimelineTrackBuilder] track laid
/// over the full year range, with a draggable outline box showing which
/// slice of the timeline the main scrolling viewport currently has in view.
///
/// Ported verbatim from Wonderous's `_BottomScrubber`
/// (`lib/ui/screens/timeline/widgets/_bottom_scrubber.dart`): the
/// `_calculateScrollFraction`/`_calculateViewPortFraction` formulas and the
/// `onPanUpdate` drag-multiplier math (`(maxScrollExtent + timelineMinSize) /
/// totalWidth`) are unchanged. Only presentational constants (the container
/// padding, corner radius) are ScreenUtil-scaled.
///
/// Wonderous's version also took a `selectedWonder` to drive the background
/// track's filled/selected pill styling; this port has dropped "selected
/// wonder" entirely (no wonder-detail page to select one from yet — see the
/// future Plexaverse-data integration guide), so the background track is
/// always rendered in its default (unselected, outlined) style.
class TimelineBottomScrubber extends StatelessWidget {
  const TimelineBottomScrubber({
    required this.scroller,
    required this.timelineMinSize,
    required this.size,
    required this.wonders,
    super.key,
  });

  /// The main scrolling viewport's [ScrollController]. It may take a frame
  /// after the viewport mounts before this has clients attached.
  final ScrollController? scroller;

  /// The minimum extent of the scrolling viewport's content — added to
  /// `maxScrollExtent` in the drag-multiplier formula, exactly like
  /// Wonderous's `timelineMinSize`.
  final double timelineMinSize;

  /// The overall height of the scrubber bar.
  final double size;

  /// The 8 wonder construction-span markers, forwarded to the background
  /// [WondersTimelineTrackBuilder].
  final List<WonderMarker> wonders;

  /// Calculate what fraction the scroller has travelled. Ported verbatim
  /// from Wonderous's `_calculateScrollFraction`.
  double _calculateScrollFraction(ScrollPosition? pos) {
    if (pos == null || pos.maxScrollExtent == 0) return 0;
    return pos.pixels / pos.maxScrollExtent;
  }

  /// Calculates what fraction of the scroller is currently visible. Ported
  /// verbatim from Wonderous's `_calculateViewPortFraction`.
  double _calculateViewPortFraction(ScrollPosition? pos) {
    if (pos == null) return 1;
    final double viewportSize = pos.viewportDimension;
    final double result = viewportSize / (pos.maxScrollExtent + viewportSize);
    return result.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController? scroller = this.scroller;

    // It might take a frame until we receive a valid scroller.
    if (scroller == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        void handleScrubberPan(DragUpdateDetails details) {
          final double totalWidth = constraints.maxWidth;
          if (!scroller.hasClients) return;
          final double dragMultiplier =
              (scroller.position.maxScrollExtent + timelineMinSize) / totalWidth;
          final double newPos = scroller.position.pixels + details.delta.dx * dragMultiplier;
          scroller.position.jumpTo(newPos.clamp(0, scroller.position.maxScrollExtent));
        }

        return SizedBox(
          height: size,
          child: Stack(
            children: [
              // Timeline background.
              Container(
                padding: EdgeInsets.all(AppSpacing.md.w),
                decoration: BoxDecoration(
                  color: SkinColors.sheetDark,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: WondersTimelineTrackBuilder(
                  wonders: wonders,
                  axis: Axis.horizontal,
                  // Wonderous explicitly overrides its WondersTimelineBuilder
                  // default (`$styles.insets.xs` = 8*scale) with a raw `4`
                  // here — half of its own default gap. `AppSpacing.xs` (4)
                  // is likewise half of `AppSpacing.sm` (8), Plexaverse's
                  // closest analog to Wonderous's `insets.xs`, so it is used
                  // here to preserve that same ratio.
                  crossAxisGap: AppSpacing.xs.w,
                ),
              ),

              // Visible area, follows the position of scroller.
              AnimatedBuilder(
                animation: scroller,
                builder: (_, _) {
                  ScrollPosition? pos;
                  if (scroller.hasClients) pos = scroller.position;
                  // Get current scroll offset and move the viewport to match.
                  final double scrollFraction = _calculateScrollFraction(pos);
                  final double viewPortFraction = _calculateViewPortFraction(pos);
                  final Alignment scrubberAlign = Alignment(-1 + scrollFraction * 2, 0);

                  return Positioned.fill(
                    child: Semantics(
                      container: true,
                      slider: true,
                      label: 'Timeline Scrubber, drag horizontally to navigate the timeline.',
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onPanUpdate: handleScrubberPan,
                        // Scrub area.
                        child: Align(
                          alignment: scrubberAlign,
                          child: FractionallySizedBox(
                            widthFactor: viewPortFraction,
                            heightFactor: 1,
                            child: _buildOutlineBox(scrubberAlign),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutlineBox(Alignment alignment) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Align(alignment: alignment, child: const TimelineDashedLine(vertical: true)),
    );
  }
}
