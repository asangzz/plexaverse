// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConnectionTarget _$ConnectionTargetFromJson(Map<String, dynamic> json) =>
    _ConnectionTarget(
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      searchQuery: json['searchQuery'] as String? ?? '',
      linkedinSearchUrl: json['linkedinSearchUrl'] as String? ?? '',
      note: json['note'] as String? ?? '',
      isDirectMessage: json['isDirectMessage'] as bool? ?? false,
    );

Map<String, dynamic> _$ConnectionTargetToJson(_ConnectionTarget instance) =>
    <String, dynamic>{
      'role': instance.role,
      'company': instance.company,
      'searchQuery': instance.searchQuery,
      'linkedinSearchUrl': instance.linkedinSearchUrl,
      'note': instance.note,
      'isDirectMessage': instance.isDirectMessage,
    };

_ConnectionBatch _$ConnectionBatchFromJson(Map<String, dynamic> json) =>
    _ConnectionBatch(
      connections:
          (json['connections'] as List<dynamic>?)
              ?.map((e) => ConnectionTarget.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ConnectionTarget>[],
      profession: json['profession'] as String? ?? '',
      cached: json['cached'] as bool? ?? false,
      xpCost: (json['xpCost'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConnectionBatchToJson(_ConnectionBatch instance) =>
    <String, dynamic>{
      'connections': instance.connections.map((e) => e.toJson()).toList(),
      'profession': instance.profession,
      'cached': instance.cached,
      'xpCost': instance.xpCost,
    };
