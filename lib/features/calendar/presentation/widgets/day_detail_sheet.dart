import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/calendar_month.dart';
import '../../domain/calendar_post.dart';
import '../calendar_status_ui.dart';
import 'calendar_sheet.dart';

/// What the day sheet asks the page to do once it has closed.
enum DaySheetIntent {
  /// Put this pending post on the day the sheet was opened for.
  scheduleHere,

  /// Move this already-scheduled post to some OTHER day the user has yet to
  /// choose. The page puts the grid into pick-a-day mode.
  moveElsewhere,
}

/// The sheet's answer. Null means the user just closed it.
class DaySheetRequest {
  const DaySheetRequest(this.post, this.intent);

  final CalendarPost post;
  final DaySheetIntent intent;
}

/// One day's posts, plus the touch path to scheduling.
///
/// The web's `DayDetailSheet` is the same object: a list of the day's posts and
/// a "Schedule a pending post here" footer that flips the body into a picker.
/// Its own comment calls this "the touch-friendly path to scheduling — drag and
/// drop is desktop-only territory", which is exactly why this screen builds on
/// it rather than trying to reproduce the drag.
///
/// The one addition is **Move to…** on an already-scheduled row. On the web
/// that is done by dragging the post out of one cell and into another; a phone
/// needs a named action, and this is it.
class DayDetailSheet extends StatefulWidget {
  const DayDetailSheet({
    required this.day,
    required this.scheduled,
    required this.pending,
    super.key,
  });

  final DateTime day;

  /// The posts already on this day.
  final List<CalendarPost> scheduled;

  /// The whole pending backlog — the picker mode shows it all, because the user
  /// is choosing WHICH post lands on this day.
  final List<CalendarPost> pending;

  static Future<DaySheetRequest?> show(
    BuildContext context, {
    required DateTime day,
    required List<CalendarPost> scheduled,
    required List<CalendarPost> pending,
  }) => showModalBottomSheet<DaySheetRequest>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext _) =>
        DayDetailSheet(day: day, scheduled: scheduled, pending: pending),
  );

  @override
  State<DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends State<DayDetailSheet> {
  bool _picking = false;

  @override
  Widget build(BuildContext context) {
    // "Friday, September 18" — the web's
    // `toLocaleDateString(undefined, {weekday, month, day})`.
    final String dateLabel = DateFormat(
      'EEEE, MMMM d',
    ).format(widget.day);

    return CalendarSheet(
      footer: _footer(context),
      children: _picking ? _pickerBody(context) : _dayBody(dateLabel),
    );
  }

  List<Widget> _dayBody(String dateLabel) => <Widget>[
    CalendarSheetTitle(
      kicker: '${widget.scheduled.length} scheduled',
      title: dateLabel,
    ),
    SizedBox(height: ZaveSpace.xl),
    if (widget.scheduled.isEmpty)
      ZaveCard(
        size: ZaveCardSize.small,
        padding: ZaveSpace.rowPad,
        child: Text(
          'Nothing scheduled for this day yet.',
          style: ZaveType.bodyMuted,
        ),
      )
    else
      for (int i = 0; i < widget.scheduled.length; i++) ...<Widget>[
        if (i > 0) SizedBox(height: ZaveSpace.md),
        _ScheduledRow(
          post: widget.scheduled[i],
          onMove: widget.scheduled[i].status.isMovable
              ? () => Navigator.of(context).pop(
                  DaySheetRequest(
                    widget.scheduled[i],
                    DaySheetIntent.moveElsewhere,
                  ),
                )
              : null,
        ),
      ],
  ];

  List<Widget> _pickerBody(BuildContext context) => <Widget>[
    CalendarSheetTitle(
      kicker: 'Pick a post',
      title: 'Schedule here',
    ),
    SizedBox(height: ZaveSpace.xl),
    if (widget.pending.isEmpty)
      ZaveCard(
        size: ZaveCardSize.small,
        padding: ZaveSpace.rowPad,
        child: Text(
          'No pending posts to schedule.',
          style: ZaveType.bodyMuted,
        ),
      )
    else
      for (int i = 0; i < widget.pending.length; i++) ...<Widget>[
        if (i > 0) SizedBox(height: ZaveSpace.md),
        _PendingRow(
          post: widget.pending[i],
          onTap: () => Navigator.of(context).pop(
            DaySheetRequest(widget.pending[i], DaySheetIntent.scheduleHere),
          ),
        ),
      ],
  ];

  Widget _footer(BuildContext context) {
    if (_picking) {
      return ZaveButton(
        label: 'Back',
        expand: true,
        onPressed: () => setState(() => _picking = false),
      );
    }
    return ZaveButton(
      label: 'Schedule a pending post here',
      kind: ZaveButtonKind.primarySmall,
      expand: true,
      // Disabled with nothing to schedule, exactly as the web disables it.
      onPressed: widget.pending.isEmpty
          ? null
          : () => setState(() => _picking = true),
    );
  }
}

/// A post already on this day.
class _ScheduledRow extends StatelessWidget {
  const _ScheduledRow({required this.post, this.onMove});

  final CalendarPost post;

  /// Null for a published post — the server refuses to edit one, so offering
  /// the action would only ever produce a 409.
  final VoidCallback? onMove;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label, String description}) signal =
        calendarSignal(post.status);
    final DateTime? at = post.calendarDate;

    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(signal.color),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  signal.label,
                  style: ZaveType.caption.copyWith(color: signal.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (at != null)
                Text(DateFormat.jm().format(at), style: ZaveType.caption),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            truncate(post.content.isEmpty ? post.displayText : post.content, 220),
            style: ZaveType.body,
          ),
          if (post.failureReason != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              post.failureReason!,
              // Amber, not red: Zave has no red, and this is "needs you".
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
          ],
          if (onMove != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(
              label: 'Move to…',
              icon: const Icon(Icons.event_repeat_outlined),
              expand: true,
              onPressed: onMove,
            ),
          ],
        ],
      ),
    );
  }
}

/// One candidate from the backlog, in picker mode.
class _PendingRow extends StatelessWidget {
  const _PendingRow({required this.post, required this.onTap});

  final CalendarPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label, String description}) signal =
        calendarSignal(post.status);

    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(signal.color),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  signal.label,
                  style: ZaveType.caption.copyWith(color: signal.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            truncate(post.displayText, 110),
            style: ZaveType.bodyMuted,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
