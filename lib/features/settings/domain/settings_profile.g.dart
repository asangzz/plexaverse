// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsProfile _$SettingsProfileFromJson(Map<String, dynamic> json) =>
    _SettingsProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      handle: json['handle'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      memberSince: json['memberSince'] == null
          ? null
          : DateTime.parse(json['memberSince'] as String),
    );

Map<String, dynamic> _$SettingsProfileToJson(_SettingsProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'handle': instance.handle,
      'email': instance.email,
      'avatarUrl': ?instance.avatarUrl,
      'memberSince': ?instance.memberSince?.toIso8601String(),
    };
