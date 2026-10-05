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

  /// We write a script; the user records and posts it themselves. LinkedIn
  /// video upload is a different API (initialize → binary PUT → finalize →
  /// a share referencing the video URN) and nothing in this product speaks it.
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
}

/// The seven days, in order. Mirrors `WEEK_SHAPE`.
///
/// Seven posted days became two. Monday carries an industry observation,
/// Tuesday the week's biggest swing, and Wednesday, Thursday and Friday are
/// work we prepare and the user does: two video scripts and the newsletter.
/// The weekend is off.
///
/// That is a real reduction in what this product publishes on a user's behalf,
/// and it was the deliberate trade — at seven, the server's grounding runs out
/// of banked material after the first two or three and the rest come from its
/// generic no-story branch.
const List<DayKind> weekShape = <DayKind>[
  DayKind.post, // Monday
  DayKind.post, // Tuesday — the hero
  DayKind.videoScript, // Wednesday
  DayKind.article, // Thursday — the newsletter
  DayKind.videoScript, // Friday
  DayKind.rest, // Saturday
  DayKind.rest, // Sunday
];

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
