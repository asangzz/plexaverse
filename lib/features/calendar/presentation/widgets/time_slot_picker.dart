import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// A grid of selectable times.
///
/// ## Departure: slots, not `<input type="time">`
///
/// The web uses a native time input in both the calendar's `TimePickerDialog`
/// and the create-schedule modal. Flutter's equivalent is `showTimePicker`,
/// which brings the entire Material clock face — its own surfaces, its own type
/// scale, its own accent colour — none of which is Zave, and none of which can
/// be themed into Zave without fighting it.
///
/// So the choice is expressed as chips instead, which is already the system's
/// selection language: a selected chip inverts to solid white with ink letters.
/// It also fits the actual use — a posting time is chosen from a handful of
/// sensible slots, not to the minute.
class TimeSlotPicker extends StatelessWidget {
  const TimeSlotPicker({
    required this.value,
    required this.onChanged,
    this.occupied = const <TimeOfDay>[],
    this.startHour = 7,
    this.endHour = 21,
    this.stepMinutes = 60,
    super.key,
  });

  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  /// Times that already have a post on this day. Shown with a marker but still
  /// selectable — the web's free-text input lets you double-book too, and there
  /// are real reasons to (a morning post and a morning reshare).
  final List<TimeOfDay> occupied;

  final int startHour;
  final int endHour;
  final int stepMinutes;

  /// `9:00 AM` / `18:30` depending on the device locale, from one place so the
  /// chip and the summary line can never disagree.
  static String format(TimeOfDay time) =>
      DateFormat.jm().format(DateTime(2000, 1, 1, time.hour, time.minute));

  @override
  Widget build(BuildContext context) {
    final Set<int> taken = <int>{
      for (final TimeOfDay t in occupied) t.hour * 60 + t.minute,
    };

    // The suggested time can fall off the step grid — `suggestTimeForDay`
    // falls back to a 30-minute scan when every preferred hour is taken — so
    // the current value is always folded in. A picker whose own default is not
    // one of its options shows nothing selected, which reads as broken.
    final Set<int> minutes = <int>{
      for (int m = startHour * 60; m <= endHour * 60; m += stepMinutes) m,
      value.hour * 60 + value.minute,
    };
    final List<int> ordered = minutes.toList()..sort();
    final List<TimeOfDay> slots = <TimeOfDay>[
      for (final int m in ordered) TimeOfDay(hour: m ~/ 60, minute: m % 60),
    ];

    return Wrap(
      spacing: ZaveSpace.sm,
      runSpacing: ZaveSpace.sm,
      children: <Widget>[
        for (final TimeOfDay slot in slots)
          ZaveChip(
            label: format(slot),
            selected: slot.hour == value.hour && slot.minute == value.minute,
            onTap: () => onChanged(slot),
            icon: taken.contains(slot.hour * 60 + slot.minute)
                ? const ZaveDot(ZaveColors.scheduled)
                : null,
          ),
      ],
    );
  }
}
