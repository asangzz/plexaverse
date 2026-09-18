import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';
import '../../storage/session_store.dart';
import '../api_paths.dart';

/// Owns the single-flight refresh-token call. [AuthInterceptor] delegates
/// here so its file / class size stays inside the §2.5 caps and the refresh
/// wire format lives behind one boundary.
///
/// SINGLE-FLIGHT: the old Plexaverse `AuthInterceptor` coalesced concurrent
/// 401 refreshes with an `_isRefreshing` bool + a list of pending
/// `Completer`s. This is the ProHealth future-identity form of the same
/// contract — every concurrent `refresh()` awaits the one `_inflight`
/// future, and the flag clears itself in `whenComplete`. Cleaner, and it
/// can't leak completers if the refresh throws.
///
/// `isRefreshExtraKey` is exposed so the interceptor can mark the underlying
/// `RequestOptions` as the refresh call itself, preventing the 401-on-
/// refresh recursion.
class TokenRefresher {
  TokenRefresher({
    required Dio client,
    required SessionStore session,
    required AppLogger logger,
  })  : _client = client,
        _session = session,
        _logger = logger;

  final Dio _client;
  final SessionStore _session;
  final AppLogger _logger;

  /// The bare Dio used for both the refresh call and the retry of the
  /// original request — exposed so `AuthInterceptor._retry` can call
  /// `fetch()` without re-creating the client config.
  Dio get client => _client;

  Future<String?>? _inflight;

  /// Marker placed on the refresh request's `extra` map so [AuthInterceptor]
  /// knows not to recurse into refresh-on-401 for the refresh call.
  static const String isRefreshExtraKey = '_dio_auth_is_refresh';

  /// Coalesces concurrent refresh calls into one network roundtrip.
  Future<String?> refresh() {
    final existing = _inflight;
    if (existing != null) return existing;
    final future = _doRefresh();
    _inflight = future;
    return future.whenComplete(() {
      if (identical(_inflight, future)) _inflight = null;
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _session.refreshToken();
    if (refreshToken == null) return null;
    try {
      final body = await _postRefresh(refreshToken);
      return _persistRefreshedTokens(body);
    } on DioException catch (error) {
      _logRefreshDioFailure(error);
      return null;
    } on Object catch (error, stack) {
      _logRefreshUnexpectedFailure(error, stack);
      return null;
    }
  }

  void _logRefreshDioFailure(DioException error) {
    _logger.warn(
      'TokenRefresher: refresh failed (${error.response?.statusCode})',
      error: error,
    );
  }

  void _logRefreshUnexpectedFailure(Object error, StackTrace stack) {
    _logger.warn(
      'TokenRefresher: refresh threw',
      error: error,
      stackTrace: stack,
    );
  }

  Future<Map<String, dynamic>?> _postRefresh(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.refresh,
      data: <String, String>{'refreshToken': refreshToken},
      options: Options(extra: <String, dynamic>{isRefreshExtraKey: true}),
    );
    // The refresh call bypasses the DioClient parse seam (it runs on the
    // bare refresh Dio), so unwrap the Plexaverse `{data, error, meta}`
    // envelope here: prefer the inner `data` object, else the flat body.
    final raw = response.data;
    final inner = raw?['data'];
    if (inner is Map<String, dynamic>) return inner;
    return raw;
  }

  Future<String?> _persistRefreshedTokens(Map<String, dynamic>? body) async {
    final newAccess = body?['accessToken'];
    final newRefresh = body?['refreshToken'];
    if (newAccess is! String || newRefresh is! String) {
      _logger.warn('TokenRefresher: refresh response missing tokens');
      return null;
    }
    await _session.writeTokens(
      accessToken: newAccess,
      refreshToken: newRefresh,
    );
    return newAccess;
  }
}
