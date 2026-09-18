// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoItem _$VideoItemFromJson(Map<String, dynamic> json) => _VideoItem(
  id: json['id'] as String,
  title: json['title'] as String,
  dateLabel: json['dateLabel'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  badgeLabel: json['badgeLabel'] as String?,
  durationLabel: json['durationLabel'] as String?,
);

Map<String, dynamic> _$VideoItemToJson(_VideoItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'dateLabel': instance.dateLabel,
      'thumbnailUrl': instance.thumbnailUrl,
      'badgeLabel': instance.badgeLabel,
      'durationLabel': instance.durationLabel,
    };
