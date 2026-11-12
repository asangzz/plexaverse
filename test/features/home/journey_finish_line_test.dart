import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/home/presentation/pages/home_page.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';

/// The roadmap offers the journey-complete screen ONCE per app session when
/// the journey is finished, and is otherwise always the normal journey view —
/// there is no second (Season 2) mode any more.
///
/// "Once" is the load-bearing part: back from the finish screen lands on the
/// roadmap, and a roadmap that pushed again on every rebuild would be a
/// screen nobody could leave.
void main() {
  Future<(GoRouter, ProviderContainer)> pumpHome(
    WidgetTester tester,
    UserPreferences prefs,
  ) async {
    final GoRouter router = GoRouter(
      initialLocation: ZaveRoutes.roadmap,
      routes: <RouteBase>[
        GoRoute(path: ZaveRoutes.roadmap, builder: (_, _) => const HomePage()),
        GoRoute(
          path: ZaveRoutes.journeyComplete,
          builder: (_, _) => const Scaffold(body: Text('FINISH LINE')),
        ),
      ],
    );
    addTearDown(router.dispose);

    final ProviderContainer container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        preferencesControllerProvider.overrideWith(() => _FixedPrefs(prefs)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await settle(tester);
    return (router, container);
  }

  testWidgets('a finished journey pushes the finish line once', (
    WidgetTester tester,
  ) async {
    final (GoRouter router, ProviderContainer container) = await pumpHome(
      tester,
      UserPreferences.fromJson(<String, dynamic>{
        'exists': true,
        'onboardingCompleted': true,
        'roadmapStartedAt': '2023-01-01T00:00:00.000Z',
        'journeyCompletedAt': '2026-11-09T00:00:00.000Z',
      }),
    );

    expect(find.text('FINISH LINE'), findsOneWidget);

    // Back to the roadmap: the journey view is still there, and nothing
    // re-pushes — not even when the preferences refetch.
    router.pop();
    await settle(tester);
    expect(find.text('FINISH LINE'), findsNothing);

    container.invalidate(preferencesControllerProvider);
    await settle(tester);
    expect(find.text('FINISH LINE'), findsNothing);
  });

  testWidgets('a running journey 2 is the normal roadmap, no push', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      UserPreferences.fromJson(<String, dynamic>{
        'exists': true,
        'onboardingCompleted': true,
        'currentSeason': 2,
        'roadmapStartedAt': DateTime.now()
            .subtract(const Duration(days: 20))
            .toIso8601String(),
      }),
    );

    expect(find.text('FINISH LINE'), findsNothing);
    // The normal journey view's own controls, not a separate dashboard.
    expect(find.text('Open planner'), findsOneWidget);
    // Wallet XP is retired; the roadmap carries no balance pill.
    expect(find.textContaining(' XP'), findsNothing);
  });
}

/// Pumps in steps: the roadmap has looping animations and never settles.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

class _FixedPrefs extends PreferencesController {
  _FixedPrefs(this._prefs);

  final UserPreferences _prefs;

  @override
  Future<UserPreferences> build() async => _prefs;
}
