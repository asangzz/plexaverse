import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../settings/application/settings_controllers.dart';
import '../domain/levels_words.dart';

part 'name_on_board_controllers.g.dart';

/// Where "Show my name to other learners" stands — the switch's busy state
/// and the line under it.
class NameOnBoardSave {
  const NameOnBoardSave({this.saving = false, this.error});

  final bool saving;

  /// Why the last switch did not go through. Null while nothing went wrong.
  final String? error;
}

/// The leaderboard-name consent (`contest_leaderboard`), switched on the
/// levels page (owner, 24 Nov 2026). Every learner is entered automatically
/// and ANONYMOUSLY — shown to the others as "Learner" — and this is how they
/// choose to be named instead. Recorded `in_context`, through the same ledger
/// Settings → Your data lists it in, so the two can never disagree.
@riverpod
class NameOnBoardActions extends _$NameOnBoardActions {
  @override
  NameOnBoardSave build() => const NameOnBoardSave();

  /// [on] is exactly what the learner did with the switch.
  Future<void> set({required bool on}) async {
    if (state.saving) return;
    state = const NameOnBoardSave(saving: true);
    final String? failure = await ref
        .read(consentControllerProvider.notifier)
        .set(kNameTogglePurpose, on, inContext: true);
    if (!ref.mounted) return;
    state = NameOnBoardSave(error: failure);
  }
}
