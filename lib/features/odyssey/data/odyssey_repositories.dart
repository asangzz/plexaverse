import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/mock/mock_api.dart';
import '../../../core/network/internet_monitor.dart';
import '../../../core/storage/app_database.dart';
import '../domain/odyssey_repository.dart';
import 'odyssey_repository.dart';

const String _kUserStatsAsset = 'assets/mock/odyssey/user_stats.json';
const String _kMissionsAsset = 'assets/mock/odyssey/missions.json';

/// Bundled-JSON [OdysseyRepository] for the `mock` flavor.
///
/// Reads parse `assets/mock/odyssey/*.json` through the real `fromJson` and
/// are surfaced as single-emission streams (the fixtures are static, so there
/// is nothing to re-emit). Mutations are no-ops: the fake store is read-only,
/// so awarding XP / completing missions has no effect until a real backend or
/// the Drift-backed [OdysseyRepositoryImpl] is in play. Offline-aware via the
/// injected [isOffline] closure — errors collapse to [OdysseyUnavailable].
class FakeOdysseyRepository implements OdysseyRepository {
  const FakeOdysseyRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Stream<UserStatsEntity> watchStats() async* {
    if (isOffline?.call() ?? false) throw const OdysseyUnavailable();
    try {
      final json = await MockApi.loadObject(_kUserStatsAsset);
      yield UserStatsEntity.fromJson(json);
    } on Object {
      throw const OdysseyUnavailable();
    }
  }

  @override
  Stream<List<MissionEntity>> watchMissions() async* {
    if (isOffline?.call() ?? false) throw const OdysseyUnavailable();
    try {
      final list = await MockApi.loadArray(_kMissionsAsset);
      yield list
          .map((e) => MissionEntity.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    } on Object {
      throw const OdysseyUnavailable();
    }
  }

  // Mutations are no-ops against the read-only fixtures.
  @override
  Future<void> awardXp(int amount) async {}

  @override
  Future<void> updateMissionProgress(String missionKey, int newProgress) async {}

  @override
  Future<void> completeMission(String missionKey) async {}

  @override
  Future<void> syncFromRemote() async {}
}

/// Mock ↔ live switch on `useFakeBackend`; release builds can never get the
/// mock. Override in tests with `overrideWithValue`.
///
/// The live path resolves the Drift-backed [OdysseyRepositoryImpl] over the
/// shared [UserStatsDao] accessor (core/storage per the DAO placement ruling).
final odysseyRepositoryProvider = Provider<OdysseyRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return FakeOdysseyRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  return OdysseyRepositoryImpl(ref.watch(appDatabaseProvider).userStatsDao);
});
