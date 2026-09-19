/// Every mobile API path, transcribed from the route handlers under
/// `app/api/mobile/v1/**` in the web repo.
///
/// ## Read this before adding a constant
///
/// The previous version of this file was **invented independently of the real
/// API**. It named `/home/dashboard`, `/odyssey/stats`, `/odyssey/missions`,
/// `/notifications/read-all`, `/media` and `/auth/logout` — none of which
/// exist. Of the 88 verb+path combinations the server exposes, exactly three
/// were correctly wired. Every other screen rendered bundled fixtures while
/// appearing to be online.
///
/// So: **a constant here must correspond to a `route.ts` that exists.** If the
/// screen you are building needs an endpoint that is not in this file, the
/// endpoint does not exist — add it to the web repo under
/// `app/api/mobile/v1/`, in the same change. Do not invent a path and let the
/// 404 be swallowed by a `catch`.
///
/// Paths are relative to the `/api/mobile/v1` base URL in `AppConfig`.
/// Fixed paths are `static const`; parameterised ones are `static String fn()`.
class ApiPaths {
  const ApiPaths._();

  // ── Auth ────────────────────────────────────────────────────────────────
  // There is deliberately no `logout`: the server has no such route. Signing
  // out is purely local (clear the session store); the old client POSTed to
  // /auth/logout and swallowed the 404 on every sign-out.
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';

  // ── Google sign-in ──────────────────────────────────────────────────────
  // The browser-OAuth bridge. The app never sees the Google client id: it asks
  // the server for a finished authorize URL, opens it, and hands the code back.
  /// POST a PKCE challenge, get a Google authorize URL.
  static const String googleAuthUrl = '/auth/google/auth-url';

  /// POST `{code, state, codeVerifier}`. Answers `signed_in` OR
  /// `consent_required` — both as a 200, discriminated on `status`.
  static const String googleExchange = '/auth/google/exchange';

  /// POST the signup ticket plus the user's consent decisions. Creates the
  /// account. Only reached after `consent_required`.
  static const String googleComplete = '/auth/google/complete';

  /// GET / POST / DELETE — the Google link on an already-signed-in account.
  ///
  /// The escape hatch from the sign-in refusal: a password account cannot be
  /// auto-linked to Google (anyone can pre-register an address, and both
  /// register routes mark it verified without mailing it), so the user links
  /// it deliberately from Settings once they have proved the password.
  ///
  /// POST takes the same `{code, state, codeVerifier}` as [googleExchange] —
  /// the browser hand-off is identical, only the destination differs.
  static const String linkGoogle = '/user/link-google';

  /// GET / PATCH — the DPDP s6 consent ledger. GET answers
  /// `{noticeVersion, consents[]}`; PATCH takes `{purpose, granted}`.
  static const String userConsent = '/user/consent';

  /// GET — DPDP s11. Everything held about the user, including the identities
  /// of the recipients it has been shared with.
  static const String userDataExport = '/user/data-export';

  /// DELETE — DPDP s12 erasure. Irreversible. Body
  /// `{confirm: 'DELETE MY ACCOUNT', password?}`.
  static const String userAccount = '/user/account';

  /// POST — starts Season 2. `{choice, targetRole?}`. Idempotent.
  static const String seasonAdvance = '/season/advance';

  /// Warm-boot check — validates the stored token AND returns fresh role /
  /// subscription state that is deliberately not in the token payload.
  static const String me = '/auth/me';

  // ── User ────────────────────────────────────────────────────────────────
  /// GET returns the row, or `{exists: false}` when the user has none yet.
  /// PATCH is a partial upsert — send only what changed. There is no PUT on
  /// mobile, by design.
  static const String userPreferences = '/user/preferences';
  static const String userXp = '/user/xp';

  /// The auto-post kill switch. PATCH `{enabled: bool}`.
  ///
  /// Deliberately NOT a field on [userPreferences]: enabling it stamps a
  /// resume time, re-arms the next Cloud Task and clears stale "paused"
  /// notifications. It is a state machine, not a preference.
  static const String userAutoPostToggle = '/user/autopost-toggle';

  // ── Onboarding finalise chain ───────────────────────────────────────────
  // Called in order when onboarding completes. Skipping them is why a
  // mobile-onboarded user used to reach the dashboard with no roadmap and the
  // planner with no week.
  static const String onboardingDeriveAudience = '/onboarding/derive-audience';
  static const String aiInitWeekPlan = '/ai/init-week-plan';
  static const String aiGenerateRoadmap = '/ai/generate-roadmap';

  // ── Persona ─────────────────────────────────────────────────────────────
  /// Everything Plexa knows about the user: identity + the Substance Bank.
  static const String persona = '/persona';
  static const String personaHarvest = '/persona/harvest';
  static const String personaAudience = '/persona/audience';
  static const String personaChat = '/persona/chat';

  /// Applies proposals the user accepted from a chat turn. A chat turn never
  /// writes on its own.
  static const String personaApply = '/persona/apply';

  // ── Home ────────────────────────────────────────────────────────────────
  static const String dashboard = '/dashboard';

  /// GET returns roadmap progress; POST records a completed step.
  static const String roadmapProgress = '/roadmap/progress';

  // ── Planner ─────────────────────────────────────────────────────────────
  // Added to the mobile API by the web-alignment work; there was no planner
  // surface on mobile before, so the Plan tab had nothing to call.
  /// GET the week plan (?week=&season=); PATCH one slot.
  static const String planner = '/planner';

  /// GET the Sunday article; POST to record that the user published it
  /// themselves. LinkedIn's API cannot publish an article, so the app never
  /// pushes one — it prepares a body and the user pastes it.
  static const String plannerArticle = '/planner/article';

  /// POST — writes the post for one planner slot. `{planId, slotIndex, force}`.
  ///
  /// The planner's primary action, and the last thing keeping the mobile
  /// planner read-only. `force: true` is Regenerate: it replaces the existing
  /// draft and deletes the superseded one. Costs XP, so a 402 here is an
  /// answer, not a fault.
  static const String plannerGeneratePost = '/planner/generate-post';

  /// POST — the carousel equivalent of [plannerGeneratePost], for a slot whose
  /// `format` is `carousel`. Same claim and rollback; XP is charged inside the
  /// carousel generator rather than by a gate in front of it.
  static const String plannerGenerateCarousel = '/planner/generate-carousel';

  /// POST `{planId, topic}` — replaces the week's topic and rewrites the days
  /// that have not been written yet. Free; days already generated keep their
  /// posts.
  static const String plannerChangeTopic = '/planner/change-topic';

  /// POST `{planId, slotIndex}` — rewrites one day's title. Free.
  static const String plannerRegenerateTitle = '/planner/regenerate-title';

  // ── Posts ───────────────────────────────────────────────────────────────
  static const String posts = '/posts';

  /// `id` is the SERVER id (a cuid), never the local Drift autoincrement.
  /// Sending the local int is what made every publish 404.
  static String post(String id) => '/posts/$id';
  static String postPublish(String id) => '/posts/$id/publish';

  // ── Scheduling ──────────────────────────────────────────────────────────
  static const String schedules = '/schedules';
  static String schedule(String id) => '/schedules/$id';

  static const String topics = '/topics';
  static String topic(String id) => '/topics/$id';

  // ── LinkedIn ────────────────────────────────────────────────────────────
  static const String linkedInAccounts = '/linkedin/accounts';
  static const String linkedInAnalytics = '/linkedin/analytics';
  static const String linkedInAuthUrl = '/linkedin/auth-url';
  static const String linkedInExchange = '/linkedin/exchange';
  static const String linkedInPosts = '/linkedin/posts';
  static const String linkedInComments = '/linkedin/comments';
  static const String linkedInCommentsReact = '/linkedin/comments/react';
  static const String linkedInOrganizations = '/linkedin/organizations';
  static const String linkedInCompanyPost = '/linkedin/company-post';
  static const String linkedInCompanyBanner = '/linkedin/company-banner';
  static const String linkedInAdvocacy = '/linkedin/posts/advocacy';
  static const String linkedInReshare = '/linkedin/posts/reshare';

  // ── Notifications ───────────────────────────────────────────────────────
  // NOTE: there is no device-registration endpoint. The old client POSTed to
  // `/notifications/devices` on every launch and 404ed silently. Push cannot
  // work until that route is added server-side.
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';

  /// PATCH with an EMPTY body marks it read. Idempotent; 404 when not owned.
  static String notification(String id) => '/notifications/$id';

  // ── AI ──────────────────────────────────────────────────────────────────
  static const String aiGenerate = '/ai/generate';
  static const String aiImage = '/ai/image';
  static const String aiPoster = '/ai/poster';
  static const String aiCarousel = '/ai/carousel';
  static const String aiHeadshot = '/ai/headshot';
  static const String aiComments = '/ai/comments';
  static const String aiGenerateComment = '/ai/generate-comment';
  static const String aiGeneratePoll = '/ai/generate-poll';
  static const String aiGenerateAbout = '/ai/generate-about';
  static const String aiConnections = '/ai/connections';
  static const String aiConnectionMessage = '/ai/connection-message';
  static const String aiRecommendationRequest = '/ai/recommendation-request';
  static const String aiSuggestTopics = '/ai/suggest-topics';
  static const String aiSuggestTitle = '/ai/suggest-title';
  static const String aiSuggestSkills = '/ai/suggest-skills';
  static const String aiSuggestGroups = '/ai/suggest-groups';
  static const String aiAnalyzePost = '/ai/analyze-post';
  static const String aiAnalyzeProfession = '/ai/analyze-profession';
  static const String aiAnalyzeStyleScreenshot = '/ai/analyze-style-screenshot';
  static const String aiLinkedInProfile = '/ai/linkedin-profile';
  static const String aiParseCv = '/ai/parse-cv';
  static const String aiStyleMemory = '/ai/style-memory';
  static const String aiTrendingPosts = '/ai/trending-posts';

  /// The only GET under /ai.
  static const String aiStrategy = '/ai/strategy';

  // ── Studio ──────────────────────────────────────────────────────────────
  static const String studioAccess = '/studio/access';
  static const String studioDesigns = '/studio/designs';
  static String studioDesign(String id) => '/studio/designs/$id';
  static const String studioTemplates = '/studio/templates';
  static const String studioAiDesigner = '/studio/ai-designer';
  static const String studioCopy = '/studio/copy';

  // ── Festive ─────────────────────────────────────────────────────────────
  static const String festiveTemplates = '/festive/templates';
  static const String festiveGenerate = '/festive/generate';

  // ── Integrations ────────────────────────────────────────────────────────
  static const String slackStatus = '/slack/status';
  static const String slackAuthUrl = '/slack/auth-url';
  static const String slackExchange = '/slack/exchange';

  /// DELETE disconnects.
  static const String slack = '/slack';

  static const String googleCalendarStatus = '/google-calendar/status';
  static const String googleCalendarAuthUrl = '/google-calendar/auth-url';
  static const String googleCalendarExchange = '/google-calendar/exchange';

  /// DELETE disconnects.
  static const String googleCalendar = '/google-calendar';

  // ── Money ───────────────────────────────────────────────────────────────
  static const String geoPricing = '/geo/pricing';
  static const String paymentCreateOrder = '/payment/create-order';
  static const String paymentVerify = '/payment/verify';
  static const String subscriptionCreate = '/subscription/create';
  static const String subscriptionVerify = '/subscription/verify';
  static const String referral = '/referral';
  static const String referralApply = '/referral/apply';

  // ── Media ───────────────────────────────────────────────────────────────
  static const String uploadImage = '/upload/image';
}
