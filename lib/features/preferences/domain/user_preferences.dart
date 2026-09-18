import 'package:freezed_annotation/freezed_annotation.dart';

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
///   • [currentSeason] selects the home screen: 1 → the 66-day planet roadmap,
///     2 → the Season 2 dashboard. It flips server-side at roadmap day 66.
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

    @Default('slack') String approvalChannel,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  /// The state of a user the server has never seen. Distinct from "loading":
  /// this one routes to onboarding.
  static const UserPreferences empty = UserPreferences();

  /// True when this user runs a company brand.
  bool get isCompany => brandType == 'company';

  /// True once the roadmap has advanced past Season 1's 66 days. Selects the
  /// Season 2 dashboard over the planet roadmap.
  bool get isSeason2 => currentSeason >= 2;

  /// Maintenance mode — the reduced cadence. The Sunday article still
  /// generates; only the weekday post slots shrink.
  bool get isMaintenance => postsPerWeek <= 3;
}
