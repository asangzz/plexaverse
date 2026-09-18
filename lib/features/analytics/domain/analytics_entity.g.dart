// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopPostSummary _$TopPostSummaryFromJson(Map<String, dynamic> json) =>
    _TopPostSummary(
      postId: (json['postId'] as num).toInt(),
      preview: json['preview'] as String,
      impressions: (json['impressions'] as num?)?.toInt() ?? 0,
      engagements: (json['engagements'] as num?)?.toInt() ?? 0,
      engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TopPostSummaryToJson(_TopPostSummary instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'preview': instance.preview,
      'impressions': instance.impressions,
      'engagements': instance.engagements,
      'engagementRate': instance.engagementRate,
    };

_AnalyticsEntity _$AnalyticsEntityFromJson(Map<String, dynamic> json) =>
    _AnalyticsEntity(
      totalImpressions: (json['totalImpressions'] as num?)?.toInt() ?? 0,
      totalEngagements: (json['totalEngagements'] as num?)?.toInt() ?? 0,
      totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
      impressionsDelta: (json['impressionsDelta'] as num?)?.toDouble() ?? 0.0,
      engagementsDelta: (json['engagementsDelta'] as num?)?.toDouble() ?? 0.0,
      followersDelta: (json['followersDelta'] as num?)?.toDouble() ?? 0.0,
      reactions: (json['reactions'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      reposts: (json['reposts'] as num?)?.toInt() ?? 0,
      reactionsDelta: (json['reactionsDelta'] as num?)?.toDouble() ?? 0.0,
      commentsDelta: (json['commentsDelta'] as num?)?.toDouble() ?? 0.0,
      repostsDelta: (json['repostsDelta'] as num?)?.toDouble() ?? 0.0,
      impressionSeries:
          (json['impressionSeries'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const <double>[],
      topPost: json['topPost'] == null
          ? null
          : TopPostSummary.fromJson(json['topPost'] as Map<String, dynamic>),
      weekdayImpressions:
          (json['weekdayImpressions'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[0, 0, 0, 0, 0, 0, 0],
    );

Map<String, dynamic> _$AnalyticsEntityToJson(_AnalyticsEntity instance) =>
    <String, dynamic>{
      'totalImpressions': instance.totalImpressions,
      'totalEngagements': instance.totalEngagements,
      'totalFollowers': instance.totalFollowers,
      'impressionsDelta': instance.impressionsDelta,
      'engagementsDelta': instance.engagementsDelta,
      'followersDelta': instance.followersDelta,
      'reactions': instance.reactions,
      'comments': instance.comments,
      'reposts': instance.reposts,
      'reactionsDelta': instance.reactionsDelta,
      'commentsDelta': instance.commentsDelta,
      'repostsDelta': instance.repostsDelta,
      'impressionSeries': instance.impressionSeries,
      'topPost': instance.topPost?.toJson(),
      'weekdayImpressions': instance.weekdayImpressions,
    };
