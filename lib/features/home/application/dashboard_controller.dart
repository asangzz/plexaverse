import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/home_repository_providers.dart';
import '../domain/home_repository.dart';

part 'dashboard_controller.g.dart';

/// Loads the Home dashboard. `AsyncValue` drives the page states: loading →
/// skeleton, error → shared network-error view (with retry), data →
/// first-time orientation or the full dashboard. Pull-to-refresh and the
/// retry button re-run it via `ref.refresh(...future)` / `ref.invalidate`.
///
/// Replaces the old `dashboardProvider` function-provider that fanned in the
/// posts + odyssey streams and aggregated KPIs client-side; the summary is
/// now fetched whole from the repository (real endpoint or bundled mock).
@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardSummary> build() {
    return ref.watch(homeRepositoryProvider).fetchDashboard();
  }
}
