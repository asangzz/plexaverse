/// The public profile's words — the web's `lib/public-profile-copy.ts`,
/// verbatim.
///
/// A consent is only as good as the words it was given to, and the web's
/// Settings card, its consent list (`PURPOSE_LABELS.public_profile`) and its
/// privacy notice all say these. The app says them too, character for
/// character, so a person agrees to the same thing on either platform.
library;

/// The consent purpose these words are for.
const String kPublicProfilePurpose = 'public_profile';

/// What the user agrees to. `PURPOSE_LABELS.public_profile`, verbatim (owner,
/// 24 Nov 2026) — `<handle>` included: it names the address, whatever the
/// handle turns out to be. "how many people follow my page" was added in
/// review, before anyone could agree: the page shows the count to everyone.
const String kPublicProfileConsentText =
    'Publish my Plexaverse profile at plexaverse.com/<handle> for anyone on '
    'the internet: my name, photo, headline, about, skills, experience and '
    'education, how many people follow my page, and the posts and newsletter '
    'articles I publish on LinkedIn through Plexaverse.';

/// The choice's own name, on the card.
const String kPublicProfileToggleLabel = 'Publish my profile';

/// Settings → Your data, under the row while it is off. It is switched ON
/// only on the Public profile section, where the handle it needs is chosen;
/// both consent routes refuse a grant without one.
const String kPublicProfileGrantInContextLine =
    'Switch this on from Settings → Public profile, where you choose your '
    'handle. You can switch it off here at any time.';

/// How it is undone, said where it is given.
const String kPublicProfileWithdrawLine =
    'It stays off unless you switch it on. Switch it off here or in Settings '
    '→ Your data & consent at any time: your page goes offline at once, your '
    'handle is freed, and the list of people following it is deleted.';

/// Said under the toggle: what appears, and when.
const String kPublicProfileAutomaticLine =
    'Posts appear on your page as soon as they are published to your own '
    'LinkedIn profile through Plexaverse, and newsletter articles — with the '
    'text Plexaverse prepared for them — once you mark them published. Posts '
    'to a company page or to another LinkedIn account you connected, drafts '
    'and scheduled posts never appear.';

/// Said beside "I published it" on the Planner's newsletter article while the
/// public profile is published: the page shows the article's text as
/// Plexaverse prepared it, not what the user changed it to in LinkedIn's
/// editor. The web's `PUBLIC_PROFILE_ARTICLE_LINE`, word for word (review of
/// 24 Nov 2026).
const String kPublicProfileArticleLine =
    'Your public profile is on: once you press “I published it”, this '
    'article’s text as written here appears on your page. If you changed it '
    'in LinkedIn’s editor, the page will not show your changes.';

/// The CV download, and what it holds.
const String kCvDownloadLine =
    'A plain, single-column PDF that applicant tracking systems can read: '
    'your name, email, LinkedIn link, headline, summary, experience, '
    'education and skills. Made when you ask for it and never stored.';

/// When there is nothing to put in a CV.
const String kCvEmptyMessage =
    'There is nothing to put in your CV yet. Add your experience, education '
    'or skills by uploading your LinkedIn profile as a PDF below, then try '
    'again.';

/// Said under the handle field while nothing is wrong with it.
const String kHandleHint =
    '3–30 letters and numbers, with single hyphens between them.';

/// Where the pages live — the web's `SITE_URL` (`lib/seo.ts`), not the API
/// base, which changes per flavour.
const String kPublicProfileHost = 'plexaverse.com/';

/// The app's own line when there is nothing to put in a CV. The web's
/// [kCvEmptyMessage] points at an upload "below" its own button; the app has
/// no PDF import beside this one, so it says where that upload is.
const String kCvEmptyAppMessage =
    'There is nothing to put in your CV yet. Add your experience, education '
    'or skills by uploading your LinkedIn profile as a PDF in Settings → '
    'Public profile on plexaverse.com, then try again.';
