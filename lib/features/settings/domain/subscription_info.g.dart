// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionInfo _$SubscriptionInfoFromJson(Map<String, dynamic> json) =>
    _SubscriptionInfo(
      planName: json['planName'] as String,
      source: json['source'] as String,
      creditsRemaining: (json['creditsRemaining'] as num).toInt(),
      creditsTotal: (json['creditsTotal'] as num).toInt(),
      avatarSlotsRemaining: (json['avatarSlotsRemaining'] as num).toInt(),
      avatarSlotsTotal: (json['avatarSlotsTotal'] as num).toInt(),
      recentActivity:
          (json['recentActivity'] as List<dynamic>?)
              ?.map(
                (e) => SubscriptionActivity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <SubscriptionActivity>[],
    );

Map<String, dynamic> _$SubscriptionInfoToJson(_SubscriptionInfo instance) =>
    <String, dynamic>{
      'planName': instance.planName,
      'source': instance.source,
      'creditsRemaining': instance.creditsRemaining,
      'creditsTotal': instance.creditsTotal,
      'avatarSlotsRemaining': instance.avatarSlotsRemaining,
      'avatarSlotsTotal': instance.avatarSlotsTotal,
      'recentActivity': instance.recentActivity.map((e) => e.toJson()).toList(),
    };

_SubscriptionActivity _$SubscriptionActivityFromJson(
  Map<String, dynamic> json,
) => _SubscriptionActivity(
  title: json['title'] as String,
  timeAgo: json['timeAgo'] as String,
  kind: json['kind'] as String,
  creditsDelta: (json['creditsDelta'] as num).toInt(),
  durationLabel: json['durationLabel'] as String?,
);

Map<String, dynamic> _$SubscriptionActivityToJson(
  _SubscriptionActivity instance,
) => <String, dynamic>{
  'title': instance.title,
  'timeAgo': instance.timeAgo,
  'kind': instance.kind,
  'creditsDelta': instance.creditsDelta,
  'durationLabel': ?instance.durationLabel,
};
