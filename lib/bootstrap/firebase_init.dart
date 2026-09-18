import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Returns `true` iff Firebase initialised successfully. Initialisation
/// silently no-ops when `firebase_options.dart` and the platform config
/// files (`google-services.json`, `GoogleService-Info.plist`) are absent —
/// that case is expected in fresh checkouts before `flutterfire configure`
/// has been run.
///
/// Every downstream Firebase feature (FCM background handler, push
/// registration, Crashlytics forwarding, Firebase Analytics) is gated on the
/// returned bool so a missing config degrades gracefully instead of crashing
/// boot.
Future<bool> initFirebase() async {
  if (!await _initCore()) return false;
  if (kDebugMode) return true;
  return _enableCrashlytics();
}

Future<bool> _initCore() async {
  try {
    await Firebase.initializeApp();
    return true;
  } on Object catch (error) {
    debugPrint(
      'Firebase.initializeApp() failed: $error\n'
      'Crashlytics + FCM + Analytics will be disabled for this session. '
      'Run `flutterfire configure` to generate firebase_options.dart '
      'and drop google-services.json / GoogleService-Info.plist into '
      'the platform folders.',
    );
    return false;
  }
}

Future<bool> _enableCrashlytics() async {
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    return true;
  } on Object {
    return false;
  }
}
