import 'package:dio/dio.dart' show DioException, FormData, Response;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/compose_draft.dart';
import '../domain/compose_models.dart';
import '../domain/compose_repository.dart';
import '../domain/linkedin_account.dart';

/// Dio-backed [ComposeRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope and throws a
/// `DioException` carrying a `Failure` when the envelope reports one, so these
/// methods only ever see the inner payload and never branch on a status code.
///
/// `dio` is imported only here, and only for [FormData] (which `sendMultipart`
/// requires), [Response] and the [DioException] this class translates away.
/// Nothing above `data/` in this slice knows the transport exists.
class ApiComposeRepository implements ComposeRepository {
  const ApiComposeRepository(this._client);

  final DioClient _client;

  /// Translates every wire failure into a [ComposeFailure], once.
  ///
  /// This is the whole reason the application layer can `on ComposeFailure
  /// catch (e)` and show one amber card: without it, each controller method
  /// would have to know that a `DioException` carries a [Failure] on `.error`,
  /// and the 402 branch would end up duplicated at five call sites.
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      final Object? inner = e.error;
      if (inner is Failure) {
        final String? code = inner.errorCode;
        return Future<T>.error(
          ComposeFailure(
            inner.message ?? _defaultMessage(inner),
            insufficientXp: code == 'INSUFFICIENT_XP',
            code: code,
          ),
        );
      }
      return Future<T>.error(
        const ComposeFailure('Could not reach Plexaverse. Try again.'),
      );
    } on ComposeFailure {
      rethrow;
    } on Object {
      return Future<T>.error(
        const ComposeFailure('Something went wrong. Try again.'),
      );
    }
  }

  /// The copy shown when the server sent no message of its own.
  static String _defaultMessage(Failure failure) => switch (failure) {
    NetworkFailure() => 'No connection. Check your network and try again.',
    AuthFailure() => 'Your session expired. Sign in again.',
    NotFoundFailure() => 'That is no longer available.',
    ValidationFailure() => 'Some details were rejected. Check and try again.',
    ClientFailure() => 'That request was rejected.',
    ServerFailure() => 'Plexaverse had a problem. Try again shortly.',
    UnknownFailure() => 'Something went wrong. Try again.',
  };

  @override
  Future<List<LinkedinAccount>> fetchAccounts() => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .get<Map<String, dynamic>>(ApiPaths.linkedInAccounts);

    final List<dynamic> rows =
        (response.data?['accounts'] as List<dynamic>?) ?? const <dynamic>[];

    return rows
        .whereType<Map<String, dynamic>>()
        .map(LinkedinAccount.fromJson)
        .toList(growable: false);
  });

  @override
  Future<GeneratedPost> generatePost({
    required String topic,
    required ComposeTone tone,
    required ComposeLength length,
  }) => _guard(() async {
    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.aiGenerate,
          data: <String, dynamic>{
            'topic': topic,
            'tone': tone.wire,
            'length': length.wire,
          },
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('ai/generate returned no body');
    }
    return GeneratedPost.fromJson(data);
  });

  @override
  Future<GeneratedPoster> generatePoster(PosterPrompt prompt) => _guard(
    () async {
      final Map<String, dynamic> body = <String, dynamic>{
        'topic': prompt.topic,
        'content': prompt.content,
      };
      if (prompt.posterTitle != null) body['posterTitle'] = prompt.posterTitle;
      if (prompt.userName != null) body['userName'] = prompt.userName;
      if (prompt.profileImageUrl != null) {
        body['profileImageUrl'] = prompt.profileImageUrl;
      }
      if (prompt.category != null) body['category'] = prompt.category;

      final Response<Map<String, dynamic>> response = await _client
          .post<Map<String, dynamic>>(ApiPaths.aiPoster, data: body);
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw StateError('ai/poster returned no body');
      }
      return GeneratedPoster.fromJson(data);
    },
  );

  @override
  Future<UploadedImage> uploadBase64Image(String dataUri) => _guard(() async {
    // The route accepts either a multipart `image` File or a `base64` string
    // field; an AI poster arrives as a data URI, so it takes the second path.
    // The server strips the `data:image/…;base64,` prefix itself.
    final Response<Map<String, dynamic>> response = await _client
        .sendMultipart<Map<String, dynamic>>(
          ApiPaths.uploadImage,
          FormData.fromMap(<String, dynamic>{'base64': dataUri}),
        );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('upload/image returned no body');
    }
    return UploadedImage.fromJson(data);
  });

  @override
  Future<CreatedPost> createPost({
    required String content,
    required String status,
    String? title,
    String? imageUrl,
    String? imageThumbUrl,
    String? accountId,
    DateTime? scheduledFor,
  }) => _guard(() async {
    final Map<String, dynamic> body = <String, dynamic>{
      'content': content,
      'status': status,
    };
    if (title != null && title.isNotEmpty) body['title'] = title;
    if (imageUrl != null) body['imageUrl'] = imageUrl;
    if (imageThumbUrl != null) body['imageThumbUrl'] = imageThumbUrl;
    if (accountId != null) body['accountId'] = accountId;
    if (scheduledFor != null) {
      // Local wall-clock → UTC ISO at the boundary. The user picked their own
      // 9am; the server stores an instant.
      body['scheduledFor'] = scheduledFor.toUtc().toIso8601String();
    }

    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(ApiPaths.posts, data: body);
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('posts POST returned no body');
    }
    return CreatedPost.fromJson(data);
  });

  @override
  Future<CompanyPublishResult> publishCompanyPost({
    required String content,
    required String organizationId,
    String? imageUrl,
    String? postId,
  }) => _guard(() async {
    final Map<String, dynamic> body = <String, dynamic>{
      'content': content,
      'organizationId': organizationId,
    };
    if (imageUrl != null) body['imageUrl'] = imageUrl;
    if (postId != null) body['postId'] = postId;

    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(ApiPaths.linkedInCompanyPost, data: body);
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw StateError('linkedin/company-post returned no body');
    }
    return CompanyPublishResult.fromJson(data);
  });
}

/// In-memory [ComposeRepository] for the `mock` flavor.
///
/// Shaped like a connected personal brand with one account, so the happy path
/// is exercisable without a backend. The generated body is deliberately a real
/// multi-paragraph post rather than lorem: the character counter, the near-limit
/// amber and the preview's line breaks are all things you can only see is
/// wrong with plausible text in them.
class FakeComposeRepository implements ComposeRepository {
  /// Drafts created this session, so each gets its own id.
  int _composed = 0;

  FakeComposeRepository();

  /// A 1×1 transparent PNG. Enough for the attached-image panel and the
  /// preview to lay out correctly without shipping a fixture image.
  static const String _pixel =
      'data:image/png;base64,'
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
      'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

  @override
  Future<List<LinkedinAccount>> fetchAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const <LinkedinAccount>[
      LinkedinAccount(
        id: 'mock-account-1',
        profileId: 'urn:li:person:mock',
        profileName: 'Asang Borkar',
        profileHeadline: 'Building Plexaverse',
      ),
    ];
  }

  @override
  Future<GeneratedPost> generatePost({
    required String topic,
    required ComposeTone tone,
    required ComposeLength length,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return GeneratedPost(
      content:
          'Most teams treat $topic as a documentation exercise.\n\n'
          'Write enough down, the thinking goes, and the problem solves '
          'itself.\n\n'
          'It does not work, and the reason is not effort.\n\n'
          'What actually moves the needle is the first week.',
      category: 'reflective',
      posterTitle: 'THE FIRST WEEK DECIDES',
      model: 'mock-model',
      provider: 'gemini',
    );
  }

  @override
  Future<GeneratedPoster> generatePoster(PosterPrompt prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return GeneratedPoster(
      imageUrl: _pixel,
      posterTitle: prompt.posterTitle ?? 'MOCK POSTER',
      model: 'mock-image-model',
      provider: 'gemini-poster',
    );
  }

  @override
  Future<UploadedImage> uploadBase64Image(String dataUri) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // A URL that RESOLVES. `.invalid` is reserved and can never load, so every
    // "successful" upload rendered the image-error state — inverting the one
    // branch this fixture exists to exercise, on the build the app is manually
    // tested on.
    return const UploadedImage(
      url: 'https://picsum.photos/seed/plexa-upload/1200/1200',
      thumbUrl: 'https://picsum.photos/seed/plexa-upload/240/240',
    );
  }

  @override
  Future<CreatedPost> createPost({
    required String content,
    required String status,
    String? title,
    String? imageUrl,
    String? imageThumbUrl,
    String? accountId,
    DateTime? scheduledFor,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // A fresh id per draft. This used to be the constant 'mock-post-1', which
    // is also the id of a PUBLISHED post in the library fixture — with 4,821
    // impressions and a LinkedIn URL on it. Composing a draft and opening it
    // showed someone else's published post, and two drafts were the same row.
    _composed += 1;
    return CreatedPost(
      id: 'mock-composed-$_composed',
      status: status,
      scheduledFor: scheduledFor?.toUtc().toIso8601String(),
      imageUrl: imageUrl,
    );
  }

  @override
  Future<CompanyPublishResult> publishCompanyPost({
    required String content,
    required String organizationId,
    String? imageUrl,
    String? postId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const CompanyPublishResult(
      success: true,
      postUrn: 'urn:li:share:mock',
      postUrl: 'https://www.linkedin.com/feed/update/urn:li:share:mock',
    );
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<ComposeRepository> composeRepositoryProvider =
    Provider<ComposeRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeComposeRepository();
      return ApiComposeRepository(ref.watch(dioClientProvider));
    });
