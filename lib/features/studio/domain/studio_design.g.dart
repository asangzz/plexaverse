// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_design.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudioAccess _$StudioAccessFromJson(Map<String, dynamic> json) =>
    _StudioAccess(
      hasAccess: json['hasAccess'] as bool? ?? false,
      currentXp: (json['currentXP'] as num?)?.toInt() ?? 0,
      requiredXp: (json['requiredXP'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StudioAccessToJson(_StudioAccess instance) =>
    <String, dynamic>{
      'hasAccess': instance.hasAccess,
      'currentXP': instance.currentXp,
      'requiredXP': instance.requiredXp,
    };

_StudioUnlockResult _$StudioUnlockResultFromJson(Map<String, dynamic> json) =>
    _StudioUnlockResult(
      success: json['success'] as bool? ?? false,
      alreadyUnlocked: json['alreadyUnlocked'] as bool? ?? false,
      newBalance: (json['newBalance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StudioUnlockResultToJson(_StudioUnlockResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'alreadyUnlocked': instance.alreadyUnlocked,
      'newBalance': instance.newBalance,
    };

_StudioCanvas _$StudioCanvasFromJson(Map<String, dynamic> json) =>
    _StudioCanvas(
      width: (json['width'] as num?)?.toDouble() ?? 1080.0,
      height: (json['height'] as num?)?.toDouble() ?? 1080.0,
      background: json['background'] as String? ?? '#0a0a0a',
    );

Map<String, dynamic> _$StudioCanvasToJson(_StudioCanvas instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'background': instance.background,
    };

_StudioElement _$StudioElementFromJson(Map<String, dynamic> json) =>
    _StudioElement(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'rectangle',
      name: json['name'] as String? ?? '',
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      fill: json['fill'] as String? ?? 'transparent',
      stroke: json['stroke'] as String? ?? 'transparent',
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 0.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      visible: json['visible'] as bool? ?? true,
      locked: json['locked'] as bool? ?? false,
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      text: json['text'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontFamily: json['fontFamily'] as String?,
      fontWeight: (json['fontWeight'] as num?)?.toInt(),
      fontStyle: json['fontStyle'] as String?,
      textAlign: json['textAlign'] as String?,
      lineHeight: (json['lineHeight'] as num?)?.toDouble(),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
      underline: json['underline'] as bool? ?? false,
      linethrough: json['linethrough'] as bool? ?? false,
      textTransform: json['textTransform'] as String?,
      imageUrl: json['imageUrl'] as String?,
      maskShape: json['maskShape'] as String?,
      maskBorderRadius: (json['maskBorderRadius'] as num?)?.toDouble(),
      clipContent: json['clipContent'] as bool? ?? true,
      layoutMode: json['layoutMode'] as String?,
      layoutGap: (json['layoutGap'] as num?)?.toDouble(),
      layoutPadding: (json['layoutPadding'] as num?)?.toDouble(),
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => StudioElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StudioElement>[],
    );

Map<String, dynamic> _$StudioElementToJson(_StudioElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'rotation': instance.rotation,
      'fill': instance.fill,
      'stroke': instance.stroke,
      'strokeWidth': instance.strokeWidth,
      'opacity': instance.opacity,
      'visible': instance.visible,
      'locked': instance.locked,
      'borderRadius': instance.borderRadius,
      'text': instance.text,
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'fontWeight': instance.fontWeight,
      'fontStyle': instance.fontStyle,
      'textAlign': instance.textAlign,
      'lineHeight': instance.lineHeight,
      'letterSpacing': instance.letterSpacing,
      'underline': instance.underline,
      'linethrough': instance.linethrough,
      'textTransform': instance.textTransform,
      'imageUrl': instance.imageUrl,
      'maskShape': instance.maskShape,
      'maskBorderRadius': instance.maskBorderRadius,
      'clipContent': instance.clipContent,
      'layoutMode': instance.layoutMode,
      'layoutGap': instance.layoutGap,
      'layoutPadding': instance.layoutPadding,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };

_StudioDesign _$StudioDesignFromJson(Map<String, dynamic> json) =>
    _StudioDesign(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      width: (json['width'] as num?)?.toInt() ?? 1080,
      height: (json['height'] as num?)?.toInt() ?? 1080,
      isPublic: json['isPublic'] as bool? ?? false,
      isTemplate: json['isTemplate'] as bool? ?? false,
      category: json['category'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      data: json['data'] == null
          ? null
          : StudioDesignData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudioDesignToJson(_StudioDesign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'width': instance.width,
      'height': instance.height,
      'isPublic': instance.isPublic,
      'isTemplate': instance.isTemplate,
      'category': instance.category,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'data': instance.data?.toJson(),
    };
