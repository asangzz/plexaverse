// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_home_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `POST /contest/join`, with its busy and error state off the widget.
///
/// A success re-reads the standing, and the page turns from the join card
/// into the path (or the quiet page, before day 1) on the overview that
/// comes back — the web's `useJoinContest` onSuccess.

@ProviderFor(ContestJoinActions)
final contestJoinActionsProvider = ContestJoinActionsProvider._();

/// `POST /contest/join`, with its busy and error state off the widget.
///
/// A success re-reads the standing, and the page turns from the join card
/// into the path (or the quiet page, before day 1) on the overview that
/// comes back — the web's `useJoinContest` onSuccess.
final class ContestJoinActionsProvider
    extends $NotifierProvider<ContestJoinActions, ContestJoinBusy> {
  /// `POST /contest/join`, with its busy and error state off the widget.
  ///
  /// A success re-reads the standing, and the page turns from the join card
  /// into the path (or the quiet page, before day 1) on the overview that
  /// comes back — the web's `useJoinContest` onSuccess.
  ContestJoinActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestJoinActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestJoinActionsHash();

  @$internal
  @override
  ContestJoinActions create() => ContestJoinActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContestJoinBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContestJoinBusy>(value),
    );
  }
}

String _$contestJoinActionsHash() =>
    r'dedbdca0f8cdd772de328e3614e6ba36896a02ac';

/// `POST /contest/join`, with its busy and error state off the widget.
///
/// A success re-reads the standing, and the page turns from the join card
/// into the path (or the quiet page, before day 1) on the overview that
/// comes back — the web's `useJoinContest` onSuccess.

abstract class _$ContestJoinActions extends $Notifier<ContestJoinBusy> {
  ContestJoinBusy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContestJoinBusy, ContestJoinBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContestJoinBusy, ContestJoinBusy>,
              ContestJoinBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.

@ProviderFor(ContestOpenNode)
final contestOpenNodeProvider = ContestOpenNodeProvider._();

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.
final class ContestOpenNodeProvider
    extends $NotifierProvider<ContestOpenNode, String?> {
  /// The path level whose card is open, or null. One card at a time: opening a
  /// level closes the last one, and a second tap on the same level closes it.
  ///
  /// Dies with the path, so the page opens with every card shut — as the web's
  /// does on each visit.
  ContestOpenNodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestOpenNodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestOpenNodeHash();

  @$internal
  @override
  ContestOpenNode create() => ContestOpenNode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$contestOpenNodeHash() => r'469d0724c2ee5cd15aa0cf1c33618c7318d489a6';

/// The path level whose card is open, or null. One card at a time: opening a
/// level closes the last one, and a second tap on the same level closes it.
///
/// Dies with the path, so the page opens with every card shut — as the web's
/// does on each visit.

abstract class _$ContestOpenNode extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
