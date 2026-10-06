// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_voice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopVoice _$TopVoiceFromJson(Map<String, dynamic> json) => _TopVoice(
  shownId: json['shownId'] as String? ?? '',
  postId: json['postId'] as String? ?? '',
  postUrl: json['postUrl'] as String? ?? '',
  authorName: json['authorName'] as String? ?? '',
  authorHandle: json['authorHandle'] as String? ?? '',
  category: json['category'] as String? ?? '',
  postContent: json['postContent'] as String? ?? '',
  firstLine: json['firstLine'] as String?,
  postedAt: json['postedAt'] as String? ?? '',
  comment: json['comment'] as String?,
  actedAt: json['actedAt'] as String?,
);

Map<String, dynamic> _$TopVoiceToJson(_TopVoice instance) => <String, dynamic>{
  'shownId': instance.shownId,
  'postId': instance.postId,
  'postUrl': instance.postUrl,
  'authorName': instance.authorName,
  'authorHandle': instance.authorHandle,
  'category': instance.category,
  'postContent': instance.postContent,
  'firstLine': instance.firstLine,
  'postedAt': instance.postedAt,
  'comment': instance.comment,
  'actedAt': instance.actedAt,
};

_TopVoiceDay _$TopVoiceDayFromJson(Map<String, dynamic> json) => _TopVoiceDay(
  posts:
      (json['posts'] as List<dynamic>?)
          ?.map((e) => TopVoice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TopVoice>[],
  hasCategories: json['hasCategories'] as bool? ?? true,
);

Map<String, dynamic> _$TopVoiceDayToJson(_TopVoiceDay instance) =>
    <String, dynamic>{
      'posts': instance.posts.map((e) => e.toJson()).toList(),
      'hasCategories': instance.hasCategories,
    };
