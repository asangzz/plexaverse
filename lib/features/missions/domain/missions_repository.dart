import 'mission_models.dart';

export '../../preferences/domain/user_preferences.dart';
export 'mission_models.dart';

/// Thrown when a mission read or write cannot be satisfied.
///
/// One const sentinel for the whole slice, matching planner / settings: the UI
/// branches on "this did not work", never on a typed taxonomy.
class MissionUnavailable implements Exception {
  const MissionUnavailable();
}

/// Seam between the roadmap mission pages, the journey-complete recap and the
/// mobile API.
///
/// The three `/roadmap/*` missions are deep-linked FROM the journey roadmap's
/// step rows, so these screens are not optional: without them the home screen's
/// day-1..4 tasks push onto a route that does not resolve.
///
/// Starting a new journey is not on this seam: it is one write owned by
/// `JourneyStartController` (application/journey_controller.dart).
abstract class MissionsRepository {
  /// `GET /user/preferences`, plus the LinkedIn slug lifted out of the nested
  /// `user` object. See [MissionProfile].
  Future<MissionProfile> fetchProfile();

  /// Partial upsert of the preferences row. **Send only what changed** — the
  /// server's schema is `.strict()`, so an unknown key rejects the WHOLE
  /// payload with a 400 rather than being ignored.
  Future<MissionProfile> updatePreferences(Map<String, dynamic> patch);

  /// `POST /roadmap/progress` — marks one step of one day complete.
  ///
  /// Idempotent server-side: a second call answers `alreadyCompleted: true`
  /// rather than failing, so a double-tap is safe.
  Future<MissionStepResult> completeStep({
    required int levelId,
    required int stepId,
  });

  /// `POST /ai/suggest-title` — returns the optimised headline.
  ///
  /// When the model is unavailable the service falls back to a deterministic
  /// template, so this never wedges the screen.
  Future<String> suggestHeadline({
    required String headline,
    required String priority,
  });

  /// `POST /ai/generate-about` — returns the three-paragraph About body.
  Future<String> generateAbout({
    required String profession,
    required String priority,
    String? headline,
    String? industry,
  });

  /// `GET /studio/templates?category=banner&includeData=true`.
  ///
  /// `includeData` is what makes the carousel possible: without it the response
  /// carries no element tree and there is nothing to preview or personalise.
  Future<List<BannerTemplate>> fetchBannerTemplates();

  /// The finished journey's recap numbers, assembled from two reads.
  ///
  /// There is no mobile equivalent of the web's server component, so:
  /// `GET /roadmap/progress` gives the day and the roadmap start, and
  /// `GET /posts?status=published` is counted client-side against that start
  /// date. (`GET /user/xp` is no longer read: wallet XP is retired and it
  /// always answers 0.)
  ///
  /// That last one is a page, not a count — the posts route caps at 100 per
  /// request, and one page is all a recap number is worth spending. When the
  /// envelope's `meta.pagination.hasMore` says there are more, the screen
  /// renders `100+` rather than a wrong number: see [SeasonRecap.postsAtLeast].
  Future<SeasonRecap> fetchSeasonRecap();
}
