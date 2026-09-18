import 'package:dio/dio.dart' show DioException;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/engagement_repository.dart';

/// Dio-backed [EngagementRepository].
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so `response.data`
/// is already the inner payload, and a rejection arrives as a [Failure] on
/// `DioException.error` — never as a raw status code.
///
/// **Every path is a constant from [ApiPaths].** Both screens sit entirely on
/// endpoints that already exist: `/ai/comments`, `/ai/connections`,
/// `/ai/style-memory` and `/roadmap/progress`. What does NOT exist is a way to
/// ask for a *fresh* batch — see [generateComments].
class ApiEngagementRepository implements EngagementRepository {
  const ApiEngagementRepository(this._client);

  final DioClient _client;

  /// `POST /ai/comments`.
  ///
  /// ## No "new set" on mobile
  ///
  /// The web sends `{ topic, force }` and prices a regenerate at ~50 XP.
  /// `generateComments()` in the service does honour `options.force`, but the
  /// mobile route at `app/api/mobile/v1/ai/comments/route.ts` calls it as
  /// `generateComments(me.sub, body?.topic)` — it never forwards a force flag.
  /// So sending one would be accepted, ignored, and answered with today's
  /// cached batch, which is exactly the silent no-op this codebase keeps
  /// getting burned by. We therefore do not send it, and the screen renders the
  /// "new set" control disabled with an honest note rather than a button that
  /// charges nothing and changes nothing.
  @override
  Future<CommentBatch> generateComments({String? topic}) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiComments,
        // Empty string, not omitted: the server treats a blank topic as
        // "pick one from my niche", which is the normal path.
        data: <String, dynamic>{'topic': topic?.trim() ?? ''},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const EngagementFailure(EngagementBlock.unavailable);
      }
      final CommentBatch batch = CommentBatch.fromJson(data);
      // Seed each draft's teaching baseline with what the model produced, so
      // an untouched comment never teaches the model its own output back.
      return batch.copyWith(
        comments: <CommentDraft>[
          for (final CommentDraft draft in batch.comments)
            draft.copyWith(taughtText: draft.comment),
        ],
      );
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  /// `POST /ai/connections`.
  ///
  /// The body is empty on purpose. The route accepts an optional `profession`
  /// override, but overriding it from the client would let this screen aim a
  /// batch at a profession the profile does not claim — and the server's
  /// `PROFILE_INCOMPLETE` guard exists precisely to stop XP being spent on a
  /// profile that cannot produce a useful list.
  ///
  /// Same missing-`force` story as [generateComments]: the mobile route passes
  /// only `{ profession }` to `findConnections`, so a fresh set cannot be asked
  /// for from here.
  @override
  Future<ConnectionBatch> findConnections() async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiConnections,
        data: const <String, dynamic>{},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const EngagementFailure(EngagementBlock.unavailable);
      }
      return ConnectionBatch.fromJson(data);
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  @override
  Future<void> teachStyle({required String text, String? topic}) async {
    if (text.trim().isEmpty) return;
    try {
      await _client.post<Map<String, dynamic>>(
        ApiPaths.aiStyleMemory,
        data: <String, dynamic>{'text': text, 'topic': ?topic},
      );
    } on Object {
      // Fire and forget, exactly like the web's `.catch(console.error)` on
      // textarea blur. The user did not ask for this call and cannot act on
      // its failure; surfacing it would be noise on top of their own edit.
    }
  }

  @override
  Future<RoadmapProgress> fetchRoadmapProgress() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.roadmapProgress,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) {
        throw const EngagementFailure(EngagementBlock.unavailable);
      }
      return RoadmapProgress.fromJson(data);
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    try {
      await _client.post<Map<String, dynamic>>(
        ApiPaths.roadmapProgress,
        // The web sends `task: 'complete_step'` as well; the mobile route
        // reads only levelId and stepId and has no task discriminator, so
        // sending one would be dead weight on the wire.
        data: <String, dynamic>{'levelId': levelId, 'stepId': stepId},
      );
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  /// Maps a wire rejection onto the typed refusal the screens branch on.
  ///
  /// ## Why this reaches past [Failure]
  ///
  /// The mobile envelope puts its stable code at `error.code`, but
  /// `ErrorInterceptor._extractErrorCode` only looks at the body's TOP level,
  /// so `Failure.errorCode` is null for every enveloped rejection. Status alone
  /// is not enough — `PROFILE_INCOMPLETE` and an ordinary validation error are
  /// both 400 — so the code is read from the raw body here, with the status as
  /// the fallback. That is a gap in `core/network`, which this slice does not
  /// own; it is reported to the orchestrator rather than patched from here.
  EngagementFailure _translate(DioException e) {
    final String? code = _envelopeCode(e);
    final Object? failure = e.error;
    final String? message = failure is Failure ? failure.message : e.message;
    final int? status = failure is ServerFailure
        ? failure.statusCode
        : (failure is ClientFailure ? failure.statusCode : null);

    if (code == 'INSUFFICIENT_XP' || status == 402) {
      return EngagementFailure(
        EngagementBlock.insufficientXp,
        message: message,
      );
    }
    if (code == 'PROFILE_INCOMPLETE') {
      return EngagementFailure(
        EngagementBlock.profileIncomplete,
        message: message,
      );
    }
    return EngagementFailure(EngagementBlock.unavailable, message: message);
  }

  /// `body.error.code` from the raw rejection body, or null.
  static String? _envelopeCode(DioException e) {
    final Object? body = e.response?.data;
    if (body is! Map) return null;
    final Object? error = body['error'];
    if (error is! Map) return null;
    final Object? code = error['code'];
    return code is String && code.isNotEmpty ? code : null;
  }
}

/// In-memory [EngagementRepository] for the `mock` flavor.
///
/// Shaped like a real mid-habit state so every branch of both screens is
/// reachable without a backend: a cached batch (so the free-replay note shows),
/// a priced regenerate, one direct-message card among the connection targets,
/// and a note deliberately pushed past 270 characters so the amber counter
/// renders.
class FakeEngagementRepository implements EngagementRepository {
  FakeEngagementRepository();

  final Set<String> _completed = <String>{};

  @override
  Future<CommentBatch> generateComments({String? topic}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final String picked = (topic == null || topic.trim().isEmpty)
        ? 'career growth'
        : topic.trim();
    return CommentBatch(
      topic: picked,
      cached: true,
      xpCost: 50,
      comments: const <CommentDraft>[
        CommentDraft(
          targetPostTitle: 'A hiring manager on why most CVs get 6 seconds',
          searchKeywords: 'hiring resume screening',
          comment:
              'Six seconds is generous. I time-boxed a screen last quarter and '
              'the median was under four. What changed my shortlist was not the '
              'layout — it was whether line one said what the person actually '
              'owned. Do you find ownership or outcomes reads faster?',
          taughtText:
              'Six seconds is generous. I time-boxed a screen last quarter and '
              'the median was under four. What changed my shortlist was not the '
              'layout — it was whether line one said what the person actually '
              'owned. Do you find ownership or outcomes reads faster?',
        ),
        CommentDraft(
          targetPostTitle: 'A founder post about saying no to good work',
          searchKeywords: 'focus prioritisation founders',
          comment:
              'The hard nos are never the bad ideas. They are the good ones '
              'arriving in the wrong quarter. We started writing the reason on '
              'the card instead of just closing it, and half of them came back '
              'better six months later. How do you keep the good nos findable?',
          taughtText:
              'The hard nos are never the bad ideas. They are the good ones '
              'arriving in the wrong quarter. We started writing the reason on '
              'the card instead of just closing it, and half of them came back '
              'better six months later. How do you keep the good nos findable?',
        ),
        CommentDraft(
          targetPostTitle: 'A thread on remote onboarding going wrong',
          searchKeywords: 'remote onboarding first week',
          comment:
              'Week one is a design problem, not a documentation problem. Every '
              'team I have seen fix it did the same thing: gave the new joiner '
              'one real, shippable task on day two. What was the smallest change '
              'that moved it for you?',
          taughtText:
              'Week one is a design problem, not a documentation problem. Every '
              'team I have seen fix it did the same thing: gave the new joiner '
              'one real, shippable task on day two. What was the smallest change '
              'that moved it for you?',
        ),
      ],
    );
  }

  @override
  Future<ConnectionBatch> findConnections() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const ConnectionBatch(
      profession: 'Senior Product Manager',
      cached: true,
      xpCost: 50,
      connections: <ConnectionTarget>[
        ConnectionTarget(
          role: 'Head of Product',
          company: 'Razorpay',
          searchQuery: 'Head of Product Razorpay',
          linkedinSearchUrl:
              'https://www.linkedin.com/search/results/people/?keywords=Head%20of%20Product%20Razorpay',
          note:
              'Hi — I lead product on a small team shipping into Indian fintech, '
              'and I have been following how your payments surface handles '
              'failed-retry UX. Would be glad to connect and trade notes.',
        ),
        ConnectionTarget(
          role: 'Director of Engineering',
          company: 'Zerodha',
          searchQuery: 'Director of Engineering Zerodha',
          linkedinSearchUrl:
              'https://www.linkedin.com/search/results/people/?keywords=Director%20of%20Engineering%20Zerodha',
          note:
              'Hello — we are solving a similar reliability problem on a much '
              'smaller scale, and your team writes about it more honestly than '
              'most. Connecting to keep learning from it.',
        ),
        ConnectionTarget(
          role: 'VP Product',
          company: 'Freshworks',
          searchQuery: 'VP Product Freshworks',
          linkedinSearchUrl:
              'https://www.linkedin.com/search/results/people/?keywords=VP%20Product%20Freshworks',
          note:
              'Hi — I work on product in a company roughly where yours was five '
              'years ago, and the way your team staged the move upmarket is the '
              'clearest account of it I have read anywhere. I would like to '
              'connect and follow how the next stage goes, if you are open to it.',
        ),
        ConnectionTarget(
          role: 'Group Product Manager',
          company: 'Swiggy',
          searchQuery: 'Group Product Manager Swiggy',
          linkedinSearchUrl:
              'https://www.linkedin.com/search/results/people/?keywords=Group%20Product%20Manager%20Swiggy',
          note:
              'Hi — I lead a product team working on scheduling and I keep '
              'coming back to how your side handles supply peaks. Would be good '
              'to connect.',
        ),
        ConnectionTarget(
          role: 'Any Senior Product Manager',
          company: 'Open Profile',
          searchQuery: 'Senior Product Manager India',
          linkedinSearchUrl:
              'https://www.linkedin.com/search/results/people/?keywords=Senior%20Product%20Manager%20India',
          isDirectMessage: true,
          note:
              'Hi — I am a product manager building in the same space and I am '
              'trying to meet more people doing this work outside my own company. '
              'No pitch; just glad to compare notes when you have a minute.',
        ),
      ],
    );
  }

  @override
  Future<void> teachStyle({required String text, String? topic}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  @override
  Future<RoadmapProgress> fetchRoadmapProgress() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return RoadmapProgress(
      currentDay: 12,
      completedSteps: _completed.toList(growable: false),
      roadmapStartedAt: DateTime.now().subtract(const Duration(days: 11)),
    );
  }

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _completed.add('$levelId-$stepId');
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<EngagementRepository> engagementRepositoryProvider =
    Provider<EngagementRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeEngagementRepository();
      return ApiEngagementRepository(ref.watch(dioClientProvider));
    });
