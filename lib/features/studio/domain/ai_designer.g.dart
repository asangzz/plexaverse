// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_designer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiDesignerReply _$AiDesignerReplyFromJson(Map<String, dynamic> json) =>
    _AiDesignerReply(
      message: json['message'] as String? ?? '',
      design: json['design'] == null
          ? null
          : StudioDesignData.fromJson(json['design'] as Map<String, dynamic>),
      model: json['model'] as String? ?? '',
      imagesGenerated: (json['imagesGenerated'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AiDesignerReplyToJson(_AiDesignerReply instance) =>
    <String, dynamic>{
      'message': instance.message,
      'design': instance.design?.toJson(),
      'model': instance.model,
      'imagesGenerated': instance.imagesGenerated,
    };
