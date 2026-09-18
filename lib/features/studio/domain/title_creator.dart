import 'package:freezed_annotation/freezed_annotation.dart';

part 'title_creator.freezed.dart';
part 'title_creator.g.dart';

/// Who the headline is written FOR.
///
/// **Deliberate departure from the web.** The web's two cards are labelled
/// "Build Personal Brand" and "Get Hired", and it POSTs the literal id
/// `get_hired`. The mobile route only accepts `personal_brand` | `recruiter`
/// and coerces anything else to `undefined`, at which point the server falls
/// back to the stored preference — so a mobile client copying the web's string
/// would silently generate the WRONG kind of headline and look like it worked.
/// The user-facing labels stay the web's; only the wire value is corrected.
enum TitlePriority {
  personalBrand,
  recruiter;

  String get wire =>
      this == TitlePriority.personalBrand ? 'personal_brand' : 'recruiter';

  /// The card title, verbatim from the web.
  String get label => this == TitlePriority.personalBrand
      ? 'Build Personal Brand'
      : 'Get Hired';

  /// The card subtitle, verbatim from the web.
  String get description => this == TitlePriority.personalBrand
      ? 'Establish yourself as a thought leader'
      : 'Attract recruiters and job opportunities';

  /// The eyebrow over the generated headline.
  String get resultKicker => this == TitlePriority.personalBrand
      ? 'Generated for personal brand'
      : 'Generated for job search';
}

/// What `POST /ai/analyze-profession` reads out of a headline.
///
/// Free — no XP gate — and the service returns a usable shell rather than a
/// 5xx when Gemini is unavailable, so this step can never wedge the wizard.
@freezed
abstract class ProfessionAnalysis with _$ProfessionAnalysis {
  const factory ProfessionAnalysis({
    @Default('Professional') String profession,
    @Default('') String industry,
    @Default(<String>[]) List<String> suggestedCategories,
    @Default('') String expertise,
    @Default('') String roadmapTitle,
  }) = _ProfessionAnalysis;

  factory ProfessionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ProfessionAnalysisFromJson(json);
}

/// What `POST /ai/suggest-title` gives back.
///
/// XP is charged only on the AI path: when Gemini is down the service returns
/// a deterministic template for free. The response shape is identical either
/// way, so the client cannot — and should not — tell the difference.
@freezed
abstract class TitleSuggestion with _$TitleSuggestion {
  const TitleSuggestion._();

  const factory TitleSuggestion({
    @Default('') String suggestedTitle,

    /// The web labels this "Strategic Logic".
    @Default('') String reasoning,

    /// The web labels this "Authority Tip".
    @Default('') String tips,
  }) = _TitleSuggestion;

  factory TitleSuggestion.fromJson(Map<String, dynamic> json) =>
      _$TitleSuggestionFromJson(json);

  bool get isEmpty => suggestedTitle.trim().isEmpty;
}
