// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odyssey_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live user stats (streak / XP / level) for the Odyssey hero card.
///
/// DEVIATION FROM PROHEALTH (documented per task): a thin `StreamProvider`
/// over the Drift watch-stream rather than an `AsyncNotifier` future fetch —
/// mission/XP progress written elsewhere in the app re-renders the path in
/// real time. See [OdysseyRepository] for the rationale.

@ProviderFor(userStats)
final userStatsProvider = UserStatsProvider._();

/// Live user stats (streak / XP / level) for the Odyssey hero card.
///
/// DEVIATION FROM PROHEALTH (documented per task): a thin `StreamProvider`
/// over the Drift watch-stream rather than an `AsyncNotifier` future fetch —
/// mission/XP progress written elsewhere in the app re-renders the path in
/// real time. See [OdysseyRepository] for the rationale.

final class UserStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStatsEntity>,
          UserStatsEntity,
          Stream<UserStatsEntity>
        >
    with $FutureModifier<UserStatsEntity>, $StreamProvider<UserStatsEntity> {
  /// Live user stats (streak / XP / level) for the Odyssey hero card.
  ///
  /// DEVIATION FROM PROHEALTH (documented per task): a thin `StreamProvider`
  /// over the Drift watch-stream rather than an `AsyncNotifier` future fetch —
  /// mission/XP progress written elsewhere in the app re-renders the path in
  /// real time. See [OdysseyRepository] for the rationale.
  UserStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStatsHash();

  @$internal
  @override
  $StreamProviderElement<UserStatsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserStatsEntity> create(Ref ref) {
    return userStats(ref);
  }
}

String _$userStatsHash() => r'ceff09f084a47a70ad427d5bf099b4bd9c0af7d1';

/// Live mission list ordered by sortOrder (the mission path).

@ProviderFor(missions)
final missionsProvider = MissionsProvider._();

/// Live mission list ordered by sortOrder (the mission path).

final class MissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MissionEntity>>,
          List<MissionEntity>,
          Stream<List<MissionEntity>>
        >
    with
        $FutureModifier<List<MissionEntity>>,
        $StreamProvider<List<MissionEntity>> {
  /// Live mission list ordered by sortOrder (the mission path).
  MissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missionsHash();

  @$internal
  @override
  $StreamProviderElement<List<MissionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MissionEntity>> create(Ref ref) {
    return missions(ref);
  }
}

String _$missionsHash() => r'e3e31207b63afb914d6e22bd8dc7f7c0ad805b08';

/// User stats as a one-shot Future — convenience for cross-feature consumers
/// (e.g. the home dashboard) that only need the current snapshot.

@ProviderFor(userStatsFuture)
final userStatsFutureProvider = UserStatsFutureProvider._();

/// User stats as a one-shot Future — convenience for cross-feature consumers
/// (e.g. the home dashboard) that only need the current snapshot.

final class UserStatsFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStatsEntity>,
          UserStatsEntity,
          FutureOr<UserStatsEntity>
        >
    with $FutureModifier<UserStatsEntity>, $FutureProvider<UserStatsEntity> {
  /// User stats as a one-shot Future — convenience for cross-feature consumers
  /// (e.g. the home dashboard) that only need the current snapshot.
  UserStatsFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStatsFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStatsFutureHash();

  @$internal
  @override
  $FutureProviderElement<UserStatsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserStatsEntity> create(Ref ref) {
    return userStatsFuture(ref);
  }
}

String _$userStatsFutureHash() => r'46eb865830c58300c40b1e579d32222f432636cc';
