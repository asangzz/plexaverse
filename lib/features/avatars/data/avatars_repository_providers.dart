import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/internet_monitor.dart';
import '../domain/avatars_repository.dart';
import 'mock_avatars_repository.dart';

/// Resolves the [AvatarsRepository]. Gated on `useFakeBackend` like the
/// other slices, but there is no avatars endpoint yet, so BOTH branches
/// currently resolve the bundled-JSON mock (offline-aware); a
/// `kReleaseMode` assert still forbids the fake flavor flag in release
/// builds.
///
/// Override in tests with `avatarsRepositoryProvider.overrideWithValue(...)`.
final avatarsRepositoryProvider = Provider<AvatarsRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return MockAvatarsRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  // TODO(avatars): swap for ApiAvatarsRepository(ref.watch(dioClientProvider))
  // once the avatars endpoint ships; the seam and models are ready.
  return MockAvatarsRepository(
    isOffline: () => ref.read(internetMonitorProvider).isOffline,
  );
});
