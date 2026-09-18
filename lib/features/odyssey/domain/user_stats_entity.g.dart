// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStatsEntity _$UserStatsEntityFromJson(Map<String, dynamic> json) =>
    _UserStatsEntity(
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      levelTitle: json['levelTitle'] as String? ?? 'Beginner',
      weeklyXp: (json['weeklyXp'] as num?)?.toInt() ?? 0,
      weeklyXpGoal: (json['weeklyXpGoal'] as num?)?.toInt() ?? 2000,
      lastActiveDateStr: json['lastActiveDateStr'] as String?,
    );

Map<String, dynamic> _$UserStatsEntityToJson(_UserStatsEntity instance) =>
    <String, dynamic>{
      'streakDays': instance.streakDays,
      'xp': instance.xp,
      'level': instance.level,
      'levelTitle': instance.levelTitle,
      'weeklyXp': instance.weeklyXp,
      'weeklyXpGoal': instance.weeklyXpGoal,
      'lastActiveDateStr': instance.lastActiveDateStr,
    };
