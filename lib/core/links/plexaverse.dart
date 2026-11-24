/// Plexaverse's own public pages.
///
/// Separate from `linkedin.dart` because the two answer different questions:
/// that file is "where does this app send people on LinkedIn", this one is
/// "which of our own pages does the app link to".
///
/// The host matches `SITE_URL` in the web's `lib/seo.ts`
/// (`https://www.plexaverse.com`), not the API base in
/// `core/config/api_environment.dart`. They look alike and are not the same
/// thing: the API base changes per flavour and points at a Cloud Run origin
/// in dev, which has no `/terms` page to show anyone. A legal notice has one
/// address in every build.
library;

const String _site = 'https://www.plexaverse.com';

/// Terms of Service. `app/(legal)/terms` on the web.
const String plexaverseTermsUrl = '$_site/terms';

/// The Privacy Notice — the document the DPDP consent gate refers to.
///
/// `app/(legal)/privacy` on the web, and the same page the web's login form
/// links from its consent line. Under DPDP s5 the notice has to be reachable
/// at the moment consent is taken; a sign-up form that names it and cannot
/// open it is the gap this closes.
const String plexaversePrivacyUrl = '$_site/privacy';

/// The published rules of the levels — every figure, how the top learners
/// are chosen, what a shoutout is, how claims are checked and how to appeal.
/// `app/(legal)/levels/rules` on the web, titled "How levels, XP and
/// shoutouts work" (LEGAL_CONSISTENCY_MEMO §3.A.5).
///
/// Opened on the web rather than rebuilt here: every number on that page is
/// read from the round's own stored rules, and a second copy in the app
/// would be the one that drifts. The page is public: the browser it opens
/// in has no web session. (`/contest/rules`, which builds before 24 Nov 2026
/// open, is a permanent redirect to it.)
const String plexaverseLevelsRulesUrl = '$_site/levels/rules';

/// The learner's removed claims and their appeals — where a revoke notice
/// leads (`CONTEST_APPEALS_PATH` on the web). The app has no appeal form of
/// its own: a revoke is appealed there, once, within its window.
const String plexaverseLevelsAppealsUrl = '$_site/levels/appeals';

/// Someone's public Plexaverse profile (owner, 24 Nov 2026) — the page at
/// `www.plexaverse.com/<handle>`. Built only from a handle the server sent.
String plexaverseProfileUrl(String handle) => '$_site/$handle';
