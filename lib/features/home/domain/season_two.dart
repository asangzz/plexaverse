/// Season 2 — the endless four-phase cycle that replaces the 66-day roadmap.
///
/// Ported from `lib/narrative-phases.ts` (`getSeasonDay`,
/// `getSeason2LoopNumber`, `getNarrativePhase`, `SEASON_2_PHASES`,
/// `TRANSFORMATION_PHASES`) and the `PHASE_META` / `DAILY_HABITS` tables in
/// `components/automate/Season2Dashboard.tsx`.
///
/// Season 1 is a journey with an end; Season 2 is a habit with a rhythm. The
/// surface says so — one phase a week, four phases a cycle, forever.
library;

/// A narrative phase: what this week's posts are FOR.
class NarrativePhase {
  const NarrativePhase({required this.name, required this.intent});

  /// The matcher key against the phase tables. **Never rename it** — it is
  /// load-bearing logic on the web, where the generator looks phases up by
  /// name. The user-visible string is [SeasonTwoPhase.label].
  final String name;

  /// One sentence on what the week is trying to do. Rendered verbatim.
  final String intent;
}

/// The Season 2 orbit: four phases, one a week, in orbit order.
///
/// `name` matches `SEASON_2_PHASES` in `lib/narrative-phases.ts`; `label` is
/// the plain-English text the user reads. The two are deliberately different —
/// "Event Horizon" is a system identifier, "Bold takes" is the promise.
class SeasonTwoPhase {
  const SeasonTwoPhase({
    required this.name,
    required this.label,
    required this.symbol,
    required this.angleDegrees,
  });

  final String name;
  final String label;

  /// The glyph on the orbit ring and the phase card's badge.
  final String symbol;

  /// Where the phase sits on the ring, 0° at the top, clockwise.
  final double angleDegrees;
}

const List<SeasonTwoPhase> seasonTwoPhases = <SeasonTwoPhase>[
  SeasonTwoPhase(
    name: 'Event Horizon',
    label: 'Bold takes',
    symbol: '◈',
    angleDegrees: 270,
  ),
  SeasonTwoPhase(
    name: 'Singularity',
    label: 'Deep expertise',
    symbol: '◉',
    angleDegrees: 0,
  ),
  SeasonTwoPhase(
    name: 'Multiverse',
    label: 'Unexpected angles',
    symbol: '⊕',
    angleDegrees: 90,
  ),
  SeasonTwoPhase(
    name: 'Time Dilation',
    label: 'Lessons learned',
    symbol: '◎',
    angleDegrees: 180,
  ),
];

/// The intents behind [seasonTwoPhases], in the same order.
const List<NarrativePhase> _seasonTwoIntents = <NarrativePhase>[
  NarrativePhase(
    name: 'Event Horizon',
    intent:
        'First bold stance — content no one else in your field will say out '
        'loud',
  ),
  NarrativePhase(
    name: 'Singularity',
    intent: 'Hyper-specific mastery — maximum density, zero filler',
  ),
  NarrativePhase(
    name: 'Multiverse',
    intent: 'Cross-genre thinking — connect your niche to an unexpected domain',
  ),
  NarrativePhase(
    name: 'Time Dilation',
    intent:
        'Reflection from depth — lessons that only exist on the other side of '
        'the event horizon',
  ),
];

/// The five-phase arc a `transformation` user runs instead.
///
/// The web's `getNarrativePhase` sends transformation users down this table
/// even in Season 2, clamped to 66 days. Its names do not appear on the orbit
/// ring, so the dashboard's `findIndex` misses and the ring pins to phase 0 —
/// this port reproduces that, but shows the CORRECT intent rather than the
/// orbit phase's, because the intent is the sentence the user is meant to act
/// on and showing the wrong one would be a bug we copied rather than ported.
const List<NarrativePhase> _transformationPhases = <NarrativePhase>[
  NarrativePhase(
    name: 'The Expert',
    intent:
        'Establish deep credibility in your current role before the pivot — '
        'you cannot transition credibly without proving you mastered the old '
        'thing',
  ),
  NarrativePhase(
    name: 'The Spark',
    intent:
        'Show what pulled you toward the new direction — curiosity, '
        'experiments, a moment of realisation',
  ),
  NarrativePhase(
    name: 'The Bridge',
    intent:
        'Connect your old expertise to the new domain in specific, surprising '
        'ways that only you can articulate',
  ),
  NarrativePhase(
    name: 'The Learner',
    intent:
        'Document active transformation in real time — experiments, failures, '
        'and wins',
  ),
  NarrativePhase(
    name: 'The Arrival',
    intent:
        'Post as the new identity — the transformation is complete in the '
        'content even if still in progress in real life',
  ),
];

/// Day within the current season, 1-indexed and **uncapped** — Season 2 has no
/// finish line, which is the point of it.
///
/// Anchored on `seasonStartedAt` so the counter restarts at 1 when Season 2
/// begins; falls back to `roadmapStartedAt` for users whose season flipped
/// before that column existed.
int seasonDay({
  DateTime? seasonStartedAt,
  DateTime? roadmapStartedAt,
  DateTime? now,
}) {
  final DateTime? anchor = seasonStartedAt ?? roadmapStartedAt;
  if (anchor == null) return 1;
  final int days = (now ?? DateTime.now()).difference(anchor).inDays + 1;
  return days < 1 ? 1 : days;
}

/// Which 28-day loop (four phases × seven days) the user is on, 1-indexed.
/// The generator pushes harder on each successive loop.
int seasonTwoLoopNumber(int day) => (day - 1) ~/ 28 + 1;

/// Day within the current phase, 1..7.
int seasonTwoPhaseDay(int day) => (day - 1) % 7 + 1;

/// Which of the four orbit phases is live.
///
/// A `transformation` user has no orbit phase of their own, so the ring pins to
/// index 0 — matching the web's `Math.max(0, findIndex(...))`.
int seasonTwoPhaseIndex(int day, String contentMode) {
  if (contentMode == 'transformation') return 0;
  return ((day - 1) ~/ 7) % seasonTwoPhases.length;
}

/// The intent sentence for this day.
NarrativePhase seasonTwoIntent(int day, String contentMode) {
  if (contentMode == 'transformation') {
    final int clamped = day < 1 ? 1 : (day > 66 ? 66 : day);
    final int index = (clamped - 1) ~/ 13;
    return _transformationPhases[index > 4 ? 4 : index];
  }
  return _seasonTwoIntents[seasonTwoPhaseIndex(day, contentMode)];
}

// ── Daily habits ────────────────────────────────────────────────────────────

/// One of the day's recurring tasks.
class DailyHabit {
  const DailyHabit({
    required this.id,
    required this.title,
    required this.link,
    required this.xp,
  });

  /// Matches the Season 1 roadmap's step id, so a completion written from
  /// either dashboard means the same thing.
  final int id;
  final String title;
  final String link;
  final int xp;
}

const List<DailyHabit> _dailyHabits = <DailyHabit>[
  DailyHabit(id: 1, title: 'Publish a post', link: '/create', xp: 100),
  DailyHabit(id: 2, title: 'Comment on posts', link: '/comments', xp: 50),
  DailyHabit(
    id: 3,
    title: 'Send connection requests',
    link: '/connections',
    xp: 50,
  ),
];

const DailyHabit _weeklyReachHabit = DailyHabit(
  id: 5,
  title: "Log this week's reach",
  link: '/persona?focus=reach',
  xp: 100,
);

/// Today's habits. Sunday carries a fourth.
///
/// Evaluated per build, exactly as the web evaluates it per render, so the task
/// appears and leaves on its own — and so the progress bar's DENOMINATOR moves
/// with it. A fixed denominator would read 3/3 with the reach task still open.
List<DailyHabit> habitsForToday([DateTime? now]) =>
    (now ?? DateTime.now()).weekday == DateTime.sunday
    ? <DailyHabit>[..._dailyHabits, _weeklyReachHabit]
    : _dailyHabits;
