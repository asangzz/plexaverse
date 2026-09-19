import 'package:freezed_annotation/freezed_annotation.dart';

import 'onboarding_step.dart';

part 'onboarding_answers.freezed.dart';

/// Everything the conversation has collected so far.
///
/// Accumulated turn by turn and written ONCE, at [toPreferencesPatch], when the
/// user reaches the finish step — the same shape as the web's finalise effect,
/// which builds one `preferences` object and `await`s a single write.
///
/// Nothing is persisted mid-conversation on purpose. A partial preferences row
/// reads as "onboarded" to some of the code that branches on it, and a user who
/// abandons the chat halfway would land on a dashboard configured by half an
/// answer.
@freezed
abstract class OnboardingAnswers with _$OnboardingAnswers {
  const OnboardingAnswers._();

  const factory OnboardingAnswers({
    BrandChoice? brand,

    /// The `current-role` answer. Becomes `preferences.profession`.
    String? role,
    OnboardingGoal? goal,

    /// The writing sample. Saved separately to the style memory (it is an
    /// embedding, not a preferences column), and kept here only so a failed
    /// save can be retried without re-asking.
    String? voiceSample,

    /// **Company brand only.** The LinkedIn page company posts publish to.
    /// Without it `brandType: 'company'` is a setting with nowhere to act.
    String? companyPageId,
    String? companyPageName,

    /// **Company brand only.** The company document. These anchor every
    /// generated company post, which is why the flow asks rather than
    /// letting the model infer a company from its page name.
    String? companyDescription,
    String? companyIndustry,
    String? companyTagline,

    /// Filled from `POST /ai/analyze-profession`, which the web calls with the
    /// user's headline. Best-effort: all three stay null when the call fails,
    /// and the finalise simply sends less.
    String? profession,
    String? industry,
    @Default(<String>[]) List<String> postCategories,
  }) = _OnboardingAnswers;

  /// The PATCH body for `/user/preferences`.
  ///
  /// **Partial by design.** The mobile endpoint is a partial upsert and strips
  /// undefined fields server-side, so only answered questions are sent; a key
  /// with a null value would overwrite a column the user never touched. This
  /// mirrors the web's finalise, which spreads each optional field in only when
  /// it has a value.
  ///
  /// `contentMode` is fixed to `'authority'` — the web's own fallback, and the
  /// only value reachable there now that `TRANSFORMATION_ONBOARDING_ENABLED` is
  /// false.
  Map<String, dynamic> toPreferencesPatch() {
    final BrandChoice brandType = brand ?? BrandChoice.personal;

    return <String, dynamic>{
      'onboardingCompleted': true,
      // The web sets this from whether the CV import was used. This flow has no
      // CV import at all, so it is always false and is sent explicitly rather
      // than left to whatever the column happened to hold.
      'cvUploaded': false,
      'brandType': brandType.id,
      'priority': brandType.priority,
      'contentMode': 'authority',
      if (goal != null) 'goals': <String>[goal!.id],
      if (_nonEmpty(profession ?? role)) 'profession': profession ?? role,
      if (_nonEmpty(industry)) 'industry': industry,
      if (postCategories.isNotEmpty) 'postCategories': postCategories,
      // Company fields only on the company path. Sending them empty on a
      // personal account would write blank strings over columns the user may
      // have filled in elsewhere.
      if (brandType == BrandChoice.company) ...<String, dynamic>{
        if (_nonEmpty(companyPageId)) 'companyPageId': companyPageId,
        if (_nonEmpty(companyPageName)) 'companyPageName': companyPageName,
        if (_nonEmpty(companyDescription))
          'companyDescription': companyDescription,
        if (_nonEmpty(companyIndustry)) 'companyIndustry': companyIndustry,
        if (_nonEmpty(companyTagline)) 'companyTagline': companyTagline,
      },
    };
  }

  static bool _nonEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;
}
