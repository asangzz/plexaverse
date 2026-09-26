import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/post_schedule.dart';
import 'calendar_sheet.dart';
import 'time_slot_picker.dart';

/// Everything the create-schedule form collects.
class ScheduleDraft {
  const ScheduleDraft({
    required this.linkedinAccountId,
    required this.dayOfWeek,
    required this.timeOfDay,
    this.topicId,
  });

  final String linkedinAccountId;

  /// 0 = Sunday … 6 = Saturday, the server's numbering.
  final List<int> dayOfWeek;

  /// `HH:MM`, 24-hour — the only shape the server accepts.
  final String timeOfDay;

  final String? topicId;
}

/// Create a recurring auto-post schedule.
///
/// The web's "Create Schedule" modal, as a sheet, field for field: account
/// (required), topic (optional), days, time. The four `<select>` / toggle /
/// `<input type=time>` controls all become chips, because a selected chip
/// inverting to solid white is the selection language this system already has —
/// and because Material's own dropdown and clock picker carry none of it.
///
/// Returns the draft, or null if the user backed out.
class ScheduleFormSheet extends StatefulWidget {
  const ScheduleFormSheet({
    required this.accounts,
    required this.topics,
    super.key,
  });

  final List<CalendarAccount> accounts;
  final List<ScheduleTopic> topics;

  static Future<ScheduleDraft?> show(
    BuildContext context, {
    required List<CalendarAccount> accounts,
    required List<ScheduleTopic> topics,
  }) => showModalBottomSheet<ScheduleDraft>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext _) =>
        ScheduleFormSheet(accounts: accounts, topics: topics),
  );

  @override
  State<ScheduleFormSheet> createState() => _ScheduleFormSheetState();
}

class _ScheduleFormSheetState extends State<ScheduleFormSheet> {
  late String? _accountId = widget.accounts.isEmpty
      ? null
      : widget.accounts.first.id;
  String? _topicId;

  /// The web's defaults, kept: weekdays at 09:00.
  final Set<int> _days = <int>{1, 2, 3, 4, 5};
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  bool get _valid => _accountId != null && _days.isNotEmpty;

  @override
  Widget build(BuildContext context) {
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
              label: 'Create',
              kind: ZaveButtonKind.primarySmall,
              expand: true,
              onPressed: _valid ? () => _submit(context) : null,
            ),
          ),
        ],
      ),
      children: <Widget>[
        const CalendarSheetTitle(kicker: 'Automate', title: 'Create schedule'),
        SizedBox(height: ZaveSpace.xl),

        Text('LINKEDIN ACCOUNT', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (final CalendarAccount account in widget.accounts)
              ZaveChip(
                label: account.displayName,
                selected: account.id == _accountId,
                onTap: () => setState(() => _accountId = account.id),
              ),
          ],
        ),

        SizedBox(height: ZaveSpace.xl),
        Text('TOPIC', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            // The web's placeholder option, made selectable: "no topic" is a
            // real choice here, not an empty state.
            ZaveChip(
              label: 'No specific topic',
              selected: _topicId == null,
              onTap: () => setState(() => _topicId = null),
            ),
            for (final ScheduleTopic topic in widget.topics)
              ZaveChip(
                label: topic.name,
                selected: topic.id == _topicId,
                onTap: () => setState(() => _topicId = topic.id),
              ),
          ],
        ),

        SizedBox(height: ZaveSpace.xl),
        Text('DAYS', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            for (int day = 0; day < kScheduleDayNames.length; day++)
              ZaveChip(
                label: kScheduleDayNames[day],
                selected: _days.contains(day),
                onTap: () => setState(() {
                  if (!_days.remove(day)) _days.add(day);
                }),
              ),
          ],
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
          onChanged: (TimeOfDay t) => setState(() => _time = t),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final String? accountId = _accountId;
    if (accountId == null) return;
    final String hh = _time.hour.toString().padLeft(2, '0');
    final String mm = _time.minute.toString().padLeft(2, '0');
    Navigator.of(context).pop(
      ScheduleDraft(
        linkedinAccountId: accountId,
        dayOfWeek: (_days.toList()..sort()),
        timeOfDay: '$hh:$mm',
        topicId: _topicId,
      ),
    );
  }
}
