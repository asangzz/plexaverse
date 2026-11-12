import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/roadmap_level.dart';
import '../../domain/roadmap_planets.dart';
import '../roadmap_status_ui.dart';
import 'planet_node.dart';

/// The journey's solar system: a vertical scroll from the sun to the Milky
/// Way.
///
/// ## A calendar, not a control
///
/// Since 12 Nov 2026 a day opens nothing. The day's work moved to the
/// contest's daily path, so the rows are markers — behind, today, ahead
/// ([roadmapDayStatus]) — and scrolling only moves the orbit of the planet the
/// centred day belongs to. The timeline opens on today.
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
/// The overlay ignores pointers; nothing under it takes a tap any more either,
/// but the scroll has to reach the column beneath.
///
/// ## Rows are placed by INDEX, never by day number
///
/// The rows are a window (today − 13 … today + 7, see [buildRoadmap]), so
/// the first row is day 1 only for the first fortnight of a journey. Every
/// offset here is counted from the window's first day. This used to compute
/// `(day − 1) × row`, which held while the arc was 66 days and unwindowed;
/// from day 15 it opened the timeline past today (from day 21, on the
/// window's last row), and drew each planet as many rows below its days as
/// the window had skipped — off the screen entirely.
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
    required this.today,
    required this.topInset,
    super.key,
  });

  /// The windowed days, in order and without gaps. Never empty.
  final List<RoadmapLevel> levels;

  /// Today's day of the journey. Every status is read against it, and the
  /// timeline opens on it.
  final int today;

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

  /// The day nearest the viewport's centre once a scroll settles. Drives the
  /// orbit of its planet and nothing else — the web's `activeLevelId`, which
  /// "follows the scroll" and opens nothing.
  late int _centredDay = widget.today;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RoadmapTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The day turned over while the screen was open (or a refresh moved it):
    // follow today, as opening the screen would.
    if (oldWidget.today != widget.today) {
      _centredDay = widget.today;
      _scrollToIndex(_indexOfDay(widget.today), animate: true);
    }
  }

  /// Row index of [day] in the window, clamped to it — a today past the end
  /// of the journey parks on the last row rather than off the end.
  int _indexOfDay(int day) =>
      (day - widget.levels.first.id).clamp(0, widget.levels.length - 1);

  /// Content-space offset that puts row [index] in the viewport's middle.
  double _offsetForIndex(int index) =>
      (_spacer + index * _rowHeight + _rowHeight / 2 - _viewport / 2).clamp(
        0.0,
        _maxScroll,
      );

  double get _maxScroll =>
      _scroll.hasClients ? _scroll.position.maxScrollExtent : double.infinity;

  double get _offset => _scroll.hasClients ? _scroll.offset : 0;

  /// Which row is nearest the viewport's centre right now. The web picks the
  /// row whose centre is closest; so does this.
  int _centredIndex() {
    if (_rowHeight <= 0) return _indexOfDay(_centredDay);
    final double raw =
        (_offset + _viewport / 2 - _spacer - _rowHeight / 2) / _rowHeight;
    return raw.round().clamp(0, widget.levels.length - 1);
  }

  void _scrollToIndex(int index, {required bool animate}) {
    if (!_scroll.hasClients || _rowHeight <= 0) return;
    final double target = _offsetForIndex(index);
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
  /// `scrollend` to name the centred day. Flutter has no scroll snapping at
  /// half-viewport granularity, so the settle handler does both jobs: it names
  /// the centred day and eases it exactly onto centre.
  bool _onScrollEnd(ScrollEndNotification notification) {
    final int index = _centredIndex();
    final int day = widget.levels[index].id;
    if (day != _centredDay) setState(() => _centredDay = day);
    _scrollToIndex(index, animate: true);
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
              if (mounted) {
                _scrollToIndex(_indexOfDay(widget.today), animate: false);
              }
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
                            child: _ProgressionLine(
                              levels: widget.levels,
                              today: widget.today,
                            ),
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
                          child: _ThematicHeader(today: widget.today),
                        ),
                        for (int i = 0; i < widget.levels.length; i++)
                          Positioned(
                            top: _spacer + i * _rowHeight,
                            left: 0,
                            right: 0,
                            height: _rowHeight,
                            child: _DayRow(
                              level: widget.levels[i],
                              status: roadmapDayStatus(
                                widget.levels[i].id,
                                widget.today,
                              ),
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
                          today: widget.today,
                          centredDay: _centredDay,
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
    required this.today,
    required this.centredDay,
    required this.rowHeight,
    required this.spacer,
    required this.viewport,
    required this.offset,
  });

  final List<RoadmapLevel> levels;
  final int today;
  final int centredDay;
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

      // Counted from the window's first row, not from day 1 — see the class
      // doc on RoadmapTimeline.
      final double segmentTop =
          spacer + (segment.first.id - levels.first.id) * rowHeight;
      final double segmentBottom = segmentTop + segment.length * rowHeight;

      // `position: sticky; top: 0`, written out.
      final double lower = segmentBottom - viewport;
      final double stickyTop = offset < lower
          ? (offset > segmentTop ? offset : segmentTop)
          : (lower > segmentTop ? lower : segmentTop);

      final double centreY = stickyTop + viewport / 2 - offset;
      if (centreY < -viewport || centreY > viewport * 2) continue;

      // The day whose orbit fraction the ring shows: the centred one when it
      // is inside this segment, otherwise the segment's first day — exactly
      // the web's `activeInSegment ?? segmentLevels[0]`.
      final RoadmapLevel display = segment.firstWhere(
        (RoadmapLevel l) => l.id == centredDay,
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

  /// One status for the whole leg, reduced as the web reduces it: every day
  /// ahead → locked; every day behind → completed; otherwise the leg holds
  /// today and is active. The window is contiguous and always contains today,
  /// so a drawn leg is one of the three.
  LevelStatus _segmentStatus(List<RoadmapLevel> segment) {
    LevelStatus of(RoadmapLevel l) => roadmapDayStatus(l.id, today);
    if (segment.every((RoadmapLevel l) => of(l) == LevelStatus.locked)) {
      return LevelStatus.locked;
    }
    if (segment.every((RoadmapLevel l) => of(l) == LevelStatus.completed)) {
      return LevelStatus.completed;
    }
    return LevelStatus.active;
  }
}

/// One day: a right-aligned status word and day line, stopping clear of the
/// planet.
///
/// A marker, not a control. It took the tap that chose which day's missions
/// the sheet showed; the missions are the contest's now, so there is nothing
/// for a tap to open.
class _DayRow extends StatelessWidget {
  const _DayRow({required this.level, required this.status});

  final RoadmapLevel level;
  final LevelStatus status;

  @override
  Widget build(BuildContext context) {
    final Color signal = roadmapStatusColor(status);
    final String? label = roadmapStatusLabel(status);
    final bool emphasised = status == LevelStatus.active;
    final ctx = planetContextForDay(level.id);

    return Semantics(
      selected: emphasised,
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
                          // TODAY in its status colour; TRAVELLED quiet,
                          // so the green day line under it carries the
                          // state — the web's grey `#a8abb3` label.
                          color: emphasised ? signal : ZaveColors.ink62,
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
  const _ProgressionLine({required this.levels, required this.today});

  final List<RoadmapLevel> levels;
  final int today;

  @override
  Widget build(BuildContext context) {
    LevelStatus statusAt(int i) => roadmapDayStatus(levels[i].id, today);

    int lastCompleted = -1;
    for (int i = levels.length - 1; i >= 0; i--) {
      if (statusAt(i) == LevelStatus.completed) {
        lastCompleted = i;
        break;
      }
    }
    int activeIdx = -1;
    for (int i = 0; i < levels.length; i++) {
      if (statusAt(i) == LevelStatus.active) {
        activeIdx = i;
        break;
      }
    }

    final int span = levels.length > 1 ? levels.length - 1 : 1;
    final double green = lastCompleted == -1
        ? 0
        : (lastCompleted / span).clamp(0.0, 1.0);
    // `(activeIdx + 1) / span` passes 1.0 when today is the last row, and a
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

/// What the journey is, said once, at the top: the phase today falls in and
/// the follower mark it is working toward.
///
/// The web's thematic header, word for word. This used to read "Your 66-day
/// plan — Show up a little every day — comment, connect, and post", which was
/// wrong twice over: the journey is a thousand days, and the roadmap no longer
/// asks for a daily comment or connection.
class _ThematicHeader extends StatelessWidget {
  const _ThematicHeader({required this.today});

  final int today;

  @override
  Widget build(BuildContext context) {
    final RoadmapPhase phase = phaseForDay(today);

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
                  phase.name,
                  style: ZaveType.spaceGrotesk(
                    size: 22,
                    weight: FontWeight.w800,
                    tracking: 0.02 * 22,
                  ),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(
                  // `ROADMAP_TOTAL_DAYS` ungrouped and the target grouped,
                  // exactly as the web prints them.
                  'Day $today of $roadmapTotalDays — next checkpoint '
                  '${NumberFormat.decimalPattern('en_US').format(phase.followerTarget)}'
                  ' followers.',
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
