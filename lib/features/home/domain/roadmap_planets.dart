/// The nine legs of the 66-day journey.
///
/// Ported from `PLANET_TIMELINE` in `components/automate/GamifiedRoadmap.tsx`.
/// The day counts are not decorative: they sum to exactly 66, and the segment a
/// day falls in decides which planet is on screen and how far round its orbit
/// ring the progress arc has travelled.
///
/// Sizes, gradients and shadows live in the presentation layer
/// (`presentation/widgets/planet_node.dart`) — they are how a planet is DRAWN,
/// not what it is.
library;

/// One leg of the journey.
class RoadmapPlanet {
  const RoadmapPlanet({
    required this.key,
    required this.name,
    required this.days,
  });

  /// The stable identifier the drawing tables are keyed on. Logic keys on
  /// this, never on [name].
  final String key;

  /// What the user reads, beside the planet.
  final String name;

  /// How many roadmap days this planet covers.
  final int days;
}

/// Mercury 5 · Venus 7 · Earth 9 · Mars 10 · Jupiter 13 · Saturn 10 ·
/// Uranus 7 · Neptune 4 · Milky Way 1 = 66.
const List<RoadmapPlanet> roadmapPlanets = <RoadmapPlanet>[
  RoadmapPlanet(key: 'mercury', name: 'Mercury', days: 5),
  RoadmapPlanet(key: 'venus', name: 'Venus', days: 7),
  RoadmapPlanet(key: 'earth', name: 'Earth', days: 9),
  RoadmapPlanet(key: 'mars', name: 'Mars', days: 10),
  RoadmapPlanet(key: 'jupiter', name: 'Jupiter', days: 13),
  RoadmapPlanet(key: 'saturn', name: 'Saturn', days: 10),
  RoadmapPlanet(key: 'uranus', name: 'Uranus', days: 7),
  RoadmapPlanet(key: 'neptune', name: 'Neptune', days: 4),
  RoadmapPlanet(key: 'milkyway', name: 'Milky Way', days: 1),
];

/// The total the timeline covers. Asserted rather than assumed: the roadmap is
/// built to 66 days independently, and a planet table that drifted from it
/// would silently drop or duplicate days.
const int roadmapTotalDays = 66;

/// Where a roadmap day sits in the solar system.
///
/// [fraction] is how far through its planet the day is — it drives the orbit
/// ring's sweep and the orbiting dot's angle. [dayInPlanet] and [totalDays]
/// are the "Day 3 of 9" the row reads out; note that is the day within the
/// PLANET, not within the 66, which is what makes each leg feel finishable.
({RoadmapPlanet planet, double fraction, int dayInPlanet, int totalDays})
planetContextForDay(int day) {
  int start = 1;
  for (final RoadmapPlanet p in roadmapPlanets) {
    final int end = start + p.days - 1;
    if (day >= start && day <= end) {
      final int dayInPlanet = day - start + 1;
      return (
        planet: p,
        fraction: dayInPlanet / p.days,
        dayInPlanet: dayInPlanet,
        totalDays: p.days,
      );
    }
    start = end + 1;
  }
  // Past the end of the journey — the web falls through to the Milky Way at
  // full orbit, and so does this.
  final RoadmapPlanet last = roadmapPlanets.last;
  return (planet: last, fraction: 1, dayInPlanet: 1, totalDays: last.days);
}
