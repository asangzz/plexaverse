// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona_write_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every write the persona can start, and which of them are open.
///
/// ## Why the flags are here and not on the widgets
///
/// Each of these was a `_saving` / `_busy` field on the widget holding the
/// button. ARCHITECTURE.md's test — "if the widget were disposed
/// mid-operation, or a second screen asked the same question, would the answer
/// be wrong?" — answers yes for all three. The audience PATCH and the reach
/// import keep running after a back-swipe, and the follower checkpoint is
/// asked from a different screen than the one that owns the persona: a flag
/// that lives on whichever widget happened to host the control cannot be read
/// by the other.
///
/// ## Why the reads stay on [PersonaController]
///
/// [PersonaController] is one controller on purpose — everything the screen
/// shows comes from the same two requests. Nothing about that changes here.
/// This holds only the "is it open" answer, which the snapshot has no field
/// for and should not grow one: a value fetched from the server and a flag
/// about a request in flight have different lifetimes.
///
/// ## Why it is `autoDispose`
///
/// Same bargain `SettingsWriteController` strikes: the flag is worth losing
/// when the screen goes, the WORK is not, and the work is not lost — every
/// method below delegates to [PersonaController], which owns the request and
/// the result. Only the "is it open" answer goes, and by then nobody is
/// asking. Each control watches its own key through `.select`, so the audience
/// form does not rebuild because the reach import moved.

@ProviderFor(PersonaWriteController)
final personaWriteControllerProvider = PersonaWriteControllerProvider._();

/// Every write the persona can start, and which of them are open.
///
/// ## Why the flags are here and not on the widgets
///
/// Each of these was a `_saving` / `_busy` field on the widget holding the
/// button. ARCHITECTURE.md's test — "if the widget were disposed
/// mid-operation, or a second screen asked the same question, would the answer
/// be wrong?" — answers yes for all three. The audience PATCH and the reach
/// import keep running after a back-swipe, and the follower checkpoint is
/// asked from a different screen than the one that owns the persona: a flag
/// that lives on whichever widget happened to host the control cannot be read
/// by the other.
///
/// ## Why the reads stay on [PersonaController]
///
/// [PersonaController] is one controller on purpose — everything the screen
/// shows comes from the same two requests. Nothing about that changes here.
/// This holds only the "is it open" answer, which the snapshot has no field
/// for and should not grow one: a value fetched from the server and a flag
/// about a request in flight have different lifetimes.
///
/// ## Why it is `autoDispose`
///
/// Same bargain `SettingsWriteController` strikes: the flag is worth losing
/// when the screen goes, the WORK is not, and the work is not lost — every
/// method below delegates to [PersonaController], which owns the request and
/// the result. Only the "is it open" answer goes, and by then nobody is
/// asking. Each control watches its own key through `.select`, so the audience
/// form does not rebuild because the reach import moved.
final class PersonaWriteControllerProvider
    extends $NotifierProvider<PersonaWriteController, Set<String>> {
  /// Every write the persona can start, and which of them are open.
  ///
  /// ## Why the flags are here and not on the widgets
  ///
  /// Each of these was a `_saving` / `_busy` field on the widget holding the
  /// button. ARCHITECTURE.md's test — "if the widget were disposed
  /// mid-operation, or a second screen asked the same question, would the answer
  /// be wrong?" — answers yes for all three. The audience PATCH and the reach
  /// import keep running after a back-swipe, and the follower checkpoint is
  /// asked from a different screen than the one that owns the persona: a flag
  /// that lives on whichever widget happened to host the control cannot be read
  /// by the other.
  ///
  /// ## Why the reads stay on [PersonaController]
  ///
  /// [PersonaController] is one controller on purpose — everything the screen
  /// shows comes from the same two requests. Nothing about that changes here.
  /// This holds only the "is it open" answer, which the snapshot has no field
  /// for and should not grow one: a value fetched from the server and a flag
  /// about a request in flight have different lifetimes.
  ///
  /// ## Why it is `autoDispose`
  ///
  /// Same bargain `SettingsWriteController` strikes: the flag is worth losing
  /// when the screen goes, the WORK is not, and the work is not lost — every
  /// method below delegates to [PersonaController], which owns the request and
  /// the result. Only the "is it open" answer goes, and by then nobody is
  /// asking. Each control watches its own key through `.select`, so the audience
  /// form does not rebuild because the reach import moved.
  PersonaWriteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personaWriteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personaWriteControllerHash();

  @$internal
  @override
  PersonaWriteController create() => PersonaWriteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$personaWriteControllerHash() =>
    r'ee2c203e72b6261c89e22982d8df6efa695c394b';

/// Every write the persona can start, and which of them are open.
///
/// ## Why the flags are here and not on the widgets
///
/// Each of these was a `_saving` / `_busy` field on the widget holding the
/// button. ARCHITECTURE.md's test — "if the widget were disposed
/// mid-operation, or a second screen asked the same question, would the answer
/// be wrong?" — answers yes for all three. The audience PATCH and the reach
/// import keep running after a back-swipe, and the follower checkpoint is
/// asked from a different screen than the one that owns the persona: a flag
/// that lives on whichever widget happened to host the control cannot be read
/// by the other.
///
/// ## Why the reads stay on [PersonaController]
///
/// [PersonaController] is one controller on purpose — everything the screen
/// shows comes from the same two requests. Nothing about that changes here.
/// This holds only the "is it open" answer, which the snapshot has no field
/// for and should not grow one: a value fetched from the server and a flag
/// about a request in flight have different lifetimes.
///
/// ## Why it is `autoDispose`
///
/// Same bargain `SettingsWriteController` strikes: the flag is worth losing
/// when the screen goes, the WORK is not, and the work is not lost — every
/// method below delegates to [PersonaController], which owns the request and
/// the result. Only the "is it open" answer goes, and by then nobody is
/// asking. Each control watches its own key through `.select`, so the audience
/// form does not rebuild because the reach import moved.

abstract class _$PersonaWriteController extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
