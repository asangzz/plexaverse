// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WritingTask _$WritingTaskFromJson(Map<String, dynamic> json) => _WritingTask(
  prompt: json['prompt'] as String? ?? '',
  hint: json['hint'] as String? ?? '',
  minChars: (json['minChars'] as num?)?.toInt() ?? 30,
  maxChars: (json['maxChars'] as num?)?.toInt() ?? 1200,
);

Map<String, dynamic> _$WritingTaskToJson(_WritingTask instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'hint': instance.hint,
      'minChars': instance.minChars,
      'maxChars': instance.maxChars,
    };

_PublicPlacementItem _$PublicPlacementItemFromJson(Map<String, dynamic> json) =>
    _PublicPlacementItem(
      id: json['id'] as String? ?? '',
      skill: ObjectiveSkill.parse(json['skill']),
      passage: json['passage'] as String?,
      prompt: json['prompt'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$PublicPlacementItemToJson(
  _PublicPlacementItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'skill': _skillWire(instance.skill),
  'passage': instance.passage,
  'prompt': instance.prompt,
  'options': instance.options,
};

_PlacementMeasured _$PlacementMeasuredFromJson(Map<String, dynamic> json) =>
    _PlacementMeasured(
      vocabulary: json['vocabulary'] as bool? ?? true,
      grammar: json['grammar'] as bool? ?? true,
      reading: json['reading'] as bool? ?? true,
    );

Map<String, dynamic> _$PlacementMeasuredToJson(_PlacementMeasured instance) =>
    <String, dynamic>{
      'vocabulary': instance.vocabulary,
      'grammar': instance.grammar,
      'reading': instance.reading,
    };

_WritingFeedback _$WritingFeedbackFromJson(Map<String, dynamic> json) =>
    _WritingFeedback(
      strengths:
          (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      improvements:
          (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$WritingFeedbackToJson(_WritingFeedback instance) =>
    <String, dynamic>{
      'strengths': instance.strengths,
      'improvements': instance.improvements,
    };

_PlacementInProgress _$PlacementInProgressFromJson(Map<String, dynamic> json) =>
    _PlacementInProgress(
      attemptId: json['attemptId'] as String? ?? '',
      answered: (json['answered'] as num?)?.toInt() ?? 0,
      closesAt: _instant(json['closesAt']),
    );

Map<String, dynamic> _$PlacementInProgressToJson(
  _PlacementInProgress instance,
) => <String, dynamic>{
  'attemptId': instance.attemptId,
  'answered': instance.answered,
  'closesAt': _instantWire(instance.closesAt),
};

_PlacementSummary _$PlacementSummaryFromJson(Map<String, dynamic> json) =>
    _PlacementSummary(
      attemptId: json['attemptId'] as String? ?? '',
      completedAt: _instant(json['completedAt']),
      band: CefrBand.parse(json['band']),
      vocabularyBand: CefrBand.parse(json['vocabularyBand']),
      grammarBand: CefrBand.parse(json['grammarBand']),
      readingBand: CefrBand.parse(json['readingBand']),
      writingBand: CefrBand.parse(json['writingBand']),
      writingFeedback: json['writingFeedback'] == null
          ? null
          : WritingFeedback.fromJson(
              json['writingFeedback'] as Map<String, dynamic>,
            ),
      writingPending: json['writingPending'] as bool? ?? false,
      closedEarly: json['closedEarly'] as bool? ?? false,
      measured: json['measured'] == null
          ? const PlacementMeasured()
          : PlacementMeasured.fromJson(
              json['measured'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PlacementSummaryToJson(_PlacementSummary instance) =>
    <String, dynamic>{
      'attemptId': instance.attemptId,
      'completedAt': _instantWire(instance.completedAt),
      'band': _bandWire(instance.band),
      'vocabularyBand': _bandWire(instance.vocabularyBand),
      'grammarBand': _bandWire(instance.grammarBand),
      'readingBand': _bandWire(instance.readingBand),
      'writingBand': _bandWire(instance.writingBand),
      'writingFeedback': instance.writingFeedback?.toJson(),
      'writingPending': instance.writingPending,
      'closedEarly': instance.closedEarly,
      'measured': instance.measured.toJson(),
    };

_PlacementStatus _$PlacementStatusFromJson(Map<String, dynamic> json) =>
    _PlacementStatus(
      band: json['band'] == null ? defaultBand : _bandOrDefault(json['band']),
      hasPlacement: json['hasPlacement'] as bool? ?? false,
      latest: json['latest'] == null
          ? null
          : PlacementSummary.fromJson(json['latest'] as Map<String, dynamic>),
      inProgress: json['inProgress'] == null
          ? null
          : PlacementInProgress.fromJson(
              json['inProgress'] as Map<String, dynamic>,
            ),
      canStart: json['canStart'] as bool? ?? true,
      nextRetakeAt: _instant(json['nextRetakeAt']),
      writingConsent: json['writingConsent'] as bool? ?? false,
    );

Map<String, dynamic> _$PlacementStatusToJson(_PlacementStatus instance) =>
    <String, dynamic>{
      'band': _bandWire(instance.band),
      'hasPlacement': instance.hasPlacement,
      'latest': instance.latest?.toJson(),
      'inProgress': instance.inProgress?.toJson(),
      'canStart': instance.canStart,
      'nextRetakeAt': _instantWire(instance.nextRetakeAt),
      'writingConsent': instance.writingConsent,
    };

_PlacementStep _$PlacementStepFromJson(Map<String, dynamic> json) =>
    _PlacementStep(
      attemptId: json['attemptId'] as String? ?? '',
      stage: json['stage'] == null
          ? PlacementStage.objective
          : PlacementStage.parse(json['stage']),
      skill: ObjectiveSkill.parse(json['skill']),
      item: json['item'] == null
          ? null
          : PublicPlacementItem.fromJson(json['item'] as Map<String, dynamic>),
      answered: (json['answered'] as num?)?.toInt() ?? 0,
      estimatedTotal: (json['estimatedTotal'] as num?)?.toInt() ?? 0,
      writingTask: json['writingTask'] == null
          ? null
          : WritingTask.fromJson(json['writingTask'] as Map<String, dynamic>),
      closesAt: _instant(json['closesAt']),
    );

Map<String, dynamic> _$PlacementStepToJson(_PlacementStep instance) =>
    <String, dynamic>{
      'attemptId': instance.attemptId,
      'stage': _stageWire(instance.stage),
      'skill': _skillWire(instance.skill),
      'item': instance.item?.toJson(),
      'answered': instance.answered,
      'estimatedTotal': instance.estimatedTotal,
      'writingTask': instance.writingTask?.toJson(),
      'closesAt': _instantWire(instance.closesAt),
    };

_PlacementResult _$PlacementResultFromJson(Map<String, dynamic> json) =>
    _PlacementResult(
      band: CefrBand.parse(json['band']),
      vocabularyBand: CefrBand.parse(json['vocabularyBand']),
      grammarBand: CefrBand.parse(json['grammarBand']),
      readingBand: CefrBand.parse(json['readingBand']),
      writingBand: CefrBand.parse(json['writingBand']),
      writingFeedback: json['writingFeedback'] == null
          ? null
          : WritingFeedback.fromJson(
              json['writingFeedback'] as Map<String, dynamic>,
            ),
      writingSubmitted: json['writingSubmitted'] as bool? ?? false,
      completedAt: _instant(json['completedAt']),
      closedEarly: json['closedEarly'] as bool? ?? false,
      measured: json['measured'] == null
          ? const PlacementMeasured()
          : PlacementMeasured.fromJson(
              json['measured'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PlacementResultToJson(_PlacementResult instance) =>
    <String, dynamic>{
      'band': _bandWire(instance.band),
      'vocabularyBand': _bandWire(instance.vocabularyBand),
      'grammarBand': _bandWire(instance.grammarBand),
      'readingBand': _bandWire(instance.readingBand),
      'writingBand': _bandWire(instance.writingBand),
      'writingFeedback': instance.writingFeedback?.toJson(),
      'writingSubmitted': instance.writingSubmitted,
      'completedAt': _instantWire(instance.completedAt),
      'closedEarly': instance.closedEarly,
      'measured': instance.measured.toJson(),
    };
