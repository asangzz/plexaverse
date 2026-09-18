import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/compose_draft.dart';

/// One of the five "peak engagement times" the web offers.
class _PeakTime {
  const _PeakTime(this.value, this.label, this.sublabel, this.icon, this.peak);

  /// 'HH:mm'.
  final String value;
  final String label;
  final String sublabel;
  final String icon;

  /// LinkedIn's two strongest windows. The web draws an amber border on these;
  /// see the note in [SchedulePanel] for what happens to that here.
  final bool peak;
}

/// The web's table, verbatim — including the emoji, which carry the meaning
/// ("Lunch Peak" reads very differently with and without 🍽️).
const List<_PeakTime> _peakTimes = <_PeakTime>[
  _PeakTime('07:30', '7:30 AM', 'Early Birds', '🌅', false),
  _PeakTime('08:30', '8:30 AM', 'Morning Commute', '☕', false),
  _PeakTime('12:00', '12:00 PM', 'Lunch Peak', '🍽️', true),
  _PeakTime('17:00', '5:00 PM', 'Evening Rush', '🌆', false),
  _PeakTime('18:30', '6:30 PM', 'After Work', '🏠', true),
];

/// The 25 slots behind "More times", in the web's order.
const List<String> _timeSlots = <String>[
  '06:00',
  '07:00',
  '07:30',
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '17:30',
  '18:00',
  '18:30',
  '19:00',
  '19:30',
  '20:00',
  '21:00',
];

/// "Schedule post" — when this goes out.
///
/// Ports the web composer's schedule panel (recon §4.2.4 item 7). Three
/// deliberate changes, all of them because a phone is not a browser:
///
/// • The web's checkbox becomes a [ZaveSwitch]. Zave has no checkbox, and the
///   switch carries the same "selected inverts to white" language as every
///   other selected thing in the system.
/// • The web's `<input type="date">` and `<input type="time">` become the
///   platform pickers. A native date input on a phone IS a platform picker, so
///   this is the same control, not a substitute.
/// • The two peak slots get an amber border on the web. A Zave chip has exactly
///   two states — rest, and selected-inverts-to-white — and adding a third
///   border colour would break the one rule the system is most protective of.
///   The peak signal instead lands where the web also puts it: an amber suffix
///   on the summary line once such a time is chosen.
class SchedulePanel extends StatefulWidget {
  const SchedulePanel({
    required this.draft,
    required this.onToggle,
    required this.onPickDate,
    required this.onPickTime,
    super.key,
  });

  final ComposeDraft draft;
  final ValueChanged<bool> onToggle;
  final ValueChanged<DateTime> onPickDate;

  /// 'HH:mm', 24-hour.
  final ValueChanged<String> onPickTime;

  @override
  State<SchedulePanel> createState() => _SchedulePanelState();
}

class _SchedulePanelState extends State<SchedulePanel> {
  bool _moreTimes = false;

  @override
  Widget build(BuildContext context) {
    final ComposeDraft draft = widget.draft;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('Schedule post', style: ZaveType.h3)),
              ZaveSwitch(
                value: draft.scheduled,
                onChanged: widget.onToggle,
                semanticLabel: 'Schedule for later',
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            draft.scheduled
                ? 'Goes out at the time you pick.'
                : 'Goes out as soon as it is approved.',
            style: ZaveType.bodyMuted,
          ),

          if (draft.scheduled) ...<Widget>[
            SizedBox(height: ZaveSpace.xl),
            _DateStrip(
              selected: draft.date,
              onPick: widget.onPickDate,
              onPickOther: _pickOtherDate,
            ),

            SizedBox(height: ZaveSpace.xl),
            Text('PEAK ENGAGEMENT TIMES', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.md),
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                for (final _PeakTime peak in _peakTimes)
                  ZaveChip(
                    label: peak.label,
                    badge: peak.sublabel,
                    icon: Text(peak.icon, style: ZaveType.label),
                    selected: draft.time == peak.value,
                    onTap: () => widget.onPickTime(peak.value),
                  ),
              ],
            ),

            SizedBox(height: ZaveSpace.lg),
            Row(
              children: <Widget>[
                ZaveChip(
                  label: _moreTimes ? 'Fewer times' : 'More times',
                  selected: false,
                  icon: const Icon(Icons.schedule_outlined),
                  onTap: () => setState(() => _moreTimes = !_moreTimes),
                ),
                SizedBox(width: ZaveSpace.sm),
                ZaveChip(
                  label: 'Other time…',
                  selected: false,
                  onTap: _pickOtherTime,
                ),
              ],
            ),

            if (_moreTimes) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              Wrap(
                spacing: ZaveSpace.sm,
                runSpacing: ZaveSpace.sm,
                children: <Widget>[
                  for (final String slot in _timeSlots)
                    ZaveChip(
                      label: formatClock(slot),
                      selected: draft.time == slot,
                      onTap: () => widget.onPickTime(slot),
                    ),
                ],
              ),
            ],

            SizedBox(height: ZaveSpace.xl),
            _SelectedWhen(draft: draft),
          ],
        ],
      ),
    );
  }

  /// The web's `<input type="date">` with `min = today`. Thirty days is the
  /// same window its chip strip is generated from.
  Future<void> _pickOtherDate() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.draft.date ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );
    if (picked != null) widget.onPickDate(picked);
  }

  /// The web's `<input type="time">`.
  Future<void> _pickOtherTime() async {
    final List<String> parts = widget.draft.time.split(':');
    final TimeOfDay initial = TimeOfDay(
      hour: parts.isEmpty ? 9 : (int.tryParse(parts.first) ?? 9),
      minute: parts.length < 2 ? 0 : (int.tryParse(parts[1]) ?? 0),
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null) return;
    final String hh = picked.hour.toString().padLeft(2, '0');
    final String mm = picked.minute.toString().padLeft(2, '0');
    widget.onPickTime('$hh:$mm');
  }
}

/// The five-day strip, plus a way out to any day in the next month.
class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.selected,
    required this.onPick,
    required this.onPickOther,
  });

  final DateTime? selected;
  final ValueChanged<DateTime> onPick;
  final VoidCallback onPickOther;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('SELECT DATE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        // Horizontally scrolling, as the web's `overflow-x-auto` strip is —
        // wrapping five date chips onto three lines would bury the rest of the
        // panel.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < 5; i++) ...<Widget>[
                Builder(
                  builder: (BuildContext context) {
                    final DateTime day = today.add(Duration(days: i));
                    return ZaveChip(
                      label: _dayLabel(day, i),
                      selected: _sameDay(day, selected),
                      onTap: () => onPick(day),
                    );
                  },
                ),
                SizedBox(width: ZaveSpace.sm),
              ],
              ZaveChip(
                label: 'Pick a date',
                selected:
                    selected != null && selected!.difference(today).inDays >= 5,
                icon: const Icon(Icons.calendar_today_outlined),
                onTap: onPickOther,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static bool _sameDay(DateTime a, DateTime? b) =>
      b != null && a.year == b.year && a.month == b.month && a.day == b.day;

  static String _dayLabel(DateTime day, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    return '${weekdayShort(day)}, ${monthShort(day)} ${day.day}';
  }
}

/// The summary card — the web's "selected datetime" block.
class _SelectedWhen extends StatelessWidget {
  const _SelectedWhen({required this.draft});

  final ComposeDraft draft;

  @override
  Widget build(BuildContext context) {
    final DateTime? when = draft.scheduledFor;
    if (when == null) {
      return Container(
        padding: ZaveSpace.rowPad,
        decoration: ZaveSurface.row,
        child: Text('Pick a day to schedule this.', style: ZaveType.bodyMuted),
      );
    }

    String? peakNote;
    for (final _PeakTime peak in _peakTimes) {
      if (peak.value == draft.time && peak.peak) peakNote = peak.sublabel;
    }

    return Container(
      padding: ZaveSpace.rowPad,
      // The chosen slot is the one thing happening on this panel — the `now`
      // fill step is exactly what it is for.
      decoration: ZaveSurface.rowNow,
      child: Row(
        children: <Widget>[
          Icon(Icons.schedule_outlined, size: 20, color: ZaveColors.peri),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${weekdayLong(when)}, ${monthLong(when)} ${when.day}',
                  style: ZaveType.label,
                ),
                SizedBox(height: ZaveSpace.xs),
                Row(
                  children: <Widget>[
                    Text(
                      'at ${formatClock(draft.time)}',
                      style: ZaveType.caption,
                    ),
                    if (peakNote != null) ...<Widget>[
                      SizedBox(width: ZaveSpace.sm),
                      Text(
                        '• $peakNote',
                        style: ZaveType.caption.copyWith(
                          color: ZaveColors.amber,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date formatting ────────────────────────────────────────────────────────
// Written by hand rather than through `intl`. The composer is English-only on
// both platforms today, these are the exact strings the web produces
// (`toLocaleDateString('en-US', …)`), and pulling a localisation dependency in
// for five labels would promise a translation that does not exist.

const List<String> _weekdaysShort = <String>[
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const List<String> _weekdaysLong = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _monthsShort = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const List<String> _monthsLong = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String weekdayShort(DateTime d) => _weekdaysShort[d.weekday - 1];

String weekdayLong(DateTime d) => _weekdaysLong[d.weekday - 1];

String monthShort(DateTime d) => _monthsShort[d.month - 1];

String monthLong(DateTime d) => _monthsLong[d.month - 1];

/// 'HH:mm' → '6:30 PM', matching the web's slot labels exactly.
String formatClock(String hhmm) {
  final List<String> parts = hhmm.split(':');
  final int hour = parts.isEmpty ? 0 : (int.tryParse(parts.first) ?? 0);
  final int minute = parts.length < 2 ? 0 : (int.tryParse(parts[1]) ?? 0);
  final String suffix = hour < 12 ? 'AM' : 'PM';
  final int display = hour % 12 == 0 ? 12 : hour % 12;
  return '$display:${minute.toString().padLeft(2, '0')} $suffix';
}
