import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../domain/timeline_event.dart';

/// A vertically aligned stack of dots that represent global events along
/// the timeline's year axis. The event closest to [selectedYear] is shown
/// selected (larger dot + glow).
///
/// Ported verbatim from Wonderous's `_EventMarkers`/`_EventMarker`
/// (`lib/ui/screens/timeline/widgets/_event_markers.dart`): the 10px
/// px-based proximity threshold (not year-based, so selection UX stays
/// consistent across zoom levels), the offset-to-[Alignment] math, and the
/// 2px -> 6px `AnimatedContainer` dot growth on selection are all kept
/// exactly as Wonderous defined them. Only presentational constants
/// (paddings, widths, the touch-target height) are scaled with ScreenUtil.
///
/// Wonderous read `wondersLogic.timelineStartYear/timelineEndYear` and
/// `timelineLogic.events` off global singletons (`get_it`); this port takes
/// [startYear]/[endYear]/[events] as explicit params instead, sourced from
/// the Riverpod `GlobalTimelineController` by the caller.
///
/// Marker/halo color: Wonderous used `$styles.colors.accent1` (its
/// always-visible accent token) — [SkinColors.brandCyan] is Plexaverse's
/// equivalent token.
class TimelineEventMarkers extends StatefulWidget {
  const TimelineEventMarkers({
    required this.selectedYear,
    required this.events,
    required this.startYear,
    required this.endYear,
    required this.onEventChanged,
    required this.onMarkerPressed,
    super.key,
  });

  /// The year currently centered in the scrolling viewport.
  final int selectedYear;

  /// The merged+sorted event list (global events + wonder construction
  /// events), per `GlobalTimelineOverview.events`.
  final List<TimelineEvent> events;

  final int startYear;
  final int endYear;

  /// Fired whenever the closest-selected event changes (including to
  /// `null` when nothing is within the proximity threshold).
  final void Function(TimelineEvent? event) onEventChanged;

  /// Fired when a marker dot is tapped.
  final void Function(TimelineEvent event) onMarkerPressed;

  @override
  State<TimelineEventMarkers> createState() => _TimelineEventMarkersState();
}

class _TimelineEventMarkersState extends State<TimelineEventMarkers> {
  bool get showReferenceMarkers => kDebugMode;

  late final int _totalYrs = widget.endYear - widget.startYear;

  TimelineEvent? _selectedEvent;

  /// Normalizes a given year to a value from 0 - 1, based on start and end
  /// yr. Ported verbatim from Wonderous's `_calculateOffsetY`.
  double _calculateOffsetY(int yr) => (yr - widget.startYear) / _totalYrs;

  /// Loops through the events, and does a px-based check to see whether one
  /// of them should be selected (as opposed to year-based proximity). This
  /// ensures consistent UX at different zoom levels. Ported verbatim from
  /// Wonderous's `_updateSelectedEvent` (10px `minDistance` threshold).
  void _updateSelectedEvent(double maxPxHeight) {
    const double minDistance = 10;
    TimelineEvent? closestEvent;
    double closestDistance = double.infinity;
    // Convert current yr to a px position
    final double currentYearPx =
        _calculateOffsetY(widget.selectedYear) * maxPxHeight;
    for (final e in widget.events) {
      // Convert both the event.yr to px, and compare with currentYearPx
      final double eventPx = _calculateOffsetY(e.year) * maxPxHeight;
      final double d = (eventPx - currentYearPx).abs();
      // Keep the closest event that is within minDistance
      if (d <= minDistance && d < closestDistance) {
        closestEvent = e;
        closestDistance = d;
      }
    }
    // Dispatch if event has actually changed since last time
    if (closestEvent != _selectedEvent) {
      scheduleMicrotask(() => widget.onEventChanged(closestEvent));
    }
    _selectedEvent = closestEvent;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (_, constraints) {
          // Figure out which event is "selected"
          _updateSelectedEvent(constraints.maxHeight);

          // Create a marker for each event
          final List<Widget> markers = widget.events.map((event) {
            final double offsetY = _calculateOffsetY(event.year);
            return _EventMarker(
              offsetY,
              event: event,
              isSelected: event == _selectedEvent,
              onPressed: widget.onMarkerPressed,
            );
          }).toList();

          // Stack of fractionally positioned markers
          return FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 75.w),
              child: SizedBox(
                width: 20.w,
                child: Stack(
                  children: [
                    ...markers,
                    if (showReferenceMarkers) ..._buildReferenceMarkers(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildReferenceMarkers() {
    final Widget marker = Container(
      color: Colors.red.withValues(alpha: .4),
      width: 10.r,
      height: 10.r,
    );
    return [
      Align(
        alignment: Alignment.topCenter,
        child: FractionalTranslation(
          translation: const Offset(0, -.5),
          child: marker,
        ),
      ),
      Align(alignment: Alignment.center, child: marker),
      Align(
        alignment: Alignment.bottomCenter,
        child: FractionalTranslation(
          translation: const Offset(0, .5),
          child: marker,
        ),
      ),
    ];
  }
}

/// A dot that represents a single global event. Animated to a selected
/// state which is larger in size. Ported verbatim from Wonderous's
/// `_EventMarker`.
class _EventMarker extends StatelessWidget {
  const _EventMarker(
    this.offset, {
    required this.isSelected,
    required this.event,
    required this.onPressed,
  });

  final double offset;
  final TimelineEvent event;
  final bool isSelected;
  final void Function(TimelineEvent event) onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -1 + offset * 2),
      // Use an OverflowBox wrapped in a zero-height SizedBox so alignment
      // -based positioning stays accurate even at the edges of the parent.
      child: SizedBox(
        height: 0,
        child: OverflowBox(
          maxHeight: 30.r,
          child: Semantics(
            button: true,
            label: '${event.year}: ${event.description}',
            child: GestureDetector(
              onTap: () => onPressed(event),
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                height: 30.r,
                child: AnimatedContainer(
                  width: isSelected ? 6.r : 2.r,
                  height: isSelected ? 6.r : 2.r,
                  curve: Curves.easeOutBack,
                  duration: const Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99.r),
                    color: SkinColors.brandCyan,
                    boxShadow: [
                      BoxShadow(
                        color: SkinColors.brandCyan.withValues(
                          alpha: isSelected ? .5 : 0,
                        ),
                        spreadRadius: 3.r,
                        blurRadius: 3.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
