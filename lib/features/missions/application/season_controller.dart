import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../preferences/application/preferences_controller.dart';

part 'season_controller.g.dart';

/// Starting Season 2.
///
/// Day 66 used to be a dead end in the app: the Season Complete recap showed
/// the user's real numbers and then described three paths they could only
/// take on the web. `POST /season/advance` did not exist on the mobile API
/// until now.
@riverpod
class SeasonAdvanceController extends _$SeasonAdvanceController {
  /// True while a `POST /season/advance` is open.
  ///
  /// The in-flight flag belongs to the controller and not to the card that
  /// was tapped, because the Season Complete screen builds THREE path cards
  /// and advancing is one irreversible write for the whole account. When
  /// each card carried its own flag it disabled only itself, so "Maintenance
  /// Mode" stayed live while "Go Deeper" was still posting: two advances with
  /// different `choice` values in flight at once, and the user's entire
  /// Season 2 decided by whichever one the server happened to finish last.
  /// Every card reads this, so the first tap closes all three.
  ///
  /// Watching it also keeps this autoDispose provider alive for the length of
  /// the write — the cards used to only `read` the notifier, which left the
  /// element free to be disposed out from under an open request.
  @override
  bool build() => false;

  /// Starts Season 2 on [choice]. Returns true when the user was ALREADY on
  /// Season 2 — the server is idempotent, and "you are already there" is a
  /// different thing to tell someone than "done".
  ///
  /// Throws on failure so the caller can say nothing changed.
  Future<bool> advance(String choice, {String? targetRole}) async {
    // Defensive, and deliberately loud: the cards gate on [state] before they
    // call. Getting here means a call site skipped that gate, and a second
    // advance slipping through silently is the one outcome this controller
    // exists to prevent.
    if (state) {
      throw StateError('A season advance is already in flight.');
    }
    state = true;
    try {
      final response = await ref
          .read(dioClientProvider)
          .post<Map<String, dynamic>>(
            ApiPaths.seasonAdvance,
            data: <String, dynamic>{
              'choice': choice,
              'targetRole': ?targetRole,
            },
          );
      // The season lives on the preferences row, and the home screen branches
      // on it — without this the user starts Season 2 and keeps looking at
      // Season 1 until something else happens to refetch.
      ref.invalidate(preferencesControllerProvider);
      return response.data?['alreadyAdvanced'] == true;
    } finally {
      // The user can pop the page mid-write, which disposes this autoDispose
      // provider; writing `state` afterwards throws out of the `finally` and
      // would turn a season that DID start into "that didn't go through".
      if (ref.mounted) state = false;
    }
  }
}
