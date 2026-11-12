import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/placement/data/placement_repositories.dart';
import 'package:plexaverse/features/placement/domain/placement_repository.dart';
import 'package:plexaverse/features/placement/domain/placement_words.dart';
import 'package:plexaverse/features/placement/presentation/widgets/placement_level_hint.dart';

import 'placement_harness.dart';

/// The placement page's four screens and the intro's three variants, in the
/// web's words, at every phone width the app ships on — and the contest's
/// "Set your level first" hint.
class _StatusFails extends FakePlacementRepository {
  _StatusFails() : super(latency: Duration.zero);

  @override
  Future<PlacementStatus> fetchStatus() async =>
      throw const PlacementUnavailable('Could not load your placement.');
}

void main() {
  const Map<String, Size> sizes = <String, Size>{
    'iPhone SE': Size(375, 667),
    'iPhone 17': Size(402, 874),
    'iPhone 17 Pro Max': Size(430, 932),
  };

  group('the intro reads the status', () {
    testWidgets('never placed: the explainer, and Start', (tester) async {
      await pumpPlacement(tester, instantFake());

      expect(find.text('Find your level'), findsOneWidget);
      expect(
        find.text(
          'About 15 minutes. Three short parts and an optional writing task.',
        ),
        findsOneWidget,
      );
      expect(find.text('Writing, if you like'), findsOneWidget);
      expect(find.text('Start the test'), findsOneWidget);
      expect(find.text(placementDisclaimer), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('in progress: pick up where you left off', (tester) async {
      await pumpPlacement(
        tester,
        instantFake(seed: FakePlacementSeed.inProgress),
      );

      expect(find.text('Pick up where you left off'), findsOneWidget);
      expect(
        find.text('3 questions answered. Your answers are saved.'),
        findsOneWidget,
      );
      expect(find.textContaining('Continue by '), findsOneWidget);
      expect(find.textContaining(unfinishedRule), findsOneWidget);
      expect(find.text('Continue the test'), findsOneWidget);
    });

    testWidgets('cooling down: the level, the retake date, and the lesson', (
      tester,
    ) async {
      final GoRouter router = await pumpPlacement(
        tester,
        instantFake(seed: FakePlacementSeed.placed),
      );

      expect(find.text('Your level is set'), findsOneWidget);
      expect(
        find.textContaining('You can retake the test on '),
        findsOneWidget,
      );
      expect(find.text('B2'), findsWidgets);
      expect(find.text('Upper intermediate'), findsWidgets);
      expect(find.text('Add the writing'), findsOneWidget);
      expect(find.text(newLessonsLine(CefrBand.b2)), findsOneWidget);
      // No Start during the cooldown: the one primary button is the lesson.
      expect(find.text('Start the test'), findsNothing);

      await tapVisible(tester, find.text('Start today’s lesson'));
      expect(find.text('LESSON'), findsOneWidget);
      // The lesson took this page's place; back is the contest.
      router.pop();
      await settle(tester);
      expect(find.text('CONTEST'), findsOneWidget);
    });

    testWidgets('retake after a test that closed early says why the level is '
        'what it is', (tester) async {
      await pumpPlacement(tester, instantFake(seed: FakePlacementSeed.retake));

      expect(find.text('Check your level'), findsOneWidget);
      expect(
        find.textContaining('Your level is B1. Your result replaces it'),
        findsOneWidget,
      );
      expect(find.text(notTestedLabel), findsOneWidget);
      expect(find.text(closedEarlyLine), findsOneWidget);
      expect(find.text('Retake the test'), findsOneWidget);
      expect(find.text('Add writing to your last result'), findsOneWidget);
    });

    testWidgets('a status that cannot load offers Try again', (tester) async {
      await pumpPlacement(tester, _StatusFails());

      expect(find.text('Could not load the placement test'), findsOneWidget);
      expect(find.text('Could not load your placement.'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('a whole test: questions, writing, result', (tester) async {
    await pumpPlacement(tester, instantFake());
    await tapVisible(tester, find.text('Start the test'));

    expect(find.text('VOCABULARY'), findsOneWidget);
    expect(find.text('Part 1 of 3'), findsOneWidget);
    expect(find.text('Question 1 of about 12'), findsOneWidget);
    expect(
      find.text('Leave it for 24 hours and this test is cleared.'),
      findsOneWidget,
    );

    // Next waits for a pick.
    await tapVisible(tester, find.text('Next'));
    expect(find.text('Question 1 of about 12'), findsOneWidget);

    for (int i = 0; i < 12; i++) {
      await pickFirstOption(tester);
      await tapVisible(tester, find.text('Next'));
    }

    expect(find.text('One short piece'), findsOneWidget);
    expect(
      find.textContaining('Pressing Grade my writing is your agreement.'),
      findsOneWidget,
    );
    expect(find.text('0 / 1,200 characters'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Too short.');
    await tester.pump();
    expect(find.text('10 / 1,200 characters · 20 more to go'), findsOneWidget);

    await tapVisible(tester, find.text('Skip writing'));
    expect(find.text('Your result'), findsOneWidget);
    expect(find.text(placementDisclaimer), findsOneWidget);
    expect(find.textContaining('You can retake the test on '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the writing card says the learner agreed earlier once they '
      'have', (tester) async {
    final FakePlacementRepository repo = instantFake(
      seed: FakePlacementSeed.placed,
    );
    // Outside the test's fake clock: the fake answers on a real future.
    await tester.runAsync(repo.grantWritingConsent);
    await pumpPlacement(tester, repo);
    await tapVisible(tester, find.text('Add the writing'));

    expect(
      find.textContaining(
        'You agreed to this earlier. You can withdraw it in Settings.',
      ),
      findsOneWidget,
    );
  });

  for (final MapEntry<String, Size> size in sizes.entries) {
    group(size.key, () {
      for (final FakePlacementSeed seed in FakePlacementSeed.values) {
        testWidgets('${seed.name} intro fits', (tester) async {
          await pumpPlacement(
            tester,
            instantFake(seed: seed),
            size: size.value,
          );
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('a reading question fits', (tester) async {
        await pumpPlacement(tester, instantFake(), size: size.value);
        await tapVisible(tester, find.text('Start the test'));
        for (int i = 0; i < 8; i++) {
          await pickFirstOption(tester);
          await tapVisible(tester, find.text('Next'));
        }
        expect(find.text('READING'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }

  group('PlacementLevelHint', () {
    Future<GoRouter> pumpHint(WidgetTester tester, FakePlacementSeed seed) =>
        pumpPlacement(
          tester,
          instantFake(seed: seed),
          underneath: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20),
              child: PlacementLevelHint(),
            ),
          ),
          open: false,
        );

    testWidgets('asks a learner with no placement, and opens the test', (
      tester,
    ) async {
      await pumpHint(tester, FakePlacementSeed.fresh);

      expect(
        find.text(
          'Set your level first. It decides how hard your lessons are.',
        ),
        findsOneWidget,
      );
      await tapVisible(tester, find.text('Take the placement test'));
      expect(find.text('Find your level'), findsOneWidget);
    });

    testWidgets('says nothing once the learner has placed', (tester) async {
      await pumpHint(tester, FakePlacementSeed.placed);
      expect(find.text('Take the placement test'), findsNothing);
    });

    testWidgets('says nothing while the status cannot load', (tester) async {
      await pumpPlacement(
        tester,
        _StatusFails(),
        underneath: const Scaffold(body: PlacementLevelHint()),
        open: false,
      );
      expect(find.text('Take the placement test'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  test('the route the hint opens is the web\'s', () {
    expect(ZaveRoutes.placement, '/placement');
  });
}
