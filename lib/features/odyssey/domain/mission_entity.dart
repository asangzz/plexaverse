import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_entity.freezed.dart';
part 'mission_entity.g.dart';

/// Lifecycle of a single Odyssey mission node on the mission path.
///
/// Wire values match the enum names verbatim (`done`/`active`/`next`/`locked`)
/// so JSON fixtures and any future `/odyssey/missions` payload round-trip
/// through [MissionEntity.fromJson] without a converter.
enum MissionStatus { done, active, next, locked }

extension MissionStatusX on MissionStatus {
  /// Tolerant parse used when reading raw string columns from Drift rows
  /// (the DB stores the status as free text, defaulting to `locked`).
  static MissionStatus fromString(String s) => switch (s) {
        'done' => MissionStatus.done,
        'active' => MissionStatus.active,
        'next' => MissionStatus.next,
        _ => MissionStatus.locked,
      };
}

/// A single gamification mission (WF-Odyssey mission path node).
///
/// Ported from the legacy `domain/entities/mission_entity.dart`. Freezed is
/// kept for the value-type ergonomics the page relies on; json_serializable
/// was ADDED during the migration so the mock/fake repository can parse
/// `assets/mock/odyssey/missions.json` through the real `fromJson`.
@freezed
abstract class MissionEntity with _$MissionEntity {
  const factory MissionEntity({
    required int id,
    required String missionKey,
    required String title,
    required String description,
    @Default(MissionStatus.locked) MissionStatus status,
    @Default(100) int xpReward,
    @Default(0) int progress,
    @Default(1) int total,
    @Default(0) int sortOrder,
  }) = _MissionEntity;

  const MissionEntity._();

  factory MissionEntity.fromJson(Map<String, dynamic> json) =>
      _$MissionEntityFromJson(json);

  double get progressFraction =>
      total == 0 ? 0 : (progress / total).clamp(0.0, 1.0);

  bool get isCompleted => status == MissionStatus.done;
  bool get isActive => status == MissionStatus.active;
  bool get isLocked => status == MissionStatus.locked;
}
