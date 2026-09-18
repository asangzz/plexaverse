import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'screen_protection_prefs.g.dart';

/// Persists whether screenshot / screen-recording protection is ON.
///
/// Defaults to ON (protected). Turning it OFF lets the screen be shared or
/// recorded — e.g. when demoing the app over a screen-share in a meeting.
/// Surfaced from Settings → Security.
class ScreenProtectionPrefs {
  static const String _key = 'screen_protection_enabled';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  Future<void> setEnabled({required bool enabled}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, enabled);
  }
}

/// App-wide screenshot / screen-share protection setting. When `false`,
/// [SecureScreen] stops applying Android `FLAG_SECURE` / iOS obscuring so the
/// screen can be shared. Toggled from Settings → Security.
@Riverpod(keepAlive: true)
class ScreenProtection extends _$ScreenProtection {
  @override
  Future<bool> build() => ScreenProtectionPrefs().isEnabled();

  Future<void> set({required bool enabled}) async {
    await ScreenProtectionPrefs().setEnabled(enabled: enabled);
    state = AsyncData<bool>(enabled);
  }
}
