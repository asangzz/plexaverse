import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';

/// `seasonOneFinished` decides whether a user is sent to the Season Complete
/// screen. It is a port of `isSeasonOneFinished` in lib/narrative-phases.ts,
/// and the off-by-one is the part worth pinning: the roadmap is 1-indexed —
/// the start day IS day 1 — so the season ends strictly AFTER day 66. A
/// day-66 user still has a day left.
void main() {
  UserPreferences at(int daysAgo, {int season = 1}) => UserPreferences(
        currentSeason: season,
        roadmapStartedAt: DateTime.now().subtract(Duration(days: daysAgo)),
      );

  test('day 66 is still Season 1 — there is a day left', () {
    expect(at(65).seasonOneFinished, isFalse);
  });

  test('day 67 is finished', () {
    expect(at(66).seasonOneFinished, isTrue);
  });

  test('a fresh roadmap is not finished', () {
    expect(at(0).seasonOneFinished, isFalse);
  });

  test('a user already on Season 2 is never sent back to the recap', () {
    // Otherwise choosing a path would bounce them straight to the screen
    // they just used, forever.
    expect(at(200, season: 2).seasonOneFinished, isFalse);
  });

  test('no roadmap start means no season to finish', () {
    expect(const UserPreferences().seasonOneFinished, isFalse);
  });

  test('seasonOneFinished and isSeason2 are never both true', () {
    for (final int days in <int>[0, 30, 65, 66, 100, 400]) {
      for (final int season in <int>[1, 2, 3]) {
        final UserPreferences p = at(days, season: season);
        expect(p.seasonOneFinished && p.isSeason2, isFalse,
            reason: 'day $days season $season would route two ways at once');
      }
    }
  });
}
