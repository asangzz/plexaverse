// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the Analytics tab aggregate. `AsyncValue` drives the three states:
/// loading → shimmer placeholders, error → shared network-error view with
/// retry, data → the hero/sub-metrics/top-post/best-times cards.
/// Pull-to-refresh and the retry button re-run it via `ref.invalidate` /
/// `.future`.

@ProviderFor(AnalyticsController)
final analyticsControllerProvider = AnalyticsControllerProvider._();

/// Loads the Analytics tab aggregate. `AsyncValue` drives the three states:
/// loading → shimmer placeholders, error → shared network-error view with
/// retry, data → the hero/sub-metrics/top-post/best-times cards.
/// Pull-to-refresh and the retry button re-run it via `ref.invalidate` /
/// `.future`.
final class AnalyticsControllerProvider
    extends $AsyncNotifierProvider<AnalyticsController, AnalyticsEntity> {
  /// Loads the Analytics tab aggregate. `AsyncValue` drives the three states:
  /// loading → shimmer placeholders, error → shared network-error view with
  /// retry, data → the hero/sub-metrics/top-post/best-times cards.
  /// Pull-to-refresh and the retry button re-run it via `ref.invalidate` /
  /// `.future`.
  AnalyticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsControllerHash();

  @$internal
  @override
  AnalyticsController create() => AnalyticsController();
}

String _$analyticsControllerHash() =>
    r'98d870dd076e63c923fa0b0f337dc6f8352fba99';

/// Loads the Analytics tab aggregate. `AsyncValue` drives the three states:
/// loading → shimmer placeholders, error → shared network-error view with
/// retry, data → the hero/sub-metrics/top-post/best-times cards.
/// Pull-to-refresh and the retry button re-run it via `ref.invalidate` /
/// `.future`.

abstract class _$AnalyticsController extends $AsyncNotifier<AnalyticsEntity> {
  FutureOr<AnalyticsEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AnalyticsEntity>, AnalyticsEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AnalyticsEntity>, AnalyticsEntity>,
              AsyncValue<AnalyticsEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
