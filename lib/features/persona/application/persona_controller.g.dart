// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The persona screen's state.
///
/// One controller rather than a provider per block, because — unlike Settings —
/// everything this screen can actually read comes from the SAME two requests.
/// Splitting it would buy independent retries for two sections that always
/// succeed or fail together.

@ProviderFor(PersonaController)
final personaControllerProvider = PersonaControllerProvider._();

/// The persona screen's state.
///
/// One controller rather than a provider per block, because — unlike Settings —
/// everything this screen can actually read comes from the SAME two requests.
/// Splitting it would buy independent retries for two sections that always
/// succeed or fail together.
final class PersonaControllerProvider
    extends $AsyncNotifierProvider<PersonaController, PersonaSnapshot> {
  /// The persona screen's state.
  ///
  /// One controller rather than a provider per block, because — unlike Settings —
  /// everything this screen can actually read comes from the SAME two requests.
  /// Splitting it would buy independent retries for two sections that always
  /// succeed or fail together.
  PersonaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personaControllerHash();

  @$internal
  @override
  PersonaController create() => PersonaController();
}

String _$personaControllerHash() => r'b25b56aa435bcbff01bf5a7298edbfccbd336663';

/// The persona screen's state.
///
/// One controller rather than a provider per block, because — unlike Settings —
/// everything this screen can actually read comes from the SAME two requests.
/// Splitting it would buy independent retries for two sections that always
/// succeed or fail together.

abstract class _$PersonaController extends $AsyncNotifier<PersonaSnapshot> {
  FutureOr<PersonaSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PersonaSnapshot>, PersonaSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PersonaSnapshot>, PersonaSnapshot>,
              AsyncValue<PersonaSnapshot>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The Plexa conversation.
///
/// Held separately from [PersonaController] because the transcript is UI state
/// with no server counterpart: `/persona/chat` is a single request/response
/// and keeps no history, so reloading the persona must not wipe what the user
/// is in the middle of saying.

@ProviderFor(PersonaChat)
final personaChatProvider = PersonaChatProvider._();

/// The Plexa conversation.
///
/// Held separately from [PersonaController] because the transcript is UI state
/// with no server counterpart: `/persona/chat` is a single request/response
/// and keeps no history, so reloading the persona must not wipe what the user
/// is in the middle of saying.
final class PersonaChatProvider
    extends $NotifierProvider<PersonaChat, List<PersonaTurn>> {
  /// The Plexa conversation.
  ///
  /// Held separately from [PersonaController] because the transcript is UI state
  /// with no server counterpart: `/persona/chat` is a single request/response
  /// and keeps no history, so reloading the persona must not wipe what the user
  /// is in the middle of saying.
  PersonaChatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personaChatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personaChatHash();

  @$internal
  @override
  PersonaChat create() => PersonaChat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PersonaTurn> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PersonaTurn>>(value),
    );
  }
}

String _$personaChatHash() => r'48b857c55fe558224f1a94423b4ca09b13242f7c';

/// The Plexa conversation.
///
/// Held separately from [PersonaController] because the transcript is UI state
/// with no server counterpart: `/persona/chat` is a single request/response
/// and keeps no history, so reloading the persona must not wipe what the user
/// is in the middle of saying.

abstract class _$PersonaChat extends $Notifier<List<PersonaTurn>> {
  List<PersonaTurn> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<PersonaTurn>, List<PersonaTurn>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PersonaTurn>, List<PersonaTurn>>,
              List<PersonaTurn>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PersonaTabController)
final personaTabControllerProvider = PersonaTabControllerProvider._();

final class PersonaTabControllerProvider
    extends $NotifierProvider<PersonaTabController, PersonaTab> {
  PersonaTabControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personaTabControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personaTabControllerHash();

  @$internal
  @override
  PersonaTabController create() => PersonaTabController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonaTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonaTab>(value),
    );
  }
}

String _$personaTabControllerHash() =>
    r'a1dc8b010e63d38f9926fb2d666b267a304323d8';

abstract class _$PersonaTabController extends $Notifier<PersonaTab> {
  PersonaTab build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PersonaTab, PersonaTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PersonaTab, PersonaTab>,
              PersonaTab,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
