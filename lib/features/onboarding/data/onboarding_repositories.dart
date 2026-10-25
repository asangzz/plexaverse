import 'dart:async';
import 'package:dio/dio.dart'
    show DioException, DioMediaType, FormData, MultipartFile;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/onboarding_repository.dart';
import '../../../core/platform/file_picking.dart';
import '../../../core/platform/image_picking.dart';

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
  Future<ParsedCv> parseCv(PickedFile pdf) async {
    final Map<String, dynamic> body = await _upload(
      ApiPaths.aiParseCv,
      pdf,
      DioMediaType('application', 'pdf'),
    );
    // `{ success, data: {...} }` — the route keeps the web's inner wrapper.
    final Object? data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const OnboardingUnavailable('The server sent nothing back');
    }
    return ParsedCv.fromJson(data);
  }

  @override
  Future<CompanyDoc> parseCompanyDoc(PickedFile pdf) async {
    final Map<String, dynamic> body = await _upload(
      ApiPaths.aiParseCompanyDoc,
      pdf,
      DioMediaType('application', 'pdf'),
    );
    final Object? data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const OnboardingUnavailable('The server sent nothing back');
    }
    return CompanyDoc.fromJson(data);
  }

  @override
  Future<String> uploadLogo(PickedFile image) async {
    final Map<String, dynamic> body = await _upload(
      ApiPaths.uploadAsset,
      image,
      _imageType(image.name),
      fields: const <String, String>{'kind': 'logo'},
    );
    final Object? url = body['url'];
    if (url is! String || url.isEmpty) {
      throw const OnboardingUnavailable('The upload returned no address');
    }
    return url;
  }

  @override
  Future<PosterStyle> analyzePosterStyle(PickedFile image) async {
    final Map<String, dynamic> body = await _upload(
      ApiPaths.aiAnalyzePosterStyle,
      image,
      _imageType(image.name),
    );
    return PosterStyle.fromJson(body);
  }

  /// One file, multipart, under `file` — the shape every upload route here
  /// reads. The content type is set rather than left to Dio: the parsers check
  /// it, and an `application/octet-stream` PDF is rejected as not a PDF.
  Future<Map<String, dynamic>> _upload(
    String path,
    PickedFile file,
    DioMediaType type, {
    Map<String, String> fields = const <String, String>{},
  }) async {
    try {
      final FormData form = FormData.fromMap(<String, dynamic>{
        ...fields,
        'file': MultipartFile.fromBytes(
          file.bytes,
          filename: file.name,
          contentType: type,
        ),
      });
      final response = await _client.sendMultipart<Map<String, dynamic>>(
        path,
        form,
      );
      return response.data ?? const <String, dynamic>{};
    } on DioException catch (e) {
      throw OnboardingUnavailable(_reasonFrom(e));
    } on OnboardingUnavailable {
      rethrow;
    } on Object {
      throw const OnboardingUnavailable();
    }
  }

  static DioMediaType _imageType(String name) {
    final String n = name.toLowerCase();
    if (n.endsWith('.png')) return DioMediaType('image', 'png');
    if (n.endsWith('.webp')) return DioMediaType('image', 'webp');
    if (n.endsWith('.gif')) return DioMediaType('image', 'gif');
    return DioMediaType('image', 'jpeg');
  }

  @override
  Future<String?> analyzeStyleScreenshots(List<PickedImage> images) async {
    if (images.isEmpty) return null;
    try {
      final FormData form = FormData();
      for (final PickedImage image in images) {
        // The route reads repeated `files` fields, so each image is appended
        // under the same name rather than files[0], files[1].
        form.files.add(
          MapEntry<String, MultipartFile>(
            'files',
            // No explicit contentType: Dio derives it from the filename,
            // and the route accepts any image type.
            MultipartFile.fromBytes(image.bytes, filename: image.name),
          ),
        );
      }
      final response = await _client.sendMultipart<Map<String, dynamic>>(
        ApiPaths.aiAnalyzeStyleScreenshot,
        form,
      );
      final String? text = response.data?['analyzedStyleText'] as String?;
      return (text == null || text.trim().isEmpty) ? null : text.trim();
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
        // `baseline`, as the web sends it: this is the voice everything else
        // is measured against, not a sample about one topic.
        data: <String, dynamic>{'text': text, 'topic': 'baseline'},
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
  Future<bool> hasFreshWelcomeBonus() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userXp,
        queryParameters: const <String, dynamic>{'include': 'history'},
      );
      final List<Object?> history =
          (response.data?['transactions'] as List<Object?>?) ??
          const <Object?>[];
      final Iterable<Map<String, dynamic>> registrations = history
          .whereType<Map<String, dynamic>>()
          .where((Map<String, dynamic> t) => t['action'] == 'registration');
      // The web's two checks, kept apart as it keeps them: the bonus was
      // earned, and it landed within the last two minutes.
      final bool earned = registrations.any(
        (Map<String, dynamic> t) => t['type'] == 'earn',
      );
      final DateTime cutoff = DateTime.now().subtract(
        const Duration(minutes: 2),
      );
      final bool recent = registrations.any((Map<String, dynamic> t) {
        final DateTime? at = DateTime.tryParse('${t['createdAt']}');
        return at != null && at.isAfter(cutoff);
      });
      return earned && recent;
    } on Object {
      return false;
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
  Future<void> seedAfterOnboarding(OnboardingAnswers answers) async {
    // Each step swallows its own failure — none may block the handover.
    Future<void> attempt(String path, [Object? body]) async {
      try {
        await _client.post<Map<String, dynamic>>(path, data: body);
      } on Object {
        // Fire-and-forget, exactly like the web's post-finalise fan-out.
      }
    }

    final bool company = answers.isCompany;
    final ParsedCv? cv = answers.cv;
    final CompanyDoc? doc = answers.companyDoc;

    if (company) unawaited(attempt(ApiPaths.studioBrandTemplate));

    // Grounding first. Idempotent server-side.
    unawaited(attempt(ApiPaths.personaHarvest));

    // AWAITED. The next call plans week one by reading the audience this one
    // infers; racing them leaves week one aimed at nobody. It cannot fail the
    // flow — attempt() swallows — so the worst case is the seconds it costs.
    await attempt(ApiPaths.onboardingDeriveAudience);

    unawaited(attempt(ApiPaths.aiInitWeekPlan));
    unawaited(
      attempt(ApiPaths.aiGenerateRoadmap, <String, dynamic>{
        'profession': ?cv?.profession,
        'industry': ?(company ? _orNull(doc?.industry) : cv?.industry),
        // The web sends the profession as expertise too.
        'expertise': ?cv?.profession,
        'goals': <String>[company ? 'brand_building' : 'thought_leadership'],
        'usedCVUpload': answers.usedCvUpload,
        'cvData': ?cv?.toJson(),
        'brandType': (answers.brand ?? BrandChoice.personal).id,
        if (company) 'companyDescription': ?_orNull(doc?.description),
      }),
    );
  }

  static String? _orNull(String? v) => v == null || v.trim().isEmpty ? null : v;

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
  Future<ParsedCv> parseCv(PickedFile pdf) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return const ParsedCv(
      headline: 'Senior Software Engineer at Acme',
      profession: 'Software Engineer',
      industry: 'Technology',
      summary: 'Builds the systems behind payments at scale.',
      skills: <String>['Distributed systems', 'Go', 'Mentoring'],
    );
  }

  @override
  Future<CompanyDoc> parseCompanyDoc(PickedFile pdf) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    // No website, so the mock walks through the details form too.
    return const CompanyDoc(
      description:
          'Acme builds payment infrastructure for small online shops across '
          'India.',
      industry: 'FinTech',
      tagline: 'Payments, minus the paperwork',
      features: <String>['Checkout links', 'UPI collections'],
    );
  }

  @override
  Future<String> uploadLogo(PickedFile image) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return 'https://picsum.photos/seed/logo/256';
  }

  @override
  Future<PosterStyle> analyzePosterStyle(PickedFile image) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    return const PosterStyle(theme: 'dark', primaryColor: '#5761EB');
  }

  @override
  Future<String?> analyzeStyleScreenshots(List<PickedImage> images) async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (images.isEmpty) return null;
    return 'Short sentences. One idea per line. No throat-clearing — the '
        'first line says the thing, and the rest earns it.';
  }

  @override
  Future<String?> saveStyleSample(String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return null;
  }

  @override
  Future<bool> hasFreshWelcomeBonus() async => false;

  @override
  Future<void> completeOnboarding(Map<String, dynamic> patch) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> seedAfterOnboarding(OnboardingAnswers answers) async {}
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
