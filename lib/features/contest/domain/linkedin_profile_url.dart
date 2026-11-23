/// A learner's public LinkedIn profile link — the "View on LinkedIn" of a
/// contest shoutout. A port of the web's `lib/linkedin-profile-url.ts`, so
/// the card checks a paste with the same rule the server enforces.
///
/// ## Why the learner types it
///
/// Nothing we hold names a personal profile's public address: LinkedIn's
/// sign-in returns a member id, a name, a photo and an email — never the
/// vanity name. So a learner who agrees to be featured pastes their own link,
/// once, on the consent card.
///
/// ## Exactly one shape is accepted
///
/// https, on exactly `www.linkedin.com` or `linkedin.com`, path
/// `/in/<slug>`. A country subdomain, a look-alike host, credentials in the
/// authority, another scheme, a company page, a post or a sub-page of a
/// profile is refused. Tracking LinkedIn's share sheet appends and a trailing
/// slash are dropped, and what is kept is ALWAYS rebuilt from the slug:
/// `https://www.linkedin.com/in/<slug>`, never the string that was pasted.
///
/// Where Dart's URI parser is stricter than the browser's (a backslash, a
/// scheme with no slashes), a paste is refused here that the server might
/// take. That is the safe direction: the server re-checks every link, and
/// this exists only so the learner hears about a bad one first.
///
/// ## Never fetched
///
/// A profile link is handed to the OS for another learner to open, and
/// nothing here resolves, follows or checks it against LinkedIn.
library;

/// The longest input looked at, before any parsing.
/// `LINKEDIN_PROFILE_URL_MAX_CHARS`.
const int kLinkedInProfileUrlMaxChars = 300;

/// A LinkedIn custom URL: 3–100 letters, digits or hyphens, plus the
/// underscore some older vanity names carry. Never `%`, `.` or `/`.
final RegExp _slug = RegExp(r'^[A-Za-z0-9_-]{3,100}$');
final RegExp _onlyPunctuation = RegExp(r'^[-_]+$');
final RegExp _bareHost = RegExp(
  r'^(www\.)?linkedin\.com/',
  caseSensitive: false,
);
final RegExp _spaceOrControl = RegExp(r'[\s\u0000-\u001f\u007f]');
final RegExp _profilePath = RegExp(r'^/in/([^/]+)/?$');

const Set<String> _hosts = <String>{'www.linkedin.com', 'linkedin.com'};

/// The canonical `https://www.linkedin.com/in/<slug>` for a link that is a
/// public LinkedIn profile, or null for anything else.
///
/// A paste without a scheme (`linkedin.com/in/asha`) is read as https — the
/// host rule still applies in full. An explicit `http:` is refused.
String? normaliseLinkedInProfileUrl(String? raw) {
  if (raw == null) return null;
  final String t = raw.trim();
  if (t.isEmpty || t.length > kLinkedInProfileUrlMaxChars) return null;
  // Whitespace or control characters inside a link are never a profile.
  if (_spaceOrControl.hasMatch(t)) return null;

  final String withScheme = _bareHost.hasMatch(t) ? 'https://$t' : t;
  final Uri? parsed = Uri.tryParse(withScheme);
  if (parsed == null) return null;
  // Resolve dot segments as the browser does, so `/in/x/../../company/y`
  // arrives as `/company/y` and fails the path rule.
  final Uri u = parsed.normalizePath();
  if (u.scheme != 'https') return null;
  if (u.userInfo.isNotEmpty || u.hasPort) return null;
  if (!_hosts.contains(u.host.toLowerCase())) return null;

  final RegExpMatch? m = _profilePath.firstMatch(u.path);
  if (m == null) return null;
  final String slug = m.group(1)!;
  if (!_slug.hasMatch(slug) || _onlyPunctuation.hasMatch(slug)) return null;

  return 'https://www.linkedin.com/in/${slug.toLowerCase()}';
}

/// Is this a public LinkedIn profile link the server would accept?
bool isLinkedInProfileUrl(String? raw) =>
    normaliseLinkedInProfileUrl(raw) != null;

/// The link to open for a STORED one: re-checked on the way out, so a row
/// written by hand (or by an older rule) can never hand the OS a `javascript:`
/// or off-site address from someone else's card. Null opens nothing.
String? profileHref(String? stored) => normaliseLinkedInProfileUrl(stored);
