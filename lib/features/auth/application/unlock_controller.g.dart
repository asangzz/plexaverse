// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The biometric unlock gate's two use cases — prompt, and give up and sign
/// out — and the state around them.
///
/// ## Why this is not on the page
///
/// It was: `_inProgress`, `_loggingOut` and `_message` were fields on
/// `_UnlockPageState`, and the switch that read the prompt's outcome ran
/// `if (!mounted) return;` first. Two things followed from that.
///
/// The visible one is the ordinary in-flight-flag complaint ARCHITECTURE.md
/// tabulates: a failure recorded after a `mounted` check is a failure the user
/// never sees.
///
/// The worse one is that `BiometricOutcome.success` was handled on the far
/// side of the same guard — and success is where [AppLock.unlock] is called,
/// which is the ONLY thing that lets the router redirect back into the app. A
/// page rebuilt while the system prompt was up (the prompt itself backgrounds
/// the app, which is why `persistAcrossBackgrounding` is set) therefore
/// dropped a successful unlock on the floor and left a user who had just
/// proved who they were still staring at the gate. That is the same shape as
/// the login defect in the doc's table — tokens written, gate never
/// invalidated — one screen over.
///
/// ## The keep-alive link is load-bearing, for the same reason
///
/// Each use case pins this notifier with `ref.keepAlive()` and releases it in
/// a `finally`, copying `AuthController`. The provider is autoDispose and the
/// page is its only listener, so a rebuild mid-prompt would otherwise tear the
/// notifier down during the await and make the `state =` after it throw —
/// losing the outcome in a new way while fixing the old one. Releasing the
/// link rather than declaring `keepAlive: true` is what lets a fresh gate open
/// idle.

@ProviderFor(UnlockController)
final unlockControllerProvider = UnlockControllerProvider._();

/// The biometric unlock gate's two use cases — prompt, and give up and sign
/// out — and the state around them.
///
/// ## Why this is not on the page
///
/// It was: `_inProgress`, `_loggingOut` and `_message` were fields on
/// `_UnlockPageState`, and the switch that read the prompt's outcome ran
/// `if (!mounted) return;` first. Two things followed from that.
///
/// The visible one is the ordinary in-flight-flag complaint ARCHITECTURE.md
/// tabulates: a failure recorded after a `mounted` check is a failure the user
/// never sees.
///
/// The worse one is that `BiometricOutcome.success` was handled on the far
/// side of the same guard — and success is where [AppLock.unlock] is called,
/// which is the ONLY thing that lets the router redirect back into the app. A
/// page rebuilt while the system prompt was up (the prompt itself backgrounds
/// the app, which is why `persistAcrossBackgrounding` is set) therefore
/// dropped a successful unlock on the floor and left a user who had just
/// proved who they were still staring at the gate. That is the same shape as
/// the login defect in the doc's table — tokens written, gate never
/// invalidated — one screen over.
///
/// ## The keep-alive link is load-bearing, for the same reason
///
/// Each use case pins this notifier with `ref.keepAlive()` and releases it in
/// a `finally`, copying `AuthController`. The provider is autoDispose and the
/// page is its only listener, so a rebuild mid-prompt would otherwise tear the
/// notifier down during the await and make the `state =` after it throw —
/// losing the outcome in a new way while fixing the old one. Releasing the
/// link rather than declaring `keepAlive: true` is what lets a fresh gate open
/// idle.
final class UnlockControllerProvider
    extends $NotifierProvider<UnlockController, UnlockState> {
  /// The biometric unlock gate's two use cases — prompt, and give up and sign
  /// out — and the state around them.
  ///
  /// ## Why this is not on the page
  ///
  /// It was: `_inProgress`, `_loggingOut` and `_message` were fields on
  /// `_UnlockPageState`, and the switch that read the prompt's outcome ran
  /// `if (!mounted) return;` first. Two things followed from that.
  ///
  /// The visible one is the ordinary in-flight-flag complaint ARCHITECTURE.md
  /// tabulates: a failure recorded after a `mounted` check is a failure the user
  /// never sees.
  ///
  /// The worse one is that `BiometricOutcome.success` was handled on the far
  /// side of the same guard — and success is where [AppLock.unlock] is called,
  /// which is the ONLY thing that lets the router redirect back into the app. A
  /// page rebuilt while the system prompt was up (the prompt itself backgrounds
  /// the app, which is why `persistAcrossBackgrounding` is set) therefore
  /// dropped a successful unlock on the floor and left a user who had just
  /// proved who they were still staring at the gate. That is the same shape as
  /// the login defect in the doc's table — tokens written, gate never
  /// invalidated — one screen over.
  ///
  /// ## The keep-alive link is load-bearing, for the same reason
  ///
  /// Each use case pins this notifier with `ref.keepAlive()` and releases it in
  /// a `finally`, copying `AuthController`. The provider is autoDispose and the
  /// page is its only listener, so a rebuild mid-prompt would otherwise tear the
  /// notifier down during the await and make the `state =` after it throw —
  /// losing the outcome in a new way while fixing the old one. Releasing the
  /// link rather than declaring `keepAlive: true` is what lets a fresh gate open
  /// idle.
  UnlockControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockControllerHash();

  @$internal
  @override
  UnlockController create() => UnlockController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnlockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnlockState>(value),
    );
  }
}

String _$unlockControllerHash() => r'15b5dc640eaaa23353f523e6134c8868aeda6bf5';

/// The biometric unlock gate's two use cases — prompt, and give up and sign
/// out — and the state around them.
///
/// ## Why this is not on the page
///
/// It was: `_inProgress`, `_loggingOut` and `_message` were fields on
/// `_UnlockPageState`, and the switch that read the prompt's outcome ran
/// `if (!mounted) return;` first. Two things followed from that.
///
/// The visible one is the ordinary in-flight-flag complaint ARCHITECTURE.md
/// tabulates: a failure recorded after a `mounted` check is a failure the user
/// never sees.
///
/// The worse one is that `BiometricOutcome.success` was handled on the far
/// side of the same guard — and success is where [AppLock.unlock] is called,
/// which is the ONLY thing that lets the router redirect back into the app. A
/// page rebuilt while the system prompt was up (the prompt itself backgrounds
/// the app, which is why `persistAcrossBackgrounding` is set) therefore
/// dropped a successful unlock on the floor and left a user who had just
/// proved who they were still staring at the gate. That is the same shape as
/// the login defect in the doc's table — tokens written, gate never
/// invalidated — one screen over.
///
/// ## The keep-alive link is load-bearing, for the same reason
///
/// Each use case pins this notifier with `ref.keepAlive()` and releases it in
/// a `finally`, copying `AuthController`. The provider is autoDispose and the
/// page is its only listener, so a rebuild mid-prompt would otherwise tear the
/// notifier down during the await and make the `state =` after it throw —
/// losing the outcome in a new way while fixing the old one. Releasing the
/// link rather than declaring `keepAlive: true` is what lets a fresh gate open
/// idle.

abstract class _$UnlockController extends $Notifier<UnlockState> {
  UnlockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UnlockState, UnlockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UnlockState, UnlockState>,
              UnlockState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
