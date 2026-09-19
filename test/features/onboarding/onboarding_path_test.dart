import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_answers.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_step.dart';

/// The onboarding path forks, and the two things that go wrong when a flow
/// forks are both pinned here: a personal user seeing a company step, and a
/// progress bar that never fills because it counts steps that user will
/// never reach.
void main() {
  group('progress', () {
    test('a personal user reaches 100% at finish', () {
      // The company steps exist in the enum but not on this path. Counting
      // them would strand the bar in the eighties at the exact moment the
      // user finishes, which reads as something having gone wrong.
      expect(OnboardingStep.finish.progressPercent(company: false), 100);
    });

    test('a company user also reaches 100% at finish', () {
      expect(OnboardingStep.finish.progressPercent(company: true), 100);
    });

    test('never reports below 5%, so step one looks like progress', () {
      expect(
        OnboardingStep.welcome.progressPercent(company: false),
        greaterThanOrEqualTo(5),
      );
    });

    test('a company user is further from done at the same step', () {
      expect(
        OnboardingStep.connect.progressPercent(company: true),
        lessThan(OnboardingStep.connect.progressPercent(company: false)),
      );
    });

    test('progress never goes backwards along either path', () {
      for (final bool company in <bool>[false, true]) {
        final List<OnboardingStep> path = OnboardingStep.values
            .where((OnboardingStep s) => company || !s.isCompanyOnly)
            .toList();
        int last = 0;
        for (final OnboardingStep step in path) {
          final int pct = step.progressPercent(company: company);
          expect(pct, greaterThanOrEqualTo(last),
              reason: '$step went backwards on company=$company');
          last = pct;
        }
      }
    });
  });

  group('the finalise patch', () {
    test('a personal account sends no company fields', () {
      // Sending them empty would write blank strings over columns the user
      // may have filled in elsewhere.
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.personal,
        role: 'Engineer',
        companyDescription: 'left over from a changed mind',
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch.containsKey('companyDescription'), isFalse);
      expect(patch['brandType'], 'personal');
    });

    test('a company account sends the page and the document', () {
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.company,
        companyPageId: '123',
        companyPageName: 'Plexaverse',
        companyDescription: 'We automate LinkedIn for founders.',
        companyIndustry: 'SaaS',
      );
      final Map<String, dynamic> patch = a.toPreferencesPatch();
      expect(patch['brandType'], 'company');
      expect(patch['companyPageId'], '123');
      expect(patch['companyDescription'], 'We automate LinkedIn for founders.');
      expect(patch['companyIndustry'], 'SaaS');
      // Not answered — absent, not empty.
      expect(patch.containsKey('companyTagline'), isFalse);
    });

    test('blank company answers are omitted, not written as empty strings', () {
      const OnboardingAnswers a = OnboardingAnswers(
        brand: BrandChoice.company,
        companyDescription: '   ',
      );
      expect(a.toPreferencesPatch().containsKey('companyDescription'), isFalse);
    });
  });

  test('only the two company steps are company-only', () {
    final List<OnboardingStep> companyOnly = OnboardingStep.values
        .where((OnboardingStep s) => s.isCompanyOnly)
        .toList();
    expect(companyOnly, <OnboardingStep>[
      OnboardingStep.companyPage,
      OnboardingStep.companyDetails,
    ]);
  });
}
