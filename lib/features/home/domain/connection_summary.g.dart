// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConnectionReading _$ConnectionReadingFromJson(Map<String, dynamic> json) =>
    _ConnectionReading(
      count: (json['count'] as num?)?.toInt() ?? 0,
      measuredAt: json['measuredAt'] as String? ?? '',
    );

Map<String, dynamic> _$ConnectionReadingToJson(_ConnectionReading instance) =>
    <String, dynamic>{
      'count': instance.count,
      'measuredAt': instance.measuredAt,
    };

_ConnectionGrowth _$ConnectionGrowthFromJson(Map<String, dynamic> json) =>
    _ConnectionGrowth(
      week: (json['week'] as num?)?.toInt(),
      sinceFirst: (json['sinceFirst'] as num?)?.toInt() ?? 0,
      firstMeasuredAt: json['firstMeasuredAt'] as String? ?? '',
      daysCovered: (json['daysCovered'] as num?)?.toInt() ?? 0,
      readings: (json['readings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConnectionGrowthToJson(_ConnectionGrowth instance) =>
    <String, dynamic>{
      'week': instance.week,
      'sinceFirst': instance.sinceFirst,
      'firstMeasuredAt': instance.firstMeasuredAt,
      'daysCovered': instance.daysCovered,
      'readings': instance.readings,
    };

_ConnectionSummary _$ConnectionSummaryFromJson(Map<String, dynamic> json) =>
    _ConnectionSummary(
      reading: json['reading'] == null
          ? null
          : ConnectionReading.fromJson(json['reading'] as Map<String, dynamic>),
      growth: json['growth'] == null
          ? null
          : ConnectionGrowth.fromJson(json['growth'] as Map<String, dynamic>),
      history:
          (json['history'] as List<dynamic>?)
              ?.map(
                (e) => ConnectionReading.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ConnectionReading>[],
    );

Map<String, dynamic> _$ConnectionSummaryToJson(_ConnectionSummary instance) =>
    <String, dynamic>{
      'reading': instance.reading?.toJson(),
      'growth': instance.growth?.toJson(),
      'history': instance.history.map((e) => e.toJson()).toList(),
    };
