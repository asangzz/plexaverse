/// The comment level's words — the web's `CommentLevel.tsx` copy, verbatim,
/// and the template split its two screens share. Pure, so a test pins them
/// without rendering.
library;

import '../../../domain/contest_repository.dart';

/// The kicker over every comment-level screen.
const String kCommentEyebrow = 'Today · comment level';

/// Under the pill once the comment is on the clipboard.
const String kCopiedLine = 'Copied — paste it as your comment';

/// The result bar after a miss that cost the day's XP.
const String kWrongLine =
    'First-try XP for today is gone, but you can still finish your comment and post it.';

/// The result bar after a miss that cost nothing — the first try was not
/// this one, and was not a miss.
const String kFixLine = 'Fix the red blanks and check again.';

/// Above the comment, once the first try has missed and the learner is back.
const String kFirstTryMissedNote =
    'Your first try missed, so today’s comment XP is gone. Finish it to post your comment.';

/// On the finished comment, when it was not right first time.
const String kNoXpTodayLine =
    'Not right first time, so no XP today — the comment is still yours.';

/// Why there is no comment level to play: a title and a line.
typedef CommentUnavailableWords = ({String title, String line});

/// The words for an unavailable level, by the server's reason. No reason —
/// or one this build does not know — is "not written": the comment could not
/// be written this time.
CommentUnavailableWords commentUnavailableWords(
  CommentLevelReason? reason,
) => switch (reason) {
  CommentLevelReason.notToday => (
    title: 'No comment level today',
    line:
        'There is no comment level today. Today’s lesson is on your levels page.',
  ),
  CommentLevelReason.noPost => (
    title: 'No post to comment on today',
    line:
        'There is no post from a top voice in your field today, so there is nothing to comment on. Today’s lesson still counts.',
  ),
  CommentLevelReason.notRunning => (
    title: 'New levels are on the way',
    line:
        'The levels reset between rounds, and the next round starts soon. Its comment levels will show up on your levels page.',
  ),
  CommentLevelReason.notJoined => (
    title: 'Open your levels first',
    line:
        'Open your levels page once and today’s comment level opens here. There is nothing to join.',
  ),
  CommentLevelReason.writing => (
    title: 'Writing today’s comment',
    line: 'Today’s comment is being written. It will appear here in a moment.',
  ),
  null => (
    title: 'Today’s comment is not ready',
    line:
        'We could not write today’s comment just now. Come back a little later; today’s lesson still counts.',
  ),
};

/// One piece of the comment: running text, or the blank at [slot].
sealed class CommentPart {
  const CommentPart();
}

final class CommentText extends CommentPart {
  const CommentText(this.text);

  final String text;
}

final class CommentSlot extends CommentPart {
  const CommentSlot(this.slot);

  /// 0-based: `{{1}}` is slot 0.
  final int slot;
}

/// The template split into text and blanks, in order. A marker past
/// [blankCount] (or `{{0}}`) is left out, as the web's `splitTemplate` does,
/// so a malformed template can never ask for a blank the bank cannot fill.
List<CommentPart> splitTemplate(String template, int blankCount) {
  final List<CommentPart> out = <CommentPart>[];
  int last = 0;
  for (final RegExpMatch m in RegExp(r'\{\{(\d+)\}\}').allMatches(template)) {
    if (m.start > last) out.add(CommentText(template.substring(last, m.start)));
    // tryParse: a run of digits too long for an int is no blank either.
    final int n = int.tryParse(m.group(1)!) ?? 0;
    if (n >= 1 && n <= blankCount) out.add(CommentSlot(n - 1));
    last = m.end;
  }
  if (last < template.length) out.add(CommentText(template.substring(last)));
  return out;
}
