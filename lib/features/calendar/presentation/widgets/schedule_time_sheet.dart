import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/calendar_month.dart';
import '../../domain/calendar_post.dart';
import 'calendar_sheet.dart';
import 'time_slot_picker.dart';

/// Picks the time a post lands on a chosen day.
///
/// The web's `TimePickerDialog`, as a sheet. Its own comment says it is
/// "intentionally minimal — one time input, one button… defaults to the first
/// free slot for the day so the common case is one click", and that default is
/// the part worth keeping: [suggestTimeForDay] is ported verbatim, so the sheet
/// opens already pointing at a sensible free hour.
///
/// Returns the chosen instant, or null if the user backed out. The mutation is
/// the PAGE's job — the web keeps the dialog open with a "Scheduling…" label
/// through the round-trip, but a sheet that stays up while the screen behind it
/// changes reads as stuck on a phone, so the sheet closes and the page shows
/// the busy state.
class ScheduleTimeSheet extends StatefulWidget {
  const ScheduleTimeSheet({
    required this.day,
    required this.post,
    required this.occupied,
    super.key,
  });

  final DateTime day;
  final CalendarPost post;

  /// Times already taken on [day] — feeds both the suggested default and the
  /// marker on an occupied chip.
  final List<DateTime> occupied;

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime day,
    required CalendarPost post,
    required List<DateTime> occupied,
  }) => showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext _) =>
        ScheduleTimeSheet(day: day, post: post, occupied: occupied),
  );

  @override
  State<ScheduleTimeSheet> createState() => _ScheduleTimeSheetState();
}

class _ScheduleTimeSheetState extends State<ScheduleTimeSheet> {
  late TimeOfDay _time = TimeOfDay.fromDateTime(
    suggestTimeForDay(widget.day, widget.occupied),
  );

  @override
  Widget build(BuildContext context) {
    final String dateLabel = DateFormat('EEEE, MMMM d').format(widget.day);

    return CalendarSheet(
      footer: Row(
        children: <Widget>[
          Expanded(
            child: ZaveButton(
              label: 'Cancel',
              expand: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: ZaveButton(
              label: 'Schedule',
              kind: ZaveButtonKind.primarySmall,
              expand: true,
              onPressed: () => Navigator.of(context).pop(
                DateTime(
                  widget.day.year,
                  widget.day.month,
                  widget.day.day,
                  _time.hour,
                  _time.minute,
                ),
              ),
            ),
          ),
        ],
      ),
      children: <Widget>[
        CalendarSheetTitle(kicker: 'Schedule post', title: dateLabel),
        SizedBox(height: ZaveSpace.xl),
        ZaveCard(
          size: ZaveCardSize.small,
          padding: ZaveSpace.rowPad,
          child: Text(
            truncate(widget.post.displayText, 200),
            style: ZaveType.bodyMuted,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: ZaveSpace.xl),
        Row(
          children: <Widget>[
            Expanded(child: Text('TIME', style: ZaveType.kicker)),
            Text(TimeSlotPicker.format(_time), style: ZaveType.label),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        TimeSlotPicker(
          value: _time,
          occupied: <TimeOfDay>[
            for (final DateTime t in widget.occupied) TimeOfDay.fromDateTime(t),
          ],
          onChanged: (TimeOfDay t) => setState(() => _time = t),
        ),
      ],
    );
  }
}
