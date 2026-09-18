import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/global_timeline_repository.dart';
import '../../domain/wonder_type.dart';

/// Lays the 8 wonders out over the Global Timeline's year axis on 3
/// non-overlapping "tracks" (screenshot: the pill-shaped construction-span
/// markers running alongside the vertical year axis in the main viewport,
/// and again along the bottom scrubber).
///
/// Ported verbatim from Wonderous's `WondersTimelineBuilder`
/// (`lib/ui/common/wonders_timeline_builder.dart`): the px/yr conversion
/// math, the `minSize` clamping, and the exact 3-track groupings are
/// unchanged. Only presentational constants (the inter-track gap, the
/// pill's corner radius) are ScreenUtil-scaled — Wonderous's raw pixel
/// literals are not copied verbatim.
///
/// `axis` is the axis time flows along: [Axis.vertical] for the main
/// viewport (this port's default — Wonderous defaults to horizontal because
/// its main viewport is the odd one out; here the main viewport is the
/// primary caller so the default flips), [Axis.horizontal] for the bottom
/// scrubber.
class WondersTimelineTrackBuilder extends StatelessWidget {
  const WondersTimelineTrackBuilder({
    super.key,
    required this.wonders,
    this.timelineBuilder,
    this.axis = Axis.vertical,
    this.crossAxisGap,
    this.minSize,
  });

  /// The wonder markers to lay out — typically all 8 from
  /// `GlobalTimelineOverview.wonders`.
  final List<WonderMarker> wonders;

  /// Per-entry override, exactly like Wonderous's `timelineBuilder` param.
  /// `isSelected` is always `false` in this port: Plexaverse has no wonder
  /// detail page to select a wonder from yet, so there is no selection
  /// source to drive it (see the future integration guide). The main
  /// viewport supplies its own richer entry via this param; callers that
  /// omit it get [_DefaultTrackEntry].
  final Widget Function(BuildContext context, WonderMarker wonder, bool isSelected)? timelineBuilder;

  /// The axis time flows along.
  final Axis axis;

  /// Gap between the 3 tracks on the cross axis. Defaults to
  /// `AppSpacing.xs` scaled (Wonderous's `$styles.insets.xs`).
  final double? crossAxisGap;

  /// Minimum pill thickness along the main axis, ScreenUtil-scaled by
  /// default (Wonderous's raw `10`-pixel default).
  final double? minSize;

  bool get _isHz => axis == Axis.horizontal;

  static const List<List<WonderType>> _tracks = <List<WonderType>>[
    <WonderType>[WonderType.greatWall, WonderType.pyramidsGiza, WonderType.christRedeemer],
    <WonderType>[WonderType.petra, WonderType.machuPicchu],
    <WonderType>[WonderType.chichenItza, WonderType.tajMahal, WonderType.colosseum],
  ];

  WonderMarker? _findWonder(WonderType type) {
    for (final WonderMarker w in wonders) {
      if (w.type == type) return w;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double gap = crossAxisGap ?? AppSpacing.xs.w;
    final double effectiveMinSize = minSize ?? 10.r;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Builds one timeline track; may contain multiple wonders, but they
        // should never overlap within a track.
        Widget buildSingleTimelineTrack(BuildContext context, List<WonderType> types) {
          final List<WonderMarker> markers = types.map(_findWonder).whereType<WonderMarker>().toList();
          return Stack(
            clipBehavior: Clip.none,
            children: markers.map((WonderMarker wonder) {
              // To keep the math simple, first figure out a multiplier we
              // can use to convert yrs to pixels.
              final int totalYrs = kTimelineEndYear - kTimelineStartYear;
              final double pxToYrRatio = totalYrs / (_isHz ? constraints.maxWidth : constraints.maxHeight);
              // Now we just need to calculate year spans, and then convert
              // them to pixels for the start/end position in the Stack.
              final int wonderYrs = wonder.endYr - wonder.startYr;
              final int yrsFromStart = wonder.startYr - kTimelineStartYear;
              double startPx = yrsFromStart / pxToYrRatio;
              double sizePx = wonderYrs / pxToYrRatio;
              if (sizePx < effectiveMinSize) {
                final double yearDelta = (effectiveMinSize - sizePx) / 2;
                sizePx = effectiveMinSize;
                startPx -= yearDelta;
              }
              const bool isSelected = false;
              final Widget child =
                  timelineBuilder?.call(context, wonder, isSelected) ?? _DefaultTrackEntry(wonder: wonder);
              return _isHz
                  ? Positioned(left: startPx, width: sizePx, top: 0, bottom: 0, child: child)
                  : Positioned(top: startPx, height: sizePx, left: 0, right: 0, child: child);
            }).toList(),
          );
        }

        final List<Widget> tracks =
            _tracks.map((List<WonderType> types) => Expanded(child: buildSingleTimelineTrack(context, types))).toList();

        // Depending on axis, tracks are wrapped in a hz row (vertical time
        // axis) or a vt column (horizontal time axis) — mirrors Wonderous's
        // wrapFlex(). Wonderous stacks tracks bottom-to-top
        // (`verticalDirection: up`) when the time axis is horizontal; that
        // visual ordering is preserved here via `reversed`.
        if (_isHz) {
          final List<Widget> bottomToTop = tracks.reversed.toList();
          return Column(
            children: <Widget>[
              for (int i = 0; i < bottomToTop.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: gap),
                bottomToTop[i],
              ],
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              for (int i = 0; i < tracks.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: gap),
                tracks[i],
              ],
            ],
          );
        }
      },
    );
  }
}

/// Default per-track entry: a rounded pill outlined in `wonder.type.fgColor`
/// with a transparent fill. Wonderous fills the pill solid when the wonder
/// is selected; this port has dropped "selected wonder" entirely (see class
/// doc comment), so the fill is always transparent — callers that need the
/// filled/selected look must supply their own `timelineBuilder`.
class _DefaultTrackEntry extends StatelessWidget {
  const _DefaultTrackEntry({required this.wonder});

  final WonderMarker wonder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: wonder.type.fgColor),
      ),
    );
  }
}
