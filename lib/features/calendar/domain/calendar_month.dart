/// Pure calendar arithmetic — the Dart port of the web's
/// `app/(dashboard)/calendar/calendar-utils.ts`.
///
/// Everything here is deliberately free of Flutter and of the repository, so
/// the grid's shape, the bucket split and the suggested-time algorithm are
/// testable on their own and cannot drift from the web by being "fixed" inside
/// a widget.
library;

import 'calendar_post.dart';

/// The weekday header. **The week starts on MONDAY**, as it does on the web —
/// not on Sunday, which is what `DateTime.weekday`'s numbering and most
/// locale defaults would give you.
const List<String> kWeekdayLabels = <String>[
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// How many day cells the grid always has: 6 rows × 7 columns.
///
/// Always exactly 42 — the web pads both ends so the grid's height never jumps
/// between a 4-row February and a 6-row March. The phone needs that even more
/// than the desktop does, because a jumping grid re-lays-out the whole scroll
/// view under the user's thumb.
const int kMonthGridCells = 42;

/// The 42 dates of [month]'s grid, Monday-first, including the leading and
/// trailing days that belong to the neighbouring months.
///
/// Days are built as `DateTime(year, month, day + n)` rather than by adding a
/// `Duration`, exactly as the web does: a `Duration(days: 1)` is 24 hours, and
/// across a DST boundary 24 hours is not "the next day".
List<DateTime> buildMonthGrid(int year, int month) {
  final DateTime firstOfMonth = DateTime(year, month);
  // DateTime.weekday is Mon=1 … Sun=7; the grid wants Mon=0 … Sun=6.
  final int offset = firstOfMonth.weekday - 1;
  return <DateTime>[
    for (int i = 0; i < kMonthGridCells; i++)
      DateTime(year, month, 1 - offset + i),
  ];
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// Midnight at the start of [d], in local time.
DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// The stable `yyyy-MM-dd` key a day's posts are grouped under.
///
/// Local time, like the web — a post scheduled at 00:30 IST belongs to that
/// calendar day for the user looking at it, not to the previous UTC day.
String dayKey(DateTime date) {
  final String m = date.month.toString().padLeft(2, '0');
  final String d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

/// Groups posts by [dayKey], dropping any that have neither a scheduled nor a
/// published time — those are not on the calendar at all. Each day's list is
/// sorted earliest-first.
Map<String, List<CalendarPost>> groupByDay(List<CalendarPost> posts) {
  final Map<String, List<CalendarPost>> byDay = <String, List<CalendarPost>>{};
  for (final CalendarPost post in posts) {
    final DateTime? at = post.calendarDate;
    if (at == null) continue;
    byDay.putIfAbsent(dayKey(at), () => <CalendarPost>[]).add(post);
  }
  for (final List<CalendarPost> day in byDay.values) {
    day.sort((CalendarPost a, CalendarPost b) {
      final DateTime? x = a.calendarDate;
      final DateTime? y = b.calendarDate;
      if (x == null || y == null) return 0;
      return x.compareTo(y);
    });
  }
  return byDay;
}

/// The two lists the calendar screen renders.
///
/// A plain value class rather than a Freezed model: it is derived on the client
/// and never crosses the wire, so it needs neither `fromJson` nor `copyWith`.
class CalendarBuckets {
  const CalendarBuckets({
    this.scheduled = const <CalendarPost>[],
    this.pending = const <CalendarPost>[],
  });

  /// Everything that has a place on the grid.
  final List<CalendarPost> scheduled;

  /// The backlog — what the user can still put on a day.
  final List<CalendarPost> pending;

  bool get isEmpty => scheduled.isEmpty && pending.isEmpty;
}

/// Splits a flat post list the way the server's `getCalendarBuckets` does.
///
/// **This runs on the client only because it has to.** The web calls
/// `/api/calendar/posts`, which buckets server-side; the mobile API exposes no
/// equivalent, so `GET /posts` is bucketed here instead. The rule is copied
/// from `lib/services/calendar.service.ts` verbatim so the two surfaces agree:
///
///   • `scheduled` — `scheduled`, `approved`, `published`, `failed`, plus
///     `pending_approval` whose time is still in the FUTURE (so the day cell
///     can show that it needs approving before it goes).
///   • `pending` — `draft`, plus `pending_approval` whose time has already
///     lapsed. That second group is the "missed because nobody approved it"
///     case, and it is the reason the pending rail exists at all.
///
/// [now] is injectable so the boundary case (an approval lapsing) is testable.
CalendarBuckets splitCalendarBuckets(
  List<CalendarPost> posts, {
  DateTime? now,
}) {
  final DateTime at = now ?? DateTime.now();
  final List<CalendarPost> scheduled = <CalendarPost>[];
  final List<CalendarPost> pending = <CalendarPost>[];

  for (final CalendarPost post in posts) {
    final bool isPending = switch (post.status) {
      CalendarPostStatus.draft => true,
      CalendarPostStatus.pendingApproval =>
        !(post.scheduledFor?.isAfter(at) ?? false),
      _ => false,
    };
    if (isPending) {
      pending.add(post);
    } else {
      scheduled.add(post);
    }
  }

  return CalendarBuckets(scheduled: scheduled, pending: pending);
}

/// The default time for a post being placed on [day].
///
/// Ported exactly from `suggestTimeForDay`: prefer 09:00, then 12:00, 15:00,
/// 18:00 — the first of those not already taken; failing that the first free
/// 30-minute slot from 08:00 to 22:00; failing that 09:00 anyway.
///
/// The point is that the common case is ONE tap: the sheet opens already
/// pointing at a sensible free time.
DateTime suggestTimeForDay(DateTime day, List<DateTime> occupied) {
  final Set<int> taken = <int>{
    for (final DateTime t in occupied) t.hour * 60 + t.minute,
  };

  const List<int> preferred = <int>[9 * 60, 12 * 60, 15 * 60, 18 * 60];
  for (final int minutes in preferred) {
    if (!taken.contains(minutes)) return _at(day, minutes);
  }
  for (int m = 8 * 60; m < 22 * 60; m += 30) {
    if (!taken.contains(m)) return _at(day, m);
  }
  return _at(day, 9 * 60);
}

DateTime _at(DateTime day, int minutesFromMidnight) => DateTime(
  day.year,
  day.month,
  day.day,
  minutesFromMidnight ~/ 60,
  minutesFromMidnight % 60,
);

/// Trims [text] to [max] characters with an ellipsis, like the web's
/// `truncate`. Used for chip and row previews.
String truncate(String text, int max) {
  final String trimmed = text.trim();
  if (trimmed.length <= max) return trimmed;
  return '${trimmed.substring(0, max - 1).trimRight()}…';
}
