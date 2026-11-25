import '../../../core/mock/fake_autopost_state.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/home_repository.dart';

/// Dio-backed [HomeRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner object. Every failure collapses to the
/// one [HomeUnavailable] sentinel.
///
/// The path exists in `ApiPaths` and corresponds to a real route handler
/// under `app/api/mobile/v1/`. Nothing on this screen calls an invented
/// endpoint — the persona chip the web renders beside the planner button is
/// left out precisely because `/persona` does not exist on the mobile API.
class ApiHomeRepository implements HomeRepository {
  const ApiHomeRepository(this._client);

  final DioClient _client;

  @override
  Future<RoadmapProgress> fetchRoadmapProgress() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.roadmapProgress,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const HomeUnavailable();
      return RoadmapProgress.fromJson(data);
    } on HomeUnavailable {
      rethrow;
    } on Object {
      throw const HomeUnavailable();
    }
  }

  @override
  Future<LevelsFinished> fetchLevelsFinished() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.roadmapLevelsFinished,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const HomeUnavailable();
      return LevelsFinished.fromJson(data);
    } on HomeUnavailable {
      rethrow;
    } on Object {
      throw const HomeUnavailable();
    }
  }
}

/// In-memory [HomeRepository] for the `mock` flavor.
///
/// Shaped as a mid-journey user, because that is what nearly every
/// real user is: day 12, the first four days fully done, day 11 half-missed,
/// and an AI post waiting for approval. The roadmap draws none of the steps
/// any more — it is a calendar, behind / today / ahead — but `/comments` and
/// `/connections` still find today's step here, so the step history stays
/// realistic rather than empty.
class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository();

  static const int _currentDay = 12;

  @override
  Future<RoadmapProgress> fetchRoadmapProgress() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final DateTime startedAt = DateTime.now().subtract(
      const Duration(days: _currentDay - 1),
    );
    return RoadmapProgress(
      currentDay: _currentDay,
      completedSteps: <String>[
        // Days 1–4 finished outright (four steps each: the three dailies plus
        // the day's profile extra).
        for (int day = 1; day <= 4; day++)
          for (int step = 1; step <= 4; step++) '$day-$step',
        // Days 5–10 finished on the three dailies.
        for (int day = 5; day <= 10; day++)
          for (int step = 1; step <= 3; step++) '$day-$step',
        // Day 11 half-done.
        '11-1',
        // Today: the comment task is already in.
        '$_currentDay-2',
      ],
      roadmapStartedAt: startedAt,
      // Read off the shared auto-post row, not pinned here. These three are
      // mutually exclusive on the server and the transition between them is
      // an APPROVAL, which happens in the planner — so pinning `pending` here
      // left two of the three branches in roadmap_level.dart unreachable.
      pendingPostIdToday: FakeAutoPostState.pendingPostId,
      scheduledPostId: FakeAutoPostState.scheduledPostId,
      scheduledPostAt: FakeAutoPostState.scheduledAt,
    );
  }

  /// Entered in the levels on day 9: the days before it carry no figure, as
  /// the server sends none for a day the learner had no levels on.
  @override
  Future<LevelsFinished> fetchLevelsFinished() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    LevelsFinishedDay figure(int day, int done, int offered) =>
        LevelsFinishedDay(
          day: day,
          done: done,
          offered: offered,
          percent: (100 * done) ~/ offered,
        );
    return LevelsFinished(
      days: <LevelsFinishedDay>[
        figure(9, 5, 5),
        figure(10, 3, 5),
        figure(11, 2, 6),
        figure(_currentDay, 1, 5),
      ],
    );
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<HomeRepository> homeRepositoryProvider =
    Provider<HomeRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeHomeRepository();
      return ApiHomeRepository(ref.watch(dioClientProvider));
    });
