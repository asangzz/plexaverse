// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerTemplate _$BannerTemplateFromJson(Map<String, dynamic> json) =>
    _BannerTemplate(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      width: (json['width'] as num?)?.toInt() ?? 1584,
      height: (json['height'] as num?)?.toInt() ?? 396,
      data: json['data'] == null
          ? null
          : StudioDesignData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BannerTemplateToJson(_BannerTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'width': instance.width,
      'height': instance.height,
      'data': instance.data?.toJson(),
    };
