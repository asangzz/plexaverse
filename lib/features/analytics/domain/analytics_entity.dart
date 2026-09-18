import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_entity.freezed.dart';
part 'analytics_entity.g.dart';

/// The best-performing post in the reporting period (WF — Analytics
/// "Top Post This Week" card).
///
/// Ported verbatim from `lib/domain/entities/analytics_entity.dart`; a
/// `fromJson`/`toJson` pair was added so the mock fixtures and the real
/// `/analytics` payload deserialise through the same model (feature-slice
/// convention: repositories parse through the real `fromJson`).
@freezed
abstract class TopPostSummary with _$TopPostSummary {
  const factory TopPostSummary({
    required int postId,
    required String preview,
    @Default(0) int impressions,
    @Default(0) int engagements,
    @Default(0.0) double engagementRate,
  }) = _TopPostSummary;

  factory TopPostSummary.fromJson(Map<String, dynamic> json) =>
      _$TopPostSummaryFromJson(json);
}

/// Aggregated analytics for the selected reporting period — the single
/// object the Analytics tab renders (hero impressions, sub-metrics, chart
/// series, top post, best-times bars).
///
/// Ported from `lib/domain/entities/analytics_entity.dart` with the
/// derived-label getters kept intact and JSON (de)serialisation added.
/// `impressionSeries` is pre-normalised (0–1) chart data; `weekdayImpressions`
/// is raw impressions indexed Mon(0)–Sun(6).
@freezed
abstract class AnalyticsEntity with _$AnalyticsEntity {
  const factory AnalyticsEntity({
    // Hero metric
    @Default(0) int totalImpressions,
    @Default(0) int totalEngagements,
    @Default(0) int totalFollowers,
    // Period-over-period deltas (percentage points)
    @Default(0.0) double impressionsDelta,
    @Default(0.0) double engagementsDelta,
    @Default(0.0) double followersDelta,
    // Sub-metrics
    @Default(0) int reactions,
    @Default(0) int comments,
    @Default(0) int reposts,
    @Default(0.0) double reactionsDelta,
    @Default(0.0) double commentsDelta,
    @Default(0.0) double repostsDelta,
    // Chart: normalized 0-1 values for the selected time range
    @Default(<double>[]) List<double> impressionSeries,
    // Best post in the period
    TopPostSummary? topPost,
    // Impressions by weekday Mon-Sun (index 0=Mon)
    @Default(<int>[0, 0, 0, 0, 0, 0, 0]) List<int> weekdayImpressions,
  }) = _AnalyticsEntity;

  const AnalyticsEntity._();

  factory AnalyticsEntity.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEntityFromJson(json);

  String get impressionsDeltaLabel =>
      '${impressionsDelta >= 0 ? '+' : ''}${impressionsDelta.toStringAsFixed(0)}%';

  String get formattedImpressions => _format(totalImpressions);
  String get formattedEngagements => _format(totalEngagements);
  String get formattedFollowers => _format(totalFollowers);

  static String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
