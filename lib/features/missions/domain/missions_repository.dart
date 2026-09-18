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

/// Seam between the roadmap mission pages, the season-complete flow and the
/// mobile API.
///
/// The three `/roadmap/*` missions are deep-linked FROM the Season 1 roadmap's
/// step rows, so these screens are not optional: without them the home screen's
/// day-1..4 tasks push onto a route that does not resolve.
///
/// ## What is deliberately absent, and why
///
/// **Season 2 advancement.** The web's `/season-complete` ends in
/// `POST /api/season/advance`. There is no `season/` directory under
/// `app/api/mobile/v1/`, so that route does not exist for this client. The
/// recap therefore renders and the three paths are DESCRIBED, but the choice
/// itself is made on the web. Firing an invented path and swallowing the 404
/// would leave a user believing they had started Season 2 while the server
/// still had them on day 67 of Season 1.
///
/// **AI career suggestions.** `GET /api/ai/career-suggestions` likewise has no
/// mobile mirror, so the "New Transformation" path cannot offer the
/// AI-suggested roles. Since the whole choice is unavailable, this is moot
/// today — but it is the second route the season flow needs.
///
/// Both are reported in the summary.
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
  /// with no XP rather than failing, so a double-tap is safe.
  Future<MissionStepResult> completeStep({
    required int levelId,
    required int stepId,
  });

  /// `POST /ai/suggest-title` — returns the optimised headline.
  ///
  /// Costs XP server-side ONLY on the AI path; when the model is unavailable
  /// the service falls back to a deterministic template for free, so this never
  /// wedges the screen.
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

  /// The Season 1 recap numbers, assembled from three reads.
  ///
  /// There is no mobile equivalent of the web's server component, so:
  /// `GET /roadmap/progress` gives the day and the roadmap start,
  /// `GET /user/xp` gives the balance, and `GET /posts?status=published` is
  /// counted client-side against that start date.
  ///
  /// That last one is a page, not a count — the posts route caps at 100 per
  /// request, and one page is all a recap number is worth spending. When the
  /// envelope's `meta.pagination.hasMore` says there are more, the screen
  /// renders `100+` rather than a wrong number: see [SeasonRecap.postsAtLeast].
  Future<SeasonRecap> fetchSeasonRecap();
}
