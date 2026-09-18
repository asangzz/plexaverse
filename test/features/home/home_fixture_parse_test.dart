import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/data/mock_home_repository.dart';
import 'package:plexaverse/features/home/domain/home_repository.dart';

/// Guards the home mock flavour: the bundled dashboard fixture must parse
/// cleanly through the (regenerated, camelCase) [DashboardSummary.fromJson]
/// and through the [MockHomeRepository] that the fake backend uses.
///
/// After the `field_rename: snake -> none` migration the fixture keys must be
/// the Dart field names verbatim (there are no `@JsonKey` overrides in the
/// home models), so any lingering snake_case key would silently fall back to
/// the model defaults instead of the fixture's sample values — these
/// assertions on real values catch that.
void main() {
  // Gives the mock repo path access to rootBundle (declared assets).
  TestWidgetsFlutterBinding.ensureInitialized();

  const fixturePath = 'assets/mock/home/dashboard.json';

  Map<String, dynamic> readFixtureFromDisk() {
    final raw = File(fixturePath).readAsStringSync();
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  group('dashboard.json fixture', () {
    test('parses through DashboardSummary.fromJson with expected values', () {
      final summary = DashboardSummary.fromJson(readFixtureFromDisk());

      // Top-level KPI fields (would default to 0 / "+0%" on a key mismatch).
      expect(summary.totalImpressions, 48200);
      expect(summary.totalEngagements, 3120);
      expect(summary.totalFollowers, 2341);
      expect(summary.scheduledCount, 3);
      expect(summary.impressionsDelta, '+18%');
      expect(summary.engagementsDelta, '+12%');
      expect(summary.followersDelta, '+5%');
      expect(summary.isFirstTime, isFalse);

      // Gamification hero (nested object).
      expect(summary.stats.streakDays, 12);
      expect(summary.stats.weeklyXp, 1450);
      expect(summary.stats.weeklyXpGoal, 2000);
      expect(summary.stats.level, 7);
      expect(summary.stats.levelTitle, 'Creator');
      expect(summary.stats.weeklyXpProgress, closeTo(0.725, 1e-9));

      // Optional mission banner.
      expect(summary.mission, isNotNull);
      expect(summary.mission!.title, 'Get 1,000 impressions on a post');
      expect(summary.mission!.statusLabel, 'Active');

      // Recent-posts strip: count, ids, enum status, and metrics flags.
      expect(summary.recentPosts, hasLength(5));
      final first = summary.recentPosts.first;
      expect(first.id, 'post_1042');
      expect(first.status, DashboardPostStatus.published);
      expect(first.impressions, 18400);
      expect(first.engagements, 1260);
      expect(first.hasMetrics, isTrue);
      expect(
        summary.recentPosts.map((p) => p.status),
        containsAllInOrder(<DashboardPostStatus>[
          DashboardPostStatus.published,
          DashboardPostStatus.published,
          DashboardPostStatus.scheduled,
          DashboardPostStatus.published,
          DashboardPostStatus.draft,
        ]),
      );
    });

    test(
      'MockHomeRepository.fetchDashboard() loads and parses the bundled asset',
      () async {
        // Sanity-check that the declared asset resolves in the test bundle;
        // this is the exact path MockApi.loadObject reads at runtime.
        final bundled = await rootBundle.loadString(fixturePath);
        expect(bundled, isNotEmpty);

        const repo = MockHomeRepository();
        final summary = await repo.fetchDashboard();

        expect(summary.totalImpressions, 48200);
        expect(summary.recentPosts, hasLength(5));
        expect(summary.stats.levelTitle, 'Creator');
      },
    );

    test('offline mock throws DashboardUnavailable', () async {
      final repo = MockHomeRepository(isOffline: () => true);
      expect(repo.fetchDashboard(), throwsA(isA<DashboardUnavailable>()));
    });
  });
}
