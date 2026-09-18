// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionStepResult _$MissionStepResultFromJson(Map<String, dynamic> json) =>
    _MissionStepResult(
      alreadyCompleted: json['alreadyCompleted'] as bool? ?? false,
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MissionStepResultToJson(_MissionStepResult instance) =>
    <String, dynamic>{
      'alreadyCompleted': instance.alreadyCompleted,
      'xpAwarded': instance.xpAwarded,
    };

_BannerTemplate _$BannerTemplateFromJson(Map<String, dynamic> json) =>
    _BannerTemplate(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      width: (json['width'] as num?)?.toInt() ?? 1200,
      height: (json['height'] as num?)?.toInt() ?? 400,
      data: json['data'] == null
          ? null
          : BannerDesign.fromJson(json['data'] as Map<String, dynamic>),
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

_BannerCanvas _$BannerCanvasFromJson(Map<String, dynamic> json) =>
    _BannerCanvas(
      width: (json['width'] as num?)?.toDouble() ?? 1200.0,
      height: (json['height'] as num?)?.toDouble() ?? 400.0,
      background: json['background'] as String?,
    );

Map<String, dynamic> _$BannerCanvasToJson(_BannerCanvas instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'background': instance.background,
    };

_BannerElement _$BannerElementFromJson(Map<String, dynamic> json) =>
    _BannerElement(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'rectangle',
      name: json['name'] as String? ?? '',
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      fill: json['fill'] as String? ?? 'transparent',
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      visible: json['visible'] as bool? ?? true,
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      text: json['text'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontFamily: json['fontFamily'] as String?,
      fontWeight: (json['fontWeight'] as num?)?.toInt(),
      textAlign: json['textAlign'] as String?,
      imageUrl: json['imageUrl'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => BannerElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BannerElement>[],
    );

Map<String, dynamic> _$BannerElementToJson(_BannerElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'fill': instance.fill,
      'opacity': instance.opacity,
      'visible': instance.visible,
      'borderRadius': instance.borderRadius,
      'text': instance.text,
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'fontWeight': instance.fontWeight,
      'textAlign': instance.textAlign,
      'imageUrl': instance.imageUrl,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };

_BannerDesign _$BannerDesignFromJson(Map<String, dynamic> json) =>
    _BannerDesign(
      canvas: json['canvas'] == null
          ? null
          : BannerCanvas.fromJson(json['canvas'] as Map<String, dynamic>),
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => BannerElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BannerElement>[],
    );

Map<String, dynamic> _$BannerDesignToJson(_BannerDesign instance) =>
    <String, dynamic>{
      'canvas': instance.canvas?.toJson(),
      'elements': instance.elements.map((e) => e.toJson()).toList(),
    };
