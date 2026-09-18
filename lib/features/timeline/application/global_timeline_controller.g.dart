// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_timeline_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the Global Timeline screen. Global events and wonders are fetched
/// in parallel and merged exactly like Wonderous's `TimelineLogic.init()`:
/// each wonder contributes a synthetic "Construction of {title} begins."
/// event at its `startYr`, the combined list is sorted by year ascending,
/// and both the merged events and the raw wonders are exposed together so
/// the page and its wonder-track widgets can render as one unit.
/// `AsyncValue` drives the page states: loading → skeleton, error → shared
/// network-error view (with retry), data → the screen. Retry re-runs it via
/// `ref.invalidate`.

@ProviderFor(GlobalTimelineController)
final globalTimelineControllerProvider = GlobalTimelineControllerProvider._();

/// Loads the Global Timeline screen. Global events and wonders are fetched
/// in parallel and merged exactly like Wonderous's `TimelineLogic.init()`:
/// each wonder contributes a synthetic "Construction of {title} begins."
/// event at its `startYr`, the combined list is sorted by year ascending,
/// and both the merged events and the raw wonders are exposed together so
/// the page and its wonder-track widgets can render as one unit.
/// `AsyncValue` drives the page states: loading → skeleton, error → shared
/// network-error view (with retry), data → the screen. Retry re-runs it via
/// `ref.invalidate`.
final class GlobalTimelineControllerProvider
    extends
        $AsyncNotifierProvider<
          GlobalTimelineController,
          GlobalTimelineOverview
        > {
  /// Loads the Global Timeline screen. Global events and wonders are fetched
  /// in parallel and merged exactly like Wonderous's `TimelineLogic.init()`:
  /// each wonder contributes a synthetic "Construction of {title} begins."
  /// event at its `startYr`, the combined list is sorted by year ascending,
  /// and both the merged events and the raw wonders are exposed together so
  /// the page and its wonder-track widgets can render as one unit.
  /// `AsyncValue` drives the page states: loading → skeleton, error → shared
  /// network-error view (with retry), data → the screen. Retry re-runs it via
  /// `ref.invalidate`.
  GlobalTimelineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalTimelineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalTimelineControllerHash();

  @$internal
  @override
  GlobalTimelineController create() => GlobalTimelineController();
}

String _$globalTimelineControllerHash() =>
    r'ba325c2bdd90ce1b5edbe06a1247dcf1bf7eacfb';

/// Loads the Global Timeline screen. Global events and wonders are fetched
/// in parallel and merged exactly like Wonderous's `TimelineLogic.init()`:
/// each wonder contributes a synthetic "Construction of {title} begins."
/// event at its `startYr`, the combined list is sorted by year ascending,
/// and both the merged events and the raw wonders are exposed together so
/// the page and its wonder-track widgets can render as one unit.
/// `AsyncValue` drives the page states: loading → skeleton, error → shared
/// network-error view (with retry), data → the screen. Retry re-runs it via
/// `ref.invalidate`.

abstract class _$GlobalTimelineController
    extends $AsyncNotifier<GlobalTimelineOverview> {
  FutureOr<GlobalTimelineOverview> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<GlobalTimelineOverview>, GlobalTimelineOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<GlobalTimelineOverview>,
                GlobalTimelineOverview
              >,
              AsyncValue<GlobalTimelineOverview>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
