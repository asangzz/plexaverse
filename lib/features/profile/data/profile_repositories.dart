import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:dio/dio.dart'
    show DioException, Options, Response, ResponseType;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/profile_handle.dart';
import '../domain/public_profile.dart';
import '../domain/public_profile_words.dart';

/// Dio-backed [ProfileRepository] — the web's `/api/mobile/v1/profile/**`.
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so each body here
/// is the web's own. A refusal arrives as a [Failure] on
/// `DioException.error`; its CODE decides the [ProfileFailure], never its
/// class (409 HANDLE_TAKEN would otherwise read as a generic client error).
class ApiProfileRepository implements ProfileRepository {
  const ApiProfileRepository(this._client);

  final DioClient _client;

  @override
  Future<PublicProfileSettings> fetchSettings() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.profile);
    return PublicProfileSettings.fromJson(_body(r));
  });

  @override
  Future<HandleAvailability> checkHandle(String handle) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.profile,
          queryParameters: <String, dynamic>{'handle': handle},
        );
    final Object? a = _body(r)['availability'];
    if (a is! Map<String, dynamic>) throw const ProfileUnavailable();
    return HandleAvailability.fromJson(a);
  });

  @override
  Future<PublicProfileSettings> publish({
    required String handle,
    bool adult = false,
  }) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .put<Map<String, dynamic>>(
          ApiPaths.profile,
          // A literal bool: only the box the person ticked publishes.
          data: <String, dynamic>{
            'published': true,
            'handle': handle,
            if (adult) 'adult': true,
          },
        );
    return PublicProfileSettings.fromJson(_body(r));
  });

  /// `published: false` and nothing else: a withdrawal needs no handle.
  @override
  Future<PublicProfileSettings> unpublish() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .put<Map<String, dynamic>>(
          ApiPaths.profile,
          data: <String, dynamic>{'published': false},
        );
    return PublicProfileSettings.fromJson(_body(r));
  });

  @override
  Future<FollowState> follow(String handle) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.profileFollow,
          data: <String, dynamic>{'handle': handle},
        );
    return FollowState.fromJson(_body(r));
  });

  /// In the query, not a body: a DELETE body is dropped by some proxies, and
  /// the route reads `?handle=` first.
  @override
  Future<FollowState> unfollow(String handle) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .delete<Map<String, dynamic>>(
          ApiPaths.profileFollow,
          queryParameters: <String, dynamic>{'handle': handle},
        );
    return FollowState.fromJson(_body(r));
  });

  /// Bytes, not the envelope: a success is the PDF itself. A refusal's body
  /// is then bytes too, so CV_EMPTY is read off the status (422) and its
  /// sentence off the decoded body when it parses.
  @override
  Future<CvFile> downloadCv() async {
    try {
      final Response<List<int>> r = await _client.get<List<int>>(
        ApiPaths.profileCv,
        options: Options(responseType: ResponseType.bytes),
      );
      final List<int>? bytes = r.data;
      // A body that is not a PDF is not the CV, whatever its status.
      if (bytes == null || bytes.length < 5 || !_isPdf(bytes)) {
        throw const ProfileUnavailable();
      }
      return CvFile(
        bytes: Uint8List.fromList(bytes),
        fileName: cvFileName(r.headers.value('content-disposition')),
      );
    } on ProfileFailure {
      rethrow;
    } on DioException catch (e) {
      // The app's words, whatever the server says: the web's line points at
      // an upload "below" its own button, which the app does not have.
      if (e.response?.statusCode == 422) {
        throw const ProfileCvEmpty(kCvEmptyAppMessage);
      }
      throw _mapped(e);
    } on Object {
      throw const ProfileUnavailable();
    }
  }

  static bool _isPdf(List<int> b) =>
      utf8.decode(b.sublist(0, 5), allowMalformed: true) == '%PDF-';

  /// The file name the server chose (`<Name>-CV.pdf`), or a plain one. Only
  /// a bare name is kept: anything with a path separator is not a file name.
  static String cvFileName(String? disposition) {
    final RegExpMatch? m = RegExp(
      r'filename="([^"/\\]+)"',
    ).firstMatch(disposition ?? '');
    final String? name = m?.group(1)?.trim();
    return name != null && name.toLowerCase().endsWith('.pdf')
        ? name
        : 'CV.pdf';
  }

  // ── The seam ─────────────────────────────────────────────────────────────

  static Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on ProfileFailure {
      rethrow;
    } on DioException catch (e) {
      throw _mapped(e);
    }
  }

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> r) {
    final Map<String, dynamic>? data = r.data;
    if (data == null) throw const ProfileUnavailable();
    return data;
  }

  static ProfileFailure _mapped(DioException e) {
    final Object? error = e.error;
    final Failure? failure = error is Failure ? error : null;
    final String? said = failure?.message?.trim();
    final String? message = said == null || said.isEmpty ? null : said;
    return switch (failure?.errorCode) {
      'HANDLE_INVALID' || 'HANDLE_REQUIRED' || 'VALIDATION_FAILED' =>
        message == null
            ? const ProfileHandleRefused()
            : ProfileHandleRefused(message),
      'HANDLE_TAKEN' =>
        message == null
            ? const ProfileHandleTaken()
            : ProfileHandleTaken(message),
      'ADULT_REQUIRED' =>
        message == null
            ? const ProfileAdultRequired()
            : ProfileAdultRequired(message),
      'NOT_FOUND' =>
        message == null ? const ProfileNotFound() : ProfileNotFound(message),
      'SELF_FOLLOW' =>
        message == null
            ? const ProfileSelfFollow()
            : ProfileSelfFollow(message),
      'CV_EMPTY' => const ProfileCvEmpty(kCvEmptyAppMessage),
      _ => ProfileUnavailable(switch (failure) {
        NetworkFailure() => 'No connection. Check your network and try again.',
        AuthFailure() => 'Your session expired. Sign in again.',
        _ => message ?? 'That did not come through. Try again.',
      }),
    };
  }
}

/// In-memory [ProfileRepository] for the `mock` flavor and the tests: one
/// person's profile, and the handles other people hold. It plays the server's
/// rules — the shape, the taken handles, the 18+ declaration, no self-follow.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({
    this.latency = const Duration(milliseconds: 300),
    String? handle,
    this.adultDeclared = true,
    this.cvReady = true,
    Set<String>? takenHandles,
    Set<String>? publicHandles,
  }) : _handle = handle,
       _taken = takenHandles ?? <String>{'asha-rao', 'admin'},
       _public = publicHandles ?? <String>{'asha-rao', 'vikram-shah'};

  final Duration latency;
  bool adultDeclared;
  final bool cvReady;
  String? _handle;
  final Set<String> _taken;
  final Set<String> _public;
  final Map<String, bool> _following = <String, bool>{};

  /// Every write, in order — what a test reads to see what was sent.
  final List<String> writes = <String>[];

  Future<void> _wait() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  PublicProfileSettings get _settings => PublicProfileSettings(
    handle: _handle,
    published: _handle != null,
    url: _handle == null ? null : publicProfileUrl(_handle!),
    suggestedHandle: _handle == null ? 'priya-sharma' : null,
    adultDeclared: adultDeclared,
    cvReady: cvReady,
  );

  @override
  Future<PublicProfileSettings> fetchSettings() async {
    await _wait();
    return _settings;
  }

  @override
  Future<HandleAvailability> checkHandle(String handle) async {
    await _wait();
    return switch (checkHandleShape(handle)) {
      HandleProblem(:final String message) => HandleAvailability(
        handle: normaliseHandle(handle),
        available: false,
        message: message,
      ),
      HandleOk(handle: final String h)
          when _taken.contains(h) && h != _handle =>
        HandleAvailability(
          handle: h,
          available: false,
          message: 'That handle is taken. Try another.',
        ),
      HandleOk(handle: final String h) => HandleAvailability(
        handle: h,
        available: true,
      ),
    };
  }

  @override
  Future<PublicProfileSettings> publish({
    required String handle,
    bool adult = false,
  }) async {
    await _wait();
    writes.add('publish:$handle${adult ? ':adult' : ''}');
    final HandleCheck c = checkHandleShape(handle);
    if (c is HandleProblem) throw ProfileHandleRefused(c.message);
    final String h = (c as HandleOk).handle;
    if (_taken.contains(h) && h != _handle) throw const ProfileHandleTaken();
    if (!adultDeclared && !adult) throw const ProfileAdultRequired();
    if (adult) adultDeclared = true;
    _handle = h;
    return _settings;
  }

  @override
  Future<PublicProfileSettings> unpublish() async {
    await _wait();
    writes.add('unpublish');
    _handle = null;
    return _settings;
  }

  @override
  Future<FollowState> follow(String handle) async {
    await _wait();
    writes.add('follow:$handle');
    final String h = normaliseHandle(handle);
    if (h == _handle) throw const ProfileSelfFollow();
    if (!_public.contains(h)) throw const ProfileNotFound();
    _following[h] = true;
    return const FollowState(following: true, followers: 12);
  }

  @override
  Future<FollowState> unfollow(String handle) async {
    await _wait();
    writes.add('unfollow:$handle');
    final String h = normaliseHandle(handle);
    if (!_public.contains(h)) throw const ProfileNotFound();
    _following[h] = false;
    return const FollowState(following: false, followers: 11);
  }

  /// Whether this fake follows [handle] — for the contest world's step 2.
  bool follows(String handle) => _following[handle] ?? false;

  @override
  Future<CvFile> downloadCv() async {
    await _wait();
    writes.add('cv');
    if (!cvReady) throw const ProfileCvEmpty(kCvEmptyAppMessage);
    return CvFile(
      bytes: Uint8List.fromList(utf8.encode('%PDF-1.4\n% fake CV\n')),
      fileName: 'Priya-Sharma-CV.pdf',
    );
  }
}

/// The shape rule, as the fake server applies it. Top-level, so it reaches
/// the domain's `checkHandle` rather than the repository method of that name.
HandleCheck checkHandleShape(String raw) => checkHandle(raw);

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake.
final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeProfileRepository();
      return ApiProfileRepository(ref.watch(dioClientProvider));
    });
