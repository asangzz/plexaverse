import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home/domain/roadmap_planets.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// The signed-in user's preferences — the keystone state the whole app
/// branches on, mirroring the web's `useUserPreferences()` hook.
///
/// Three fields here decide what the app even looks like:
///
///   • [onboardingCompleted] gates the dashboard. False → the onboarding chat.
///   • [brandType] selects personal vs company navigation and the compose
///     screen (`/create` vs `/company-post`).
///   • [roadmapStartedAt] and [journeyCompletedAt] place the user on the
///     1000-day journey, and say when it is finished (see [journeyFinished]).
///
/// [currentSeason] is NOT a season any more. The server keeps the column as the
/// JOURNEY NUMBER — the key that stops journey 2's week 1 colliding with
/// journey 1's — and nothing user-visible may call it a season. Read it
/// through [journeyNumber].
///
/// `GET /api/mobile/v1/user/preferences` returns the whole Prisma row (60+
/// columns) plus `approvalChannel`. This models the subset the mobile UI
/// reads; json_serializable ignores the rest, so the server can add columns
/// without breaking the client. Every field is optional or defaulted for the
/// same reason.
///
/// The endpoint also answers `{ exists: false, onboardingCompleted: false }`
/// when the user has no row yet — [exists] is that sentinel, not a column.
@freezed
abstract class UserPreferences with _$UserPreferences {
  const UserPreferences._();

  const factory UserPreferences({
    /// False when the server has no preferences row for this user yet. A
    /// brand-new account, so onboarding has not started.
    @Default(false) bool exists,
    @Default(false) bool onboardingCompleted,

    /// `'personal'` | `'company'`. Defaulted rather than nullable because the
    /// server column defaults to `'personal'`.
    @Default('personal') String? brandType,
    @Default(1) int currentSeason,
    DateTime? roadmapStartedAt,
    DateTime? seasonStartedAt,

    // ── Cadence ──
    @Default(7) int postsPerWeek,
    @Default(<int>[1, 3, 5]) List<int> preferredDays,
    @Default('09:00') String preferredTime,
    @Default('Asia/Kolkata') String timezone,
    @Default(true) bool autoPostEnabled,

    // ── Voice / strategy ──
    @Default('professional') String contentStyle,
    @Default('authority') String contentMode,
    String? priority,
    String? targetRole,
    String? profession,
    String? industry,
    String? headline,
    String? summary,
    @Default(<String>[]) List<String> goals,
    @Default(<String>[]) List<String> postCategories,
    @Default(<String>[]) List<String> skills,

    /// Self-reported; nothing syncs it because nothing can. Null means "no
    /// newsletter yet", which is what triggers the first-article naming flow.
    /// The consultant-practice audience fields. Real preferences columns that
    /// the mobile PATCH accepts, and what the persona screen's audience
    /// section reads and writes.
    String? serveRole,
    String? serveIndustry,
    String? problemSolved,

    String? newsletterName,

    // ── Company brand (all null for a personal brand) ──
    String? companyPageId,
    String? companyPageName,
    String? companyDescription,
    String? companyIndustry,
    String? companyTagline,
    String? companyLogoUrl,
    String? companyWebsite,
    @Default(<String>[]) List<String> companyFeatures,

    /// Poster style. The server composites with these, so the defaults here
    /// match its own rather than Zave's palette — changing them would
    /// silently restyle every poster generated from the app.
    @Default('dark') String posterTheme,
    String? posterPrimaryColor,
    String? posterSecondaryColor,

    @Default('slack') String approvalChannel,
  }) = _UserPreferences;

  /// Built from the raw row so [journeyCompletedAt] can be read off it.
  ///
  /// It MUST stay an expression body that calls `_$UserPreferencesFromJson`:
  /// freezed only generates JSON support (and `toJson`) when the `fromJson`
  /// factory is an `=>` expression. A block body silently drops the whole
  /// `.g.dart` at the next build_runner run.
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _withJourneyEnd(_$UserPreferencesFromJson(json), json);

  /// Parks the raw `journeyCompletedAt` on [preferences]. See
  /// [journeyCompletedAt] for why it is not (yet) a freezed field.
  static UserPreferences _withJourneyEnd(
    UserPreferences preferences,
    Map<String, dynamic> json,
  ) {
    final Object? completed = json['journeyCompletedAt'];
    if (completed is String) {
      final DateTime? at = DateTime.tryParse(completed);
      if (at != null) _journeyCompletedAt[preferences] = at;
    }
    return preferences;
  }

  /// Side table for [journeyCompletedAt]. Expando entries die with the object,
  /// so this cannot leak preferences rows.
  static final Expando<DateTime> _journeyCompletedAt = Expando<DateTime>(
    'journeyCompletedAt',
  );

  /// The state of a user the server has never seen. Distinct from "loading":
  /// this one routes to onboarding.
  static const UserPreferences empty = UserPreferences();

  /// True when this user runs a company brand.
  bool get isCompany => brandType == 'company';

  /// When the server stamped day 1000 — the journey's finish line — or null
  /// while the journey is still running. Cleared by starting a new journey.
  ///
  /// **Interim: read off the raw JSON, not a freezed field.** Adding the field
  /// to the factory needs a build_runner pass, and this change could not run
  /// one. So [UserPreferences.fromJson] parks the value in an [Expando] keyed
  /// on the instance. Two known gaps, both covered by [journeyFinished]'s
  /// day fallback (the server stamps at day 1000, which is when the fallback
  /// fires anyway): a `copyWith` copy does not carry it, and it takes no part
  /// in `==`. Once the field is generated, move it into the factory as
  /// `DateTime? journeyCompletedAt` and delete the Expando.
  DateTime? get journeyCompletedAt => _journeyCompletedAt[this];

  /// Which journey this is, 1-based. [currentSeason] under its real meaning;
  /// clamped because a 0 from a malformed row would read as "journey 0".
  int get journeyNumber => currentSeason < 1 ? 1 : currentSeason;

  /// Day of the current journey, 1-indexed, capped at [roadmapTotalDays].
  ///
  /// A port of `getRoadmapDay` in the web's lib/narrative-phases.ts: the start
  /// day IS day 1, and no start date reads as day 1.
  int get journeyDay {
    final DateTime? started = roadmapStartedAt;
    if (started == null) return 1;
    final int day = DateTime.now().difference(started).inDays + 1;
    return day.clamp(1, roadmapTotalDays);
  }

  /// True once this journey has reached its finish line, day 1000.
  ///
  /// [journeyCompletedAt] is the server's answer, but the server only stamps
  /// it from the auto-post chain or a web dashboard visit. A user with
  /// auto-post off who only uses the app would never be stamped, so the day
  /// count is a fallback — the same one `startNewJourney` accepts on the
  /// server, so the start the finish screen offers will not be refused.
  ///
  /// This replaces `isSeason2` / `seasonOneFinished`. There is no second mode
  /// any more: a finished journey still shows the normal journey home, and a
  /// user on journey 2+ is simply at their own roadmap day.
  bool get journeyFinished =>
      journeyCompletedAt != null ||
      (roadmapStartedAt != null && journeyDay >= roadmapTotalDays);

  // `isMaintenance` lived here — `postsPerWeek <= 3` — with a doc saying the
  // post slots shrink. It had no callers, and the claim stopped being true at
  // the pivot: the kept set is `postingDays().slice(0, 3)` and the week has
  // two post days, so a cap of three blanks nothing. A dead getter is cheap;
  // a dead getter that asserts something false is what the next person reads
  // and believes. If maintenance needs a client-side notion again, derive it
  // from the week shape rather than from a number that no longer implies it.
}
