import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/domain/roadmap_planets.dart';
import 'package:plexaverse/features/home/presentation/widgets/planet_node.dart';

/// The drawing table has to cover the domain table.
///
/// ## What this exists to stop happening again
///
/// `planetVisuals` was ported when the arc was 66 days and stopped at Neptune,
/// so nebula, quasar and nova were left out on purpose — the comment above the
/// map said as much. The 1000-day rebuild made all twelve planets reachable
/// and this map was not revisited.
///
/// Nothing broke, which is the whole problem. Both lookup sites ended in
/// `?? planetVisuals['uranus']!`, so from day 601 onwards the roadmap drew
/// Uranus's cyan sphere under the names NEBULA, QUASAR and NOVA — a plausible
/// enough screen that it took a user report to find. A fallback that returns
/// another real planet cannot fail visibly; only a test can.
///
/// So this asserts coverage, not pixels. It does not pin gradients or halos:
/// those are a port of `PLANET_GRADIENT` / `PLANET_SHADOWS` in
/// components/automate/GamifiedRoadmap.tsx and are allowed to be re-tuned. The
/// invariant that must never bend is that every planet the timeline can reach
/// has its OWN entry.
void main() {
  test('every roadmap planet has its own drawing spec', () {
    final List<String> missing = <String>[
      for (final RoadmapPlanet p in roadmapPlanets)
        if (!planetVisuals.containsKey(p.key)) p.key,
    ];

    expect(
      missing,
      isEmpty,
      reason:
          'These planet keys have no PlanetVisual, so planetVisual() falls back '
          'to Uranus and they render as the wrong planet: $missing',
    );
  });

  test('no two planets share a drawing spec', () {
    // Catches the other way of "fixing" a missing key: pointing the new key at
    // an existing entry. Identical spheres under different names is the same
    // bug with the lookup table rearranged.
    final Map<String, List<String>> byIdentity = <String, List<String>>{};
    for (final RoadmapPlanet p in roadmapPlanets) {
      final PlanetVisual v = planetVisual(p.key);
      byIdentity
          .putIfAbsent(identityHashCode(v).toString(), () => <String>[])
          .add(p.key);
    }

    final Iterable<List<String>> shared = byIdentity.values.where(
      (List<String> keys) => keys.length > 1,
    );
    expect(
      shared,
      isEmpty,
      reason: 'Planets sharing one PlanetVisual draw identically: $shared',
    );
  });

  test('the drawing table has no keys the roadmap cannot reach', () {
    // The opposite drift: a planet renamed in roadmap_planets.dart leaves a
    // stale visual behind and a live key with none, which the first test would
    // catch — but a stale key on its own is dead weight worth deleting.
    final Set<String> live = <String>{
      for (final RoadmapPlanet p in roadmapPlanets) p.key,
    };
    expect(planetVisuals.keys.toSet().difference(live), isEmpty);
  });

  group('the arc the timeline walks', () {
    // _PlanetOverlay derives each segment by ACCUMULATING planet.days from day
    // 1 rather than reading startDay/endDay. That is only equivalent while the
    // table is gapless and starts at 1. It is today; this pins it, because the
    // failure if it stops being true is every planet after the gap drawn
    // against the wrong rows.
    test('is contiguous from day 1 with no gaps or overlaps', () {
      int expected = 1;
      for (final RoadmapPlanet p in roadmapPlanets) {
        expect(
          p.startDay,
          expected,
          reason: '${p.key} starts at ${p.startDay}, expected $expected',
        );
        expect(p.endDay, greaterThanOrEqualTo(p.startDay));
        expected = p.endDay + 1;
      }
      expect(expected - 1, roadmapTotalDays);
    });

    test('every planet belongs to a phase that contains it', () {
      for (final RoadmapPlanet p in roadmapPlanets) {
        expect(phaseForDay(p.startDay).key, p.phaseKey, reason: p.key);
        expect(phaseForDay(p.endDay).key, p.phaseKey, reason: p.key);
      }
    });

    test('planetContextForDay returns the named planet, day by day', () {
      // One probe per planet at each edge and mid-point. Day 601 is the first
      // day the shipped bug was visible.
      for (final RoadmapPlanet p in roadmapPlanets) {
        for (final int day in <int>[
          p.startDay,
          p.startDay + (p.days ~/ 2),
          p.endDay,
        ]) {
          expect(planetContextForDay(day).planet.key, p.key, reason: 'day $day');
        }
      }
      expect(planetContextForDay(601).planet.key, 'nebula');
      expect(planetContextForDay(731).planet.key, 'quasar');
      expect(planetContextForDay(821).planet.key, 'nova');
    });
  });
}
