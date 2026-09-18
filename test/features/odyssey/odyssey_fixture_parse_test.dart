import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/odyssey/domain/mission_entity.dart';
import 'package:plexaverse/features/odyssey/domain/user_stats_entity.dart';

/// Guards the mock flavor (`flutter run -t lib/main_mock.dart`): the bundled
/// fixtures under `assets/mock/odyssey/` must parse through the regenerated
/// (camelCase) `fromJson` of each entity, exactly as [FakeOdysseyRepository]
/// does at runtime. A snake_case regression would throw a cast here.
void main() {
  const missionsAsset = 'assets/mock/odyssey/missions.json';
  const userStatsAsset = 'assets/mock/odyssey/user_stats.json';

  test('missions.json parses through MissionEntity.fromJson', () {
    final raw = File(missionsAsset).readAsStringSync();
    final list = jsonDecode(raw) as List<dynamic>;

    final missions = list
        .map((e) => MissionEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    expect(missions, hasLength(5));

    final first = missions.first;
    expect(first.id, 1);
    expect(first.missionKey, 'linkedin_launch');
    expect(first.title, 'LinkedIn Launch');
    expect(first.status, MissionStatus.done);
    expect(first.xpReward, 200);
    expect(first.progress, 5);
    expect(first.total, 5);
    expect(first.sortOrder, 0);

    // Every status string in the fixture decodes to a real enum value
    // (i.e. none silently fell back to the `locked` default via a bad key).
    expect(
      missions.map((m) => m.status).toSet(),
      containsAll(<MissionStatus>[
        MissionStatus.done,
        MissionStatus.active,
        MissionStatus.next,
        MissionStatus.locked,
      ]),
    );
  });

  test('user_stats.json parses through UserStatsEntity.fromJson', () {
    final raw = File(userStatsAsset).readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final stats = UserStatsEntity.fromJson(json);

    expect(stats.streakDays, 40);
    expect(stats.xp, 1440);
    expect(stats.level, 8);
    expect(stats.levelTitle, 'Master');
    expect(stats.weeklyXp, 1440);
    expect(stats.weeklyXpGoal, 2000);
    expect(stats.lastActiveDateStr, '2026-07-05');
  });

  test('no camelCase key silently fell back to a default', () {
    // If a fixture still used snake_case (e.g. mission_key / xp_reward /
    // streak_days), fromJson would return the field defaults instead of the
    // fixture's real values. Assert the values are the non-default ones.
    final missionsRaw = File(missionsAsset).readAsStringSync();
    final missions = (jsonDecode(missionsRaw) as List<dynamic>)
        .map((e) => MissionEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final m in missions) {
      expect(m.missionKey, isNotEmpty,
          reason: 'missionKey must come from the "missionKey" wire key');
    }
    expect(missions.any((m) => m.xpReward != 100), isTrue,
        reason: 'xpReward must come from "xpReward", not the 100 default');

    final statsRaw = File(userStatsAsset).readAsStringSync();
    final stats =
        UserStatsEntity.fromJson(jsonDecode(statsRaw) as Map<String, dynamic>);
    expect(stats.streakDays, isNot(0),
        reason: 'streakDays must come from "streakDays", not the 0 default');
    expect(stats.levelTitle, isNot('Beginner'),
        reason: 'levelTitle must come from "levelTitle", not the default');
  });
}
