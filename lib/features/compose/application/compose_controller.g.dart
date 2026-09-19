// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who the user is publishing as — preferences plus connected accounts.
///
/// Separate from the draft on purpose. This half is server state that can be
/// refetched and can fail; the draft is the user's work and must survive both.
/// Folding them into one provider would mean a failed accounts fetch threw away
/// a post someone had just written.

@ProviderFor(ComposeContextController)
final composeContextControllerProvider = ComposeContextControllerProvider._();

/// Who the user is publishing as — preferences plus connected accounts.
///
/// Separate from the draft on purpose. This half is server state that can be
/// refetched and can fail; the draft is the user's work and must survive both.
/// Folding them into one provider would mean a failed accounts fetch threw away
/// a post someone had just written.
final class ComposeContextControllerProvider
    extends
        $AsyncNotifierProvider<ComposeContextController, ComposeContextState> {
  /// Who the user is publishing as — preferences plus connected accounts.
  ///
  /// Separate from the draft on purpose. This half is server state that can be
  /// refetched and can fail; the draft is the user's work and must survive both.
  /// Folding them into one provider would mean a failed accounts fetch threw away
  /// a post someone had just written.
  ComposeContextControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composeContextControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composeContextControllerHash();

  @$internal
  @override
  ComposeContextController create() => ComposeContextController();
}

String _$composeContextControllerHash() =>
    r'7def994c2cee31de99cc7b9c9a485d563de2a925';

/// Who the user is publishing as — preferences plus connected accounts.
///
/// Separate from the draft on purpose. This half is server state that can be
/// refetched and can fail; the draft is the user's work and must survive both.
/// Folding them into one provider would mean a failed accounts fetch threw away
/// a post someone had just written.

abstract class _$ComposeContextController
    extends $AsyncNotifier<ComposeContextState> {
  FutureOr<ComposeContextState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ComposeContextState>, ComposeContextState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ComposeContextState>, ComposeContextState>,
              AsyncValue<ComposeContextState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The post being written.
///
/// A plain synchronous notifier — nothing here touches the network. Keeping it
/// that way is what lets the AI generation, the schedule panel and the preview
/// all read one source of truth without any of them awaiting.

@ProviderFor(ComposeDraftController)
final composeDraftControllerProvider = ComposeDraftControllerProvider._();

/// The post being written.
///
/// A plain synchronous notifier — nothing here touches the network. Keeping it
/// that way is what lets the AI generation, the schedule panel and the preview
/// all read one source of truth without any of them awaiting.
final class ComposeDraftControllerProvider
    extends $NotifierProvider<ComposeDraftController, ComposeDraft> {
  /// The post being written.
  ///
  /// A plain synchronous notifier — nothing here touches the network. Keeping it
  /// that way is what lets the AI generation, the schedule panel and the preview
  /// all read one source of truth without any of them awaiting.
  ComposeDraftControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composeDraftControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composeDraftControllerHash();

  @$internal
  @override
  ComposeDraftController create() => ComposeDraftController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComposeDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComposeDraft>(value),
    );
  }
}

String _$composeDraftControllerHash() =>
    r'ed43b13027e2d5b30d40cf33958d8db7ea94d202';

/// The post being written.
///
/// A plain synchronous notifier — nothing here touches the network. Keeping it
/// that way is what lets the AI generation, the schedule panel and the preview
/// all read one source of truth without any of them awaiting.

abstract class _$ComposeDraftController extends $Notifier<ComposeDraft> {
  ComposeDraft build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ComposeDraft, ComposeDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ComposeDraft, ComposeDraft>,
              ComposeDraft,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Everything the composer does that can fail or take time.
///
/// The state it exposes is [ComposeStatus] — what is in flight, what failed,
/// and what just landed. The draft it operates on lives in
/// [ComposeDraftController]; this notifier reads and writes it through that
/// notifier's own methods rather than owning a second copy, because two copies
/// of a post body is exactly how a user loses one.

@ProviderFor(ComposeActions)
final composeActionsProvider = ComposeActionsProvider._();

/// Everything the composer does that can fail or take time.
///
/// The state it exposes is [ComposeStatus] — what is in flight, what failed,
/// and what just landed. The draft it operates on lives in
/// [ComposeDraftController]; this notifier reads and writes it through that
/// notifier's own methods rather than owning a second copy, because two copies
/// of a post body is exactly how a user loses one.
final class ComposeActionsProvider
    extends $NotifierProvider<ComposeActions, ComposeStatus> {
  /// Everything the composer does that can fail or take time.
  ///
  /// The state it exposes is [ComposeStatus] — what is in flight, what failed,
  /// and what just landed. The draft it operates on lives in
  /// [ComposeDraftController]; this notifier reads and writes it through that
  /// notifier's own methods rather than owning a second copy, because two copies
  /// of a post body is exactly how a user loses one.
  ComposeActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composeActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composeActionsHash();

  @$internal
  @override
  ComposeActions create() => ComposeActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComposeStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComposeStatus>(value),
    );
  }
}

String _$composeActionsHash() => r'3fbe9b6ced26ccffc5e6e6506f558168d94b9cc5';

/// Everything the composer does that can fail or take time.
///
/// The state it exposes is [ComposeStatus] — what is in flight, what failed,
/// and what just landed. The draft it operates on lives in
/// [ComposeDraftController]; this notifier reads and writes it through that
/// notifier's own methods rather than owning a second copy, because two copies
/// of a post body is exactly how a user loses one.

abstract class _$ComposeActions extends $Notifier<ComposeStatus> {
  ComposeStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ComposeStatus, ComposeStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ComposeStatus, ComposeStatus>,
              ComposeStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
