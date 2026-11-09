import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/missions/application/journey_controller.dart';
import 'package:plexaverse/features/missions/application/missions_controllers.dart';
import 'package:plexaverse/features/missions/domain/missions_repository.dart';
import 'package:plexaverse/features/missions/presentation/pages/journey_complete_page.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';

/// The journey-complete screen: day 1000 is a finish line, and the screen
/// offers "Start a new journey" (optional new target role) or "Keep going for
/// now". It replaced Season Complete, so it must never say "season" and never
/// show wallet XP.
void main() {
  final UserPreferences finished = UserPreferences.fromJson(<String, dynamic>{
    'exists': true,
    'onboardingCompleted': true,
    'targetRole': 'Staff Engineer',
    'roadmapStartedAt': '2024-02-14T00:00:00.000Z',
    'journeyCompletedAt': '2026-11-09T00:00:00.000Z',
  });

  final UserPreferences running = UserPreferences.fromJson(<String, dynamic>{
    'exists': true,
    'onboardingCompleted': true,
    'currentSeason': 2,
    'roadmapStartedAt': DateTime.now()
        .subtract(const Duration(days: 41))
        .toIso8601String(),
  });

  late _RecordingStart start;
  late GoRouter router;

  /// Home underneath, the page pushed over it — the way the app reaches it.
  ///
  /// [deepLink] opens the page as the first location instead, with nothing
  /// under it, the way a notification or `/season-complete` does. Home is
  /// then [_GatedHome], which offers the page the way the real home does.
  Future<ProviderContainer> pump(
    WidgetTester tester,
    UserPreferences prefs, {
    JourneyStartResult answer = const JourneyStartResult(
      alreadyAdvanced: false,
      journeyNumber: 2,
    ),
    bool deepLink = false,
  }) async {
    tester.view.physicalSize = const Size(375, 667) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    start = _RecordingStart(answer);
    router = GoRouter(
      initialLocation: deepLink
          ? ZaveRoutes.journeyComplete
          : ZaveRoutes.dashboard,
      routes: <RouteBase>[
        GoRoute(
          path: ZaveRoutes.dashboard,
          builder: (_, _) => deepLink
              ? const _GatedHome()
              : const Scaffold(body: Text('HOME')),
        ),
        GoRoute(
          path: ZaveRoutes.journeyComplete,
          builder: (_, _) => const JourneyCompletePage(),
        ),
      ],
    );
    addTearDown(router.dispose);

    final ProviderContainer container = ProviderContainer(
      overrides: [
        envProvider.overrideWithValue(Env.mock),
        preferencesControllerProvider.overrideWith(() => _FixedPrefs(prefs)),
        seasonRecapProvider.overrideWith(
          (Ref ref) async => const SeasonRecap(
            roadmapDay: 1000,
            postsPublished: 100,
            postsAtLeast: true,
          ),
        ),
        journeyStartControllerProvider.overrideWith(() => start),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    if (!deepLink) router.push(ZaveRoutes.journeyComplete);
    await tester.pumpAndSettle();
    return container;
  }

  /// The buttons sit below the fold on the narrowest phone; scroll first.
  Future<void> tapButton(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
  }

  /// Every string on screen, for the copy rules.
  String allText(WidgetTester tester) => tester
      .widgetList<Text>(find.byType(Text))
      .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
      .join('\n');

  testWidgets('celebrates day 1000 and offers both answers', (
    WidgetTester tester,
  ) async {
    await pump(tester, finished);

    expect(find.text('You reached day 1,000.'), findsOneWidget);
    expect(find.text('100+'), findsOneWidget);
    expect(find.text('Start a new journey'), findsWidgets);
    expect(find.text('Keep going for now'), findsOneWidget);
    // The current role is offered as the default to keep.
    expect(find.text('Keep "Staff Engineer"'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('never says season and never shows XP', (
    WidgetTester tester,
  ) async {
    await pump(tester, finished);
    final String text = allText(tester);
    expect(text.toLowerCase(), isNot(contains('season')));
    expect(text, isNot(contains('XP')));
  });

  testWidgets('start sends the typed role, then goes home', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pump(tester, finished);

    await tester.enterText(find.byType(TextField), '  Head of Product  ');
    await tapButton(tester, find.text('Start a new journey').last);
    await tester.pumpAndSettle();

    expect(start.calls, <String?>['Head of Product']);
    expect(find.text('HOME'), findsOneWidget);
    expect(container.read(journeyCompletePromptProvider), isTrue);
  });

  testWidgets('a blank role is sent as none', (WidgetTester tester) async {
    await pump(tester, finished);
    await tapButton(tester, find.text('Start a new journey').last);
    await tester.pumpAndSettle();
    expect(start.calls, <String?>[null]);
  });

  testWidgets('keep going returns home and is remembered for the session', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pump(tester, finished);

    await tapButton(tester, find.text('Keep going for now'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(start.calls, isEmpty);
    expect(container.read(journeyCompletePromptProvider), isTrue);
  });

  testWidgets('a refused start on an unfinished journey changes nothing', (
    WidgetTester tester,
  ) async {
    // The device clock ran ahead: the app saw day 1000, the server did not.
    // The alias answers alreadyAdvanced with the SAME journey number.
    await pump(
      tester,
      finished,
      answer: const JourneyStartResult(alreadyAdvanced: true, journeyNumber: 1),
    );

    await tapButton(tester, find.text('Start a new journey').last);
    await tester.pumpAndSettle();

    expect(start.calls, <String?>[null]);
    expect(find.text('Your journey is not finished yet.'), findsOneWidget);
    expect(find.text('Your new journey starts today.'), findsNothing);
    expect(find.text('HOME'), findsNothing);
    // Still on the page (its heading is scrolled above the button).
    expect(find.text('Keep going for now'), findsOneWidget);
  });

  testWidgets('a start another device already made still goes home', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      finished,
      answer: const JourneyStartResult(alreadyAdvanced: true, journeyNumber: 2),
    );

    await tapButton(tester, find.text('Start a new journey').last);
    await tester.pumpAndSettle();

    expect(find.text('Your new journey starts today.'), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('being shown records the offer, so home does not push it back', (
    WidgetTester tester,
  ) async {
    // Opened by a deep link, then left by the system back — not by any of
    // the page's own buttons.
    final ProviderContainer container = await pump(
      tester,
      finished,
      deepLink: true,
    );
    expect(find.text('You reached day 1,000.'), findsOneWidget);
    expect(container.read(journeyCompletePromptProvider), isTrue);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    // Nothing under a cold deep link: the app is backgrounded, and coming
    // back lands on home.
    router.go(ZaveRoutes.dashboard);
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('You reached day 1,000.'), findsNothing);
  });

  testWidgets('a deep link mid-journey says it is still running', (
    WidgetTester tester,
  ) async {
    await pump(tester, running);

    expect(find.text('JOURNEY 2'), findsOneWidget);
    expect(find.text('Day 42 of 1,000'), findsOneWidget);
    expect(find.text('Start a new journey'), findsNothing);
  });
}

class _FixedPrefs extends PreferencesController {
  _FixedPrefs(this._prefs);

  final UserPreferences _prefs;

  @override
  Future<UserPreferences> build() async => _prefs;
}

/// Records each start instead of posting it, and answers [answer].
class _RecordingStart extends JourneyStartController {
  _RecordingStart(this.answer);

  final JourneyStartResult answer;
  final List<String?> calls = <String?>[];

  @override
  Future<JourneyStartResult> start({String? targetRole}) async {
    calls.add(targetRole);
    return answer;
  }
}

/// The real home's offer, reduced to its gate: push the page once a session
/// when the journey is finished and the offer was not already made. The real
/// one is private to home_page.dart; this keeps the same rule.
class _GatedHome extends ConsumerStatefulWidget {
  const _GatedHome();

  @override
  ConsumerState<_GatedHome> createState() => _GatedHomeState();
}

class _GatedHomeState extends ConsumerState<_GatedHome> {
  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<UserPreferences>>(
      preferencesControllerProvider,
      (AsyncValue<UserPreferences>? _, AsyncValue<UserPreferences> next) {
        final UserPreferences? prefs = next.value;
        if (prefs == null || !prefs.journeyFinished) return;
        if (ref.read(journeyCompletePromptProvider)) return;
        ref.read(journeyCompletePromptProvider.notifier).markHandled();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.push(ZaveRoutes.journeyComplete);
        });
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('HOME'));
}
