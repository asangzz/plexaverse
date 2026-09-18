// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profession_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfessionAnalysis _$ProfessionAnalysisFromJson(Map<String, dynamic> json) =>
    _ProfessionAnalysis(
      profession: json['profession'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      suggestedCategories:
          (json['suggestedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      expertise: json['expertise'] as String? ?? '',
      roadmapTitle: json['roadmapTitle'] as String? ?? '',
    );

Map<String, dynamic> _$ProfessionAnalysisToJson(_ProfessionAnalysis instance) =>
    <String, dynamic>{
      'profession': instance.profession,
      'industry': instance.industry,
      'suggestedCategories': instance.suggestedCategories,
      'expertise': instance.expertise,
      'roadmapTitle': instance.roadmapTitle,
    };
