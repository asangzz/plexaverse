import 'package:dio/dio.dart' show DioException, FormData, Response;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/ai_tool_failure.dart';
import '../domain/ai_tools_repository.dart';
import '../domain/festive_template.dart';
import '../domain/headshot_session.dart';
import '../domain/studio_template.dart';

/// Dio-backed [AiToolsRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope and throws a
/// `DioException` carrying a [Failure] when the envelope reports one, so these
/// methods only ever see the inner payload and never branch on a status code.
///
/// `dio` is imported only here, and only for [FormData] (which `sendMultipart`
/// needs), [Response] and the [DioException] this class translates away.
class ApiAiToolsRepository implements AiToolsRepository {
  const ApiAiToolsRepository(this._client);

  final DioClient _client;

  /// Translates every wire failure into an [AiToolFailure], once.
  ///
  /// This is the whole reason the three controllers can `on AiToolFailure
  /// catch (e)` and render one amber card: without it, each of them would have
  /// to know that a `DioException` carries a [Failure] on `.error`, and the
  /// 402 branch would be duplicated at four call sites.
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      final Object? inner = e.error;
      if (inner is Failure) {
        final String? code = inner.errorCode;
        return Future<T>.error(
          AiToolFailure(
            inner.message ?? _defaultMessage(inner),
            insufficientXp: code == 'INSUFFICIENT_XP',
            code: code,
          ),
        );
      }
      return Future<T>.error(
        const AiToolFailure('Could not reach Plexaverse. Try again.'),
      );
    } on AiToolFailure {
      rethrow;
    } on Object {
      return Future<T>.error(
        const AiToolFailure('Something went wrong. Try again.'),
      );
    }
  }

  /// The copy shown when the server sent no message of its own.
  static String _defaultMessage(Failure failure) => switch (failure) {
    NetworkFailure() => 'No connection. Check your network and try again.',
    // Reached the server, which is still working on it. Never tell
    // someone to check a connection that demonstrably worked.
    TimeoutFailure() =>
      'That took longer than expected. It may still have gone through — '
      'check before trying again.',
    AuthFailure() => 'Your session expired. Sign in again.',
    NotFoundFailure() => 'That is no longer available.',
    ValidationFailure() => 'Some details were rejected. Check and try again.',
    ClientFailure() => 'That request was rejected.',
    ServerFailure() => 'Plexaverse had a problem. Try again shortly.',
    UnknownFailure() => 'Something went wrong. Try again.',
  };

  @override
  Future<List<StudioTemplate>> fetchStudioTemplates({String? category}) =>
      _guard(() async {
        final Response<Map<String, dynamic>> response = await _client
            .get<Map<String, dynamic>>(
              ApiPaths.studioTemplates,
              queryParameters: <String, dynamic>{'category': ?category},
            );
        final List<dynamic> rows =
            (response.data?['templates'] as List<dynamic>?) ??
            const <dynamic>[];
        return rows
            .whereType<Map<String, dynamic>>()
            .map(StudioTemplate.fromJson)
            .toList(growable: false);
      });

  @override
  Future<StudioTemplate> copyStudioTemplate({
    required String sourceId,
    required String name,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.studioCopy,
          data: <String, dynamic>{'sourceId': sourceId, 'name': name},
        );
    final Map<String, dynamic>? design =
        response.data?['design'] as Map<String, dynamic>?;
    if (design == null) {
      throw const AiToolFailure('The copy did not come back. Try again.');
    }
    // The route returns the FULL design, canvas JSON included.
    // `StudioTemplate` models the list projection; json_serializable ignores
    // the extra keys, so the same type reads both shapes.
    return StudioTemplate.fromJson(design);
  });

  @override
  Future<FestiveGallery> fetchFestiveTemplates({String? category}) =>
      _guard(() async {
        final Response<Map<String, dynamic>> response = await _client
            .get<Map<String, dynamic>>(
              ApiPaths.festiveTemplates,
              queryParameters: <String, dynamic>{'category': ?category},
            );
        final Map<String, dynamic>? data = response.data;
        if (data == null) return const FestiveGallery();
        return FestiveGallery.fromJson(data);
      });

  @override
  Future<FestivePoster> generateFestivePoster({
    required String templateId,
    required FestiveCustomizations customizations,
  }) => _guard(() async {
    // Only what the user filled in. The server merges `customizations` onto
    // the template's own text, so an empty string sent for a field the user
    // left alone would blank that layer rather than leave it.
    final Map<String, dynamic> body = <String, dynamic>{
      'companyName': ?_trimmedOrNull(customizations.companyName),
      'eventName': ?_trimmedOrNull(customizations.eventName),
      'additionalText': ?_trimmedOrNull(customizations.additionalText),
      'date': ?customizations.formattedDate,
      'logoUrl': ?customizations.logoUrl,
      'colors': <String, dynamic>{'primary': customizations.primaryColor},
    };

    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.festiveGenerate,
          data: <String, dynamic>{
            'templateId': templateId,
            'customizations': body,
          },
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw const AiToolFailure('The poster did not come back. Try again.');
    }
    return FestivePoster.fromJson(data);
  });

  @override
  Future<HeadshotResult> generateHeadshots({
    required List<String> photos,
    required HeadshotStyle style,
    required HeadshotBackground background,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.aiHeadshot,
          data: <String, dynamic>{
            'photos': photos,
            'style': style.wire,
            'background': background.wire,
          },
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw const AiToolFailure('The headshots did not come back. Try again.');
    }
    return HeadshotResult.fromJson(data);
  });

  @override
  Future<String> uploadDataUri(String dataUri) => _guard(() async {
    // The route accepts either a multipart `image` File or a `base64` string
    // field. A composited poster arrives as a data URI, so it takes the second
    // path; the server strips the `data:image/…;base64,` prefix itself.
    final Response<Map<String, dynamic>> response = await _client
        .sendMultipart<Map<String, dynamic>>(
          ApiPaths.uploadImage,
          FormData.fromMap(<String, dynamic>{'base64': dataUri}),
        );
    final String? url = response.data?['url'] as String?;
    if (url == null || url.isEmpty) {
      throw const AiToolFailure('The upload did not return a link.');
    }
    return url;
  });

  @override
  Future<void> completeRoadmapStep({
    required int levelId,
    required int stepId,
  }) => _guard(() async {
    await _client.post<Map<String, dynamic>>(
      ApiPaths.roadmapProgress,
      data: <String, dynamic>{'levelId': levelId, 'stepId': stepId},
    );
  });

  static String? _trimmedOrNull(String value) {
    final String t = value.trim();
    return t.isEmpty ? null : t;
  }
}

/// In-memory [AiToolsRepository] for the `mock` flavor.
///
/// Shaped so every state on all three screens is reachable without a backend:
/// templates in several categories, a poster that "generates", and four
/// headshots. The image URLs are the templates' own previews rather than data
/// URIs — there is no point shipping megabytes of base64 in a fixture.
class FakeAiToolsRepository implements AiToolsRepository {
  FakeAiToolsRepository();

  static const List<StudioTemplate> _studio = <StudioTemplate>[
    StudioTemplate(
      id: 'mock-tpl-1',
      name: 'Insight carousel cover',
      description: 'A bold opening slide for a five-part carousel.',
      width: 1080,
      height: 1350,
      category: 'social_media',
      isPublic: true,
    ),
    StudioTemplate(
      id: 'mock-tpl-2',
      name: 'Comparison poster',
      description: 'Two columns, one argument. Works for before/after.',
      width: 1080,
      height: 1080,
      category: 'infographic',
      isPublic: true,
    ),
    StudioTemplate(
      id: 'mock-tpl-3',
      name: 'Company announcement',
      description: null,
      width: 1200,
      height: 628,
      category: 'automate_posts_company',
      isPublic: true,
    ),
    StudioTemplate(
      id: 'mock-tpl-4',
      name: 'Profile banner',
      description: 'A LinkedIn header sized for the desktop crop.',
      width: 1584,
      height: 396,
      category: 'banner',
      isTemplate: true,
    ),
  ];

  static const FestiveGallery _festive = FestiveGallery(
    templates: <FestiveTemplate>[
      FestiveTemplate(
        id: 'mock-fest-1',
        name: 'Diwali',
        description: 'Lamps and a warm gradient.',
        category: 'diwali',
      ),
      FestiveTemplate(
        id: 'mock-fest-2',
        name: 'New Year',
        description: 'Midnight, confetti, a big number.',
        category: 'new_year',
      ),
      FestiveTemplate(
        id: 'mock-fest-3',
        name: 'Republic Day',
        description: null,
        category: 'republic_day',
      ),
    ],
    categories: <String>['diwali', 'new_year', 'republic_day'],
  );

  @override
  Future<List<StudioTemplate>> fetchStudioTemplates({String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (category == null) return _studio;
    return _studio
        .where((StudioTemplate t) => t.category == category)
        .toList(growable: false);
  }

  @override
  Future<StudioTemplate> copyStudioTemplate({
    required String sourceId,
    required String name,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final StudioTemplate source = _studio.firstWhere(
      (StudioTemplate t) => t.id == sourceId,
      orElse: () => _studio.first,
    );
    return source.copyWith(
      id: 'mock-copy-$sourceId',
      name: name,
      isPublic: false,
      isTemplate: false,
    );
  }

  @override
  Future<FestiveGallery> fetchFestiveTemplates({String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (category == null) return _festive;
    return _festive.copyWith(
      templates: _festive.templates
          .where((FestiveTemplate t) => t.category == category)
          .toList(growable: false),
    );
  }

  @override
  Future<FestivePoster> generateFestivePoster({
    required String templateId,
    required FestiveCustomizations customizations,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return FestivePoster(
      imageUrl: '',
      templateName: _festive.templates
          .firstWhere(
            (FestiveTemplate t) => t.id == templateId,
            orElse: () => _festive.templates.first,
          )
          .name,
    );
  }

  @override
  Future<HeadshotResult> generateHeadshots({
    required List<String> photos,
    required HeadshotStyle style,
    required HeadshotBackground background,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    return HeadshotResult(
      headshots: const <String>['', '', '', ''],
      count: 4,
      style: style.wire,
      background: background.wire,
    );
  }

  @override
  Future<String> uploadDataUri(String dataUri) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'https://example.invalid/mock-upload.png';
  }

  @override
  Future<void> completeRoadmapStep({
    required int levelId,
    required int stepId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<AiToolsRepository> aiToolsRepositoryProvider =
    Provider<AiToolsRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeAiToolsRepository();
      return ApiAiToolsRepository(ref.watch(dioClientProvider));
    });
