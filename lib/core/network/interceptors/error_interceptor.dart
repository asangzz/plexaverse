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
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkFailure(message: ctx.message, errorCode: ctx.errorCode);
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

  String? _extractErrorCode(Object? data) {
    if (data is! Map) return null;
    for (final key in _errorCodeKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is num) return value.toString();
    }
    return null;
  }

  bool _hasFieldErrors(Object? data) =>
      data is Map && (data['fieldErrors'] is Map || data['errors'] is Map);

  Map<String, String> _extractFieldErrors(Object? data) {
    if (data is! Map) return const <String, String>{};
    final raw = data['fieldErrors'] ?? data['errors'];
    if (raw is! Map) return const <String, String>{};
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
