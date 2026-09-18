import 'package:dio/dio.dart';

/// Centralised PII / secret scrubbing used by [LoggingInterceptor].
///
/// Lives in its own file so the interceptor itself stays under the
/// `class_too_long` / `file_too_long` caps and the scrubbing policy is
/// easy to unit-test in isolation (§6, §12 PII discipline).
class LogScrubber {
  const LogScrubber._();

  static const _redacted = '[REDACTED]';

  static const _sensitiveHeaderKeys = <String>{
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'proxy-authorization',
    'x-csrf-token',
    'x-session-id',
  };

  static const _sensitiveBodyKeys = <String>{
    'password',
    'newpassword',
    'oldpassword',
    'access_token',
    'accesstoken',
    'refresh_token',
    'refreshtoken',
    'token',
    'jwt',
    'secret',
    'apikey',
    'api_key',
    'pin',
    'otp',
    'signature',
    'driverlicense',
    'driver_license',
    'nationalid',
    'national_id',
    'taxid',
    'tax_id',
  };

  static bool isSensitiveHeader(String key) =>
      _sensitiveHeaderKeys.contains(key.toLowerCase());

  static bool isSensitiveBody(String key) =>
      _sensitiveBodyKeys.contains(_normalize(key));

  static String _normalize(String key) =>
      key.toLowerCase().replaceAll('-', '').replaceAll('_', '');

  /// Recursively scrubs nested maps / lists. Strings shaped like JWTs are
  /// also redacted even when they appear under non-sensitive keys.
  static Object? scrubValue(Object? value) {
    if (value is Map) {
      return scrubMap(
        Map<String, dynamic>.from(
          value.map((key, val) => MapEntry(key.toString(), val)),
        ),
        isSensitiveBody,
      );
    }
    if (value is List) return value.map(scrubValue).toList();
    if (value is String && _looksLikeJwt(value)) return _redacted;
    if (value is FormData) {
      return '[FormData fields=${value.fields.length} '
          'files=${value.files.length}]';
    }
    return value;
  }

  static Map<String, dynamic> scrubMap(
    Map<String, dynamic> map,
    bool Function(String key) isSensitive,
  ) {
    final out = <String, dynamic>{};
    map.forEach((key, value) {
      out[key] = isSensitive(key) ? _redacted : scrubValue(value);
    });
    return out;
  }

  static bool _looksLikeJwt(String value) {
    if (value.length < 20 || !value.contains('.')) return false;
    final parts = value.split('.');
    if (parts.length != 3) return false;
    for (final part in parts) {
      if (part.isEmpty) return false;
      if (!_isBase64UrlSafe(part)) return false;
    }
    return true;
  }

  static bool _isBase64UrlSafe(String value) {
    for (final code in value.codeUnits) {
      final isDigit = code >= 0x30 && code <= 0x39;
      final isUpper = code >= 0x41 && code <= 0x5A;
      final isLower = code >= 0x61 && code <= 0x7A;
      final isSymbol = code == 0x2D || code == 0x5F || code == 0x3D;
      if (!isDigit && !isUpper && !isLower && !isSymbol) return false;
    }
    return true;
  }
}
