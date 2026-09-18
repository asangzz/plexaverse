// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoadmapProgress _$RoadmapProgressFromJson(Map<String, dynamic> json) =>
    _RoadmapProgress(
      currentDay: (json['currentDay'] as num?)?.toInt() ?? 1,
      completedSteps:
          (json['completedSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      roadmapStartedAt: json['roadmapStartedAt'] == null
          ? null
          : DateTime.parse(json['roadmapStartedAt'] as String),
      brandType: json['brandType'] as String? ?? 'personal',
      pendingPostIdToday: json['pendingPostIdToday'] as String?,
      scheduledPostId: json['scheduledPostId'] as String?,
      scheduledPostAt: json['scheduledPostAt'] == null
          ? null
          : DateTime.parse(json['scheduledPostAt'] as String),
    );

Map<String, dynamic> _$RoadmapProgressToJson(_RoadmapProgress instance) =>
    <String, dynamic>{
      'currentDay': instance.currentDay,
      'completedSteps': instance.completedSteps,
      'roadmapStartedAt': instance.roadmapStartedAt?.toIso8601String(),
      'brandType': instance.brandType,
      'pendingPostIdToday': instance.pendingPostIdToday,
      'scheduledPostId': instance.scheduledPostId,
      'scheduledPostAt': instance.scheduledPostAt?.toIso8601String(),
    };
