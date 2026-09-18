import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/videos_repository_providers.dart';
import '../domain/videos_repository.dart';

part 'videos_controller.g.dart';

/// Loads the video library for the Videos tab. `AsyncValue` drives the page
/// states: loading → skeleton rows, error → shared network-error view (with
/// retry), data → the list (screenshot 2354). Retry re-runs it via
/// `ref.invalidate`.
@riverpod
class VideosController extends _$VideosController {
  @override
  Future<List<VideoItem>> build() {
    return ref.watch(videosRepositoryProvider).fetchVideos();
  }
}
