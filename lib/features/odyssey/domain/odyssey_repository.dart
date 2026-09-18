import 'mission_entity.dart';
import 'user_stats_entity.dart';

export 'mission_entity.dart';
export 'user_stats_entity.dart';

/// Thrown when the Odyssey data can't be read or a mutation fails — the UI
/// maps it to the shared network-error / inline-error state.
///
/// Follows the ProHealth single-sentinel convention (one const exception per
/// feature; no dartz `Either` — the legacy `ResultVoid`/`CacheFailure` return
/// type is retired per RULINGS §5).
class OdysseyUnavailable implements Exception {
  const OdysseyUnavailable();
}

/// Seam between the Odyssey screens and the gamification store.
///
/// DEVIATION FROM PROHEALTH (documented per task): ProHealth repositories are
/// Future-returning (`Future<T> fetchX()`). Odyssey stays STREAM-backed
/// because the live implementation watches Drift streams so XP / mission
/// progress updates re-render the mission path in real time as the user earns
/// rewards elsewhere in the app. The controllers are therefore thin
/// `StreamProvider`s over these methods rather than `AsyncNotifier` fetches.
///
/// Mutations return `Future<void>` and throw [OdysseyUnavailable] on failure
/// (the live impl writes to Drift, which then re-emits on the watch streams;
/// the fake impl is read-only and treats mutations as no-ops).
abstract class OdysseyRepository {
  /// Watch live user stats (streak, XP, level).
  Stream<UserStatsEntity> watchStats();

  /// Watch all missions ordered by sortOrder.
  Stream<List<MissionEntity>> watchMissions();

  /// Award XP for completing an action (recomputes level + weekly XP).
  Future<void> awardXp(int amount);

  /// Update mission progress; auto-completes when progress reaches total.
  Future<void> updateMissionProgress(String missionKey, int newProgress);

  /// Mark a mission complete, award its XP and unlock the next node.
  Future<void> completeMission(String missionKey);

  /// Sync stats from remote (call after publishing a post).
  Future<void> syncFromRemote();
}
