import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/analytics/domain/analytics_entity.dart';

/// Verifies the mock fixture `assets/mock/analytics/analytics.json` parses
/// cleanly through the regenerated (camelCase) `AnalyticsEntity.fromJson`.
///
/// Guards against a regression to snake_case keys, which would silently fall
/// back to the model's `@Default` values instead of throwing.
void main() {
  final file = File('assets/mock/analytics/analytics.json');

  test('fixture exists', () {
    expect(file.existsSync(), isTrue,
        reason: 'expected fixture at ${file.path}');
  });

  test('AnalyticsEntity.fromJson parses the fixture with real sample values',
      () {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final entity = AnalyticsEntity.fromJson(json);

    // Hero metrics.
    expect(entity.totalImpressions, 48200);
    expect(entity.totalEngagements, 3140);
    expect(entity.totalFollowers, 1820);

    // Deltas.
    expect(entity.impressionsDelta, 21.9);
    expect(entity.engagementsDelta, 14.0);
    expect(entity.followersDelta, 6.5);

    // Sub-metrics.
    expect(entity.reactions, 1980);
    expect(entity.comments, 742);
    expect(entity.reposts, 418);
    expect(entity.reactionsDelta, 22.0);
    expect(entity.commentsDelta, 8.0);
    expect(entity.repostsDelta, 31.0);

    // Chart series.
    expect(entity.impressionSeries,
        [0.32, 0.58, 0.47, 0.81, 0.69, 1.0, 0.74]);
    expect(entity.weekdayImpressions,
        [5200, 7100, 6400, 9800, 8300, 6900, 4500]);

    // Nested top post (respects TopPostSummary.fromJson).
    expect(entity.topPost, isNotNull);
    expect(entity.topPost!.postId, 4821);
    expect(entity.topPost!.impressions, 12400);
    expect(entity.topPost!.engagements, 1180);
    expect(entity.topPost!.engagementRate, 0.0952);
    expect(entity.topPost!.preview, contains('LinkedIn'));
  });

  test('fixture keys are camelCase (no snake_case regression)', () {
    final raw = file.readAsStringSync();
    for (final badKey in const [
      'total_impressions',
      'impressions_delta',
      'impression_series',
      'weekday_impressions',
      'top_post',
      'post_id',
      'engagement_rate',
    ]) {
      expect(raw.contains('"$badKey"'), isFalse,
          reason: 'snake_case key "$badKey" must not appear in fixture');
    }
  });
}
