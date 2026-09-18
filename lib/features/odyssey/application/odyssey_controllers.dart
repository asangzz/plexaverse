import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/odyssey_repositories.dart';
import '../domain/mission_entity.dart';
import '../domain/user_stats_entity.dart';

part 'odyssey_controllers.g.dart';

/// Live user stats (streak / XP / level) for the Odyssey hero card.
///
/// DEVIATION FROM PROHEALTH (documented per task): a thin `StreamProvider`
/// over the Drift watch-stream rather than an `AsyncNotifier` future fetch —
/// mission/XP progress written elsewhere in the app re-renders the path in
/// real time. See [OdysseyRepository] for the rationale.
@riverpod
Stream<UserStatsEntity> userStats(Ref ref) =>
    ref.watch(odysseyRepositoryProvider).watchStats();

/// Live mission list ordered by sortOrder (the mission path).
@riverpod
Stream<List<MissionEntity>> missions(Ref ref) =>
    ref.watch(odysseyRepositoryProvider).watchMissions();

/// User stats as a one-shot Future — convenience for cross-feature consumers
/// (e.g. the home dashboard) that only need the current snapshot.
@riverpod
Future<UserStatsEntity> userStatsFuture(Ref ref) =>
    ref.watch(userStatsProvider.future);
