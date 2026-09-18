import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// What the user chose in [pickSchedule].
///
/// Three outcomes, and they are genuinely distinct: a time was picked, the
/// schedule was removed, or the sheet was dismissed. A plain `DateTime?` cannot
/// tell "unschedule this" apart from "never mind", and the API treats those two
/// very differently — one is a PATCH with an explicit null, the other is no
/// request at all.
class ScheduleChoice {
  const ScheduleChoice.at(DateTime at) : when = at, cleared = false;
  const ScheduleChoice.clear() : when = null, cleared = true;

  final DateTime? when;
  final bool cleared;
}

/// Pick a publish time, as a sheet.
///
/// Ports the web's edit-mode schedule block on `/posts/[id]`: a strip of the
/// next seven days and a grid of sixteen hourly slots from 6 AM to 9 PM. The
/// web generates thirty days and then renders `.slice(0, 7)`; only the seven
/// are reachable, so only the seven are built here.
///
/// Restated in Zave: the web's selected day is `bg-[#5761EB]` and its selected
/// time is `bg-[#00DC82]` — two accent fills for one act of selection. Here
/// both are chips, and a selected chip INVERTS to solid white with ink letters,
/// which is the system's single selection language.
Future<ScheduleChoice?> pickSchedule(
  BuildContext context, {
  DateTime? initial,
}) {
  return showModalBottomSheet<ScheduleChoice>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => _ScheduleSheet(initial: initial),
  );
}

class _ScheduleSheet extends StatefulWidget {
  const _ScheduleSheet({this.initial});

  final DateTime? initial;

  @override
  State<_ScheduleSheet> createState() => _ScheduleSheetState();
}

class _ScheduleSheetState extends State<_ScheduleSheet> {
  static final DateFormat _dayLabel = DateFormat('EEE, MMM d');
  static final DateFormat _hourLabel = DateFormat('h a');

  /// 6 AM … 9 PM, hourly — the web's sixteen slots.
  static const List<int> _hours = <int>[
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
  ];

  late DateTime _day;
  late int _hour;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateTime? initial = widget.initial;
    _day = initial == null
        ? DateTime(now.year, now.month, now.day)
        : DateTime(initial.year, initial.month, initial.day);
    // 9 AM is the web's default `selectedTime`. An existing schedule outside
    // the 6–21 window snaps to the nearest end rather than silently selecting
    // nothing.
    _hour = initial == null ? 9 : initial.hour.clamp(_hours.first, _hours.last);
  }

  List<DateTime> get _days {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <DateTime>[for (int i = 0; i < 7; i++) today.add(Duration(days: i))];
  }

  String _labelFor(DateTime day, int index) => switch (index) {
    0 => 'Today',
    1 => 'Tomorrow',
    _ => _dayLabel.format(day),
  };

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // Built once per frame: `_days` allocates, and reading it inside the loop
    // would rebuild the list on every iteration.
    final List<DateTime> days = _days;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ZaveColors.rule,
                    borderRadius: ZaveRadius.pillBr,
                  ),
                ),
              ),
              SizedBox(height: ZaveSpace.xl),
              Text('SCHEDULE', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              Text('When should this go out?', style: ZaveType.h3),

              SizedBox(height: ZaveSpace.xl),
              Text('DAY', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < days.length; i++) ...<Widget>[
                      ZaveChip(
                        label: _labelFor(days[i], i),
                        selected: _sameDay(days[i], _day),
                        onTap: () => setState(() => _day = days[i]),
                      ),
                      SizedBox(width: ZaveSpace.sm),
                    ],
                  ],
                ),
              ),

              SizedBox(height: ZaveSpace.xl),
              Text('TIME', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              Wrap(
                spacing: ZaveSpace.sm,
                runSpacing: ZaveSpace.sm,
                children: <Widget>[
                  for (final int hour in _hours)
                    ZaveChip(
                      label: _hourLabel.format(
                        DateTime(_day.year, _day.month, _day.day, hour),
                      ),
                      selected: hour == _hour,
                      onTap: () => setState(() => _hour = hour),
                    ),
                ],
              ),

              SizedBox(height: ZaveSpace.xl),
              ZaveButton.primary(
                label: 'Schedule post',
                expand: true,
                onPressed: () => Navigator.of(context).pop(
                  ScheduleChoice.at(
                    DateTime(_day.year, _day.month, _day.day, _hour),
                  ),
                ),
              ),
              if (widget.initial != null) ...<Widget>[
                SizedBox(height: ZaveSpace.md),
                ZaveButton(
                  label: 'Remove schedule',
                  expand: true,
                  onPressed: () =>
                      Navigator.of(context).pop(const ScheduleChoice.clear()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
