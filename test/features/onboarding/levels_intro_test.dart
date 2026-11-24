import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/links/plexaverse.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/features/contest/domain/levels_words.dart';
import 'package:plexaverse/features/onboarding/application/onboarding_chat_controller.dart';
import 'package:plexaverse/features/onboarding/domain/onboarding_repository.dart';
import 'package:plexaverse/features/onboarding/presentation/pages/onboarding_chat_page.dart';

/// Onboarding's last step (owner, 24 Nov 2026): after the save, before
/// Level 1, Plexa says how levels, XP and the shoutout work — the web's
/// `LEVELS_INTRO`, word for word — and the one chip, "Start Level 1", hands
/// over to the levels. The published rules open beside it, on the web.
void main() {
  test('the words are the web’s, word for word', () {
    // lib/levels-copy.ts LEVELS_INTRO, 24 Nov 2026.
    expect(kLevelsIntroLines, <String>[
      'Last thing: how your levels work. Every day you pass levels — a short English lesson, then a few LinkedIn tasks — and each level you pass earns XP.',
      // The paid condition, before anyone scores (review of 24 Nov 2026).
      'Levels are free to take. In each round your first month of XP is free too; after that, XP counts only while you have a Plexaverse plan — the lessons stay open either way.',
      'Levels reset every 3 months. When they reset, the learners with the most XP get a shoutout: their profile becomes a level every learner sees, where learners follow them on LinkedIn and on Plexaverse and earn XP for it.',
      'A shoutout is recognition only — it has no cash value.',
    ]);
    expect(kLevelsIntroStart, 'Start Level 1');
    expect(kLevelsIntroRules, 'How levels, XP and shoutouts work');
    expect(kRoundMonths, 3);
  });

  testWidgets('the step draws its lines, "Start Level 1" and the rules link; '
      'the chip hands over and the link opens the rules', (
    WidgetTester tester,
  ) async {
    // Tall enough that the whole thread is built at once.
    // (Four lines since review added the paid condition, 24 Nov 2026.)
    tester.view.physicalSize = const Size(1290, 6000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final _Opener opener = _Opener();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        linkOpeningProvider.overrideWithValue(opener),
        onboardingChatControllerProvider.overrideWith(_AtLevelsIntro.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: OnboardingChatBody())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    for (final String line in kLevelsIntroLines) {
      expect(find.text(line), findsOneWidget, reason: line);
    }
    expect(find.text(kLevelsIntroStart), findsOneWidget);
    expect(find.text(kLevelsIntroRules), findsOneWidget);

    await tester.tap(find.text(kLevelsIntroRules));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opener.opened, <String>[plexaverseLevelsRulesUrl]);
    expect(
      container.read(onboardingChatControllerProvider).completed,
      isFalse,
      reason: 'the rules are a link, not the answer',
    );

    await tester.tap(find.text(kLevelsIntroStart));
    await tester.pump(const Duration(milliseconds: 100));
    final OnboardingChatState after = container.read(
      onboardingChatControllerProvider,
    );
    expect(after.completed, isTrue);
    expect(after.messages.last.text, kLevelsIntroStart);
    expect(after.messages.last.role, ChatRole.user);
    // The hand-over is the gate's; let its write settle.
    await tester.pump(const Duration(seconds: 1));
  });
}

/// The chat at its last step, as the save leaves it: the levels explained.
class _AtLevelsIntro extends OnboardingChatController {
  @override
  OnboardingChatState build() => OnboardingChatState(
    step: OnboardingStep.levelsIntro,
    hasUserSent: true,
    messages: <ChatMessage>[
      for (final (int i, String line) in kLevelsIntroLines.indexed)
        ChatMessage(id: 'b$i', role: ChatRole.bot, text: line),
    ],
  );
}

class _Opener implements LinkOpeningService {
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return const LinkOpened();
  }
}
