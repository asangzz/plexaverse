// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plexa_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayItem _$DayItemFromJson(Map<String, dynamic> json) => _DayItem(
  id: json['id'] as String? ?? '',
  lane:
      $enumDecodeNullable(
        _$PlexaLaneEnumMap,
        json['lane'],
        unknownValue: PlexaLane.comments,
      ) ??
      PlexaLane.comments,
  headline: json['headline'] as String? ?? '',
  context: json['context'] as String?,
  draft: json['draft'] as String? ?? '',
  url: json['url'] as String? ?? '',
  topVoiceId: json['topVoiceId'] as String?,
);

Map<String, dynamic> _$DayItemToJson(_DayItem instance) => <String, dynamic>{
  'id': instance.id,
  'lane': _$PlexaLaneEnumMap[instance.lane]!,
  'headline': instance.headline,
  'context': instance.context,
  'draft': instance.draft,
  'url': instance.url,
  'topVoiceId': instance.topVoiceId,
};

const _$PlexaLaneEnumMap = {
  PlexaLane.comments: 'comments',
  PlexaLane.connections: 'connections',
};

_PlexaReady _$PlexaReadyFromJson(Map<String, dynamic> json) => _PlexaReady(
  comments: json['comments'] as bool? ?? false,
  connections: json['connections'] as bool? ?? false,
  topVoices: json['topVoices'] as bool? ?? false,
);

Map<String, dynamic> _$PlexaReadyToJson(_PlexaReady instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'connections': instance.connections,
      'topVoices': instance.topVoices,
    };
