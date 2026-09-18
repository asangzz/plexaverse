// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'festive_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FestiveTemplate _$FestiveTemplateFromJson(Map<String, dynamic> json) =>
    _FestiveTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'general',
      previewUrl: json['previewUrl'] as String? ?? '',
      aspectRatio: json['aspectRatio'] as String? ?? '1:1',
      figmaNodeId: json['figmaNodeId'] as String?,
    );

Map<String, dynamic> _$FestiveTemplateToJson(_FestiveTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'previewUrl': instance.previewUrl,
      'aspectRatio': instance.aspectRatio,
      'figmaNodeId': instance.figmaNodeId,
    };

_FestiveGallery _$FestiveGalleryFromJson(Map<String, dynamic> json) =>
    _FestiveGallery(
      templates:
          (json['templates'] as List<dynamic>?)
              ?.map((e) => FestiveTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FestiveTemplate>[],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$FestiveGalleryToJson(_FestiveGallery instance) =>
    <String, dynamic>{
      'templates': instance.templates.map((e) => e.toJson()).toList(),
      'categories': instance.categories,
    };

_FestivePoster _$FestivePosterFromJson(Map<String, dynamic> json) =>
    _FestivePoster(
      imageUrl: json['imageUrl'] as String? ?? '',
      templateName: json['templateName'] as String? ?? '',
    );

Map<String, dynamic> _$FestivePosterToJson(_FestivePoster instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'templateName': instance.templateName,
    };
