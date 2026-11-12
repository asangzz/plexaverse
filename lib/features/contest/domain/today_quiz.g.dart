// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicQuizItem _$PublicQuizItemFromJson(Map<String, dynamic> json) =>
    _PublicQuizItem(
      id: json['id'] as String? ?? '',
      skill:
          $enumDecodeNullable(
            _$QuizSkillEnumMap,
            json['skill'],
            unknownValue: QuizSkill.other,
          ) ??
          QuizSkill.other,
      passage: json['passage'] as String?,
      prompt: json['prompt'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$PublicQuizItemToJson(_PublicQuizItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'skill': _$QuizSkillEnumMap[instance.skill]!,
      'passage': instance.passage,
      'prompt': instance.prompt,
      'options': instance.options,
    };

const _$QuizSkillEnumMap = {
  QuizSkill.vocabulary: 'vocabulary',
  QuizSkill.grammar: 'grammar',
  QuizSkill.usage: 'usage',
  QuizSkill.reading: 'reading',
  QuizSkill.other: 'other',
};

_QuizAnswerView _$QuizAnswerViewFromJson(Map<String, dynamic> json) =>
    _QuizAnswerView(
      itemId: json['itemId'] as String? ?? '',
      value: json['value'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
      correctOption: json['correctOption'] as String? ?? '',
      explain: json['explain'] as String? ?? '',
      pointsApplied: (json['pointsApplied'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuizAnswerViewToJson(_QuizAnswerView instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'value': instance.value,
      'correct': instance.correct,
      'correctOption': instance.correctOption,
      'explain': instance.explain,
      'pointsApplied': instance.pointsApplied,
    };

_QuizScore _$QuizScoreFromJson(Map<String, dynamic> json) => _QuizScore(
  correct: (json['correct'] as num?)?.toInt() ?? 0,
  wrong: (json['wrong'] as num?)?.toInt() ?? 0,
  points: (json['points'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$QuizScoreToJson(_QuizScore instance) =>
    <String, dynamic>{
      'correct': instance.correct,
      'wrong': instance.wrong,
      'points': instance.points,
    };

_FinishBonus _$FinishBonusFromJson(Map<String, dynamic> json) => _FinishBonus(
  points: (json['points'] as num?)?.toInt() ?? 0,
  minCorrect: (json['minCorrect'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FinishBonusToJson(_FinishBonus instance) =>
    <String, dynamic>{
      'points': instance.points,
      'minCorrect': instance.minCorrect,
    };

_TodayQuiz _$TodayQuizFromJson(Map<String, dynamic> json) => _TodayQuiz(
  status:
      $enumDecodeNullable(
        _$QuizStatusEnumMap,
        json['status'],
        unknownValue: QuizStatus.noQuizToday,
      ) ??
      QuizStatus.noQuizToday,
  reason: $enumDecodeNullable(
    _$QuizReasonEnumMap,
    json['reason'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  contestId: json['contestId'] as String?,
  day: (json['day'] as num?)?.toInt(),
  band: json['band'] as String?,
  bandLocked: json['bandLocked'] as bool? ?? false,
  tomorrow: json['tomorrow'] as bool?,
  started: json['started'] as bool?,
  ownQuestions: (json['ownQuestions'] as num?)?.toInt() ?? 0,
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => PublicQuizItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PublicQuizItem>[],
  answered:
      (json['answered'] as List<dynamic>?)
          ?.map((e) => QuizAnswerView.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuizAnswerView>[],
  completed: json['completed'] as bool? ?? false,
  score: json['score'] == null
      ? null
      : QuizScore.fromJson(json['score'] as Map<String, dynamic>),
  finishBonus: json['finishBonus'] == null
      ? null
      : FinishBonus.fromJson(json['finishBonus'] as Map<String, dynamic>),
  scoringPaused: json['scoringPaused'] as bool? ?? false,
);

Map<String, dynamic> _$TodayQuizToJson(_TodayQuiz instance) =>
    <String, dynamic>{
      'status': _$QuizStatusEnumMap[instance.status]!,
      'reason': _$QuizReasonEnumMap[instance.reason],
      'contestId': instance.contestId,
      'day': instance.day,
      'band': instance.band,
      'bandLocked': instance.bandLocked,
      'tomorrow': instance.tomorrow,
      'started': instance.started,
      'ownQuestions': instance.ownQuestions,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'answered': instance.answered.map((e) => e.toJson()).toList(),
      'completed': instance.completed,
      'score': instance.score?.toJson(),
      'finishBonus': instance.finishBonus?.toJson(),
      'scoringPaused': instance.scoringPaused,
    };

const _$QuizStatusEnumMap = {
  QuizStatus.noContest: 'no_contest',
  QuizStatus.notJoined: 'not_joined',
  QuizStatus.upcoming: 'upcoming',
  QuizStatus.ended: 'ended',
  QuizStatus.noQuizToday: 'no_quiz_today',
  QuizStatus.ready: 'ready',
};

const _$QuizReasonEnumMap = {
  QuizReason.noContest: 'no_contest',
  QuizReason.notJoined: 'not_joined',
  QuizReason.notStarted: 'not_started',
  QuizReason.contestEnded: 'contest_ended',
  QuizReason.bankEnded: 'bank_ended',
};

_QuizAnswerResult _$QuizAnswerResultFromJson(Map<String, dynamic> json) =>
    _QuizAnswerResult(
      value: json['value'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
      correctOption: json['correctOption'] as String? ?? '',
      explain: json['explain'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
      scored: json['scored'] as bool? ?? true,
      weekBonus: (json['weekBonus'] as num?)?.toInt(),
      replay: json['replay'] as bool? ?? false,
    );

Map<String, dynamic> _$QuizAnswerResultToJson(_QuizAnswerResult instance) =>
    <String, dynamic>{
      'value': instance.value,
      'correct': instance.correct,
      'correctOption': instance.correctOption,
      'explain': instance.explain,
      'completed': instance.completed,
      'pointsApplied': instance.pointsApplied,
      'scored': instance.scored,
      'weekBonus': instance.weekBonus,
      'replay': instance.replay,
    };
