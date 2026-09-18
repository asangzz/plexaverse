// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the video library for the Videos tab. `AsyncValue` drives the page
/// states: loading → skeleton rows, error → shared network-error view (with
/// retry), data → the list (screenshot 2354). Retry re-runs it via
/// `ref.invalidate`.

@ProviderFor(VideosController)
final videosControllerProvider = VideosControllerProvider._();

/// Loads the video library for the Videos tab. `AsyncValue` drives the page
/// states: loading → skeleton rows, error → shared network-error view (with
/// retry), data → the list (screenshot 2354). Retry re-runs it via
/// `ref.invalidate`.
final class VideosControllerProvider
    extends $AsyncNotifierProvider<VideosController, List<VideoItem>> {
  /// Loads the video library for the Videos tab. `AsyncValue` drives the page
  /// states: loading → skeleton rows, error → shared network-error view (with
  /// retry), data → the list (screenshot 2354). Retry re-runs it via
  /// `ref.invalidate`.
  VideosControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videosControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videosControllerHash();

  @$internal
  @override
  VideosController create() => VideosController();
}

String _$videosControllerHash() => r'b6f00f3a00c93c7e2fb91298e51fd09bd632d995';

/// Loads the video library for the Videos tab. `AsyncValue` drives the page
/// states: loading → skeleton rows, error → shared network-error view (with
/// retry), data → the list (screenshot 2354). Retry re-runs it via
/// `ref.invalidate`.

abstract class _$VideosController extends $AsyncNotifier<List<VideoItem>> {
  FutureOr<List<VideoItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<VideoItem>>, List<VideoItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VideoItem>>, List<VideoItem>>,
              AsyncValue<List<VideoItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
