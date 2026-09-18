import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logging/app_logger.dart';
import '../../storage/session_store.dart';
import 'auth_signal.dart';
import 'refresh_dio.dart';
import 'token_refresher.dart';

part 'auth_interceptor.g.dart';

/// Attaches the Bearer token. On 401, runs a single-flight refresh and
/// retries the original request; concurrent 401s await the same refresh
/// future. Refresh failure clears the session and emits an [AuthSignal]
/// that the router listens to (§6, §8).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenRefresher refresher,
    required SessionStore session,
    required AuthSignalSink signals,
    required AppLogger logger,
  })  : _refresher = refresher,
        _session = session,
        _signals = signals,
        _logger = logger;

  final TokenRefresher _refresher;
  final SessionStore _session;
  final AuthSignalSink _signals;
  final AppLogger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_skipAuthKey] == true) {
      handler.next(options);
      return;
    }
    try {
      final token = await _session.activeAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } on Object catch (error, stack) {
      _logger.warn(
        'AuthInterceptor: token attach failed; sending without bearer',
        error: error,
        stackTrace: stack,
      );
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isRefreshable(err)) {
      handler.next(err);
      return;
    }
    if (err.requestOptions.extra[_retriedKey] == true) {
      await _failHard(err);
      handler.next(err);
      return;
    }
    final newToken = await _refresher.refresh();
    if (newToken == null) {
      await _failHard(err);
      handler.next(err);
      return;
    }
    await _retryAndResolve(err, newToken, handler);
  }

  /// Only 401s that aren't themselves the refresh call are eligible.
  bool _isRefreshable(DioException err) {
    if (err.response?.statusCode != 401) return false;
    if (err.requestOptions.extra[TokenRefresher.isRefreshExtraKey] == true) {
      return false;
    }
    return true;
  }

  Future<void> _retryAndResolve(
    DioException err,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final retried = await _retry(err.requestOptions, newToken);
      handler.resolve(retried);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    } on Object catch (other, stack) {
      _logger.error(
        'AuthInterceptor: retry failed',
        error: other,
        stackTrace: stack,
      );
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions options, String token) {
    final retried = options.copyWith(
      headers: <String, dynamic>{
        ...options.headers,
        'Authorization': 'Bearer $token',
      },
      extra: <String, dynamic>{...options.extra, _retriedKey: true},
    );
    return _refresher.client.fetch<dynamic>(retried);
  }

  Future<void> _failHard(DioException err) async {
    await _session.clear();
    _signals.emitSignedOut(reason: 'refresh-failed');
    _logger.warn(
      'AuthInterceptor: cleared session after 401 '
      '(${err.requestOptions.path})',
    );
  }

  // Dio `extra` flags — internal markers carried through the interceptor
  // chain to control retry/skip behaviour. Not persisted, deliberately
  // short and distinct from any `StorageKeys.*` namespace.
  static const String _retriedKey = '_dio_auth_retried';
  static const String _skipAuthKey = '_dio_auth_skip';

  /// Marks a request as not requiring auth (e.g. /auth/login).
  static Options skipAuth([Options? base]) {
    final extra = <String, dynamic>{
      ...?base?.extra,
      _skipAuthKey: true,
    };
    return (base ?? Options()).copyWith(extra: extra);
  }
}

@Riverpod(keepAlive: true)
TokenRefresher tokenRefresher(Ref ref) {
  return TokenRefresher(
    client: ref.watch(refreshDioProvider),
    session: ref.watch(sessionStoreProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(
    refresher: ref.watch(tokenRefresherProvider),
    session: ref.watch(sessionStoreProvider),
    signals: ref.watch(authSignalSinkProvider),
    logger: ref.watch(appLoggerProvider),
  );
}
