/// Every LinkedIn URL this app knows, in one place.
///
/// ## Why they live together
///
/// These were scattered, and most of them were not URLs at all. One search
/// builder sat in the engagement domain; the mission hand-off card composed a
/// profile path inline; and five more destinations existed only as English
/// instructions telling the user where to navigate by hand — "set it as your
/// LinkedIn cover photo", "Settings › Data privacy › Get a copy of your data".
/// Those sentences were written when the app had no URL launcher and there was
/// nothing else to offer.
///
/// One file means a destination can be checked against the web in one place,
/// and a reader looking for "where does this app send people on LinkedIn" has
/// somewhere to look. Each constant names the web file it came from: when
/// LinkedIn moves a page both have to change, and the comment is how the
/// second one gets found.
///
/// Nothing here opens anything. Opening goes through `openLinkOrCopy` in
/// `core/ui/widgets/open_link.dart`, which is also where the fallback lives.
library;

// ─── Fixed destinations ────────────────────────────────────────────────────

/// LinkedIn's own article editor.
///
/// The Sunday article cannot be published through the API — there is no
/// article endpoint and no newsletter endpoint, and the personal scope set
/// covers UGC shares only. So the app prepares the article and hands it over:
/// copy the body, open this, paste.
///
/// From `LINKEDIN_ARTICLE_COMPOSER_URL` in
/// `components/planner/SundayArticlePanel.tsx`.
const String linkedInArticleComposerUrl =
    'https://www.linkedin.com/article/new/';

/// The signed-in member's own profile, with the photo editor in reach.
///
/// `/in/me/` resolves server-side to whoever is signed in, so it needs no
/// slug and works for an account this app has never seen — which matters,
/// because the headshot flow runs before any LinkedIn account is required.
///
/// From `app/(dashboard)/headshots/page.tsx`.
const String linkedInOwnProfileUrl =
    'https://www.linkedin.com/in/me/?isSelfProfile=true';

/// The same profile without the photo-editor hint.
///
/// From `app/(dashboard)/company-banner/page.tsx`.
const String linkedInOwnProfilePlainUrl = 'https://www.linkedin.com/in/me/';

/// LinkedIn's creator analytics, where the reach export lives.
///
/// From `EXPORT_URL` in `app/(dashboard)/persona/PersonaClient.tsx`.
const String linkedInCreatorAnalyticsUrl =
    'https://www.linkedin.com/analytics/creator/content/';

/// LinkedIn itself.
///
/// The banner mission's hand-off has no deeper target, and neither does the
/// web's — `app/(dashboard)/roadmap/banner-blueprint/page.tsx` opens the bare
/// domain, because the cover-photo editor has no addressable URL.
const String linkedInHomeUrl = 'https://www.linkedin.com';

// ─── Composed destinations ─────────────────────────────────────────────────

/// A member profile by vanity slug, optionally at one of its edit forms.
///
/// [editPath] is a path under `linkedin.com/in/{slug}/`, e.g.
/// `edit/forms/intro/new/`. Empty gives the plain profile.
String linkedInProfileUrl(String slug, {String editPath = ''}) =>
    'https://www.linkedin.com/in/$slug/$editPath';

/// A company page by its organisation id.
///
/// The server builds the same string when it reports where a company banner
/// landed; this exists for the callers that only hold the id.
String linkedInCompanyPageUrl(String organizationId) =>
    'https://www.linkedin.com/company/$organizationId/';

// ─── Search ────────────────────────────────────────────────────────────────

/// ## Why the app builds search URLs at all
///
/// The engagement screens are search briefs: the app writes a comment or a
/// connection note, and the user has to go and find something on LinkedIn to
/// attach it to. Both screens used to end with "copy these search terms and
/// paste them into LinkedIn search" — three manual steps standing between a
/// finished draft and the thing it is for. A URL collapses them into one tap.
///
/// ## The two verticals are not interchangeable
///
/// Comments need POSTS to comment on; connections need PEOPLE to write to.
/// LinkedIn puts those behind different paths, and sending one screen's query
/// to the other's vertical returns a confidently wrong page rather than an
/// error — people results for "remote onboarding first week", or post results
/// for "Head of Product Razorpay". So they are two functions with their own
/// names, not one function with a parameter.
///
/// The `origin` values are copied from the callers being matched rather than
/// invented: the web's comments page sends `GLOBAL_SEARCH_HEADER`, and
/// `findConnections()` in the server's `ai.service.ts` stamps
/// `SWITCH_SEARCH_VERTICAL` onto every `linkedinSearchUrl` it emits. LinkedIn
/// reads it as analytics about where a search came from. Matching the web
/// keeps one story in their logs instead of two, and costs nothing.

/// Posts matching [keywords] — what the comments screen looks for.
///
/// Mirrors `app/(dashboard)/comments/page.tsx`, which builds this string
/// inline in both `copyComment` and `openSearch`.
String linkedInContentSearchUrl(String keywords) {
  final String query = Uri.encodeComponent(keywords.trim());
  return 'https://www.linkedin.com/search/results/content/'
      '?keywords=$query&origin=GLOBAL_SEARCH_HEADER';
}

/// People matching [query] — what the connections screen looks for.
///
/// Only used as a FALLBACK. The server sends `linkedinSearchUrl` on every
/// connection, so this runs for a target whose URL arrived empty — an older
/// server, or the field's `@Default('')`. Building it here rather than
/// disabling the button means a missing field costs the user nothing, and the
/// formula is the server's own so the two cannot drift into different results.
String linkedInPeopleSearchUrl(String query) {
  final String encoded = Uri.encodeComponent(query.trim());
  return 'https://www.linkedin.com/search/results/people/'
      '?keywords=$encoded&origin=SWITCH_SEARCH_VERTICAL';
}
