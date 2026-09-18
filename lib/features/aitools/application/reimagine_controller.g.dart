// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reimagine_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which category chip is selected on Reimagine. `null` is "All templates".
///
/// Kept out of [ReimagineController] on purpose: the web fetches the gallery
/// once and filters it in memory, so a chip tap must not refetch. Putting the
/// selection into the controller's `build` would make every tap a request.

@ProviderFor(ReimagineCategory)
final reimagineCategoryProvider = ReimagineCategoryProvider._();

/// Which category chip is selected on Reimagine. `null` is "All templates".
///
/// Kept out of [ReimagineController] on purpose: the web fetches the gallery
/// once and filters it in memory, so a chip tap must not refetch. Putting the
/// selection into the controller's `build` would make every tap a request.
final class ReimagineCategoryProvider
    extends $NotifierProvider<ReimagineCategory, String?> {
  /// Which category chip is selected on Reimagine. `null` is "All templates".
  ///
  /// Kept out of [ReimagineController] on purpose: the web fetches the gallery
  /// once and filters it in memory, so a chip tap must not refetch. Putting the
  /// selection into the controller's `build` would make every tap a request.
  ReimagineCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reimagineCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reimagineCategoryHash();

  @$internal
  @override
  ReimagineCategory create() => ReimagineCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$reimagineCategoryHash() => r'd1f59c1ecb9dc11f667ebe8f7a3c159b63c38455';

/// Which category chip is selected on Reimagine. `null` is "All templates".
///
/// Kept out of [ReimagineController] on purpose: the web fetches the gallery
/// once and filters it in memory, so a chip tap must not refetch. Putting the
/// selection into the controller's `build` would make every tap a request.

abstract class _$ReimagineCategory extends $Notifier<String?> {
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

/// The Reimagine gallery — `GET /studio/templates`.
///
/// Mirrors the web's `useStudioTemplates`: one fetch, cached, shared with any
/// other surface that wants the same list.

@ProviderFor(ReimagineController)
final reimagineControllerProvider = ReimagineControllerProvider._();

/// The Reimagine gallery — `GET /studio/templates`.
///
/// Mirrors the web's `useStudioTemplates`: one fetch, cached, shared with any
/// other surface that wants the same list.
final class ReimagineControllerProvider
    extends $AsyncNotifierProvider<ReimagineController, List<StudioTemplate>> {
  /// The Reimagine gallery — `GET /studio/templates`.
  ///
  /// Mirrors the web's `useStudioTemplates`: one fetch, cached, shared with any
  /// other surface that wants the same list.
  ReimagineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reimagineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reimagineControllerHash();

  @$internal
  @override
  ReimagineController create() => ReimagineController();
}

String _$reimagineControllerHash() =>
    r'e387bf9b60637bc1813e53a11ff9c86b13d3ebfd';

/// The Reimagine gallery — `GET /studio/templates`.
///
/// Mirrors the web's `useStudioTemplates`: one fetch, cached, shared with any
/// other surface that wants the same list.

abstract class _$ReimagineController
    extends $AsyncNotifier<List<StudioTemplate>> {
  FutureOr<List<StudioTemplate>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<StudioTemplate>>, List<StudioTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<StudioTemplate>>,
                List<StudioTemplate>
              >,
              AsyncValue<List<StudioTemplate>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Copying a template into the user's own designs — `POST /studio/copy`.
///
/// Separate from [ReimagineController] because the gallery is not invalidated
/// by a copy: the copy is private and never a template, so it can never appear
/// in this list. Refetching after it would be a request that provably changes
/// nothing.

@ProviderFor(TemplateCopyController)
final templateCopyControllerProvider = TemplateCopyControllerProvider._();

/// Copying a template into the user's own designs — `POST /studio/copy`.
///
/// Separate from [ReimagineController] because the gallery is not invalidated
/// by a copy: the copy is private and never a template, so it can never appear
/// in this list. Refetching after it would be a request that provably changes
/// nothing.
final class TemplateCopyControllerProvider
    extends $NotifierProvider<TemplateCopyController, TemplateCopyState> {
  /// Copying a template into the user's own designs — `POST /studio/copy`.
  ///
  /// Separate from [ReimagineController] because the gallery is not invalidated
  /// by a copy: the copy is private and never a template, so it can never appear
  /// in this list. Refetching after it would be a request that provably changes
  /// nothing.
  TemplateCopyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateCopyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateCopyControllerHash();

  @$internal
  @override
  TemplateCopyController create() => TemplateCopyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplateCopyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplateCopyState>(value),
    );
  }
}

String _$templateCopyControllerHash() =>
    r'ee1a544d3caaccef2eb900b716b6545f000c75f2';

/// Copying a template into the user's own designs — `POST /studio/copy`.
///
/// Separate from [ReimagineController] because the gallery is not invalidated
/// by a copy: the copy is private and never a template, so it can never appear
/// in this list. Refetching after it would be a request that provably changes
/// nothing.

abstract class _$TemplateCopyController extends $Notifier<TemplateCopyState> {
  TemplateCopyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TemplateCopyState, TemplateCopyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TemplateCopyState, TemplateCopyState>,
              TemplateCopyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
