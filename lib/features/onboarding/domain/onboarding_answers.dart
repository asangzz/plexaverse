import 'package:freezed_annotation/freezed_annotation.dart';

import 'onboarding_inputs.dart';
import 'onboarding_step.dart';

part 'onboarding_answers.freezed.dart';

/// Everything the chat has collected, and the one write that ends onboarding.
@freezed
abstract class OnboardingAnswers with _$OnboardingAnswers {
  const OnboardingAnswers._();

  const factory OnboardingAnswers({
    BrandChoice? brand,

    /// The LinkedIn profile PDF was imported. Sent as `cvUploaded`.
    @Default(false) bool usedCvUpload,

    /// The parsed CV — or, when the CV was skipped, just the role the user
    /// picked, as `profession`. The web keeps both in one `parsedCV`.
    ParsedCv? cv,

    String? companyPageId,
    String? companyPageName,

    /// The parsed company document, merged with the details form.
    CompanyDoc? companyDoc,

    String? companyLogoUrl,
    PosterStyle? posterStyle,
  }) = _OnboardingAnswers;

  bool get isCompany => brand == BrandChoice.company;

  /// The body of `PATCH /user/preferences` — the web's finalise `preferences`
  /// object, field for field.
  ///
  /// Values are capped to the server's validation limits so a long paste or a
  /// verbose model answer cannot 400 the whole finalise. Absent and blank
  /// answers are left OUT rather than sent empty, so a skipped step leaves its
  /// columns as they were instead of writing blanks over them.
  Map<String, dynamic> toPreferencesPatch() {
    final BrandChoice brandType = brand ?? BrandChoice.personal;
    final bool company = brandType == BrandChoice.company;
    final ParsedCv? cv = this.cv;
    final CompanyDoc? doc = companyDoc;
    final PosterStyle? poster = posterStyle;

    return <String, dynamic>{
      'onboardingCompleted': true,
      'cvUploaded': usedCvUpload,
      'brandType': brandType.id,
      'priority': brandType.priority,
      // The career-transition choice is hidden on the web, so every account
      // is created on the authority arc.
      'contentMode': 'authority',
      if (company && _nonEmpty(companyPageId)) ...<String, dynamic>{
        'companyPageId': companyPageId,
        'companyPageName': companyPageName,
      },
      if (cv != null) ...<String, dynamic>{
        'headline': ?cv.headline,
        'profession': ?cv.profession,
        'industry': ?cv.industry,
        'summary': ?cv.summary,
        'skills': ?cv.skills,
        'positions': ?cv.positions,
        'education': ?cv.education,
      },
      if (company) ...<String, dynamic>{
        if (doc != null) ...<String, dynamic>{
          // Blank fields are left out rather than written as "" — which the
          // web does — so a user who runs the chat again from /plexa does not
          // lose a tagline they set in Settings to a document without one.
          if (_nonEmpty(doc.description))
            'companyDescription': _cap(doc.description.trim(), 2000),
          if (_nonEmpty(doc.industry))
            'companyIndustry': _cap(doc.industry.trim(), 200),
          if (_nonEmpty(doc.tagline))
            'companyTagline': _cap(doc.tagline.trim(), 300),
          if (doc.features.isNotEmpty)
            'companyFeatures': doc.features
                .map((String f) => _cap(f.trim(), 300))
                .where((String f) => f.isNotEmpty)
                .take(40)
                .toList(),
          if (_nonEmpty(doc.website))
            'companyWebsite': _cap(doc.website.trim(), 200),
        },
        'companyLogoUrl': ?companyLogoUrl,
        if (poster != null) ...<String, dynamic>{
          'posterTheme': ?poster.theme,
          if (poster.primaryColor != null)
            'posterPrimaryColor': _cap(poster.primaryColor!, 32),
          if (poster.secondaryColor != null)
            'posterSecondaryColor': _cap(poster.secondaryColor!, 32),
          'posterLayout': ?poster.layout,
        },
      },
    };
  }

  static bool _nonEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _cap(String value, int max) =>
      value.length <= max ? value : value.substring(0, max);
}
