// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_winners_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(FollowWinnersActions)
final followWinnersActionsProvider = FollowWinnersActionsProvider._();

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
final class FollowWinnersActionsProvider
    extends $NotifierProvider<FollowWinnersActions, FollowWinnerBusy> {
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
  FollowWinnersActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followWinnersActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$followWinnersActionsHash();

  @$internal
  @override
  FollowWinnersActions create() => FollowWinnersActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FollowWinnerBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FollowWinnerBusy>(value),
    );
  }
}

String _$followWinnersActionsHash() =>
    r'c9c4c1320b926b2ff508e33c571c814539429935';

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

abstract class _$FollowWinnersActions extends $Notifier<FollowWinnerBusy> {
  FollowWinnerBusy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FollowWinnerBusy, FollowWinnerBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FollowWinnerBusy, FollowWinnerBusy>,
              FollowWinnerBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
