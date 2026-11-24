import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../../application/contest_controllers.dart';
import '../../../application/contest_home_controllers.dart';
import '../../../application/skip_controllers.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import '../labelled_rule.dart';
import 'lesson_chest.dart';
import 'node_card.dart';
import 'path_node.dart';
import 'week_trophy.dart';

/// A level's row on the path; the current level's is taller, with the node
/// at its foot, to leave room for the START bubble above it.
const double kPathRowHeight = 96;
const double kPathCurrentRowHeight = 132;

/// Wide enough for the web's `sm` swing and for Plexa beside today's level.
/// The app is drawn for phones; a tablet gets the roomier path.
const double kPathWideWidth = 600;

/// The swing's amplitude in logical pixels: 52 on a phone, 100 from
/// [kPathWideWidth]. Shared with the loading skeleton, so the skeleton winds
/// exactly as the path does.
double pathAmplitude(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kPathWideWidth ? 100 : 52;

/// "Wed · Day 17" — a day as a card's kicker names it.
String pathDayName(PathDay day) => '${_weekday(day)} · Day ${day.dayNumber}';

/// "Wed, day 17" — a day as a level's spoken label starts.
String pathDaySpoken(PathDay day) => '${_weekday(day)}, day ${day.dayNumber}';

String _weekday(PathDay day) =>
    day.weekday >= 0 && day.weekday < 7 ? kWeekdayShort[day.weekday] : '';

/// The week's unit banner and the winding path of its days. A port of the
/// web's `PathView.tsx`.
///
/// ## Drawn from the wire, deciding nothing
///
/// Which day offers what, and where each level stands, is the server's. The
/// only things decided here are visual: where START sits (the first of
/// today's levels still to do), how far each node swings, and the two
/// decorations — a chest after the LAST part of today's lesson and a trophy
/// at the week's end.
///
/// ## A level opens by its KIND
///
/// The card's button goes where `contestLevelRoute` sends that kind — never
/// to the node's `href`, which is the web's address for it. A level the app
/// cannot open draws its card with the button disabled, and opens nothing.
///
/// ## One card at a time
///
/// Opening a level closes the last one ([ContestOpenNode]); the card drops in
/// under its node's row, so the path below moves down rather than being
/// covered. A press anywhere outside the card and the nodes closes it, the
/// way a popover behaves.
///
/// ## Opening on today, once
///
/// The current level is brought to the middle of the view the first time the
/// path is drawn — the way Duolingo opens on the current lesson — and again
/// only when the current level moves to a node not yet scrolled to. Instant
/// under reduced motion.
class PathView extends ConsumerStatefulWidget {
  const PathView({
    required this.path,
    required this.title,
    this.lesson,
    super.key,
  });

  final ContestPath path;

  /// The banner's title: the contest's own name.
  final String title;

  /// Today's lesson as the quiz read has it; the current lesson part's ring
  /// draws that PART's share of it.
  final LessonProgress? lesson;

  @override
  ConsumerState<PathView> createState() => _PathViewState();
}

class _PathViewState extends ConsumerState<PathView> {
  /// On the current level's row, for the scroll to today.
  final GlobalKey _current = GlobalKey(debugLabel: 'contest-current-level');

  /// The card and every node share one tap region, so a press on another
  /// node switches the card rather than first closing it.
  final Object _cardRegion = Object();

  /// The current level last brought into view.
  String? _scrolledTo;

  void _bringIntoView(String? current) {
    if (current == null || current == _scrolledTo) return;
    _scrolledTo = current;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? row = _current.currentContext;
      if (!mounted || row == null) return;
      final bool still = MediaQuery.disableAnimationsOf(context);
      unawaited(
        Scrollable.ensureVisible(
          row,
          alignment: 0.5,
          duration: still ? Duration.zero : const Duration(milliseconds: 450),
          curve: ZaveMotion.curve,
        ),
      );
    });
  }

  void _toggle(PathNode node) =>
      ref.read(contestOpenNodeProvider.notifier).toggle(node.id);

  void _close() => ref.read(contestOpenNodeProvider.notifier).close();

  /// Skip the open level. On success the card closes, and the path — re-read
  /// by the skip — moves START on; [_bringIntoView] follows it.
  Future<void> _skip(PathNode node) async {
    final SkipOutcome? outcome = await ref
        .read(contestSkipActionsProvider.notifier)
        .skip(node.id);
    if (outcome == null || !mounted) return;
    _close();
  }

  void _open(PathNode node) {
    final String? route = contestLevelRoute(node);
    if (route == null) return;
    _close();
    unawaited(context.push(route));
  }

  @override
  Widget build(BuildContext context) {
    final List<PathDay> days = widget.path.days;
    final String? current = currentNodeId(days);
    _bringIntoView(current);

    final String? openId = ref.watch(contestOpenNodeProvider);
    final SkipBusy skip = ref.watch(contestSkipActionsProvider);
    final bool cooling = ref.watch(skipCooldownProvider);
    final double amp = pathAmplitude(context);
    final bool wide = MediaQuery.sizeOf(context).width >= kPathWideWidth;
    final LessonProgress? lesson = widget.lesson;

    int step = 0;
    final List<Widget> rows = <Widget>[];
    for (final PathDay day in days) {
      rows.add(_DayDivider(day));
      final List<PathNode> parts = lessonPartsOf(day);
      final String? lastPart = parts.isEmpty ? null : parts.last.id;
      for (final (int i, PathNode node) in day.nodes.indexed) {
        final double k = windAt(step++);
        final bool isCurrent = node.id == current;
        final bool open = node.id == openId;
        rows.add(
          _NodeRow(
            key: isCurrent ? _current : null,
            node: node,
            dayName: pathDaySpoken(day),
            level: i + 1,
            offset: amp * k,
            current: isCurrent,
            progress: isCurrent && lesson != null
                ? partProgress(
                    node,
                    answered: lesson.answered,
                    total: lesson.total,
                    answeredIndexes: lesson.answeredIndexes,
                  )
                : 0,
            expanded: open,
            plexa: isCurrent && wide,
            region: _cardRegion,
            onPressed: () => _toggle(node),
          ),
        );
        if (open) {
          rows.add(
            TapRegion(
              groupId: _cardRegion,
              onTapOutside: (_) => _close(),
              child: NodeCard(
                node: node,
                dayName: pathDayName(day),
                level: i + 1,
                onOpen: () => _open(node),
                onSkip: () => _skip(node),
                skipping: skip.busyNodeId == node.id,
                skipError: skip.errorFor(node.id),
                skipHidden: cooling,
              ),
            ),
          );
        }
        if (day.isToday && node.id == lastPart) {
          rows.add(
            LessonChest(
              // Every part, not the last: a part can be skipped.
              open: isLessonDone(day),
              offset: amp * windAt(step++),
            ),
          );
        }
      }
    }
    if (days.isNotEmpty) {
      rows.add(
        WeekTrophyView(
          trophy: weekTrophy(widget.path.weekReward),
          offset: amp * windAt(step++),
        ),
      );
    }

    return Column(
      children: <Widget>[
        _UnitBanner(path: widget.path, title: widget.title),
        const SizedBox(height: 24),
        ...rows,
        const SizedBox(height: 40),
      ],
    );
  }
}

/// The week's banner: "Week 2 · Day 11" over the contest's name. The day
/// only — never "of N": the contest's length is not its brand.
class _UnitBanner extends StatelessWidget {
  const _UnitBanner({required this.path, required this.title});

  final ContestPath path;
  final String title;

  @override
  Widget build(BuildContext context) {
    final String kicker = <String>[
      if (path.weekNumber case final int w when w > 0) 'Week $w',
      if (path.dayNumber case final int d when d > 0) 'Day $d',
    ].join(' · ');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          // CSS 120deg: from the top-left, towards the bottom-right.
          begin: Alignment(-0.87, -0.5),
          end: Alignment(0.87, 0.5),
          colors: <Color>[
            ContestColors.lesson,
            Color(0xFF4B2FD8),
            Color(0xFF7B3FE4),
          ],
          stops: <double>[0, 0.55, 1],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x592F3AF7), blurRadius: 40),
          BoxShadow(color: Color(0xFF1B22A8), offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (kicker.isNotEmpty)
            Text(
              kicker.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.32,
                color: const Color(0xBFFFFFFF),
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          const SizedBox(height: 4),
          Semantics(
            header: true,
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.18,
                color: ZaveColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "MON · DAY 9", "WED · DAY 11 · TODAY" between two rules. Today in
/// periwinkle.
class _DayDivider extends StatelessWidget {
  const _DayDivider(this.day);

  final PathDay day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 14),
      child: LabelledRule(
        colour: ZaveColors.rule,
        thickness: 2,
        gap: 14,
        label: Semantics(
          header: true,
          child: Text(
            dayLabel(day).toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.82,
              color: day.isToday ? ContestColors.peri : ZaveColors.ink50,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

/// One level's row: the node, swung sideways by [offset]; the current
/// level's taller, with Plexa beside it where there is room.
class _NodeRow extends StatelessWidget {
  const _NodeRow({
    required this.node,
    required this.dayName,
    required this.level,
    required this.offset,
    required this.current,
    required this.progress,
    required this.expanded,
    required this.plexa,
    required this.region,
    required this.onPressed,
    super.key,
  });

  final PathNode node;
  final String dayName;

  /// Its number in the day: Level 1, Level 2 …
  final int level;
  final double offset;
  final bool current;
  final double progress;
  final bool expanded;

  /// Draw Plexa's inspect still beside it — the web's desktop-only touch,
  /// kept to a wide screen: on a phone she would sit on the path.
  final bool plexa;
  final Object region;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget button = TapRegion(
      groupId: region,
      child: PathNodeButton(
        node: node,
        dayName: dayName,
        level: level,
        current: current,
        progress: progress,
        expanded: expanded,
        onPressed: onPressed,
      ),
    );
    return SizedBox(
      height: current ? kPathCurrentRowHeight : kPathRowHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          if (plexa)
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(_plexaCentre(), 0),
                child: const ExcludeSemantics(
                  child: QuizPlexaStill(QuizMood.inspect),
                ),
              ),
            ),
          // The swing moves the whole row's box, not just the node inside
          // it: a hit is tested against every box on the way down, so a
          // node translated out of a box the size of itself could only be
          // tapped where the two still overlapped.
          Transform.translate(
            offset: Offset(offset, 0),
            child: Align(
              alignment: current ? Alignment.bottomCenter : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: current ? 14 : 0),
                child: button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Plexa's centre, from the row's: on the side the node swung TOWARDS —
  /// the web's `plexaSide`, opposite the side label, which a wide screen
  /// would have room for — clear of the node's half-width and her own.
  double _plexaCentre() {
    const double half = kPathNodeWidth / 2;
    const double plexaWidth = 118 * 520 / 432;
    return offset > 0
        ? offset + half + 24 + plexaWidth / 2
        : offset - half - 170 + plexaWidth / 2;
  }
}
