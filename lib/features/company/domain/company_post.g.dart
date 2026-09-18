// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanyPostStats _$CompanyPostStatsFromJson(Map<String, dynamic> json) =>
    _CompanyPostStats(
      impressionCount: (json['impressionCount'] as num?)?.toInt() ?? 0,
      clickCount: (json['clickCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      engagement: (json['engagement'] as num?)?.toDouble() ?? 0,
      engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$CompanyPostStatsToJson(_CompanyPostStats instance) =>
    <String, dynamic>{
      'impressionCount': instance.impressionCount,
      'clickCount': instance.clickCount,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'engagement': instance.engagement,
      'engagementRate': instance.engagementRate,
    };

_CompanyPostItem _$CompanyPostItemFromJson(Map<String, dynamic> json) =>
    _CompanyPostItem(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      createdAt: (json['createdAt'] as num?)?.toInt(),
      isAdvocated: json['isAdvocated'] as bool? ?? false,
      advocacyExpiry: json['advocacyExpiry'] as String?,
      stats: json['stats'] == null
          ? const CompanyPostStats()
          : CompanyPostStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyPostItemToJson(_CompanyPostItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt,
      'isAdvocated': instance.isAdvocated,
      'advocacyExpiry': instance.advocacyExpiry,
      'stats': instance.stats.toJson(),
    };
