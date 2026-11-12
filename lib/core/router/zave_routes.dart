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

  /// Onboarding — Plexa's intro, then the chat. Held ahead of the dashboard
  /// until completed.
  static const String onboarding = '/onboarding';

  // ── Overview ──────────────────────────────────────────────────────────────

  /// The web's signed-in landing. The web checks onboarding there and sends
  /// the user on to [contest]; the journey roadmap it used to show is
  /// [roadmap] now. Kept because onboarding finishes here and old links name
  /// it.
  static const String dashboard = '/dashboard';

  /// The Business English contest: the daily path, the standings and the
  /// week's LinkedIn tasks. The web's signed-in home since 11 Nov 2026.
  static const String contest = '/contest';

  /// The 1000-day journey as a calendar, with the follower and connection
  /// check-ins — the web's "LinkedIn Personal Branding Roadmap", which hands
  /// out no daily missions any more.
  static const String roadmap = '/roadmap';

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

  // [plexa] below is Plexa's journey again, not the old "Open Plexa" day
  // chat, which left the app with the roadmap's daily missions (web, 12 Nov
  // 2026).

  /// Plexa's journey again, for an account that has already onboarded —
  /// Settings' "Meet Plexa". The web keeps `/plexa` only as a redirect to
  /// `/onboarding`; the app's onboarding gate sends a finished account away
  /// from `/onboarding`, so the same page is mounted here instead.
  static const String plexa = '/plexa';

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

  /// Day 1000 — the finish line, and the choice to start a new journey.
  static const String journeyComplete = '/journey-complete';

  /// The old name of [journeyComplete]. Only a redirect now: shipped
  /// notifications and deep links still name it.
  static const String seasonComplete = '/season-complete';

  // The contest's levels. Each is opened from its node on the [contest] path,
  // chosen by the node's KIND. A node's `href` is the web's path for it, which
  // the web can change without the app knowing: routed blindly, a new one is
  // a "Page not found", where an unknown kind simply opens nothing.

  /// Today's lesson.
  static const String contestLesson = '/contest/lesson';

  /// The daily quiz's old address. Only a redirect to [contestLesson]: sent
  /// emails and notifications still name it.
  static const String contestQuiz = '/contest/quiz';

  /// Today's comment level — a comment completed from a word bank.
  static const String contestComment = '/contest/comment';

  /// "Post 5 valuable comments": the links to the user's own comments.
  static const String contestFeedComments = '/contest/feed-comments';

  /// Saturday's sent-invitations screenshot.
  static const String contestInvites = '/contest/invites';

  /// Sunday's level: this week, generated in the Planner.
  static const String contestPlan = '/contest/plan';

  /// Claims the article or a video by the link of its post. Reads `kind` and
  /// `occurrence` from the query.
  static const String contestClaim = '/contest/claim';

  /// The placement test that sets the lesson level.
  static const String placement = '/placement';

  /// Roadmap mission pages.
  static const String roadmapAboutOdyssey = '/roadmap/about-odyssey';
  static const String roadmapHeadlineHook = '/roadmap/headline-hook';
  static const String roadmapBannerBlueprint = '/roadmap/banner-blueprint';

  /// The design-system reference. Public on both platforms.
  static const String styleguide = '/styleguide';

  /// Routes reachable while signed out. A signed-in user who navigates to one
  /// is sent to the signed-in home instead.
  static const Set<String> preAuth = <String>{login};

  /// Routes that bypass the auth guard entirely.
  static const Set<String> public = <String>{styleguide};
}
