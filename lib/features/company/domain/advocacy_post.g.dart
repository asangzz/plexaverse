// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advocacy_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdvocacyAccount _$AdvocacyAccountFromJson(Map<String, dynamic> json) =>
    _AdvocacyAccount(
      profileName: json['profileName'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      profileSlug: json['profileSlug'] as String?,
    );

Map<String, dynamic> _$AdvocacyAccountToJson(_AdvocacyAccount instance) =>
    <String, dynamic>{
      'profileName': instance.profileName,
      'profileImage': instance.profileImage,
      'profileSlug': instance.profileSlug,
    };

_AdvocacyMetrics _$AdvocacyMetricsFromJson(Map<String, dynamic> json) =>
    _AdvocacyMetrics(
      impressions: (json['impressions'] as num?)?.toInt() ?? 0,
      clicks: (json['clicks'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      reactions: (json['reactions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdvocacyMetricsToJson(_AdvocacyMetrics instance) =>
    <String, dynamic>{
      'impressions': instance.impressions,
      'clicks': instance.clicks,
      'comments': instance.comments,
      'shares': instance.shares,
      'reactions': instance.reactions,
    };

_AdvocacyPost _$AdvocacyPostFromJson(Map<String, dynamic> json) =>
    _AdvocacyPost(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      linkedinPostId: json['linkedinPostId'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      publishedAt: json['publishedAt'] as String?,
      isAdvocated: json['isAdvocated'] as bool? ?? false,
      advocacyExpiry: json['advocacyExpiry'] as String?,
      account: json['account'] == null
          ? null
          : AdvocacyAccount.fromJson(json['account'] as Map<String, dynamic>),
      metrics: json['metrics'] == null
          ? null
          : AdvocacyMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdvocacyPostToJson(_AdvocacyPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'linkedinPostId': instance.linkedinPostId,
      'linkedinUrl': instance.linkedinUrl,
      'publishedAt': instance.publishedAt,
      'isAdvocated': instance.isAdvocated,
      'advocacyExpiry': instance.advocacyExpiry,
      'account': instance.account?.toJson(),
      'metrics': instance.metrics?.toJson(),
    };
