/// The contest's LinkedIn link rules, for the forms' inline checks.
///
/// Ports of the web's `lib/contest-week.ts` — the same functions the server
/// refuses with, so a link this accepts is one the server accepts and a
/// "duplicate" here is one the server would call a duplicate. The server
/// re-checks every link; these exist so the learner hears about a bad one
/// before they send it, in the server's own terms.
///
/// No link is ever fetched or resolved here, short links included: a
/// user-chosen URL is never requested by this product, on either side.
library;

/// The longest feed-comment link accepted, after trimming. Longer is refused,
/// never truncated. `MAX_COMMENT_URL_CHARS`.
const int kMaxCommentUrlChars = 2000;

/// The longest post link a claim accepts. The claim route's `MAX_URL_CHARS`,
/// checked beside the URL rule.
const int kMaxPostUrlChars = 500;

/// LinkedIn's own short links: `https://lnkd.in/p/<code>` — what the
/// LinkedIn app's "Copy link to comment" gives — or `https://lnkd.in/<code>`.
final RegExp _lnkdPath = RegExp(r'^/(?:p/)?[A-Za-z0-9_-]{4,64}/?$');
final RegExp _lnkdHost = RegExp(r'^lnkd\.in$', caseSensitive: false);
final RegExp _linkedInHost = RegExp(
  r'^(www\.)?linkedin\.com$',
  caseSensitive: false,
);

/// Parsed as the web's `new URL()` would accept it for these rules: https,
/// no credentials, no port. Null otherwise.
Uri? _httpsUri(String raw) {
  final Uri? u = Uri.tryParse(raw.trim());
  if (u == null || u.scheme != 'https') return null;
  if (u.userInfo.isNotEmpty || u.hasPort) return null;
  return u;
}

/// A LinkedIn post link a learner may claim the article or a video with:
/// `linkedin.com/posts/…`, `/feed/update/urn:li:…` or `/pulse/…` (an
/// article), or an lnkd.in short link — on `linkedin.com` or
/// `www.linkedin.com` only, never a country or mobile subdomain. A PREFIX
/// match: deeper paths are fine. At most [kMaxPostUrlChars].
/// `isLinkedInPostUrl`, plus the claim route's length cap.
bool isLinkedInPostUrl(String raw) {
  final String t = raw.trim();
  if (t.isEmpty || t.length > kMaxPostUrlChars) return false;
  final Uri? u = _httpsUri(t);
  if (u == null) return false;
  if (_lnkdHost.hasMatch(u.host)) return _lnkdPath.hasMatch(u.path);
  if (!_linkedInHost.hasMatch(u.host)) return false;
  return RegExp(
    r'^/(posts|feed/update|pulse)/[^/]+',
    caseSensitive: false,
  ).hasMatch(u.path);
}

/// A link to a comment the learner posted, as "Copy link to comment" gives
/// it: a `/feed/update/…` or `/posts/…` post with or without a `commentUrn`,
/// or an lnkd.in short link. EXACTLY one segment after the prefix — a suffix
/// would spell one comment a new way. Articles (`/pulse/`), profiles,
/// searches, other hosts and `in.` / `m.` subdomains are refused.
/// `isLinkedInCommentUrl`.
bool isLinkedInCommentUrl(String raw) {
  final String t = raw.trim();
  if (t.isEmpty || t.length > kMaxCommentUrlChars) return false;
  final Uri? u = _httpsUri(t);
  if (u == null) return false;
  if (_lnkdHost.hasMatch(u.host)) return _lnkdPath.hasMatch(u.path);
  if (!_linkedInHost.hasMatch(u.host)) return false;
  return RegExp(
    r'^/(posts|feed/update)/[^/]+/?$',
    caseSensitive: false,
  ).hasMatch(u.path);
}

/// The query parameters that name a comment, in the order the normalised
/// link keeps them.
const List<String> _commentIdParams = <String>[
  'commentUrn',
  'replyUrn',
  'dashCommentUrn',
  'dashReplyUrn',
];

/// The first non-empty value of [name], as the web's
/// `searchParams.get(name) || …` reads it — the FIRST, where Dart's
/// `queryParameters` would keep the last.
String? _param(Uri u, String name) {
  final List<String>? all = u.queryParametersAll[name];
  if (all == null || all.isEmpty || all.first.isEmpty) return null;
  return all.first;
}

String _decoded(String path) {
  try {
    return Uri.decodeComponent(path);
  } on ArgumentError {
    // A malformed escape: compare it as written.
    return path;
  }
}

/// One comment, one spelling: https, `www.linkedin.com`, the path decoded
/// and without a trailing slash, and only the comment-identifying query
/// parameters, in a fixed order. A short link is its code, case kept, no
/// query. Only for a link [isLinkedInCommentUrl] accepted.
/// `normaliseCommentUrl`.
String normaliseCommentUrl(String raw) {
  final Uri u = Uri.parse(raw.trim());
  if (_lnkdHost.hasMatch(u.host)) {
    return 'https://lnkd.in${u.path.replaceAll(RegExp(r'/+$'), '')}';
  }
  final String path = _decoded(u.path)
      .replaceAll(RegExp(r'/+$'), '')
      .replaceFirstMapped(
        RegExp(r'^/(posts|feed/update)/', caseSensitive: false),
        (Match m) => '/${m.group(1)!.toLowerCase()}/',
      );
  final List<String> kept = <String>[
    for (final String name in _commentIdParams)
      if (_param(u, name) case final String v)
        '$name=${Uri.encodeComponent(v)}',
  ];
  return 'https://www.linkedin.com$path${kept.isEmpty ? '' : '?${kept.join('&')}'}';
}

/// The comment's own id out of a comment URN, in either form LinkedIn
/// writes: `urn:li:comment:(<post>,C)` puts it last,
/// `urn:li:fsd_comment:(C,<post>)` first. Anything else falls back to its
/// digit runs, sorted, then to the text itself.
String _commentIdOf(String urn) {
  final RegExpMatch? dash = RegExp(
    r'fsd_comment:\((\d+),',
    caseSensitive: false,
  ).firstMatch(urn);
  if (dash != null) return dash.group(1)!;
  final RegExpMatch? plain = RegExp(
    r'comment:\(.*,\s*(\d+)\s*\)',
    caseSensitive: false,
  ).firstMatch(urn);
  if (plain != null) return plain.group(1)!;
  final List<String> runs = <String>{
    for (final Match m in RegExp(r'\d+').allMatches(urn)) m.group(0)!,
  }.toList()..sort();
  return runs.isNotEmpty ? runs.join(',') : urn.toLowerCase();
}

/// The identity of the comment a link points at — what the duplicate checks
/// compare. Links that differ only in spelling are one comment: `/posts/`
/// against `/feed/update/`, a `commentUrn` against the same comment's
/// `dashCommentUrn`, a changed case or a trailing slash.
///
///  - a reply id → that reply;
///  - else a comment id → that comment;
///  - else the post, by its activity / ugcPost / share id;
///  - else the normalised link.
///
/// A short link's code is its identity: it cannot be read without resolving
/// it, which nothing does. Only for a link [isLinkedInCommentUrl] accepted.
/// `commentIdentity`.
String commentIdentity(String raw) {
  final Uri u = Uri.parse(raw.trim());
  if (_lnkdHost.hasMatch(u.host)) {
    final String code = u.path
        .replaceFirst(RegExp(r'^/(?:p/)?'), '')
        .replaceAll(RegExp(r'/+$'), '');
    return 'lnkd:$code';
  }
  final String? reply = _param(u, 'replyUrn') ?? _param(u, 'dashReplyUrn');
  if (reply != null) return 'comment:${_commentIdOf(reply)}';
  final String? comment =
      _param(u, 'commentUrn') ?? _param(u, 'dashCommentUrn');
  if (comment != null) return 'comment:${_commentIdOf(comment)}';
  final RegExpMatch? post = RegExp(
    r'(activity|ugcpost|share)[:-](\d+)',
    caseSensitive: false,
  ).firstMatch(_decoded(u.path));
  if (post != null) {
    return 'post:${post.group(1)!.toLowerCase()}:${post.group(2)}';
  }
  return normaliseCommentUrl(raw);
}

/// What is wrong with one feed-comment link before it is sent.
enum FeedCommentLinkProblem {
  /// Nothing pasted.
  empty,

  /// Not a link to a comment on a LinkedIn post.
  bad,

  /// The same comment as one already sent today, however it is spelt.
  duplicate,
}

/// Checks ONE link the way the server does, against the links already sent
/// today (normalised or not): null for a good one. An unreadable stored link
/// matches nothing rather than throwing. `checkFeedCommentLink`.
FeedCommentLinkProblem? checkFeedCommentLink(
  String raw, [
  List<String> sentToday = const <String>[],
]) {
  final String t = raw.trim();
  if (t.isEmpty) return FeedCommentLinkProblem.empty;
  if (!isLinkedInCommentUrl(t)) return FeedCommentLinkProblem.bad;
  final String id = commentIdentity(t);
  for (final String sent in sentToday) {
    try {
      if (commentIdentity(sent) == id) return FeedCommentLinkProblem.duplicate;
    } on FormatException {
      continue;
    }
  }
  return null;
}

/// A link the app may hand to the OS to open: https on `linkedin.com` or any
/// of its subdomains. The comment level's "Comment on LinkedIn" opens the
/// top voice's post only through this — the server filters that URL to
/// https, and the web additionally requires a LinkedIn host before
/// `window.open`, which this mirrors.
bool isLinkedInHost(String? raw) {
  if (raw == null) return false;
  final Uri? u = Uri.tryParse(raw.trim());
  if (u == null || u.scheme != 'https' || u.userInfo.isNotEmpty) return false;
  final String host = u.host.toLowerCase();
  return host == 'linkedin.com' || host.endsWith('.linkedin.com');
}
