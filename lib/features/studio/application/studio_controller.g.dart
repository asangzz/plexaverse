// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Studio is unlocked.
///
/// Every Studio surface watches this, so it is the one place the XP gate is
/// decided. Kept as its own controller rather than folded into the library so
/// that unlocking re-renders the gate without re-fetching the design list —
/// and so the list's own failure cannot be mistaken for "you don't have
/// access", which is the confusing failure this split exists to prevent.

@ProviderFor(StudioAccessController)
final studioAccessControllerProvider = StudioAccessControllerProvider._();

/// Whether Studio is unlocked.
///
/// Every Studio surface watches this, so it is the one place the XP gate is
/// decided. Kept as its own controller rather than folded into the library so
/// that unlocking re-renders the gate without re-fetching the design list —
/// and so the list's own failure cannot be mistaken for "you don't have
/// access", which is the confusing failure this split exists to prevent.
final class StudioAccessControllerProvider
    extends $AsyncNotifierProvider<StudioAccessController, StudioAccess> {
  /// Whether Studio is unlocked.
  ///
  /// Every Studio surface watches this, so it is the one place the XP gate is
  /// decided. Kept as its own controller rather than folded into the library so
  /// that unlocking re-renders the gate without re-fetching the design list —
  /// and so the list's own failure cannot be mistaken for "you don't have
  /// access", which is the confusing failure this split exists to prevent.
  StudioAccessControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studioAccessControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studioAccessControllerHash();

  @$internal
  @override
  StudioAccessController create() => StudioAccessController();
}

String _$studioAccessControllerHash() =>
    r'fb59f80e32e37f633e2d46c637266ba8bf03298e';

/// Whether Studio is unlocked.
///
/// Every Studio surface watches this, so it is the one place the XP gate is
/// decided. Kept as its own controller rather than folded into the library so
/// that unlocking re-renders the gate without re-fetching the design list —
/// and so the list's own failure cannot be mistaken for "you don't have
/// access", which is the confusing failure this split exists to prevent.

abstract class _$StudioAccessController extends $AsyncNotifier<StudioAccess> {
  FutureOr<StudioAccess> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StudioAccess>, StudioAccess>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StudioAccess>, StudioAccess>,
              AsyncValue<StudioAccess>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The user's saved designs.

@ProviderFor(StudioDesignsController)
final studioDesignsControllerProvider = StudioDesignsControllerProvider._();

/// The user's saved designs.
final class StudioDesignsControllerProvider
    extends
        $AsyncNotifierProvider<StudioDesignsController, List<StudioDesign>> {
  /// The user's saved designs.
  StudioDesignsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studioDesignsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studioDesignsControllerHash();

  @$internal
  @override
  StudioDesignsController create() => StudioDesignsController();
}

String _$studioDesignsControllerHash() =>
    r'd808a0157e428b0f560fb4d523d886b0e54ba849';

/// The user's saved designs.

abstract class _$StudioDesignsController
    extends $AsyncNotifier<List<StudioDesign>> {
  FutureOr<List<StudioDesign>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StudioDesign>>, List<StudioDesign>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StudioDesign>>, List<StudioDesign>>,
              AsyncValue<List<StudioDesign>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Templates the user may start from — public designs plus their own.
///
/// Separate from the design list because it is a different question ("what
/// could I start from") asked against a different endpoint, and because a
/// template fetch failing must not empty the user's own work.

@ProviderFor(StudioTemplatesController)
final studioTemplatesControllerProvider = StudioTemplatesControllerProvider._();

/// Templates the user may start from — public designs plus their own.
///
/// Separate from the design list because it is a different question ("what
/// could I start from") asked against a different endpoint, and because a
/// template fetch failing must not empty the user's own work.
final class StudioTemplatesControllerProvider
    extends
        $AsyncNotifierProvider<StudioTemplatesController, List<StudioDesign>> {
  /// Templates the user may start from — public designs plus their own.
  ///
  /// Separate from the design list because it is a different question ("what
  /// could I start from") asked against a different endpoint, and because a
  /// template fetch failing must not empty the user's own work.
  StudioTemplatesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studioTemplatesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studioTemplatesControllerHash();

  @$internal
  @override
  StudioTemplatesController create() => StudioTemplatesController();
}

String _$studioTemplatesControllerHash() =>
    r'1329ecdf09861f354384a7228e224a3961e1c8f1';

/// Templates the user may start from — public designs plus their own.
///
/// Separate from the design list because it is a different question ("what
/// could I start from") asked against a different endpoint, and because a
/// template fetch failing must not empty the user's own work.

abstract class _$StudioTemplatesController
    extends $AsyncNotifier<List<StudioDesign>> {
  FutureOr<List<StudioDesign>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StudioDesign>>, List<StudioDesign>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StudioDesign>>, List<StudioDesign>>,
              AsyncValue<List<StudioDesign>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
