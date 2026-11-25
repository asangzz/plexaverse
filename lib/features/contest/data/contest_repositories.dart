import 'dart:typed_data';

import 'package:dio/dio.dart'
    show DioException, DioMediaType, FormData, MultipartFile, Response;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../../../core/plan/plan_refusal.dart';
import '../domain/contest_repository.dart';
import '../domain/shoutout_words.dart';
import 'fake_contest_world.dart';

export 'fake_contest_world.dart' show FakeContestScenario, FakeContestWorld;

/// Dio-backed [ContestRepository].
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so `response.data`
/// is already the web's own body — `{overview}`, `{path}`, `{quiz}`, … — and
/// every DTO here is the web type, one to one.
///
/// ## The code before the class
///
/// A rejection arrives as a [Failure] on `DioException.error`, and the
/// contest's refusals keep the web's statuses: 403 NOT_ENTERED reaches here
/// as an [AuthFailure], 503 STORAGE_UNAVAILABLE as a [NetworkFailure]. So
/// [_mapped] reads `errorCode` first and turns every code the contest speaks
/// into its [ContestRefusal]; the class only decides the sentence for a
/// failure that carries none of them. A screen that switched on the class
/// would tell a non-entrant their session had expired.
class ApiContestRepository implements ContestRepository {
  const ApiContestRepository(this._client);

  final DioClient _client;

  /// The layout this build draws: the open-all-week Sunday levels. Sent on
  /// the path, the skip and both plan calls alike — the server decides a
  /// lock or a skip on the layout the caller says it draws.
  static const Map<String, dynamic> _setupLevels = <String, dynamic>{
    'setupLevels': '1',
  };

  @override
  Future<ContestOverview?> fetchOverview() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contest);
    final Map<String, dynamic> data = _body(r);
    // `{overview: null}` is an answer — no contest — and still a 200. A
    // missing body is not: reading it as "no contest" would show the waiting
    // room over a request that never arrived.
    final Object? overview = data['overview'];
    return overview is Map<String, dynamic>
        ? ContestOverview.fromJson(overview)
        : null;
  });

  @override
  Future<BoardResult> fetchBoard({int? limit}) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.contestBoard,
          queryParameters: <String, dynamic>{'limit': ?limit},
        );
    return BoardResult.fromJson(_body(r));
  });

  /// With `followLevel=1`: this build draws "Follow last round's top
  /// learners" and opens its screen. Without the flag the server leaves the
  /// node out, for the builds before it that would draw it as a dead lock.
  ///
  /// With `setupLevels=1` (25 Nov 2026): this build draws the open-all-week
  /// Sunday levels — the week's set-up steps as Sunday's nodes, outside the
  /// gate. The same flag goes on the skip and the plan routes, so a lock or a
  /// skip is decided on the layout drawn here.
  @override
  Future<ContestPath> fetchPath() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.contestPath,
          queryParameters: <String, dynamic>{
            'followLevel': '1',
            ..._setupLevels,
          },
        );
    return ContestPath.fromJson(_inner(_body(r), 'path'));
  });

  @override
  Future<TodayQuiz> fetchTodayQuiz() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestLesson);
    return TodayQuiz.fromJson(_inner(_body(r), 'quiz'));
  });

  @override
  Future<TodayQuiz> startLesson() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(ApiPaths.contestLesson);
    return TodayQuiz.fromJson(_inner(_body(r), 'quiz'));
  });

  @override
  Future<QuizAnswerResult> answerQuiz({
    required int day,
    required String itemId,
    required String value,
  }) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.contestQuizAnswer,
          data: <String, dynamic>{'day': day, 'itemId': itemId, 'value': value},
        );
    return QuizAnswerResult.fromJson(_inner(_body(r), 'result'));
  });

  @override
  Future<CommentLevelView> fetchCommentLevel() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestTaskComment);
    return CommentLevelView.fromJson(_inner(_body(r), 'level'));
  });

  @override
  Future<CommentSubmitResult> submitComment(List<String> words) =>
      _call(() async {
        final Response<Map<String, dynamic>> r = await _client
            .post<Map<String, dynamic>>(
              ApiPaths.contestTaskCommentAnswer,
              data: <String, dynamic>{'words': words},
            );
        return CommentSubmitResult.fromJson(_inner(_body(r), 'result'));
      });

  @override
  Future<FeedCommentsView> fetchFeedComments() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestTaskFeedComments);
    return FeedCommentsView.fromJson(_inner(_body(r), 'view'));
  });

  @override
  Future<FeedCommentSubmitResult> submitFeedComment(String link) =>
      _call(() async {
        final Response<Map<String, dynamic>> r = await _client
            .post<Map<String, dynamic>>(
              ApiPaths.contestTaskFeedComments,
              data: <String, dynamic>{'link': link},
            );
        return FeedCommentSubmitResult.fromJson(_inner(_body(r), 'result'));
      });

  /// Bare inside `data`, unlike its neighbours: the same body as
  /// `ai/connections`, so the one [ConnectionBatch] reads both.
  @override
  Future<ConnectionBatch> fetchConnectTargets() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestTaskConnect);
    return ConnectionBatch.fromJson(_body(r));
  });

  @override
  Future<ConnectTaskResult> completeConnect() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(ApiPaths.contestTaskConnect);
    return ConnectTaskResult.fromJson(_inner(_body(r), 'result'));
  });

  /// One file, multipart, under `screenshot`.
  ///
  /// The part's content type is set from the file name rather than left to
  /// Dio, which falls back to `application/octet-stream` for a name it does
  /// not recognise — and the route refuses anything that is not `image/*` as
  /// INVALID_IMAGE. Oversized files are refused here, before a byte is sent.
  @override
  Future<InvitesSubmitResult> submitInvites(
    Uint8List bytes,
    String filename,
  ) async {
    if (bytes.length > kMaxInvitesScreenshotBytes) {
      throw const ContestTooLarge('That screenshot is over 8 MB.');
    }
    return _call(() async {
      final FormData form = FormData.fromMap(<String, dynamic>{
        'screenshot': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: imageTypeOf(filename),
        ),
      });
      final Response<Map<String, dynamic>> r = await _client
          .sendMultipart<Map<String, dynamic>>(
            ApiPaths.contestTaskInvites,
            form,
          );
      return InvitesSubmitResult.fromJson(_inner(_body(r), 'result'));
    });
  }

  /// The `image/*` type a screenshot's name says it is; JPEG when it says
  /// nothing, which is what the picker re-encodes to.
  static DioMediaType imageTypeOf(String filename) {
    final String n = filename.toLowerCase();
    if (n.endsWith('.png')) return DioMediaType('image', 'png');
    if (n.endsWith('.webp')) return DioMediaType('image', 'webp');
    if (n.endsWith('.gif')) return DioMediaType('image', 'gif');
    if (n.endsWith('.heic')) return DioMediaType('image', 'heic');
    return DioMediaType('image', 'jpeg');
  }

  @override
  Future<PlanWeekView> fetchPlanWeek() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(
          ApiPaths.contestTaskPlan,
          queryParameters: _setupLevels,
        );
    return PlanWeekView.fromJson(_inner(_body(r), 'view'));
  });

  @override
  Future<PlanWeekResult> completePlanWeek() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.contestTaskPlan,
          queryParameters: _setupLevels,
        );
    return PlanWeekResult.fromJson(_inner(_body(r), 'result'));
  });

  @override
  Future<ClaimResult> claimPostLink({
    required ClaimKind kind,
    required String occurrence,
    required String postUrl,
  }) async {
    // Never sent: a piece this build cannot name is not one to claim.
    if (kind == ClaimKind.unknown) {
      throw const ContestInvalid('That is not one of this week’s pieces.');
    }
    return _call(() async {
      final Response<Map<String, dynamic>> r = await _client
          .post<Map<String, dynamic>>(
            ApiPaths.contestTaskClaim,
            data: <String, dynamic>{
              'kind': kind.wire,
              'occurrence': occurrence,
              'postUrl': postUrl,
            },
          );
      return ClaimResult.fromJson(_inner(_body(r), 'result'));
    });
  }

  @override
  Future<SkipResult> skipLevel(String nodeId) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.contestSkip,
          queryParameters: _setupLevels,
          data: <String, dynamic>{'nodeId': nodeId},
        );
    return SkipResult.fromJson(_inner(_body(r), 'result'));
  });

  @override
  Future<ConsistencyView> fetchConsistency() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestConsistency);
    return ConsistencyView.fromJson(_inner(_body(r), 'consistency'));
  });

  /// Bare inside `data`: the web's `{week, hallOfFame}`.
  @override
  Future<ContestFeatured> fetchFeatured() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestFeatured);
    return ContestFeatured.fromJson(_body(r));
  });

  /// Bare inside `data`: `{featured, linkedinUrl}`.
  @override
  Future<ShoutoutSettings> fetchShoutout() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestShoutout);
    return ShoutoutSettings.fromJson(_body(r));
  });

  /// A withdrawal sends `featured: false` and nothing else: it needs no
  /// link, and a stale one riding along could only confuse the record.
  @override
  Future<ShoutoutSettings> setShoutout({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  }) => _call(() async {
    final String? link = linkedinUrl?.trim();
    final Response<Map<String, dynamic>> r = await _client
        .put<Map<String, dynamic>>(
          ApiPaths.contestShoutout,
          // A literal bool, as the join's consent is: nothing but the box the
          // learner ticked can grant it. The 18+ tick only rides with a yes,
          // and so does the notice date of the words this card showed — the
          // server refuses a yes without the current one (UPDATE_REQUIRED).
          data: <String, dynamic>{
            'featured': featured,
            if (featured && link != null && link.isNotEmpty)
              'linkedinUrl': link,
            if (featured && adult) 'adult': true,
            if (featured) 'wordsVersion': kShoutoutWordsVersion,
          },
        );
    return ShoutoutSettings.fromJson(_body(r));
  });

  @override
  Future<FollowWinnersView> fetchFollowWinners() => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .get<Map<String, dynamic>>(ApiPaths.contestTaskFollowWinners);
    return FollowWinnersView.fromJson(_inner(_body(r), 'view'));
  });

  @override
  Future<FollowWinnerStepResult> recordFollowWinnerStep({
    required String handle,
    required FollowWinnerStep step,
  }) => _call(() async {
    final Response<Map<String, dynamic>> r = await _client
        .post<Map<String, dynamic>>(
          ApiPaths.contestTaskFollowWinners,
          data: <String, dynamic>{'handle': handle, 'step': step.wire},
        );
    return FollowWinnerStepResult.fromJson(_inner(_body(r), 'result'));
  });

  // ── The seam ─────────────────────────────────────────────────────────────

  static Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw _mapped(e);
    }
  }

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> r) {
    final Map<String, dynamic>? data = r.data;
    if (data == null) throw const ContestUnavailable();
    return data;
  }

  /// The web body's one key — `{path}`, `{quiz}`, `{result}` …
  static Map<String, dynamic> _inner(Map<String, dynamic> data, String key) {
    final Object? inner = data[key];
    if (inner is! Map<String, dynamic>) throw const ContestUnavailable();
    return inner;
  }

  /// Every code the contest's routes refuse with, each to its refusal. A
  /// missing sentence falls back to the refusal's own default.
  static final Map<String, ContestRefusal Function([String])> _byCode =
      <String, ContestRefusal Function([String])>{
        'NOT_ENTERED': ContestNotEntered.new,
        'NOT_RUNNING': ContestNotRunning.new,
        'NOT_IN_LEVEL': ContestNotInLevel.new,
        'LOCKED': ContestLocked.new,
        'STALE_QUIZ': ContestStale.new,
        'NOT_TODAY': ContestNotToday.new,
        'NO_QUIZ': ContestNoQuiz.new,
        'WRONG_DAY': ContestWrongDay.new,
        'TOO_EARLY': ContestTooEarly.new,
        'NOT_READY': ContestNotReady.new,
        'NOT_OPEN': ContestNotOpen.new,
        'ALREADY_DONE': ContestAlreadyDone.new,
        'DUPLICATE_URL': ContestDuplicateUrl.new,
        'BAD_URL': ContestBadUrl.new,
        'REVOKED': ContestRevoked.new,
        'CONFLICT': ContestConflict.new,
        'TOO_LARGE': ContestTooLarge.new,
        'INVALID_IMAGE': ContestInvalidImage.new,
        'STORAGE_UNAVAILABLE': ContestStorageUnavailable.new,
        'VALIDATION_FAILED': ContestInvalid.new,
        'PROFILE_INCOMPLETE': ContestProfileIncomplete.new,
        'INVALID_LINKEDIN_URL': ContestBadProfileLink.new,
        'ADULT_REQUIRED': ContestAdultRequired.new,
      };

  /// A rejection, as the refusal the UI branches on.
  ///
  /// The plan gate first (only the connect level's targets meet it, as a 402
  /// whose `details` the interceptor drops — [PlanRefusal] reads them off the
  /// raw body), then the contest's own code at any status, and only then the
  /// [Failure]'s class.
  static ContestRefusal _mapped(DioException e) {
    final PlanRefusal? plan = PlanRefusal.fromDioException(e);
    if (plan != null) return ContestPlanRefused(plan);

    final Object? error = e.error;
    final Failure? failure = error is Failure ? error : null;
    final String? said = failure?.message?.trim();
    final String? message = said == null || said.isEmpty ? null : said;

    final ContestRefusal Function([String])? make = _byCode[failure?.errorCode];
    if (make != null) return message == null ? make() : make(message);
    return ContestUnavailable(message ?? _sentenceFor(failure));
  }

  /// What to say for a failure that carried no sentence of its own.
  static String _sentenceFor(Failure? failure) => switch (failure) {
    NetworkFailure() => 'No connection. Check your network and try again.',
    // Reached the server, which is still working on it. Never tell someone
    // to check a connection that demonstrably worked.
    TimeoutFailure() =>
      'That took longer than expected. It may still have gone through — '
          'check before trying again.',
    AuthFailure() => 'Your session expired. Sign in again.',
    _ => 'That did not come through. Try again.',
  };
}

/// In-memory [ContestRepository] for the `mock` flavor and the tests.
///
/// Every call waits a moment, as the network does, and is answered by the
/// [FakeContestWorld] for its [scenario] — which plays the server, rules and
/// all. The answer key lives there and nowhere else.
class FakeContestRepository implements ContestRepository {
  FakeContestRepository({
    this.scenario = FakeContestScenario.running,
    this.latency = const Duration(milliseconds: 350),
  });

  final FakeContestScenario scenario;
  final Duration latency;

  FakeContestWorld get _world => FakeContestWorld.of(scenario);

  Future<T> _answer<T>(T Function(FakeContestWorld world) read) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return read(_world);
  }

  @override
  Future<ContestOverview?> fetchOverview() =>
      _answer((FakeContestWorld w) => w.overview());

  @override
  Future<BoardResult> fetchBoard({int? limit}) =>
      _answer((FakeContestWorld w) => w.board(limit: limit));

  @override
  Future<ContestPath> fetchPath() => _answer((FakeContestWorld w) => w.path());

  @override
  Future<TodayQuiz> fetchTodayQuiz() =>
      _answer((FakeContestWorld w) => w.quiz());

  @override
  Future<TodayQuiz> startLesson() =>
      _answer((FakeContestWorld w) => w.startLesson());

  @override
  Future<QuizAnswerResult> answerQuiz({
    required int day,
    required String itemId,
    required String value,
  }) => _answer(
    (FakeContestWorld w) => w.answer(day: day, itemId: itemId, value: value),
  );

  @override
  Future<CommentLevelView> fetchCommentLevel() =>
      _answer((FakeContestWorld w) => w.commentLevel());

  @override
  Future<CommentSubmitResult> submitComment(List<String> words) =>
      _answer((FakeContestWorld w) => w.submitComment(words));

  @override
  Future<FeedCommentsView> fetchFeedComments() =>
      _answer((FakeContestWorld w) => w.feedComments());

  @override
  Future<FeedCommentSubmitResult> submitFeedComment(String link) =>
      _answer((FakeContestWorld w) => w.submitFeedComment(link));

  @override
  Future<ConnectionBatch> fetchConnectTargets() =>
      _answer((FakeContestWorld w) => w.connectTargets());

  @override
  Future<ConnectTaskResult> completeConnect() =>
      _answer((FakeContestWorld w) => w.completeConnect());

  @override
  Future<InvitesSubmitResult> submitInvites(Uint8List bytes, String filename) =>
      _answer((FakeContestWorld w) => w.submitInvites(bytes));

  @override
  Future<PlanWeekView> fetchPlanWeek() =>
      _answer((FakeContestWorld w) => w.planWeek());

  @override
  Future<PlanWeekResult> completePlanWeek() =>
      _answer((FakeContestWorld w) => w.completePlanWeek());

  @override
  Future<ClaimResult> claimPostLink({
    required ClaimKind kind,
    required String occurrence,
    required String postUrl,
  }) => _answer(
    (FakeContestWorld w) =>
        w.claim(kind: kind, occurrence: occurrence, postUrl: postUrl),
  );

  @override
  Future<SkipResult> skipLevel(String nodeId) =>
      _answer((FakeContestWorld w) => w.skip(nodeId));

  @override
  Future<ConsistencyView> fetchConsistency() =>
      _answer((FakeContestWorld w) => w.consistency());

  @override
  Future<ContestFeatured> fetchFeatured() =>
      _answer((FakeContestWorld w) => w.featured());

  @override
  Future<ShoutoutSettings> fetchShoutout() =>
      _answer((FakeContestWorld w) => w.shoutout());

  @override
  Future<ShoutoutSettings> setShoutout({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  }) => _answer(
    (FakeContestWorld w) => w.setShoutout(
      featured: featured,
      linkedinUrl: linkedinUrl,
      adult: adult,
    ),
  );

  @override
  Future<FollowWinnersView> fetchFollowWinners() =>
      _answer((FakeContestWorld w) => w.followWinners());

  @override
  Future<FollowWinnerStepResult> recordFollowWinnerStep({
    required String handle,
    required FollowWinnerStep step,
  }) => _answer(
    (FakeContestWorld w) => w.followWinnerStep(handle: handle, step: step),
  );
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice. The mock flavor's
/// scenario comes from `--dart-define=FAKE_CONTEST`.
final Provider<ContestRepository> contestRepositoryProvider =
    Provider<ContestRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) {
        return FakeContestRepository(
          scenario: FakeContestScenario.fromEnvironment(),
        );
      }
      return ApiContestRepository(ref.watch(dioClientProvider));
    });
