import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/home/domain/roadmap_planets.dart';
import 'package:plexaverse/features/preferences/domain/user_preferences.dart';

/// `journeyFinished` decides whether home offers the journey-complete screen.
/// It replaced `isSeason2` / `seasonOneFinished`: the product has no seasons,
/// only a 1000-day journey whose day 1000 is a finish line.
///
/// Two inputs, because the server only stamps `journeyCompletedAt` from the
/// auto-post chain or a web dashboard visit. A user with auto-post off who
/// only uses the app would never be stamped, so the roadmap day — counted the
/// way the web's `getRoadmapDay` counts it — is the fallback.
void main() {
  /// A user whose journey started [daysAgo] days ago. Day 1 is the start day,
  /// so `daysAgo: 999` is day 1000.
  UserPreferences startedAgo(int daysAgo, {int journey = 1}) =>
      UserPreferences.fromJson(<String, dynamic>{
        'currentSeason': journey,
        'roadmapStartedAt': DateTime.now()
            .subtract(Duration(days: daysAgo))
            .toIso8601String(),
      });

  test('the arc matches the web', () {
    // `ROADMAP_TOTAL_DAYS` in lib/roadmap-phases.ts is the source.
    expect(roadmapTotalDays, 1000);
  });

  test('day 999 is still running', () {
    expect(startedAgo(roadmapTotalDays - 2).journeyFinished, isFalse);
  });

  test('day 1000 is the finish line', () {
    final UserPreferences p = startedAgo(roadmapTotalDays - 1);
    expect(p.journeyDay, roadmapTotalDays);
    expect(p.journeyFinished, isTrue);
  });

  test('the day is capped at 1000, like the web', () {
    expect(startedAgo(5000).journeyDay, roadmapTotalDays);
  });

  test('no start date is day 1 and never finished', () {
    expect(const UserPreferences().journeyDay, 1);
    expect(const UserPreferences().journeyFinished, isFalse);
  });

  test('the server stamp finishes the journey whatever the day says', () {
    // Day 12 by the clock, but the server says it is done (a clock skew, or
    // an admin finishing it) — the server's answer wins.
    final UserPreferences p = UserPreferences.fromJson(<String, dynamic>{
      'roadmapStartedAt': DateTime.now()
          .subtract(const Duration(days: 11))
          .toIso8601String(),
      'journeyCompletedAt': '2026-11-09T18:30:00.000Z',
    });
    expect(p.journeyCompletedAt, DateTime.utc(2026, 11, 9, 18, 30));
    expect(p.journeyFinished, isTrue);
  });

  test('a null or malformed stamp is "not finished", not a crash', () {
    expect(
      UserPreferences.fromJson(<String, dynamic>{
        'journeyCompletedAt': null,
      }).journeyCompletedAt,
      isNull,
    );
    expect(
      UserPreferences.fromJson(<String, dynamic>{
        'journeyCompletedAt': 'not a date',
      }).journeyCompletedAt,
      isNull,
    );
  });

  test('a new journey restarts the clock — journey 2 at day 3 is running', () {
    // The server resets roadmapStartedAt and clears journeyCompletedAt when a
    // journey starts. The journey number alone must not mean "finished" (it
    // used to mean "Season 2", a different home screen).
    final UserPreferences p = startedAgo(2, journey: 2);
    expect(p.journeyNumber, 2);
    expect(p.journeyDay, 3);
    expect(p.journeyFinished, isFalse);
  });

  test('the journey number is never below 1', () {
    expect(
      UserPreferences.fromJson(<String, dynamic>{
        'currentSeason': 0,
      }).journeyNumber,
      1,
    );
  });

  test('fromJson still round-trips the rest of the row', () {
    // Guards the expression-bodied factory: freezed only generates JSON
    // support when fromJson is an `=>` call, and losing it would drop every
    // field below silently.
    final UserPreferences p = UserPreferences.fromJson(<String, dynamic>{
      'exists': true,
      'onboardingCompleted': true,
      'targetRole': 'Head of Product',
    });
    expect(p.exists, isTrue);
    expect(p.targetRole, 'Head of Product');
    expect(p.toJson()['targetRole'], 'Head of Product');
  });
}
