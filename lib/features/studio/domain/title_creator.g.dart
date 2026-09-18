// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfessionAnalysis _$ProfessionAnalysisFromJson(Map<String, dynamic> json) =>
    _ProfessionAnalysis(
      profession: json['profession'] as String? ?? 'Professional',
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

_TitleSuggestion _$TitleSuggestionFromJson(Map<String, dynamic> json) =>
    _TitleSuggestion(
      suggestedTitle: json['suggestedTitle'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
      tips: json['tips'] as String? ?? '',
    );

Map<String, dynamic> _$TitleSuggestionToJson(_TitleSuggestion instance) =>
    <String, dynamic>{
      'suggestedTitle': instance.suggestedTitle,
      'reasoning': instance.reasoning,
      'tips': instance.tips,
    };
