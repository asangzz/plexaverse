/// The twelve legs of the 1000-day journey.
///
/// Ported from `ROADMAP_PLANETS` and `ROADMAP_PHASES` in the web's
/// `lib/roadmap-phases.ts`.
///
/// ## This used to be 66 days and nine planets
///
/// The arc was rebuilt: four phases across a thousand days, twelve planets
/// split between them. The old table summed to 66, and keeping it did real
/// damage rather than merely looking out of date — `seasonOneFinished` is
/// `day > roadmapTotalDays`, so every user past their sixty-sixth day was
/// being told Season 1 was over and pushed to the Season Complete screen, 934
/// days before the web thinks it ends.
///
/// ## Why the days are explicit bounds now, not a count
///
/// The old entries carried `days: 5` and the lookup accumulated them, which
/// works only while the table is contiguous and complete. The web writes
/// `startDay`/`endDay` per planet, and the phase boundaries (90 / 365 / 730 /
/// 1000) are the real constants — a planet is a slice of a phase, not an
/// increment. Porting the counts would have meant re-deriving twelve
/// boundaries by addition and getting the same answer only if nothing is ever
/// inserted.
///
/// Sizes, gradients and shadows live in the presentation layer
/// (`presentation/widgets/planet_node.dart`) — they are how a planet is DRAWN,
/// not what it is.
library;

/// The whole arc. The old roadmap stopped at 66; nothing else about it did.
///
/// Mirrors `ROADMAP_TOTAL_DAYS`.
const int roadmapTotalDays = 1000;

/// One of the four stretches the journey is divided into.
class RoadmapPhase {
  const RoadmapPhase({
    required this.key,
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.followerTarget,
  });

  /// Logic key. Stored and compared; never shown.
  final String key;

  /// Shown.
  final String name;

  final int startDay;
  final int endDay;

  /// Where a steady pace would put someone by the END of this phase.
  ///
  /// A yardstick, not a gate, and an optimistic one — its job is to make a
  /// stalled account visible to its owner. A phase advances on elapsed days
  /// only: LinkedIn exposes no follower count for a personal profile without
  /// Partner Program access, so this number is one the user uploads
  /// themselves and cannot be gated on.
  final int followerTarget;
}

/// Mirrors `ROADMAP_PHASES`.
///
/// The first two targets were 1,000 and 10,000 here against the web's 3,000
/// and 15,000 — a divergence that cost nothing while `followerTarget` was
/// declared and read by nobody, and would have become four wrong numbers on
/// screen the moment a checkpoint surface existed. It does now.
const List<RoadmapPhase> roadmapPhases = <RoadmapPhase>[
  RoadmapPhase(
    key: 'getting_seen',
    name: 'Getting Seen',
    startDay: 1,
    endDay: 90,
    followerTarget: 3000,
  ),
  RoadmapPhase(
    key: 'being_trusted',
    name: 'Being Trusted',
    startDay: 91,
    endDay: 365,
    followerTarget: 15000,
  ),
  RoadmapPhase(
    key: 'compounding',
    name: 'Compounding',
    startDay: 366,
    endDay: 730,
    followerTarget: 50000,
  ),
  RoadmapPhase(
    key: 'recognised',
    name: 'Recognised',
    startDay: 731,
    endDay: roadmapTotalDays,
    followerTarget: 100000,
  ),
];

/// One leg of the journey.
class RoadmapPlanet {
  const RoadmapPlanet({
    required this.key,
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.phaseKey,
  });

  /// The stable identifier the drawing tables are keyed on. Logic keys on
  /// this, never on [name].
  final String key;

  /// What the user reads, beside the planet.
  final String name;

  /// Inclusive bounds within the arc.
  final int startDay;
  final int endDay;

  /// Which [RoadmapPhase] this planet belongs to.
  final String phaseKey;

  /// How many roadmap days this planet covers.
  int get days => endDay - startDay + 1;
}

/// Mirrors `ROADMAP_PLANETS`. Twelve, three per phase.
const List<RoadmapPlanet> roadmapPlanets = <RoadmapPlanet>[
  // Phase 1 — Getting Seen (1–90)
  RoadmapPlanet(
    key: 'mercury',
    name: 'Mercury',
    startDay: 1,
    endDay: 30,
    phaseKey: 'getting_seen',
  ),
  RoadmapPlanet(
    key: 'venus',
    name: 'Venus',
    startDay: 31,
    endDay: 60,
    phaseKey: 'getting_seen',
  ),
  RoadmapPlanet(
    key: 'earth',
    name: 'Earth',
    startDay: 61,
    endDay: 90,
    phaseKey: 'getting_seen',
  ),
  // Phase 2 — Being Trusted (91–365)
  RoadmapPlanet(
    key: 'mars',
    name: 'Mars',
    startDay: 91,
    endDay: 180,
    phaseKey: 'being_trusted',
  ),
  RoadmapPlanet(
    key: 'jupiter',
    name: 'Jupiter',
    startDay: 181,
    endDay: 270,
    phaseKey: 'being_trusted',
  ),
  RoadmapPlanet(
    key: 'saturn',
    name: 'Saturn',
    startDay: 271,
    endDay: 365,
    phaseKey: 'being_trusted',
  ),
  // Phase 3 — Compounding (366–730)
  RoadmapPlanet(
    key: 'uranus',
    name: 'Uranus',
    startDay: 366,
    endDay: 480,
    phaseKey: 'compounding',
  ),
  RoadmapPlanet(
    key: 'neptune',
    name: 'Neptune',
    startDay: 481,
    endDay: 600,
    phaseKey: 'compounding',
  ),
  RoadmapPlanet(
    key: 'nebula',
    name: 'Nebula',
    startDay: 601,
    endDay: 730,
    phaseKey: 'compounding',
  ),
  // Phase 4 — Recognised (731–1000)
  RoadmapPlanet(
    key: 'quasar',
    name: 'Quasar',
    startDay: 731,
    endDay: 820,
    phaseKey: 'recognised',
  ),
  RoadmapPlanet(
    key: 'nova',
    name: 'Nova',
    startDay: 821,
    endDay: 910,
    phaseKey: 'recognised',
  ),
  RoadmapPlanet(
    key: 'milkyway',
    name: 'Milky Way',
    startDay: 911,
    endDay: roadmapTotalDays,
    phaseKey: 'recognised',
  ),
];

/// The phase a roadmap day falls in. Falls through to the last one past the
/// end of the arc, the way the web's lookup does.
RoadmapPhase phaseForDay(int day) {
  for (final RoadmapPhase p in roadmapPhases) {
    if (day >= p.startDay && day <= p.endDay) return p;
  }
  return roadmapPhases.last;
}

/// Where a roadmap day sits in the solar system.
///
/// [fraction] is how far through its planet the day is — it drives the orbit
/// ring's sweep and the orbiting dot's angle. [dayInPlanet] and [totalDays]
/// are the "Day 3 of 30" the row reads out; note that is the day within the
/// PLANET, not within the thousand, which is what makes each leg feel
/// finishable. At 1000 days that matters far more than it did at 66.
({RoadmapPlanet planet, double fraction, int dayInPlanet, int totalDays})
planetContextForDay(int day) {
  for (final RoadmapPlanet p in roadmapPlanets) {
    if (day >= p.startDay && day <= p.endDay) {
      final int dayInPlanet = day - p.startDay + 1;
      return (
        planet: p,
        fraction: dayInPlanet / p.days,
        dayInPlanet: dayInPlanet,
        totalDays: p.days,
      );
    }
  }
  // Past the end of the journey — the web falls through to the last planet at
  // full orbit, and so does this.
  final RoadmapPlanet last = roadmapPlanets.last;
  return (
    planet: last,
    fraction: 1,
    dayInPlanet: last.days,
    totalDays: last.days,
  );
}
