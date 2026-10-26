// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: json['id'] as String,
  type: json['type'] as String,
  prompt: json['prompt'] as String,
  teaches: json['teaches'] as String?,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  correctIndex: (json['correctIndex'] as num?)?.toInt(),
  explain: json['explain'] as String?,
  sentence: json['sentence'] as String?,
  starter: json['starter'] as String?,
  modelAnswer: json['modelAnswer'] as String?,
  placeholder: json['placeholder'] as String?,
  minChars: (json['minChars'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'prompt': instance.prompt,
  'teaches': instance.teaches,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
  'explain': instance.explain,
  'sentence': instance.sentence,
  'starter': instance.starter,
  'modelAnswer': instance.modelAnswer,
  'placeholder': instance.placeholder,
  'minChars': instance.minChars,
};

_TeachBlock _$TeachBlockFromJson(Map<String, dynamic> json) => _TeachBlock(
  rule: json['rule'] as String,
  why: json['why'] as String,
  before: json['before'] as String,
  after: json['after'] as String,
  kind: json['kind'] as String?,
);

Map<String, dynamic> _$TeachBlockToJson(_TeachBlock instance) =>
    <String, dynamic>{
      'rule': instance.rule,
      'why': instance.why,
      'before': instance.before,
      'after': instance.after,
      'kind': instance.kind,
    };

_LevelAnswer _$LevelAnswerFromJson(Map<String, dynamic> json) => _LevelAnswer(
  exerciseId: json['exerciseId'] as String,
  value: json['value'] as String,
  correct: json['correct'] as bool?,
);

Map<String, dynamic> _$LevelAnswerToJson(_LevelAnswer instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'value': instance.value,
      'correct': instance.correct,
    };

_LearnLevel _$LearnLevelFromJson(Map<String, dynamic> json) => _LearnLevel(
  index: (json['index'] as num).toInt(),
  kind: LevelKind.parse(json['kind'] as String?),
  title: json['title'] as String,
  teach: json['teach'] == null
      ? null
      : TeachBlock.fromJson(json['teach'] as Map<String, dynamic>),
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Exercise>[],
  status: json['status'] == null
      ? LevelStatus.locked
      : LevelStatus.parse(json['status'] as String?),
  answers:
      (json['answers'] as List<dynamic>?)
          ?.map((e) => LevelAnswer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LevelAnswer>[],
  completedAt: json['completedAt'] as String?,
);

Map<String, dynamic> _$LearnLevelToJson(_LearnLevel instance) =>
    <String, dynamic>{
      'index': instance.index,
      'kind': _$LevelKindEnumMap[instance.kind]!,
      'title': instance.title,
      'teach': instance.teach?.toJson(),
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
      'status': _$LevelStatusEnumMap[instance.status]!,
      'answers': instance.answers.map((e) => e.toJson()).toList(),
      'completedAt': instance.completedAt,
    };

const _$LevelKindEnumMap = {
  LevelKind.vocabulary: 'vocabulary',
  LevelKind.hook: 'hook',
  LevelKind.substance: 'substance',
  LevelKind.close: 'close',
  LevelKind.draft: 'draft',
  LevelKind.visual: 'visual',
  LevelKind.review: 'review',
};

const _$LevelStatusEnumMap = {
  LevelStatus.locked: 'locked',
  LevelStatus.available: 'available',
  LevelStatus.complete: 'complete',
};

_LearnUnit _$LearnUnitFromJson(Map<String, dynamic> json) => _LearnUnit(
  id: json['id'] as String,
  season: (json['season'] as num).toInt(),
  weekNumber: (json['weekNumber'] as num).toInt(),
  dayIndex: (json['dayIndex'] as num).toInt(),
  kind: DayKind.parse(json['kind'] as String?),
  title: json['title'] as String,
  unitTitle: json['unitTitle'] as String? ?? '',
  levels:
      (json['levels'] as List<dynamic>?)
          ?.map((e) => LearnLevel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LearnLevel>[],
  status: json['status'] == null
      ? UnitStatus.available
      : UnitStatus.parse(json['status'] as String?),
  nextLevelIndex: (json['nextLevelIndex'] as num?)?.toInt() ?? 0,
  postId: json['postId'] as String?,
  postContent: json['postContent'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$LearnUnitToJson(_LearnUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'season': instance.season,
      'weekNumber': instance.weekNumber,
      'dayIndex': instance.dayIndex,
      'kind': _$DayKindEnumMap[instance.kind]!,
      'title': instance.title,
      'unitTitle': instance.unitTitle,
      'levels': instance.levels.map((e) => e.toJson()).toList(),
      'status': _$UnitStatusEnumMap[instance.status]!,
      'nextLevelIndex': instance.nextLevelIndex,
      'postId': instance.postId,
      'postContent': instance.postContent,
      'imageUrl': instance.imageUrl,
    };

const _$DayKindEnumMap = {
  DayKind.post: 'post',
  DayKind.videoScript: 'videoScript',
  DayKind.article: 'article',
  DayKind.rest: 'rest',
};

const _$UnitStatusEnumMap = {
  UnitStatus.locked: 'locked',
  UnitStatus.available: 'available',
  UnitStatus.inProgress: 'inProgress',
  UnitStatus.complete: 'complete',
};

_LearnPathDay _$LearnPathDayFromJson(Map<String, dynamic> json) =>
    _LearnPathDay(
      dayIndex: (json['dayIndex'] as num).toInt(),
      day: json['day'] as String,
      kind: DayKind.parse(json['kind'] as String?),
      title: json['title'] as String,
      status: json['status'] == null
          ? UnitStatus.locked
          : UnitStatus.parse(json['status'] as String?),
      levelCount: (json['levelCount'] as num?)?.toInt() ?? 0,
      completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
      started: json['started'] as bool? ?? false,
    );

Map<String, dynamic> _$LearnPathDayToJson(_LearnPathDay instance) =>
    <String, dynamic>{
      'dayIndex': instance.dayIndex,
      'day': instance.day,
      'kind': _$DayKindEnumMap[instance.kind]!,
      'title': instance.title,
      'status': _$UnitStatusEnumMap[instance.status]!,
      'levelCount': instance.levelCount,
      'completedCount': instance.completedCount,
      'started': instance.started,
    };

_LearnPath _$LearnPathFromJson(Map<String, dynamic> json) => _LearnPath(
  season: (json['season'] as num).toInt(),
  weekNumber: (json['weekNumber'] as num).toInt(),
  unitTitle: json['unitTitle'] as String? ?? '',
  phase: json['phase'] as String? ?? '',
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => LearnPathDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LearnPathDay>[],
  nextDayIndex: (json['nextDayIndex'] as num?)?.toInt(),
);

Map<String, dynamic> _$LearnPathToJson(_LearnPath instance) =>
    <String, dynamic>{
      'season': instance.season,
      'weekNumber': instance.weekNumber,
      'unitTitle': instance.unitTitle,
      'phase': instance.phase,
      'days': instance.days.map((e) => e.toJson()).toList(),
      'nextDayIndex': instance.nextDayIndex,
    };

_ExerciseResult _$ExerciseResultFromJson(Map<String, dynamic> json) =>
    _ExerciseResult(
      exerciseId: json['exerciseId'] as String,
      correct: json['correct'] as bool,
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$ExerciseResultToJson(_ExerciseResult instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'correct': instance.correct,
      'message': instance.message,
    };

_SubmitResult _$SubmitResultFromJson(Map<String, dynamic> json) =>
    _SubmitResult(
      unit: LearnUnit.fromJson(json['unit'] as Map<String, dynamic>),
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => ExerciseResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ExerciseResult>[],
    );

Map<String, dynamic> _$SubmitResultToJson(_SubmitResult instance) =>
    <String, dynamic>{
      'unit': instance.unit.toJson(),
      'results': instance.results.map((e) => e.toJson()).toList(),
    };
