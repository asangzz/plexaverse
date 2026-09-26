import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/calendar_month.dart';
import '../../domain/calendar_post.dart';
import '../calendar_status_ui.dart';

/// The month grid — six rows of seven days, Monday-first.
///
/// ## What a phone cell can and cannot show
///
/// The web cell is 110px tall and shows up to three full post chips, each with
/// a time and 30 characters of title. A phone column is roughly 42dp wide;
/// thirty characters is not legible at that width at any type size in the
/// system, and shrinking the type to fit would break the Zave scale.
///
/// **So the cell shows the date and up to three status DOTS, and the chips move
/// into the day sheet.** That is a deliberate departure: the grid answers "which
/// days have something, and is it healthy?" at a glance, and one tap answers
/// "what exactly?". Trying to keep the chips would have produced a grid that
/// says nothing legibly instead of one thing legibly.
///
/// The web's drag-and-drop is likewise absent — see `CalendarPage`, which moves
/// a post by putting the grid into an explicit pick-a-day mode.
class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    required this.viewMonth,
    required this.byDay,
    required this.onSelectDay,
    this.selectedDay,
    this.pickMode = false,
    super.key,
  });

  /// Any date inside the month being shown.
  final DateTime viewMonth;

  /// Scheduled posts keyed by `dayKey`.
  final Map<String, List<CalendarPost>> byDay;

  final ValueChanged<DateTime> onSelectDay;
  final DateTime? selectedDay;

  /// The page is waiting for the user to choose a day for a post being moved.
  /// Every cell becomes a target, including the empty ones.
  final bool pickMode;

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = buildMonthGrid(viewMonth.year, viewMonth.month);
    final DateTime today = DateTime.now();

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            for (final String label in kWeekdayLabels)
              Expanded(
                child: Center(
                  child: Text(label.toUpperCase(), style: ZaveType.kicker),
                ),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        for (int row = 0; row < 6; row++) ...<Widget>[
          Row(
            children: <Widget>[
              for (int col = 0; col < 7; col++) ...<Widget>[
                if (col > 0) SizedBox(width: ZaveSpace.xs),
                Expanded(child: _cell(days[row * 7 + col], today)),
              ],
            ],
          ),
          if (row < 5) SizedBox(height: ZaveSpace.xs),
        ],
      ],
    );
  }

  Widget _cell(DateTime day, DateTime today) {
    final DateTime? selected = selectedDay;
    return _DayCell(
      day: day,
      posts: byDay[dayKey(day)] ?? const <CalendarPost>[],
      inMonth: isSameMonth(day, viewMonth),
      isToday: isSameDay(day, today),
      isSelected: selected != null && isSameDay(day, selected),
      pickMode: pickMode,
      onTap: () => onSelectDay(day),
    );
  }
}

/// One day.
///
/// Depth is the fill step and nothing else: a day outside the month is
/// transparent, a day inside it rests, and the selected day (or, in pick mode,
/// every day) is raised. There is no shadow and no border colour that is not a
/// Zave glass border.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.posts,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.pickMode,
    required this.onTap,
  });

  final DateTime day;
  final List<CalendarPost> posts;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final bool pickMode;
  final VoidCallback onTap;

  /// How many status dots a cell can hold before it stops trying.
  static const int _maxDots = 3;

  @override
  Widget build(BuildContext context) {
    final bool raised = isSelected || (pickMode && inMonth);

    // `Colors.transparent` rather than a hex literal: a day outside the month
    // has no surface at all, which is the absence of a fill step, not a sixth
    // one.
    final Color fill = raised
        ? ZaveGlass.now
        : (inMonth ? ZaveGlass.rest : Colors.transparent);
    final Color border = raised
        ? ZaveGlass.nowBorder
        : (inMonth ? ZaveGlass.restBorder : Colors.transparent);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${day.day}, ${posts.length} posts',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AspectRatio(
          // Slightly taller than wide, so the date and its dot row both have
          // room. The web's fixed 110px height has no phone equivalent — at
          // seven columns on a 360dp screen the cell's width is what decides
          // its size, so the ratio is the honest way to express it.
          aspectRatio: 0.86,
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            padding: EdgeInsets.all(ZaveSpace.xs),
            decoration: BoxDecoration(
              color: fill,
              border: Border.all(color: border, width: 1),
              // The web cell is r12; Zave's smallest surface radius is r16
              // (`ZaveRadius.input`), which is the nearest token and the one
              // used here rather than a literal 12.
              borderRadius: BorderRadius.circular(ZaveRadius.input),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DayNumber(day: day, inMonth: inMonth, isToday: isToday),
                SizedBox(height: ZaveSpace.xs),
                SizedBox(
                  height: ZaveSpace.dot,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (
                          int i = 0;
                          i < posts.length && i < _maxDots;
                          i++
                        ) ...<Widget>[
                          if (i > 0) SizedBox(width: ZaveSpace.xs / 2),
                          ZaveDot(calendarSignal(posts[i].status).color),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The date itself.
///
/// Today inverts to a solid white disc with ink letters — the same "selected
/// becomes white" language as a chip or a nav item. The web paints a
/// blue→green gradient here; Zave has no gradient fills and no decorative
/// colour, so the inversion carries the meaning instead.
class _DayNumber extends StatelessWidget {
  const _DayNumber({
    required this.day,
    required this.inMonth,
    required this.isToday,
  });

  final DateTime day;
  final bool inMonth;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    if (isToday) {
      return Container(
        height: ZaveSpace.xl,
        width: ZaveSpace.xl,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: ZaveColors.white,
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${day.day}',
            style: ZaveType.label.copyWith(color: ZaveColors.ink),
          ),
        ),
      );
    }

    return SizedBox(
      height: ZaveSpace.xl,
      child: Center(
        child: Text(
          '${day.day}',
          style: ZaveType.label.copyWith(
            color: inMonth ? ZaveColors.ink85 : ZaveColors.ink35,
          ),
        ),
      ),
    );
  }
}
