import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/platform/file_picking.dart';
import 'package:plexaverse/core/platform/image_picking.dart';
import 'package:plexaverse/features/onboarding/application/onboarding_chat_controller.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_repository.dart';

/// The onboarding runs in the web's order, on both paths.
///
/// This is the test the step ORDER lives in. The app's onboarding once asked
/// role, goal and voice before LinkedIn, had no CV import and no company
/// logo, poster or document — a different flow from the web's under the same
/// name. Each list below is the web's `OnboardingChat` path, read off its
/// `advance(...)` calls; if the web changes, change it there and here.
///
/// Runs on the in-memory fakes (the mock flavour's backend), with the pickers
/// replaced so a "file" is chosen without a platform channel.
class _Files implements FilePickingService {
  @override
  Future<FilePickResult> pick({required List<String> extensions}) async =>
      PickedFile(
        bytes: Uint8List(16),
        name: extensions.contains('pdf') ? 'profile.pdf' : 'logo.png',
      );
}

class _Images implements ImagePickingService {
  @override
  Future<ImagePickResult> pick(ImageSourceKind source) async =>
      PickedImage(bytes: Uint8List(16), name: 'shot.png');

  @override
  Future<List<PickedImage>> pickMany({required int limit}) async =>
      <PickedImage>[
        PickedImage(bytes: Uint8List(16), name: 'a.png'),
        PickedImage(bytes: Uint8List(16), name: 'b.png'),
      ];
}

void main() {
  late ProviderContainer container;
  late List<OnboardingStep> visited;

  OnboardingChatController chat() =>
      container.read(onboardingChatControllerProvider.notifier);
  OnboardingChatState state() =>
      container.read(onboardingChatControllerProvider);

  /// Lets Plexa finish typing. Her lines are timers, so the fake clock has to
  /// move — generously, because a step can say two lines after a slow upload.
  Future<void> settle(WidgetTester tester) async {
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  /// Starts the chat and records every step it enters, in order.
  Future<void> open(WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        filePickingProvider.overrideWithValue(_Files()),
        imagePickingProvider.overrideWithValue(_Images()),
      ],
    );
    addTearDown(container.dispose);
    visited = <OnboardingStep>[];
    container.listen<OnboardingChatState>(onboardingChatControllerProvider, (
      OnboardingChatState? _,
      OnboardingChatState next,
    ) {
      if (visited.isEmpty || visited.last != next.step) visited.add(next.step);
    }, fireImmediately: true);
    await settle(tester);
  }

  Future<void> act(WidgetTester tester, Future<void> Function() step) async {
    unawaited(step());
    await settle(tester);
  }

  testWidgets('personal, CV skipped: role, then a written sample', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().pickBrand(BrandChoice.personal));
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().skipCv());
    await act(tester, () => chat().pickRole('Software Engineer'));
    await act(tester, () => chat().chooseWrite());
    await act(
      tester,
      () => chat().submitVoiceSample(
        'Short sentences. One idea per line. No throat-clearing.',
      ),
    );

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.brand,
      OnboardingStep.connect,
      OnboardingStep.cvUpload,
      OnboardingStep.currentRole,
      OnboardingStep.styleChoice,
      OnboardingStep.styleWrite,
      OnboardingStep.finish,
    ]);
    expect(state().answers.cv?.profession, 'Software Engineer');
    expect(state().answers.usedCvUpload, isFalse);
    expect(state().completed, isTrue);
  });

  testWidgets('personal, CV imported: straight to the voice, via screenshots', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().pickBrand(BrandChoice.personal));
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().uploadCv());
    await act(tester, () => chat().chooseScreenshots());
    await act(tester, () => chat().uploadScreenshots());

    expect(visited, <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.brand,
      OnboardingStep.connect,
      OnboardingStep.cvUpload,
      OnboardingStep.styleChoice,
      OnboardingStep.styleScreenshots,
      OnboardingStep.finish,
    ]);
    expect(state().answers.usedCvUpload, isTrue);
    expect(state().answers.cv?.headline, isNotNull);
  });

  testWidgets(
    'company: page, logo, poster, document, details, then the voice',
    (WidgetTester tester) async {
      await open(tester);
      await act(tester, () => chat().acknowledgeWelcome());
      await act(tester, () => chat().pickBrand(BrandChoice.company));
      await act(tester, () => chat().connectLinkedin());
      await act(tester, () => chat().pickCompanyPage('1234567', 'Plexaverse'));
      await act(tester, () => chat().uploadLogo());
      await act(tester, () => chat().skipPosterStyle());
      // The mock document has no website, so it is too thin to write from.
      await act(tester, () => chat().uploadCompanyDoc());
      await act(
        tester,
        () => chat().submitCompanyDetails(
          description: 'Acme builds payment infrastructure for small shops.',
          industry: 'FinTech',
          tagline: '',
          features: <String>['Checkout links'],
          website: 'acme.in',
        ),
      );
      await act(tester, () => chat().skipScreenshots());
      await act(
        tester,
        () => chat().submitVoiceSample(
          'We ship payments that just work, so shops can sell.',
        ),
      );

      expect(visited, <OnboardingStep>[
        OnboardingStep.welcome,
        OnboardingStep.brand,
        OnboardingStep.connect,
        OnboardingStep.companyPage,
        OnboardingStep.companyLogo,
        OnboardingStep.posterStyle,
        OnboardingStep.companyDoc,
        OnboardingStep.companyDetails,
        OnboardingStep.styleChoice,
        OnboardingStep.styleWrite,
        OnboardingStep.finish,
      ]);
      expect(state().answers.companyLogoUrl, isNotNull);
      expect(state().answers.companyDoc?.website, 'acme.in');
      // The typed feature first, then the document's, deduplicated.
      expect(state().answers.companyDoc?.features.first, 'Checkout links');
    },
  );

  testWidgets('company with no usable page can switch to a personal brand', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().pickBrand(BrandChoice.company));
    await act(tester, () => chat().connectLinkedin());
    await act(tester, () => chat().switchToPersonal());
    await act(tester, () => chat().connectLinkedin());

    expect(visited.skip(2), <OnboardingStep>[
      OnboardingStep.connect,
      OnboardingStep.companyPage,
      OnboardingStep.connect,
      OnboardingStep.cvUpload,
    ]);
    expect(state().answers.brand, BrandChoice.personal);
  });

  testWidgets('connecting says who connected, and asks the web\'s line', (
    WidgetTester tester,
  ) async {
    await open(tester);
    await act(tester, () => chat().acknowledgeWelcome());
    await act(tester, () => chat().pickBrand(BrandChoice.personal));
    final List<String> lines = state().messages
        .map((ChatMessage m) => m.text)
        .toList();
    expect(
      lines.last,
      "I'll publish on your behalf and learn from your existing posts. "
      '+2,500 XP on connect.',
    );

    await act(tester, () => chat().connectLinkedin());
    expect(
      state().messages.map((ChatMessage m) => m.text),
      contains('Connected as Asang Borkar'),
    );
  });
}
