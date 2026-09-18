import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the biometric app-lock preferences.
///
/// Two distinct flags:
///   - the one-time opt-in ANSWER (`_key`): whether the user has been asked at
///     all. The behavioural constraint is to ask **once** — accept, decline, or
///     dismiss (dismissal = decline) — and never re-prompt automatically; the
///     user re-enables later from Settings.
///   - the current ON/OFF state (`_enabledKey`): what the lock gate and the
///     Security toggle read/write. Can be turned on (after a live biometric
///     check) or off again independently of the opt-in answer.
///
/// A preference, not a secret, so `SharedPreferences` is the right store — the
/// biometric key material itself lives in the platform keystore (`local_auth`).
class BiometricPrefs {
  static const String _key = 'biometric_opt_in';
  static const String _enabledKey = 'biometric_unlock_enabled';

  /// True once the user has answered the prompt either way.
  Future<bool> hasResponded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }

  /// True only if they explicitly accepted.
  Future<bool> accepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> record({required bool accepted}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, accepted);
  }

  /// Whether biometric app-unlock is currently switched ON — the flag the lock
  /// gate ([AppLock]) and the Settings toggle read/write.
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<void> setEnabled({required bool enabled}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }
}

final biometricPrefsProvider =
    Provider<BiometricPrefs>((ref) => BiometricPrefs());
