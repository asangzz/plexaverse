import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';

/// Wires `FlutterError.onError` and `PlatformDispatcher.onError` to funnel
/// uncaught errors through [AppLogger] (which handles PII scrubbing and, in
/// release, Crashlytics forwarding of `error()`). This is the second of the
/// three error layers designed in ProHealth §3a:
///
///   (a) the `runZonedGuarded` handler in `bootstrap.dart` — last resort;
///   (b) *this* framework funnel — the common path for widget-build and
///       platform-callback errors;
///   (c) explicit `try/catch` in feature code.
///
/// When [firebaseReady] is false, the Crashlytics branches are skipped — the
/// logger still records to console.
///
/// NOTE (RULINGS ruling 2 / bootstrap-flavors.md): ProHealth *defines* this
/// but never calls it (a documented wiring gap). This port fixes the gap —
/// `bootstrap.dart` actually invokes `attachErrorHandlers(...)` after the
/// logger is built, once `firebaseReady` is known.
void attachErrorHandlers({
  required AppLogger logger,
  required bool firebaseReady,
}) {
  FlutterError.onError = (details) {
    logger.error(
      'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (firebaseReady && !kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('PlatformDispatcher', error: error, stackTrace: stack);
    if (firebaseReady && !kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
}
