import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_entity.freezed.dart';

/// Lifecycle of a post. Wire values match the Dart enum names verbatim
/// (`draft` / `scheduled` / `published` / `failed`) — the same strings are
/// persisted in the Drift `posts.status` column and used in mock JSON.
enum PostStatus { draft, scheduled, published, failed }

extension PostStatusX on PostStatus {
  String get label => switch (this) {
        PostStatus.draft => 'Draft',
        PostStatus.scheduled => 'Scheduled',
        PostStatus.published => 'Published',
        PostStatus.failed => 'Failed',
      };

  /// Tolerant parse from the persisted/wire string; unknown -> draft.
  static PostStatus fromString(String s) => switch (s) {
        'scheduled' => PostStatus.scheduled,
        'published' => PostStatus.published,
        'failed' => PostStatus.failed,
        _ => PostStatus.draft,
      };
}

/// Engagement counters for a published post. Ported verbatim from the legacy
/// `lib/domain/entities/post_entity.dart`; the derived getters keep the same
/// formatting contract the UI relies on.
@freezed
abstract class PostMetricsEntity with _$PostMetricsEntity {
  const factory PostMetricsEntity({
    @Default(0) int impressions,
    @Default(0) int engagements,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int reposts,
  }) = _PostMetricsEntity;

  const PostMetricsEntity._();

  double get engagementRate =>
      impressions == 0 ? 0 : engagements / impressions * 100;

  String get impressionsFormatted => _formatCount(impressions);
  String get engagementsFormatted => _formatCount(engagements);

  static String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

/// A single post as surfaced to the UI. `id` is the local Drift row id
/// (auto-increment); `remoteId` is null for a local-only draft and set once
/// the post exists on the server. Ported verbatim from the layer-first
/// `lib/domain/entities/post_entity.dart` — the model and its derived getters
/// are Plexaverse product identity and are NOT redesigned (RULINGS).
@freezed
abstract class PostEntity with _$PostEntity {
  const factory PostEntity({
    required int id,
    String? remoteId,
    required String content,
    String? hookLine,
    @Default(PostStatus.draft) PostStatus status,
    @Default('linkedin') String platform,
    DateTime? scheduledAt,
    DateTime? publishedAt,
    String? errorMessage,
    PostMetricsEntity? metrics,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PostEntity;

  const PostEntity._();

  /// First line of content (for list previews).
  String get preview {
    if (hookLine != null && hookLine!.isNotEmpty) return hookLine!;
    final lines = content.split('\n');
    return lines.first.trim();
  }

  /// Initials derived from the first two words of the hook/content.
  String get initials {
    final words = preview.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words.isNotEmpty ? words[0][0].toUpperCase() : 'P';
  }
}
