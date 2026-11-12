// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoardRow _$BoardRowFromJson(Map<String, dynamic> json) => _BoardRow(
  rank: (json['rank'] as num?)?.toInt() ?? 0,
  name: json['name'] as String?,
  image: json['image'] as String?,
  isViewer: json['isViewer'] as bool? ?? false,
  total: (json['total'] as num?)?.toInt() ?? 0,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  level: json['level'] as String? ?? 'B2',
);

Map<String, dynamic> _$BoardRowToJson(_BoardRow instance) => <String, dynamic>{
  'rank': instance.rank,
  'name': instance.name,
  'image': instance.image,
  'isViewer': instance.isViewer,
  'total': instance.total,
  'streak': instance.streak,
  'level': instance.level,
};

_BoardSelf _$BoardSelfFromJson(Map<String, dynamic> json) => _BoardSelf(
  total: (json['total'] as num?)?.toInt() ?? 0,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  level: json['level'] as String? ?? 'B2',
);

Map<String, dynamic> _$BoardSelfToJson(_BoardSelf instance) =>
    <String, dynamic>{
      'total': instance.total,
      'streak': instance.streak,
      'level': instance.level,
    };

_BoardResult _$BoardResultFromJson(Map<String, dynamic> json) => _BoardResult(
  revealed: json['revealed'] as bool? ?? false,
  revealsOn: json['revealsOn'] as String? ?? '',
  revealDay: (json['revealDay'] as num?)?.toInt() ?? 1,
  rows:
      (json['rows'] as List<dynamic>?)
          ?.map((e) => BoardRow.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BoardRow>[],
  viewer: json['viewer'] == null
      ? null
      : BoardRow.fromJson(json['viewer'] as Map<String, dynamic>),
  self: json['self'] == null
      ? null
      : BoardSelf.fromJson(json['self'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BoardResultToJson(_BoardResult instance) =>
    <String, dynamic>{
      'revealed': instance.revealed,
      'revealsOn': instance.revealsOn,
      'revealDay': instance.revealDay,
      'rows': instance.rows.map((e) => e.toJson()).toList(),
      'viewer': instance.viewer?.toJson(),
      'self': instance.self?.toJson(),
    };
