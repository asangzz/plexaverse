// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
  id: json['id'] as String,
  name: json['name'] as String? ?? '',
  description: json['description'] as String?,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] as String?,
  scheduleCount:
      (_readScheduleCount(json, 'scheduleCount') as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'keywords': instance.keywords,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'scheduleCount': instance.scheduleCount,
};

_SuggestedTopic _$SuggestedTopicFromJson(Map<String, dynamic> json) =>
    _SuggestedTopic(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SuggestedTopicToJson(_SuggestedTopic instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'keywords': instance.keywords,
    };
