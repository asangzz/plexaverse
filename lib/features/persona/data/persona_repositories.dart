import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/persona_repository.dart';
import '../../../core/platform/file_picking.dart';
import '../../../core/network/failure.dart';
import 'package:dio/dio.dart';

/// Dio-backed [PersonaRepository], reading the real `GET /persona`.
///
/// The previous version composed a partial persona from `/user/preferences`
/// and `/auth/me` because `/persona` had no mobile route. It does now, so this
/// reads the whole thing — including the Substance Bank and the voice-sample
/// count, which the composed version could not see at all and reported as
/// unavailable.
class ApiPersonaRepository implements PersonaRepository {
  const ApiPersonaRepository(this._client);

  final DioClient _client;

  @override
  Future<PersonaSnapshot> fetchPersona() => _guard(_get);

  @override
  Future<PersonaSnapshot> saveAudience({
    String? role,
    String? industry,
    String? problem,
  }) => _guard(() async {
    final Map<String, dynamic> patch = <String, dynamic>{
      'serveRole': ?role,
      'serveIndustry': ?industry,
      'problemSolved': ?problem,
    };
    // Audience lives on the preferences row, so the write is a preferences
    // PATCH; the READ is /persona, which composes it back with the bank.
    if (patch.isNotEmpty) {
      await _client.patch<Map<String, dynamic>>(
        ApiPaths.userPreferences,
        data: patch,
      );
    }
    return _get();
  });

  @override
  Future<FollowerReading?> recordFollowers({
    required int count,
    DateTime? measuredAt,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.personaReach,
      data: <String, dynamic>{
        'followers': count,
        if (measuredAt != null)
          'measuredAt': measuredAt.toUtc().toIso8601String(),
      },
    );
    return _followers(<String, dynamic>{
      'followers': response.data?['followers'],
    });
  }

  @override
  Future<String> importReachExport(PickedFile file) async {
    try {
      final FormData form = FormData.fromMap(<String, dynamic>{
        'file': MultipartFile.fromBytes(file.bytes, filename: file.name),
      });
      final response = await _client.sendMultipart<Map<String, dynamic>>(
        ApiPaths.personaReachImport,
        form,
      );
      final Map<String, dynamic>? data = response.data;
      final int posts = (data?['posts'] as num?)?.toInt() ?? 0;
      return posts > 0
          ? 'Imported $posts posts worth of reach.'
          : 'Imported. Your numbers are up to date.';
    } on DioException catch (e) {
      // 422 carries a message written FOR the user — most often "that does
      // not look like a LinkedIn export", which is the difference between
      // them picking the right file next time and giving up.
      final Object? failure = e.error;
      if (failure is Failure) {
        final String? m = failure.message;
        if (m != null && m.isNotEmpty) return m;
      }
      return "Couldn't read that export.";
    } on Object {
      return "Couldn't read that export.";
    }
  }

  @override
  Future<PersonaSnapshot> harvest() => _guard(() async {
    await _client.post<Map<String, dynamic>>(ApiPaths.personaHarvest);
    return _get();
  });

  @override
  Future<List<PersonaAudience>> suggestAudiences() => _guard(() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.personaAudience,
    );
    final List<dynamic> rows =
        (response.data?['candidates'] as List<dynamic>?) ?? const <dynamic>[];
    return rows
        .whereType<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> m) => PersonaAudience(
            role: m['role'] as String?,
            industry: m['industry'] as String?,
            problem: (m['problem'] ?? m['problemSolved']) as String?,
          ),
        )
        .toList(growable: false);
  });

  @override
  Future<PersonaReply> chat(String message) => _guard(() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.personaChat,
      data: <String, dynamic>{'message': message},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw const PersonaUnavailable();
    return PersonaReply.fromJson(data);
  });

  @override
  Future<PersonaSnapshot> applyProposals(List<PersonaProposal> proposals) =>
      _guard(() async {
        await _client.post<Map<String, dynamic>>(
          ApiPaths.personaApply,
          data: <String, dynamic>{
            'proposals': proposals
                .map(
                  (PersonaProposal p) => <String, dynamic>{
                    'field': p.field,
                    'to': p.to,
                  },
                )
                .toList(growable: false),
          },
        );
        return _get();
      });

  Future<PersonaSnapshot> _get() async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.persona);
    final Map<String, dynamic>? data = response.data;
    if (data == null) throw const PersonaUnavailable();
    return _compose(data);
  }

  /// Maps the `{identity, bank, reach}` payload onto the screen's model.
  ///
  /// The wire shape is not the screen's shape — `identity.brandType` is a
  /// string where the UI wants a bool, and the audience is nested inside
  /// identity where the screen edits it as its own block — so this is an
  /// explicit mapping rather than a generated `fromJson`.
  static PersonaSnapshot _compose(Map<String, dynamic> json) {
    final Map<String, dynamic> identity =
        (json['identity'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final Map<String, dynamic> audience =
        (identity['audience'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final Map<String, dynamic>? bank = json['bank'] as Map<String, dynamic>?;

    List<String> strings(Object? v) => v is List
        ? v.whereType<String>().toList(growable: false)
        : const <String>[];

    return PersonaSnapshot(
      identity: PersonaIdentity(
        name: (identity['name'] as String?) ?? '',
        profession: identity['profession'] as String?,
        headline: identity['headline'] as String?,
        industry: identity['industry'] as String?,
        skills: strings(identity['skills']),
        topics: strings(identity['topics']),
        targetRole: identity['targetRole'] as String?,
        contentMode: (identity['contentMode'] as String?) ?? 'authority',
        isCompany: identity['brandType'] == 'company',
        companyName: identity['companyName'] as String?,
        companyIndustry: identity['companyIndustry'] as String?,
        companyDescription: identity['companyDescription'] as String?,
        companyFeatures: strings(identity['companyFeatures']),
      ),
      audience: PersonaAudience(
        role: audience['role'] as String?,
        industry: audience['industry'] as String?,
        problem: audience['problem'] as String?,
      ),
      // A bank the server could not read reports `unavailable`, which the UI
      // must not render as "empty" — see SubstanceBank.unavailable.
      bank: bank == null
          ? const SubstanceBank(unavailable: true)
          : SubstanceBank.fromJson(bank),
      voiceSampleCount: (identity['voiceSampleCount'] as num?)?.toInt() ?? 0,
      // `reach.followers` has been in this payload since the route existed and
      // was read by nothing — the doc comment above even names `reach` as part
      // of the shape. A field produced and never consumed is indistinguishable
      // from a field that does not exist, which is how the roadmap ended up
      // with checkpoints it could not measure.
      followers: _followers(json['reach']),
    );
  }

  /// `{ reach: { followers: { count, measuredAt } | null } }`, defensively.
  ///
  /// Null at every level is a real state: a user who has never recorded one,
  /// and also a reach read the server could not complete — `getReachSummary`
  /// reports `unavailable` rather than throwing. Both mean "no number", which
  /// is what the checkpoint prompt is for.
  static FollowerReading? _followers(Object? reach) {
    if (reach is! Map<String, dynamic>) return null;
    final Object? followers = reach['followers'];
    if (followers is! Map<String, dynamic>) return null;
    final int? count = (followers['count'] as num?)?.toInt();
    if (count == null) return null;
    return FollowerReading(
      count: count,
      measuredAt: (followers['measuredAt'] as String?) ?? '',
    );
  }

  static Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on PersonaUnavailable {
      rethrow;
    } on Object {
      throw const PersonaUnavailable();
    }
  }
}

/// In-memory [PersonaRepository] for the `mock` flavor.
class FakePersonaRepository implements PersonaRepository {
  FakePersonaRepository();

  static const Duration _latency = Duration(milliseconds: 300);

  PersonaSnapshot _snapshot = const PersonaSnapshot(
    identity: PersonaIdentity(
      name: 'Asang Borkar',
      profession: 'Mobile Application Developer',
      headline: 'Building next-gen apps 🚀',
      industry: 'Software',
      skills: <String>['Flutter', 'Dart', 'Design systems'],
      topics: <String>['Onboarding', 'Developer experience'],
      contentMode: 'authority',
    ),
    audience: PersonaAudience(
      role: 'Engineering manager',
      industry: 'B2B SaaS',
      problem: 'Their first-week onboarding quietly loses people.',
    ),
    voiceSampleCount: 4,
    bank: SubstanceBank(
      availableCount: 2,
      usedCount: 1,
      available: <SubstanceItem>[
        SubstanceItem(
          id: 'sub-1',
          kind: 'story',
          text: 'Cut our onboarding from nine days to three by deleting docs.',
          entities: <String>['onboarding'],
          hasNumber: true,
          source: 'cv',
        ),
        SubstanceItem(
          id: 'sub-2',
          kind: 'result',
          text: 'Mentor pairing lifted 90-day retention by 18%.',
          entities: <String>['mentorship'],
          hasNumber: true,
          source: 'post',
        ),
      ],
      used: <SubstanceItem>[
        SubstanceItem(
          id: 'sub-3',
          kind: 'story',
          text: 'The handover checklist nobody reads.',
          source: 'cv',
          usedInPostId: 'mock-post-1',
        ),
      ],
    ),
  );

  @override
  Future<PersonaSnapshot> fetchPersona() async {
    await Future<void>.delayed(_latency);
    // Reads back what recordFollowers stored. Starting null is deliberate:
    // the mock opens in the state the checkpoint prompt exists for, and a
    // fixture that returned a count would have hidden the prompt entirely on
    // the build this app is manually tested on.
    return _snapshot.copyWith(followers: _recorded);
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

  /// Null to begin with — see fetchPersona.
  FollowerReading? _recorded;

  @override
  Future<FollowerReading?> recordFollowers({
    required int count,
    DateTime? measuredAt,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _recorded = FollowerReading(
      count: count,
      measuredAt: (measuredAt ?? DateTime.now()).toUtc().toIso8601String(),
    );
  }

  @override
  Future<String> importReachExport(PickedFile file) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return 'Imported 24 posts worth of reach.';
  }

  @override
  Future<PersonaSnapshot> harvest() async {
    await Future<void>.delayed(_latency);
    return _snapshot;
  }

  @override
  Future<List<PersonaAudience>> suggestAudiences() async {
    await Future<void>.delayed(_latency);
    return const <PersonaAudience>[
      PersonaAudience(
        role: 'Engineering manager',
        industry: 'B2B SaaS',
        problem: 'Their first-week onboarding quietly loses people.',
      ),
      PersonaAudience(
        role: 'Head of People',
        industry: 'Scale-ups',
        problem: 'New joiners take a quarter to become useful.',
      ),
    ];
  }

  @override
  Future<PersonaReply> chat(String message) async {
    await Future<void>.delayed(_latency);
    return const PersonaReply(
      reply:
          'Got it. Want me to set your audience to engineering managers at '
          'B2B SaaS companies?',
      proposals: <PersonaProposal>[
        PersonaProposal(
          field: 'serveRole',
          to: 'Engineering manager',
          label: 'Audience role',
        ),
      ],
    );
  }

  @override
  Future<PersonaSnapshot> applyProposals(
    List<PersonaProposal> proposals,
  ) async {
    await Future<void>.delayed(_latency);
    for (final PersonaProposal p in proposals) {
      if (p.field == 'serveRole') {
        _snapshot = _snapshot.copyWith(
          audience: _snapshot.audience.copyWith(role: p.to),
        );
      }
    }
    return _snapshot;
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
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
