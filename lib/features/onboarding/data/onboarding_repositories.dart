import 'dart:async';
import 'package:dio/dio.dart' show DioException;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/onboarding_repository.dart';

/// Dio-backed [OnboardingRepository].
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so `response.data`
/// is already the inner object on every call here, and a rejection arrives as a
/// [Failure] on `DioException.error` — never as a raw status code.
///
/// **Every path is a constant from [ApiPaths].** The previous version of this
/// app invented its endpoint map and 85 of 88 routes 404ed in silence. The
/// onboarding steps missing from this flow are exactly the steps whose
/// endpoints (or file pickers) do not exist yet; they are reported, not guessed
/// at.
class ApiOnboardingRepository implements OnboardingRepository {
  const ApiOnboardingRepository(this._client);

  final DioClient _client;

  @override
  Future<String?> fetchDisplayName() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.me);
      // The route answers `{ user: {...}, subscription: {...} }`, and the
      // envelope is already off by the time we see it.
      final Object? user = response.data?['user'];
      if (user is Map && user['name'] is String) return user['name'] as String;
      return null;
    } on Object {
      return null;
    }
  }

  @override
  Future<ProfessionAnalysis?> analyzeProfession(String headline) async {
    // The server rejects anything under three characters with a 400. Not worth
    // the round-trip, and the caller treats null as "no analysis" either way.
    if (headline.trim().length < 3) return null;
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiAnalyzeProfession,
        data: <String, dynamic>{'headline': headline.trim()},
      );
      final Map<String, dynamic>? data = response.data;
      return data == null ? null : ProfessionAnalysis.fromJson(data);
    } on Object {
      // Best-effort by contract — see OnboardingRepository.
      return null;
    }
  }

  @override
  Future<String?> saveStyleSample(String text) async {
    try {
      await _client.post<Map<String, dynamic>>(
        ApiPaths.aiStyleMemory,
        // `topic` defaults to 'general' server-side; an onboarding sample has
        // no topic of its own, so it is left to that default.
        data: <String, dynamic>{'text': text},
      );
      return null;
    } on DioException catch (e) {
      return _reasonFrom(e);
    } on Object {
      // A parse failure on a call whose body we ignore. Nothing to quote.
      return null;
    }
  }

  @override
  Future<void> completeOnboarding(Map<String, dynamic> patch) async {
    try {
      await _client.patch<Map<String, dynamic>>(
        ApiPaths.userPreferences,
        data: patch,
      );
    } on DioException catch (e) {
      throw OnboardingUnavailable(_reasonFrom(e));
    } on Object {
      throw const OnboardingUnavailable();
    }
  }

  @override
  Future<void> seedAfterOnboarding({
    String? profession,
    String? industry,
    String? brandType,
    bool usedCvUpload = false,
  }) async {
    // Each step swallows its own failure — none may block the handover.
    Future<void> attempt(String path, [Object? body]) async {
      try {
        await _client.post<Map<String, dynamic>>(path, data: body);
      } on Object {
        // Fire-and-forget, exactly like the web's post-finalise fan-out.
      }
    }

    // Grounding first. Idempotent server-side.
    unawaited(attempt(ApiPaths.personaHarvest));

    // AWAITED. The next call plans week one by reading the audience this one
    // infers; racing them leaves week one aimed at nobody. It cannot fail the
    // flow — attempt() swallows — so the worst case is the seconds it costs.
    await attempt(ApiPaths.onboardingDeriveAudience);

    unawaited(attempt(ApiPaths.aiInitWeekPlan));
    unawaited(
      attempt(ApiPaths.aiGenerateRoadmap, <String, dynamic>{
        'profession': ?profession,
        'industry': ?industry,
        // The web sends the profession as expertise too.
        'expertise': ?profession,
        'goals': <String>[
          brandType == 'company' ? 'brand_building' : 'thought_leadership',
        ],
        'usedCVUpload': usedCvUpload,
        'brandType': ?brandType,
      }),
    );

    // No body: the server reads profession / industry / headline / summary
    // from the preferences row this flow has just written, which is why this
    // runs AFTER completeOnboarding and not beside it.
    unawaited(attempt(ApiPaths.aiSuggestTopics));
  }

  /// The backend's own message when it sent one, so the chat can quote it the
  /// way the web does (`I hit a snag saving your setup ({reason}).`).
  static String? _reasonFrom(DioException e) {
    final Object? failure = e.error;
    if (failure is Failure) {
      final String? message = failure.message;
      if (message != null && message.isNotEmpty) return message;
    }
    return e.message;
  }
}

/// In-memory [OnboardingRepository] for the `mock` flavor.
///
/// Succeeds at everything after a short delay. The failure paths are reachable
/// by overriding this provider in a test — a fake that failed at random would
/// make the mock flavor's onboarding unusable, which is the opposite of what
/// the mock is for.
class FakeOnboardingRepository implements OnboardingRepository {
  const FakeOnboardingRepository();

  @override
  Future<String?> fetchDisplayName() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return 'Asha Mehta';
  }

  @override
  Future<ProfessionAnalysis?> analyzeProfession(String headline) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ProfessionAnalysis(
      profession: headline,
      industry: 'Technology',
      suggestedCategories: const <String>[
        'thought_leadership',
        'career_growth',
      ],
      expertise: headline,
      roadmapTitle: 'Your Growth Roadmap',
    );
  }

  @override
  Future<String?> saveStyleSample(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return null;
  }

  @override
  Future<void> completeOnboarding(Map<String, dynamic> patch) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> seedAfterOnboarding({
    String? profession,
    String? industry,
    String? brandType,
    bool usedCvUpload = false,
  }) async {}
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<OnboardingRepository> onboardingRepositoryProvider =
    Provider<OnboardingRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return const FakeOnboardingRepository();
      return ApiOnboardingRepository(ref.watch(dioClientProvider));
    });
