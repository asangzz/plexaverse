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
