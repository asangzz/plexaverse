import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/domain/roadmap_planets.dart';
import 'package:plexaverse/features/persona/domain/persona_entities.dart';

void main() {
  group('FollowerReading staleness', () {
    final DateTime now = DateTime.utc(2026, 10, 6, 12);
    FollowerReading at(Duration ago) => FollowerReading(
      count: 1240,
      measuredAt: now.subtract(ago).toIso8601String(),
    );

    test('a fresh reading is not stale', () {
      expect(at(const Duration(days: 1)).isStale(now: now), isFalse);
      expect(at(const Duration(days: 29)).isStale(now: now), isFalse);
    });

    test('goes stale after thirty days, matching the web', () {
      // FOLLOWER_STALE_DAYS. About how long a figure stays useful against a
      // checkpoint a quarter away, and long enough that answering never feels
      // like a chore.
      expect(at(const Duration(days: 30)).isStale(now: now), isFalse);
      expect(at(const Duration(days: 31)).isStale(now: now), isTrue);
      expect(at(const Duration(days: 400)).isStale(now: now), isTrue);
    });

    test('an unparseable or empty stamp is stale, not fresh', () {
      // Fail toward asking. Treating a stamp we cannot read as fresh would
      // silently stop the roadmap ever asking again, and the checkpoint would
      // sit on a number from an unknown date for ever.
      expect(const FollowerReading(count: 1240).isStale(now: now), isTrue);
      expect(
        const FollowerReading(count: 1240, measuredAt: 'soon').isStale(now: now),
        isTrue,
      );
    });

    test('parses the wire shape', () {
      final FollowerReading r = FollowerReading.fromJson(<String, dynamic>{
        'count': 1240,
        'measuredAt': '2026-10-06T09:00:00.000Z',
      });
      expect(r.count, 1240);
      expect(r.measuredAt, '2026-10-06T09:00:00.000Z');
    });
  });

  group('the phase checkpoints', () {
    test('match the web, which they did not', () {
      // These read 1,000 and 10,000 against the web's 3,000 and 15,000 — a
      // divergence that cost nothing while followerTarget was declared and
      // read by nobody, and became four wrong numbers on screen the moment a
      // checkpoint surface existed.
      expect(
        roadmapPhases.map((RoadmapPhase p) => p.followerTarget),
        <int>[3000, 15000, 50000, 100000],
      );
    });

    test('rise across the arc', () {
      // A checkpoint that went down would mean the plan asks for fewer
      // followers later, which is not a thing the product claims anywhere.
      for (int i = 1; i < roadmapPhases.length; i++) {
        expect(
          roadmapPhases[i].followerTarget,
          greaterThan(roadmapPhases[i - 1].followerTarget),
        );
      }
    });

    test('phaseForDay picks the phase whose target is being worked toward', () {
      expect(phaseForDay(1).followerTarget, 3000);
      expect(phaseForDay(90).followerTarget, 3000);
      expect(phaseForDay(91).followerTarget, 15000);
      expect(phaseForDay(365).followerTarget, 15000);
      expect(phaseForDay(366).followerTarget, 50000);
      expect(phaseForDay(731).followerTarget, 100000);
    });

    test('a day past the arc still has a phase rather than throwing', () {
      // Season 2 users are past day 1000, and the checkpoint strip renders on
      // their roadmap too.
      expect(phaseForDay(99999).followerTarget, 100000);
    });
  });
}
