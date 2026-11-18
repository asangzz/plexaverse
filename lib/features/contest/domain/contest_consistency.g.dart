// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_consistency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsistencyWindow _$ConsistencyWindowFromJson(Map<String, dynamic> json) =>
    _ConsistencyWindow(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
      basis: json['basis'] as String? ?? '',
      estimated: json['estimated'] as bool? ?? false,
    );

Map<String, dynamic> _$ConsistencyWindowToJson(_ConsistencyWindow instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'basis': instance.basis,
      'estimated': instance.estimated,
    };

_ConsistencyToday _$ConsistencyTodayFromJson(Map<String, dynamic> json) =>
    _ConsistencyToday(
      dayKey: json['dayKey'] as String? ?? '',
      earned: (json['earned'] as num?)?.toInt() ?? 0,
      available: (json['available'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConsistencyTodayToJson(_ConsistencyToday instance) =>
    <String, dynamic>{
      'dayKey': instance.dayKey,
      'earned': instance.earned,
      'available': instance.available,
    };

_ConsistencyDay _$ConsistencyDayFromJson(Map<String, dynamic> json) =>
    _ConsistencyDay(
      dayKey: json['dayKey'] as String? ?? '',
      available: (json['available'] as num?)?.toInt() ?? 0,
      earned: (json['earned'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      paused: json['paused'] as bool? ?? false,
      today: json['today'] as bool? ?? false,
    );

Map<String, dynamic> _$ConsistencyDayToJson(_ConsistencyDay instance) =>
    <String, dynamic>{
      'dayKey': instance.dayKey,
      'available': instance.available,
      'earned': instance.earned,
      'pending': instance.pending,
      'paused': instance.paused,
      'today': instance.today,
    };

_ConsistencyView _$ConsistencyViewFromJson(Map<String, dynamic> json) =>
    _ConsistencyView(
      state:
          $enumDecodeNullable(
            _$ConsistencyStateEnumMap,
            json['state'],
            unknownValue: ConsistencyState.off,
          ) ??
          ConsistencyState.off,
      mode:
          $enumDecodeNullable(
            _$ConsistencyModeEnumMap,
            json['mode'],
            unknownValue: ConsistencyMode.shadow,
          ) ??
          ConsistencyMode.shadow,
      threshold: (json['threshold'] as num?)?.toInt() ?? 75,
      percent: (json['percent'] as num?)?.toInt(),
      atOrAbove: json['atOrAbove'] as bool?,
      earned: (json['earned'] as num?)?.toInt() ?? 0,
      available: (json['available'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      unaudited: (json['unaudited'] as num?)?.toInt() ?? 0,
      toLine: (json['toLine'] as num?)?.toInt() ?? 0,
      countedDays: (json['countedDays'] as num?)?.toInt() ?? 0,
      window: json['window'] == null
          ? null
          : ConsistencyWindow.fromJson(json['window'] as Map<String, dynamic>),
      today: json['today'] == null
          ? null
          : ConsistencyToday.fromJson(json['today'] as Map<String, dynamic>),
      joined: json['joined'] as bool?,
      scoringPaused: json['scoringPaused'] as bool? ?? false,
      noContestRunning: json['noContestRunning'] as bool? ?? false,
      days:
          (json['days'] as List<dynamic>?)
              ?.map((e) => ConsistencyDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ConsistencyDay>[],
    );

Map<String, dynamic> _$ConsistencyViewToJson(_ConsistencyView instance) =>
    <String, dynamic>{
      'state': _$ConsistencyStateEnumMap[instance.state]!,
      'mode': _$ConsistencyModeEnumMap[instance.mode]!,
      'threshold': instance.threshold,
      'percent': instance.percent,
      'atOrAbove': instance.atOrAbove,
      'earned': instance.earned,
      'available': instance.available,
      'pending': instance.pending,
      'unaudited': instance.unaudited,
      'toLine': instance.toLine,
      'countedDays': instance.countedDays,
      'window': instance.window?.toJson(),
      'today': instance.today?.toJson(),
      'joined': instance.joined,
      'scoringPaused': instance.scoringPaused,
      'noContestRunning': instance.noContestRunning,
      'days': instance.days.map((e) => e.toJson()).toList(),
    };

const _$ConsistencyStateEnumMap = {
  ConsistencyState.off: 'off',
  ConsistencyState.noContest: 'no_contest',
  ConsistencyState.notJoined: 'not_joined',
  ConsistencyState.noTasks: 'no_tasks',
  ConsistencyState.measuring: 'measuring',
};

const _$ConsistencyModeEnumMap = {
  ConsistencyMode.off: 'off',
  ConsistencyMode.shadow: 'shadow',
  ConsistencyMode.on: 'on',
};
