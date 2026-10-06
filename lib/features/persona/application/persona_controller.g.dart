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

String _$personaControllerHash() => r'3e2d0233354fdf523e2c96e74e568baee5a9e95a';

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

/// The follower series behind the checkpoint.
///
/// Separate from [PersonaController] rather than folded into the snapshot:
/// `GET /persona` does not carry it, it is only ever needed by the one strip
/// that draws it, and keeping it apart means the roadmap does not pay for a
/// second query on every load of a screen that may not show a chart at all.
///
/// Returns an empty history rather than throwing when the read fails. This is
/// an instrument on somebody else's screen — the roadmap renders perfectly
/// without it, and an error card above the day's missions would cost more
/// attention than the line is worth.

@ProviderFor(followerHistory)
final followerHistoryProvider = FollowerHistoryProvider._();

/// The follower series behind the checkpoint.
///
/// Separate from [PersonaController] rather than folded into the snapshot:
/// `GET /persona` does not carry it, it is only ever needed by the one strip
/// that draws it, and keeping it apart means the roadmap does not pay for a
/// second query on every load of a screen that may not show a chart at all.
///
/// Returns an empty history rather than throwing when the read fails. This is
/// an instrument on somebody else's screen — the roadmap renders perfectly
/// without it, and an error card above the day's missions would cost more
/// attention than the line is worth.

final class FollowerHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<FollowerHistory>,
          FollowerHistory,
          FutureOr<FollowerHistory>
        >
    with $FutureModifier<FollowerHistory>, $FutureProvider<FollowerHistory> {
  /// The follower series behind the checkpoint.
  ///
  /// Separate from [PersonaController] rather than folded into the snapshot:
  /// `GET /persona` does not carry it, it is only ever needed by the one strip
  /// that draws it, and keeping it apart means the roadmap does not pay for a
  /// second query on every load of a screen that may not show a chart at all.
  ///
  /// Returns an empty history rather than throwing when the read fails. This is
  /// an instrument on somebody else's screen — the roadmap renders perfectly
  /// without it, and an error card above the day's missions would cost more
  /// attention than the line is worth.
  FollowerHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followerHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$followerHistoryHash();

  @$internal
  @override
  $FutureProviderElement<FollowerHistory> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FollowerHistory> create(Ref ref) {
    return followerHistory(ref);
  }
}

String _$followerHistoryHash() => r'bb0ee9fed2d7b6c755034c93d4e729e17376055c';

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
