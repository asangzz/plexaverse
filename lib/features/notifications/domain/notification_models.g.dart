// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: $enumDecode(
        _$NotificationCategoryEnumMap,
        json['category'],
        unknownValue: NotificationCategory.system,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      read: json['read'] as bool,
      route: json['route'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'category': _$NotificationCategoryEnumMap[instance.category]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'read': instance.read,
      'route': ?instance.route,
    };

const _$NotificationCategoryEnumMap = {
  NotificationCategory.postPublished: 'post_published',
  NotificationCategory.postScheduled: 'post_scheduled',
  NotificationCategory.postFailed: 'post_failed',
  NotificationCategory.missionComplete: 'mission_complete',
  NotificationCategory.xpEarned: 'xp_earned',
  NotificationCategory.analytics: 'analytics',
  NotificationCategory.system: 'general',
};
