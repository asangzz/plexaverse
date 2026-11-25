/// The week, in one table. A port of the web's `lib/week-shape.ts`.
///
/// ## Why this is a leaf module in `core/`
///
/// Two features read it — the planner draws a day, and the home roadmap
/// decides whether a day gets a "Publish a post" mission — and neither should
/// depend on the other. The web split it out for the same reason and says so:
/// it is pure, and the planner's client components need it, so putting it in
/// the service pulled Prisma into a jsdom test and would have pulled it into
/// the browser bundle too.
///
/// ## What a day is
///
/// [DayKind] is the important field and it is not the same question as a post
/// format. Format is what we hand LinkedIn. Kind is whether we hand LinkedIn
/// anything at all: a video script and a newsletter are both work the user
/// does and we cannot publish for them, and a rest day is no work.
library;

/// What a day produces. Mirrors `DayKind`.
enum DayKind {
  /// We write it and the chain publishes it.
  post,

  /// LEGACY (weeks planned before 25 Nov 2026): we wrote a script; the user
  /// recorded and posted it. [weekShape] never produces it any more, but a
  /// stored week's lived days still carry it.
  videoScript,

  /// The weekly newsletter. The user pastes it into LinkedIn and confirms.
  article,

  /// Nothing.
  rest;

  static DayKind parse(String? raw) => switch (raw) {
    'video_script' => DayKind.videoScript,
    'article' => DayKind.article,
    'rest' => DayKind.rest,
    _ => DayKind.post,
  };

  String get wire => switch (this) {
    DayKind.videoScript => 'video_script',
    DayKind.article => 'article',
    DayKind.rest => 'rest',
    DayKind.post => 'post',
  };

  /// True when the chain can publish this day on the user's behalf.
  bool get isPublishable => this == DayKind.post;

  /// True when we prepare something the USER then posts. Both of these end in
  /// a hand-off rather than in our publish pipeline.
  bool get isHandoff => this == DayKind.videoScript || this == DayKind.article;

  /// What this day produces, in the words the user sees.
  ///
  /// Calling the newsletter a "post" — "Write my post" on a Thursday — is
  /// wrong before it is confusing: it never becomes a Post. `rest` falls to
  /// "post" only because nothing is ever written on a rest day and the string
  /// is never reached. `videoScript` survives only on weeks planned before
  /// 25 Nov 2026.
  String get madeThing => switch (this) {
    DayKind.videoScript => 'script',
    DayKind.article => 'newsletter',
    DayKind.post || DayKind.rest => 'post',
  };
}

/// What a post day is FOR. Mirrors `PostRole` in the web's `lib/week-shape.ts`.
///
/// The role picks the day's format (the server's `pickFormat`) and, through
/// the post type, how its image is made. A day that is not a post has none.
enum PostRole {
  /// Monday: teach the reader one thing.
  teach,

  /// Wednesday: a real story from the user's own work.
  story,

  /// Friday: a position the user holds.
  opinion;

  /// Unknown or absent → null, never a guess: a legacy slot has no role.
  static PostRole? parse(String? raw) => switch (raw) {
    'teach' => PostRole.teach,
    'story' => PostRole.story,
    'opinion' => PostRole.opinion,
    _ => null,
  };

  String get wire => name;

  /// The role in the words the planner shows on a day card.
  String get label => switch (this) {
    PostRole.teach => 'Teach',
    PostRole.story => 'Story',
    PostRole.opinion => 'Opinion',
  };
}

/// The seven days, in order. Mirrors `WEEK_SHAPE` (the playbook week, owner,
/// 25 Nov 2026 — PLANNER_REDESIGN.md §0):
///
///   Mon  post, role teach
///   Tue  rest
///   Wed  post, role story
///   Thu  the newsletter article (the user pastes it in)
///   Fri  post, role opinion
///   Sat  rest
///   Sun  rest
///
/// Video scripts were dropped from the week. [DayKind.videoScript] stays
/// parseable because weeks planned before 25 Nov 2026 still carry it — the
/// server switches a stored week's days still to come on read, but a day
/// already lived keeps what it was.
const List<DayKind> weekShape = <DayKind>[
  DayKind.post, // Monday — teach
  DayKind.rest, // Tuesday
  DayKind.post, // Wednesday — story
  DayKind.article, // Thursday — the newsletter
  DayKind.post, // Friday — opinion
  DayKind.rest, // Saturday
  DayKind.rest, // Sunday
];

/// The role per day. Mirrors `WEEK_SHAPE[i].role`.
const List<PostRole?> weekRoles = <PostRole?>[
  PostRole.teach, // Monday
  null, // Tuesday
  PostRole.story, // Wednesday
  null, // Thursday
  PostRole.opinion, // Friday
  null, // Saturday
  null, // Sunday
];

/// The post format per day. Mirrors `WEEK_SHAPE[i].format`.
///
/// These are the SERVER's `PostFormat` values — `text`, `text_image`,
/// `carousel`, `poll` — not prettier short ones. Shipped builds print this
/// raw, which is why the playbook's format (`formatId`) is a separate key
/// and never this one.
const List<String> weekFormats = <String>[
  'text_image', // Monday
  'text', // Tuesday
  'text_image', // Wednesday
  'text', // Thursday — the newsletter
  'text_image', // Friday
  'text', // Saturday
  'text', // Sunday
];

/// The post type per day. Mirrors `WEEK_SHAPE[i].type` (teach → niche,
/// story → productive, opinion → general).
const List<String> weekTypes = <String>[
  'niche', // Monday
  'general', // Tuesday
  'productive', // Wednesday
  'niche', // Thursday
  'general', // Friday
  'productive', // Saturday
  'light', // Sunday
];

/// The day indexes that take a post — Mon, Wed, Fri. Mirrors `postingDays()`.
List<int> postingDays() => <int>[
  for (int i = 0; i < weekShape.length; i++)
    if (weekShape[i] == DayKind.post) i,
];

/// Mirrors `roleForDay(index)`.
PostRole? roleForDay(int index) {
  if (index < 0 || index >= weekRoles.length) return weekRoles.first;
  return weekRoles[index];
}

/// Mirrors `daySpec(index).format`.
String dayFormatAt(int index) {
  if (index < 0 || index >= weekFormats.length) return weekFormats.first;
  return weekFormats[index];
}

/// Mirrors `daySpec(index).type`.
String dayTypeAt(int index) {
  if (index < 0 || index >= weekTypes.length) return weekTypes.first;
  return weekTypes[index];
}

/// The kind for a day index, clamped so an out-of-range index cannot throw.
/// Mirrors `daySpec(index).kind`.
DayKind dayKindAt(int index) {
  if (index < 0 || index >= weekShape.length) return weekShape.first;
  return weekShape[index];
}

/// True when the week's shape gives this day nothing to do.
bool isRestDayIndex(int index) => dayKindAt(index) == DayKind.rest;

/// 0 = Monday … 6 = Sunday, for the roadmap day [day] of a roadmap that began
/// on [startedAt]. Mirrors `weekdayIndex`.
int weekdayIndexForDay(int day, DateTime startedAt) {
  final DateTime d = startedAt.add(Duration(days: day - 1));
  // Dart's DateTime.weekday is 1 = Monday … 7 = Sunday, which already matches
  // after subtracting one. The web converts from JS's 0 = Sunday instead.
  return d.weekday - 1;
}
