import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar_month.dart';
import '../../domain/calendar_post.dart';
import '../widgets/calendar_month_grid.dart';
import '../widgets/calendar_pending_strip.dart';
import '../widgets/day_detail_sheet.dart';
import '../widgets/schedule_time_sheet.dart';

/// **Calendar** — the web's `/calendar`.
///
/// ## The one structural departure: no drag-and-drop
///
/// The web moves a post between days with `@dnd-kit`: pick a card up from the
/// pending rail, drop it on a day cell, confirm a time. Its own touch sensor
/// needs a 200 ms press-and-hold before a drag starts, which on a phone
/// competes with the scroll gesture the grid and the strip both need — and the
/// same file already ships a touch fallback (`PendingPill` → sheet) because of
/// it.
///
/// So this screen makes the fallback the main path and names it:
///
///   1. Tap a pending card, **or** tap "Move to…" on a scheduled post in the
///      day sheet. The grid goes into **pick-a-day** mode and says so.
///   2. Tap a day. The time sheet opens on a suggested free hour.
///   3. Confirm. `PATCH /posts/{id}` sets `scheduledFor` and `status`.
///
/// Tapping a day outside pick-a-day mode opens that day's sheet, exactly as the
/// web's `onSelectDay` does.
///
/// ## Screen-local state stays in the widget
///
/// The month being viewed, the selected day and the post being moved are
/// ephemeral UI state and live here, not in a provider — the same split the web
/// app's own contract draws between Zustand and React Query. Only the posts go
/// through a controller.
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _viewMonth = _currentMonth();
  DateTime? _selectedDay;

  /// The post waiting for a day. Non-null puts the grid into pick-a-day mode.
  CalendarPost? _moving;

  /// A reschedule is in flight — the grid is not lying to the user while the
  /// server re-queues the Cloud Task.
  bool _busy = false;

  /// The last reschedule failed. Surfaced inline rather than as a snackbar:
  /// Material's snackbar carries none of Zave's surfaces.
  String? _error;

  static DateTime _currentMonth() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CalendarBuckets> buckets = ref.watch(
      calendarControllerProvider,
    );

    return ZaveScaffold(
      title: 'Calendar',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(calendarControllerProvider);
          await ref.read(calendarControllerProvider.future);
        },
        child: buckets.when(
          loading: () => const _CalendarSkeleton(),
          error: (Object error, StackTrace _) => _CalendarError(
            onRetry: () => ref.invalidate(calendarControllerProvider),
          ),
          data: _body,
        ),
      ),
    );
  }

  Widget _body(CalendarBuckets buckets) {
    final Map<String, List<CalendarPost>> byDay = groupByDay(buckets.scheduled);
    final CalendarPost? moving = _moving;

    return ZaveScrollView(
      children: <Widget>[
        _MonthStepper(
          viewMonth: _viewMonth,
          onPrevious: () => setState(() {
            _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
          }),
          onNext: () => setState(() {
            _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
          }),
        ),
        SizedBox(height: ZaveSpace.md),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${buckets.scheduled.length} scheduled · '
                '${buckets.pending.length} pending',
                style: ZaveType.caption,
              ),
            ),
            ZaveButton(
              label: 'Today',
              onPressed: () => setState(() => _viewMonth = _currentMonth()),
            ),
          ],
        ),

        if (_error != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          _Banner(
            // Amber, not red — Zave has no red, and a failed reschedule is
            // "this needs you", not a destructive state.
            tone: ZaveColors.amber,
            kicker: 'Could not reschedule',
            body: _error!,
            action: ZaveButton(
              label: 'Dismiss',
              onPressed: () => setState(() => _error = null),
            ),
          ),
        ],

        if (moving != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          _Banner(
            tone: ZaveColors.peri,
            kicker: 'Pick a day',
            body: truncate(moving.displayText, 110),
            action: ZaveButton(
              label: 'Cancel',
              onPressed: () => setState(() => _moving = null),
            ),
          ),
        ],

        if (_busy) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          _Banner(
            tone: ZaveColors.scheduled,
            kicker: 'Scheduling',
            body: 'Queueing the post…',
          ),
        ],

        // The backlog sits ABOVE the grid, which is both the web's own reading
        // order (`PendingRail | CalendarGrid`) and the order the gesture needs:
        // tapping a pending card arms pick-a-day mode, and the days it is
        // asking you to choose from are the very next thing on screen.
        SizedBox(height: ZaveSpace.xl),
        CalendarPendingStrip(
          pending: buckets.pending,
          onPick: (CalendarPost post) => setState(() => _moving = post),
        ),

        SizedBox(height: ZaveSpace.xxl),
        CalendarMonthGrid(
          viewMonth: _viewMonth,
          byDay: byDay,
          selectedDay: _selectedDay,
          pickMode: moving != null,
          onSelectDay: (DateTime day) => _onSelectDay(day, buckets, byDay),
        ),
      ],
    );
  }

  Future<void> _onSelectDay(
    DateTime day,
    CalendarBuckets buckets,
    Map<String, List<CalendarPost>> byDay,
  ) async {
    final CalendarPost? moving = _moving;

    // Pick-a-day mode: this tap chooses the destination.
    if (moving != null) {
      setState(() => _moving = null);
      await _scheduleOnto(day: day, post: moving, byDay: byDay);
      return;
    }

    setState(() => _selectedDay = day);

    final DaySheetRequest? request = await DayDetailSheet.show(
      context,
      day: day,
      scheduled: byDay[dayKey(day)] ?? const <CalendarPost>[],
      pending: buckets.pending,
    );
    if (!mounted) return;
    setState(() => _selectedDay = null);
    if (request == null) return;

    switch (request.intent) {
      case DaySheetIntent.scheduleHere:
        await _scheduleOnto(day: day, post: request.post, byDay: byDay);
      case DaySheetIntent.moveElsewhere:
        // The destination is not known yet — hand the grid over.
        setState(() => _moving = request.post);
    }
  }

  Future<void> _scheduleOnto({
    required DateTime day,
    required CalendarPost post,
    required Map<String, List<CalendarPost>> byDay,
  }) async {
    final List<DateTime> occupied = <DateTime>[
      for (final CalendarPost p in byDay[dayKey(day)] ?? const <CalendarPost>[])
        if (p.calendarDate != null) p.calendarDate!,
    ];

    final DateTime? when = await ScheduleTimeSheet.show(
      context,
      day: day,
      post: post,
      occupied: occupied,
    );
    if (when == null || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(calendarControllerProvider.notifier)
          .reschedule(postId: post.id, when: when);
      if (!mounted) return;
      setState(() => _busy = false);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = '$error';
      });
    }
  }
}

/// The month label between its two steppers.
///
/// The web keeps the steppers, the label and "Today" in one right-hand cluster.
/// At phone width those four controls do not fit on a line without the month
/// label ellipsing, so the stepper takes a line of its own and "Today" moves
/// down beside the counts.
class _MonthStepper extends StatelessWidget {
  const _MonthStepper({
    required this.viewMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime viewMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      ZaveIconButton(
        icon: const Icon(Icons.chevron_left),
        tooltip: 'Previous month',
        onPressed: onPrevious,
      ),
      Expanded(
        child: Center(
          child: Text(
            DateFormat.yMMMM().format(viewMonth),
            style: ZaveType.h3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      ZaveIconButton(
        icon: const Icon(Icons.chevron_right),
        tooltip: 'Next month',
        onPressed: onNext,
      ),
    ],
  );
}

/// A one-line state banner: a status dot, a kicker, a line of body and an
/// optional action. Used for pick-a-day, busy and error, so all three read as
/// the same kind of object rather than three inventions.
///
/// It takes the `now` fill step because that is literally what it reports —
/// the thing happening right now. Only one banner is ever on screen at a time
/// (busy and pick-a-day are mutually exclusive), so the step keeps its meaning.
class _Banner extends StatelessWidget {
  const _Banner({
    required this.tone,
    required this.kicker,
    required this.body,
    this.action,
  });

  final Color tone;
  final String kicker;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    padding: ZaveSpace.rowPad,
    isNow: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZaveDot(tone),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: Text(kicker.toUpperCase(), style: ZaveType.kicker),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(body, style: ZaveType.bodyMuted),
        if (action != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Align(alignment: Alignment.centerLeft, child: action!),
        ],
      ],
    ),
  );
}

/// The loading state — the real layout's silhouette, so the screen does not
/// jump when the data lands.
class _CalendarSkeleton extends StatelessWidget {
  const _CalendarSkeleton();

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      _SkeletonBlock(height: ZaveSpace.section),
      SizedBox(height: ZaveSpace.xl),
      _SkeletonBlock(height: ZaveSpace.section * 1.6),
      SizedBox(height: ZaveSpace.xxl),
      _SkeletonBlock(height: MediaQuery.sizeOf(context).width),
    ],
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}

class _CalendarError extends StatelessWidget {
  const _CalendarError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Amber, not red: Zave has no red, and a failed fetch is
                // "needs attention", not a destructive state.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Text('COULD NOT LOAD', style: ZaveType.kicker),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            Text('The calendar did not load.', style: ZaveType.h3),
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    ],
  );
}
