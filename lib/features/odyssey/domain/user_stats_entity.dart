import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats_entity.freezed.dart';
part 'user_stats_entity.g.dart';

/// The player's gamification snapshot (streak, XP, level) shown on the
/// Odyssey hero card.
///
/// Ported from the legacy `domain/entities/user_stats_entity.dart`. Freezed is
/// kept; json_serializable was ADDED so the mock/fake repository can parse
/// `assets/mock/odyssey/user_stats.json` through the real `fromJson`. The
/// live (Drift-backed) repository maps DB rows into this type directly.
@freezed
abstract class UserStatsEntity with _$UserStatsEntity {
  const factory UserStatsEntity({
    @Default(0) int streakDays,
    @Default(0) int xp,
    @Default(1) int level,
    @Default('Beginner') String levelTitle,
    @Default(0) int weeklyXp,
    @Default(2000) int weeklyXpGoal,
    String? lastActiveDateStr,
  }) = _UserStatsEntity;

  const UserStatsEntity._();

  factory UserStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$UserStatsEntityFromJson(json);

  double get weeklyXpProgress =>
      weeklyXpGoal == 0 ? 0 : weeklyXp / weeklyXpGoal;

  bool get isStreakAlive {
    if (lastActiveDateStr == null) return false;
    final last = DateTime.tryParse(lastActiveDateStr!);
    if (last == null) return false;
    final today = DateTime.now();
    final diff = today.difference(last).inDays;
    return diff <= 1;
  }
}
