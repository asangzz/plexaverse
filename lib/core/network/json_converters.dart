import 'package:freezed_annotation/freezed_annotation.dart';

/// Round-trips an OpenAPI `format: date` field as `YYYY-MM-DD`.
///
/// json_serializable's default DateTime handling parses both shapes but
/// always *serialises* via `toIso8601String()` (a full date-time), which a
/// backend strictly validating `format: date` would reject. Annotate
/// date-only fields with `@DateOnlyConverter()` so the wire format matches
/// the contract in both directions.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String().split('T').first;
}

/// Nullable variant of [DateOnlyConverter].
class DateOnlyConverterNullable implements JsonConverter<DateTime?, String?> {
  const DateOnlyConverterNullable();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? object) =>
      object?.toIso8601String().split('T').first;
}
