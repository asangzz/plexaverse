import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/internet_monitor.dart';
import '../../../core/platform/web_auth.dart';
import '../domain/auth_repository.dart';
import 'api_auth_repository.dart';
import 'mock_auth_repository.dart';

/// Resolves the [AuthRepository] implementation from `useFakeBackend`:
/// the **mock** flavor → [MockAuthRepository] (bundled JSON), everything else →
/// the real [ApiAuthRepository] over Dio. Going live is therefore config — run
/// a real flavor (or override `Env` / `API_BASE_URL`) and the real backend +
/// base URL take effect with no code or UI change.
///
/// Override in tests with `authRepositoryProvider.overrideWithValue(...)`.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final useFake = ref.watch(useFakeBackendProvider);
  // Defence in depth: the mock must never resolve in a release build, even if a
  // flavor were misconfigured. The assert catches it in debug/profile; the
  // `&& !kReleaseMode` guarantees it in release (where asserts strip).
  assert(
    !(kReleaseMode && useFake),
    'useFakeBackend must be false in release builds — the mock auth '
    'repository (and its test credentials) must never ship live.',
  );
  if (useFake && !kReleaseMode) {
    // The mock honours connectivity (online-first): offline calls fast-fail
    // exactly like the gated Dio path would.
    return MockAuthRepository(
      isOffline: () => ref.read(internetMonitorProvider).isOffline,
    );
  }
  return ApiAuthRepository(
    ref.watch(dioClientProvider),
    ref.watch(webAuthServiceProvider),
  );
});
