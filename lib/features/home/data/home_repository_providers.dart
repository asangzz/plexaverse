import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/internet_monitor.dart';
import '../domain/home_repository.dart';
import 'api_home_repository.dart';
import 'mock_home_repository.dart';

/// Resolves the [HomeRepository] from `useFakeBackend` — the mock (bundled
/// JSON, offline-aware) for the `mock` flavor, the real Dio impl otherwise.
/// Going live is config-only; a `kReleaseMode` assert forbids the mock ever
/// resolving in a release build.
///
/// Override in tests with `homeRepositoryProvider.overrideWithValue(...)`.
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds.',
  );
  if (useFake && !kReleaseMode) {
    return MockHomeRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  return ApiHomeRepository(ref.watch(dioClientProvider));
});
