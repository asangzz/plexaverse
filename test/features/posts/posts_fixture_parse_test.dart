import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/posts/domain/post_entity.dart';

/// Fixture-parse guard for the posts mock payload.
///
/// `PostEntity` is a plain freezed model with no generated `fromJson` (it is
/// normally hydrated from Drift rows via `_mapRow`). The mock flavor's
/// `assets/mock/posts/posts.json` documents the wire payload shape, so this
/// test maps each fixture entry into `PostEntity`/`PostMetricsEntity` using the
/// SAME camelCase keys the regenerated code path expects (Dart field names
/// as-is: `hookLine`, `scheduledAt`, `publishedAt`, `errorMessage`,
/// `remoteId`, `createdAt`, `updatedAt`) and asserts every row hydrates.
PostMetricsEntity _metricsFromJson(Map<String, dynamic> j) => PostMetricsEntity(
      impressions: j['impressions'] as int? ?? 0,
      engagements: j['engagements'] as int? ?? 0,
      likes: j['likes'] as int? ?? 0,
      comments: j['comments'] as int? ?? 0,
      reposts: j['reposts'] as int? ?? 0,
    );

PostEntity _postFromJson(Map<String, dynamic> j) => PostEntity(
      id: j['id'] as int,
      remoteId: j['remoteId'] as String?,
      content: j['content'] as String,
      hookLine: j['hookLine'] as String?,
      status: PostStatusX.fromString(j['status'] as String),
      platform: j['platform'] as String? ?? 'linkedin',
      scheduledAt: j['scheduledAt'] == null
          ? null
          : DateTime.parse(j['scheduledAt'] as String),
      publishedAt: j['publishedAt'] == null
          ? null
          : DateTime.parse(j['publishedAt'] as String),
      errorMessage: j['errorMessage'] as String?,
      metrics: j['metrics'] == null
          ? null
          : _metricsFromJson(j['metrics'] as Map<String, dynamic>),
      createdAt: DateTime.parse(j['createdAt'] as String),
      updatedAt: DateTime.parse(j['updatedAt'] as String),
    );

void main() {
  test('posts.json fixture parses through PostEntity', () {
    final raw =
        File('assets/mock/posts/posts.json').readAsStringSync();
    final list = jsonDecode(raw) as List<dynamic>;

    final posts = list
        .map((e) => _postFromJson(e as Map<String, dynamic>))
        .toList();

    expect(posts, isNotEmpty);
    expect(posts.length, list.length);

    // Spot-check the camelCase-sensitive fields survived the mapping.
    final published =
        posts.firstWhere((p) => p.status == PostStatus.published);
    expect(published.remoteId, isNotNull);
    expect(published.hookLine, isNotNull);
    expect(published.publishedAt, isNotNull);
    expect(published.metrics, isNotNull);
    expect(published.metrics!.impressions, greaterThan(0));
    expect(published.createdAt, isA<DateTime>());
    expect(published.updatedAt, isA<DateTime>());

    final scheduled =
        posts.firstWhere((p) => p.status == PostStatus.scheduled);
    expect(scheduled.scheduledAt, isNotNull);
    expect(scheduled.remoteId, isNull);
    expect(scheduled.metrics, isNull);

    // Every row must carry the required non-null fields.
    for (final p in posts) {
      expect(p.content, isNotEmpty);
      expect(p.errorMessage, isNull);
    }
  });
}
