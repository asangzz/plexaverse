import 'analytics_entity.dart';

export 'analytics_entity.dart';

/// Thrown when analytics can't be loaded (transport/server failure or
/// offline). Online-first: the UI maps any load error to the shared
/// network-error state with retry; no cached fallback is implied here.
///
/// One const sentinel per feature (feature-slice convention) — the UI never
/// sees a typed error taxonomy, only this.
class AnalyticsUnavailable implements Exception {
  const AnalyticsUnavailable();
}

/// Seam between the Analytics tab and the backend. `analyticsRepositoryProvider`
/// (see `data/`) resolves the fake or the real Dio-backed implementation from
/// `useFakeBackend`, so going live is config — no UI change.
abstract class AnalyticsRepository {
  /// Returns the aggregated analytics for the current period or throws
  /// [AnalyticsUnavailable].
  Future<AnalyticsEntity> fetchAnalytics();
}
