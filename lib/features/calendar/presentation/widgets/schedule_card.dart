import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/post_schedule.dart';
import 'time_slot_picker.dart';

/// One recurring auto-post schedule.
///
/// The web row is an account name, a "Weekdays · 09:00" meta line, an optional
/// topic chip and an Active/Paused pill. The pill becomes a [ZaveSwitch] here:
/// the mobile API exposes `PATCH /schedules/{id}`, and a status pill you cannot
/// act on is a worse answer to "stop posting for me" than a switch is. See
/// `SchedulesController` for why that addition is deliberate.
///
/// Active is GREEN and paused is ink-35 — done-and-running versus inert. The
/// web uses the same two meanings (`#00DC82` / grey).
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    required this.schedule,
    required this.onToggle,
    required this.onDelete,
    this.busy = false,
    super.key,
  });

  final PostSchedule schedule;

  /// Pause / resume.
  final ValueChanged<bool> onToggle;

  final VoidCallback onDelete;

  /// A write is in flight; the controls stop taking taps.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ScheduleTopic? topic = schedule.topic;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(schedule.isActive ? ZaveColors.green : ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  schedule.isActive ? 'ACTIVE' : 'PAUSED',
                  style: ZaveType.kicker,
                ),
              ),
              ZaveSwitch(
                value: schedule.isActive,
                semanticLabel: schedule.isActive
                    ? 'Pause this schedule'
                    : 'Resume this schedule',
                onChanged: busy ? null : onToggle,
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(schedule.accountLabel, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            '${schedule.daysLabel} · ${_readableTime(schedule.timeOfDay)}',
            style: ZaveType.bodyMuted,
          ),
          if (topic != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Align(
              alignment: Alignment.centerLeft,
              child: ZavePill(label: topic.name, color: ZaveColors.peri),
            ),
          ],
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: busy ? null : onDelete,
            ),
          ),
        ],
      ),
    );
  }

  /// `09:00` → the device's own rendering of nine in the morning.
  ///
  /// The wire value is always 24-hour `HH:MM` because that is what the server
  /// validates; showing it raw to a user on a 12-hour locale is a small, daily
  /// annoyance. An unparseable value falls back to the raw string rather than
  /// throwing — a schedule that renders oddly beats a screen that does not.
  static String _readableTime(String hhmm) {
    final List<String> parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return hhmm;
    return TimeSlotPicker.format(TimeOfDay(hour: hour, minute: minute));
  }
}
