// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skip_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The double-tap guard every Skip control shares.
///
/// After a skip resolves, the NEXT level's Skip can be drawn in the very spot
/// the finger is still on — the node card, the lesson header, the checkpoint,
/// a level page opened after it — and the server cannot tell two valid
/// presses apart. So every Skip is hidden for [kSkipGuard] after a skip.
///
/// Kept alive and shared, not per widget: the page a skip opens is a fresh
/// widget, and a per-widget flag would start it uncooled — exactly the double
/// skip this exists to stop. The web keeps it as module state for the same
/// reason.

@ProviderFor(SkipCooldown)
final skipCooldownProvider = SkipCooldownProvider._();

/// The double-tap guard every Skip control shares.
///
/// After a skip resolves, the NEXT level's Skip can be drawn in the very spot
/// the finger is still on — the node card, the lesson header, the checkpoint,
/// a level page opened after it — and the server cannot tell two valid
/// presses apart. So every Skip is hidden for [kSkipGuard] after a skip.
///
/// Kept alive and shared, not per widget: the page a skip opens is a fresh
/// widget, and a per-widget flag would start it uncooled — exactly the double
/// skip this exists to stop. The web keeps it as module state for the same
/// reason.
final class SkipCooldownProvider extends $NotifierProvider<SkipCooldown, bool> {
  /// The double-tap guard every Skip control shares.
  ///
  /// After a skip resolves, the NEXT level's Skip can be drawn in the very spot
  /// the finger is still on — the node card, the lesson header, the checkpoint,
  /// a level page opened after it — and the server cannot tell two valid
  /// presses apart. So every Skip is hidden for [kSkipGuard] after a skip.
  ///
  /// Kept alive and shared, not per widget: the page a skip opens is a fresh
  /// widget, and a per-widget flag would start it uncooled — exactly the double
  /// skip this exists to stop. The web keeps it as module state for the same
  /// reason.
  SkipCooldownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skipCooldownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skipCooldownHash();

  @$internal
  @override
  SkipCooldown create() => SkipCooldown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$skipCooldownHash() => r'107fd6889e1c8bde8a6898ba5bac7caf2df11b2b';

/// The double-tap guard every Skip control shares.
///
/// After a skip resolves, the NEXT level's Skip can be drawn in the very spot
/// the finger is still on — the node card, the lesson header, the checkpoint,
/// a level page opened after it — and the server cannot tell two valid
/// presses apart. So every Skip is hidden for [kSkipGuard] after a skip.
///
/// Kept alive and shared, not per widget: the page a skip opens is a fresh
/// widget, and a per-widget flag would start it uncooled — exactly the double
/// skip this exists to stop. The web keeps it as module state for the same
/// reason.

abstract class _$SkipCooldown extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// `POST /contest/skip`, with its busy and error state off the widget.
///
/// A success re-reads the path and today's lesson, WAITS for the path, and
/// says which level is open next — so the caller can move on without reading
/// the cache itself — then starts [SkipCooldown].

@ProviderFor(ContestSkipActions)
final contestSkipActionsProvider = ContestSkipActionsProvider._();

/// `POST /contest/skip`, with its busy and error state off the widget.
///
/// A success re-reads the path and today's lesson, WAITS for the path, and
/// says which level is open next — so the caller can move on without reading
/// the cache itself — then starts [SkipCooldown].
final class ContestSkipActionsProvider
    extends $NotifierProvider<ContestSkipActions, SkipBusy> {
  /// `POST /contest/skip`, with its busy and error state off the widget.
  ///
  /// A success re-reads the path and today's lesson, WAITS for the path, and
  /// says which level is open next — so the caller can move on without reading
  /// the cache itself — then starts [SkipCooldown].
  ContestSkipActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestSkipActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestSkipActionsHash();

  @$internal
  @override
  ContestSkipActions create() => ContestSkipActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SkipBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SkipBusy>(value),
    );
  }
}

String _$contestSkipActionsHash() =>
    r'ea4103f32fa9e6bab963ae760b49db8ffe3e27bf';

/// `POST /contest/skip`, with its busy and error state off the widget.
///
/// A success re-reads the path and today's lesson, WAITS for the path, and
/// says which level is open next — so the caller can move on without reading
/// the cache itself — then starts [SkipCooldown].

abstract class _$ContestSkipActions extends $Notifier<SkipBusy> {
  SkipBusy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SkipBusy, SkipBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SkipBusy, SkipBusy>,
              SkipBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
