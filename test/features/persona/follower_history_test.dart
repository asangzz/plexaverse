import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/persona/domain/persona_entities.dart';

/// The follower series behind the checkpoint.
///
/// `GET /persona/reach` answers "where am I now". A checkpoint raises a
/// different question — "am I moving" — and until the history route existed
/// the phone could WRITE follower counts and never read back more than the
/// latest one, so a growth chart was impossible on mobile while the web had
/// one.
///
/// The rule these tests mostly exist to protect: the series is returned and
/// drawn EXACTLY as measured. Never resampled onto an even daily grid, never
/// splined between points. This is the one number in the product that can only
/// come from the person looking at the screen, and a chart that quietly fills
/// in the days between is fabricating it.
void main() {
  FollowerReading at(int daysAgo, int count) => FollowerReading(
    count: count,
    measuredAt: DateTime.utc(
      2026,
      10,
      6,
    ).subtract(Duration(days: daysAgo)).toIso8601String(),
  );

  group('points', () {
    test('parses and orders oldest first', () {
      final FollowerHistory h = FollowerHistory(
        readings: <FollowerReading>[at(30, 1000), at(1, 1240), at(60, 820)],
      );
      expect(
        h.points.map((({DateTime at, double value}) p) => p.value).toList(),
        <double>[820, 1000, 1240],
      );
    });

    test('keeps the real gaps rather than evening them out', () {
      // 34 days then 29 then 1. An index-spaced chart would draw these three
      // intervals identically and claim a shape nothing measured.
      final FollowerHistory h = FollowerHistory(
        readings: <FollowerReading>[at(64, 820), at(30, 1000), at(1, 1240)],
      );
      final List<({DateTime at, double value})> p = h.points;

      expect(p[1].at.difference(p[0].at).inDays, 34);
      expect(p[2].at.difference(p[1].at).inDays, 29);
      // Three readings in, three out — nothing invented between them.
      expect(p, hasLength(3));
    });

    test('drops a reading whose stamp cannot be read, without throwing', () {
      // A malformed value from the server should cost the chart one point,
      // not take the roadmap down.
      final FollowerHistory h = FollowerHistory(
        readings: <FollowerReading>[
          at(30, 1000),
          const FollowerReading(count: 1100, measuredAt: 'soon'),
          at(1, 1240),
        ],
      );
      expect(h.points, hasLength(2));
    });
  });

  group('isPlottable', () {
    test('needs two points — one is a dot, not a line', () {
      expect(const FollowerHistory().isPlottable, isFalse);
      expect(
        FollowerHistory(readings: <FollowerReading>[at(1, 1240)]).isPlottable,
        isFalse,
      );
      expect(
        FollowerHistory(
          readings: <FollowerReading>[at(30, 1000), at(1, 1240)],
        ).isPlottable,
        isTrue,
      );
    });

    test('two readings with unreadable stamps are not plottable', () {
      // isPlottable counts raw readings; points is what actually gets drawn.
      // The chart guards on points.length too, which this pins.
      final FollowerHistory h = FollowerHistory(
        readings: <FollowerReading>[
          const FollowerReading(count: 1, measuredAt: 'x'),
          const FollowerReading(count: 2, measuredAt: 'y'),
        ],
      );
      expect(h.points.length, lessThan(2));
    });
  });

  group('growth', () {
    test('reads the server kinds rather than re-deriving them', () {
      // Derived server-side on purpose: "is a fortnight long enough to quote a
      // rate over" is a product decision, and two clients deciding it
      // separately is how they come to disagree about one series.
      expect(const FollowerGrowth().asKind, FollowerGrowthKind.none);
      expect(
        const FollowerGrowth(kind: 'single').asKind,
        FollowerGrowthKind.single,
      );
      expect(
        const FollowerGrowth(kind: 'tooSoon').asKind,
        FollowerGrowthKind.tooSoon,
      );
      expect(
        const FollowerGrowth(kind: 'rate').asKind,
        FollowerGrowthKind.rate,
      );
    });

    test('an unknown kind degrades to none, not to a crash', () {
      // A server that grows a fifth kind must not take the strip down on an
      // app version that predates it.
      expect(
        const FollowerGrowth(kind: 'exponential').asKind,
        FollowerGrowthKind.none,
      );
    });

    test('carries a negative rate — people lose followers', () {
      // A chart that cannot go down is a chart nobody should trust on the way
      // up either.
      const FollowerGrowth g = FollowerGrowth(
        kind: 'rate',
        days: 40,
        gained: -60,
        perDay: -1.5,
        perMonth: -45,
      );
      expect(g.asKind, FollowerGrowthKind.rate);
      expect(g.perMonth, -45);
    });
  });

  group('the wire shape', () {
    test('parses what the route sends', () {
      final FollowerHistory h = FollowerHistory.fromJson(<String, dynamic>{
        'readings': <Map<String, dynamic>>[
          {'count': 1000, 'measuredAt': '2026-09-06T09:00:00.000Z'},
          {'count': 1240, 'measuredAt': '2026-10-05T09:00:00.000Z'},
        ],
        'growth': <String, dynamic>{
          'kind': 'rate',
          'days': 29,
          'gained': 240,
          'perDay': 8.28,
          'perMonth': 248,
        },
      });

      expect(h.readings, hasLength(2));
      expect(h.growth.asKind, FollowerGrowthKind.rate);
      expect(h.growth.perMonth, 248);
      expect(h.isPlottable, isTrue);
    });

    test('an empty history is a valid answer, not an error', () {
      // What a new user has, and what a failed read degrades to. Both mean
      // "ask them", which is a prompt rather than a broken screen.
      final FollowerHistory h = FollowerHistory.fromJson(<String, dynamic>{
        'readings': <Map<String, dynamic>>[],
        'growth': <String, dynamic>{'kind': 'none'},
      });
      expect(h.readings, isEmpty);
      expect(h.isPlottable, isFalse);
      expect(h.growth.asKind, FollowerGrowthKind.none);
    });

    test('missing keys fall back rather than throwing', () {
      final FollowerHistory h = FollowerHistory.fromJson(<String, dynamic>{});
      expect(h.readings, isEmpty);
      expect(h.growth.asKind, FollowerGrowthKind.none);
    });
  });
}
