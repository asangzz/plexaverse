// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanSlot _$PlanSlotFromJson(Map<String, dynamic> json) => _PlanSlot(
  day: json['day'] as String,
  type: json['type'] as String? ?? 'general',
  format: json['format'] as String? ?? 'text',
  previewImageUrl: json['previewImageUrl'] as String?,
  fullImageUrl: json['fullImageUrl'] as String?,
  angle: json['angle'] as String? ?? '',
  title: json['title'] as String? ?? '',
  titleEditedByUser: json['titleEditedByUser'] as bool? ?? false,
  hashtags:
      (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(
        _$SlotStatusEnumMap,
        json['status'],
        unknownValue: SlotStatus.planned,
      ) ??
      SlotStatus.planned,
  postId: json['postId'] as String?,
  rawKind: json['kind'] as String?,
  restDay: json['restDay'] as bool? ?? false,
  artifact: json['artifact'] as String?,
  posterTag: json['posterTag'] as String?,
);

Map<String, dynamic> _$PlanSlotToJson(_PlanSlot instance) => <String, dynamic>{
  'day': instance.day,
  'type': instance.type,
  'format': instance.format,
  'previewImageUrl': instance.previewImageUrl,
  'fullImageUrl': instance.fullImageUrl,
  'angle': instance.angle,
  'title': instance.title,
  'titleEditedByUser': instance.titleEditedByUser,
  'hashtags': instance.hashtags,
  'status': _$SlotStatusEnumMap[instance.status]!,
  'postId': instance.postId,
  'kind': instance.rawKind,
  'restDay': instance.restDay,
  'artifact': instance.artifact,
  'posterTag': instance.posterTag,
};

const _$SlotStatusEnumMap = {
  SlotStatus.planned: 'planned',
  SlotStatus.generating: 'generating',
  SlotStatus.generated: 'generated',
  SlotStatus.approved: 'approved',
  SlotStatus.published: 'published',
};

_WeekPlan _$WeekPlanFromJson(Map<String, dynamic> json) => _WeekPlan(
  id: json['id'] as String,
  weekNumber: (json['weekNumber'] as num).toInt(),
  season: (json['season'] as num).toInt(),
  phase: json['phase'] as String?,
  topic: json['topic'] as String?,
  posts:
      (json['posts'] as List<dynamic>?)
          ?.map((e) => PlanSlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PlanSlot>[],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$WeekPlanToJson(_WeekPlan instance) => <String, dynamic>{
  'id': instance.id,
  'weekNumber': instance.weekNumber,
  'season': instance.season,
  'phase': instance.phase,
  'topic': instance.topic,
  'posts': instance.posts.map((e) => e.toJson()).toList(),
  'generatedAt': instance.generatedAt,
};

_PlannerState _$PlannerStateFromJson(Map<String, dynamic> json) =>
    _PlannerState(
      plan: json['plan'] == null
          ? null
          : WeekPlan.fromJson(json['plan'] as Map<String, dynamic>),
      currentWeekNumber: (json['currentWeekNumber'] as num?)?.toInt() ?? 1,
      currentSeason: (json['currentSeason'] as num?)?.toInt() ?? 1,
      upcomingTopic: json['upcomingTopic'] as String?,
      upcomingPhase: json['upcomingPhase'] as String?,
      upcomingTitle: json['upcomingTitle'] as String?,
    );

Map<String, dynamic> _$PlannerStateToJson(_PlannerState instance) =>
    <String, dynamic>{
      'plan': instance.plan?.toJson(),
      'currentWeekNumber': instance.currentWeekNumber,
      'currentSeason': instance.currentSeason,
      'upcomingTopic': instance.upcomingTopic,
      'upcomingPhase': instance.upcomingPhase,
      'upcomingTitle': instance.upcomingTitle,
    };
