// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      totalImpressions: (json['totalImpressions'] as num?)?.toInt() ?? 0,
      totalEngagements: (json['totalEngagements'] as num?)?.toInt() ?? 0,
      totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
      scheduledCount: (json['scheduledCount'] as num?)?.toInt() ?? 0,
      impressionsDelta: json['impressionsDelta'] as String? ?? '+0%',
      engagementsDelta: json['engagementsDelta'] as String? ?? '+0%',
      followersDelta: json['followersDelta'] as String? ?? '+0%',
      recentPosts:
          (json['recentPosts'] as List<dynamic>?)
              ?.map((e) => DashboardPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DashboardPost>[],
      mission: json['mission'] == null
          ? null
          : DashboardMission.fromJson(json['mission'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{
      'stats': instance.stats.toJson(),
      'totalImpressions': instance.totalImpressions,
      'totalEngagements': instance.totalEngagements,
      'totalFollowers': instance.totalFollowers,
      'scheduledCount': instance.scheduledCount,
      'impressionsDelta': instance.impressionsDelta,
      'engagementsDelta': instance.engagementsDelta,
      'followersDelta': instance.followersDelta,
      'recentPosts': instance.recentPosts.map((e) => e.toJson()).toList(),
      'mission': instance.mission?.toJson(),
    };

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      weeklyXp: (json['weeklyXp'] as num?)?.toInt() ?? 0,
      weeklyXpGoal: (json['weeklyXpGoal'] as num?)?.toInt() ?? 2000,
      level: (json['level'] as num?)?.toInt() ?? 1,
      levelTitle: json['levelTitle'] as String? ?? 'Beginner',
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'streakDays': instance.streakDays,
      'weeklyXp': instance.weeklyXp,
      'weeklyXpGoal': instance.weeklyXpGoal,
      'level': instance.level,
      'levelTitle': instance.levelTitle,
    };

_DashboardPost _$DashboardPostFromJson(Map<String, dynamic> json) =>
    _DashboardPost(
      id: json['id'] as String,
      preview: json['preview'] as String,
      status:
          $enumDecodeNullable(_$DashboardPostStatusEnumMap, json['status']) ??
          DashboardPostStatus.draft,
      impressions: (json['impressions'] as num?)?.toInt() ?? 0,
      engagements: (json['engagements'] as num?)?.toInt() ?? 0,
      hasMetrics: json['hasMetrics'] as bool? ?? false,
    );

Map<String, dynamic> _$DashboardPostToJson(_DashboardPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'preview': instance.preview,
      'status': _$DashboardPostStatusEnumMap[instance.status]!,
      'impressions': instance.impressions,
      'engagements': instance.engagements,
      'hasMetrics': instance.hasMetrics,
    };

const _$DashboardPostStatusEnumMap = {
  DashboardPostStatus.draft: 'draft',
  DashboardPostStatus.scheduled: 'scheduled',
  DashboardPostStatus.published: 'published',
  DashboardPostStatus.failed: 'failed',
};

_DashboardMission _$DashboardMissionFromJson(Map<String, dynamic> json) =>
    _DashboardMission(
      title: json['title'] as String,
      statusLabel: json['statusLabel'] as String? ?? 'Active',
    );

Map<String, dynamic> _$DashboardMissionToJson(_DashboardMission instance) =>
    <String, dynamic>{
      'title': instance.title,
      'statusLabel': instance.statusLabel,
    };
