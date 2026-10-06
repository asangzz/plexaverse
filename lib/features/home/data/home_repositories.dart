import '../../../core/mock/mock_constants.dart';
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
/// All three paths exist in `ApiPaths` and correspond to real route handlers
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
  Future<XpBalance> fetchXpBalance() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.userXp);
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const XpBalance();
      return XpBalance.fromJson(data);
    } on Object {
      throw const HomeUnavailable();
    }
  }
}

/// In-memory [HomeRepository] for the `mock` flavor.
///
/// Shaped as a mid-journey Season 1 user, because that is what nearly every
/// real user is: day 12, the first four days fully done, day 11 half-missed,
/// and an AI post waiting for approval — so the panel exercises `completed`,
/// `missed`, `active` and `locked` without anyone having to fake a date.
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
        // Day 11 half-done — a missed day, so the amber state is reachable.
        '11-1',
        // Today: the comment task is already in.
        '$_currentDay-2',
      ],
      roadmapStartedAt: startedAt,
      pendingPostIdToday: 'mock-post-today',
    );
  }

  @override
  Future<XpBalance> fetchXpBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const XpBalance(balance: kMockXpBalance);
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
