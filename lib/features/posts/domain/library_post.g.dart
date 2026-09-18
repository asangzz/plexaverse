// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostMetrics _$PostMetricsFromJson(Map<String, dynamic> json) => _PostMetrics(
  impressions: (json['impressions'] as num?)?.toInt() ?? 0,
  comments: (json['comments'] as num?)?.toInt() ?? 0,
  shares: (json['shares'] as num?)?.toInt() ?? 0,
  reactions: (json['reactions'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PostMetricsToJson(_PostMetrics instance) =>
    <String, dynamic>{
      'impressions': instance.impressions,
      'comments': instance.comments,
      'shares': instance.shares,
      'reactions': instance.reactions,
    };

_PostAuthor _$PostAuthorFromJson(Map<String, dynamic> json) => _PostAuthor(
  id: json['id'] as String,
  profileName: json['profileName'] as String?,
);

Map<String, dynamic> _$PostAuthorToJson(_PostAuthor instance) =>
    <String, dynamic>{'id': instance.id, 'profileName': instance.profileName};

_LibraryPost _$LibraryPostFromJson(Map<String, dynamic> json) => _LibraryPost(
  id: json['id'] as String,
  title: json['title'] as String?,
  content: json['content'] as String? ?? '',
  imageUrl: json['imageUrl'] as String?,
  imageThumbUrl: json['imageThumbUrl'] as String?,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(
        _$PostLibraryStatusEnumMap,
        json['status'],
        unknownValue: PostLibraryStatus.draft,
      ) ??
      PostLibraryStatus.draft,
  linkedinUrl: json['linkedinUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  scheduledFor: json['scheduledFor'] == null
      ? null
      : DateTime.parse(json['scheduledFor'] as String),
  metrics: json['metrics'] == null
      ? null
      : PostMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
  account: json['account'] == null
      ? null
      : PostAuthor.fromJson(json['account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LibraryPostToJson(_LibraryPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'imageThumbUrl': instance.imageThumbUrl,
      'imageUrls': instance.imageUrls,
      'status': _$PostLibraryStatusEnumMap[instance.status]!,
      'linkedinUrl': instance.linkedinUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'metrics': instance.metrics?.toJson(),
      'account': instance.account?.toJson(),
    };

const _$PostLibraryStatusEnumMap = {
  PostLibraryStatus.draft: 'draft',
  PostLibraryStatus.pendingApproval: 'pending_approval',
  PostLibraryStatus.approved: 'approved',
  PostLibraryStatus.scheduled: 'scheduled',
  PostLibraryStatus.published: 'published',
  PostLibraryStatus.rejected: 'rejected',
  PostLibraryStatus.failed: 'failed',
};
