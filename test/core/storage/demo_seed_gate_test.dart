import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/storage/app_database.dart';

/// The demo fixtures must never reach a real user's database.
///
/// `beforeOpen` used to seed on `details.wasCreated` alone — no flavor, no
/// `kReleaseMode`, no `useFakeBackend` — so a dev/staging/prod install wrote a
/// 40-day streak, level 8, five invented LinkedIn posts and 16,200 impressions
/// into the user's own encrypted database before they had done anything. The
/// rows happened not to be rendered, because both readers were unrouted legacy
/// code, which is luck rather than a safeguard.
///
/// These tests are the safeguard. The first one is the one that matters: if it
/// ever goes green-to-red, someone has un-gated the seed.
void main() {
  test('a real-flavor database starts EMPTY — no demo rows', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Force beforeOpen to run.
    await db.customSelect('SELECT 1').get();

    expect(await db.userStatsDao.getStats(), isNull,
        reason: 'a new real-backend user has no stats until the server says so');
    expect(await db.userStatsDao.getMissions(), isEmpty,
        reason: 'missions must not arrive pre-completed');
    // countAll() always returns the four status keys, so assert on the total.
    final counts = await db.postsDao.countAll();
    expect(counts.values.fold<int>(0, (a, b) => a + b), 0,
        reason: 'invented posts must never look like the user\'s own history');
  });

  test('the mock flavor still gets its demo data', () async {
    // Gated, not deleted: the fixtures are what make the mock flavor a usable
    // demo. Removing them would trade one bug for a broken demo build.
    final db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      seedDemoData: true,
    );
    addTearDown(db.close);

    await db.customSelect('SELECT 1').get();

    final stats = await db.userStatsDao.getStats();
    expect(stats, isNotNull);
    expect(stats!.xp, 1440);
    expect(stats.level, 8);
    expect(await db.userStatsDao.getMissions(), isNotEmpty);
    final counts = await db.postsDao.countAll();
    expect(counts.values.fold<int>(0, (a, b) => a + b), greaterThan(0));
  });

  test('seeding is off by default, so a new construction site cannot leak it', () async {
    // The flag defaults to false on BOTH constructors. Someone adding a third
    // call site gets the safe behaviour without having to know this history.
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    expect(db.seedDemoData, isFalse);
  });

  test('an explicitly written row survives — the gate blocks seeding, not writes',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.userStatsDao.upsertStats(
      UserStatsTableCompanion(
        id: const Value(1),
        streakDays: const Value(3),
        xp: const Value(120),
        level: const Value(1),
        levelTitle: const Value('Starter'),
      ),
    );

    final stats = await db.userStatsDao.getStats();
    expect(stats, isNotNull);
    expect(stats!.xp, 120, reason: 'real data must still write through');
  });
}
