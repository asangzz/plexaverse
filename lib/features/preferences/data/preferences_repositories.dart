import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/preferences_repository.dart';

/// Dio-backed [PreferencesRepository].
class ApiPreferencesRepository implements PreferencesRepository {
  const ApiPreferencesRepository(this._client);

  final DioClient _client;

  @override
  Future<UserPreferences> fetch() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userPreferences,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PreferencesUnavailable();
      return UserPreferences.fromJson(data);
    } on PreferencesUnavailable {
      rethrow;
    } on Object {
      throw const PreferencesUnavailable();
    }
  }

  @override
  Future<UserPreferences> patch(Map<String, dynamic> patch) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        ApiPaths.userPreferences,
        data: patch,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const PreferencesUnavailable();
      // PATCH answers with the preferences row but without the `exists`
      // sentinel the GET adds, so re-assert it: a row we just wrote exists by
      // definition, and letting it default to false would bounce the user back
      // into onboarding on the next read of this object.
      return UserPreferences.fromJson(<String, dynamic>{
        'exists': true,
        ...data,
      });
    } on PreferencesUnavailable {
      rethrow;
    } on Object {
      throw const PreferencesUnavailable();
    }
  }
}

/// In-memory [PreferencesRepository] for the `mock` flavor.
class FakePreferencesRepository implements PreferencesRepository {
  FakePreferencesRepository();

  static const Duration _latency = Duration(milliseconds: 250);

  UserPreferences _preferences = const UserPreferences(
    exists: true,
    onboardingCompleted: true,
    brandType: 'personal',
    postsPerWeek: 7,
    preferredDays: <int>[1, 3, 5],
    preferredTime: '09:00',
    timezone: 'Asia/Kolkata',
    profession: 'Mobile Application Developer',
    headline: 'Building next-gen apps 🚀',
    industry: 'Software',
    approvalChannel: 'slack',
    skills: <String>['Flutter', 'Dart', 'Design systems'],
    postCategories: <String>['Engineering', 'Career'],
  );

  @override
  Future<UserPreferences> fetch() async {
    await Future<void>.delayed(_latency);
    return _preferences;
  }

  @override
  Future<UserPreferences> patch(Map<String, dynamic> patch) async {
    await Future<void>.delayed(_latency);
    // Round-trip through JSON so the fake applies a patch exactly the way the
    // server does — by key, onto the existing row — instead of hand-copying
    // fields and quietly drifting from the real merge.
    _preferences = UserPreferences.fromJson(<String, dynamic>{
      ..._preferences.toJson(),
      ...patch,
      'exists': true,
    });
    return _preferences;
  }

  /// Lets the settings slice's auto-post toggle keep the fake row in step.
  void setAutoPostEnabled(bool enabled) {
    _preferences = _preferences.copyWith(autoPostEnabled: enabled);
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<PreferencesRepository> preferencesRepositoryProvider =
    Provider<PreferencesRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePreferencesRepository();
      return ApiPreferencesRepository(ref.watch(dioClientProvider));
    });
