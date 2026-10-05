import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/domain/roadmap_planets.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';

/// `seasonOneFinished` decides whether a user is sent to the Season Complete
/// screen. It is a port of `isSeasonOneFinished` in lib/narrative-phases.ts.
///
/// ## The length is read, not written
///
/// These used to say 66, because the arc was 66 days. It is a thousand now,
/// and the mismatch was not cosmetic: `day > 66` meant every user past their
/// sixty-sixth day was shown the Season Complete screen 934 days early, while
/// the server still had them mid-Season-1 — so nothing on the backend agreed
/// with what the app was telling them.
///
/// So the boundary cases below are expressed against [roadmapTotalDays] rather
/// than a literal. A test that hard-codes the length cannot catch the length
/// being wrong; it can only pin whatever the code already does.
///
/// The off-by-one is still the part worth pinning: the roadmap is 1-indexed —
/// the start day IS day 1 — so the season ends strictly AFTER the last day.
void main() {
  UserPreferences at(int daysAgo, {int season = 1}) => UserPreferences(
    currentSeason: season,
    roadmapStartedAt: DateTime.now().subtract(Duration(days: daysAgo)),
  );

  test('the arc matches the web', () {
    // If this moves, the web moved it. `ROADMAP_TOTAL_DAYS` in
    // lib/roadmap-phases.ts is the source.
    expect(roadmapTotalDays, 1000);
  });

  test('the last day is still Season 1 — there is a day left', () {
    expect(at(roadmapTotalDays - 1).seasonOneFinished, isFalse);
  });

  test('the day after the last is finished', () {
    expect(at(roadmapTotalDays).seasonOneFinished, isTrue);
  });

  test('day 67 is NOT finished — the old boundary is gone', () {
    // The regression this file exists for. 66 days was the whole arc once;
    // now it is somewhere inside Earth, the third of twelve planets.
    expect(at(66).seasonOneFinished, isFalse);
    expect(at(200).seasonOneFinished, isFalse);
    expect(at(900).seasonOneFinished, isFalse);
  });

  test('a fresh roadmap is not finished', () {
    expect(at(0).seasonOneFinished, isFalse);
  });

  test('a user already on Season 2 is never sent back to the recap', () {
    // Otherwise choosing a path would bounce them straight to the screen
    // they just used, forever.
    expect(at(2000, season: 2).seasonOneFinished, isFalse);
  });

  test('no roadmap start means no season to finish', () {
    expect(const UserPreferences().seasonOneFinished, isFalse);
  });

  test('seasonOneFinished and isSeason2 are never both true', () {
    for (final int days in <int>[0, 30, 66, 365, 999, 1000, 1500]) {
      for (final int season in <int>[1, 2, 3]) {
        final UserPreferences p = at(days, season: season);
        expect(
          p.seasonOneFinished && p.isSeason2,
          isFalse,
          reason: 'day $days season $season would route two ways at once',
        );
      }
    }
  });
}
