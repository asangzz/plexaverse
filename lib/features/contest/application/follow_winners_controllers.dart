import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../profile/data/profile_repositories.dart';
import '../../profile/domain/public_profile.dart';
import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'follow_winners_controllers.g.dart';

/// Where a step of "Follow last round's top learners" stands — one top
/// learner at a time, since every card has its own two buttons.
class FollowWinnerBusy {
  const FollowWinnerBusy({this.handle, this.step, this.errorFor, this.error});

  /// The top learner whose step is in flight, and which step.
  final String? handle;
  final FollowWinnerStep? step;

  /// The top learner the last refusal was about, and its sentence.
  final String? errorFor;
  final String? error;

  bool get busy => handle != null;
}

/// The follow level's two steps, with their busy and error state off the
/// widget (owner, 24 Nov 2026; the web's `useFollowWinnerStep` and
/// `useToggleFollow`).
///
/// ## Step 1 is the learner's word
///
/// "Follow on LinkedIn" opens their LinkedIn profile in the learner's own
/// app, and the TAP is recorded: LinkedIn gives no app a way to see who
/// follows whom, so the server takes the tap, as it takes the connect
/// level's Finish. Nothing is fetched from LinkedIn, and nothing is done
/// there for anyone.
///
/// ## Step 2 is not
///
/// "Follow on Plexaverse" is a real follow of their public profile
/// (`POST /profile/follow`), and only then the level is asked to re-check —
/// the server believes the follow row, never the app.
///
/// Both done → the level's XP for that top learner, once this round, paid by
/// whichever step lands second. A success keeps the server's answer as the
/// level and re-reads the standing the payment moved.
@riverpod
class FollowWinnersActions extends _$FollowWinnersActions {
  @override
  FollowWinnerBusy build() => const FollowWinnerBusy();

  /// Step 1: "Follow on LinkedIn" was tapped (the screen opens the profile).
  Future<bool> tappedLinkedIn(String handle) =>
      _step(handle, FollowWinnerStep.linkedin, () async {});

  /// Step 2: follow them on Plexaverse, then have the level re-check it.
  Future<bool> followOnPlexaverse(String handle) => _step(
    handle,
    FollowWinnerStep.plexaverse,
    () => ref.read(profileRepositoryProvider).follow(handle),
  );

  Future<bool> _step(
    String handle,
    FollowWinnerStep step,
    Future<void> Function() before,
  ) async {
    if (state.busy) return false;
    state = FollowWinnerBusy(handle: handle, step: step);
    try {
      await before();
      final FollowWinnerStepResult result = await ref
          .read(contestRepositoryProvider)
          .recordFollowWinnerStep(handle: handle, step: step);
      if (!ref.mounted) return false;
      state = const FollowWinnerBusy();
      ref.read(followWinnersProvider.notifier).settle(result.view);
      // What a payment moves: the XP, the path's node, the board. The
      // consistency meter counts this level on neither side, but the path it
      // reads changed.
      ref.invalidate(contestOverviewProvider);
      ref.invalidate(contestPathProvider);
      ref.invalidate(contestBoardProvider);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = FollowWinnerBusy(
        errorFor: handle,
        error: switch (e) {
          ProfileFailure() => e.message,
          _ => contestMessage(e),
        },
      );
      // A refusal's cause is learnt by re-reading: the level may have moved
      // (a top learner withdrew, the day turned over).
      ref.invalidate(followWinnersProvider);
      return false;
    }
  }
}
