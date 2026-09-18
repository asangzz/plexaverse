// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboxComment _$InboxCommentFromJson(Map<String, dynamic> json) =>
    _InboxComment(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      suggestedReply: json['suggestedReply'] as String? ?? '',
      suggestedReaction: json['suggestedReaction'] as String? ?? 'LIKE',
    );

Map<String, dynamic> _$InboxCommentToJson(_InboxComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt,
      'suggestedReply': instance.suggestedReply,
      'suggestedReaction': instance.suggestedReaction,
    };

_ReplyOutcome _$ReplyOutcomeFromJson(Map<String, dynamic> json) =>
    _ReplyOutcome(
      targetUrn: json['targetUrn'] as String,
      success: json['success'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ReplyOutcomeToJson(_ReplyOutcome instance) =>
    <String, dynamic>{
      'targetUrn': instance.targetUrn,
      'success': instance.success,
      'error': instance.error,
    };
