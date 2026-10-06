import 'package:flutter/material.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/roadmap_level.dart';
import '../../domain/roadmap_planets.dart';
import '../roadmap_status_ui.dart';
import 'planet_node.dart';

/// The 66-day solar system: a vertical scroll from the sun to the Milky Way.
///
/// ## How the sticky planet is done
///
/// The web puts each planet in a `position: sticky; top: 0` container inside a
/// segment whose height is `days × 50vh`, so the planet holds the middle of the
/// viewport for as long as its days are passing and then hands over to the
/// next. Flutter has no `position: sticky` inside a scrolling child and this
/// app has no `sliver_tools`, so the planets are drawn in a **separate overlay
/// in viewport space**, positioned from the live scroll offset with exactly the
/// CSS clamp:
///
/// ```
/// stickyTop = max(segmentTop, min(scrollOffset, segmentBottom - viewportH))
/// ```
///
/// The overlay ignores pointers, so taps still land on the day rows underneath
/// — which is the web's z-order too (rows are `z-index: 11`, the globe is 10).
///
/// ## Where the heights come from
///
/// Every figure is the web's **mobile** branch, expressed against the scroll
/// viewport rather than against `vh`, so it cannot drift if the page chrome
/// changes height:
///
/// | web (`@media max-width: 767px`) | here |
/// |---|---|
/// | scroll container `calc(100vh - 42vh)` = 58vh | the viewport itself |
/// | row `25vh` | `viewport × 25/58` |
/// | spacer `16.5vh` | `(viewport − row) / 2` |
///
/// The spacer is written as the centring expression rather than as 16.5/58,
/// because centring the first row in the viewport is what it is FOR — the
/// web's number is the answer, not the reason.
class RoadmapTimeline extends StatefulWidget {
  const RoadmapTimeline({
    required this.levels,
    required this.selectedDay,
    required this.onSelectDay,
    required this.topInset,
    super.key,
  });

  final List<RoadmapLevel> levels;

  /// The day the mission panel is showing. The timeline scrolls it to the
  /// centre when it changes from outside.
  final int selectedDay;

  final ValueChanged<int> onSelectDay;

  /// Height of the sticky header above this widget. The timeline is a
  /// fixed-height instrument rather than a document, so it starts BELOW the
  /// header instead of sliding under its blur — a planet parked permanently
  /// behind the header would be the one thing on the screen you cannot see.
  final double topInset;

  @override
  State<RoadmapTimeline> createState() => _RoadmapTimelineState();
}

class _RoadmapTimelineState extends State<RoadmapTimeline> {
  final ScrollController _scroll = ScrollController();

  double _rowHeight = 0;
  double _spacer = 0;
  double _viewport = 0;
  bool _placed = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RoadmapTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay &&
        _centredDay() != widget.selectedDay) {
      _scrollToDay(widget.selectedDay, animate: true);
    }
  }

  /// Content-space offset that puts day [day]'s row in the viewport's middle.
  double _offsetForDay(int day) =>
      (_spacer + (day - 1) * _rowHeight + _rowHeight / 2 - _viewport / 2).clamp(
        0.0,
        _maxScroll,
      );

  double get _maxScroll =>
      _scroll.hasClients ? _scroll.position.maxScrollExtent : double.infinity;

  double get _offset => _scroll.hasClients ? _scroll.offset : 0;

  /// Which day is nearest the viewport's centre right now. The web picks the
  /// row whose centre is closest; so does this.
  int _centredDay() {
    if (_rowHeight <= 0) return widget.selectedDay;
    final double raw =
        (_offset + _viewport / 2 - _spacer - _rowHeight / 2) / _rowHeight;
    return (raw.round() + 1).clamp(1, widget.levels.length);
  }

  void _scrollToDay(int day, {required bool animate}) {
    if (!_scroll.hasClients || _rowHeight <= 0) return;
    final double target = _offsetForDay(day);
    if ((target - _offset).abs() < 1) return;
    if (animate) {
      _scroll.animateTo(
        target,
        duration: ZaveMotion.page,
        curve: ZaveMotion.curve,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  /// Snap-to-nearest once the fling has settled.
  ///
  /// The web relies on CSS `scroll-snap-type: y mandatory` and listens for
  /// `scrollend` to pick the selected day. Flutter has no scroll snapping at
  /// half-viewport granularity, so the settle handler does both jobs: it names
  /// the centred day and eases it exactly onto centre.
  bool _onScrollEnd(ScrollEndNotification notification) {
    final int day = _centredDay();
    if (day != widget.selectedDay) widget.onSelectDay(day);
    _scrollToDay(day, animate: true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topInset),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _viewport = constraints.maxHeight;
          // The web's `25vh` row against its `58vh` scroll container.
          _rowHeight = _viewport * 25 / 58;
          _spacer = (_viewport - _rowHeight) / 2;

          final double total = _spacer * 2 + widget.levels.length * _rowHeight;

          if (!_placed && _viewport > 0) {
            _placed = true;
            // Land the user on their own day rather than at the sun. The web
            // smooth-scrolls there 600 ms after loading resolves; on a phone
            // that reads as the screen moving under you, so this places the
            // viewport before the first frame is seen.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _scrollToDay(widget.selectedDay, animate: false);
            });
          }

          return Stack(
            children: <Widget>[
              NotificationListener<ScrollEndNotification>(
                onNotification: _onScrollEnd,
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: SizedBox(
                    height: total,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        // Positioned has to be the Stack's DIRECT child, so
                        // the three decorations are placed here and each one
                        // renders only its own contents.
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _ProgressionLine(levels: widget.levels),
                          ),
                        ),
                        Positioned(
                          top: -520.r,
                          left: 0,
                          right: 0,
                          child: const Center(child: _Sun()),
                        ),
                        Positioned(
                          // The web's `top: 100`; nothing in the Zave ramp is
                          // 100, so this is the section space plus one xxl.
                          top: ZaveSpace.section + ZaveSpace.xxl,
                          left: 0,
                          right: 0,
                          child: const _ThematicHeader(),
                        ),
                        for (int i = 0; i < widget.levels.length; i++)
                          Positioned(
                            top: _spacer + i * _rowHeight,
                            left: 0,
                            right: 0,
                            height: _rowHeight,
                            child: _DayRow(
                              level: widget.levels[i],
                              onTap: () =>
                                  widget.onSelectDay(widget.levels[i].id),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _scroll,
                    builder: (BuildContext context, Widget? _) =>
                        _PlanetOverlay(
                          levels: widget.levels,
                          selectedDay: widget.selectedDay,
                          rowHeight: _rowHeight,
                          spacer: _spacer,
                          viewport: _viewport,
                          offset: _offset,
                        ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The sticky planets, drawn in viewport space.
class _PlanetOverlay extends StatelessWidget {
  const _PlanetOverlay({
    required this.levels,
    required this.selectedDay,
    required this.rowHeight,
    required this.spacer,
    required this.viewport,
    required this.offset,
  });

  final List<RoadmapLevel> levels;
  final int selectedDay;
  final double rowHeight;
  final double spacer;
  final double viewport;
  final double offset;

  @override
  Widget build(BuildContext context) {
    if (rowHeight <= 0) return const SizedBox.shrink();

    final List<Widget> planets = <Widget>[];
    int firstDay = 1;

    for (final RoadmapPlanet planet in roadmapPlanets) {
      final int lastDay = firstDay + planet.days - 1;
      final List<RoadmapLevel> segment = levels
          .where((RoadmapLevel l) => l.id >= firstDay && l.id <= lastDay)
          .toList();
      firstDay = lastDay + 1;
      if (segment.isEmpty) continue;

      final double segmentTop = spacer + (segment.first.id - 1) * rowHeight;
      final double segmentBottom = segmentTop + segment.length * rowHeight;

      // `position: sticky; top: 0`, written out.
      final double lower = segmentBottom - viewport;
      final double stickyTop = offset < lower
          ? (offset > segmentTop ? offset : segmentTop)
          : (lower > segmentTop ? lower : segmentTop);

      final double centreY = stickyTop + viewport / 2 - offset;
      if (centreY < -viewport || centreY > viewport * 2) continue;

      // The day whose orbit fraction the ring shows: the selected one when it
      // is inside this segment, otherwise the segment's first day — exactly
      // the web's `activeInSegment ?? segmentLevels[0]`.
      final RoadmapLevel display = segment.firstWhere(
        (RoadmapLevel l) => l.id == selectedDay,
        orElse: () => segment.first,
      );

      planets.add(
        Positioned(
          top: centreY - _planetRowHeight(planet.key) / 2,
          left: 0,
          right: 0,
          child: Center(
            child: PlanetNode(
              planetKey: planet.key,
              name: planet.name,
              fraction: planetContextForDay(display.id).fraction,
              status: _segmentStatus(segment),
            ),
          ),
        ),
      );
    }

    return Stack(clipBehavior: Clip.none, children: planets);
  }

  // Must agree with PlanetNode's own box (`ring + 40`), which is why it reads
  // the same table. The old `?? 100` default silently shrank the box for the
  // three planets that had no entry, mis-centring their rows on top of drawing
  // the wrong sphere.
  double _planetRowHeight(String key) => (planetVisual(key).ring + 40).r;

  /// One status for the whole leg.
  ///
  /// The web reduces the segment the same way and in this order: every day
  /// locked → locked; every day done → completed; any day today → active;
  /// otherwise missed. Order matters — a leg with one missed day and one live
  /// day reads as ACTIVE, because the live day is the one the user can still
  /// act on.
  LevelStatus _segmentStatus(List<RoadmapLevel> segment) {
    if (segment.every((RoadmapLevel l) => l.status == LevelStatus.locked)) {
      return LevelStatus.locked;
    }
    if (segment.every((RoadmapLevel l) => l.status == LevelStatus.completed)) {
      return LevelStatus.completed;
    }
    if (segment.any((RoadmapLevel l) => l.status == LevelStatus.active)) {
      return LevelStatus.active;
    }
    return LevelStatus.missed;
  }
}

/// One day: a right-aligned status word and day line, stopping clear of the
/// planet. The whole row is the tap target for selecting that day.
class _DayRow extends StatelessWidget {
  const _DayRow({required this.level, required this.onTap});

  final RoadmapLevel level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final LevelStatus status = level.status;
    final Color signal = roadmapStatusColor(status);
    final String? label = roadmapStatusLabel(status);
    final bool emphasised =
        status == LevelStatus.active || status == LevelStatus.missed;
    final ctx = planetContextForDay(level.id);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        selected: status == LevelStatus.active,
        label: 'Day ${level.id}, ${level.subtitle}',
        child: Row(
          children: <Widget>[
            Expanded(
              child: AnimatedOpacity(
                duration: ZaveMotion.fast,
                curve: ZaveMotion.curve,
                opacity: roadmapRowOpacity(status),
                child: Padding(
                  // The web's mobile `pr-[60px]` — three Zave gutters, which
                  // is exactly 60 and keeps the text clear of the widest
                  // planet (Jupiter's 148px ring).
                  padding: EdgeInsets.only(right: ZaveSpace.gutter * 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (label != null) ...<Widget>[
                        Text(
                          label.toUpperCase(),
                          textAlign: TextAlign.right,
                          style: ZaveType.spaceGrotesk(
                            size: _statusLabelSize,
                            color: signal,
                            tracking: 0.10 * _statusLabelSize,
                          ),
                        ),
                        SizedBox(height: ZaveSpace.xs),
                      ],
                      Text(
                        'Day ${ctx.dayInPlanet} of ${ctx.totalDays} — '
                                '${level.subtitle}'
                            .toUpperCase(),
                        textAlign: TextAlign.right,
                        style: ZaveType.kicker.copyWith(
                          fontSize: emphasised
                              ? _dayLineLargeSize.sp
                              : _dayLineSize.sp,
                          fontWeight: emphasised
                              ? FontWeight.w600
                              : FontWeight.w400,
                          letterSpacing: 0.02 * _dayLineSize,
                          color: status == LevelStatus.locked
                              ? ZaveColors.ink35
                              : signal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // The right half is the planet's; the row leaves it empty.
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

/// The web's mobile roadmap type sizes (8px / 9px). They sit below every Zave
/// token — the smallest, `ZaveType.kicker`, is 13 — and they have to: the left
/// cell is half a 360px phone minus the planet, and anything larger collides
/// with Jupiter. Both are derived from a token's face rather than written as a
/// fresh `TextStyle`.
const double _statusLabelSize = 8;
const double _dayLineSize = 8;
const double _dayLineLargeSize = 9;

/// The vertical thread every planet hangs off.
///
/// Its gradient is the journey stated in one object: solid green up to the last
/// completed day, mint through the live one, then inert. The web computes the
/// two stops with a deliberate manual reverse scan rather than
/// `Array.findLastIndex`, which crashes on iOS 15.0–15.3 and took the whole
/// dashboard down with it; the scan is kept here for symmetry, not necessity.
class _ProgressionLine extends StatelessWidget {
  const _ProgressionLine({required this.levels});

  final List<RoadmapLevel> levels;

  @override
  Widget build(BuildContext context) {
    int lastCompleted = -1;
    for (int i = levels.length - 1; i >= 0; i--) {
      if (levels[i].status == LevelStatus.completed) {
        lastCompleted = i;
        break;
      }
    }
    int activeIdx = -1;
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].status == LevelStatus.active) {
        activeIdx = i;
        break;
      }
    }

    final int span = levels.length > 1 ? levels.length - 1 : 1;
    final double green = lastCompleted == -1
        ? 0
        : (lastCompleted / span).clamp(0.0, 1.0);
    // `(activeIdx + 1) / span` reaches 66/65 on the very last day, and a
    // gradient stop above 1.0 throws rather than clamping itself.
    final double mint = activeIdx == -1
        ? green
        : ((activeIdx + 1) / span).clamp(green, 1.0);

    return Opacity(
      opacity: 0.45,
      child: Container(
        width: 2,
        // The Center above passes LOOSE constraints, so a height-less box would
        // collapse to nothing; infinity resolves to the content's full height.
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: ZaveRadius.pillBr,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const <Color>[
              ZaveColors.green,
              ZaveColors.green,
              ZaveColors.mint,
              ZaveColors.mint,
              ZaveColors.ink35,
              ZaveColors.ink35,
            ],
            stops: <double>[0, green, green, mint, mint, 1],
          ),
        ),
      ),
    );
  }
}

/// The sun: a 600px disc parked 520px above the first day, so only its rim
/// shows over the top of the journey.
///
/// Like the planets, the sun is a DEPICTION and carries its own literal values;
/// it is not UI chrome and there is no Zave token for "hydrogen".
class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700.r,
      width: 700.r,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Corona.
          Container(
            height: 700.r,
            width: 700.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  Color(0x26FFA000), // rgba(255,160,0,0.15)
                  Color(0x00FFA000),
                ],
                stops: <double>[0, 0.7],
              ),
            ),
          ),
          Container(
            height: 600.r,
            width: 600.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFFFF6B00), Color(0xFFFFB800)],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0x66FF6B00), blurRadius: 100.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What the journey is, said once, at the top.
class _ThematicHeader extends StatelessWidget {
  const _ThematicHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // `left: calc(50% + 20px)` — half the width, then one gutter.
        const Spacer(),
        SizedBox(width: ZaveSpace.gutter),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: ZaveSpace.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Your 66-day plan',
                  style: ZaveType.spaceGrotesk(
                    size: 22,
                    weight: FontWeight.w800,
                    tracking: 0.02 * 22,
                  ),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(
                  'Post a little every day for 66 days to grow on LinkedIn.',
                  // The web sets this in Manrope; Zave's rule is that Urbanist
                  // reads and Manrope names, and this is a sentence you read —
                  // so it takes the reading face.
                  style: ZaveType.caption,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
