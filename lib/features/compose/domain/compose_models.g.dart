// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneratedPost _$GeneratedPostFromJson(Map<String, dynamic> json) =>
    _GeneratedPost(
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? '',
      posterTitle: json['posterTitle'] as String?,
      model: json['model'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
    );

Map<String, dynamic> _$GeneratedPostToJson(_GeneratedPost instance) =>
    <String, dynamic>{
      'content': instance.content,
      'category': instance.category,
      'posterTitle': instance.posterTitle,
      'model': instance.model,
      'provider': instance.provider,
    };

_GeneratedPoster _$GeneratedPosterFromJson(Map<String, dynamic> json) =>
    _GeneratedPoster(
      imageUrl: json['imageUrl'] as String? ?? '',
      posterTitle: json['posterTitle'] as String? ?? '',
      model: json['model'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
    );

Map<String, dynamic> _$GeneratedPosterToJson(_GeneratedPoster instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'posterTitle': instance.posterTitle,
      'model': instance.model,
      'provider': instance.provider,
    };

_UploadedImage _$UploadedImageFromJson(Map<String, dynamic> json) =>
    _UploadedImage(
      url: json['url'] as String? ?? '',
      thumbUrl: json['thumbUrl'] as String?,
    );

Map<String, dynamic> _$UploadedImageToJson(_UploadedImage instance) =>
    <String, dynamic>{'url': instance.url, 'thumbUrl': instance.thumbUrl};

_CreatedPost _$CreatedPostFromJson(Map<String, dynamic> json) => _CreatedPost(
  id: json['id'] as String? ?? '',
  status: json['status'] as String? ?? 'draft',
  scheduledFor: json['scheduledFor'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$CreatedPostToJson(_CreatedPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'scheduledFor': instance.scheduledFor,
      'imageUrl': instance.imageUrl,
    };

_CompanyPublishResult _$CompanyPublishResultFromJson(
  Map<String, dynamic> json,
) => _CompanyPublishResult(
  success: json['success'] as bool? ?? false,
  postUrn: json['postUrn'] as String? ?? '',
  postUrl: json['postUrl'] as String? ?? '',
);

Map<String, dynamic> _$CompanyPublishResultToJson(
  _CompanyPublishResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'postUrn': instance.postUrn,
  'postUrl': instance.postUrl,
};
