import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/data/connections_repositories.dart';
import 'package:plexaverse/features/home/domain/connections_repository.dart';

/// The mock flavour's connection count, held against the server it stands in
/// for (`lib/services/connections.service.ts` on the web).
///
/// The fake does not assert a growth figure; it runs [connectionGrowthOf] over
/// its rows. So the first group pins that function to the server's own test
/// cases (`__tests__/lib/connections-service.test.ts`, same NOW, same
/// readings), and the second pins that the fake keeps its rows the way the
/// server keeps them. A fixture that cannot show what the server would is
/// worse than none: it teaches the wrong thing confidently.
void main() {
  final DateTime now = DateTime.parse('2026-11-12T10:00:00.000Z');
  String daysBefore(int n) =>
      now.subtract(Duration(days: n)).toUtc().toIso8601String();
  ConnectionReading r(int count, int daysAgo) =>
      ConnectionReading(count: count, measuredAt: daysBefore(daysAgo));

  group("connectionGrowthOf is the server's arithmetic", () {
    test('is null with no readings', () {
      expect(connectionGrowthOf(<ConnectionReading>[], now: now), isNull);
    });

    test('is all zeros on a single reading', () {
      expect(
        connectionGrowthOf(<ConnectionReading>[r(400, 2)], now: now),
        ConnectionGrowth(
          week: 0,
          sinceFirst: 0,
          firstMeasuredAt: daysBefore(2),
          daysCovered: 0,
          readings: 1,
        ),
      );
    });

    test('measures the week against the latest reading a week old', () {
      final ConnectionGrowth g = connectionGrowthOf(<ConnectionReading>[
        r(300, 21),
        r(350, 10),
        r(370, 7), // exactly 7 days — counts as the baseline
        r(390, 3),
        r(410, 0),
      ], now: now)!;
      expect(g.week, 410 - 370);
      expect(g.sinceFirst, 110);
      expect(g.daysCovered, 21);
      expect(g.firstMeasuredAt, daysBefore(21));
      expect(g.readings, 5);
    });

    test('falls back to the first reading when none is a week old yet', () {
      // Out of order on purpose: the server sorts before it measures.
      final ConnectionGrowth g = connectionGrowthOf(<ConnectionReading>[
        r(410, 0),
        r(400, 4),
      ], now: now)!;
      expect(g.week, 10);
      expect(g.sinceFirst, 10);
      expect(g.daysCovered, 4);
    });

    test('has no week figure once the latest reading is a week old', () {
      final ConnectionGrowth g = connectionGrowthOf(<ConnectionReading>[
        r(400, 30),
        r(450, 20),
      ], now: now)!;
      // Nothing was measured this week — not "no change", not +50.
      expect(g.week, isNull);
      expect(g.sinceFirst, 50);
      expect(
        connectionGrowthOf(<ConnectionReading>[r(400, 7)], now: now)!.week,
        isNull,
      );
    });

    test('reports a drop as a negative change', () {
      final ConnectionGrowth g = connectionGrowthOf(<ConnectionReading>[
        r(500, 9),
        r(488, 1),
      ], now: now)!;
      expect(g.week, -12);
      expect(g.sinceFirst, -12);
    });

    test('drops a reading whose date does not parse, as the server does', () {
      final ConnectionGrowth g = connectionGrowthOf(<ConnectionReading>[
        r(400, 3),
        const ConnectionReading(count: 999, measuredAt: 'not a date'),
      ], now: now)!;
      expect(g.readings, 1);
      expect(g.sinceFirst, 0);
    });
  });

  group('the fake keeps its rows as the server does', () {
    setUp(FakeConnectionsRepository.reset);
    tearDown(FakeConnectionsRepository.reset);

    test(
      'reading is the newest row, history oldest first, growth computed',
      () async {
        final ConnectionSummary s = await FakeConnectionsRepository()
            .fetchSummary();

        expect(s.history, isNotEmpty);
        expect(s.reading, s.history.last);
        final List<DateTime> at = <DateTime>[
          for (final ConnectionReading h in s.history)
            DateTime.parse(h.measuredAt),
        ];
        for (int i = 1; i < at.length; i++) {
          expect(at[i].isAfter(at[i - 1]), isTrue, reason: 'oldest first');
        }
        expect(s.growth!.readings, s.history.length);
        expect(
          s.growth!.sinceFirst,
          s.history.last.count - s.history.first.count,
        );
      },
    );

    test(
      'the seeded count has lapsed, so the mock opens on the question',
      () async {
        // The state worth seeing in mock: asked, with last week's figure as the
        // placeholder — and a week figure the server would not give, since
        // nothing was measured this week.
        final ConnectionSummary s = await FakeConnectionsRepository()
            .fetchSummary();
        expect(s.reading!.isStale(), isTrue);
        expect(s.growth!.week, isNull);
      },
    );

    test('a save today makes a real week of growth', () async {
      final FakeConnectionsRepository repo = FakeConnectionsRepository();
      final ConnectionSummary before = await repo.fetchSummary();

      await repo.record(before.reading!.count + 12);
      final ConnectionSummary after = await repo.fetchSummary();

      expect(after.history, hasLength(before.history.length + 1));
      expect(after.reading!.isStale(), isFalse);
      // Baseline: the latest reading at or before a week ago — the seeded one.
      expect(after.growth!.week, 12);
      expect(after.growth!.readings, after.history.length);
    });

    test(
      'a second save the same day replaces the day, not adds to it',
      () async {
        final FakeConnectionsRepository repo = FakeConnectionsRepository();
        await repo.record(490);
        final int rows = (await repo.fetchSummary()).history.length;

        await repo.record(495);
        final ConnectionSummary s = await repo.fetchSummary();
        expect(s.history, hasLength(rows));
        expect(s.reading!.count, 495);
      },
    );

    test('a fresh repository sees what the last one wrote', () async {
      await FakeConnectionsRepository().record(777);
      final ConnectionSummary s = await FakeConnectionsRepository()
          .fetchSummary();
      expect(s.reading!.count, 777);
    });

    test("refuses what the server refuses, in the server's words", () async {
      final FakeConnectionsRepository repo = FakeConnectionsRepository();
      for (final int bad in <int>[-1, maxConnections + 1]) {
        await expectLater(
          repo.record(bad),
          throwsA(
            isA<ConnectionsInvalid>().having(
              (ConnectionsInvalid e) => e.message,
              'message',
              'Enter a whole number between 0 and 30,000.',
            ),
          ),
        );
      }
      await repo.record(0);
      await repo.record(maxConnections);
    });
  });

  group('parseConnectionCount is the web form’s rule', () {
    test('strips commas and whitespace, keeps 0..30,000', () {
      expect(parseConnectionCount('1,240'), 1240);
      expect(parseConnectionCount(' 480 '), 480);
      expect(parseConnectionCount('0'), 0);
      expect(parseConnectionCount('30,000'), 30000);
    });

    test('refuses empty, negative, fractional, oversized and words', () {
      for (final String bad in <String>[
        '',
        '   ',
        '-1',
        '1.5',
        '30001',
        'abc',
        '12k',
      ]) {
        expect(parseConnectionCount(bad), isNull, reason: '"$bad"');
      }
    });
  });

  group('a reading goes stale after a week', () {
    test('seven days is still fresh; a minute past is not', () {
      final ConnectionReading at = r(400, 7);
      expect(at.isStale(now: now), isFalse);
      expect(at.isStale(now: now.add(const Duration(minutes: 1))), isTrue);
    });

    test('an unreadable date is stale', () {
      expect(
        const ConnectionReading(count: 1, measuredAt: '').isStale(now: now),
        isTrue,
      );
    });
  });
}
