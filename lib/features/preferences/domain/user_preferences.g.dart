// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      exists: json['exists'] as bool? ?? false,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      brandType: json['brandType'] as String? ?? 'personal',
      currentSeason: (json['currentSeason'] as num?)?.toInt() ?? 1,
      roadmapStartedAt: json['roadmapStartedAt'] == null
          ? null
          : DateTime.parse(json['roadmapStartedAt'] as String),
      seasonStartedAt: json['seasonStartedAt'] == null
          ? null
          : DateTime.parse(json['seasonStartedAt'] as String),
      postsPerWeek: (json['postsPerWeek'] as num?)?.toInt() ?? 7,
      preferredDays:
          (json['preferredDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[1, 3, 5],
      preferredTime: json['preferredTime'] as String? ?? '09:00',
      timezone: json['timezone'] as String? ?? 'Asia/Kolkata',
      autoPostEnabled: json['autoPostEnabled'] as bool? ?? true,
      contentStyle: json['contentStyle'] as String? ?? 'professional',
      contentMode: json['contentMode'] as String? ?? 'authority',
      priority: json['priority'] as String?,
      targetRole: json['targetRole'] as String?,
      profession: json['profession'] as String?,
      industry: json['industry'] as String?,
      headline: json['headline'] as String?,
      summary: json['summary'] as String?,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      postCategories:
          (json['postCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      serveRole: json['serveRole'] as String?,
      serveIndustry: json['serveIndustry'] as String?,
      problemSolved: json['problemSolved'] as String?,
      newsletterName: json['newsletterName'] as String?,
      companyPageId: json['companyPageId'] as String?,
      companyPageName: json['companyPageName'] as String?,
      companyDescription: json['companyDescription'] as String?,
      companyIndustry: json['companyIndustry'] as String?,
      companyTagline: json['companyTagline'] as String?,
      companyLogoUrl: json['companyLogoUrl'] as String?,
      companyWebsite: json['companyWebsite'] as String?,
      companyFeatures:
          (json['companyFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      posterTheme: json['posterTheme'] as String? ?? 'dark',
      posterPrimaryColor: json['posterPrimaryColor'] as String?,
      posterSecondaryColor: json['posterSecondaryColor'] as String?,
      approvalChannel: json['approvalChannel'] as String? ?? 'slack',
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'exists': instance.exists,
      'onboardingCompleted': instance.onboardingCompleted,
      'brandType': instance.brandType,
      'currentSeason': instance.currentSeason,
      'roadmapStartedAt': instance.roadmapStartedAt?.toIso8601String(),
      'seasonStartedAt': instance.seasonStartedAt?.toIso8601String(),
      'postsPerWeek': instance.postsPerWeek,
      'preferredDays': instance.preferredDays,
      'preferredTime': instance.preferredTime,
      'timezone': instance.timezone,
      'autoPostEnabled': instance.autoPostEnabled,
      'contentStyle': instance.contentStyle,
      'contentMode': instance.contentMode,
      'priority': instance.priority,
      'targetRole': instance.targetRole,
      'profession': instance.profession,
      'industry': instance.industry,
      'headline': instance.headline,
      'summary': instance.summary,
      'goals': instance.goals,
      'postCategories': instance.postCategories,
      'skills': instance.skills,
      'serveRole': instance.serveRole,
      'serveIndustry': instance.serveIndustry,
      'problemSolved': instance.problemSolved,
      'newsletterName': instance.newsletterName,
      'companyPageId': instance.companyPageId,
      'companyPageName': instance.companyPageName,
      'companyDescription': instance.companyDescription,
      'companyIndustry': instance.companyIndustry,
      'companyTagline': instance.companyTagline,
      'companyLogoUrl': instance.companyLogoUrl,
      'companyWebsite': instance.companyWebsite,
      'companyFeatures': instance.companyFeatures,
      'posterTheme': instance.posterTheme,
      'posterPrimaryColor': instance.posterPrimaryColor,
      'posterSecondaryColor': instance.posterSecondaryColor,
      'approvalChannel': instance.approvalChannel,
    };
