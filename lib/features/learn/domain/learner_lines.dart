/// Did the post actually use what the learner wrote?
///
/// A Dart port of the same block in the web's `lib/learn/ladder.ts`, kept
/// client-side in both places for the same reason: it is a check ON the
/// generated post, made where the post is read.
///
/// ## Why this exists
///
/// A learner is taught to write an opening, writes one, and then reads a post
/// that opens with something else. Nothing told them. That is worse than the
/// model simply not being able to use it: it is their work disappearing with
/// no acknowledgement, and the next time they are asked to write a line they
/// will not bother.
///
/// The model is ALLOWED to depart — sometimes a hook genuinely does not carry
/// a post. What it is not allowed to do is depart SILENTLY. This is the check
/// that makes the difference visible, and it is mechanical on purpose: asking
/// the model to self-report when it ignored an instruction gets a confident
/// answer that is right about as often as a coin.
library;

import 'learn_unit.dart';

/// What happened to a line the learner wrote.
enum LineOutcome {
  /// It is there, word for word.
  kept,

  /// Recognisably theirs, tidied. The prompt explicitly ASKS for this ("fix
  /// only grammar or a word that does not work on LinkedIn"), so it is a
  /// success, not a departure.
  edited,

  /// The post went another way.
  replaced,

  /// They never wrote one, so there is nothing to honour.
  missing;

  /// `kept` and `edited` both mean the line survived.
  bool get survived => this == LineOutcome.kept || this == LineOutcome.edited;
}

const Set<String> _stopWords = <String>{
  'a', 'an', 'the', 'and', 'or', 'but', 'if', 'of', 'to', 'in', 'on', 'at',
  'for', 'with', 'is', 'are', 'was', 'were', 'be', 'it', 'that', 'this',
  'i', 'we', 'you', 'my', 'our', 'your',
};

final RegExp _word = RegExp(r"[a-z0-9']+");
final RegExp _notAlphanumeric = RegExp('[^a-z0-9 ]');
final RegExp _runOfSpace = RegExp(r'\s+');

/// Only the words that carry meaning — the rest match by accident.
List<String> _contentWords(String text) => <String>[
  for (final RegExpMatch m in _word.allMatches(text.toLowerCase()))
    if (!_stopWords.contains(m[0])) m[0]!,
];

String _normalise(String text) => text
    .toLowerCase()
    .replaceAll(_notAlphanumeric, '')
    .replaceAll(_runOfSpace, ' ')
    .trim();

/// The post's opening line — the first line with anything on it.
String openingLineOf(String post) {
  for (final String line in post.split('\n')) {
    final String trimmed = line.trim();
    if (trimmed.isNotEmpty) return trimmed;
  }
  return '';
}

final RegExp _hashtagBlock = RegExp(r'^#\S+(\s+#\S+)*$');

/// The post's closing line — the last line that is not a hashtag block.
String closingLineOf(String post) {
  final List<String> lines = <String>[
    for (final String l in post.split('\n'))
      if (l.trim().isNotEmpty) l.trim(),
  ];
  for (int i = lines.length - 1; i >= 0; i--) {
    // The hashtag line is always last and is never the author's ask.
    if (_hashtagBlock.hasMatch(lines[i])) continue;
    return lines[i];
  }
  return '';
}

/// How a line the learner wrote fared against the line that shipped.
///
/// Containment rather than equality, because the prompt asks for light edits.
/// Measured as "how much of what THEY wrote survives", not overlap both ways:
/// a post line that keeps every one of their words and adds a clause is still
/// their line, while one that happens to share two common words is not.
LineOutcome lineOutcome(String? written, String shipped) {
  final String mine = (written ?? '').trim();
  if (mine.isEmpty) return LineOutcome.missing;
  if (shipped.trim().isEmpty) return LineOutcome.replaced;
  if (_normalise(mine) == _normalise(shipped)) return LineOutcome.kept;

  final List<String> mineWords = _contentWords(mine);
  if (mineWords.isEmpty) return LineOutcome.replaced;
  final Set<String> theirs = _contentWords(shipped).toSet();
  final int survived = mineWords.where(theirs.contains).length;
  return survived / mineWords.length >= 0.6
      ? LineOutcome.edited
      : LineOutcome.replaced;
}

/// One line's verdict, and both sides of it so the screen can show them.
class LineVerdict {
  const LineVerdict({
    required this.outcome,
    required this.written,
    required this.shipped,
  });

  final LineOutcome outcome;
  final String? written;
  final String shipped;
}

/// Both verdicts for a finished unit, for the screen that reports them.
class LearnerLineReport {
  const LearnerLineReport({required this.hook, required this.close});

  final LineVerdict hook;
  final LineVerdict close;

  /// Nothing to say: they wrote neither line.
  bool get isEmpty =>
      hook.outcome == LineOutcome.missing &&
      close.outcome == LineOutcome.missing;

  bool get anyReplaced =>
      hook.outcome == LineOutcome.replaced ||
      close.outcome == LineOutcome.replaced;
}

/// The learner's own words, by level kind.
///
/// Only `compose` and `rewrite` answers: a multiple-choice answer is the user
/// recognising a good hook, not writing one. Mirrors `collectLearnerInput`.
Map<LevelKind, List<String>> collectLearnerInput(List<LearnLevel> levels) {
  final Map<LevelKind, List<String>> out = <LevelKind, List<String>>{};
  for (final LearnLevel level in levels) {
    if (level.kind.isAction) continue;
    final List<String> written = <String>[];
    for (final Exercise e in level.exercises) {
      if (!e.isCompose && !e.isRewrite) continue;
      for (final LevelAnswer a in level.answers) {
        if (a.exerciseId != e.id) continue;
        final String value = a.value.trim();
        if (value.isNotEmpty) written.add(value);
      }
    }
    if (written.isNotEmpty) out[level.kind] = written;
  }
  return out;
}

/// What happened to the lines this learner wrote, or null when there is no
/// post to check them against yet.
LearnerLineReport? reportLearnerLines(List<LearnLevel> levels, String? post) {
  if (post == null || post.trim().isEmpty) return null;

  final Map<LevelKind, List<String>> written = collectLearnerInput(levels);
  final String? hook = written[LevelKind.hook]?.firstOrNull;
  // The substance level writes two lines; the close level's own compose
  // answer is the ask. Same indexing as runDraftLevel on the server.
  final String? close = written[LevelKind.close]?.firstOrNull;
  final String opening = openingLineOf(post);
  final String closing = closingLineOf(post);

  return LearnerLineReport(
    hook: LineVerdict(
      outcome: lineOutcome(hook, opening),
      written: hook,
      shipped: opening,
    ),
    close: LineVerdict(
      outcome: lineOutcome(close, closing),
      written: close,
      shipped: closing,
    ),
  );
}
