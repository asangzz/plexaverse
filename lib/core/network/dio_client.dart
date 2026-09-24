import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_environment.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/offline_gate_interceptor.dart';
import 'network_config.dart';

part 'dio_client.g.dart';

/// Adapter over `Dio`. Features receive a [DioClient] via Riverpod and
/// never import `dio` directly (§2.4 DIP, `direct_package_import` lint).
///
/// PARSE SEAM — the Plexaverse mobile API wraps every payload in a
/// `{data, error, meta}` envelope. Per RULINGS ruling 7 the unwrap lives
/// HERE, at the DioClient parse seam, not in a `ResponseUnwrapInterceptor`
/// (retired). Each verb runs the raw response through [_unwrap], which:
///   - if the body carries a non-null `error` object, throws a
///     [DioException] whose `error` is the mapped [Failure] (same shape a
///     repository sees for any transport/status failure — so `catch
///     (DioException e)` → `e.error as Failure` branching is uniform);
///   - otherwise replaces `response.data` with the inner `data` value so
///     callers deserialise the payload directly (a bare `{...}` with no
///     envelope keys is passed through untouched for forward-compat).
class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return _unwrap<T>(response);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    return _unwrap<T>(response);
  }

  /// PATCH.
  ///
  /// The mobile API prefers PATCH over PUT for partial updates — user
  /// preferences, a planner slot, a post, a schedule, a topic, marking a
  /// notification read. It deliberately exposes no PUT on mobile at all, so a
  /// client that only knows `put` cannot perform most writes. This verb was
  /// missing from the client entirely.
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return _unwrap<T>(response);
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _unwrap<T>(response);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return _unwrap<T>(response);
  }

  /// Used by MultipartUploader. Kept inside the adapter so feature code
  /// never touches FormData directly.
  Future<Response<T>> sendMultipart<T>(
    String path,
    FormData data, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      options: Options(sendTimeout: NetworkConfig.sendTimeout),
    );
    return _unwrap<T>(response);
  }

  void close({bool force = false}) => _dio.close(force: force);

  /// Unwraps the `{data, error, meta}` Plexaverse mobile-API envelope
  /// (RULINGS ruling 7). Non-Map bodies (e.g. `List` list endpoints that
  /// aren't enveloped, or `null`/`void` responses) pass straight through.
  ///
  /// **Every verb fetches as `dynamic` and this is what applies `T`.** It used
  /// to hand `T` to Dio, which casts the body to it inside `fetch` — i.e.
  /// BEFORE the envelope is opened. So `T` was silently a claim about the
  /// ENVELOPE rather than the payload, and the two only agree when the payload
  /// is itself a Map. `get<List<dynamic>>` on any list endpoint threw
  /// `_Map<String, dynamic> is not a subtype of List<dynamic>` from inside
  /// Dio, before a line of ours ran. The Season 1 recap counted published
  /// posts that way, caught the TypeError with the same `on Object` that
  /// catches a dead network, and told the user their season did not load —
  /// while every request behind it had returned 200.
  ///
  /// Casting here instead makes `T` mean what the doc above always said it
  /// meant: the type of the PAYLOAD. A mismatch still throws, but at this
  /// seam, naming the payload type the caller actually got.
  Response<T> _unwrap<T>(Response<dynamic> response) {
    final body = response.data;
    if (body is! Map) return _retype<T>(response, body);

    final apiError = body['error'];
    if (apiError != null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: _failureFromEnvelope(apiError, response.statusCode),
      );
    }

    // Keep `meta` before the payload replaces the envelope.
    //
    // Cursor pagination lives ONLY in `meta.pagination` ({cursor, hasMore,
    // limit}) — the list endpoints return a bare array as `data`. Replacing
    // the envelope therefore used to throw the cursor away, which made every
    // paginated endpoint on the API unreachable past its first page. Stashing
    // it in `extra` keeps the `data` contract every repository already relies
    // on, and [envelopeMeta] reads it back.
    final Object? meta = body['meta'];
    if (meta is Map) {
      response.extra = <String, dynamic>{
        ...response.extra,
        _metaKey: Map<String, dynamic>.from(meta),
      };
    }

    // The inner payload replaces the envelope. A bare `{...}` with no `data`
    // key is passed through untouched, for forward-compat.
    return _retype<T>(
      response,
      body.containsKey('data') ? body['data'] : body,
    );
  }

  /// Re-types a response around [payload], preserving everything else.
  ///
  /// The cast is to `T?`, not `T`: an envelope may legitimately carry
  /// `"data": null` — a write that answers with nothing, a read of something
  /// absent — and `null as T` threw for every caller that named a type. The
  /// nullability is already in the signature, since `Response.data` is `T?`
  /// and every caller has to handle the null.
  Response<T> _retype<T>(Response<dynamic> response, Object? payload) =>
      Response<T>(
        data: payload as T?,
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        extra: response.extra,
        headers: response.headers,
      );

  static const String _metaKey = 'plexaverse.envelope.meta';

  /// The envelope's `meta` for a response, or null when it carried none.
  ///
  /// Use it for `meta.pagination`:
  /// ```dart
  /// final page = DioClient.envelopeMeta(response)?['pagination'] as Map?;
  /// final cursor = page?['cursor'] as String?;
  /// ```
  static Map<String, dynamic>? envelopeMeta(Response<Object?> response) =>
      response.extra[_metaKey] as Map<String, dynamic>?;

  /// Maps an envelope `error` object to a [Failure]. Runs at the parse seam
  /// (after interceptors), so it mirrors [ErrorInterceptor]'s status table
  /// for the envelope's own `statusCode`/`errorCode`/`message` fields; a
  /// 2xx transport with an envelope error defaults to [ServerFailure].
  Failure _failureFromEnvelope(Object apiError, int? httpStatus) {
    final map = apiError is Map ? apiError : const <String, dynamic>{};
    final message = _stringOrNull(map['message']);
    final errorCode = _stringOrNull(map['errorCode'] ?? map['code']);
    final status = (map['statusCode'] as num?)?.toInt() ?? httpStatus;

    if (status == 401 || status == 403) {
      return AuthFailure(message: message, errorCode: errorCode);
    }
    if (status == 404) {
      return NotFoundFailure(message: message, errorCode: errorCode);
    }
    if (status == 422 || map['fieldErrors'] is Map || map['errors'] is Map) {
      return ValidationFailure(
        message: message,
        errorCode: errorCode,
        fieldErrors: _fieldErrors(map),
      );
    }
    if (status != null && status >= 400 && status < 500) {
      return ClientFailure(
        message: message,
        errorCode: errorCode,
        statusCode: status,
      );
    }
    return ServerFailure(
      message: message,
      errorCode: errorCode,
      statusCode: status,
    );
  }

  Map<String, String> _fieldErrors(Map<dynamic, dynamic> map) {
    final raw = map['fieldErrors'] ?? map['errors'];
    if (raw is! Map) return const <String, String>{};
    final out = <String, String>{};
    raw.forEach((key, value) {
      if (value is String) {
        out[key.toString()] = value;
      } else if (value is List && value.isNotEmpty) {
        out[key.toString()] = value.first.toString();
      }
    });
    return out;
  }

  String? _stringOrNull(Object? value) =>
      value is String && value.isNotEmpty ? value : null;
}

/// Base URL is env-derived ([apiBaseUrl]) so dev/stage/live is config-only.
/// Only materialised when a real (non-mock) repository is resolved, i.e.
/// when `useFakeBackend` is false.
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
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
  )..interceptors.addAll([
      // First: online-first fast-fail while offline (no 15s timeout burn).
      ref.read(offlineGateInterceptorProvider),
      ref.read(authInterceptorProvider),
      ref.read(loggingInterceptorProvider),
      ref.read(errorInterceptorProvider),
    ]);

  ref.onDispose(() => dio.close(force: true));
  return DioClient(dio);
}
