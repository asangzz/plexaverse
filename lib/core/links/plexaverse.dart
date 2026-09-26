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
