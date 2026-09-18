import 'dashboard_summary.dart';

export 'dashboard_summary.dart';

/// Thrown when the dashboard can't be loaded (transport/server failure, or
/// offline). Online-first: the UI maps any load error to the shared
/// network-error state with retry; no cached fallback is implied at this
/// layer.
class DashboardUnavailable implements Exception {
  const DashboardUnavailable();
}

/// Seam between the Home tab and the backend. `homeRepositoryProvider`
/// (see `data/`) resolves the mock (bundled JSON) or the real Dio-backed
/// implementation from `useFakeBackend`, so going live is config — no UI
/// change.
abstract class HomeRepository {
  /// Returns the dashboard summary or throws [DashboardUnavailable].
  Future<DashboardSummary> fetchDashboard();
}
