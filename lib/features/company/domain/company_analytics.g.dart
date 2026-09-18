// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowerCounts _$FollowerCountsFromJson(Map<String, dynamic> json) =>
    _FollowerCounts(
      organicFollowerCount:
          (json['organicFollowerCount'] as num?)?.toInt() ?? 0,
      paidFollowerCount: (json['paidFollowerCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FollowerCountsToJson(_FollowerCounts instance) =>
    <String, dynamic>{
      'organicFollowerCount': instance.organicFollowerCount,
      'paidFollowerCount': instance.paidFollowerCount,
    };

_GeoFollowerBucket _$GeoFollowerBucketFromJson(Map<String, dynamic> json) =>
    _GeoFollowerBucket(
      geo: json['geo'] as String?,
      followerCounts: json['followerCounts'] == null
          ? const FollowerCounts()
          : FollowerCounts.fromJson(
              json['followerCounts'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GeoFollowerBucketToJson(_GeoFollowerBucket instance) =>
    <String, dynamic>{
      'geo': instance.geo,
      'followerCounts': instance.followerCounts.toJson(),
    };

_StaffCountBucket _$StaffCountBucketFromJson(Map<String, dynamic> json) =>
    _StaffCountBucket(
      staffCountRange: json['staffCountRange'] as String?,
      followerCounts: json['followerCounts'] == null
          ? const FollowerCounts()
          : FollowerCounts.fromJson(
              json['followerCounts'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StaffCountBucketToJson(_StaffCountBucket instance) =>
    <String, dynamic>{
      'staffCountRange': instance.staffCountRange,
      'followerCounts': instance.followerCounts.toJson(),
    };

_PageViewCount _$PageViewCountFromJson(Map<String, dynamic> json) =>
    _PageViewCount(
      pageViews: (json['pageViews'] as num?)?.toInt() ?? 0,
      uniquePageViews: (json['uniquePageViews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PageViewCountToJson(_PageViewCount instance) =>
    <String, dynamic>{
      'pageViews': instance.pageViews,
      'uniquePageViews': instance.uniquePageViews,
    };

_CompanyPageStats _$CompanyPageStatsFromJson(Map<String, dynamic> json) =>
    _CompanyPageStats(
      views: json['views'] == null
          ? const <String, PageViewCount>{}
          : _viewsFromJson(json['views'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$CompanyPageStatsToJson(_CompanyPageStats instance) =>
    <String, dynamic>{'views': _viewsToJson(instance.views)};

_CompanyFollowerStats _$CompanyFollowerStatsFromJson(
  Map<String, dynamic> json,
) => _CompanyFollowerStats(
  followerCountsByGeoCountry:
      (json['followerCountsByGeoCountry'] as List<dynamic>?)
          ?.map((e) => GeoFollowerBucket.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GeoFollowerBucket>[],
  followerCountsByStaffCountRange:
      (json['followerCountsByStaffCountRange'] as List<dynamic>?)
          ?.map((e) => StaffCountBucket.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StaffCountBucket>[],
);

Map<String, dynamic> _$CompanyFollowerStatsToJson(
  _CompanyFollowerStats instance,
) => <String, dynamic>{
  'followerCountsByGeoCountry': instance.followerCountsByGeoCountry
      .map((e) => e.toJson())
      .toList(),
  'followerCountsByStaffCountRange': instance.followerCountsByStaffCountRange
      .map((e) => e.toJson())
      .toList(),
};

_CompanyAnalytics _$CompanyAnalyticsFromJson(Map<String, dynamic> json) =>
    _CompanyAnalytics(
      orgId: json['orgId'] as String?,
      followers: json['followers'] == null
          ? null
          : CompanyFollowerStats.fromJson(
              json['followers'] as Map<String, dynamic>,
            ),
      pageStats: json['pageStats'] == null
          ? null
          : CompanyPageStats.fromJson(
              json['pageStats'] as Map<String, dynamic>,
            ),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$CompanyAnalyticsToJson(_CompanyAnalytics instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'followers': instance.followers?.toJson(),
      'pageStats': instance.pageStats?.toJson(),
      'timestamp': instance.timestamp,
    };
