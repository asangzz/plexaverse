// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyArticle _$WeeklyArticleFromJson(Map<String, dynamic> json) =>
    _WeeklyArticle(
      id: json['id'] as String,
      weekNumber: (json['weekNumber'] as num).toInt(),
      season: (json['season'] as num).toInt(),
      title: json['title'] as String? ?? '',
      thesis: json['thesis'] as String?,
      body: json['body'] as String? ?? '',
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      readingMinutes: (json['readingMinutes'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'ready',
      publishedAt: json['publishedAt'] as String?,
      publishedUrl: json['publishedUrl'] as String?,
    );

Map<String, dynamic> _$WeeklyArticleToJson(_WeeklyArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weekNumber': instance.weekNumber,
      'season': instance.season,
      'title': instance.title,
      'thesis': instance.thesis,
      'body': instance.body,
      'sections': instance.sections,
      'readingMinutes': instance.readingMinutes,
      'status': instance.status,
      'publishedAt': instance.publishedAt,
      'publishedUrl': instance.publishedUrl,
    };

_ArticleState _$ArticleStateFromJson(Map<String, dynamic> json) =>
    _ArticleState(
      article: json['article'] == null
          ? null
          : WeeklyArticle.fromJson(json['article'] as Map<String, dynamic>),
      newsletterName: json['newsletterName'] as String?,
      newsletterCreatedAt: json['newsletterCreatedAt'] as String?,
      isFirstArticle: json['isFirstArticle'] as bool? ?? false,
      weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
      season: (json['season'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ArticleStateToJson(_ArticleState instance) =>
    <String, dynamic>{
      'article': instance.article?.toJson(),
      'newsletterName': instance.newsletterName,
      'newsletterCreatedAt': instance.newsletterCreatedAt,
      'isFirstArticle': instance.isFirstArticle,
      'weekNumber': instance.weekNumber,
      'season': instance.season,
    };
