/// The levels' words, and the few pure decisions every screen shares.
///
/// Ports of the web's `components/contest/path/words.ts`, the copy helpers in
/// `components/contest/ui.tsx` and `quizWords.ts`, `levelName` from
/// `lib/contest-gate.ts` and `gapLine` from `MiniBoard.tsx` — the strings
/// verbatim. Pure, so the tests pin them without rendering, and so the node,
/// its card, the quests and the week card cannot each decide "is this
/// finished?" a slightly different way.
///
/// ## Count the day only
///
/// Nothing here, or anywhere in the contest, says how long the contest is:
/// no "Day D of N", no "N-day contest". The day is counted and the window is
/// shown by its dates. A test scans the slice for it.
library;

import 'contest_board.dart';
import 'contest_dates.dart';
import 'contest_path.dart';
import 'lesson_parts.dart';
import 'levels_words.dart';
import 'today_quiz.dart';

/// The last days of a round in which the board is shown.
/// `LEADERBOARD_REVEAL_DAYS` in the web's `lib/contest.ts`.
const int kLeaderboardRevealDays = 10;

// ── Numbers ─────────────────────────────────────────────────────────────────

/// "1,234" — the web's `toLocaleString()`, in English.
String formatCount(int n) {
  final String digits = n.abs().toString();
  final StringBuffer out = StringBuffer(n < 0 ? '-' : '');
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}

/// "+52", "−2" (a true minus sign), "0" — for a figure whose label sits
/// beside it.
String signed(int n) {
  final String sign = n > 0 ? '+' : (n < 0 ? '−' : '');
  return '$sign${formatCount(n.abs())}';
}

/// "+52 XP", "−2 XP". A bare number beside a label reads as anything; the
/// unit keeps it the score.
String contestXp(int n) => '${signed(n)} XP';

/// "1 person", "3 people" — the count, then the right word.
String plural(int n, String one, String many) =>
    '${formatCount(n)} ${n == 1 ? one : many}';

/// "free month" when it is exactly one, the count otherwise — the copy
/// follows the contest's setting.
String freePeriod(int freeDays) =>
    freeDays == 30 ? 'free month' : plural(freeDays, 'free day', 'free days');

// ── Levels ──────────────────────────────────────────────────────────────────

/// What kind of thing a level is, in its card's kicker.
String kindWord(PathNodeKind kind) => switch (kind) {
  PathNodeKind.lesson => 'Lesson',
  PathNodeKind.connectLeaders => 'LinkedIn · Connect',
  PathNodeKind.comment => 'LinkedIn · Comment',
  PathNodeKind.feedComments => 'LinkedIn · Feed comments',
  PathNodeKind.weeklyInvites => 'LinkedIn · Invites',
  PathNodeKind.planWeek => 'Planner · Set up the week',
  PathNodeKind.article => 'LinkedIn · Article link',
  PathNodeKind.video => 'LinkedIn · Video link',
  PathNodeKind.followWinners => 'LinkedIn + Plexaverse · Top learners',
  PathNodeKind.unknown => 'Level',
};

/// Where a level stands, as its card says it and a screen reader hears it.
String stateWord(PathNodeState state) => switch (state) {
  PathNodeState.locked => 'Locked',
  PathNodeState.today => 'Open today',
  PathNodeState.done => 'Done',
  PathNodeState.missed => 'Missed',
  PathNodeState.pending => 'Waiting for review',
  PathNodeState.approved => 'Approved',
  PathNodeState.rejected => 'Rejected',
  PathNodeState.revoked => 'Removed after review',
  PathNodeState.unavailable => 'Nothing to do today',
  PathNodeState.skipped => 'Skipped, still open today',
};

/// One of the open-all-week Sunday levels whose post day has passed undone
/// (25 Nov 2026): drawn disabled — no card, no link — with "Day passed" and
/// the reason in words. Any other missed level is an ordinary past one.
bool isDayPassed(PathNode node) =>
    node.openAllWeek && node.state == PathNodeState.missed;

/// Drawn orange: one of the Sunday levels, open or done. One whose image
/// waits for its post is locked like any locked level, and one whose day
/// has passed wears the muted locked look.
bool isOrange(PathNode node) =>
    node.openAllWeek &&
    (node.state == PathNodeState.today || isFinished(node.state));

/// Where a level stands, in words — [stateWord], except for the Sunday
/// levels: an open one is "Open all week" (not "Open today": it stays open
/// on the days after its Sunday), and one whose day has gone is "Day
/// passed". The web's `stateWord(node)`.
String nodeStateWord(PathNode node) {
  if (node.openAllWeek && node.state == PathNodeState.today) {
    return kSundayLevelOpen;
  }
  if (isDayPassed(node)) return kSundayLevelDayPassed;
  return stateWord(node.state);
}

/// Why a Sunday level's day has passed, without the "Day passed — " its
/// detail starts with: "Monday’s post was not written". Null when there is
/// nothing to say.
String? dayPassedReason(PathNode node) {
  final String d = node.detail ?? '';
  const String prefix = '$kSundayLevelDayPassed — ';
  final String reason = d.startsWith(prefix) ? d.substring(prefix.length) : d;
  return reason.isEmpty ? null : reason;
}

/// The Skip button on the current level (owner, 17 Nov 2026).
const String kSkipLabel = 'Skip this level';

/// The Skip link on the lesson's open part.
const String kSkipPartLabel = 'Skip this part';

/// What a skip means, under the button on a level's own page.
const String kSkipNote =
    'It stays open until the day ends. Its XP counts only if you come back to it.';

/// Finished and paid: nothing more for the learner to do on it.
bool isFinished(PathNodeState state) =>
    state == PathNodeState.done || state == PathNodeState.approved;

/// The learner has done their part — finished, or sent in and waiting.
bool isHandedIn(PathNodeState state) =>
    isFinished(state) || state == PathNodeState.pending;

/// A level's name in a sentence: "Lesson part 3 of 3" for a lesson part (its
/// title's "·" read aloud is noise), the title for everything else.
String levelName(PathNode node) {
  final NodePart? part = node.part;
  if (node.kind == PathNodeKind.lesson && part != null) {
    return 'Lesson part ${part.index} of ${part.total}';
  }
  return node.title;
}

/// Can the card's button take the learner somewhere?
///
/// Locked never opens, even with an href: a future day's level is not there
/// yet. An unknown kind never opens (its node arrives locked anyway), nor
/// does a claim node that lost its piece — there would be nothing to send
/// the link against.
bool canOpen(PathNode node) {
  if (node.state == PathNodeState.locked || node.href == null) return false;
  if (node.kind == PathNodeKind.unknown) return false;
  if (node.kind.isClaim) {
    final NodeClaim? claim = node.claim;
    return claim != null &&
        claim.kind != ClaimKind.unknown &&
        claim.occurrence.isNotEmpty;
  }
  return true;
}

/// The card's button: START for today's work — a skipped level included,
/// since it is still open (CONTINUE once it is part done) — OPEN for
/// anything else that opens.
///
/// For a level that does not open, the card shows "Locked" for a locked one
/// and "Nothing to open" for the rest — this returns the first of those for
/// locked, and the caller decides by [canOpen] for the second.
String actionWord(PathNode node) {
  if (node.state == PathNodeState.locked) return 'Locked';
  if (node.state == PathNodeState.today ||
      node.state == PathNodeState.rejected ||
      node.state == PathNodeState.skipped) {
    final String verb = node.state != PathNodeState.rejected && node.started
        ? 'Continue'
        : 'Start';
    return node.points > 0 ? '$verb +${formatCount(node.points)} XP' : verb;
  }
  return 'Open';
}

/// The node the START bubble sits on: today's open level (or Sunday's late
/// node once nothing gated is open), else the first skipped one. The server
/// gates today, so at most one gated level is open — the open lesson part
/// until the last is done or skipped, then the comment, the feed comments,
/// the weekday's own task and the day's claim. A skipped level gets START
/// back only once nothing else is open.
///
/// The open-all-week Sunday levels (`openAllWeek`, 25 Nov 2026) come LAST:
/// they are outside today's order and stay open until their post day, so
/// anything that can only be done today takes START first. A Sunday level
/// gets it only once nothing else today is open, and only on its own Sunday
/// — on a later day it is not among today's nodes.
String? currentNodeId(List<PathDay> days) {
  for (final PathDay day in days) {
    if (!day.isToday) continue;
    for (final PathNode n in day.nodes) {
      if (!n.openAllWeek && _isOpen(n.state)) return n.id;
    }
    for (final PathNode n in day.nodes) {
      if (n.state == PathNodeState.skipped) return n.id;
    }
    for (final PathNode n in day.nodes) {
      if (n.openAllWeek && n.state == PathNodeState.today) return n.id;
    }
    return null;
  }
  return null;
}

/// Today's open level only — the first today/rejected node, never a skipped
/// one; an open-all-week Sunday level only once nothing of today's own is
/// open (as [currentNodeId]). Where a skip leads next.
PathNode? openLevelOf(List<PathDay> days) {
  for (final PathDay day in days) {
    if (!day.isToday) continue;
    for (final PathNode n in day.nodes) {
      if (!n.openAllWeek && _isOpen(n.state)) return n;
    }
    for (final PathNode n in day.nodes) {
      if (n.openAllWeek && n.state == PathNodeState.today) return n;
    }
    return null;
  }
  return null;
}

bool _isOpen(PathNodeState s) =>
    s == PathNodeState.today || s == PathNodeState.rejected;

/// "Mon · Day 15", "Wed · Day 17 · Today" — the divider above each day.
/// The path draws it in capitals; the string stays as the web builds it.
String dayLabel(PathDay day) {
  final String weekday = day.weekday >= 0 && day.weekday < 7
      ? kWeekdayShort[day.weekday]
      : '';
  final List<String> parts = <String>[weekday, 'Day ${day.dayNumber}'];
  if (day.isToday) parts.add('Today');
  return parts.join(' · ');
}

/// The path's winding: each node's sideways step, in units of the path's
/// amplitude. Counted across the whole week — nodes, the chest and the trophy
/// each take a step — so the path keeps swinging through the day dividers.
double windAt(int i) {
  const List<double> wind = <double>[0, 0.7, 1, 0.7, 0, -0.7, -1, -0.7];
  return wind[((i % wind.length) + wind.length) % wind.length];
}

// ── Lessons on the path ─────────────────────────────────────────────────────

/// The day's lesson parts, in order — one node per checkpoint.
List<PathNode> lessonPartsOf(PathDay? day) => day == null
    ? const <PathNode>[]
    : <PathNode>[
        for (final PathNode n in day.nodes)
          if (n.kind == PathNodeKind.lesson) n,
      ];

/// The day's lesson is finished: every part is, since a part can be skipped
/// (17 Nov 2026) and the last one can then be done before an earlier one.
bool isLessonDone(PathDay? day) {
  final List<PathNode> parts = lessonPartsOf(day);
  return parts.isNotEmpty && parts.every((PathNode p) => isHandedIn(p.state));
}

/// How far through ITS OWN part the learner is (0–1), for the START ring on
/// a lesson part — not the whole day's progress.
///
/// [answered] and [total] are today's, from the lesson read. The server's
/// cut wins when the node carries one: the node's detail was counted on it,
/// and the lesson read's size can differ for a moment (opening the day
/// writes its own questions; the path is re-read after). A node from a
/// server before parts gets the day's fraction.
///
/// With [answeredIndexes] (WHICH questions are answered — after a skip the
/// answers need not be a prefix), the part's progress is its answered
/// questions over its size; without, the old count rule.
double partProgress(
  PathNode node, {
  required int answered,
  required int total,
  Set<int>? answeredIndexes,
}) {
  if (node.kind != PathNodeKind.lesson || total <= 0) return 0;
  final NodePart? part = node.part;
  if (part == null) return (answered / total).clamp(0, 1).toDouble();
  final int? start = part.start;
  final int? end = part.end;
  int s;
  int e;
  if (start != null && end != null && end > start) {
    s = start;
    e = end;
  } else {
    final List<LessonPart> cut = lessonPartBounds(total);
    final int i = part.index - 1;
    if (i < 0 || i >= cut.length) return 0;
    s = cut[i].start;
    e = cut[i].end;
  }
  final Set<int>? which = answeredIndexes;
  if (which != null) {
    int n = 0;
    for (int i = s; i < e; i++) {
      if (which.contains(i)) n++;
    }
    return (n / (e - s)).clamp(0, 1).toDouble();
  }
  return ((answered - s) / (e - s)).clamp(0, 1).toDouble();
}

// ── The week ────────────────────────────────────────────────────────────────

/// The week trophy at the end of the path, as the server's [WeekReward]
/// says it: open once earned, shut while still possible, shut and muted with
/// a red tag once a day went unfinished. No reward (an older server) is a
/// shut, plain trophy.
class WeekTrophy {
  const WeekTrophy({
    required this.open,
    required this.label,
    required this.missed,
  });

  final bool open;
  final String label;

  /// Draw it muted, with its label as the red tag.
  final bool missed;
}

WeekTrophy weekTrophy(WeekReward? reward) {
  if (reward == null) {
    return const WeekTrophy(open: false, label: 'Week trophy', missed: false);
  }
  if (reward.earned) {
    final int? paid = reward.paid;
    return WeekTrophy(
      open: true,
      // No figure when nothing was paid: earned while paused, or a 0 bonus.
      label: paid != null && paid != 0
          ? 'Week complete · +${formatCount(paid)} XP'
          : 'Week complete',
      missed: false,
    );
  }
  if (reward.missedDay) {
    return WeekTrophy(
      open: false,
      label: reward.points > 0
          ? '−${formatCount(reward.points)} XP missed · incomplete week'
          : 'Missed a day’s lesson this week',
      missed: true,
    );
  }
  return WeekTrophy(
    open: false,
    label: reward.points > 0
        ? 'Week trophy · +${formatCount(reward.points)} XP'
        : 'Week trophy',
    missed: false,
  );
}

/// The claim's status word on the week card.
String claimWord(PostClaim claim) => switch (claim.status) {
  ClaimStatus.approved => 'Done',
  ClaimStatus.pending => 'Pending',
  ClaimStatus.rejected => 'Rejected',
  ClaimStatus.open => 'Share link',
  ClaimStatus.notReady => switch (weekdayOfKey(claim.opensOnKey)) {
    final int wd => 'Opens ${kWeekdayShort[wd]}',
    null => '+${claim.points}',
  },
};

// ── The board ───────────────────────────────────────────────────────────────

/// What the board says before it opens. The server sends no rows until
/// then; this is the words.
String boardLockedLine(String revealsOn) {
  final String label = dayKeyLong(revealsOn);
  final String when = label.isEmpty ? 'in the round’s last days' : 'on $label';
  return 'The top learners show $when — the last $kLeaderboardRevealDays days of the round. Until then, it’s you against yesterday: keep your streak.';
}

/// The one sentence under the board: how far to the next place that changes
/// something.
String gapLine(List<BoardRow> rows, BoardRow? viewer, int topN) {
  if (viewer == null) return 'Most consistent and most correct leads.';
  if (viewer.rank == 1) return 'You lead. Keep the streak going.';
  BoardRow? rowAt(int rank) {
    for (final BoardRow r in rows) {
      if (r.rank == rank) return r;
    }
    return null;
  }

  if (viewer.rank <= topN) {
    final BoardRow? above = rowAt(viewer.rank - 1);
    if (above == null) return 'You are a finalist.';
    final int pass = above.total - viewer.total + 1;
    return 'You are a finalist. ${formatCount(pass < 1 ? 1 : pass)} XP to pass #${formatCount(above.rank)}.';
  }
  final BoardRow? last = rowAt(topN);
  if (last != null) {
    final int reach = last.total - viewer.total + 1;
    return '${formatCount(reach < 1 ? 1 : reach)} XP to reach the top ${formatCount(topN)}.';
  }
  return 'Most consistent and most correct leads.';
}

// ── The lesson ──────────────────────────────────────────────────────────────

/// What paused scoring means for an answer NOT YET GIVEN — the banner over
/// an unanswered question.
///
/// "Not now and not later" is the point of it: an answer given while scoring
/// is paused is recorded and never paid, not even once a plan starts. Any
/// wording that reads as "these will count once you subscribe" is a promise
/// the ledger will not keep. One string, so no screen can drift into it.
const String kQuizPausedLine =
    'Your free days are over, so answers you give now don’t earn XP — not now and not later. With a plan, your next answers do.';

/// For answers already given that the ledger never paid. The same promise as
/// [kQuizPausedLine]: never later.
const String kQuizUnscoredLine =
    'These answers came while your scoring was paused, so they earned no XP — not now and not later.';

/// Why today has no lesson, in one sentence.
String noQuizLine(TodayQuiz? quiz) => quiz?.reason == QuizReason.bankEnded
    ? 'The lesson questions for your level have run out, so there is no lesson today.'
    : 'There is no lesson at your level today.';

/// What the learner can expect tomorrow — or null when the server has not
/// said, because a guess here is a promise. False on the contest's last day
/// and when the band's questions run out; it does not say which, so neither
/// is named.
String? tomorrowLine(TodayQuiz? quiz) => switch (quiz?.tomorrow) {
  true => 'A new lesson tomorrow.',
  false => 'No lesson tomorrow.',
  null => null,
};
