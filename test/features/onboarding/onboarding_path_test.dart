import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_answers.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_inputs.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_step.dart';

/// The onboarding's pure parts: the progress bar, the company-document gaps,
/// and the one write that ends it. The step ORDER is pinned by
/// onboarding_flow_test.dart, which drives the controller end to end.
void main() {
  /// The milestones each path counts — the web's `progressPct` order lists,
  /// with the brand question only while the company brand is open.
  List<OnboardingStep> path({required bool company, required bool brand}) =>
      <OnboardingStep>[
        OnboardingStep.welcome,
        if (brand) OnboardingStep.brand,
        OnboardingStep.connect,
        OnboardingStep.plan,
        if (company) ...<OnboardingStep>[
          OnboardingStep.companyPage,
          OnboardingStep.companyLogo,
          OnboardingStep.posterStyle,
          OnboardingStep.companyDoc,
        ] else
          OnboardingStep.cvUpload,
        OnboardingStep.styleChoice,
        OnboardingStep.finish,
      ];

  const List<(bool, bool)> variants = <(bool, bool)>[
    (false, false),
    (false, true),
    (true, false),
    (true, true),
  ];

  group('progress', () {
    test('every path reaches 100% at finish', () {
      for (final (bool c, bool b) in variants) {
        expect(
          OnboardingStep.finish.progressPercent(company: c, brandStep: b),
          100,
        );
      }
    });

    test('matches the web: (index + 1) / path length, never below 5%', () {
      for (final (bool c, bool b) in variants) {
        final List<OnboardingStep> steps = path(company: c, brand: b);
        for (int i = 0; i < steps.length; i++) {
          final int expected = ((i + 1) / steps.length * 100).round();
          expect(
            steps[i].progressPercent(company: c, brandStep: b),
            expected < 5 ? 5 : expected,
            reason: '${steps[i]} on company=$c brand=$b',
          );
        }
      }
    });

    test('a branch step reports the milestone it belongs to', () {
      // The web's resolvedStep: the bar neither jumps nor stalls on them.
      expect(
        OnboardingStep.currentRole.progressPercent(
          company: false,
          brandStep: false,
        ),
        OnboardingStep.cvUpload.progressPercent(
          company: false,
          brandStep: false,
        ),
      );
      expect(
        OnboardingStep.companyDetails.progressPercent(
          company: true,
          brandStep: false,
        ),
        OnboardingStep.companyDoc.progressPercent(
          company: true,
          brandStep: false,
        ),
      );
      for (final (bool c, bool b) in variants) {
        // The State is part of the plan's turn: asked of India buyers only,
        // so it never moves the bar on its own (the web's resolvedStep).
        expect(
          OnboardingStep.billingState.progressPercent(company: c, brandStep: b),
          OnboardingStep.plan.progressPercent(company: c, brandStep: b),
        );
        for (final OnboardingStep s in <OnboardingStep>[
          OnboardingStep.styleScreenshots,
          OnboardingStep.styleWrite,
        ]) {
          expect(
            s.progressPercent(company: c, brandStep: b),
            OnboardingStep.styleChoice.progressPercent(
              company: c,
              brandStep: b,
            ),
          );
        }
      }
    });
  });

  test('the State step is a panel whose line the controller writes', () {
    // A picker and a button — a form, not a choice of chips. Whether it is
    // asked at all depends on the region and on what is on record.
    expect(OnboardingStep.billingState.lane(), OnboardingLane.panel);
    expect(
      OnboardingStep.billingState.botLines(firstName: 'A', company: false),
      isEmpty,
    );
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
