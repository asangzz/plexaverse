import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/skin_colors.dart';
import '../../../../core/ui/motion/app_haptics.dart';
import '../../domain/global_timeline_repository.dart';
import 'dashed_divider_with_year.dart';
import 'event_markers.dart';
import 'event_popup_card.dart';
import 'timeline_marker_card.dart';
import 'wonders_timeline_builder.dart';
import 'year_markers.dart';

/// The main zoomable/scrollable Global Timeline viewport: a vertical year
/// axis the user can pinch-zoom (or ctrl+scroll on desktop/web) and drag to
/// scroll through, with the left-side [TimelineYearMarkers] ruler, the
/// 3-track [WondersTimelineTrackBuilder] wonder pills, the [TimelineEventMarkers]
/// dots, a debounced [TimelineEventPopup], and a big current-year readout
/// ([DashedDividerWithYear]) all composited on top of one another.
///
/// Ports Wonderous's `_ScrollingViewport` / `_ScalingViewportState`
/// (`lib/ui/screens/timeline/widgets/_scrolling_viewport.dart`) — the widget
/// composition below mirrors that file's `build`/`_buildScrollingArea`
/// structure line-for-line (same `Stack` ordering, same
/// `AnimatedBuilder`-per-scroll-tick rebuild pattern), with every Wonderous
/// utility swapped for its Plexaverse/plain-Flutter equivalent per the port
/// manifest (`CenteredBox` -> `Center`+`ConstrainedBox`+`SizedBox`,
/// `ListOverscollGradient` -> the private [_TimelineOverscrollGradient]
/// below, `BottomCenter`/`TopCenter` -> `Align`,
/// `IgnorePointerKeepSemantics` -> `IgnorePointer`,
/// `AppHaptics.selectionClick()` -> [AppHaptics.selection]).
///
/// Unlike Wonderous (which read `wondersLogic`/`timelineLogic` off `get_it`
/// singletons), this widget takes its [events]/[wonders] data as explicit
/// constructor params, sourced by the caller from
/// `GlobalTimelineController`'s `GlobalTimelineOverview`.
///
/// This port also drops the `selectedWonder` param entirely: Plexaverse has
/// no wonder detail page yet to deep-link from, so there is no "jump/animate
/// the initial scroll position to a selected wonder's start year" behaviour
/// to preserve. See [_GlobalScrollingViewportController.init] and the future
/// Plexaverse-data integration guide for wiring a real selection source back
/// in later.
class GlobalScrollingViewport extends StatefulWidget {
  const GlobalScrollingViewport({
    required this.scroller,
    required this.minSize,
    required this.maxSize,
    required this.events,
    required this.wonders,
    this.onYearChanged,
    super.key,
  });

  /// Drives (and is driven by) the viewport's scroll position. Owned by the
  /// caller so siblings (e.g. a future bottom scrubber) can share it.
  final ScrollController scroller;

  /// Content height at zoom `0` (fully zoomed out), minus the viewport's
  /// vertical padding. Ported verbatim into
  /// [_GlobalScrollingViewportController.calculateContentHeight].
  final double minSize;

  /// Content height at zoom `1` (fully zoomed in).
  final double maxSize;

  /// The merged+sorted event list (global events + synthetic wonder
  /// construction-start events), per `GlobalTimelineOverview.events`.
  final List<TimelineEvent> events;

  /// The raw wonder list, per `GlobalTimelineOverview.wonders`.
  final List<WonderMarker> wonders;

  /// Fired whenever the year centered in the viewport changes.
  final void Function(int year)? onYearChanged;

  @override
  State<GlobalScrollingViewport> createState() => _GlobalScrollingViewportState();
}

class _GlobalScrollingViewportState extends State<GlobalScrollingViewport> {
  late final _GlobalScrollingViewportController controller = _GlobalScrollingViewportController(this);

  /// Ported verbatim from Wonderous's `_minTimelineSize` (the minimum pixel
  /// thickness of a wonder's track pill along the main axis) — scaled with
  /// ScreenUtil since it's a presentational sizing constant, not timeline
  /// math.
  static final double _minTimelineSize = 100.h;

  final ValueNotifier<TimelineEvent?> _currentEventMarker = ValueNotifier<TimelineEvent?>(null);
  Size? _prevSize;

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    _currentEventMarker.dispose();
    super.dispose();
  }

  void _handleEventMarkerChanged(TimelineEvent? event) {
    _currentEventMarker.value = event;
    AppHaptics.selection();
  }

  void _handleMarkerPressed(TimelineEvent event) {
    final double pos = controller.calculateScrollPosFromYear(event.year);
    controller.scroller.animateTo(
      pos,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
    );
  }

  /// Lets [_GlobalScrollingViewportController] request a rebuild without
  /// reaching into [State.setState] directly (which is `@protected` and
  /// only callable from within a `State` subclass's own instance members).
  void rebuild(VoidCallback fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (_prevSize != null && _prevSize != size) {
      scheduleMicrotask(controller.handleResize);
    }
    _prevSize = size;

    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        // Ctrl + mouse-wheel zoom, ported verbatim from Wonderous (desktop
        // / web only — `HardwareKeyboard` reports no modifiers on
        // touch-only platforms, so this is a no-op there).
        if (event is PointerScaleEvent && HardwareKeyboard.instance.isControlPressed) {
          controller.handleScaleUpdateMouse((event.scale - 1) * 0.25);
        }
      },
      child: GestureDetector(
        // Pinch to zoom.
        onScaleStart: controller.handleScaleStart,
        onScaleUpdate: controller.handleScaleUpdate,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Main content area. Fades in on first build, exactly like
            // Wonderous's `.maybeAnimate().fadeIn()`.
            _buildScrollingArea(context).animate().fadeIn(),

            // Dashed line with a year that changes as we scroll.
            IgnorePointer(
              child: AnimatedBuilder(
                animation: controller.scroller,
                builder: (_, _) => DashedDividerWithYear(controller.calculateYearFromScrollPos()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollingArea(BuildContext context) {
    // Builds a wonder's track entry, passing it the currently selected yr
    // based on scroll position. Rebuilds whenever the timeline is scrolled.
    Widget buildTimelineSection(WonderMarker wonder) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(99.r),
        child: AnimatedBuilder(
          animation: controller.scroller,
          builder: (_, _) => TimelineMarkerEntry(
            wonder: wonder,
            selectedYear: controller.calculateYearFromScrollPos(),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Cache constraints, so they can be used to maintain the selected
        // year while zooming.
        controller.constraints = constraints;
        final double vtPadding = constraints.maxHeight / 2;
        final double height = controller.calculateContentHeight();
        // Wonderous's `$styles.sizes.maxContentWidth2` (600), scaled.
        final double width = math.min(600.w, constraints.maxWidth);
        return Stack(
          children: [
            SingleChildScrollView(
              controller: controller.scroller,
              padding: EdgeInsets.symmetric(vertical: vtPadding),
              // A Stack sized to an explicit height/width, centered within
              // whatever width the scroll view is given. Ports Wonderous's
              // `CenteredBox(height:, width:, child:)` per the port
              // manifest's `Center`+`ConstrainedBox`+`SizedBox` recipe (the
              // inner `SizedBox` also pins `width` — matching
              // `CenteredBox`'s own forced-exact-size behaviour, since a
              // `maxWidth`-only constraint would let the `Stack` collapse to
              // zero width under the scroll view's loose constraints).
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Stack(
                      children: [
                        /// Year Markers
                        TimelineYearMarkers(startYear: controller.startYr, endYear: controller.endYr),

                        /// individual timeline sections
                        Positioned.fill(
                          left: 100.w,
                          right: AppSpacing.sm.w,
                          child: FocusTraversalGroup(
                            child: WondersTimelineTrackBuilder(
                              wonders: widget.wonders,
                              axis: Axis.vertical,
                              crossAxisGap: math.max(6.w, (width - (120.w * 3)) / 2),
                              minSize: _minTimelineSize,
                              timelineBuilder: (_, wonder, _) => buildTimelineSection(wonder),
                            ),
                          ),
                        ),

                        /// Event Markers, rebuilds on scroll
                        AnimatedBuilder(
                          animation: controller.scroller,
                          builder: (_, _) => TimelineEventMarkers(
                            selectedYear: controller.calculateYearFromScrollPos(),
                            events: widget.events,
                            startYear: controller.startYr,
                            endYear: controller.endYr,
                            onEventChanged: _handleEventMarkerChanged,
                            onMarkerPressed: _handleMarkerPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Top and bottom gradients for visual style
            const _TimelineOverscrollGradient(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: _TimelineOverscrollGradient(bottomUp: true),
            ),

            /// Event Popups, rebuilds when [_currentEventMarker] changes
            ValueListenableBuilder<TimelineEvent?>(
              valueListenable: _currentEventMarker,
              builder: (_, TimelineEvent? data, _) => TimelineEventPopup(currentEvent: data),
            ),
          ],
        );
      },
    );
  }
}

/// Drives the Global Timeline's zoom/scroll/scale-gesture math.
///
/// Ports Wonderous's `_ScrollingViewportController`
/// (`lib/ui/screens/timeline/widgets/_scrolling_viewport_controller.dart`)
/// verbatim for every numeric formula: [calculateContentHeight],
/// [calculateYearFromScrollPos], [calculateScrollPosFromYear], [jumpToYear],
/// and the pinch- / mouse-wheel-zoom handlers are all untouched timeline
/// math, not presentational choices.
///
/// The one intentional behavioural simplification vs. Wonderous is in
/// [init]: Wonderous's `init()` also read `widget.selectedWonder` and, if
/// set, jumped the scroll position 200px before that wonder's `startYr` and
/// then animated into place (deep-linking in from a wonder detail page).
/// Plexaverse has no wonder detail page to deep-link from yet, so that
/// branch is dropped entirely — `init()` here just sets the initial zoom to
/// `.5`. See the future Plexaverse-data integration guide for wiring a real
/// "selected wonder" source back in.
class _GlobalScrollingViewportController extends ChangeNotifier {
  _GlobalScrollingViewportController(this._state);

  final _GlobalScrollingViewportState _state;

  GlobalScrollingViewport get _widget => _state.widget;
  ScrollController get scroller => _widget.scroller;

  /// Ported verbatim from Wonderous's `WondersLogic.timelineStartYear` /
  /// `timelineEndYear`, which survive in this port as the top-level consts
  /// `kTimelineStartYear` / `kTimelineEndYear`.
  int get startYr => kTimelineStartYear;
  int get endYr => kTimelineEndYear;

  double _zoom = .5;
  double _zoomOnScaleStart = 0;
  late BoxConstraints constraints;

  late final ValueNotifier<int> _currentYr = ValueNotifier<int>(startYr)
    ..addListener(() => _widget.onYearChanged?.call(_currentYr.value));

  void init() {
    scheduleMicrotask(() {
      setZoom(.5);
      scroller.addListener(_updateCurrentYear);
    });
  }

  void _updateCurrentYear() => _currentYr.value = calculateYearFromScrollPos();

  /// Allows ancestors to set zoom directly.
  void setZoom(double d) {
    _state.rebuild(() {
      // Determine current yr, based on scroll position.
      final int currentYr = calculateYearFromScrollPos();

      // Change zoom, which will scale our content, and change our scroll
      // position.
      _zoom = d.clamp(0, 1.0);
      // Jump to whatever yr we were on before changing the zoom.
      jumpToYear(currentYr);
    });
  }

  /// Jump to the scroll position for a given yr. Does not animate unless
  /// [animate] is `true`.
  void jumpToYear(int yr, {bool animate = false}) {
    final double yrRatio = (yr - startYr) / (endYr - startYr);
    final double newMaxScroll = calculateContentHeight();
    final double newPos = newMaxScroll * yrRatio;
    if (animate) {
      scroller.animateTo(newPos, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
    } else {
      scroller.jumpTo(newPos);
    }
  }

  /// Calculates current content height, taking zoom into account.
  double calculateContentHeight() {
    final double vtPadding = constraints.maxHeight / 2;
    return lerpDouble(_widget.minSize - vtPadding, _widget.maxSize, _zoom) ?? _widget.maxSize;
  }

  /// Derive current yr based on the scroll position and the current content
  /// height.
  int calculateYearFromScrollPos() {
    if (!scroller.hasClients) return startYr;
    final int totalYrs = endYr - startYr;
    final double currentPx = scroller.position.pixels;
    final double scrollAmt = currentPx / calculateContentHeight();
    final int result = (startYr + scrollAmt * totalYrs).round();
    return result.clamp(startYr, endYr);
  }

  double calculateScrollPosFromYear(int yr) {
    final int totalYrs = endYr - startYr;
    final double yrFraction = totalYrs / (yr - startYr);
    return calculateContentHeight() / yrFraction;
  }

  /// Since the onScale gesture always starts from 1, we need to hold onto
  /// the zoom value that we had when the scale gesture started and
  /// multiply it with the gesture data, to get the real new scale.
  void handleScaleStart(ScaleStartDetails _) => _zoomOnScaleStart = _zoom;

  void handleScaleUpdate(ScaleUpdateDetails details) {
    setZoom(details.scale * _zoomOnScaleStart);
  }

  void handleScaleUpdateMouse(double scale) {
    setZoom(math.max(0, math.min(1, _zoom + scale)));
  }

  /// Maintain current yr when the app changes size.
  void handleResize() => jumpToYear(_currentYr.value);
}

/// Fades the top/bottom edges of the scrolling viewport to
/// [SkinColors.deepNavy] so content doesn't hard-clip as it scrolls under
/// the edge of the screen.
///
/// Replaces Wonderous's `ListOverscollGradient` (a Wonderous-only utility
/// widget, not a package) per the COMMON widget-replacement rules: a small
/// private gradient `Container`, ~40.h tall, fading from opaque
/// [SkinColors.deepNavy] at the screen edge to transparent.
class _TimelineOverscrollGradient extends StatelessWidget {
  const _TimelineOverscrollGradient({this.bottomUp = false});

  /// When `true`, the gradient fades from the bottom edge upward; otherwise
  /// it fades from the top edge downward.
  final bool bottomUp;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: bottomUp ? Alignment.bottomCenter : Alignment.topCenter,
            end: bottomUp ? Alignment.topCenter : Alignment.bottomCenter,
            colors: const [SkinColors.deepNavy, Color(0x0005061A)],
          ),
        ),
      ),
    );
  }
}
