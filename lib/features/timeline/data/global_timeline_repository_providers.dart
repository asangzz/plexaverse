import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/internet_monitor.dart';
import '../domain/global_timeline_repository.dart';
import 'mock_global_timeline_repository.dart';

/// Resolves the [GlobalTimelineRepository]. Gated on `useFakeBackend` like
/// the other slices, but there is no timeline endpoint yet, so BOTH
/// branches currently resolve the bundled-JSON mock (offline-aware); a
/// `kReleaseMode` assert still forbids the fake flavor flag in release
/// builds.
///
/// Override in tests with
/// `globalTimelineRepositoryProvider.overrideWithValue(...)`.
final globalTimelineRepositoryProvider = Provider<GlobalTimelineRepository>((
  ref,
) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return MockGlobalTimelineRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  // TODO(timeline): swap for ApiGlobalTimelineRepository(ref.watch(dioClientProvider))
  // once the timeline endpoint ships; the seam and models are ready.
  return MockGlobalTimelineRepository(
    isOffline: () => ref.read(internetMonitorProvider).isOffline,
  );
});
