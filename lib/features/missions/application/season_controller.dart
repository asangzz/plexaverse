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
  @override
  void build() {}

  /// Starts Season 2 on [choice]. Returns true when the user was ALREADY on
  /// Season 2 — the server is idempotent, and "you are already there" is a
  /// different thing to tell someone than "done".
  ///
  /// Throws on failure so the caller can say nothing changed.
  Future<bool> advance(String choice, {String? targetRole}) async {
    final response = await ref.read(dioClientProvider).post<Map<String, dynamic>>(
      ApiPaths.seasonAdvance,
      data: <String, dynamic>{'choice': choice, 'targetRole': ?targetRole},
    );
    // The season lives on the preferences row, and the home screen branches
    // on it — without this the user starts Season 2 and keeps looking at
    // Season 1 until something else happens to refetch.
    ref.invalidate(preferencesControllerProvider);
    return response.data?['alreadyAdvanced'] == true;
  }
}
