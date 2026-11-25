import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/network/api_paths.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/home/data/home_repositories.dart';
import 'package:plexaverse/features/home/domain/home_repository.dart';
import 'package:plexaverse/features/home/domain/roadmap_level.dart';
import 'package:plexaverse/features/home/presentation/pages/home_page.dart';
import 'package:plexaverse/features/home/presentation/widgets/roadmap_timeline.dart';
import 'package:plexaverse/features/preferences/application/preferences_controller.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How much of each day's levels was finished, on the roadmap's day rows
/// (web, 25 Nov 2026 — `lib/levels-finished.ts`, `GamifiedRoadmap`'s
/// `LevelsFinishedLine`): on the rows behind today and today, never ahead; a
/// row with no entry shows nothing, never 0%; a failed read shows no figures
/// and costs the roadmap nothing.
void main() {
  LevelsFinishedDay figure(int day, int done, int offered) => LevelsFinishedDay(
    day: day,
    dayKey: '2026-11-${day.toString().padLeft(2, '0')}',
    done: done,
    offered: offered,
    percent: (100 * done) ~/ offered,
  );

  group('the words', () {
    test("are the web's, shown and spoken", () {
      final ({String short, String spoken}) w = levelsFinishedWords(
        figure(1, 3, 5),
      );
      expect(w.short, '3/5 levels · 60%');
      expect(w.spoken, '3 of 5 levels finished, 60%');
    });

    test('one level is a level', () {
      expect(levelsFinishedWords(figure(1, 1, 1)).short, '1/1 level · 100%');
    });

    test('an entry with nothing offered is no figure', () {
      final LevelsFinished f = LevelsFinished(
        days: <LevelsFinishedDay>[
          const LevelsFinishedDay(day: 4),
          figure(5, 2, 4),
        ],
      );
      expect(f.byDay.keys, <int>[5]);
    });
  });

  group('the wire', () {
    test('reads `{ days }` out of the envelope', () async {
      final (ApiHomeRepository repo, _Canned adapter) = _repo(
        200,
        <String, dynamic>{
          'data': <String, dynamic>{
            'days': <Map<String, dynamic>>[
              <String, dynamic>{
                'day': 47,
                'dayKey': '2026-11-24',
                'done': 3,
                'offered': 5,
                'percent': 60,
              },
              <String, dynamic>{
                'day': 48,
                'dayKey': '2026-11-25',
                'done': 1,
                'offered': 4,
                'percent': 25,
              },
            ],
          },
          'error': null,
        },
      );
      final LevelsFinished f = await repo.fetchLevelsFinished();
      expect(adapter.seen.single.path, ApiPaths.roadmapLevelsFinished);
      expect(ApiPaths.roadmapLevelsFinished, '/roadmap/levels-finished');
      expect(f.byDay[47], figure(47, 3, 5).copyWith(dayKey: '2026-11-24'));
      expect(f.byDay[48]!.percent, 25);
    });

    test('an empty list is an answer', () async {
      final (ApiHomeRepository repo, _) = _repo(200, <String, dynamic>{
        'data': <String, dynamic>{'days': <Object>[]},
        'error': null,
      });
      expect((await repo.fetchLevelsFinished()).byDay, isEmpty);
    });

    test('a 500 is HomeUnavailable', () async {
      final (ApiHomeRepository repo, _) = _repo(500, <String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'INTERNAL',
          'message': 'Could not load your levels.',
        },
      });
      await expectLater(
        repo.fetchLevelsFinished(),
        throwsA(isA<HomeUnavailable>()),
      );
    });
  });

  group('the rows', () {
    Future<void> pumpTimeline(
      WidgetTester tester,
      Map<int, LevelsFinishedDay> figures,
    ) async {
      tester.view.physicalSize = const Size(375, 667) * 3;
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      const int today = 48;
      final List<RoadmapLevel> levels = buildRoadmap(
        RoadmapProgress(
          currentDay: today,
          roadmapStartedAt: DateTime.now().subtract(
            const Duration(days: today - 1),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: RoadmapTimeline(
                levels: levels,
                today: today,
                topInset: 0,
                levelsFinished: figures,
              ),
            ),
          ),
        ),
      );
      for (int i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('behind and today carry a figure; ahead never does', (
      WidgetTester tester,
    ) async {
      await pumpTimeline(tester, <int, LevelsFinishedDay>{
        46: figure(46, 5, 5),
        47: figure(47, 3, 5),
        48: figure(48, 1, 4),
        // The server never sends one for a day ahead; if it did, it is not
        // drawn.
        49: figure(49, 2, 2),
      });

      expect(find.byType(LevelsFinishedLine), findsNWidgets(3));
      expect(find.text('5/5 LEVELS · 100%'), findsOneWidget);
      expect(find.text('3/5 LEVELS · 60%'), findsOneWidget);
      expect(find.text('1/4 LEVELS · 25%'), findsOneWidget);
      expect(find.text('2/2 LEVELS · 100%'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a row with no entry shows nothing, never 0%', (
      WidgetTester tester,
    ) async {
      await pumpTimeline(tester, <int, LevelsFinishedDay>{
        47: figure(47, 3, 5),
      });
      expect(find.byType(LevelsFinishedLine), findsOneWidget);
      expect(find.textContaining('LEVELS ·'), findsOneWidget);
    });

    testWidgets('a screen reader hears the sentence, not the slash', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await pumpTimeline(tester, <int, LevelsFinishedDay>{
        47: figure(47, 3, 5),
      });
      expect(
        find.bySemanticsLabel('3 of 5 levels finished, 60%'),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });

  group('the roadmap', () {
    setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

    Future<void> pumpRoadmap(WidgetTester tester, HomeRepository repo) async {
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
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            preferencesControllerProvider.overrideWith(_RunningPrefs.new),
            homeRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
    }

    testWidgets('draws the figures it was sent', (WidgetTester tester) async {
      await pumpRoadmap(tester, FakeHomeRepository());
      // The mock sends days 9–12 (today).
      expect(find.byType(LevelsFinishedLine), findsNWidgets(4));
      expect(find.text('TODAY'), findsOneWidget);
    });

    testWidgets('a failed read shows no figures and keeps the roadmap', (
      WidgetTester tester,
    ) async {
      await pumpRoadmap(tester, _NoFigures());
      expect(find.byType(LevelsFinishedLine), findsNothing);
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('Open planner'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

class _NoFigures extends FakeHomeRepository {
  @override
  Future<LevelsFinished> fetchLevelsFinished() async =>
      throw const HomeUnavailable();
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

class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiHomeRepository, _Canned) _repo(int status, Object body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiHomeRepository(DioClient(dio)), adapter);
}
