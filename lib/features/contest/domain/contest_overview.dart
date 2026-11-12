import 'package:freezed_annotation/freezed_annotation.dart';

part 'contest_overview.freezed.dart';
part 'contest_overview.g.dart';

/// Where the contest is in its life. Mirrors `ContestPhase` in the web's
/// `lib/contest.ts`.
///
/// An unknown phase reads as [upcoming]: the one state in which the page
/// opens no path and no lesson, and joining — idempotent and free — is the
/// most it offers. Reading it as [running] would draw a path the server
/// never sent.
enum ContestPhase { upcoming, running, ended }

/// The contest itself, as `GET /contest` describes it. Mirrors
/// `ContestOverview['contest']` in the web's `lib/services/contest.service.ts`.
@freezed
abstract class ContestInfo with _$ContestInfo {
  const factory ContestInfo({
    @Default('') String id,

    /// Admin-set, and editable while the contest runs.
    @Default('') String title,

    /// What first place wins. Editable at any time, so never cached locally.
    @Default('') String prizeTitle,

    /// An admin-pasted URL on any host.
    String? prizeImageUrl,

    /// The first instant. Show [firstDayKey], not this.
    required DateTime startsAt,

    /// The EXCLUSIVE end — midnight after the last day. Formatted through a
    /// viewer's clock it reads one day long, and in another timezone a day
    /// off; show [lastDayKey] for the window. The web's "Results on" and
    /// "Winner announced" lines are the one place it is read, as a date.
    required DateTime endsAt,

    /// The first and last playable day, `YYYY-MM-DD` in the contest's
    /// timezone. What the window is shown as: read with `dayKeyDate`, never
    /// through the device's timezone.
    @Default('') String firstDayKey,
    @Default('') String lastDayKey,

    /// How many finishers get plan time, and how many months each.
    @Default(10) int rewardTopN,
    @Default(3) int rewardMonths,

    /// Scoring days before a plan is needed, counted from the join day.
    @Default(30) int freeDays,

    /// The week-complete bonus (`rules.weekComplete`). Absent from an older
    /// server, and then the join card leaves its rule out.
    int? weekComplete,
  }) = _ContestInfo;

  factory ContestInfo.fromJson(Map<String, dynamic> json) =>
      _$ContestInfoFromJson(json);
}

/// When entrants may see the board. Mirrors `BoardReveal`.
///
/// The SERVER decides this — the last ten days, and the final standings
/// once it has ended — and enforces it: before the reveal the board route
/// sends no rows and the overview no rank. Nothing here recomputes it.
@freezed
abstract class BoardReveal with _$BoardReveal {
  const factory BoardReveal({
    @Default(false) bool revealed,

    /// The day it opens, `YYYY-MM-DD` in the contest's timezone. Empty when
    /// there is no contest to reveal.
    @Default('') String revealsOn,

    /// That day's contest day number.
    @Default(1) int revealDay,
  }) = _BoardReveal;

  factory BoardReveal.fromJson(Map<String, dynamic> json) =>
      _$BoardRevealFromJson(json);
}

/// The caller's own entry. Mirrors `ContestOverview['entry']`.
@freezed
abstract class ContestEntryView with _$ContestEntryView {
  const ContestEntryView._();

  const factory ContestEntryView({
    required DateTime joinedAt,

    /// The placement band at join (`A1`…`C2`). A label on the board; it
    /// prices nothing — each lesson is multiplied by its own day's band.
    @Default('B2') String level,

    /// Contest XP. Never below zero: the server clamps every penalty.
    @Default(0) int total,

    /// Null until the board opens. A rank is a comparison with everyone
    /// else, and before the reveal the server does not even compute one.
    int? rank,

    /// The daily lesson streak, live on the contest's clock: 0 once a day
    /// went by without the lesson. Read, never derived.
    @Default(0) int streak,
    @Default(0) int bestStreak,

    /// First-attempt counts on the questions written for this learner — the
    /// tie-break's accuracy.
    @Default(0) int correctCount,
    @Default(0) int wrongCount,

    /// Whole free scoring days left.
    @Default(0) int freeDaysLeft,

    /// The free period is over and there is no live plan: contest XP has
    /// stopped. Lessons and tasks still work; they record and pay nothing.
    @Default(false) bool scoringPaused,
  }) = _ContestEntryView;

  factory ContestEntryView.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryViewFromJson(json);
}

/// Everything the contest page needs for one user, in one read.
/// `GET /contest` → `{overview}`, where null means no contest is running,
/// ended in the last week, or scheduled.
///
/// Mirrors `ContestOverview` in the web's `lib/services/contest.service.ts`.
@freezed
abstract class ContestOverview with _$ContestOverview {
  const ContestOverview._();

  const factory ContestOverview({
    required ContestInfo contest,
    @JsonKey(unknownEnumValue: ContestPhase.upcoming)
    @Default(ContestPhase.upcoming)
    ContestPhase phase,

    /// Today's contest day, on the contest's clock; day 1 is the start date.
    /// At or below zero before it starts, past the last day once it ended.
    @Default(0) int dayNumber,

    /// Start to end, in days. **Never rendered**: the contest is shown by its
    /// dates and its day count, never by its length — no "of N", no "N-day
    /// contest" (the web's no-branding rule, guarded on both platforms).
    @Default(0) int lengthDays,
    @Default(BoardReveal()) BoardReveal board,

    /// Null when the caller has not joined.
    ContestEntryView? entry,

    /// How many are taking part. Shown before the reveal too: it names and
    /// ranks nobody.
    @Default(0) int entrants,
  }) = _ContestOverview;

  factory ContestOverview.fromJson(Map<String, dynamic> json) =>
      _$ContestOverviewFromJson(json);

  bool get isEntrant => entry != null;
  bool get isRunning => phase == ContestPhase.running;
  bool get isEnded => phase == ContestPhase.ended;
}
