import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../preferences/domain/user_preferences.dart';
import '../domain/persona_repository.dart';

/// Dio-backed [PersonaRepository], composed from `/user/preferences` and
/// `/auth/me`.
///
/// ## Why the raw preferences map is read alongside the typed model
///
/// `UserPreferences` (owned by `features/preferences`) models the subset of the
/// row the rest of the app reads, and it does **not** carry `serveRole`,
/// `serveIndustry` or `problemSolved` — the three audience columns this screen
/// exists to edit. That file belongs to another slice, so rather than reach in
/// and change it, this repository parses the typed model for everything it
/// covers and lifts those three keys off the same JSON map. The request to add
/// them to the shared model is in the hand-off summary; when it lands, the
/// three `_string` calls below collapse into field reads.
class ApiPersonaRepository implements PersonaRepository {
  const ApiPersonaRepository(this._client);

  final DioClient _client;

  @override
  Future<PersonaSnapshot> fetchPersona() async {
    try {
      // Two independent reads, in parallel: neither depends on the other, and
      // a phone pays for every serial round-trip.
      final List<Map<String, dynamic>> results = await Future.wait(
        <Future<Map<String, dynamic>>>[_getPreferences(), _getMe()],
      );
      return _compose(preferences: results[0], me: results[1]);
    } on PersonaUnavailable {
      rethrow;
    } on Object {
      throw const PersonaUnavailable();
    }
  }

  @override
  Future<PersonaSnapshot> saveAudience({
    String? role,
    String? industry,
    String? problem,
  }) async {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (role != null) patch['serveRole'] = role;
    if (industry != null) patch['serveIndustry'] = industry;
    if (problem != null) patch['problemSolved'] = problem;

    try {
      final Map<String, dynamic> updated = patch.isEmpty
          ? await _getPreferences()
          : await _patchPreferences(patch);
      final Map<String, dynamic> me = await _getMe();
      return _compose(preferences: updated, me: me);
    } on PersonaUnavailable {
      rethrow;
    } on Object {
      throw const PersonaUnavailable();
    }
  }

  Future<Map<String, dynamic>> _getPreferences() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.userPreferences,
    );
    return response.data ?? const <String, dynamic>{};
  }

  Future<Map<String, dynamic>> _patchPreferences(
    Map<String, dynamic> patch,
  ) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.userPreferences,
      data: patch,
    );
    return response.data ?? const <String, dynamic>{};
  }

  Future<Map<String, dynamic>> _getMe() async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.me);
    return response.data ?? const <String, dynamic>{};
  }

  /// Trims to null. A column holding `''` means the same thing as one holding
  /// null here, and the UI has exactly one "not set yet" state to render.
  static String? _string(Map<String, dynamic> map, String key) {
    final Object? value = map[key];
    if (value is! String) return null;
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static PersonaSnapshot _compose({
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> me,
  }) {
    final UserPreferences prefs = UserPreferences.fromJson(preferences);
    final Map<String, dynamic>? user = me['user'] as Map<String, dynamic>?;

    return PersonaSnapshot(
      identity: PersonaIdentity(
        name: user == null ? '' : (_string(user, 'name') ?? ''),
        profession: prefs.profession,
        headline: prefs.headline,
        industry: prefs.industry,
        skills: prefs.skills,
        topics: prefs.postCategories,
        targetRole: prefs.targetRole,
        contentMode: prefs.contentMode,
        isCompany: prefs.isCompany,
        companyName: prefs.companyPageName,
        companyIndustry: prefs.companyIndustry,
        companyDescription: prefs.companyDescription,
        companyFeatures: prefs.companyFeatures,
      ),
      audience: PersonaAudience(
        role: _string(preferences, 'serveRole'),
        industry: _string(preferences, 'serveIndustry'),
        problem: _string(preferences, 'problemSolved'),
      ),
    );
  }
}

/// In-memory [PersonaRepository] for the `mock` flavor.
///
/// Starts with an UNSET audience, because that is the state the screen is
/// really for — a set audience is a static block of text and tells you nothing
/// about whether the form works.
class FakePersonaRepository implements PersonaRepository {
  FakePersonaRepository();

  PersonaSnapshot _snapshot = const PersonaSnapshot(
    identity: PersonaIdentity(
      name: 'Asang Borkar',
      profession: 'Mobile Application Developer',
      headline: 'Building next-gen apps',
      industry: 'Software',
      skills: <String>['Flutter', 'Dart', 'Design systems', 'CI/CD'],
      topics: <String>['Engineering', 'Career', 'Design'],
      targetRole: 'Principal Engineer',
    ),
  );

  static const Duration _latency = Duration(milliseconds: 220);

  @override
  Future<PersonaSnapshot> fetchPersona() async {
    await Future<void>.delayed(_latency);
    return _snapshot;
  }

  @override
  Future<PersonaSnapshot> saveAudience({
    String? role,
    String? industry,
    String? problem,
  }) async {
    await Future<void>.delayed(_latency);
    _snapshot = _snapshot.copyWith(
      audience: _snapshot.audience.copyWith(
        role: role ?? _snapshot.audience.role,
        industry: industry ?? _snapshot.audience.industry,
        problem: problem ?? _snapshot.audience.problem,
      ),
    );
    return _snapshot;
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake.
final Provider<PersonaRepository> personaRepositoryProvider =
    Provider<PersonaRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePersonaRepository();
      return ApiPersonaRepository(ref.watch(dioClientProvider));
    });
