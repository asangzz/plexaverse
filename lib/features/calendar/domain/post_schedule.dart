import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_schedule.freezed.dart';
part 'post_schedule.g.dart';

/// Day names indexed the way the server indexes [PostSchedule.dayOfWeek]:
/// **0 = Sunday … 6 = Saturday**.
///
/// That is `Date.getDay()`'s numbering, not `DateTime.weekday`'s (Mon=1…Sun=7),
/// and the two are one apart for every day of the week. Mixing them up moves a
/// user's whole posting schedule by a day, silently, so the two numberings are
/// never converted implicitly: this list is the only place the wire numbering
/// is interpreted.
const List<String> kScheduleDayNames = <String>[
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

/// A topic, as the schedules screen needs it.
///
/// The server returns the whole `Topic` row (description, keywords, counts);
/// only the two fields the UI renders are decoded. Unknown JSON keys are
/// ignored, so this stays valid as the row grows.
@freezed
abstract class ScheduleTopic with _$ScheduleTopic {
  const factory ScheduleTopic({
    required String id,
    @Default('') String name,
  }) = _ScheduleTopic;

  factory ScheduleTopic.fromJson(Map<String, dynamic> json) =>
      _$ScheduleTopicFromJson(json);
}

/// A connected LinkedIn account, as the schedules screen needs it.
///
/// Decoded both from `GET /linkedin/accounts` and from the `linkedinAccount`
/// join on a schedule row — the join selects `{id, profileName}` only, which is
/// why everything past [profileName] carries a default.
@freezed
abstract class CalendarAccount with _$CalendarAccount {
  const CalendarAccount._();

  const factory CalendarAccount({
    required String id,
    @Default('') String profileName,

    /// `'personal'` or `'company'`. Absent on the schedule join.
    @Default('personal') String appType,

    /// The account's LinkedIn token is dead or nearly dead and the user has to
    /// re-authorise. Absent on the schedule join, so it defaults to false —
    /// never assume a reconnect is needed from missing data.
    @Default(false) bool needsReconnect,
  }) = _CalendarAccount;

  factory CalendarAccount.fromJson(Map<String, dynamic> json) =>
      _$CalendarAccountFromJson(json);

  /// Never render an empty account name — a nameless row reads as a bug.
  String get displayName =>
      profileName.trim().isEmpty ? 'LinkedIn account' : profileName.trim();
}

/// A recurring auto-post schedule — the `/schedules` screen's row.
///
/// This is **not** a scheduled post. It is the standing instruction "write and
/// publish something about topic X every weekday at 09:00", stored as
/// `PostSchedule` and fired by Cloud Tasks. The web page words it as
/// "Configure when AI generates your posts", and that wording is load-bearing:
/// users who read this screen as "my queue" go looking for their drafts here.
@freezed
abstract class PostSchedule with _$PostSchedule {
  const PostSchedule._();

  const factory PostSchedule({
    required String id,
    String? topicId,
    @Default('') String linkedinAccountId,

    /// Which days it fires, 0=Sunday … 6=Saturday.
    @Default(<int>[]) List<int> dayOfWeek,

    /// `HH:MM`, 24-hour. The server validates this shape and rejects anything
    /// else, so the UI only ever offers real slots.
    @Default('09:00') String timeOfDay,

    /// IANA zone. The server defaults to `Asia/Kolkata`.
    @Default('Asia/Kolkata') String timezone,

    @Default(true) bool isActive,
    ScheduleTopic? topic,
    CalendarAccount? linkedinAccount,
  }) = _PostSchedule;

  factory PostSchedule.fromJson(Map<String, dynamic> json) =>
      _$PostScheduleFromJson(json);

  /// The days, worded as the web's `formatDays` words them.
  ///
  /// "Every day" / "Weekdays" / "Weekends" / an explicit list — the shorthands
  /// are what make a list of schedules scannable, so they are ported exactly
  /// rather than approximated.
  String get daysLabel {
    final List<int> days =
        dayOfWeek.where((int d) => d >= 0 && d < kScheduleDayNames.length).toList()
          ..sort();
    if (days.isEmpty) return 'No days';
    if (days.length == 7) return 'Every day';
    if (days.length == 5 && days.every((int d) => d >= 1 && d <= 5)) {
      return 'Weekdays';
    }
    if (days.length == 2 && days.contains(0) && days.contains(6)) {
      return 'Weekends';
    }
    return days.map((int d) => kScheduleDayNames[d]).join(', ');
  }

  /// The account this schedule publishes to, or a placeholder if the join was
  /// not included.
  String get accountLabel =>
      linkedinAccount?.displayName ?? 'LinkedIn account';
}
