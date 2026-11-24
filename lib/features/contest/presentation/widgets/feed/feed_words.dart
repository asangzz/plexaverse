/// "Post 5 valuable comments" in words — the web's `FeedComments.tsx` copy,
/// verbatim. Pure, so a test pins the sentences that carry numbers without
/// rendering.
library;

import '../../../domain/contest_links.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';

/// The kicker over the task.
const String kFeedEyebrow = 'Every day · your feed';

/// Where the comments are left.
const String kFeedUrl = 'https://www.linkedin.com/feed/';

/// How to get a comment's link out of LinkedIn.
const String kFeedHowLine =
    'On LinkedIn, open the ⋯ menu on your comment → Copy link to comment, then paste it here.';

/// Why do this every day — modest, true, and nothing promised.
const List<String> kFeedWhyPoints = <String>[
  'People who follow the post’s author can see your comment, so new people in your field come across your name.',
  'Showing up with useful thoughts day after day is how people in your field start to remember you.',
  'A good comment starts a conversation, and conversations are where connections and opportunities begin.',
  'Every comment is practice at writing professional English in public, a few sentences at a time.',
  'LinkedIn can show your profile to more people when you add thoughtful comments, not just reactions.',
];

/// What a valuable comment is.
const List<String> kFeedCountsPoints = <String>[
  'An experience of your own that bears on the post',
  'A real question that takes the idea further',
  'A respectful counterpoint, with your reason',
  'A specific takeaway, said in your own words',
];

/// And what it is not.
const String kFeedNotCountsLine =
    'Not “Great post!”, not “Thanks for sharing”, and not emoji on their own.';

/// The warning, with the real penalty — stated plainly, BEFORE the send
/// button. A contest may set no penalty; "and 0 more is deducted" would read
/// as a threat that is not one, so the clause goes.
String feedWarningLine(int penalty) {
  const String base =
      'We check these. A link that isn’t your comment, or a comment that isn’t genuine, is a false claim: the XP is taken back';
  return penalty > 0
      ? '$base and ${formatCount(penalty)} more is deducted.'
      : '$base.';
}

/// What each comment pays, in words: "+20 XP each, 100 for all 5". When the
/// total does not split evenly the fifth carries the remainder, and says so.
/// Empty when the task pays nothing.
String feedSharesLine(FeedCommentsView view) {
  if (view.points <= 0) return '';
  final List<int> shares = view.shares.isNotEmpty
      ? view.shares
      : <int>[view.points];
  final int first = shares.first;
  final int last = shares.last;
  final String all = '${formatCount(view.points)} for all ${view.perDay}';
  if (first == last) return '+${formatCount(first)} XP each, $all';
  final String nth = view.perDay == 5 ? 'fifth' : '#${view.perDay}';
  return '+${formatCount(first)} XP each (the $nth +${formatCount(last)}), $all';
}

/// The field's line for a link the check here refused.
String feedProblemText(FeedCommentLinkProblem problem) => switch (problem) {
  FeedCommentLinkProblem.empty => 'Paste the link to this comment.',
  FeedCommentLinkProblem.bad =>
    'That is not a link to a comment on a LinkedIn post. Use Copy link to comment.',
  FeedCommentLinkProblem.duplicate =>
    'You already sent this comment today. Each comment counts once.',
};

/// The line under the header when there is no task to do.
String feedUnavailableLine(FeedCommentsReason? reason) => switch (reason) {
  FeedCommentsReason.notJoined =>
    'Open your levels page once and this level opens here. There is nothing to join.',
  FeedCommentsReason.notRunning =>
    'This level runs while a round of levels does. The next round starts soon.',
  _ => 'There is no comments task today.',
};
