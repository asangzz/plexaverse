import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/env.dart';

part 'app_logger.g.dart';

/// Logging adapter.
///
///   - Mock/dev/staging: pretty console output.
///   - Prod: warnings + errors only on console; errors are forwarded to
///     Firebase Crashlytics with the current logging context attached.
///
/// PII discipline: structured network traffic is scrubbed upstream by the
/// `LoggingInterceptor` before it ever reaches a log call; as defense in
/// depth this logger also masks token-shaped strings (JWTs, Bearer
/// credentials) inside free-text messages so a careless interpolation can't
/// leak a credential to console or Crashlytics.
///
/// Call `setContext()` from controllers as user-id / tenant-key / request-id
/// become known so multi-step flows are debuggable end-to-end.
abstract class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warn(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});

  /// Updates the logging context. Null values are ignored so callers can
  /// patch one field at a time.
  void setContext({String? userId, String? tenantKey, String? requestId});

  /// Clears every context field. Called on sign-out so the next session
  /// doesn't inherit the previous user's identifiers.
  void clearContext();
}

class AppLoggerImpl implements AppLogger {
  AppLoggerImpl({
    this.env = Env.prod,
    CrashlyticsSink? crashlytics,
  })  : _delegate = Logger(
          level: env == Env.prod ? Level.warning : Level.debug,
          printer: PrettyPrinter(methodCount: 0, colors: false),
        ),
        _crashlytics = crashlytics ?? _CrashlyticsSinkImpl();

  final Env env;
  final Logger _delegate;
  final CrashlyticsSink _crashlytics;

  String? _userId;
  String? _tenantKey;
  String? _requestId;

  /// Three base64url segments separated by dots — the JWT shape. Matched
  /// anywhere in a message so interpolated tokens are masked even mid-string.
  static final RegExp _jwtPattern = RegExp(
    r'[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{5,}',
  );

  /// `Bearer <credential>` fragments (e.g. a pasted Authorization header).
  static final RegExp _bearerPattern = RegExp(
    r'Bearer\s+[A-Za-z0-9._~+/-]+=*',
    caseSensitive: false,
  );

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (env == Env.prod) return;
    _delegate.d(_decorate(message), error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _delegate.i(_decorate(message), error: error, stackTrace: stackTrace);
  }

  @override
  void warn(String message, {Object? error, StackTrace? stackTrace}) {
    _delegate.w(_decorate(message), error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    final scrubbed = _decorate(message);
    _delegate.e(scrubbed, error: error, stackTrace: stackTrace);
    _crashlytics.recordError(
      reason: _scrub(message),
      error: error ?? message,
      stackTrace: stackTrace,
      context: _contextMap(),
    );
    if (kDebugMode) {
      debugPrint('AppLogger.error: $scrubbed\n$error\n$stackTrace');
    }
  }

  @override
  void setContext({String? userId, String? tenantKey, String? requestId}) {
    if (userId != null) _userId = userId;
    if (tenantKey != null) _tenantKey = tenantKey;
    if (requestId != null) _requestId = requestId;
    _crashlytics.setIdentifiers(
      userId: _userId,
      tenantKey: _tenantKey,
      requestId: _requestId,
    );
  }

  @override
  void clearContext() {
    _userId = null;
    _tenantKey = null;
    _requestId = null;
    _crashlytics.setIdentifiers(
      userId: null,
      tenantKey: null,
      requestId: null,
    );
  }

  String _decorate(String message) {
    final scrubbed = _scrub(message);
    final parts = <String>[];
    if (_tenantKey != null) parts.add('tenant=$_tenantKey');
    if (_userId != null) parts.add('user=$_userId');
    if (_requestId != null) parts.add('req=$_requestId');
    if (parts.isEmpty) return scrubbed;
    return '${parts.join(' ')} | $scrubbed';
  }

  /// Masks credential-shaped substrings. Cheap regex pass on the message
  /// only — structured payload scrubbing belongs to `LogScrubber` in the
  /// network layer; this is the last line of defense for free text.
  String _scrub(String message) {
    return message
        .replaceAll(_bearerPattern, 'Bearer [REDACTED]')
        .replaceAll(_jwtPattern, '[REDACTED]');
  }

  Map<String, String> _contextMap() {
    final out = <String, String>{};
    final u = _userId;
    final t = _tenantKey;
    final r = _requestId;
    if (u != null) out['userId'] = u;
    if (t != null) out['tenantKey'] = t;
    if (r != null) out['requestId'] = r;
    return out;
  }
}

/// Indirection so tests / dev builds can plug in a fake sink. The default
/// implementation forwards to `FirebaseCrashlytics.instance`.
abstract class CrashlyticsSink {
  void recordError({
    required String reason,
    required Object error,
    StackTrace? stackTrace,
    Map<String, String> context = const <String, String>{},
  });
  void setIdentifiers({String? userId, String? tenantKey, String? requestId});
}

class _CrashlyticsSinkImpl implements CrashlyticsSink {
  @override
  void recordError({
    required String reason,
    required Object error,
    StackTrace? stackTrace,
    Map<String, String> context = const <String, String>{},
  }) {
    if (kDebugMode) return;
    final c = FirebaseCrashlytics.instance;
    for (final entry in context.entries) {
      // Best-effort; Crashlytics keys are length-limited (64 chars) and
      // values are clamped server-side.
      c.setCustomKey(entry.key, entry.value);
    }
    c.recordError(error, stackTrace, reason: reason, fatal: false);
  }

  @override
  void setIdentifiers({String? userId, String? tenantKey, String? requestId}) {
    if (kDebugMode) return;
    final c = FirebaseCrashlytics.instance;
    if (userId != null) c.setUserIdentifier(userId);
    if (tenantKey != null) c.setCustomKey('tenantKey', tenantKey);
    if (requestId != null) c.setCustomKey('requestId', requestId);
  }
}

@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  return AppLoggerImpl(env: ref.watch(envProvider));
}
