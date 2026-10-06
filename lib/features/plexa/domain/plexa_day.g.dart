// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plexa_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlexaComment _$PlexaCommentFromJson(Map<String, dynamic> json) =>
    _PlexaComment(
      id: json['id'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      searchKeywords: json['searchKeywords'] as String? ?? '',
      targetPostTitle: json['targetPostTitle'] as String? ?? '',
    );

Map<String, dynamic> _$PlexaCommentToJson(_PlexaComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'searchKeywords': instance.searchKeywords,
      'targetPostTitle': instance.targetPostTitle,
    };

_PlexaConnection _$PlexaConnectionFromJson(Map<String, dynamic> json) =>
    _PlexaConnection(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      note: json['note'] as String? ?? '',
      searchUrl: json['searchUrl'] as String? ?? '',
      isDirectMessage: json['isDirectMessage'] as bool? ?? false,
    );

Map<String, dynamic> _$PlexaConnectionToJson(_PlexaConnection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'company': instance.company,
      'note': instance.note,
      'searchUrl': instance.searchUrl,
      'isDirectMessage': instance.isDirectMessage,
    };

_PlexaTopVoice _$PlexaTopVoiceFromJson(Map<String, dynamic> json) =>
    _PlexaTopVoice(
      id: json['id'] as String? ?? '',
      postUrl: json['postUrl'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      firstLine: json['firstLine'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      actedAt: json['actedAt'] as String?,
    );

Map<String, dynamic> _$PlexaTopVoiceToJson(_PlexaTopVoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postUrl': instance.postUrl,
      'authorName': instance.authorName,
      'firstLine': instance.firstLine,
      'comment': instance.comment,
      'actedAt': instance.actedAt,
    };
