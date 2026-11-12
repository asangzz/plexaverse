import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/features/planner/data/planner_repositories.dart';
import 'package:plexaverse/features/planner/domain/display_phase.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/presentation/pages/planner_page.dart';

/// Users from the old endless loop are now on journey 2, and their stored
/// rows still carry that loop's phase names. No row is rewritten, so the
/// planner's chips are the only place those names can be kept off the screen.
///
/// A port of the web's `__tests__/components/planner-retired-phase.test.tsx`.
void main() {
  const List<String> retired = <String>[
    'Event Horizon',
    'Singularity',
    'Multiverse',
    'Time Dilation',
  ];

  group('displayPhase', () {
    for (final String name in <String>[
      ...retired,
      'event horizon',
      ' SINGULARITY ',
    ]) {
      test('hides "$name"', () => expect(displayPhase(name), isNull));
    }

    test('keeps a current phase name and hides an empty one', () {
      expect(displayPhase('Foundation'), 'Foundation');
      expect(displayPhase('  Credibility '), 'Credibility');
      expect(displayPhase(''), isNull);
      expect(displayPhase('   '), isNull);
      expect(displayPhase(null), isNull);
    });
  });

  group('a retired phase name never reaches the planner', () {
    Future<void> pump(WidgetTester tester, String phase) async {
      tester.view.physicalSize = const Size(402, 874) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            plannerRepositoryProvider.overrideWithValue(_PhasedPlanner(phase)),
          ],
          child: const MaterialApp(home: PlannerPage()),
        ),
      );
      // The fake answers after a delay; step past it rather than settling.
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
    }

    testWidgets('a current phase shows, as the header kicker', (
      WidgetTester tester,
    ) async {
      await pump(tester, 'Credibility');
      expect(find.text('CREDIBILITY'), findsOneWidget);
    });

    for (final String name in retired) {
      testWidgets('"$name" is hidden', (WidgetTester tester) async {
        await pump(tester, name);
        expect(find.text('Week 3'), findsOneWidget);
        expect(
          find.textContaining(RegExp(name, caseSensitive: false)),
          findsNothing,
        );
      });
    }
  });
}

/// The mock flavour's week, with its phase replaced by [phase].
class _PhasedPlanner extends FakePlannerRepository {
  _PhasedPlanner(this.phase);

  final String phase;

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) async {
    final PlannerState state = await super.fetchWeek(
      week: week,
      season: season,
    );
    final WeekPlan? plan = state.plan;
    return plan == null
        ? state
        : state.copyWith(plan: plan.copyWith(phase: phase));
  }
}
