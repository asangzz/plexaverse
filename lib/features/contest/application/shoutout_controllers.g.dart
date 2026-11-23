// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoutout_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `PUT /contest/shoutout`, with its busy and error state off the widget —
/// the web's `useSetContestShoutout`.
///
/// A success writes the server's answer into the choice
/// ([ContestShoutout.settle]) and re-reads the cards, so switching off takes
/// the learner off every card they were on at once.

@ProviderFor(ContestShoutoutActions)
final contestShoutoutActionsProvider = ContestShoutoutActionsProvider._();

/// `PUT /contest/shoutout`, with its busy and error state off the widget —
/// the web's `useSetContestShoutout`.
///
/// A success writes the server's answer into the choice
/// ([ContestShoutout.settle]) and re-reads the cards, so switching off takes
/// the learner off every card they were on at once.
final class ContestShoutoutActionsProvider
    extends $NotifierProvider<ContestShoutoutActions, ShoutoutSave> {
  /// `PUT /contest/shoutout`, with its busy and error state off the widget —
  /// the web's `useSetContestShoutout`.
  ///
  /// A success writes the server's answer into the choice
  /// ([ContestShoutout.settle]) and re-reads the cards, so switching off takes
  /// the learner off every card they were on at once.
  ContestShoutoutActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestShoutoutActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestShoutoutActionsHash();

  @$internal
  @override
  ContestShoutoutActions create() => ContestShoutoutActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoutoutSave value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoutoutSave>(value),
    );
  }
}

String _$contestShoutoutActionsHash() =>
    r'556b2228a5fdbca0d9b6a452288683a6576ff95c';

/// `PUT /contest/shoutout`, with its busy and error state off the widget —
/// the web's `useSetContestShoutout`.
///
/// A success writes the server's answer into the choice
/// ([ContestShoutout.settle]) and re-reads the cards, so switching off takes
/// the learner off every card they were on at once.

abstract class _$ContestShoutoutActions extends $Notifier<ShoutoutSave> {
  ShoutoutSave build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ShoutoutSave, ShoutoutSave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShoutoutSave, ShoutoutSave>,
              ShoutoutSave,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
