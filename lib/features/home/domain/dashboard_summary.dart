import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';
part 'dashboard_summary.g.dart';

/// `GET /home/dashboard` — everything the Home tab renders in one payload:
/// the gamification hero (streak + weekly XP + level), the four KPI tiles
/// (impressions / engagements / followers / scheduled with their period
/// deltas), and the recent-posts strip.
///
/// This is a self-contained Home DTO (like ProHealth's `DashboardSummary`)
/// rather than a composition of the posts/odyssey feature entities: it owns
/// its own `fromJson` so the Home slice deserialises the dashboard endpoint
/// (and the bundled mock) without depending on those features' wire models.
/// The old provider aggregated this client-side from the posts/odyssey
/// streams; the migrated dashboard is a single server-computed summary.
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required DashboardStats stats,
    @Default(0) int totalImpressions,
    @Default(0) int totalEngagements,
    @Default(0) int totalFollowers,
    @Default(0) int scheduledCount,
    @Default('+0%') String impressionsDelta,
    @Default('+0%') String engagementsDelta,
    @Default('+0%') String followersDelta,
    @Default(<DashboardPost>[]) List<DashboardPost> recentPosts,
    DashboardMission? mission,
  }) = _DashboardSummary;

  const DashboardSummary._();

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);

  /// First-time users have no posts and no accrued metrics yet — the page
  /// swaps the KPI/chart layout for an orientation view.
  bool get isFirstTime => recentPosts.isEmpty && totalImpressions == 0;
}

/// The gamification hero header: streak, weekly XP against goal, level.
@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0) int streakDays,
    @Default(0) int weeklyXp,
    @Default(2000) int weeklyXpGoal,
    @Default(1) int level,
    @Default('Beginner') String levelTitle,
  }) = _DashboardStats;

  const DashboardStats._();

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  /// Fraction [0..1] of the weekly XP goal reached (drives the hero bar).
  double get weeklyXpProgress =>
      weeklyXpGoal == 0 ? 0 : (weeklyXp / weeklyXpGoal).clamp(0.0, 1.0);
}

/// Publishing status of a post surfaced on the dashboard strip. Wire values
/// match the Dart names verbatim (see the posts feature `PostStatus`).
enum DashboardPostStatus { draft, scheduled, published, failed }

/// A recent-post summary as the dashboard renders it — just enough to draw
/// the compact card (preview line, status pill, headline metrics). The full
/// post model lives in the posts feature; the dashboard never needs it.
@freezed
abstract class DashboardPost with _$DashboardPost {
  const factory DashboardPost({
    required String id,
    required String preview,
    @Default(DashboardPostStatus.draft) DashboardPostStatus status,
    @Default(0) int impressions,
    @Default(0) int engagements,
    @Default(false) bool hasMetrics,
  }) = _DashboardPost;

  const DashboardPost._();

  factory DashboardPost.fromJson(Map<String, dynamic> json) =>
      _$DashboardPostFromJson(json);

  /// Two-letter avatar seed derived from the preview's first two words.
  String get initials {
    final words = preview.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words.isNotEmpty ? words.first[0].toUpperCase() : 'P';
  }
}

/// The optional "today's mission" banner (present only while a daily
/// challenge is active).
@freezed
abstract class DashboardMission with _$DashboardMission {
  const factory DashboardMission({
    required String title,
    @Default('Active') String statusLabel,
  }) = _DashboardMission;

  factory DashboardMission.fromJson(Map<String, dynamic> json) =>
      _$DashboardMissionFromJson(json);
}
