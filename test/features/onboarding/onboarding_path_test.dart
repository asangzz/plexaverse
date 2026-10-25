import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_answers.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_inputs.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_step.dart';

/// The onboarding's pure parts: the progress bar, the company-document gaps,
/// and the one write that ends it. The step ORDER is pinned by
/// onboarding_flow_test.dart, which drives the controller end to end.
void main() {
  /// The milestones each path counts — the web's `progressPct` order lists.
  const List<OnboardingStep> personal = <OnboardingStep>[
    OnboardingStep.welcome,
    OnboardingStep.brand,
    OnboardingStep.connect,
    OnboardingStep.cvUpload,
    OnboardingStep.styleChoice,
    OnboardingStep.finish,
  ];
  const List<OnboardingStep> company = <OnboardingStep>[
    OnboardingStep.welcome,
    OnboardingStep.brand,
    OnboardingStep.connect,
    OnboardingStep.companyPage,
    OnboardingStep.companyLogo,
    OnboardingStep.posterStyle,
    OnboardingStep.companyDoc,
    OnboardingStep.styleChoice,
    OnboardingStep.finish,
  ];

  group('progress', () {
    test('both paths reach 100% at finish', () {
      expect(OnboardingStep.finish.progressPercent(company: false), 100);
      expect(OnboardingStep.finish.progressPercent(company: true), 100);
    });

    test('matches the web: (index + 1) / path length, never below 5%', () {
      for (final (bool c, List<OnboardingStep> path)
          in <(bool, List<OnboardingStep>)>[
            (false, personal),
            (true, company),
          ]) {
        for (int i = 0; i < path.length; i++) {
          final int expected = ((i + 1) / path.length * 100).round();
          expect(
            path[i].progressPercent(company: c),
            expected < 5 ? 5 : expected,
            reason: '${path[i]} on company=$c',
          );
        }
      }
    });

    test('a branch step reports the milestone it belongs to', () {
      // The web's resolvedStep: the bar neither jumps nor stalls on them.
      expect(
        OnboardingStep.currentRole.progressPercent(company: false),
        OnboardingStep.cvUpload.progressPercent(company: false),
      );
      expect(
        OnboardingStep.companyDetails.progressPercent(company: true),
        OnboardingStep.companyDoc.progressPercent(company: true),
      );
      for (final bool c in <bool>[false, true]) {
        for (final OnboardingStep s in <OnboardingStep>[
          OnboardingStep.styleScreenshots,
          OnboardingStep.styleWrite,
        ]) {
          expect(
            s.progressPercent(company: c),
            OnboardingStep.styleChoice.progressPercent(company: c),
          );
        }
      }
    });
  });

  group('company document gaps', () {
    test('no document needs everything', () {
      final CompanyDocGaps g = CompanyDocGaps.of(null);
      expect(g.sufficient, isFalse);
      expect(<bool>[
        g.needDescription,
        g.needIndustry,
        g.needFeatures,
        g.needWebsite,
      ], everyElement(isTrue));
    });

    test('a generic industry is no industry', () {
      const CompanyDoc doc = CompanyDoc(
        description:
            'We build payment infrastructure for small online shops in India.',
        industry: 'General',
        features: <String>['Checkout links'],
        website: 'acme.in',
      );
      expect(CompanyDocGaps.of(doc).needIndustry, isTrue);
    });

    test('a full document is sufficient', () {
      const CompanyDoc doc = CompanyDoc(
        description:
            'We build payment infrastructure for small online shops in India.',
        industry: 'FinTech',
        features: <String>['Checkout links'],
        website: 'acme.in',
      );
      expect(CompanyDocGaps.of(doc).sufficient, isTrue);
    });
  });

  group('the finalise patch', () {
    test('a personal account sends no company fields', () {
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.personal,
        cv: ParsedCv(profession: 'Engineer'),
        companyDoc: CompanyDoc(description: 'left over from a changed mind'),
        companyLogoUrl: 'https://x/logo.png',
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch['brandType'], 'personal');
      expect(patch['priority'], 'personal_brand');
      expect(patch['profession'], 'Engineer');
      expect(patch.containsKey('companyDescription'), isFalse);
      expect(patch.containsKey('companyLogoUrl'), isFalse);
    });

    test('an imported CV sends its fields and cvUploaded', () {
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.personal,
        usedCvUpload: true,
        cv: ParsedCv(
          headline: 'Senior Engineer',
          profession: 'Software Engineer',
          industry: 'Technology',
          skills: <String>['Go'],
        ),
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch['cvUploaded'], isTrue);
      expect(patch['headline'], 'Senior Engineer');
      expect(patch['industry'], 'Technology');
      expect(patch['skills'], <String>['Go']);
      // The web hard-codes authority while the transition choice is hidden.
      expect(patch['contentMode'], 'authority');
      // The web never asks for a goal, so none is written.
      expect(patch.containsKey('goals'), isFalse);
    });

    test('a company account sends the page, the document and the brand', () {
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.company,
        companyPageId: '123',
        companyPageName: 'Plexaverse',
        companyDoc: CompanyDoc(
          description: 'We automate LinkedIn for founders.',
          industry: 'SaaS',
          features: <String>['Auto-posting', '  '],
          website: 'plexaverse.com',
        ),
        companyLogoUrl: 'https://x/logo.png',
        posterStyle: PosterStyle(theme: 'dark', primaryColor: '#5761EB'),
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch['brandType'], 'company');
      expect(patch['priority'], 'company_brand');
      expect(patch['companyPageId'], '123');
      expect(patch['companyDescription'], 'We automate LinkedIn for founders.');
      expect(patch['companyIndustry'], 'SaaS');
      expect(patch['companyFeatures'], <String>['Auto-posting']);
      expect(patch['companyWebsite'], 'plexaverse.com');
      expect(patch['companyLogoUrl'], 'https://x/logo.png');
      expect(patch['posterTheme'], 'dark');
      expect(patch['posterPrimaryColor'], '#5761EB');
      // Not answered — absent, not empty.
      expect(patch.containsKey('companyTagline'), isFalse);
      expect(patch.containsKey('posterSecondaryColor'), isFalse);
    });

    test('blank company answers are omitted, not written as empty strings', () {
      // A user re-running the chat from /plexa must not lose a field they set
      // in Settings to a document that left it blank.
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.company,
        companyDoc: CompanyDoc(description: '   '),
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch.containsKey('companyDescription'), isFalse);
      expect(patch.containsKey('companyTagline'), isFalse);
    });

    test('long answers are capped to the server limits', () {
      final OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.company,
        companyDoc: CompanyDoc(description: 'x' * 2500),
      );
      expect(
        (a.toPreferencesPatch()['companyDescription'] as String).length,
        2000,
      );
    });
  });
}
