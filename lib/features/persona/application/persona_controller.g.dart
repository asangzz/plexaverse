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

String _$personaControllerHash() => r'7b1a6ba911b6b844f9456be98bf00260d9cb6fa5';

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
