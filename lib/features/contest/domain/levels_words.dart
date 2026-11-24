/// The levels' own words — the web's `lib/levels-copy.ts`, WORD FOR WORD,
/// plus the follow level's from `lib/follow-winners.ts`.
///
/// Owner, 24 Nov 2026: learners are never told about a contest. They pass
/// levels, earn XP, and every three months the levels reset — a new round —
/// and the learners with the most XP get a shoutout. The web's onboarding
/// step, its levels page and its rules page read those modules; this file
/// says the same thing, character for character, so a learner is told the
/// same on either platform. An edit there is an edit here.
///
/// The internal names (`ContestPage`, `contestPathProvider`, the
/// `/api/mobile/v1/contest/**` routes) keep the old word: they are code, and
/// no learner reads them. `test/features/contest/no_contest_word_test.dart`
/// holds every string a learner can read to it.
library;

import 'contest_words.dart' show formatCount, plural;

/// How long a round of levels lasts, in calendar months.
const int kRoundMonths = 3;

/// The rules page's title, and the link text that leads to it.
const String kLevelsRulesTitle = 'How levels, XP and shoutouts work';

/// The onboarding step's label in the web's progress header.
const String kLevelsIntroStepLabel = 'Your levels';

/// Onboarding's last step, before the learner lands on Level 1: Plexa says
/// these lines in order, then offers [kLevelsIntroStart] (and a link to the
/// rules). The web's `LEVELS_INTRO.lines`.
/// The paid condition on scoring, said before anyone scores — the web's
/// `PAID_SCORING_LINE` (review of 24 Nov 2026).
const String kPaidScoringLine =
    'Levels are free to take. In each round your first month of XP is free '
    'too; after that, XP counts only while you have a Plexaverse plan — the '
    'lessons stay open either way.';

/// While a round's free days run, the paid condition is said on the levels
/// page itself, above the path — the web's `FreeDaysLine` in
/// `ContestClient.tsx`, word for word. A learner entered automatically (there
/// is no join step, and the join card that used to say it is gone) never sees
/// onboarding's step (review of 24 Nov 2026). Gone once the days are used up:
/// `PausedNotice` says the rest.
String freeDaysLine(int left) =>
    '${plural(left, 'free day', 'free days')} of XP left in this round. After '
    'that, XP counts only while you have a Plexaverse plan — the lessons stay '
    'open either way.';

const List<String> kLevelsIntroLines = <String>[
  'Last thing: how your levels work. Every day you pass levels — a short '
      'English lesson, then a few LinkedIn tasks — and each level you pass '
      'earns XP.',
  kPaidScoringLine,
  'Levels reset every $kRoundMonths months. When they reset, the learners '
      'with the most XP get a shoutout: their profile becomes a level every '
      'learner sees, where learners follow them on LinkedIn and on Plexaverse '
      'and earn XP for it.',
  'A shoutout is recognition only — it has no cash value.',
];

/// The one button: the learner's answer, and the way to Level 1.
const String kLevelsIntroStart = 'Start Level 1';

/// The link beside it.
const String kLevelsIntroRules = kLevelsRulesTitle;

/// How an anonymous learner is shown to the others — anyone who has not
/// switched their name on.
const String kAnonymousLearner = 'Learner';

/// The board's name wherever a board of learners is shown.
const String kTopLearners = 'Top learners';

/// The leaderboard-name consent (`contest_leaderboard`), asked in context on
/// the levels page and in Settings — never assumed. Entry is automatic and
/// anonymous; this is the learner's own switch.
const String kNameToggleLabel = 'Show my name to other learners';

/// The consent purpose that switch records.
const String kNameTogglePurpose = 'contest_leaderboard';

/// Said under the switch.
const String kNameToggleDetail =
    'Other learners see your name and profile photo beside your XP and rank '
    'among the top learners. Leave it off and you still earn XP and a place, '
    'shown as “$kAnonymousLearner”. You can change this here or in Settings '
    '→ Your data & consent at any time.';

const List<String> _months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "23 February 2027" for a `YYYY-MM-DD` day key — spelt by hand, never
/// shifted by a timezone. Empty for anything that is not a day key.
String dayKeyLongDate(String dayKey) {
  final List<String> parts = dayKey.split('-');
  if (parts.length != 3) return '';
  final int? y = int.tryParse(parts[0]);
  final int? m = int.tryParse(parts[1]);
  final int? d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null || m < 1 || m > 12) return '';
  return '$d ${_months[m - 1]} $y';
}

/// A round named by its dates, never by an admin's title: "the round that
/// ended 23 February 2027".
String roundEndedPhrase(String lastDayKey) {
  final String date = dayKeyLongDate(lastDayKey);
  return date.isEmpty ? 'the last round' : 'the round that ended $date';
}

// ── "Follow last round's top learners" (lib/follow-winners.ts) ──────────────

/// The level's name, on the path and on its page.
const String kFollowWinnersTitle = 'Follow last round’s top learners';

/// Step 1's button.
const String kFollowOnLinkedIn = 'Follow on LinkedIn';

/// Step 2's button.
const String kFollowOnPlexaverse = 'Follow on Plexaverse';

/// Said under step 1: why the tap is all we record.
const String kLinkedInSelfReportedLine =
    'LinkedIn does not tell us who follows whom, so this step counts when you '
    'tap it. Follow them for real — it is the point.';

/// Said on the level's page: what pays, and what does not undo it.
String followWinnersLead(int pointsEach) {
  final String xp = pointsEach > 0
      ? ' and earn ${formatCount(pointsEach)} XP for each'
      : '';
  return 'Last round’s top learners agreed to be featured. Follow each of '
      'them on LinkedIn and on Plexaverse$xp. It is paid once for each of '
      'them this round; unfollowing later does not take it back.';
}
