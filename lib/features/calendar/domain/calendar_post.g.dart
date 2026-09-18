// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarPost _$CalendarPostFromJson(Map<String, dynamic> json) =>
    _CalendarPost(
      id: json['id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      imageThumbUrl: json['imageThumbUrl'] as String?,
      status:
          $enumDecodeNullable(
            _$CalendarPostStatusEnumMap,
            json['status'],
            unknownValue: CalendarPostStatus.draft,
          ) ??
          CalendarPostStatus.draft,
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      linkedinUrl: json['linkedinUrl'] as String?,
      failureReason: json['failureReason'] as String?,
      failedAt: json['failedAt'] == null
          ? null
          : DateTime.parse(json['failedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CalendarPostToJson(_CalendarPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageThumbUrl': instance.imageThumbUrl,
      'status': _$CalendarPostStatusEnumMap[instance.status]!,
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'linkedinUrl': instance.linkedinUrl,
      'failureReason': instance.failureReason,
      'failedAt': instance.failedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$CalendarPostStatusEnumMap = {
  CalendarPostStatus.draft: 'draft',
  CalendarPostStatus.pendingApproval: 'pending_approval',
  CalendarPostStatus.approved: 'approved',
  CalendarPostStatus.scheduled: 'scheduled',
  CalendarPostStatus.published: 'published',
  CalendarPostStatus.failed: 'failed',
};
