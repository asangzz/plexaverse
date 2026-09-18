import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/env.dart';
import 'log_scrubber.dart';

part 'logging_interceptor.g.dart';

/// Dev/staging only. Emits a *scrubbed* view of each request / response /
/// error — Authorization, JWTs, passwords, PII, and any token-shaped strings
/// are masked (§6, §12 PII discipline) before they reach the log.
///
/// CRITICAL — scrubbing must never touch the live traffic. [PrettyDioLogger]
/// both logs *and* forwards whatever it is handed (it calls
/// `handler.next(...)`). So we hand it a scrubbed COPY together with a
/// *throwaway* handler whose `next(...)` goes nowhere; the real, unscrubbed
/// request / response / error is forwarded down the chain via the *real*
/// handler.
///
/// (Forwarding the scrubbed copy on the real handler was a latent bug: the
/// outgoing login request had its `password` replaced by the literal string
/// "[REDACTED]", so every sign-in failed with 401. The fix is to keep the
/// scrub on the logging path only.)
///
/// Production builds construct no logger and pass everything straight
/// through with no scrubbing work at all.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(Env env)
      : _delegate = env == Env.prod ? null : _buildLogger();

  /// The pretty-printer, or null in production (silent pass-through).
  final Interceptor? _delegate;

  static Interceptor _buildLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 120,
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Log a scrubbed copy into a dead-end handler; forward the real request.
    _delegate?.onRequest(_scrubRequest(options), RequestInterceptorHandler());
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _delegate?.onResponse(
      _scrubResponse(response),
      ResponseInterceptorHandler(),
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (_delegate != null) {
      final scrubbedRequest = _scrubRequest(err.requestOptions);
      final scrubbedResponse = err.response == null
          ? null
          : _scrubResponseFor(err.response!, scrubbedRequest);
      _delegate.onError(
        _rebuildException(err, scrubbedRequest, scrubbedResponse),
        ErrorInterceptorHandler(),
      );
    }
    handler.next(err);
  }

  RequestOptions _scrubRequest(RequestOptions original) {
    return original.copyWith(
      headers: LogScrubber.scrubMap(
        Map<String, dynamic>.from(original.headers),
        LogScrubber.isSensitiveHeader,
      ),
      data: LogScrubber.scrubValue(original.data),
      queryParameters: LogScrubber.scrubMap(
        Map<String, dynamic>.from(original.queryParameters),
        LogScrubber.isSensitiveBody,
      ),
    );
  }

  Response<dynamic> _scrubResponse(Response<dynamic> response) =>
      _scrubResponseFor(response, response.requestOptions);

  Response<dynamic> _scrubResponseFor(
    Response<dynamic> source,
    RequestOptions request,
  ) {
    final scrubbedHeaders = <String, List<String>>{};
    source.headers.forEach((name, values) {
      scrubbedHeaders[name] =
          LogScrubber.isSensitiveHeader(name) ? const ['[REDACTED]'] : values;
    });
    return Response<dynamic>(
      requestOptions: request,
      data: LogScrubber.scrubValue(source.data),
      statusCode: source.statusCode,
      statusMessage: source.statusMessage,
      isRedirect: source.isRedirect,
      redirects: source.redirects,
      extra: source.extra,
      headers: Headers.fromMap(scrubbedHeaders),
    );
  }

  DioException _rebuildException(
    DioException original,
    RequestOptions request,
    Response<dynamic>? response,
  ) {
    return DioException(
      requestOptions: request,
      response: response,
      type: original.type,
      error: original.error,
      stackTrace: original.stackTrace,
      message: original.message,
    );
  }
}

@Riverpod(keepAlive: true)
LoggingInterceptor loggingInterceptor(Ref ref) {
  return LoggingInterceptor(ref.watch(envProvider));
}
