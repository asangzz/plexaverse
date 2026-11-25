/// The editor's post review — the server's MANUAL review, not a rule set of
/// the app's own. A port of `reviewManual` in the web's `lib/post-review.ts`
/// over `validatePost` in `lib/services/post-validator.ts` (25 Nov 2026).
///
/// The compose screen used to score five home-made heuristics, one of which
/// paid a fifth of the score for "3-5 relevant hashtags". The web replaced its
/// own copy of those heuristics with this review the same day, because a third
/// rule set that disagrees with the other two coaches people into exactly what
/// the server's review strips out. A test holds the patterns below against the
/// server's source, so the two cannot drift.
///
/// Advisory in the editor: a person's own words are reviewed, never rewritten
/// for them (PLANNER_REDESIGN.md §0.4).
library;

/// `BANNED_WORDS` — corporate and AI tells the prompt bans outright.
final RegExp bannedWords = RegExp(
  r'\b(delve|leverage|unlock|elevate|robust|seamless|game-?changer|testament to|realm|tapestry|navigate the landscape|fast-paced world)\b',
  caseSensitive: false,
);

/// `STOCK_STRUGGLE` — the idioms a model reaches for with no real event.
final RegExp stockStruggle = RegExp(
  r'\b(hit(ting)? a wall|hit(ting)? a roadblock|ran into a wall|bang(ing|ed)? my head|down a rabbit hole|spun my wheels|stumped me)\b',
  caseSensitive: false,
);

/// `MARKDOWN` — paired emphasis, which LinkedIn prints with the asterisks.
/// A single `*` used as a bullet does not match.
final RegExp markdownEmphasis = RegExp(r'\*\*|(?<!\*)\*[^*\n]+\*(?!\*)');

/// `NOT_JUST_X` — the banned "It's not just X, it's Y" construction.
final RegExp notJustX = RegExp(
  r"not just .{2,40}?,? it'?s\b",
  caseSensitive: false,
);

/// The body's word bounds (`MIN_WORDS` / `MAX_WORDS`).
const int minPostWords = 100;
const int maxPostWords = 220;

/// `bodyWordCount`: words with any `#tag` left out.
int bodyWordCount(String post) => post
    .replaceAll(RegExp(r'#\w+'), '')
    .split(RegExp(r'\s+'))
    .where((String w) => w.isNotEmpty)
    .length;

/// What the review found: each error an imperative fix, in the server's
/// words. The manual review has no warnings.
class PostReview {
  const PostReview({required this.errors});

  final List<String> errors;

  bool get ok => errors.isEmpty;

  /// The web's `reviewScore`: each error costs 15 (manual mode has no
  /// warnings, which would cost 5).
  int get score => (100 - errors.length * 15).clamp(0, 100);
}

/// `reviewPost({ mode: 'manual' })` for a post with no planner format.
PostReview reviewManualPost(String raw) {
  final String text = raw.replaceAll(RegExp(r'\r\n?'), '\n');
  final List<String> errors = <String>[];

  if (markdownEmphasis.hasMatch(text)) {
    errors.add(
      'Remove the markdown bold and italics — LinkedIn shows the asterisks '
      'as they are.',
    );
  }
  if (bannedWords.firstMatch(text) case final RegExpMatch m) {
    errors.add('Replace "${m[0]}" with a plain word.');
  }
  if (stockStruggle.firstMatch(text) case final RegExpMatch m) {
    errors.add('Replace "${m[0]}" with what actually happened.');
  }
  if (notJustX.hasMatch(text)) {
    errors.add(
      'Rewrite the "It\'s not just X, it\'s Y" sentence as one plain claim.',
    );
  }
  final int words = bodyWordCount(text);
  final String count =
      'The post body is $words words. It must be between $minPostWords and '
      '$maxPostWords.';
  if (words < minPostWords) {
    errors.add('Lengthen the post. $count');
  } else if (words > maxPostWords) {
    errors.add('Shorten the post. $count');
  }
  return PostReview(errors: errors);
}
