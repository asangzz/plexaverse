import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../failure.dart';

part 'error_interceptor.g.dart';

/// Wire `DioException` -> app [Failure] (§6). This is the SINGLE mapping
/// point: it re-wraps the exception with `error: <Failure>`, so downstream
/// repositories `catch (DioException e)` once at the boundary and read
/// `e.error` (a [Failure]) — they never inspect raw status codes.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        stackTrace: err.stackTrace,
      ),
    );
  }

  Failure _mapToFailure(DioException error) {
    final response = error.response;
    final ctx = _FailureCtx(
      status: response?.statusCode,
      data: response?.data,
      message: _extractMessage(response?.data),
      errorCode: _extractErrorCode(response?.data),
    );
    return _mapTransport(error, ctx) ?? _mapStatus(ctx);
  }

  Failure? _mapTransport(DioException error, _FailureCtx ctx) {
    switch (error.type) {
      // We never reached the server, or could not trust it. Retrying, or
      // checking the connection, is the right advice.
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkFailure(message: ctx.message, errorCode: ctx.errorCode);
      // We DID reach the server and it is still working. Telling someone to
      // check their network here sends them to fix the one thing that is not
      // broken — see [TimeoutFailure].
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(message: ctx.message, errorCode: ctx.errorCode);
      case DioExceptionType.cancel:
        return UnknownFailure(message: ctx.message, errorCode: ctx.errorCode);
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return null;
    }
  }

  Failure _mapStatus(_FailureCtx ctx) {
    final status = ctx.status;
    if (status == null) {
      return UnknownFailure(message: ctx.message, errorCode: ctx.errorCode);
    }
    if (status == 401 || status == 403) {
      return AuthFailure(message: ctx.message, errorCode: ctx.errorCode);
    }
    if (status == 404) {
      return NotFoundFailure(message: ctx.message, errorCode: ctx.errorCode);
    }
    if (_isTransient(status)) {
      return NetworkFailure(message: ctx.message, errorCode: ctx.errorCode);
    }
    if (_isValidation(status, ctx.data)) return _validation(ctx);
    return _mapServerOrClient(ctx, status);
  }

  bool _isTransient(int status) =>
      status == 408 || status == 429 || status == 503 || status == 504;

  bool _isValidation(int status, Object? data) =>
      status == 422 || (status == 400 && _hasFieldErrors(data));

  Failure _validation(_FailureCtx ctx) {
    return ValidationFailure(
      message: ctx.message,
      errorCode: ctx.errorCode,
      fieldErrors: _extractFieldErrors(ctx.data),
    );
  }

  Failure _mapServerOrClient(_FailureCtx ctx, int status) {
    if (status >= 500) {
      return ServerFailure(
        message: ctx.message,
        errorCode: ctx.errorCode,
        statusCode: status,
      );
    }
    return ClientFailure(
      message: ctx.message,
      errorCode: ctx.errorCode,
      statusCode: status,
    );
  }

  static const _messageKeys = <String>[
    'message',
    'error_message',
    'errorMessage',
    'error',
    'detail',
    'title',
  ];

  String? _extractMessage(Object? data) {
    if (data is! Map) return null;
    for (final key in _messageKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
      // Some backends nest: { error: { message: "..." } }.
      if (value is Map) {
        final inner = value['message'];
        if (inner is String && inner.isNotEmpty) return inner;
      }
    }
    return null;
  }

  static const _errorCodeKeys = <String>[
    'errorCode',
    'error_code',
    'code',
  ];

  /// The stable code, from the top level or from inside `error`.
  ///
  /// ## Why the nested case is not an edge case
  ///
  /// It is OUR case. The mobile API answers every rejection with
  /// `{data: null, error: {code, message}, meta}` (RULINGS ruling 7), so the
  /// code is never at the top level of a 4xx body. Reading only the top
  /// level left `Failure.errorCode` null for every enveloped rejection in
  /// the app, which meant each `switch (failure.errorCode)` fell through to
  /// its generic branch: "you have not connected a company page", "you are
  /// out of XP", "that is not a post day" and "you spent the five hearts"
  /// all arrived as "something went wrong".
  ///
  /// Two slices found this and worked around it by reaching past [Failure]
  /// into the raw body (`company`, `engagement`), each noting that the fix
  /// belonged here. This is that fix; those workarounds still read the same
  /// value and are unaffected.
  ///
  /// `_extractMessage` has always handled the nesting. The asymmetry between
  /// the two was the whole bug — the message came through and the code did
  /// not, so a failure looked specific and branched generic.
  String? _extractErrorCode(Object? data) {
    if (data is! Map) return null;
    final String? top = _codeIn(data);
    if (top != null) return top;
    final Object? nested = data['error'];
    return nested is Map ? _codeIn(nested) : null;
  }

  String? _codeIn(Map<dynamic, dynamic> map) {
    for (final key in _errorCodeKeys) {
      final value = map[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is num) return value.toString();
    }
    return null;
  }

  bool _hasFieldErrors(Object? data) => _fieldMap(data) != null;

  /// Per-field messages, wherever this API puts them.
  ///
  /// OURS calls them `error.fields` — nested, and spelled differently from
  /// the `fieldErrors` / `errors` this looked for at the top level. So
  /// `ValidationFailure.fieldErrors` was always empty, and the per-field
  /// text that `POST /auth/register` goes to the trouble of building (which
  /// field was already taken, which password was too short) never reached a
  /// form. The legacy spellings are kept: they cost nothing and this
  /// interceptor is not only ours to feed.
  Map<dynamic, dynamic>? _fieldMap(Object? data) {
    if (data is! Map) return null;
    for (final Object? candidate in <Object?>[
      data['fieldErrors'],
      data['errors'],
      if (data['error'] is Map) (data['error'] as Map)['fields'],
    ]) {
      if (candidate is Map) return candidate;
    }
    return null;
  }

  Map<String, String> _extractFieldErrors(Object? data) {
    final Map<dynamic, dynamic>? raw = _fieldMap(data);
    if (raw == null) return const <String, String>{};
    final out = <String, String>{};
    raw.forEach((key, value) {
      if (value is String) {
        out[key.toString()] = value;
      } else if (value is List && value.isNotEmpty) {
        out[key.toString()] = value.first.toString();
      } else if (value is Map && value['message'] is String) {
        out[key.toString()] = value['message'] as String;
      }
    });
    return out;
  }
}

@Riverpod(keepAlive: true)
ErrorInterceptor errorInterceptor(Ref ref) {
  return ErrorInterceptor();
}

/// Internal carrier used by [ErrorInterceptor] to keep `_mapTransport` /
/// `_mapStatus` under the positional-argument cap.
class _FailureCtx {
  const _FailureCtx({
    required this.status,
    required this.data,
    required this.message,
    required this.errorCode,
  });

  final int? status;
  final Object? data;
  final String? message;
  final String? errorCode;
}
