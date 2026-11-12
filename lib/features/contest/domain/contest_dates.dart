/// Dates as the contest shows them.
///
/// ## Two kinds of date, and the one rule
///
/// A DAY KEY (`YYYY-MM-DD`: `firstDayKey`, `dayKey`, `revealsOn`,
/// `opensOnKey`) is a calendar date the server already worked out in the
/// contest's timezone — or, for planner days, the user's. It is read as a
/// calendar date and formatted as one: [dayKeyDate] gives a UTC midnight and
/// the formatters print its fields as they stand. Never `toLocal()` a day
/// key; west of Greenwich that turns 15 Feb into 14 Feb.
///
/// An INSTANT (`startsAt`, `endsAt`, `joinedAt`) is a moment, and the web
/// formats it on the viewer's clock — so the caller passes `toLocal()`.
///
/// Nothing here computes a day key from the device's clock. The contest's
/// "today" is the server's.
library;

/// A day key as its calendar date, at UTC midnight. Null for anything that
/// is not `YYYY-MM-DD`.
DateTime? dayKeyDate(String? key) {
  if (key == null) return null;
  final RegExpMatch? m = _dayKey.firstMatch(key.trim());
  if (m == null) return null;
  final int y = int.parse(m.group(1)!);
  final int mo = int.parse(m.group(2)!);
  final int d = int.parse(m.group(3)!);
  if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
  final DateTime date = DateTime.utc(y, mo, d);
  // 31 Feb rolls over into March; a key that does not name a real day is
  // not one.
  if (date.month != mo || date.day != d) return null;
  return date;
}

final RegExp _dayKey = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

// Spelt by hand, as the web's `dayKeyLabel` and the server's `planDateLabel`
// are, rather than through `DateFormat`: the phone's locale must not change a
// date the server's own sentences spell in English, and nothing in this app
// guarantees `initializeDateFormatting` has run.

/// "15 Feb 2027" — the window, the prize date, "Results on".
///
/// Prints [date]'s fields as given: pass a [dayKeyDate] unchanged, an
/// instant `toLocal()`.
String shortDate(DateTime date) =>
    '${date.day} ${_monthShort[date.month - 1]} ${date.year}';

/// "Saturday, 20 February" — the web's `dayKeyLabel`, as the board's reveal
/// line says it.
String longDate(DateTime date) =>
    '${_weekdayLong[date.weekday % 7]}, ${date.day} ${_monthLong[date.month - 1]}';

/// "Wednesday, 18 Nov" — the server's `planDateLabel`, for a planner day.
String planDate(DateTime date) =>
    '${_weekdayLong[date.weekday % 7]}, ${date.day} ${_monthShort[date.month - 1]}';

const List<String> _weekdayLong = <String>[
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

const List<String> _monthShort = <String>[
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

const List<String> _monthLong = <String>[
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

/// [shortDate] of a day key; empty when the key is not one.
String dayKeyShort(String? key) {
  final DateTime? d = dayKeyDate(key);
  return d == null ? '' : shortDate(d);
}

/// [longDate] of a day key; empty when the key is not one.
String dayKeyLong(String? key) {
  final DateTime? d = dayKeyDate(key);
  return d == null ? '' : longDate(d);
}

/// The weekday of a day key, 0 = Sunday … 6 = Saturday (the wire's own
/// numbering), read as a calendar date. Null when the key is not one.
int? weekdayOfKey(String? key) {
  final DateTime? d = dayKeyDate(key);
  // DateTime counts Monday 1 … Sunday 7.
  return d == null ? null : d.weekday % 7;
}

/// 0 = Sunday … 6 = Saturday, as the wire's `weekday`.
const List<String> kWeekdayShort = <String>[
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];
