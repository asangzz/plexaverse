/// The playbook week's post formats, as the planner shows them. A port of the
/// display half of the web's `lib/post-formats.ts` (PLANNER_REDESIGN.md §2).
///
/// The server decides every format: it picks one per post day at plan time
/// and writes `formatId` / `imageKind` onto the slot. Nothing here picks,
/// checks facts or reviews — this table only names what the slot says, so a
/// day card can read "Teach · Numbered steps" and the image step can say what
/// photo the format wants. An id this table does not know shows as a legacy
/// day, never as a guessed format.
library;

import '../../../core/week/week_shape.dart';

/// How a post day's image is made. Mirrors `ImageKind`.
enum ImageKind {
  /// The user's own photo — used as it is, or as a reference for OpenAI.
  photo,

  /// An AI poster, made by the poster pipeline.
  aiPoster,

  /// The post's key line printed on a clean card. No model.
  textCard,

  /// The post's quote printed on a clean card. No model.
  quoteCard;

  static ImageKind? parse(String? raw) => switch (raw) {
    'photo' => ImageKind.photo,
    'ai_poster' => ImageKind.aiPoster,
    'text_card' => ImageKind.textCard,
    'quote_card' => ImageKind.quoteCard,
    _ => null,
  };

  String get wire => switch (this) {
    ImageKind.photo => 'photo',
    ImageKind.aiPoster => 'ai_poster',
    ImageKind.textCard => 'text_card',
    ImageKind.quoteCard => 'quote_card',
  };

  /// The web's `IMAGE_KIND_LABEL`.
  String get label => switch (this) {
    ImageKind.photo => 'Your photo',
    ImageKind.aiPoster => 'AI poster',
    ImageKind.textCard => 'Text card',
    ImageKind.quoteCard => 'Quote card',
  };

  bool get isCard => this == ImageKind.textCard || this == ImageKind.quoteCard;
}

/// One format, as much of it as a phone draws.
class PostFormatInfo {
  const PostFormatInfo({
    required this.id,
    required this.role,
    required this.name,
    required this.oneLine,
    required this.imageKind,
    this.photoGuide,
  });

  final String id;
  final PostRole role;
  final String name;
  final String oneLine;
  final ImageKind imageKind;

  /// What photo the format wants — null for formats that need none.
  final String? photoGuide;
}

/// Mirrors `POST_FORMATS` (names, one-liners, image kinds, photo guides).
const Map<String, PostFormatInfo> postFormats = <String, PostFormatInfo>{
  'educational_infographic': PostFormatInfo(
    id: 'educational_infographic',
    role: PostRole.teach,
    name: 'Educational infographic',
    oneLine:
        'A subject in a few highlights, what it means, and three takeaways '
        'worth saving.',
    imageKind: ImageKind.aiPoster,
  ),
  'numbered_steps': PostFormatInfo(
    id: 'numbered_steps',
    role: PostRole.teach,
    name: 'Numbered steps',
    oneLine: 'An outcome within a timeframe, broken into numbered steps.',
    imageKind: ImageKind.aiPoster,
  ),
  'learning_note': PostFormatInfo(
    id: 'learning_note',
    role: PostRole.teach,
    name: 'Learning note',
    oneLine:
        'What finally clicked while learning the skill for the role you are '
        'moving into.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a photo of you at your desk mid-learning — laptop open, notes or a '
        'book beside you',
  ),
  'interview_question': PostFormatInfo(
    id: 'interview_question',
    role: PostRole.teach,
    name: 'Interview question',
    oneLine:
        'A question hiring managers ask, with a one-line answer and the '
        'reasons behind it.',
    imageKind: ImageKind.textCard,
  ),
  'timeline': PostFormatInfo(
    id: 'timeline',
    role: PostRole.story,
    name: 'Timeline',
    oneLine: 'Who you were, year by year, and who you are now.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a clear photo of you today — at work, speaking, or at your desk',
  ),
  're_introduction': PostFormatInfo(
    id: 're_introduction',
    role: PostRole.story,
    name: 'Re-introduction',
    oneLine:
        'Introduce yourself to the people who started following you, year by '
        'year.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a friendly, well-lit photo of you doing your work or with people '
        'from your field',
  ),
  'authority_positioning': PostFormatInfo(
    id: 'authority_positioning',
    role: PostRole.story,
    name: 'Authority positioning',
    oneLine: 'One real event that shows people want what you do.',
    imageKind: ImageKind.photo,
    photoGuide:
        'you doing what this post is about — presenting, helping someone, at '
        'the event',
  ),
  'project_breakdown': PostFormatInfo(
    id: 'project_breakdown',
    role: PostRole.story,
    name: 'Project breakdown',
    oneLine:
        'A real project: why you built it, what broke, and what you would do '
        'differently.',
    imageKind: ImageKind.photo,
    photoGuide: 'a screenshot of the project, or you with it on your screen',
  ),
  'mistake_lesson': PostFormatInfo(
    id: 'mistake_lesson',
    role: PostRole.story,
    name: 'Mistake → lesson',
    oneLine: 'A real mistake, what it cost, and the one rule it left you with.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a candid photo of you at your desk with your laptop and coffee',
  ),
  'career_highlight_reel': PostFormatInfo(
    id: 'career_highlight_reel',
    role: PostRole.story,
    name: 'Career highlight reel',
    oneLine:
        'A real milestone — a new job, an anniversary — and the moments that '
        'led to it.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a photo from the milestone — first day, the team, the award, the '
        'moment',
  ),
  'career_motivation': PostFormatInfo(
    id: 'career_motivation',
    role: PostRole.opinion,
    name: 'Career motivation',
    oneLine:
        'A bold position on careers or hiring, and what actually matters '
        'instead.',
    imageKind: ImageKind.textCard,
  ),
  'platitude_quote': PostFormatInfo(
    id: 'platitude_quote',
    role: PostRole.opinion,
    name: 'Quotable line',
    oneLine: 'A short story that lands on one quotable line.',
    imageKind: ImageKind.quoteCard,
  ),
  'repetition': PostFormatInfo(
    id: 'repetition',
    role: PostRole.opinion,
    name: 'Repetition',
    oneLine:
        'Six to eight "You don\'t need …" lines, then the three things that '
        'matter.',
    imageKind: ImageKind.photo,
    photoGuide:
        'a confident portrait of you — sitting or standing, plain background',
  ),
  'myth_flip': PostFormatInfo(
    id: 'myth_flip',
    role: PostRole.opinion,
    name: 'Myth flip',
    oneLine: 'A belief people repeat, why it fails, and what is true instead.',
    imageKind: ImageKind.textCard,
  ),
  'industry_take': PostFormatInfo(
    id: 'industry_take',
    role: PostRole.opinion,
    name: 'Industry take',
    oneLine:
        'The news in one line, your position on it, and what would change '
        'your mind.',
    imageKind: ImageKind.aiPoster,
  ),
};

/// The format for a stored id, or null for a legacy day / an unknown id.
PostFormatInfo? formatInfo(String? id) => id == null ? null : postFormats[id];

/// What each role is FOR, in a few words. The web's `ROLE_PURPOSE`.
String rolePurpose(PostRole role) => switch (role) {
  PostRole.teach => 'Something worth saving',
  PostRole.story => 'Who you are, with proof',
  PostRole.opinion => 'What you believe',
};

/// The ask on the image step, from the format's photo guide. The web's
/// `photoAsk`: "Give us a photo of you at your desk with your laptop and
/// coffee."
String photoAsk(String? guide) {
  String g = (guide ?? '').trim();
  if (g.endsWith('.')) g = g.substring(0, g.length - 1);
  if (g.isEmpty) return 'Give us a photo of you that fits this post.';
  final String lower = g.toLowerCase();
  return (lower.startsWith('a ') || lower.startsWith('an '))
      ? 'Give us $g.'
      : 'Give us a photo of $g.';
}

/// The send-to-OpenAI consent line, word for word with the web's
/// `PHOTO_CONSENT_TEXT`.
const String photoConsentText =
    'Send this photo to OpenAI to create your image. We keep the original for '
    '30 days.';

// ─── The stored review (`slot.review`) ───────────────────────────────────────

/// The playbook review stored on a slot. Mirrors `SlotReview`.
///
/// Parsed by hand and tolerantly: a malformed review on one day must never
/// fail the whole week's parse. Anything unreadable is no review at all.
class SlotReview {
  const SlotReview({
    required this.ok,
    this.errors = const <String>[],
    this.warnings = const <String>[],
    this.refined = false,
  });

  final bool ok;

  /// Each an imperative fix ("End with a question."). Errors hold a post back
  /// from auto-publishing.
  final List<String> errors;
  final List<String> warnings;

  /// The server rewrote the post to get here.
  final bool refined;

  static SlotReview? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final Object? ok = raw['ok'];
    if (ok is! bool) return null;
    return SlotReview(
      ok: ok,
      errors: _lines(raw['errors']),
      warnings: _lines(raw['warnings']),
      refined: raw['refined'] == true,
    );
  }
}

/// Strings, or `{ message }` objects (the refine answer's shape), as lines.
List<String> _lines(Object? raw) {
  if (raw is! List) return const <String>[];
  final List<String> out = <String>[];
  for (final Object? e in raw) {
    final Object? m = e is Map ? e['message'] : e;
    if (m is String && m.trim().isNotEmpty) out.add(m.trim());
  }
  return out;
}

/// What "Fix with AI" answered. `content` is the post as now stored.
class RefineResult {
  const RefineResult({
    required this.ok,
    required this.changed,
    required this.review,
    this.content,
  });

  final bool ok;
  final bool changed;
  final SlotReview review;
  final String? content;

  factory RefineResult.fromJson(Map<String, dynamic> json) {
    final Object? r = json['review'];
    return RefineResult(
      ok: json['ok'] == true,
      changed: json['changed'] == true,
      review:
          SlotReview.tryParse(r) ??
          SlotReview(
            ok: json['ok'] == true,
            errors: r is Map ? _lines(r['errors']) : const <String>[],
          ),
      content: json['content'] as String?,
    );
  }
}

// ─── The week's news (`slot.news`) ───────────────────────────────────────────

/// How old a headline may be when the post is written. `NEWS_USABLE_DAYS`.
const int newsUsableDays = 10;

/// How far back a headline may be published when searched. `NEWS_RECENCY_DAYS`.
const int newsRecencyDays = 7;

/// The news day of a planner week: Friday's industry take on odd weeks,
/// Monday's news-led infographic on even ones. Mirrors `newsDayFor`.
({int dayIndex, String formatId, PostRole role}) newsDayFor(int weekNumber) =>
    weekNumber.abs().isOdd
    ? (dayIndex: 4, formatId: 'industry_take', role: PostRole.opinion)
    : (dayIndex: 0, formatId: 'educational_infographic', role: PostRole.teach);

/// One headline. `url` is shown, never fetched by the app.
class NewsCandidate {
  const NewsCandidate({
    required this.title,
    required this.source,
    required this.url,
    this.publishedAt,
    this.summary = '',
  });

  final String title;
  final String source;
  final String url;

  /// YYYY-MM-DD, or null when the page gave none.
  final String? publishedAt;
  final String summary;

  static NewsCandidate? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final Object? title = raw['title'];
    final Object? url = raw['url'];
    if (title is! String || title.trim().isEmpty) return null;
    if (url is! String || !url.startsWith('https://')) return null;
    final Object? source = raw['source'];
    final Object? at = raw['publishedAt'];
    final Object? summary = raw['summary'];
    return NewsCandidate(
      title: title.trim(),
      source: source is String ? source.trim() : '',
      url: url,
      publishedAt: at is String && at.isNotEmpty ? at : null,
      summary: summary is String ? summary.trim() : '',
    );
  }

  /// "Reuters · 24 Nov" — source and date, whichever exist.
  String get meta {
    final List<String> parts = <String>[
      if (source.isNotEmpty) source,
      if (_shortDate(publishedAt) case final String d) d,
    ];
    return parts.join(' · ');
  }

  /// Fresh enough to write from: published (or, undated, searched) within
  /// [newsUsableDays]. Mirrors `isUsableNews`.
  bool isUsable(DateTime fetchedAt, {DateTime? now}) {
    final DateTime at =
        (publishedAt == null ? null : DateTime.tryParse('${publishedAt}T00:00:00Z')) ??
        fetchedAt;
    final DateTime n = (now ?? DateTime.now()).toUtc();
    final Duration age = n.difference(at.toUtc());
    return age <= const Duration(days: newsUsableDays) &&
        age >= const Duration(days: -1);
  }
}

String? _shortDate(String? iso) {
  if (iso == null) return null;
  final DateTime? d = DateTime.tryParse('${iso}T00:00:00Z');
  if (d == null) return null;
  const List<String> months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${months[d.month - 1]}';
}

/// The headlines on a news day and the user's pick. Mirrors `SlotNews`
/// (`readSlotNews`): null for anything unreadable.
class SlotNews {
  const SlotNews({
    required this.candidates,
    required this.fetchedAt,
    required this.formatId,
    this.pickedIndex,
  });

  final List<NewsCandidate> candidates;
  final int? pickedIndex;
  final DateTime fetchedAt;
  final String formatId;

  static SlotNews? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final Object? formatId = raw['formatId'];
    if (formatId != 'industry_take' && formatId != 'educational_infographic') {
      return null;
    }
    final Object? at = raw['fetchedAt'];
    final DateTime? fetchedAt = at is String ? DateTime.tryParse(at) : null;
    if (fetchedAt == null) return null;
    final Object? list = raw['candidates'];
    final List<NewsCandidate> candidates = <NewsCandidate>[
      if (list is List)
        for (final Object? c in list)
          if (NewsCandidate.tryParse(c) case final NewsCandidate n) n,
    ].take(3).toList(growable: false);
    final Object? picked = raw['pickedIndex'];
    return SlotNews(
      candidates: candidates,
      fetchedAt: fetchedAt,
      formatId: formatId! as String,
      pickedIndex: picked is int && picked >= 0 && picked < candidates.length
          ? picked
          : null,
    );
  }

  /// The pick, else candidate 0. Null with no candidates. `pickedCandidate`.
  int? get chosenIndex => candidates.isEmpty ? null : (pickedIndex ?? 0);

  NewsCandidate? get chosen =>
      chosenIndex == null ? null : candidates[chosenIndex!];
}

/// The news status: whether the search is switched on, and whether this user
/// is searched for by the system (on a plan).
class NewsStatus {
  const NewsStatus({required this.enabled, required this.entitled});

  final bool enabled;
  final bool entitled;

  factory NewsStatus.fromJson(Map<String, dynamic> json) => NewsStatus(
    enabled: json['enabled'] == true,
    entitled: json['entitled'] == true,
  );

  static const NewsStatus off = NewsStatus(enabled: false, entitled: false);
}

/// What a find or a pick answered.
class NewsResult {
  const NewsResult({
    required this.dayIndex,
    this.news,
    this.refreshFoundNone = false,
  });

  final int dayIndex;
  final SlotNews? news;

  /// A Refresh found nothing and KEPT the headlines already there.
  final bool refreshFoundNone;

  factory NewsResult.fromJson(Map<String, dynamic> json) => NewsResult(
    dayIndex: (json['dayIndex'] as num?)?.toInt() ?? 0,
    news: SlotNews.tryParse(json['news']),
    refreshFoundNone: json['refreshFoundNone'] == true,
  );
}

// ─── The image step ──────────────────────────────────────────────────────────

/// How `/planner/image` is asked to make a day's image. `SlotImageMode`.
enum SlotImageMode {
  auto,
  reference,
  asIs,
  card,
  poster;

  String get wire => switch (this) {
    SlotImageMode.auto => 'auto',
    SlotImageMode.reference => 'reference',
    SlotImageMode.asIs => 'as_is',
    SlotImageMode.card => 'card',
    SlotImageMode.poster => 'poster',
  };
}

/// What a photo upload answered. `previewUrl` is signed for 10 minutes —
/// for showing it now only, never stored.
class SlotPhotoUpload {
  const SlotPhotoUpload({this.previewUrl, this.photoGuide});

  final String? previewUrl;
  final String? photoGuide;
}

/// What `/planner/image` answered.
class SlotImageMade {
  const SlotImageMade({required this.imageUrl, this.kindUsed});

  final String imageUrl;

  /// `photo | ai_poster | text_card | quote_card | text_card_fallback`.
  final String? kindUsed;
}
