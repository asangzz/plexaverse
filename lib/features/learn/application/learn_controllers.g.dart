// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which week the path is showing.
///
/// Null means "whatever the server says is current". The server owns that
/// calculation — a Sunday-anchored week off roadmapStartedAt — and a client
/// that recomputed it would ask for a week the plan was never saved under.

@ProviderFor(LearnWeek)
final learnWeekProvider = LearnWeekProvider._();

/// Which week the path is showing.
///
/// Null means "whatever the server says is current". The server owns that
/// calculation — a Sunday-anchored week off roadmapStartedAt — and a client
/// that recomputed it would ask for a week the plan was never saved under.
final class LearnWeekProvider extends $NotifierProvider<LearnWeek, int?> {
  /// Which week the path is showing.
  ///
  /// Null means "whatever the server says is current". The server owns that
  /// calculation — a Sunday-anchored week off roadmapStartedAt — and a client
  /// that recomputed it would ask for a week the plan was never saved under.
  LearnWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnWeekHash();

  @$internal
  @override
  LearnWeek create() => LearnWeek();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$learnWeekHash() => r'8a3e2eb53d54d26efb396a016e108184c4e5cfab';

/// Which week the path is showing.
///
/// Null means "whatever the server says is current". The server owns that
/// calculation — a Sunday-anchored week off roadmapStartedAt — and a client
/// that recomputed it would ask for a week the plan was never saved under.

abstract class _$LearnWeek extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The week as a path.

@ProviderFor(learnPath)
final learnPathProvider = LearnPathProvider._();

/// The week as a path.

final class LearnPathProvider
    extends
        $FunctionalProvider<
          AsyncValue<LearnPath>,
          LearnPath,
          FutureOr<LearnPath>
        >
    with $FutureModifier<LearnPath>, $FutureProvider<LearnPath> {
  /// The week as a path.
  LearnPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnPathHash();

  @$internal
  @override
  $FutureProviderElement<LearnPath> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<LearnPath> create(Ref ref) {
    return learnPath(ref);
  }
}

String _$learnPathHash() => r'97b6b3cbf45b3d1e761536349b22d52e95b482ac';

/// One day's ladder.
///
/// ## Why this is keepAlive and never invalidated
///
/// Its build() calls a GET that **generates the ladder with a model call** the
/// first time a day is opened. Every reflex the stack has around GETs is wrong
/// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
/// refresh-on-resume would re-run it — and each re-run is another model call
/// and another few seconds of the user staring at a spinner for questions they
/// already have.
///
/// So: fetched exactly once per (week, day), kept alive, and every later
/// version of the unit — from submitting a level, from the draft, from the
/// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
/// rather than refetched.
///
/// The server caches the built ladder on its own row, so even a genuine
/// refetch would return identical questions. That is a safety net, not a
/// licence: it still costs a round trip the user did not ask for.

@ProviderFor(LearnUnitController)
final learnUnitControllerProvider = LearnUnitControllerFamily._();

/// One day's ladder.
///
/// ## Why this is keepAlive and never invalidated
///
/// Its build() calls a GET that **generates the ladder with a model call** the
/// first time a day is opened. Every reflex the stack has around GETs is wrong
/// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
/// refresh-on-resume would re-run it — and each re-run is another model call
/// and another few seconds of the user staring at a spinner for questions they
/// already have.
///
/// So: fetched exactly once per (week, day), kept alive, and every later
/// version of the unit — from submitting a level, from the draft, from the
/// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
/// rather than refetched.
///
/// The server caches the built ladder on its own row, so even a genuine
/// refetch would return identical questions. That is a safety net, not a
/// licence: it still costs a round trip the user did not ask for.
final class LearnUnitControllerProvider
    extends $AsyncNotifierProvider<LearnUnitController, LearnUnit> {
  /// One day's ladder.
  ///
  /// ## Why this is keepAlive and never invalidated
  ///
  /// Its build() calls a GET that **generates the ladder with a model call** the
  /// first time a day is opened. Every reflex the stack has around GETs is wrong
  /// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
  /// refresh-on-resume would re-run it — and each re-run is another model call
  /// and another few seconds of the user staring at a spinner for questions they
  /// already have.
  ///
  /// So: fetched exactly once per (week, day), kept alive, and every later
  /// version of the unit — from submitting a level, from the draft, from the
  /// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
  /// rather than refetched.
  ///
  /// The server caches the built ladder on its own row, so even a genuine
  /// refetch would return identical questions. That is a safety net, not a
  /// licence: it still costs a round trip the user did not ask for.
  LearnUnitControllerProvider._({
    required LearnUnitControllerFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'learnUnitControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learnUnitControllerHash();

  @override
  String toString() {
    return r'learnUnitControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LearnUnitController create() => LearnUnitController();

  @override
  bool operator ==(Object other) {
    return other is LearnUnitControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learnUnitControllerHash() =>
    r'735e169cebc7c9d22a723df5a6312072deff6093';

/// One day's ladder.
///
/// ## Why this is keepAlive and never invalidated
///
/// Its build() calls a GET that **generates the ladder with a model call** the
/// first time a day is opened. Every reflex the stack has around GETs is wrong
/// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
/// refresh-on-resume would re-run it — and each re-run is another model call
/// and another few seconds of the user staring at a spinner for questions they
/// already have.
///
/// So: fetched exactly once per (week, day), kept alive, and every later
/// version of the unit — from submitting a level, from the draft, from the
/// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
/// rather than refetched.
///
/// The server caches the built ladder on its own row, so even a genuine
/// refetch would return identical questions. That is a safety net, not a
/// licence: it still costs a round trip the user did not ask for.

final class LearnUnitControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LearnUnitController,
          AsyncValue<LearnUnit>,
          LearnUnit,
          FutureOr<LearnUnit>,
          (int, int)
        > {
  LearnUnitControllerFamily._()
    : super(
        retry: null,
        name: r'learnUnitControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// One day's ladder.
  ///
  /// ## Why this is keepAlive and never invalidated
  ///
  /// Its build() calls a GET that **generates the ladder with a model call** the
  /// first time a day is opened. Every reflex the stack has around GETs is wrong
  /// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
  /// refresh-on-resume would re-run it — and each re-run is another model call
  /// and another few seconds of the user staring at a spinner for questions they
  /// already have.
  ///
  /// So: fetched exactly once per (week, day), kept alive, and every later
  /// version of the unit — from submitting a level, from the draft, from the
  /// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
  /// rather than refetched.
  ///
  /// The server caches the built ladder on its own row, so even a genuine
  /// refetch would return identical questions. That is a safety net, not a
  /// licence: it still costs a round trip the user did not ask for.

  LearnUnitControllerProvider call(int week, int day) =>
      LearnUnitControllerProvider._(argument: (week, day), from: this);

  @override
  String toString() => r'learnUnitControllerProvider';
}

/// One day's ladder.
///
/// ## Why this is keepAlive and never invalidated
///
/// Its build() calls a GET that **generates the ladder with a model call** the
/// first time a day is opened. Every reflex the stack has around GETs is wrong
/// for it: `ref.invalidate` would re-run it, an error-retry would re-run it, a
/// refresh-on-resume would re-run it — and each re-run is another model call
/// and another few seconds of the user staring at a spinner for questions they
/// already have.
///
/// So: fetched exactly once per (week, day), kept alive, and every later
/// version of the unit — from submitting a level, from the draft, from the
/// visual check — is WRITTEN INTO state by [LearnUnitController.absorb]
/// rather than refetched.
///
/// The server caches the built ladder on its own row, so even a genuine
/// refetch would return identical questions. That is a safety net, not a
/// licence: it still costs a round trip the user did not ask for.

abstract class _$LearnUnitController extends $AsyncNotifier<LearnUnit> {
  late final _$args = ref.$arg as (int, int);
  int get week => _$args.$1;
  int get day => _$args.$2;

  FutureOr<LearnUnit> build(int week, int day);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LearnUnit>, LearnUnit>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LearnUnit>, LearnUnit>,
              AsyncValue<LearnUnit>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Which day's player is open, if any.

@ProviderFor(LearnOpenDay)
final learnOpenDayProvider = LearnOpenDayProvider._();

/// Which day's player is open, if any.
final class LearnOpenDayProvider extends $NotifierProvider<LearnOpenDay, int?> {
  /// Which day's player is open, if any.
  LearnOpenDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnOpenDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnOpenDayHash();

  @$internal
  @override
  LearnOpenDay create() => LearnOpenDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$learnOpenDayHash() => r'bf8a4a85df2e8e164ed149c206820518fe3b3df4';

/// Which day's player is open, if any.

abstract class _$LearnOpenDay extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives one unit's climb.
///
/// Every write goes through here so the in-flight flag, the failure and the
/// server's verdicts live in one place that outlives the player.

@ProviderFor(LearnActions)
final learnActionsProvider = LearnActionsFamily._();

/// Drives one unit's climb.
///
/// Every write goes through here so the in-flight flag, the failure and the
/// server's verdicts live in one place that outlives the player.
final class LearnActionsProvider
    extends $NotifierProvider<LearnActions, LearnBusy> {
  /// Drives one unit's climb.
  ///
  /// Every write goes through here so the in-flight flag, the failure and the
  /// server's verdicts live in one place that outlives the player.
  LearnActionsProvider._({
    required LearnActionsFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'learnActionsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learnActionsHash();

  @override
  String toString() {
    return r'learnActionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LearnActions create() => LearnActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnBusy>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LearnActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learnActionsHash() => r'6e68f7b59e3dd1343a09133e7729320c6871a5ea';

/// Drives one unit's climb.
///
/// Every write goes through here so the in-flight flag, the failure and the
/// server's verdicts live in one place that outlives the player.

final class LearnActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          LearnActions,
          LearnBusy,
          LearnBusy,
          LearnBusy,
          (int, int)
        > {
  LearnActionsFamily._()
    : super(
        retry: null,
        name: r'learnActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Drives one unit's climb.
  ///
  /// Every write goes through here so the in-flight flag, the failure and the
  /// server's verdicts live in one place that outlives the player.

  LearnActionsProvider call(int week, int day) =>
      LearnActionsProvider._(argument: (week, day), from: this);

  @override
  String toString() => r'learnActionsProvider';
}

/// Drives one unit's climb.
///
/// Every write goes through here so the in-flight flag, the failure and the
/// server's verdicts live in one place that outlives the player.

abstract class _$LearnActions extends $Notifier<LearnBusy> {
  late final _$args = ref.$arg as (int, int);
  int get week => _$args.$1;
  int get day => _$args.$2;

  LearnBusy build(int week, int day);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LearnBusy, LearnBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LearnBusy, LearnBusy>,
              LearnBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
