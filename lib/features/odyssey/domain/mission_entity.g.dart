// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionEntity _$MissionEntityFromJson(Map<String, dynamic> json) =>
    _MissionEntity(
      id: (json['id'] as num).toInt(),
      missionKey: json['missionKey'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status:
          $enumDecodeNullable(_$MissionStatusEnumMap, json['status']) ??
          MissionStatus.locked,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 100,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MissionEntityToJson(_MissionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'missionKey': instance.missionKey,
      'title': instance.title,
      'description': instance.description,
      'status': _$MissionStatusEnumMap[instance.status]!,
      'xpReward': instance.xpReward,
      'progress': instance.progress,
      'total': instance.total,
      'sortOrder': instance.sortOrder,
    };

const _$MissionStatusEnumMap = {
  MissionStatus.done: 'done',
  MissionStatus.active: 'active',
  MissionStatus.next: 'next',
  MissionStatus.locked: 'locked',
};
