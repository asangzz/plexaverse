// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatars_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the Avatars tab (screenshot 2369). Profile and looks are fetched
/// in parallel and land together so the header, grid and voice bar appear
/// as one unit. `AsyncValue` drives the page states: loading → skeleton,
/// error → shared network-error view (with retry), data → the tab. Retry
/// re-runs it via `ref.invalidate`.

@ProviderFor(AvatarsController)
final avatarsControllerProvider = AvatarsControllerProvider._();

/// Loads the Avatars tab (screenshot 2369). Profile and looks are fetched
/// in parallel and land together so the header, grid and voice bar appear
/// as one unit. `AsyncValue` drives the page states: loading → skeleton,
/// error → shared network-error view (with retry), data → the tab. Retry
/// re-runs it via `ref.invalidate`.
final class AvatarsControllerProvider
    extends $AsyncNotifierProvider<AvatarsController, AvatarsOverview> {
  /// Loads the Avatars tab (screenshot 2369). Profile and looks are fetched
  /// in parallel and land together so the header, grid and voice bar appear
  /// as one unit. `AsyncValue` drives the page states: loading → skeleton,
  /// error → shared network-error view (with retry), data → the tab. Retry
  /// re-runs it via `ref.invalidate`.
  AvatarsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarsControllerHash();

  @$internal
  @override
  AvatarsController create() => AvatarsController();
}

String _$avatarsControllerHash() => r'5371e07db06ed8c33b30ea64fc88751f978e9fbd';

/// Loads the Avatars tab (screenshot 2369). Profile and looks are fetched
/// in parallel and land together so the header, grid and voice bar appear
/// as one unit. `AsyncValue` drives the page states: loading → skeleton,
/// error → shared network-error view (with retry), data → the tab. Retry
/// re-runs it via `ref.invalidate`.

abstract class _$AvatarsController extends $AsyncNotifier<AvatarsOverview> {
  FutureOr<AvatarsOverview> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AvatarsOverview>, AvatarsOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AvatarsOverview>, AvatarsOverview>,
              AsyncValue<AvatarsOverview>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
