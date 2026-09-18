// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the Home dashboard. `AsyncValue` drives the page states: loading →
/// skeleton, error → shared network-error view (with retry), data →
/// first-time orientation or the full dashboard. Pull-to-refresh and the
/// retry button re-run it via `ref.refresh(...future)` / `ref.invalidate`.
///
/// Replaces the old `dashboardProvider` function-provider that fanned in the
/// posts + odyssey streams and aggregated KPIs client-side; the summary is
/// now fetched whole from the repository (real endpoint or bundled mock).

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

/// Loads the Home dashboard. `AsyncValue` drives the page states: loading →
/// skeleton, error → shared network-error view (with retry), data →
/// first-time orientation or the full dashboard. Pull-to-refresh and the
/// retry button re-run it via `ref.refresh(...future)` / `ref.invalidate`.
///
/// Replaces the old `dashboardProvider` function-provider that fanned in the
/// posts + odyssey streams and aggregated KPIs client-side; the summary is
/// now fetched whole from the repository (real endpoint or bundled mock).
final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardSummary> {
  /// Loads the Home dashboard. `AsyncValue` drives the page states: loading →
  /// skeleton, error → shared network-error view (with retry), data →
  /// first-time orientation or the full dashboard. Pull-to-refresh and the
  /// retry button re-run it via `ref.refresh(...future)` / `ref.invalidate`.
  ///
  /// Replaces the old `dashboardProvider` function-provider that fanned in the
  /// posts + odyssey streams and aggregated KPIs client-side; the summary is
  /// now fetched whole from the repository (real endpoint or bundled mock).
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();
}

String _$dashboardControllerHash() =>
    r'9fb90ff44ab2ddbc9775d6ea3f53eff6ddeeca3b';

/// Loads the Home dashboard. `AsyncValue` drives the page states: loading →
/// skeleton, error → shared network-error view (with retry), data →
/// first-time orientation or the full dashboard. Pull-to-refresh and the
/// retry button re-run it via `ref.refresh(...future)` / `ref.invalidate`.
///
/// Replaces the old `dashboardProvider` function-provider that fanned in the
/// posts + odyssey streams and aggregated KPIs client-side; the summary is
/// now fetched whole from the repository (real endpoint or bundled mock).

abstract class _$DashboardController extends $AsyncNotifier<DashboardSummary> {
  FutureOr<DashboardSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DashboardSummary>, DashboardSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardSummary>, DashboardSummary>,
              AsyncValue<DashboardSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
