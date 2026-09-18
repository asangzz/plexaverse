// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvatarProfile _$AvatarProfileFromJson(Map<String, dynamic> json) =>
    _AvatarProfile(
      name: json['name'] as String,
      lookCount: (json['lookCount'] as num).toInt(),
      voiceName: json['voiceName'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$AvatarProfileToJson(_AvatarProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lookCount': instance.lookCount,
      'voiceName': instance.voiceName,
      'avatarUrl': instance.avatarUrl,
    };
