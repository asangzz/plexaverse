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
  /// `{noticeVersion, consents[]}`; PATCH takes `{purpose, granted, source?}`.
  ///
  /// `source` is where the user was asked: `settings` (the default) or
  /// `in_context`, for a card on the screen that needs the consent — the
  /// placement test's writing step asks for `assessment_grading` there. The
  /// ledger is the evidence of how consent was given, so a card must not be
  /// recorded as a settings toggle.
  static const String userConsent = '/user/consent';

  /// GET — DPDP s11. Everything held about the user, including the identities
  /// of the recipients it has been shared with.
  static const String userDataExport = '/user/data-export';

  /// DELETE — DPDP s12 erasure. Irreversible. Body
  /// `{confirm: 'DELETE MY ACCOUNT', password?}`.
  static const String userAccount = '/user/account';

  /// GET / PUT / DELETE — DPDP s14. Who may act for the user if they cannot.
  static const String userNomination = '/user/nomination';

  /// GET / POST — DPDP s13. Raise a concern, and see the deadline it carries.
  static const String userGrievance = '/user/grievance';

  /// WhatsApp status, resume-after-STOP (PATCH) and disconnect (DELETE).
  static const String userWhatsApp = '/user/whatsapp';

  /// Send a code (POST) and check it (PUT). Rate-limited as AUTH, not API:
  /// every send costs money and lands on a phone the caller merely TYPED.
  static const String userWhatsAppVerify = '/user/whatsapp/verify';

  /// POST multipart `file` — the `.xlsx` LinkedIn lets a member download.
  ///
  /// The only route to personal-profile analytics: LinkedIn shares none of
  /// it with any app, so without the export the reach screen has nothing to
  /// show.
  /// Records a follower count the user typed, and reads the latest one back.
  ///
  /// The only path for this number that does not require fetching LinkedIn's
  /// .xlsx export first — a desktop errand. Without a reading the roadmap's
  /// phase checkpoints are decoration: it can name the target and cannot say
  /// how far away the user is.
  static const String personaReach = '/persona/reach';

  static const String personaReachImport = '/persona/reach/import';

  /// GET the follower series plus a server-computed growth rate.
  ///
  /// `personaReach` answers "where am I now"; a checkpoint raises a different
  /// question — "am I moving" — and this is the only route that answers it.
  /// Optional `?days=N` trims the window.
  static const String personaReachHistory = '/persona/reach/history';

  /// POST — starts a new journey after day 1000. `{targetRole?}`. Idempotent.
  ///
  /// The path still says "season" because it is the server's compatibility
  /// alias; the journey has no seasons and no user-facing copy may say so.
  static const String seasonAdvance = '/season/advance';

  /// Warm-boot check — validates the stored token AND returns fresh role /
  /// subscription state that is deliberately not in the token payload.
  static const String me = '/auth/me';

  // ── User ────────────────────────────────────────────────────────────────
  /// GET returns the row, or `{exists: false}` when the user has none yet.
  /// PATCH is a partial upsert — send only what changed. There is no PUT on
  /// mobile, by design.
  static const String userPreferences = '/user/preferences';

  /// GET — what the plan includes, per AI feature, and how much of each is
  /// used this period: `{allowances: [{key, limit, period, label, enabled,
  /// used, remaining, periodKey, resetsAt}]}`.
  ///
  /// Replaced `/user/xp` when wallet XP was retired (10 Nov 2026). That route
  /// still answers, but always with a balance of 0, so nothing here reads it.
  static const String userAllowances = '/user/allowances';

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

  /// The roadmap's weekly connections check-in. GET answers
  /// `{reading, growth, history}`; POST `{count}` answers `{id}`.
  ///
  /// `count` is a whole number from 0 to 30,000 (LinkedIn's cap) and nothing
  /// else may ride with it: 400 VALIDATION_FAILED otherwise. LinkedIn gives no
  /// app a member's connection count, so the number is only ever what the
  /// user typed — and its growth is where the contest's connect and invite
  /// tasks show up. Free.
  static const String reachConnections = '/reach/connections';

  // ── Plexa ───────────────────────────────────────────────────────────────
  /// The day's missions as one conversation.
  ///
  /// GET returns every lane AND the cleared-item session in ONE call. The web
  /// builds the same thread from four requests because its dashboard pages
  /// have already warmed those caches; a phone opening cold would pay four
  /// sequential trips to Tokyo for one screen.
  ///
  /// It never generates and never charges — a lane with nothing prepared comes
  /// back `ready: false`, and generating goes through [aiComments] /
  /// [aiConnections] where the plan's allowance is spent on a decision the user
  /// made.
  ///
  /// POST marks one item done, or undoes it.
  static const String plexaDay = '/plexa/day';

  // ── Planner ─────────────────────────────────────────────────────────────
  // Added to the mobile API by the web-alignment work; there was no planner
  // surface on mobile before, so the Plan tab had nothing to call.
  /// GET the week plan (?week=&season=); PATCH one slot.
  static const String planner = '/planner';

  /// GET the week's article (Thursday's); POST to record that the user published it
  /// themselves. LinkedIn's API cannot publish an article, so the app never
  /// pushes one — it prepares a body and the user pastes it.
  /// Records the newsletter's name, which only the user can tell us.
  ///
  /// LinkedIn has no read API for newsletters and no write one: the user
  /// creates it by hand while publishing their first article. The preferences
  /// PATCH cannot carry it either — that schema is `.strict()` and has no such
  /// field, so a client that tried had the WHOLE patch rejected.
  static const String plannerNewsletter = '/planner/newsletter';

  /// The week's two video scripts.
  ///
  /// GET returns the week's; POST writes one on demand or marks one posted.
  /// Added server-side with the planner pivot and then reachable from nothing
  /// — the Flutter planner was served Wednesday and Friday with no way to read
  /// what had been written for them, so both days opened a sheet whose only
  /// action was rewriting the title of a script the app could not show.
  static const String plannerVideoScript = '/planner/video-script';

  static const String plannerArticle = '/planner/article';

  /// The article's body on its own.
  ///
  /// [plannerArticle] returns the summary the planner screen draws — title,
  /// thesis, sections, status, reading time. The body was 6,422 of that
  /// response's 7,148 bytes for text the screen never shows, so it moved
  /// here and is fetched when the sheet opens or Copy is tapped.
  static const String plannerArticleBody = '/planner/article/body';

  /// POST — writes the post for one planner slot. `{planId, slotIndex, force}`.
  ///
  /// The planner's primary action, and the last thing keeping the mobile
  /// planner read-only. `force: true` is Regenerate: it replaces the existing
  /// draft and deletes the superseded one. Counts against the plan's post
  /// allowance, so a 402 here (no plan, or the limit used) is an answer, not a
  /// fault.
  static const String plannerGeneratePost = '/planner/generate-post';

  /// POST — the carousel equivalent of [plannerGeneratePost], for a slot whose
  /// `format` is `carousel`. Same claim and rollback; the carousel allowance is
  /// counted inside the carousel generator rather than by a gate in front of it.
  static const String plannerGenerateCarousel = '/planner/generate-carousel';

  /// POST `{planId, topic}` — replaces the week's topic and rewrites the days
  /// that have not been written yet. Free; days already generated keep their
  /// posts.
  static const String plannerChangeTopic = '/planner/change-topic';

  /// POST `{planId, slotIndex}` — rewrites one day's title. Free.
  static const String plannerRegenerateTitle = '/planner/regenerate-title';

  // ── Contest ─────────────────────────────────────────────────────────────
  // The Business English contest: the daily path, its lesson and its LinkedIn
  // tasks. Each is the twin of the web's `/api/contest/**` route of the same
  // name and answers with the web's body inside `data` — so the DTOs mirror
  // the web's types one to one — and the web's refusal codes in `error.code`.
  //
  // READ `Failure.errorCode` BEFORE THE FAILURE'S CLASS. The statuses are the
  // web's too, and the interceptor files a 403 under AuthFailure and a 429 or
  // 503 under NetworkFailure; none of these refusals is either. NOT_ENTERED
  // ("join first") is 403 on the lesson routes and 404 on the task routes —
  // the web's own inconsistency, kept so both platforms speak one vocabulary.
  //
  // These routes were added to the web repo by the same effort as this
  // section. Push that commit first, or every constant here is a 404.

  /// GET `{overview}` — the current contest and the user's entry in it.
  /// `overview` is null when there is no contest, and that is still a 200.
  static const String contest = '/contest';

  /// POST `{showName: bool}` — joins the running contest; answers `{ok}`.
  ///
  /// `showName` is the leaderboard consent (`contest_leaderboard`), recorded
  /// server-side when true, so it must be a literal bool the user ticked:
  /// anything else is 400 VALIDATION_FAILED. 409 NOT_RUNNING when there is
  /// nothing to join.
  static const String contestJoin = '/contest/join';

  /// GET `?limit=` — the board, bare inside `data`:
  /// `{revealed, revealsOn, revealDay, rows, viewer, self}`.
  ///
  /// Until the reveal it carries no other entrant and no rank, not even the
  /// viewer's own; the server decides that, so never compute a rank here.
  static const String contestBoard = '/contest/board';

  /// GET `{path}` — this week's days and their levels, with each level's
  /// state and points.
  ///
  /// A level's `href` is a WEB path. Route on its `kind` (and `claim`), and
  /// read `href` only as "this level opens".
  static const String contestPath = '/contest/path';

  /// GET `{quiz}` — today's lesson as it stands; `quiz.status` says why there
  /// is none (no contest, not joined, not started, ended, no lesson today).
  ///
  /// POST — opens today's lesson, answering the same `{quiz}`. The day's
  /// first open writes the personal questions with a model call, so await it
  /// before the first answer: an answer that lands first fixes the day to the
  /// set questions alone. 409 NOT_RUNNING, 403 NOT_ENTERED.
  static const String contestLesson = '/contest/lesson';

  /// POST `{day, itemId, value}` — one answer; answers `{result}` with the
  /// verdict, the right option, the explanation and the points.
  ///
  /// `value` is the option's TEXT, never its index. 409 NOT_TODAY and
  /// STALE_QUIZ both mean "reload today's lesson" (the day rolled over, or the
  /// level changed); 409 NOT_RUNNING / CONFLICT, 403 NOT_ENTERED, 404 NO_QUIZ,
  /// 400 VALIDATION_FAILED.
  static const String contestQuizAnswer = '/contest/quiz/answer';

  /// GET `{level}` — today's comment level.
  ///
  /// A GET that WRITES: the day's first open builds the level with a model
  /// call. Never call it while the path says the level is locked. Not running
  /// and not entered come back as a 200 with a reason, not as refusals.
  static const String contestTaskComment = '/contest/tasks/comment';

  /// POST `{words}` — the bank words picked for the blanks, in order; answers
  /// `{result}`. Only the first submission can pay.
  ///
  /// 400 VALIDATION_FAILED; 409 NOT_RUNNING / WRONG_DAY / LOCKED / NOT_OPEN /
  /// ALREADY_DONE / CONFLICT; 404 NOT_ENTERED.
  static const String contestTaskCommentAnswer =
      '/contest/tasks/comment/answer';

  /// GET `{view}` — today's "post 5 valuable comments" task.
  ///
  /// POST `{link}` — one LinkedIn comment link; answers `{result}`. Each
  /// comment pays its share as it lands. 400 VALIDATION_FAILED / BAD_URL;
  /// 409 NOT_RUNNING / WRONG_DAY / LOCKED / REVOKED / ALREADY_DONE /
  /// DUPLICATE_URL / CONFLICT; 404 NOT_ENTERED.
  static const String contestTaskFeedComments = '/contest/tasks/feed-comments';

  /// GET — today's leaders to connect with, bare inside `data` as
  /// `{connections, profession, cached?}`: the same shape as [aiConnections].
  /// A model call on the day's first ask, then the day's batch replayed. The
  /// plan gate is lifted on a contest connect day; on any other it refuses
  /// as [aiConnections] does — a 402, read with `PlanRefusal` — and 400
  /// PROFILE_INCOMPLETE on a generic profession.
  ///
  /// POST — marks the task done; answers `{result}` (`alreadyDone` on a
  /// repeat). 409 NOT_RUNNING / WRONG_DAY / LOCKED; 404 NOT_ENTERED.
  static const String contestTaskConnect = '/contest/tasks/connect';

  /// POST multipart, field `screenshot` — the week's sent-invitations
  /// screenshot, an image of at most 8 MB; answers `{result}`. Pays on upload
  /// and is audited after.
  ///
  /// Never through [uploadImage]: that is a public bucket with a lossy
  /// re-encode, and proofs belong in the private one. Send an `image/*`
  /// content type or it is 400 INVALID_IMAGE. 413 TOO_LARGE; 400
  /// VALIDATION_FAILED; 409 WRONG_DAY / ALREADY_DONE / REVOKED / LOCKED /
  /// CONFLICT / NOT_RUNNING; 404 NOT_ENTERED; 503 STORAGE_UNAVAILABLE. There
  /// is no GET: the task's state comes from its level on [contestPath].
  static const String contestTaskInvites = '/contest/tasks/invites';

  /// GET `{view}` — this planner week, day by day.
  ///
  /// POST — "I've planned this week"; answers `{result}`. 409 NOT_READY until
  /// the week exists in the Planner; 409 NOT_RUNNING / WRONG_DAY / LOCKED;
  /// 404 NOT_ENTERED.
  static const String contestTaskPlan = '/contest/tasks/plan';

  /// POST `{kind, occurrence, postUrl}` — claims the article or a video by the
  /// link of the post the user published; answers `{result}`. Waits for an
  /// admin's approval.
  ///
  /// 400 VALIDATION_FAILED / BAD_URL; 409 NOT_RUNNING / ALREADY_DONE /
  /// TOO_EARLY / NOT_READY / LOCKED / DUPLICATE_URL / CONFLICT; 404
  /// NOT_ENTERED.
  static const String contestTaskClaim = '/contest/tasks/claim';

  // ── Placement ───────────────────────────────────────────────────────────
  // The placement test that sets the lesson level. Same vocabulary rule as the
  // contest above: read the code first.

  /// GET `{status}` — the band lessons are written at, the latest result,
  /// any attempt in progress and whether Start works now. May settle an
  /// attempt that has closed, so it is a read with a side effect.
  static const String placement = '/placement';

  /// POST — starts an attempt; answers `{step}`.
  ///
  /// 429 COOLDOWN carries `nextRetakeAt` in `error.details`, which the
  /// interceptor drops: read it off the raw response body.
  static const String placementStart = '/placement/start';

  /// POST `{attemptId, itemId, value}` — one answer, `value` being the
  /// option's TEXT; answers the next `{step}` and never says right or wrong.
  /// 400 VALIDATION_FAILED; 404 NOT_FOUND; 409 ALREADY_COMPLETE.
  static const String placementAnswer = '/placement/answer';

  /// POST `{attemptId}` — the result of an attempt whose objective parts are
  /// done, as `{result}`; "Skip writing" lands here. No model call. 409
  /// NOT_READY before those parts are done; 404 NOT_FOUND; 400.
  static const String placementFinish = '/placement/finish';

  /// POST `{attemptId, text}` — the optional writing task, graded by a model;
  /// answers `{result}`.
  ///
  /// 403 CONSENT_REQUIRED (checked first) until `assessment_grading` is
  /// granted through [userConsent]. 503 GRADING_UNAVAILABLE is retryable: the
  /// text was not stored, so keep the draft. 409 NOT_READY /
  /// ALREADY_COMPLETE; 404 NOT_FOUND; 400.
  static const String placementWriting = '/placement/writing';

  // ── Posts ───────────────────────────────────────────────────────────────
  static const String posts = '/posts';

  /// The posts LIST. Five lean rows per call — id, title, excerpt, status and
  /// a thumbnail URL — against `/posts`, which carries `imageUrl` and on the
  /// live table averages 252 KB per row because most posts hold a base64
  /// `data:` image inline. A five-row page is 2 KB here against 1.6 MB there.
  static const String postsFeed = '/posts/feed';

  /// The calendar's two buckets in one call, date-windowed and pre-split.
  ///
  /// Wraps the same `getCalendarBuckets` the web has always used: no
  /// `imageUrl`, content truncated to 280 chars, per-status caps, and a guard
  /// that drops a thumbnail which turns out to be a `data:` URL. The calendar
  /// used to read `/posts?limit=100` — 18 MB and 45 seconds on the live table
  /// — which is why it timed out.
  static const String calendar = '/calendar';

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

  /// GET — the poster styles a user can pick, with how many live references
  /// each has. A tag with no references behaves exactly like no tag, so the
  /// count is what stops the picker offering a style that would do nothing.
  static const String posterTags = '/poster-tags';

  static const String aiCarousel = '/ai/carousel';
  static const String aiHeadshot = '/ai/headshot';
  static const String aiComments = '/ai/comments';

  /// Today's five curated posts, with a drafted comment on each.
  ///
  /// GET generates on the first ask of the day and charges once for the batch;
  /// PATCH stamps one as acted. The ONLY route that can create the day —
  /// [plexaDay] deliberately reads with the service's peek half and never
  /// generates, so before this existed a phone-only user had no way to get a
  /// single curated post, on any screen.
  static const String topVoices = '/top-voices';
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

  /// Company-brand onboarding: a company document (deck, one-pager, About
  /// page) in, description / industry / tagline / features / website out.
  static const String aiParseCompanyDoc = '/ai/parse-company-doc';

  /// Company-brand onboarding: a poster the company already made in, the
  /// theme and brand colours its generated posters should match out.
  static const String aiAnalyzePosterStyle = '/ai/analyze-poster-style';
  static const String aiStyleMemory = '/ai/style-memory';
  static const String aiTrendingPosts = '/ai/trending-posts';

  /// The only GET under /ai.
  static const String aiStrategy = '/ai/strategy';

  // ── Studio ──────────────────────────────────────────────────────────────
  static const String studioAccess = '/studio/access';
  static const String studioDesigns = '/studio/designs';
  static String studioDesign(String id) => '/studio/designs/$id';
  static const String studioTemplates = '/studio/templates';

  /// Builds the company's poster template from its brand inputs. Fired, not
  /// awaited, at the end of company-brand onboarding.
  static const String studioBrandTemplate = '/studio/brand-template';
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

  /// GET — the per-region autopay flags, which decide whether a plan is sold
  /// as a subscription mandate or a one-time order. The Razorpay key is NOT
  /// here: create-order and subscription/create each return it alongside the
  /// thing it is for.
  static const String paymentConfig = '/payment/config';

  static const String paymentCreateOrder = '/payment/create-order';
  static const String paymentVerify = '/payment/verify';
  static const String subscriptionCreate = '/subscription/create';
  static const String subscriptionVerify = '/subscription/verify';
  static const String referral = '/referral';
  static const String referralApply = '/referral/apply';

  // ── Media ───────────────────────────────────────────────────────────────
  static const String uploadImage = '/upload/image';

  /// A brand asset (the company logo) uploaded without [uploadImage]'s lossy
  /// re-encode, so a transparent PNG stays transparent.
  static const String uploadAsset = '/upload/asset';
}
