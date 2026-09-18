import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/api_environment.dart';
import '../network_config.dart';
import 'offline_gate_interceptor.dart';

part 'refresh_dio.g.dart';

/// Near-bare Dio used solely for the refresh call AND for retrying the
/// original request after a successful refresh. Lives outside the main
/// interceptor chain so the refresh request doesn't recurse into
/// [AuthInterceptor] on a 401 from refresh itself. It does carry the
/// offline gate, though — the app is online-first, and a token refresh
/// attempted while definitively offline should fast-fail like every other
/// call instead of burning the connect timeout (no recursion risk: the
/// gate never re-enters the auth chain).
///
/// DEVIATION FROM PROHEALTH: ProHealth is multi-tenant and derives the
/// refresh base URL from a `RefreshBaseUrl` notifier set at bootstrap once
/// the tenant resolves (to avoid a tenant→dio→auth→tenant provider cycle).
/// Plexaverse is single-brand with an ENV-derived base URL
/// ([apiBaseUrlProvider]) and no tenant→network cycle, so the refresh Dio
/// simply reads the same env-derived base URL directly. No notifier to wire
/// at bootstrap, and no `StateError` on early read.
@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      sendTimeout: NetworkConfig.sendTimeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  )..interceptors.add(ref.read(offlineGateInterceptorProvider));
  ref.onDispose(() => dio.close(force: true));
  return dio;
}
