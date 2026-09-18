// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleTopic _$ScheduleTopicFromJson(Map<String, dynamic> json) =>
    _ScheduleTopic(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$ScheduleTopicToJson(_ScheduleTopic instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_CalendarAccount _$CalendarAccountFromJson(Map<String, dynamic> json) =>
    _CalendarAccount(
      id: json['id'] as String,
      profileName: json['profileName'] as String? ?? '',
      appType: json['appType'] as String? ?? 'personal',
      needsReconnect: json['needsReconnect'] as bool? ?? false,
    );

Map<String, dynamic> _$CalendarAccountToJson(_CalendarAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileName': instance.profileName,
      'appType': instance.appType,
      'needsReconnect': instance.needsReconnect,
    };

_PostSchedule _$PostScheduleFromJson(Map<String, dynamic> json) =>
    _PostSchedule(
      id: json['id'] as String,
      topicId: json['topicId'] as String?,
      linkedinAccountId: json['linkedinAccountId'] as String? ?? '',
      dayOfWeek:
          (json['dayOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      timeOfDay: json['timeOfDay'] as String? ?? '09:00',
      timezone: json['timezone'] as String? ?? 'Asia/Kolkata',
      isActive: json['isActive'] as bool? ?? true,
      topic: json['topic'] == null
          ? null
          : ScheduleTopic.fromJson(json['topic'] as Map<String, dynamic>),
      linkedinAccount: json['linkedinAccount'] == null
          ? null
          : CalendarAccount.fromJson(
              json['linkedinAccount'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PostScheduleToJson(_PostSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'linkedinAccountId': instance.linkedinAccountId,
      'dayOfWeek': instance.dayOfWeek,
      'timeOfDay': instance.timeOfDay,
      'timezone': instance.timezone,
      'isActive': instance.isActive,
      'topic': instance.topic?.toJson(),
      'linkedinAccount': instance.linkedinAccount?.toJson(),
    };
