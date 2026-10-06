import '../../../core/mock/mock_constants.dart';
import '../../home/domain/roadmap_level.dart';
import '../../home/domain/roadmap_planets.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/missions_repository.dart';

/// Dio-backed [MissionsRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner object.
class ApiMissionsRepository implements MissionsRepository {
  const ApiMissionsRepository(this._client);

  final DioClient _client;

  /// Lifts `user.linkedinAccounts[0].profileSlug` out of the preferences
  /// payload without modelling the whole nested `user` object.
  static String? _slugOf(Map<String, dynamic> json) {
    final Object? user = json['user'];
    if (user is! Map<String, dynamic>) return null;
    final Object? accounts = user['linkedinAccounts'];
    if (accounts is! List || accounts.isEmpty) return null;
    final Object? first = accounts.first;
    if (first is! Map<String, dynamic>) return null;
    final Object? slug = first['profileSlug'];
    return slug is String && slug.isNotEmpty ? slug : null;
  }

  static MissionProfile _profileOf(
    Map<String, dynamic>? json, {
    String? displayName,
  }) {
    if (json == null) return MissionProfile(displayName: displayName);
    return MissionProfile(
      preferences: UserPreferences.fromJson(json),
      linkedinSlug: _slugOf(json),
      displayName: displayName,
    );
  }

  @override
  Future<MissionProfile> fetchProfile() async {
    try {
      // Two reads, overlapped: the preferences row carries everything the
      // missions edit, and `/auth/me` carries the display name the banner
      // substitutes into its templates. The name request is started first and
      // awaited last, so the two are in flight together without this layer
      // having to reach for Dio's own types.
      final Future<String?> name = _displayName();
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userPreferences,
      );
      return _profileOf(response.data, displayName: await name);
    } on Object {
      throw const MissionUnavailable();
    }
  }

  /// The signed-in user's name. A failure here is deliberately swallowed: a
  /// missing name costs the banner its personalisation, and must not cost the
  /// user the whole screen.
  Future<String?> _displayName() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.me);
      final Object? user = response.data?['user'];
      if (user is! Map<String, dynamic>) return null;
      final Object? name = user['name'];
      return name is String && name.isNotEmpty ? name : null;
    } on Object {
      return null;
    }
  }

  @override
  Future<MissionProfile> updatePreferences(Map<String, dynamic> patch) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        ApiPaths.userPreferences,
        data: patch,
      );
      // The PATCH answer is the preferences row only, so the name is re-read
      // rather than dropped — losing it would blank the banner's placeholder
      // the moment a user saved a headline.
      return _profileOf(response.data, displayName: await _displayName());
    } on Object {
      throw const MissionUnavailable();
    }
  }

  @override
  Future<MissionStepResult> completeStep({
    required int levelId,
    required int stepId,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.roadmapProgress,
        data: <String, dynamic>{'levelId': levelId, 'stepId': stepId},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const MissionStepResult();
      return MissionStepResult.fromJson(data);
    } on Object {
      throw const MissionUnavailable();
    }
  }

  @override
  Future<String> suggestHeadline({
    required String headline,
    required String priority,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiSuggestTitle,
        data: <String, dynamic>{'headline': headline, 'priority': priority},
      );
      final String? title = response.data?['suggestedTitle'] as String?;
      if (title == null || title.isEmpty) throw const MissionUnavailable();
      return title;
    } on MissionUnavailable {
      rethrow;
    } on Object {
      throw const MissionUnavailable();
    }
  }

  @override
  Future<String> generateAbout({
    required String profession,
    required String priority,
    String? headline,
    String? industry,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiGenerateAbout,
        data: <String, dynamic>{
          'profession': profession,
          'priority': priority,
          if (headline != null && headline.isNotEmpty) 'headline': headline,
          if (industry != null && industry.isNotEmpty) 'industry': industry,
        },
      );
      final String? about = response.data?['about'] as String?;
      if (about == null || about.isEmpty) throw const MissionUnavailable();
      return about;
    } on MissionUnavailable {
      rethrow;
    } on Object {
      throw const MissionUnavailable();
    }
  }

  @override
  Future<List<BannerTemplate>> fetchBannerTemplates() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.studioTemplates,
        queryParameters: <String, dynamic>{
          'category': 'banner',
          // Without this the response carries no element tree and there is
          // nothing to preview.
          'includeData': 'true',
        },
      );
      final Object? raw = response.data?['templates'];
      if (raw is! List) return const <BannerTemplate>[];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(BannerTemplate.fromJson)
          // A template with no design cannot be rendered or personalised, so
          // it is dropped rather than shown as an empty card.
          .where((BannerTemplate t) => t.data != null)
          .toList(growable: false);
    } on Object {
      throw const MissionUnavailable();
    }
  }

  @override
  Future<SeasonRecap> fetchSeasonRecap() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.roadmapProgress,
      );
      final Map<String, dynamic> progress =
          response.data ?? const <String, dynamic>{};
      final int day = (progress['currentDay'] as num?)?.toInt() ?? 0;
      final DateTime? startedAt = _dateOf(progress['roadmapStartedAt']);

      final int balance = await _xpBalance();
      final (int count, bool atLeast) = await _publishedSince(startedAt);

      return SeasonRecap(
        roadmapDay: day,
        postsPublished: count,
        postsAtLeast: atLeast,
        xpBalance: balance,
      );
    } on Object {
      throw const MissionUnavailable();
    }
  }

  Future<int> _xpBalance() async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.userXp);
    return (response.data?['balance'] as num?)?.toInt() ?? 0;
  }

  /// Counts published posts since the roadmap started.
  ///
  /// `limit` is the posts route's own maximum, and one page is all this is
  /// willing to spend on a recap number. `meta.pagination.hasMore` says
  /// whether the real figure is larger; when it is, the screen renders `100+`
  /// rather than a number it cannot stand behind.
  Future<(int, bool)> _publishedSince(DateTime? startedAt) async {
    const int limit = 100;
    final response = await _client.get<List<dynamic>>(
      ApiPaths.posts,
      queryParameters: <String, dynamic>{'status': 'published', 'limit': limit},
    );
    final List<dynamic> posts = response.data ?? const <dynamic>[];
    int count = 0;
    for (final Object? post in posts) {
      if (post is! Map<String, dynamic>) continue;
      if (startedAt == null) {
        count++;
        continue;
      }
      final DateTime? publishedAt = _dateOf(post['publishedAt']);
      if (publishedAt != null && !publishedAt.isBefore(startedAt)) count++;
    }

    final Object? pagination = DioClient.envelopeMeta(response)?['pagination'];
    final bool hasMore = pagination is Map && pagination['hasMore'] == true;
    return (count, hasMore);
  }

  static DateTime? _dateOf(Object? raw) =>
      raw is String ? DateTime.tryParse(raw) : null;
}

/// In-memory [MissionsRepository] for the `mock` flavor.
///
/// Shaped like a mid-roadmap personal-brand user with a connected LinkedIn
/// account, so every populated branch of all four screens is reachable without
/// a backend.
class FakeMissionsRepository implements MissionsRepository {
  FakeMissionsRepository();

  static const Duration _latency = Duration(milliseconds: 350);

  MissionProfile _profile = const MissionProfile(
    preferences: UserPreferences(
      exists: true,
      onboardingCompleted: true,
      profession: 'Senior Product Manager',
      industry: 'SaaS / AI',
      headline: 'Senior PM at Acme · Building B2B AI tools',
      priority: 'personal_brand',
      skills: <String>['Product Strategy', 'B2B SaaS', 'Discovery'],
    ),
    linkedinSlug: 'asangborkar',
    displayName: 'Asang Borkar',
  );

  @override
  Future<MissionProfile> fetchProfile() async {
    await Future<void>.delayed(_latency);
    return _profile;
  }

  @override
  Future<MissionProfile> updatePreferences(Map<String, dynamic> patch) async {
    await Future<void>.delayed(_latency);
    final UserPreferences p = _profile.preferences;
    _profile = _profile.copyWith(
      preferences: p.copyWith(
        headline: patch['headline'] as String? ?? p.headline,
        summary: patch['summary'] as String? ?? p.summary,
        skills: (patch['skills'] as List<dynamic>?)?.cast<String>() ?? p.skills,
        priority: patch['priority'] as String? ?? p.priority,
      ),
    );
    return _profile;
  }

  @override
  Future<MissionStepResult> completeStep({
    required int levelId,
    required int stepId,
  }) async {
    await Future<void>.delayed(_latency);
    // The step's OWN reward, not a flat 50. Publishing and the weekly reach
    // log are both 100 on the real roadmap, so a flat answer here meant the
    // XP a card promised and the XP the gain animation reported disagreed for
    // three of the five steps — and the fake was the one lying.
    return MissionStepResult(xpAwarded: _rewardFor(stepId));
  }

  /// Mirrors the rewards in `getBaseRoadmap`.
  static int _rewardFor(int stepId) => switch (stepId) {
    1 => 100, // Publish a post
    2 => 50, // Comment on posts
    3 => 50, // Send connection requests
    4 => 100, // The day's extra
    weeklyReachStepId => 100, // Log this week's reach
    _ => 50,
  };

  @override
  Future<String> suggestHeadline({
    required String headline,
    required String priority,
  }) async {
    await Future<void>.delayed(_latency);
    return 'Senior Product Manager | B2B AI & SaaS | Turning messy discovery '
        'into shipped roadmaps';
  }

  @override
  Future<String> generateAbout({
    required String profession,
    required String priority,
    String? headline,
    String? industry,
  }) async {
    await Future<void>.delayed(_latency);
    return 'Most B2B products do not fail because the engineering was wrong. '
        'They fail because nobody could say, in one sentence, whose problem '
        'they solved.\n\n'
        'I have spent eight years on that sentence — running discovery that '
        'survives contact with real customers, and turning it into roadmaps a '
        'team can actually build.\n\n'
        'If you are trying to get a product from "interesting" to "bought", '
        'I am glad to compare notes.';
  }

  @override
  Future<List<BannerTemplate>> fetchBannerTemplates() async {
    await Future<void>.delayed(_latency);
    return <BannerTemplate>[
      for (int i = 0; i < 3; i++)
        BannerTemplate(
          id: 'mock-banner-$i',
          name: <String>['Midnight', 'Gradient Rule', 'Split'][i],
          data: BannerDesign(
            canvas: const BannerCanvas(
              width: 1584,
              height: 396,
              background: '#050A24',
            ),
            elements: <BannerElement>[
              BannerElement(
                id: 'bar-$i',
                type: 'rectangle',
                name: 'accent',
                x: 0,
                y: 340,
                width: 1584,
                height: 12,
                fill: <String>['#2F3AF7', '#00DC82', '#AEB4FF'][i],
              ),
              const BannerElement(
                id: 'name',
                type: 'text',
                name: 'Name',
                x: 96,
                y: 130,
                width: 1000,
                height: 70,
                fill: '#FFFFFF',
                text: 'YOUR NAME',
                fontSize: 64,
                fontWeight: 800,
              ),
              const BannerElement(
                id: 'role',
                type: 'text',
                name: 'Position',
                x: 96,
                y: 214,
                width: 1000,
                height: 40,
                fill: '#AEB4FF',
                text: 'POSITION',
                fontSize: 30,
                fontWeight: 600,
              ),
            ],
          ),
        ),
    ];
  }

  @override
  Future<SeasonRecap> fetchSeasonRecap() async {
    await Future<void>.delayed(_latency);
    // A finished SEASON, on the arc the product actually runs.
    //
    // This was day 66 with 54 posts — the old sixty-six-day season at seven
    // posts a week. The roadmap is 1000 days now and the week publishes
    // twice, so a completed season is ~286 posts, not 54, and day 66 is not
    // the end of anything. A recap screen that can only show a number the
    // product cannot produce cannot be checked against one that it can.
    return const SeasonRecap(
      roadmapDay: roadmapTotalDays,
      postsPublished: 286,
      xpBalance: kMockXpBalance,
    );
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<MissionsRepository> missionsRepositoryProvider =
    Provider<MissionsRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeMissionsRepository();
      return ApiMissionsRepository(ref.watch(dioClientProvider));
    });
