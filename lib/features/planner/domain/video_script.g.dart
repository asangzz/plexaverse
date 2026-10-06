// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoBeat _$VideoBeatFromJson(Map<String, dynamic> json) => _VideoBeat(
  seconds: (json['seconds'] as num?)?.toInt() ?? 0,
  say: json['say'] as String? ?? '',
  show: json['show'] as String? ?? '',
);

Map<String, dynamic> _$VideoBeatToJson(_VideoBeat instance) =>
    <String, dynamic>{
      'seconds': instance.seconds,
      'say': instance.say,
      'show': instance.show,
    };

_VideoScript _$VideoScriptFromJson(Map<String, dynamic> json) => _VideoScript(
  id: json['id'] as String? ?? '',
  weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
  season: (json['season'] as num?)?.toInt() ?? 1,
  dayIndex: (json['dayIndex'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  hook: json['hook'] as String? ?? '',
  beats:
      (json['beats'] as List<dynamic>?)
          ?.map((e) => VideoBeat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <VideoBeat>[],
  caption: json['caption'] as String? ?? '',
  status: json['status'] as String? ?? 'ready',
  publishedAt: json['publishedAt'] as String?,
);

Map<String, dynamic> _$VideoScriptToJson(_VideoScript instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weekNumber': instance.weekNumber,
      'season': instance.season,
      'dayIndex': instance.dayIndex,
      'title': instance.title,
      'hook': instance.hook,
      'beats': instance.beats.map((e) => e.toJson()).toList(),
      'caption': instance.caption,
      'status': instance.status,
      'publishedAt': instance.publishedAt,
    };
