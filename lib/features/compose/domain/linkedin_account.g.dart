// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LinkedinAccount _$LinkedinAccountFromJson(Map<String, dynamic> json) =>
    _LinkedinAccount(
      id: json['id'] as String,
      profileId: json['profileId'] as String? ?? '',
      profileName: json['profileName'] as String? ?? '',
      profileHeadline: json['profileHeadline'] as String?,
      profileImage: json['profileImage'] as String?,
      profileSlug: json['profileSlug'] as String?,
      appType: json['appType'] as String? ?? 'personal',
      needsReconnect: json['needsReconnect'] as bool? ?? false,
    );

Map<String, dynamic> _$LinkedinAccountToJson(_LinkedinAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'profileName': instance.profileName,
      'profileHeadline': instance.profileHeadline,
      'profileImage': instance.profileImage,
      'profileSlug': instance.profileSlug,
      'appType': instance.appType,
      'needsReconnect': instance.needsReconnect,
    };
