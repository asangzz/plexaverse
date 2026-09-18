import 'package:freezed_annotation/freezed_annotation.dart';

part 'profession_analysis.freezed.dart';
part 'profession_analysis.g.dart';

/// What `POST /ai/analyze-profession` makes of a headline.
///
/// Mirrors the server's `ProfessionAnalysis` interface exactly
/// (`lib/services/ai.service.ts`). Every field is defaulted because the route
/// is documented never to 5xx for this call: when Gemini is missing or the
/// parse fails it returns a fallback shell so onboarding keeps moving, and a
/// client that required a field would turn that kindness back into a dead end.
@freezed
abstract class ProfessionAnalysis with _$ProfessionAnalysis {
  const factory ProfessionAnalysis({
    @Default('') String profession,
    @Default('') String industry,

    /// Ids from the server's `PROFILE_CATEGORIES`. Written straight to
    /// `preferences.postCategories`.
    @Default(<String>[]) List<String> suggestedCategories,
    @Default('') String expertise,
    @Default('') String roadmapTitle,
  }) = _ProfessionAnalysis;

  factory ProfessionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ProfessionAnalysisFromJson(json);
}
