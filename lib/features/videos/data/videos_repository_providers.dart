import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/internet_monitor.dart';
import '../domain/videos_repository.dart';
import 'mock_videos_repository.dart';

/// Resolves the [VideosRepository]. Gated on `useFakeBackend` like the other
/// slices, but there is no video-library endpoint yet, so BOTH branches
/// currently resolve the bundled-JSON mock (offline-aware); a `kReleaseMode`
/// assert still forbids the fake flavor flag in release builds.
///
/// Override in tests with `videosRepositoryProvider.overrideWithValue(...)`.
final videosRepositoryProvider = Provider<VideosRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return MockVideosRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  // TODO(videos): swap for ApiVideosRepository(ref.watch(dioClientProvider))
  // once the video-library endpoint ships; the seam and models are ready.
  return MockVideosRepository(
    isOffline: () => ref.read(internetMonitorProvider).isOffline,
  );
});
