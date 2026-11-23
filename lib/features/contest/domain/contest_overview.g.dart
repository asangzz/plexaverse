// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContestInfo _$ContestInfoFromJson(Map<String, dynamic> json) => _ContestInfo(
  id: json['id'] as String? ?? '',
  title: json['title'] as String? ?? '',
  prizeTitle: json['prizeTitle'] as String? ?? '',
  prizeImageUrl: json['prizeImageUrl'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  firstDayKey: json['firstDayKey'] as String? ?? '',
  lastDayKey: json['lastDayKey'] as String? ?? '',
  rewardTopN: (json['rewardTopN'] as num?)?.toInt() ?? 10,
  rewardMonths: (json['rewardMonths'] as num?)?.toInt() ?? 0,
  freeDays: (json['freeDays'] as num?)?.toInt() ?? 30,
  weekComplete: (json['weekComplete'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContestInfoToJson(_ContestInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'prizeTitle': instance.prizeTitle,
      'prizeImageUrl': instance.prizeImageUrl,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'firstDayKey': instance.firstDayKey,
      'lastDayKey': instance.lastDayKey,
      'rewardTopN': instance.rewardTopN,
      'rewardMonths': instance.rewardMonths,
      'freeDays': instance.freeDays,
      'weekComplete': instance.weekComplete,
    };

_BoardReveal _$BoardRevealFromJson(Map<String, dynamic> json) => _BoardReveal(
  revealed: json['revealed'] as bool? ?? false,
  revealsOn: json['revealsOn'] as String? ?? '',
  revealDay: (json['revealDay'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$BoardRevealToJson(_BoardReveal instance) =>
    <String, dynamic>{
      'revealed': instance.revealed,
      'revealsOn': instance.revealsOn,
      'revealDay': instance.revealDay,
    };

_ContestEntryView _$ContestEntryViewFromJson(Map<String, dynamic> json) =>
    _ContestEntryView(
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      level: json['level'] as String? ?? 'B2',
      total: (json['total'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt(),
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      wrongCount: (json['wrongCount'] as num?)?.toInt() ?? 0,
      freeDaysLeft: (json['freeDaysLeft'] as num?)?.toInt() ?? 0,
      scoringPaused: json['scoringPaused'] as bool? ?? false,
    );

Map<String, dynamic> _$ContestEntryViewToJson(_ContestEntryView instance) =>
    <String, dynamic>{
      'joinedAt': instance.joinedAt.toIso8601String(),
      'level': instance.level,
      'total': instance.total,
      'rank': instance.rank,
      'streak': instance.streak,
      'bestStreak': instance.bestStreak,
      'correctCount': instance.correctCount,
      'wrongCount': instance.wrongCount,
      'freeDaysLeft': instance.freeDaysLeft,
      'scoringPaused': instance.scoringPaused,
    };

_ContestOverview _$ContestOverviewFromJson(Map<String, dynamic> json) =>
    _ContestOverview(
      contest: ContestInfo.fromJson(json['contest'] as Map<String, dynamic>),
      phase:
          $enumDecodeNullable(
            _$ContestPhaseEnumMap,
            json['phase'],
            unknownValue: ContestPhase.upcoming,
          ) ??
          ContestPhase.upcoming,
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      lengthDays: (json['lengthDays'] as num?)?.toInt() ?? 0,
      board: json['board'] == null
          ? const BoardReveal()
          : BoardReveal.fromJson(json['board'] as Map<String, dynamic>),
      entry: json['entry'] == null
          ? null
          : ContestEntryView.fromJson(json['entry'] as Map<String, dynamic>),
      entrants: (json['entrants'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ContestOverviewToJson(_ContestOverview instance) =>
    <String, dynamic>{
      'contest': instance.contest.toJson(),
      'phase': _$ContestPhaseEnumMap[instance.phase]!,
      'dayNumber': instance.dayNumber,
      'lengthDays': instance.lengthDays,
      'board': instance.board.toJson(),
      'entry': instance.entry?.toJson(),
      'entrants': instance.entrants,
    };

const _$ContestPhaseEnumMap = {
  ContestPhase.upcoming: 'upcoming',
  ContestPhase.running: 'running',
  ContestPhase.ended: 'ended',
};
