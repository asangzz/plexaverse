import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';
import '../../../core/storage/dao/user_stats_dao.dart';
import '../domain/odyssey_repository.dart';

// ── Level thresholds ─────────────────────────────────────────────────────────

const int _kXpPerLevel = 2000;

const Map<int, String> _kLevelTitles = <int, String>{
  1: 'Beginner',
  2: 'Contributor',
  3: 'Creator',
  4: 'Influencer',
  5: 'Expert',
  6: 'Thought Leader',
  7: 'Authority',
  8: 'Master',
  9: 'Luminary',
  10: 'Legend',
};

String _titleForLevel(int level) =>
    _kLevelTitles[level.clamp(1, 10)] ?? 'Legend';

/// Live, Drift-backed [OdysseyRepository].
///
/// Reads are exposed as Drift watch-streams (see [OdysseyRepository] for the
/// documented deviation from ProHealth's Future-repo pattern). Writes mutate
/// the encrypted `user_stats` / `missions` tables through the shared
/// [UserStatsDao] (core/storage per the storage-phase DAO placement ruling);
/// the write re-emits on the watch streams so the mission path re-renders.
///
/// Errors are collapsed to the feature sentinel [OdysseyUnavailable] — no
/// dartz `Either`/`CacheFailure` (retired per RULINGS §5). Streams surface DB
/// errors to the controller's `AsyncError` directly.
class OdysseyRepositoryImpl implements OdysseyRepository {
  const OdysseyRepositoryImpl(this._dao);

  final UserStatsDao _dao;

  // ── Reads (stream-backed) ───────────────────────────────────────────────

  @override
  Stream<UserStatsEntity> watchStats() {
    return _dao.watchStats().map((data) {
      if (data == null) return const UserStatsEntity();
      return UserStatsEntity(
        streakDays: data.streakDays,
        xp: data.xp,
        level: data.level,
        levelTitle: data.levelTitle,
        weeklyXp: data.weeklyXp,
        weeklyXpGoal: data.weeklyXpGoal,
        lastActiveDateStr: data.lastActiveDateStr,
      );
    });
  }

  @override
  Stream<List<MissionEntity>> watchMissions() {
    return _dao.watchMissions().map((rows) {
      return rows
          .map(
            (row) => MissionEntity(
              id: row.id,
              missionKey: row.missionKey,
              title: row.title,
              description: row.description,
              status: MissionStatusX.fromString(row.status),
              xpReward: row.xpReward,
              progress: row.progress,
              total: row.total,
              sortOrder: row.sortOrder,
            ),
          )
          .toList();
    });
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  @override
  Future<void> awardXp(int amount) async {
    try {
      final current = await _dao.getStats();
      final currentXp = current?.xp ?? 0;
      final currentWeeklyXp = current?.weeklyXp ?? 0;
      final currentLevel = current?.level ?? 1;

      final newXp = currentXp + amount;
      final newWeeklyXp = currentWeeklyXp + amount;

      // Compute new level based on cumulative XP (levels never decrease).
      final computedLevel = ((newXp / _kXpPerLevel).floor() + 1).clamp(1, 10);
      final newLevel =
          computedLevel > currentLevel ? computedLevel : currentLevel;
      final newLevelTitle = _titleForLevel(newLevel);

      await _dao.upsertStats(
        UserStatsTableCompanion(
          id: const Value(1),
          xp: Value(newXp),
          weeklyXp: Value(newWeeklyXp),
          level: Value(newLevel),
          levelTitle: Value(newLevelTitle),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } on Object {
      throw const OdysseyUnavailable();
    }
  }

  @override
  Future<void> updateMissionProgress(String missionKey, int newProgress) async {
    try {
      await _dao.updateMissionProgress(missionKey, newProgress);

      final missions = await _dao.getMissions();
      final mission = missions.firstWhere(
        (m) => m.missionKey == missionKey,
        orElse: () => throw const OdysseyUnavailable(),
      );

      if (newProgress >= mission.total) {
        await completeMission(missionKey);
      }
    } on OdysseyUnavailable {
      rethrow;
    } on Object {
      throw const OdysseyUnavailable();
    }
  }

  @override
  Future<void> completeMission(String missionKey) async {
    try {
      // Read missions first so we know the reward before completing.
      final missions = await _dao.getMissions();
      final mission = missions.firstWhere(
        (m) => m.missionKey == missionKey,
        orElse: () => throw const OdysseyUnavailable(),
      );

      // Only complete if not already done (idempotent).
      if (mission.status != 'done') {
        await _dao.completeMission(missionKey);

        // Award XP for completing the mission.
        await awardXp(mission.xpReward);

        // Promote the lowest-sortOrder 'next' mission to 'active'.
        final updatedMissions = await _dao.getMissions();
        final nextMission = updatedMissions
            .where((m) => m.status == 'next')
            .fold<MissionsTableData?>(null, (best, m) {
          if (best == null) return m;
          return m.sortOrder < best.sortOrder ? m : best;
        });

        if (nextMission != null) {
          await _dao.upsertMission(
            MissionsTableCompanion(
              id: Value(nextMission.id),
              missionKey: Value(nextMission.missionKey),
              title: Value(nextMission.title),
              description: Value(nextMission.description),
              status: const Value('active'),
              xpReward: Value(nextMission.xpReward),
              progress: Value(nextMission.progress),
              total: Value(nextMission.total),
              sortOrder: Value(nextMission.sortOrder),
            ),
          );
        }
      }
    } on OdysseyUnavailable {
      rethrow;
    } on Object {
      throw const OdysseyUnavailable();
    }
  }

  @override
  Future<void> syncFromRemote() async {
    // Placeholder — no remote sync implemented yet (ported from legacy).
  }
}
