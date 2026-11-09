import 'roadmap_progress.dart';

export 'roadmap_progress.dart';

/// Thrown when the home screen cannot be loaded. One sentinel per feature,
/// matching the posts/planner slices — the UI maps it to a single retryable
/// error card rather than branching on a typed taxonomy.
class HomeUnavailable implements Exception {
  const HomeUnavailable();
}

/// Seam between the home screen and the backend.
///
/// One read, no writes. That is not an oversight: on the web the roadmap
/// **never** POSTs a completion from the dashboard. The step rows only
/// navigate — completion happens server-side when the work actually lands.
/// Adding a tick-to-complete affordance here would let a user mark a post
/// published without publishing one.
///
/// There used to be a second read, `GET /user/xp`, for the balance chip in the
/// header. Wallet XP was retired on 10 Nov 2026 — the plan pays for AI
/// features now — and that route answers 0 for everyone, so the read is gone
/// rather than kept alive to draw a number that can no longer move.
abstract class HomeRepository {
  /// `GET /roadmap/progress`.
  Future<RoadmapProgress> fetchRoadmapProgress();
}
