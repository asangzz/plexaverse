import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/home/domain/roadmap_level.dart';
import 'package:plexaverse/features/home/domain/roadmap_planets.dart';
import 'package:plexaverse/features/home/domain/roadmap_progress.dart';
import 'package:plexaverse/features/home/presentation/pages/home_page.dart';
import 'package:plexaverse/features/home/presentation/roadmap_status_ui.dart';
import 'package:plexaverse/features/home/presentation/widgets/roadmap_timeline.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The roadmap is a calendar of the journey (web, 12 Nov 2026): a day's place
/// on it is the date and nothing else, a day opens nothing, and the sheet
/// holds the planner and the two check-ins — not the day's missions, which are
/// the contest's now.
void main() {
  group('a day is behind, today, or ahead', () {
    test('read off the date alone', () {
      expect(roadmapDayStatus(47, 48), LevelStatus.completed);
      expect(roadmapDayStatus(48, 48), LevelStatus.active);
      expect(roadmapDayStatus(49, 48), LevelStatus.locked);
    });

    test("named in the web's words, with nothing for a day ahead", () {
      expect(roadmapStatusLabel(LevelStatus.completed), 'Travelled');
      expect(roadmapStatusLabel(LevelStatus.active), 'Today');
      expect(roadmapStatusLabel(LevelStatus.locked), isNull);
    });

    test('there is no missed day to name', () {
      // The missions verdict ("Steps Missed", "In Progress") went with the
      // missions; a status with no date behind it cannot come back.
      expect(LevelStatus.values, hasLength(3));
    });

    test('no step on the roadmap pays XP', () {
      final List<RoadmapLevel> days = buildRoadmap(
        RoadmapProgress(
          currentDay: 3,
          roadmapStartedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );
      for (final RoadmapLevel day in days) {
        for (final RoadmapStep step in day.steps) {
          expect(step.xpReward, 0, reason: 'day ${day.id} ${step.key}');
        }
      }
    });
  });

  group('the timeline', () {
    /// Day 48 of a journey nobody has ticked a step on: the window runs
    /// 35…55 and starts nowhere near day 1, which is the case that matters.
    Future<Rect> pumpTimeline(WidgetTester tester, {int today = 48}) async {
      tester.view.physicalSize = const Size(375, 667) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final List<RoadmapLevel> levels = buildRoadmap(
        RoadmapProgress(
          currentDay: today,
          roadmapStartedAt: DateTime.now().subtract(Duration(days: today - 1)),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 400,
                child: RoadmapTimeline(
                  levels: levels,
                  today: today,
                  topInset: 0,
                ),
              ),
            ),
          ),
        ),
      );
      // The active planet pulses for ever; step past the first frame and the
      // post-frame scroll instead of settling.
      for (int i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      return tester.getRect(find.byType(RoadmapTimeline));
    }

    testWidgets('opens on today, even far from day 1', (
      WidgetTester tester,
    ) async {
      final Rect viewport = await pumpTimeline(tester);
      final double rowHeight = viewport.height * 25 / 58;

      final Offset today = tester.getCenter(find.text('TODAY'));
      expect(
        (today.dy - viewport.center.dy).abs(),
        lessThan(rowHeight / 2),
        reason: 'today must be the centred row',
      );
    });

    testWidgets("today's planet is on screen beside it", (
      WidgetTester tester,
    ) async {
      final Rect viewport = await pumpTimeline(tester);
      // Day 48 is Venus (31–60).
      final Finder venus = find.text('VENUS');
      expect(venus, findsOneWidget);
      final Offset at = tester.getCenter(venus);
      expect(at.dy, inInclusiveRange(viewport.top, viewport.bottom));
    });

    testWidgets('every day behind is travelled, missions or not', (
      WidgetTester tester,
    ) async {
      await pumpTimeline(tester);
      // 35…47, and not one step was ever done: the old verdict would have
      // called all thirteen "Steps Missed".
      expect(find.text('TRAVELLED'), findsNWidgets(13));
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('STEPS MISSED'), findsNothing);
      expect(find.text('IN PROGRESS'), findsNothing);
    });

    testWidgets('a day is a marker, not a control', (
      WidgetTester tester,
    ) async {
      await pumpTimeline(tester);
      expect(
        find.descendant(
          of: find.byType(RoadmapTimeline),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets(
      "the header names today's phase and its mark, as the web does",
      (WidgetTester tester) async {
        await pumpTimeline(tester);
        expect(find.text('Getting Seen'), findsOneWidget);
        // The journey's length ungrouped and the mark grouped, as the web
        // prints them.
        expect(roadmapTotalDays.toString(), '1000');
        expect(
          find.text(
            'Day 48 of $roadmapTotalDays — next checkpoint 3,000 followers.',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('66-day'), findsNothing);
      },
    );
  });

  group('the sheet', () {
    setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

    Future<GoRouter> pumpRoadmap(WidgetTester tester) async {
      // Tall enough that the whole sheet is built without a drag.
      tester.view.physicalSize = const Size(430, 1600) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final GoRouter router = GoRouter(
        initialLocation: ZaveRoutes.roadmap,
        routes: <RouteBase>[
          GoRoute(
            path: ZaveRoutes.roadmap,
            builder: (_, _) => const HomePage(),
          ),
          GoRoute(
            path: ZaveRoutes.planner,
            builder: (_, _) => const Scaffold(body: Text('PLANNER')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            preferencesControllerProvider.overrideWith(_RunningPrefs.new),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      return router;
    }

    testWidgets('holds the planner and the two check-ins, and no missions', (
      WidgetTester tester,
    ) async {
      await pumpRoadmap(tester);

      expect(find.text('Open planner'), findsOneWidget);
      // The mock's count has lapsed, so the weekly question is up.
      expect(
        find.text('How many connections do you have now?'),
        findsOneWidget,
      );
      expect(find.text('Open Plexa'), findsNothing);
      expect(find.textContaining('small things'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Open planner switches to the planner', (
      WidgetTester tester,
    ) async {
      final GoRouter router = await pumpRoadmap(tester);
      await tester.tap(find.text('Open planner'));
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        ZaveRoutes.planner,
      );
    });
  });
}

class _RunningPrefs extends PreferencesController {
  @override
  Future<UserPreferences> build() async =>
      UserPreferences.fromJson(<String, dynamic>{
        'exists': true,
        'onboardingCompleted': true,
        'roadmapStartedAt': DateTime.now()
            .subtract(const Duration(days: 11))
            .toIso8601String(),
      });
}
