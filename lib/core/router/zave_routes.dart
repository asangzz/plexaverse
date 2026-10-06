/// The web-aligned route table.
///
/// **Every path here is byte-identical to the web app's route for the same
/// screen.** That is not cosmetic: it means a deep link, a push-notification
/// payload, a roadmap task's target, or a support instruction ("go to
/// /planner") resolves to the same place on both platforms, and it keeps the
/// two navigation trees provably in sync — a route that exists on one side and
/// not the other is visible as a missing constant rather than as a silent
/// behavioural drift.
///
/// Paths map to `app/(dashboard)/…` on the web. Three routes are mobile-only
/// and marked as such; there are no others.
class ZaveRoutes {
  const ZaveRoutes._();

  // ── Pre-auth ──────────────────────────────────────────────────────────────

  /// Cold-start splash. Mobile-only: the web resolves the session server-side
  /// and has nothing to wait on.
  static const String splash = '/';

  /// Auth entry point — sign-in and create-account share one screen.
  static const String login = '/login';

  /// Biometric / device-credential re-auth gate. Mobile-only.
  static const String unlock = '/unlock';

  /// The onboarding chat. Held ahead of the dashboard until completed.
  static const String onboarding = '/onboarding';

  // ── Overview ──────────────────────────────────────────────────────────────

  /// Home. Renders the Season 1 roadmap or the Season 2 dashboard depending on
  /// `UserPreferences.currentSeason`.
  static const String dashboard = '/dashboard';

  /// Company-brand analytics. Nav visibility: company.
  static const String companyAnalytics = '/company-analytics';

  /// Company-brand comment inbox. Nav visibility: company.
  static const String companyAutoComment = '/company-auto-comment';

  // ── Creation ──────────────────────────────────────────────────────────────

  /// The content planner — the week grid built around Thursday's newsletter.
  static const String planner = '/planner';

  /// Compose, personal brand. Nav visibility: personal.
  static const String create = '/create';

  /// Compose, company brand. Nav visibility: company.
  static const String companyPost = '/company-post';

  /// Plexa Studio. Nav visibility: admin (hidden from end users in v1).
  static const String studio = '/studio';

  /// The Studio canvas. Nav visibility: admin.
  static const String studioFabric = '/studio/fabric';

  /// Nav visibility: admin.
  static const String reimagine = '/reimagine';

  /// Nav visibility: admin.
  static const String templateCreator = '/template-creator';

  /// Nav visibility: admin.
  static const String festive = '/festive';

  // ── Growth & tools ────────────────────────────────────────────────────────

  /// Nav visibility: admin.
  static const String companyAdvocacy = '/company-advocacy';

  // ── Management ────────────────────────────────────────────────────────────

  /// The persona / teach-voice surface.
  static const String persona = '/persona';

  /// The post library.
  static const String posts = '/posts';

  /// A single post. Mirrors the web's `/posts/[id]`.
  static String post(String id) => '/posts/$id';

  /// The content calendar.
  static const String calendar = '/calendar';

  /// Connected LinkedIn accounts. Nav visibility: admin.
  static const String accounts = '/accounts';

  static const String settings = '/settings';

  // ── Reached contextually, not from the nav ────────────────────────────────
  // These have no sidebar entry on the web either; they are opened from inside
  // another screen (a daily habit, a roadmap task, an upsell).

  // Open Plexa has no entry here, and that is deliberate: it has no URL on
  // the web either. It is a modal over whatever screen you are standing on —
  // see `showPlexaDay` in features/plexa.

  /// Opened from the "comment on posts" daily habit.
  static const String comments = '/comments';

  /// Opened from the "send connection requests" daily habit.
  static const String connections = '/connections';

  static const String topics = '/topics';
  static const String schedules = '/schedules';
  static const String companyBanner = '/company-banner';
  static const String headshots = '/headshots';
  static const String titleCreator = '/title-creator';
  static const String pricing = '/pricing';
  static const String seasonComplete = '/season-complete';

  /// Roadmap mission pages.
  static const String roadmapAboutOdyssey = '/roadmap/about-odyssey';
  static const String roadmapHeadlineHook = '/roadmap/headline-hook';
  static const String roadmapBannerBlueprint = '/roadmap/banner-blueprint';

  /// The design-system reference. Public on both platforms.
  static const String styleguide = '/styleguide';

  /// Routes reachable while signed out. A signed-in user who navigates to one
  /// is sent to [dashboard] instead.
  static const Set<String> preAuth = <String>{login};

  /// Routes that bypass the auth guard entirely.
  static const Set<String> public = <String>{styleguide};
}
