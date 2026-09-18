import '../../preferences/domain/user_preferences.dart';
import 'roadmap_progress.dart';
import 'xp_balance.dart';

export 'roadmap_progress.dart';
export 'xp_balance.dart';

/// Thrown when the home screen cannot be loaded. One sentinel per feature,
/// matching the posts/planner slices — the UI maps it to a single retryable
/// error card rather than branching on a typed taxonomy.
class HomeUnavailable implements Exception {
  const HomeUnavailable();
}

/// Seam between the home screen and the backend.
///
/// Three reads, no writes. That is not an oversight: on the web the roadmap
/// **never** POSTs a completion from the dashboard. Season 1's step rows only
/// navigate, and Season 2's habit rows thread a `handleComplete` that the row
/// never calls — completion happens server-side when the work actually lands.
/// Adding a tick-to-complete affordance here would let a user mark a post
/// published without publishing one.
abstract class HomeRepository {
  /// `GET /roadmap/progress`.
  Future<RoadmapProgress> fetchRoadmapProgress();

  /// `GET /user/xp`.
  Future<XpBalance> fetchXpBalance();

  /// `GET /user/preferences`.
  ///
  /// Lives here rather than in a preferences slice because the preferences
  /// feature currently has a domain model and nothing else, and the home
  /// screen cannot choose between Season 1 and Season 2 without it. See the
  /// note on `homeUserPreferencesProvider`.
  Future<UserPreferences> fetchPreferences();
}
