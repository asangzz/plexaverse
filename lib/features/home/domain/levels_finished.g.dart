// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'levels_finished.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LevelsFinishedDay _$LevelsFinishedDayFromJson(Map<String, dynamic> json) =>
    _LevelsFinishedDay(
      day: (json['day'] as num).toInt(),
      dayKey: json['dayKey'] as String? ?? '',
      done: (json['done'] as num?)?.toInt() ?? 0,
      offered: (json['offered'] as num?)?.toInt() ?? 0,
      percent: (json['percent'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LevelsFinishedDayToJson(_LevelsFinishedDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'dayKey': instance.dayKey,
      'done': instance.done,
      'offered': instance.offered,
      'percent': instance.percent,
    };

_LevelsFinished _$LevelsFinishedFromJson(Map<String, dynamic> json) =>
    _LevelsFinished(
      days:
          (json['days'] as List<dynamic>?)
              ?.map(
                (e) => LevelsFinishedDay.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <LevelsFinishedDay>[],
    );

Map<String, dynamic> _$LevelsFinishedToJson(_LevelsFinished instance) =>
    <String, dynamic>{'days': instance.days.map((e) => e.toJson()).toList()};
