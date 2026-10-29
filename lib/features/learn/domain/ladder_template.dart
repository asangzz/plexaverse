import 'learn_unit.dart';

/// Which levels each kind of day gets, in order.
///
/// A Dart mirror of `LADDER_TEMPLATE` in the web's `lib/learn/ladder.ts`, and
/// the reason the whole week can be drawn without loading a single ladder.
///
/// ## Why the path does not wait for the server
///
/// The first read of a day BUILDS it — a model call, several seconds, and it
/// costs money. A path that had to fetch five ladders before it could render
/// would spend five of those just to be looked at. The template is
/// deterministic, so the nodes, their glyphs, their titles and their count
/// are all known before anything is generated; the model call happens when
/// the user opens a day, which is the moment they asked for one.
///
/// ## Keeping it honest
///
/// `PathDay.levelCount` is the server's own count for the day, and
/// [levelsForDay] trusts it over this list when the two disagree — a server
/// that grows an eighth level should draw eight nodes here, not seven and a
/// silent mismatch. The titles are still ours; they are the only part that
/// cannot be derived.
const Map<DayKind, List<LevelSpec>> kLadderTemplate = <DayKind, List<LevelSpec>>{
  DayKind.post: <LevelSpec>[
    LevelSpec(LevelKind.vocabulary, 'Words that carry'),
    LevelSpec(LevelKind.hook, 'The first line'),
    LevelSpec(LevelKind.substance, 'What you actually did'),
    LevelSpec(LevelKind.close, 'The ask'),
    LevelSpec(LevelKind.draft, 'Write the post'),
    LevelSpec(LevelKind.visual, 'Make the poster'),
    LevelSpec(LevelKind.review, 'Read it back'),
  ],
  DayKind.videoScript: <LevelSpec>[
    LevelSpec(LevelKind.vocabulary, 'Words that carry'),
    LevelSpec(LevelKind.hook, 'The first three seconds'),
    LevelSpec(LevelKind.substance, 'What you actually did'),
    LevelSpec(LevelKind.close, 'The ask'),
    LevelSpec(LevelKind.draft, 'Write the script'),
    LevelSpec(LevelKind.review, 'Read it back'),
  ],
  DayKind.article: <LevelSpec>[
    LevelSpec(LevelKind.vocabulary, 'Words that carry'),
    LevelSpec(LevelKind.hook, 'The opening'),
    LevelSpec(LevelKind.substance, 'The argument'),
    LevelSpec(LevelKind.close, 'The close'),
    LevelSpec(LevelKind.draft, 'Write the newsletter'),
    LevelSpec(LevelKind.review, 'Read it back'),
  ],
  // Saturday and Sunday are off, and a product that puts homework on the rest
  // day has not understood why the rest day is there.
  DayKind.rest: <LevelSpec>[],
};

/// One rung of the template: what it is, and what it is called.
class LevelSpec {
  const LevelSpec(this.kind, this.title);

  final LevelKind kind;
  final String title;
}

/// One node on the path, before any ladder exists.
class PathNode {
  const PathNode({
    required this.kind,
    required this.status,
    required this.title,
  });

  final LevelKind kind;
  final LevelStatus status;
  final String title;
}

/// What to draw for a day the server has described but not yet built.
///
/// The STATUS is the honest part and it comes entirely from the server's own
/// `completedCount`: before a day is started every level after the first is
/// locked, which is exactly true.
List<PathNode> levelsForDay(LearnPathDay day) {
  final List<LevelSpec> specs =
      kLadderTemplate[day.kind] ?? const <LevelSpec>[];
  // The server's count wins. The titles are ours; the shape is its.
  final int count = day.levelCount > 0 ? day.levelCount : specs.length;

  return <PathNode>[
    for (int i = 0; i < count; i++)
      PathNode(
        kind: i < specs.length ? specs[i].kind : LevelKind.review,
        title: i < specs.length ? specs[i].title : 'Level ${i + 1}',
        status: day.isLocked
            ? LevelStatus.locked
            : i < day.completedCount
            ? LevelStatus.complete
            : i == day.completedCount
            ? LevelStatus.available
            : LevelStatus.locked,
      ),
  ];
}
