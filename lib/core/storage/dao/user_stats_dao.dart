import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'user_stats_dao.g.dart';

/// Drift accessor for the gamification tables (user_stats + missions).
/// Lives in `core/storage/dao/` alongside the single [AppDatabase] (see
/// notes on DAO placement).
@DriftAccessor(tables: [UserStatsTable, MissionsTable])
class UserStatsDao extends DatabaseAccessor<AppDatabase>
    with _$UserStatsDaoMixin {
  UserStatsDao(super.db);

  // -- User stats ------------------------------------------------------------

  Stream<UserStatsTableData?> watchStats() =>
      (select(userStatsTable)..where((t) => t.id.equals(1)))
          .watchSingleOrNull();

  Future<UserStatsTableData?> getStats() =>
      (select(userStatsTable)..where((t) => t.id.equals(1)))
          .getSingleOrNull();

  Future<void> upsertStats(UserStatsTableCompanion stats) =>
      into(userStatsTable).insertOnConflictUpdate(stats);

  // -- Missions --------------------------------------------------------------

  Stream<List<MissionsTableData>> watchMissions() =>
      (select(missionsTable)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<MissionsTableData>> getMissions() =>
      (select(missionsTable)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> upsertMission(MissionsTableCompanion mission) =>
      into(missionsTable).insertOnConflictUpdate(mission);

  Future<void> updateMissionProgress(String key, int progress) =>
      (update(missionsTable)..where((t) => t.missionKey.equals(key))).write(
        MissionsTableCompanion(progress: Value(progress)),
      );

  Future<void> completeMission(String key) =>
      (update(missionsTable)..where((t) => t.missionKey.equals(key))).write(
        const MissionsTableCompanion(
          status: Value('done'),
          progress: Value(1),
          total: Value(1),
        ),
      );

  // -- Seeding ---------------------------------------------------------------

  Future<void> seedIfEmpty() async {
    // Seed user stats.
    final existing = await getStats();
    if (existing == null) {
      await into(userStatsTable).insert(
        UserStatsTableCompanion(
          id: const Value(1),
          streakDays: const Value(40),
          xp: const Value(1440),
          level: const Value(8),
          levelTitle: const Value('Creator'),
          weeklyXp: const Value(1440),
          weeklyXpGoal: const Value(2000),
          lastActiveDateStr: Value(
            DateTime.now().toIso8601String().substring(0, 10),
          ),
        ),
      );
    }

    // Seed missions.
    final existingMissions = await getMissions();
    if (existingMissions.isEmpty) {
      const seeds = [
        MissionsTableCompanion(
          missionKey: Value('linkedin_launch'),
          title: Value('LinkedIn Launch'),
          description: Value('Post your first 5 posts'),
          status: Value('done'),
          xpReward: Value(200),
          progress: Value(5),
          total: Value(5),
          sortOrder: Value(0),
        ),
        MissionsTableCompanion(
          missionKey: Value('consistency_king'),
          title: Value('Consistency King'),
          description: Value('Post 10 days in a row'),
          status: Value('done'),
          xpReward: Value(500),
          progress: Value(10),
          total: Value(10),
          sortOrder: Value(1),
        ),
        MissionsTableCompanion(
          missionKey: Value('thought_leader'),
          title: Value('Thought Leader'),
          description: Value('Get 1,000 impressions on a single post'),
          status: Value('active'),
          xpReward: Value(500),
          progress: Value(450),
          total: Value(1000),
          sortOrder: Value(2),
        ),
        MissionsTableCompanion(
          missionKey: Value('audience_builder'),
          title: Value('Audience Builder'),
          description: Value('Reach 500 followers'),
          status: Value('next'),
          xpReward: Value(300),
          progress: Value(0),
          total: Value(500),
          sortOrder: Value(3),
        ),
        MissionsTableCompanion(
          missionKey: Value('viral_moment'),
          title: Value('Viral Moment'),
          description: Value('Get 10,000 impressions on a single post'),
          status: Value('locked'),
          xpReward: Value(1000),
          progress: Value(0),
          total: Value(10000),
          sortOrder: Value(4),
        ),
      ];
      for (final seed in seeds) {
        await into(missionsTable).insert(seed);
      }
    }
  }
}
