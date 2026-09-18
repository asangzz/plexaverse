import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/settings/domain/settings_profile.dart';

/// Verifies the bundled Settings profile fixture under `assets/mock/settings/`
/// deserialises through the real [SettingsProfile.fromJson] after the
/// `field_rename: snake` → `none` migration.
///
/// The fixture is read exactly as `PrefsSettingsRepository.fetchProfile` reads
/// it: a single top-level object parsed straight through the model. Settings is
/// local-only in v1 — theme mode and locale are prefs — but the profile header
/// is JSON-parsed, so its fixture must match the camelCase [fromJson] keys.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const path = 'assets/mock/settings/profile.json';

  Future<Map<String, dynamic>> load(String p) async =>
      jsonDecode(await rootBundle.loadString(p)) as Map<String, dynamic>;

  test('$path parses through SettingsProfile', () async {
    final json = await load(path);

    final profile = SettingsProfile.fromJson(json);
    expect(profile.id, isNotEmpty);
    expect(profile.displayName, isNotEmpty);
    expect(profile.handle, isNotEmpty);
    expect(profile.email, contains('@'));
    // Optional camelCase fields present in the fixture round-trip cleanly.
    expect(profile.avatarUrl, isNotNull);
    expect(profile.memberSince, isNotNull);
  });

  test('profile fixture carries the demo identity', () async {
    final json = await load(path);
    final profile = SettingsProfile.fromJson(json);
    expect(profile.displayName, 'Ava Sinclair');
    expect(profile.email, 'ava.sinclair@plexaverse.com');
    // Derived getters work off the parsed fields.
    expect(profile.initials, 'AS');
    expect(profile.handleDisplay, '@avasinclair');
    expect(profile.memberSince, DateTime.parse('2023-04-18'));
  });
}
