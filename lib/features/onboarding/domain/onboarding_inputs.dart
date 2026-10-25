/// What the onboarding uploads come back as — the web's `CVData`, its
/// `companyDoc` and its `posterStyle` state.
library;

/// `POST /ai/parse-cv` — the LinkedIn profile PDF, read.
///
/// Also what the current-role answer becomes when the CV is skipped: the web
/// seeds `parsedCV = { profession: role }`, so the finalise write does not
/// care which way the profession arrived.
class ParsedCv {
  const ParsedCv({
    this.headline,
    this.profession,
    this.industry,
    this.summary,
    this.skills,
    this.positions,
    this.education,
  });

  factory ParsedCv.fromJson(Map<String, dynamic> json) => ParsedCv(
    headline: _string(json['headline']),
    profession: _string(json['profession']),
    industry: _string(json['industry']),
    summary: _string(json['summary']),
    skills: (json['skills'] as List<Object?>?)?.whereType<String>().toList(),
    // Passed through untouched: the server owns their shape and the web sends
    // them back exactly as parse-cv returned them.
    positions: json['positions'],
    education: json['education'],
  );

  final String? headline;
  final String? profession;
  final String? industry;
  final String? summary;
  final List<String>? skills;
  final Object? positions;
  final Object? education;

  /// The CV as the roadmap route's `cvData` — the same object the web posts.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'headline': ?headline,
    'profession': ?profession,
    'industry': ?industry,
    'summary': ?summary,
    'skills': ?skills,
    'positions': ?positions,
    'education': ?education,
  };

  static String? _string(Object? v) =>
      v is String && v.trim().isNotEmpty ? v : null;
}

/// `POST /ai/parse-company-doc`, or the company-details form that fills in
/// what the document did not say.
class CompanyDoc {
  const CompanyDoc({
    this.description = '',
    this.industry = '',
    this.tagline = '',
    this.features = const <String>[],
    this.website = '',
  });

  factory CompanyDoc.fromJson(Map<String, dynamic> json) => CompanyDoc(
    description: (json['description'] as String?) ?? '',
    industry: (json['industry'] as String?) ?? '',
    tagline: (json['tagline'] as String?) ?? '',
    features:
        (json['features'] as List<Object?>?)?.whereType<String>().toList() ??
        const <String>[],
    website: (json['website'] as String?) ?? '',
  );

  final String description;
  final String industry;
  final String tagline;
  final List<String> features;
  final String website;
}

/// The web's `GENERIC_INDUSTRY` — answers that name no industry at all.
const Set<String> kGenericIndustry = <String>{
  '',
  'general',
  'the field',
  'company',
  'n/a',
  'na',
  'unknown',
  'other',
};

/// What a company document is still missing. The web's `companyDocGaps`.
///
/// "Sufficient" means a real description, a real industry, at least one
/// product or service, and a website — the website is printed on generated
/// posters, so a missing one leaves a blank where it goes.
class CompanyDocGaps {
  factory CompanyDocGaps.of(CompanyDoc? doc) => CompanyDocGaps._(
    needDescription: (doc?.description.trim().length ?? 0) < 40,
    needIndustry:
        doc == null ||
        doc.industry.trim().isEmpty ||
        kGenericIndustry.contains(doc.industry.trim().toLowerCase()),
    needFeatures:
        doc == null ||
        doc.features.where((String f) => f.trim().isNotEmpty).isEmpty,
    needWebsite: doc == null || doc.website.trim().isEmpty,
  );

  const CompanyDocGaps._({
    required this.needDescription,
    required this.needIndustry,
    required this.needFeatures,
    required this.needWebsite,
  });

  final bool needDescription;
  final bool needIndustry;
  final bool needFeatures;
  final bool needWebsite;

  bool get sufficient =>
      !needDescription && !needIndustry && !needFeatures && !needWebsite;
}

/// `POST /ai/analyze-poster-style` — the theme and brand colours a reference
/// poster uses.
class PosterStyle {
  const PosterStyle({
    this.theme,
    this.primaryColor,
    this.secondaryColor,
    this.layout,
  });

  factory PosterStyle.fromJson(Map<String, dynamic> json) => PosterStyle(
    theme: switch (json['theme']) {
      'light' => 'light',
      'dark' => 'dark',
      _ => null,
    },
    primaryColor: _color(json['primaryColor']),
    secondaryColor: _color(json['secondaryColor']),
    layout: json['layout'] is Map<String, dynamic>
        ? json['layout'] as Map<String, dynamic>
        : null,
  );

  /// `dark` or `light`.
  final String? theme;
  final String? primaryColor;
  final String? secondaryColor;
  final Map<String, dynamic>? layout;

  static String? _color(Object? v) =>
      v is String && v.trim().isNotEmpty ? v : null;
}
