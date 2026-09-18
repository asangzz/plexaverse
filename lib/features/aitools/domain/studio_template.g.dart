// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudioTemplate _$StudioTemplateFromJson(Map<String, dynamic> json) =>
    _StudioTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      category: json['category'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      isTemplate: json['isTemplate'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$StudioTemplateToJson(_StudioTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'width': instance.width,
      'height': instance.height,
      'category': instance.category,
      'isPublic': instance.isPublic,
      'isTemplate': instance.isTemplate,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
