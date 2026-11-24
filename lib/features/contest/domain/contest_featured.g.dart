// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_featured.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeaturedPerson _$FeaturedPersonFromJson(Map<String, dynamic> json) =>
    _FeaturedPerson(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      headline: json['headline'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );

Map<String, dynamic> _$FeaturedPersonToJson(_FeaturedPerson instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'image': instance.image,
      'headline': instance.headline,
      'linkedinUrl': instance.linkedinUrl,
    };

_LearnersOfWeek _$LearnersOfWeekFromJson(Map<String, dynamic> json) =>
    _LearnersOfWeek(
      state:
          $enumDecodeNullable(
            _$LearnersOfWeekStateEnumMap,
            json['state'],
            unknownValue: LearnersOfWeekState.none,
          ) ??
          LearnersOfWeekState.none,
      weekStart: json['weekStart'] as String? ?? '',
      weekEnd: json['weekEnd'] as String? ?? '',
      learners:
          (json['learners'] as List<dynamic>?)
              ?.map((e) => FeaturedPerson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FeaturedPerson>[],
    );

Map<String, dynamic> _$LearnersOfWeekToJson(_LearnersOfWeek instance) =>
    <String, dynamic>{
      'state': _$LearnersOfWeekStateEnumMap[instance.state]!,
      'weekStart': instance.weekStart,
      'weekEnd': instance.weekEnd,
      'learners': instance.learners.map((e) => e.toJson()).toList(),
    };

const _$LearnersOfWeekStateEnumMap = {
  LearnersOfWeekState.none: 'none',
  LearnersOfWeekState.afterLesson: 'after_lesson',
  LearnersOfWeekState.noWeek: 'no_week',
  LearnersOfWeekState.ready: 'ready',
};

_HallOfFameWinner _$HallOfFameWinnerFromJson(Map<String, dynamic> json) =>
    _HallOfFameWinner(
      rank: (json['rank'] as num?)?.toInt(),
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      headline: json['headline'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );

Map<String, dynamic> _$HallOfFameWinnerToJson(_HallOfFameWinner instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'key': instance.key,
      'name': instance.name,
      'image': instance.image,
      'headline': instance.headline,
      'linkedinUrl': instance.linkedinUrl,
    };

_HallOfFameEntry _$HallOfFameEntryFromJson(Map<String, dynamic> json) =>
    _HallOfFameEntry(
      contestId: json['contestId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      lastDayKey: json['lastDayKey'] as String? ?? '',
      prizeTitle: json['prizeTitle'] as String? ?? '',
      rewardTopN: (json['rewardTopN'] as num?)?.toInt() ?? 0,
      finalisedAt: DateTime.parse(json['finalisedAt'] as String),
      featuredUntil: DateTime.parse(json['featuredUntil'] as String),
      winners:
          (json['winners'] as List<dynamic>?)
              ?.map((e) => HallOfFameWinner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HallOfFameWinner>[],
    );

Map<String, dynamic> _$HallOfFameEntryToJson(_HallOfFameEntry instance) =>
    <String, dynamic>{
      'contestId': instance.contestId,
      'title': instance.title,
      'lastDayKey': instance.lastDayKey,
      'prizeTitle': instance.prizeTitle,
      'rewardTopN': instance.rewardTopN,
      'finalisedAt': instance.finalisedAt.toIso8601String(),
      'featuredUntil': instance.featuredUntil.toIso8601String(),
      'winners': instance.winners.map((e) => e.toJson()).toList(),
    };

_ContestFeatured _$ContestFeaturedFromJson(Map<String, dynamic> json) =>
    _ContestFeatured(
      week: json['week'] == null
          ? const LearnersOfWeek()
          : LearnersOfWeek.fromJson(json['week'] as Map<String, dynamic>),
      hallOfFame:
          (json['hallOfFame'] as List<dynamic>?)
              ?.map((e) => HallOfFameEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HallOfFameEntry>[],
      viewerPlaced: json['viewerPlaced'] as bool? ?? false,
    );

Map<String, dynamic> _$ContestFeaturedToJson(_ContestFeatured instance) =>
    <String, dynamic>{
      'week': instance.week.toJson(),
      'hallOfFame': instance.hallOfFame.map((e) => e.toJson()).toList(),
      'viewerPlaced': instance.viewerPlaced,
    };

_ShoutoutSettings _$ShoutoutSettingsFromJson(Map<String, dynamic> json) =>
    _ShoutoutSettings(
      featured: json['featured'] as bool? ?? false,
      linkedinUrl: json['linkedinUrl'] as String?,
      adultDeclared: json['adultDeclared'] as bool? ?? false,
      stale: json['stale'] as bool? ?? false,
    );

Map<String, dynamic> _$ShoutoutSettingsToJson(_ShoutoutSettings instance) =>
    <String, dynamic>{
      'featured': instance.featured,
      'linkedinUrl': instance.linkedinUrl,
      'adultDeclared': instance.adultDeclared,
      'stale': instance.stale,
    };
