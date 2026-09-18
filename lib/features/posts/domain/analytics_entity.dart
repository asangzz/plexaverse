import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_entity.freezed.dart';

/// The single best-performing post in the analytics period.
@freezed
abstract class TopPostSummary with _$TopPostSummary {
  const factory TopPostSummary({
    required int postId,
    required String preview,
    @Default(0) int impressions,
    @Default(0) int engagements,
    @Default(0.0) double engagementRate,
  }) = _TopPostSummary;
}

/// Aggregate analytics for the creator dashboard / analytics tab. Ported
/// verbatim from the layer-first `lib/domain/entities/analytics_entity.dart`.
/// Produced by [PostsRepository.fetchAnalytics] (local aggregation for now;
/// the API repository swaps in the remote metrics endpoint later). Kept in
/// the posts domain because the posts repository is its producer — the
/// analytics feature imports it from here.
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
    @Default([]) List<double> impressionSeries,
    // Best post in the period
    TopPostSummary? topPost,
    // Impressions by weekday Mon-Sun (index 0=Mon)
    @Default([0, 0, 0, 0, 0, 0, 0]) List<int> weekdayImpressions,
  }) = _AnalyticsEntity;

  const AnalyticsEntity._();

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
