// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headshot_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeadshotResult _$HeadshotResultFromJson(Map<String, dynamic> json) =>
    _HeadshotResult(
      headshots:
          (json['headshots'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      count: (json['count'] as num?)?.toInt() ?? 0,
      style: json['style'] as String? ?? 'professional',
      background: json['background'] as String? ?? 'studio',
    );

Map<String, dynamic> _$HeadshotResultToJson(_HeadshotResult instance) =>
    <String, dynamic>{
      'headshots': instance.headshots,
      'count': instance.count,
      'style': instance.style,
      'background': instance.background,
    };
