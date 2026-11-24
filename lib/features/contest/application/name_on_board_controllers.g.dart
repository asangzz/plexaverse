// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_on_board_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The leaderboard-name consent (`contest_leaderboard`), switched on the
/// levels page (owner, 24 Nov 2026). Every learner is entered automatically
/// and ANONYMOUSLY — shown to the others as "Learner" — and this is how they
/// choose to be named instead. Recorded `in_context`, through the same ledger
/// Settings → Your data lists it in, so the two can never disagree.

@ProviderFor(NameOnBoardActions)
final nameOnBoardActionsProvider = NameOnBoardActionsProvider._();

/// The leaderboard-name consent (`contest_leaderboard`), switched on the
/// levels page (owner, 24 Nov 2026). Every learner is entered automatically
/// and ANONYMOUSLY — shown to the others as "Learner" — and this is how they
/// choose to be named instead. Recorded `in_context`, through the same ledger
/// Settings → Your data lists it in, so the two can never disagree.
final class NameOnBoardActionsProvider
    extends $NotifierProvider<NameOnBoardActions, NameOnBoardSave> {
  /// The leaderboard-name consent (`contest_leaderboard`), switched on the
  /// levels page (owner, 24 Nov 2026). Every learner is entered automatically
  /// and ANONYMOUSLY — shown to the others as "Learner" — and this is how they
  /// choose to be named instead. Recorded `in_context`, through the same ledger
  /// Settings → Your data lists it in, so the two can never disagree.
  NameOnBoardActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nameOnBoardActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nameOnBoardActionsHash();

  @$internal
  @override
  NameOnBoardActions create() => NameOnBoardActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NameOnBoardSave value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NameOnBoardSave>(value),
    );
  }
}

String _$nameOnBoardActionsHash() =>
    r'fa28d156af51d515fef15fff7e167d377caf9f13';

/// The leaderboard-name consent (`contest_leaderboard`), switched on the
/// levels page (owner, 24 Nov 2026). Every learner is entered automatically
/// and ANONYMOUSLY — shown to the others as "Learner" — and this is how they
/// choose to be named instead. Recorded `in_context`, through the same ledger
/// Settings → Your data lists it in, so the two can never disagree.

abstract class _$NameOnBoardActions extends $Notifier<NameOnBoardSave> {
  NameOnBoardSave build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NameOnBoardSave, NameOnBoardSave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NameOnBoardSave, NameOnBoardSave>,
              NameOnBoardSave,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
