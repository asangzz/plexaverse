import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/onboarding/application/welcome_bonus.dart';
import 'package:plexaverse/features/onboarding/presentation/pages/onboarding_chat_page.dart';
import 'package:plexaverse/features/onboarding/presentation/widgets/chat_lane.dart';
import 'package:plexaverse/features/plexa/presentation/pages/plexa_journey_page.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_clips.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_mascot.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/domain/settings_entities.dart';
import 'package:plexaverse/features/settings/presentation/widgets/plexa_section.dart';
import 'package:video_player/video_player.dart';

/// Meet Plexa, and the Settings row that reaches it.
///
/// The row is the only way in — there is no nav entry — so a regression that
/// hides it strands the screen. It is shown to every user: it used to be
/// admin-only, and an end user's account must not bring that back.
void main() {
  Future<void> pumpSettingsRow(WidgetTester tester, {required String role}) {
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(child: PlexaSection()),
          ),
        ),
        GoRoute(path: ZaveRoutes.plexa, builder: (_, _) => const Text('intro')),
      ],
    );
    addTearDown(router.dispose);
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountSnapshotProvider.overrideWith(
            (Ref ref) async => AccountSnapshot(
              user: AccountIdentity(id: 'u1', role: role),
            ),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  for (final String role in <String>['user', 'admin']) {
    testWidgets('a $role sees Meet Plexa in Settings, and it opens /plexa', (
      WidgetTester tester,
    ) async {
      await pumpSettingsRow(tester, role: role);
      await tester.pumpAndSettle();

      expect(find.text('Meet Plexa'), findsOneWidget);
      await tester.tap(find.text('Meet Plexa'));
      await tester.pumpAndSettle();
      expect(find.text('intro'), findsOneWidget);
    });
  }

  group('the intro', () {
    Future<void> pumpIntro(WidgetTester tester, {bool freshBonus = false}) {
      tester.view.physicalSize = const Size(390, 844) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final GoRouter router = GoRouter(
        initialLocation: ZaveRoutes.plexa,
        routes: <RouteBase>[
          GoRoute(
            path: ZaveRoutes.plexa,
            builder: (_, _) => const PlexaJourneyPage(),
          ),
          GoRoute(
            path: ZaveRoutes.dashboard,
            builder: (_, _) => const Text('dashboard'),
          ),
        ],
      );
      addTearDown(router.dispose);
      return tester.pumpWidget(
        ProviderScope(
          // The onboarding chat after the intro runs on the in-memory fakes,
          // as the mock flavour does.
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            welcomeBonusProvider.overrideWith((Ref ref) async => freshBonus),
          ],
          child: MediaQuery(
            // Reduced motion: the still, and no player — a test has no video
            // plugin, and this is the path that must never show an empty box.
            data: const MediaQueryData(
              size: Size(390, 844),
              disableAnimations: true,
            ),
            child: MaterialApp.router(routerConfig: router),
          ),
        ),
      );
    }

    Finder still(PlexaClip clip) => find.byWidgetPredicate(
      (Widget w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == clip.still,
    );

    testWidgets('greets, and shows the still under reduced motion', (
      WidgetTester tester,
    ) async {
      await pumpIntro(tester);
      await tester.pump();

      expect(find.text('Hi there, I am Plexa'), findsOneWidget);
      expect(find.byType(VideoPlayer), findsNothing);
      expect(still(PlexaClip.hello), findsOneWidget);
    });

    testWidgets(
      'Continue walks hello → excited → notes, then opens the onboarding chat '
      'under the mascot, as on the web',
      (WidgetTester tester) async {
        await pumpIntro(tester);
        await tester.pump();

        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        expect(
          find.text('Glad you like it, we are excited to move ahead…'),
          findsOneWidget,
        );
        expect(find.text('Hi there, I am Plexa'), findsNothing);
        expect(still(PlexaClip.excited), findsOneWidget);

        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        expect(
          find.text('Let me note down a few things about you…'),
          findsOneWidget,
        );
        expect(still(PlexaClip.notes), findsOneWidget);

        await tester.tap(find.text('Continue'));
        // Not pumpAndSettle: the chat's typing dots never settle.
        for (int i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(find.byType(OnboardingChatBody), findsOneWidget);
        // No titled bar over the chat: its own top row is the top bar.
        expect(find.text('Plexa setup'), findsNothing);
        // The intro has faded out and left the tree...
        expect(find.text('Continue'), findsNothing);
        // ...and Plexa is still the one mascot — holding her notepad, with no
        // second Plexa beside her messages.
        expect(find.byType(PlexaMascot), findsOneWidget);
        expect(still(PlexaClip.notes), findsOneWidget);
        expect(find.byType(PlexaAvatar), findsNothing);
        expect(find.text('PLEXA'), findsWidgets);
      },
    );

    bool held(WidgetTester tester) =>
        tester.widget<PlexaMascot>(find.byType(PlexaMascot)).hold;

    testWidgets('a fresh welcome bonus is celebrated, and Plexa waits for it', (
      WidgetTester tester,
    ) async {
      await pumpIntro(tester, freshBonus: true);
      await tester.pump();

      expect(find.text('+2,500 XP'), findsOneWidget);
      // Her entrance would happen behind the overlay where nobody sees it.
      expect(held(tester), isTrue);

      await tester.tap(find.text('Tap anywhere to continue'));
      await tester.pump();
      expect(find.text('+2,500 XP'), findsNothing);
      expect(held(tester), isFalse);
    });

    testWidgets('the celebration also leaves by itself after four seconds', (
      WidgetTester tester,
    ) async {
      await pumpIntro(tester, freshBonus: true);
      await tester.pump();
      expect(find.text('+2,500 XP'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(find.text('+2,500 XP'), findsNothing);
    });

    testWidgets('no fresh bonus: no celebration, and nothing held', (
      WidgetTester tester,
    ) async {
      await pumpIntro(tester);
      await tester.pump();
      expect(find.text('+2,500 XP'), findsNothing);
      expect(held(tester), isFalse);
    });

    test('every clip and still is bundled', () {
      // pubspec bundles assets/videos/ whole, so a clip missing from disk
      // fails only at runtime, on the step that needs it.
      for (final PlexaClip clip in PlexaClip.values) {
        expect(File(clip.video).existsSync(), isTrue, reason: clip.video);
        expect(File(clip.still).existsSync(), isTrue, reason: clip.still);
      }
    });
  });
}
