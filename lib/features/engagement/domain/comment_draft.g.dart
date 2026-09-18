// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentDraft _$CommentDraftFromJson(Map<String, dynamic> json) =>
    _CommentDraft(
      comment: json['comment'] as String? ?? '',
      targetPostTitle: json['targetPostTitle'] as String? ?? '',
      searchKeywords: json['searchKeywords'] as String? ?? '',
    );

Map<String, dynamic> _$CommentDraftToJson(_CommentDraft instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'targetPostTitle': instance.targetPostTitle,
      'searchKeywords': instance.searchKeywords,
    };

_CommentBatch _$CommentBatchFromJson(Map<String, dynamic> json) =>
    _CommentBatch(
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentDraft.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentDraft>[],
      topic: json['topic'] as String? ?? '',
      cached: json['cached'] as bool? ?? false,
      xpCost: (json['xpCost'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommentBatchToJson(_CommentBatch instance) =>
    <String, dynamic>{
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'topic': instance.topic,
      'cached': instance.cached,
      'xpCost': instance.xpCost,
    };
