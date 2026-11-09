// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user's position on the 1000-day roadmap.
///
/// The web caches this for 30 seconds and busts the browser cache on every
/// fetch; here the equivalent is simply that the provider is re-read on
/// invalidation and on a pull-to-refresh.

@ProviderFor(RoadmapProgressController)
final roadmapProgressControllerProvider = RoadmapProgressControllerProvider._();

/// The user's position on the 1000-day roadmap.
///
/// The web caches this for 30 seconds and busts the browser cache on every
/// fetch; here the equivalent is simply that the provider is re-read on
/// invalidation and on a pull-to-refresh.
final class RoadmapProgressControllerProvider
    extends $AsyncNotifierProvider<RoadmapProgressController, RoadmapProgress> {
  /// The user's position on the 1000-day roadmap.
  ///
  /// The web caches this for 30 seconds and busts the browser cache on every
  /// fetch; here the equivalent is simply that the provider is re-read on
  /// invalidation and on a pull-to-refresh.
  RoadmapProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roadmapProgressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roadmapProgressControllerHash();

  @$internal
  @override
  RoadmapProgressController create() => RoadmapProgressController();
}

String _$roadmapProgressControllerHash() =>
    r'db06a220208904080c45496f916fbdf58c88fef5';

/// The user's position on the 1000-day roadmap.
///
/// The web caches this for 30 seconds and busts the browser cache on every
/// fetch; here the equivalent is simply that the provider is re-read on
/// invalidation and on a pull-to-refresh.

abstract class _$RoadmapProgressController
    extends $AsyncNotifier<RoadmapProgress> {
  FutureOr<RoadmapProgress> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RoadmapProgress>, RoadmapProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoadmapProgress>, RoadmapProgress>,
              AsyncValue<RoadmapProgress>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The journey's days, with progress folded in.
///
/// Derived rather than stored: the roadmap is a pure function of the progress
/// payload plus today's date, and caching it separately is how the two drift.

@ProviderFor(roadmapLevels)
final roadmapLevelsProvider = RoadmapLevelsProvider._();

/// The journey's days, with progress folded in.
///
/// Derived rather than stored: the roadmap is a pure function of the progress
/// payload plus today's date, and caching it separately is how the two drift.

final class RoadmapLevelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoadmapLevel>>,
          List<RoadmapLevel>,
          FutureOr<List<RoadmapLevel>>
        >
    with
        $FutureModifier<List<RoadmapLevel>>,
        $FutureProvider<List<RoadmapLevel>> {
  /// The journey's days, with progress folded in.
  ///
  /// Derived rather than stored: the roadmap is a pure function of the progress
  /// payload plus today's date, and caching it separately is how the two drift.
  RoadmapLevelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roadmapLevelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roadmapLevelsHash();

  @$internal
  @override
  $FutureProviderElement<List<RoadmapLevel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoadmapLevel>> create(Ref ref) {
    return roadmapLevels(ref);
  }
}

String _$roadmapLevelsHash() => r'54ccb89447de8ee5da457b623a6fdcf4e246a6d9';

/// Which day the mission panel is showing.
///
/// Null means "follow the roadmap" — the active day, or day 1 when nothing is
/// active. The user overrides it by tapping a day row or scrolling one to the
/// centre of the timeline, exactly as the web's scroll-snap selection does.

@ProviderFor(SelectedRoadmapDay)
final selectedRoadmapDayProvider = SelectedRoadmapDayProvider._();

/// Which day the mission panel is showing.
///
/// Null means "follow the roadmap" — the active day, or day 1 when nothing is
/// active. The user overrides it by tapping a day row or scrolling one to the
/// centre of the timeline, exactly as the web's scroll-snap selection does.
final class SelectedRoadmapDayProvider
    extends $NotifierProvider<SelectedRoadmapDay, int?> {
  /// Which day the mission panel is showing.
  ///
  /// Null means "follow the roadmap" — the active day, or day 1 when nothing is
  /// active. The user overrides it by tapping a day row or scrolling one to the
  /// centre of the timeline, exactly as the web's scroll-snap selection does.
  SelectedRoadmapDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRoadmapDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRoadmapDayHash();

  @$internal
  @override
  SelectedRoadmapDay create() => SelectedRoadmapDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedRoadmapDayHash() =>
    r'008249843af55fa75c083dd1d7a478fbd1783970';

/// Which day the mission panel is showing.
///
/// Null means "follow the roadmap" — the active day, or day 1 when nothing is
/// active. The user overrides it by tapping a day row or scrolling one to the
/// centre of the timeline, exactly as the web's scroll-snap selection does.

abstract class _$SelectedRoadmapDay extends $Notifier<int?> {
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

/// The day the panel actually renders: the user's selection if they made one,
/// otherwise the roadmap's own active day.

@ProviderFor(activeRoadmapDay)
final activeRoadmapDayProvider = ActiveRoadmapDayProvider._();

/// The day the panel actually renders: the user's selection if they made one,
/// otherwise the roadmap's own active day.

final class ActiveRoadmapDayProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// The day the panel actually renders: the user's selection if they made one,
  /// otherwise the roadmap's own active day.
  ActiveRoadmapDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRoadmapDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRoadmapDayHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeRoadmapDay(ref);
  }
}

String _$activeRoadmapDayHash() => r'b7fdcfec5ae22b714b88b5d3cae82b394954982c';
