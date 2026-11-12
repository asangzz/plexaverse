// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `POST /contest/tasks/claim` for one piece.

@ProviderFor(ClaimActions)
final claimActionsProvider = ClaimActionsFamily._();

/// `POST /contest/tasks/claim` for one piece.
final class ClaimActionsProvider
    extends $NotifierProvider<ClaimActions, ClaimSend> {
  /// `POST /contest/tasks/claim` for one piece.
  ClaimActionsProvider._({
    required ClaimActionsFamily super.from,
    required (ClaimKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'claimActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimActionsHash();

  @override
  String toString() {
    return r'claimActionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ClaimActions create() => ClaimActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaimSend value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaimSend>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimActionsHash() => r'ae9d6e0fd81edda0c24a87dfefccccd1e1f8cfb9';

/// `POST /contest/tasks/claim` for one piece.

final class ClaimActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimActions,
          ClaimSend,
          ClaimSend,
          ClaimSend,
          (ClaimKind, String)
        > {
  ClaimActionsFamily._()
    : super(
        retry: null,
        name: r'claimActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// `POST /contest/tasks/claim` for one piece.

  ClaimActionsProvider call(ClaimKind kind, String occurrence) =>
      ClaimActionsProvider._(argument: (kind, occurrence), from: this);

  @override
  String toString() => r'claimActionsProvider';
}

/// `POST /contest/tasks/claim` for one piece.

abstract class _$ClaimActions extends $Notifier<ClaimSend> {
  late final _$args = ref.$arg as (ClaimKind, String);
  ClaimKind get kind => _$args.$1;
  String get occurrence => _$args.$2;

  ClaimSend build(ClaimKind kind, String occurrence);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ClaimSend, ClaimSend>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClaimSend, ClaimSend>,
              ClaimSend,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
