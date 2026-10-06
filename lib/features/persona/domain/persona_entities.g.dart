// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubstanceItem _$SubstanceItemFromJson(Map<String, dynamic> json) =>
    _SubstanceItem(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? '',
      text: json['text'] as String? ?? '',
      entities:
          (json['entities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      hasNumber: json['hasNumber'] as bool? ?? false,
      source: json['source'] as String? ?? '',
      happenedAt: json['happenedAt'] == null
          ? null
          : DateTime.parse(json['happenedAt'] as String),
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
      usedInPostId: json['usedInPostId'] as String?,
    );

Map<String, dynamic> _$SubstanceItemToJson(_SubstanceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'text': instance.text,
      'entities': instance.entities,
      'hasNumber': instance.hasNumber,
      'source': instance.source,
      'happenedAt': instance.happenedAt?.toIso8601String(),
      'usedAt': instance.usedAt?.toIso8601String(),
      'usedInPostId': instance.usedInPostId,
    };

_SubstanceBank _$SubstanceBankFromJson(Map<String, dynamic> json) =>
    _SubstanceBank(
      available:
          (json['available'] as List<dynamic>?)
              ?.map((e) => SubstanceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubstanceItem>[],
      used:
          (json['used'] as List<dynamic>?)
              ?.map((e) => SubstanceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubstanceItem>[],
      availableCount: (json['availableCount'] as num?)?.toInt() ?? 0,
      usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
      unavailable: json['unavailable'] as bool? ?? false,
    );

Map<String, dynamic> _$SubstanceBankToJson(_SubstanceBank instance) =>
    <String, dynamic>{
      'available': instance.available.map((e) => e.toJson()).toList(),
      'used': instance.used.map((e) => e.toJson()).toList(),
      'availableCount': instance.availableCount,
      'usedCount': instance.usedCount,
      'unavailable': instance.unavailable,
    };

_FollowerReading _$FollowerReadingFromJson(Map<String, dynamic> json) =>
    _FollowerReading(
      count: (json['count'] as num?)?.toInt() ?? 0,
      measuredAt: json['measuredAt'] as String? ?? '',
    );

Map<String, dynamic> _$FollowerReadingToJson(_FollowerReading instance) =>
    <String, dynamic>{
      'count': instance.count,
      'measuredAt': instance.measuredAt,
    };

_FollowerGrowth _$FollowerGrowthFromJson(Map<String, dynamic> json) =>
    _FollowerGrowth(
      kind: json['kind'] as String? ?? 'none',
      days: (json['days'] as num?)?.toInt() ?? 0,
      gained: (json['gained'] as num?)?.toInt() ?? 0,
      latest: (json['latest'] as num?)?.toInt() ?? 0,
      perDay: (json['perDay'] as num?)?.toDouble() ?? 0,
      perMonth: (json['perMonth'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FollowerGrowthToJson(_FollowerGrowth instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'days': instance.days,
      'gained': instance.gained,
      'latest': instance.latest,
      'perDay': instance.perDay,
      'perMonth': instance.perMonth,
    };

_FollowerHistory _$FollowerHistoryFromJson(Map<String, dynamic> json) =>
    _FollowerHistory(
      readings:
          (json['readings'] as List<dynamic>?)
              ?.map((e) => FollowerReading.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FollowerReading>[],
      growth: json['growth'] == null
          ? const FollowerGrowth()
          : FollowerGrowth.fromJson(json['growth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FollowerHistoryToJson(_FollowerHistory instance) =>
    <String, dynamic>{
      'readings': instance.readings.map((e) => e.toJson()).toList(),
      'growth': instance.growth.toJson(),
    };

_PersonaReply _$PersonaReplyFromJson(Map<String, dynamic> json) =>
    _PersonaReply(
      reply: json['reply'] as String? ?? '',
      proposals:
          (json['proposals'] as List<dynamic>?)
              ?.map((e) => PersonaProposal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PersonaProposal>[],
    );

Map<String, dynamic> _$PersonaReplyToJson(_PersonaReply instance) =>
    <String, dynamic>{
      'reply': instance.reply,
      'proposals': instance.proposals.map((e) => e.toJson()).toList(),
    };

_PersonaProposal _$PersonaProposalFromJson(Map<String, dynamic> json) =>
    _PersonaProposal(
      field: json['field'] as String,
      to: json['to'] as String? ?? '',
      from: json['from'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$PersonaProposalToJson(_PersonaProposal instance) =>
    <String, dynamic>{
      'field': instance.field,
      'to': instance.to,
      'from': instance.from,
      'label': instance.label,
    };
