import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/plan_slot.dart';
import '../domain/planner_repository.dart';
import '../domain/weekly_article.dart';
import 'package:dio/dio.dart';
import '../../../core/network/failure.dart';

/// Dio-backed [PlannerRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner object.
class ApiPlannerRepository implements PlannerRepository {
  const ApiPlannerRepository(this._client);

  final DioClient _client;

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.planner,
      queryParameters: <String, dynamic>{'week': ?week, 'season': ?season},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const PlannerState();
    return PlannerState.fromJson(data);
  }

  @override
  Future<ApproveResult> approveSlot({
    required String planId,
    required int slotIndex,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.planner,
      data: <String, dynamic>{
        'planId': planId,
        'slotIndex': slotIndex,
        'updates': <String, dynamic>{'status': 'approved'},
      },
    );
    final Map<String, dynamic>? data = response.data;
    final Map<String, dynamic>? plan = data?['plan'] as Map<String, dynamic>?;
    if (plan == null) {
      throw StateError('planner approve returned no plan');
    }
    final String? when = data?['scheduledFor'] as String?;
    return ApproveResult(
      plan: WeekPlan.fromJson(plan),
      scheduledFor: when == null ? null : DateTime.tryParse(when)?.toLocal(),
      postUpdated: data?['postUpdated'] == true,
    );
  }

  @override
  Future<GeneratedSlot> generateSlotPost({
    required String planId,
    required int slotIndex,
    bool force = false,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.plannerGeneratePost,
        data: <String, dynamic>{
          'planId': planId,
          'slotIndex': slotIndex,
          'force': force,
        },
      );
      final Map<String, dynamic>? data = response.data;
      return GeneratedSlot(
        postId: data?['postId'] as String?,
        alreadyGenerated: data?['alreadyGenerated'] == true,
      );
    } on DioException catch (e) {
      throw PlannerGenerateFailure(
        kind: _generateKind(e),
        message: _serverMessage(e),
      );
    } on Object {
      throw const PlannerGenerateFailure(
        kind: PlannerGenerateFailureKind.failed,
      );
    }
  }

  /// Maps the server's code onto the three genuinely different next actions.
  static PlannerGenerateFailureKind _generateKind(DioException e) {
    final Object? failure = e.error;
    final String? code = failure is Failure ? failure.errorCode : null;
    if (code == 'INSUFFICIENT_XP' || e.response?.statusCode == 402) {
      return PlannerGenerateFailureKind.insufficientXp;
    }
    if (code == 'NO_LINKEDIN_ACCOUNT') {
      return PlannerGenerateFailureKind.noLinkedinAccount;
    }
    // The week stopped being seven posts, so the generator now refuses five
    // days in seven. Without this branch those came back as `failed`, which
    // offers a retry that cannot ever succeed.
    if (code == 'NOT_A_POST_DAY') {
      return PlannerGenerateFailureKind.notAPostDay;
    }
    return PlannerGenerateFailureKind.failed;
  }

  static String? _serverMessage(DioException e) {
    final Object? failure = e.error;
    if (failure is Failure) {
      final String? m = failure.message;
      if (m != null && m.isNotEmpty) return m;
    }
    return null;
  }

  @override
  Future<GeneratedSlot> generateSlotCarousel({
    required String planId,
    required int slotIndex,
    bool force = false,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.plannerGenerateCarousel,
        data: <String, dynamic>{
          'planId': planId,
          'slotIndex': slotIndex,
          'force': force,
        },
      );
      final Map<String, dynamic>? data = response.data;
      return GeneratedSlot(
        postId: data?['postId'] as String?,
        alreadyGenerated: data?['alreadyGenerated'] == true,
      );
    } on DioException catch (e) {
      throw PlannerGenerateFailure(
        kind: _generateKind(e),
        message: _serverMessage(e),
      );
    } on Object {
      throw const PlannerGenerateFailure(
        kind: PlannerGenerateFailureKind.failed,
      );
    }
  }

  @override
  Future<WeekPlan> changeTopic({
    required String planId,
    required String topic,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plannerChangeTopic,
      data: <String, dynamic>{'planId': planId, 'topic': topic},
    );
    final Map<String, dynamic>? data = response.data;
    // The service answers with the re-planned week, either bare or under a
    // `plan` key depending on the shape it was given.
    final Map<String, dynamic>? plan =
        (data?['plan'] as Map<String, dynamic>?) ?? data;
    if (plan == null) throw StateError('change-topic returned no plan');
    return WeekPlan.fromJson(plan);
  }

  @override
  Future<String> regenerateTitle({
    required String planId,
    required int slotIndex,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plannerRegenerateTitle,
      data: <String, dynamic>{'planId': planId, 'slotIndex': slotIndex},
    );
    final String? title = response.data?['title'] as String?;
    if (title == null || title.isEmpty) {
      throw StateError('regenerate-title returned no title');
    }
    return title;
  }

  @override
  Future<WeekPlan> updateSlot({
    required String planId,
    required int slotIndex,
    String? title,
    bool? titleEditedByUser,
    SlotStatus? status,
    String? posterTag,
  }) async {
    // Only send what changed. The server merges `updates` onto the slot, so a
    // null we did not mean to send would wipe a field.
    final Map<String, dynamic> updates = <String, dynamic>{
      'title': ?title,
      'titleEditedByUser': ?titleEditedByUser,
      'status': ?status?.wire,
      'posterTag': ?posterTag,
    };

    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.planner,
      data: <String, dynamic>{
        'planId': planId,
        'slotIndex': slotIndex,
        'updates': updates,
      },
    );
    final Map<String, dynamic>? plan =
        response.data?['plan'] as Map<String, dynamic>?;
    if (plan == null) {
      throw StateError('planner PATCH returned no plan');
    }
    return WeekPlan.fromJson(plan);
  }

  @override
  Future<ArticleState> fetchArticle({int? week, int? season}) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.plannerArticle,
      queryParameters: <String, dynamic>{'week': ?week, 'season': ?season},
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const ArticleState();
    return ArticleState.fromJson(data);
  }

  @override
  Future<String> fetchArticleBody({int? week, int? season}) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.plannerArticleBody,
      queryParameters: <String, dynamic>{'week': ?week, 'season': ?season},
    );
    return response.data?['body'] as String? ?? '';
  }

  @override
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plannerArticle,
      data: <String, dynamic>{
        'weekNumber': weekNumber,
        'season': season,
        // The server accepts exactly this one action.
        'action': 'published',
        'publishedUrl': ?publishedUrl,
      },
    );
    final Map<String, dynamic>? article =
        response.data?['article'] as Map<String, dynamic>?;
    return article == null ? null : WeeklyArticle.fromJson(article);
  }
}

/// In-memory [PlannerRepository] for the `mock` flavor.
///
/// Shaped like a real mid-week state so the screen's statuses are all
/// exercisable: two published, one awaiting approval, the rest planned.
class FakePlannerRepository implements PlannerRepository {
  FakePlannerRepository();

  static const List<String> _days = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _formats = <String>[
    'image',
    'text',
    'image',
    'image',
    'poll',
    'image',
    'text',
  ];

  WeekPlan _plan = WeekPlan(
    id: 'mock-plan-1',
    weekNumber: 3,
    season: 1,
    phase: 'Credibility',
    topic: 'Why most onboarding fails in week one',
    generatedAt: '2026-09-14T04:00:00.000Z',
    posts: <PlanSlot>[
      for (int i = 0; i < 7; i++)
        PlanSlot(
          day: _days[i],
          format: _formats[i],
          type: i == 4 ? 'poll' : (i.isEven ? 'niche' : 'productive'),
          title: <String>[
            'The first week decides the year',
            'Three onboarding metrics nobody tracks',
            'What a good day one actually looks like',
            'The handover problem, and how to fix it',
            'Which of these breaks your onboarding?',
            'A checklist you can steal',
            'Why onboarding is a design problem',
          ][i],
          status: switch (i) {
            0 || 1 => SlotStatus.published,
            2 => SlotStatus.generated,
            3 => SlotStatus.approved,
            _ => SlotStatus.planned,
          },
          postId: i <= 3 ? 'mock-post-$i' : null,
        ),
    ],
  );

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return PlannerState(plan: _plan, currentWeekNumber: 3, currentSeason: 1);
  }

  @override
  Future<ApproveResult> approveSlot({
    required String planId,
    required int slotIndex,
  }) async {
    final WeekPlan plan = await updateSlot(
      planId: planId,
      slotIndex: slotIndex,
      status: SlotStatus.approved,
    );
    final PlanSlot slot = plan.posts[slotIndex];
    return ApproveResult(
      plan: plan,
      // The fake has no calendar, so it reports the honest "approved but not
      // scheduled" branch rather than inventing a publish time.
      scheduledFor: null,
      postUpdated: slot.postId != null,
    );
  }

  @override
  Future<GeneratedSlot> generateSlotPost({
    required String planId,
    required int slotIndex,
    bool force = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final PlanSlot slot = _plan.posts[slotIndex];
    if (!force && slot.postId != null) {
      return GeneratedSlot(postId: slot.postId, alreadyGenerated: true);
    }
    final String id = 'mock-post-$slotIndex';
    _plan = _plan.copyWith(
      posts: <PlanSlot>[
        for (int i = 0; i < _plan.posts.length; i++)
          if (i == slotIndex)
            _plan.posts[i].copyWith(status: SlotStatus.generated, postId: id)
          else
            _plan.posts[i],
      ],
    );
    return GeneratedSlot(postId: id);
  }

  @override
  Future<GeneratedSlot> generateSlotCarousel({
    required String planId,
    required int slotIndex,
    bool force = false,
  }) => generateSlotPost(planId: planId, slotIndex: slotIndex, force: force);

  @override
  Future<WeekPlan> changeTopic({
    required String planId,
    required String topic,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _plan = _plan.copyWith(topic: topic);
    return _plan;
  }

  @override
  Future<String> regenerateTitle({
    required String planId,
    required int slotIndex,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final String title = 'A sharper line for ${_plan.posts[slotIndex].day}';
    _plan = _plan.copyWith(
      posts: <PlanSlot>[
        for (int i = 0; i < _plan.posts.length; i++)
          if (i == slotIndex)
            _plan.posts[i].copyWith(title: title, titleEditedByUser: false)
          else
            _plan.posts[i],
      ],
    );
    return title;
  }

  @override
  Future<WeekPlan> updateSlot({
    required String planId,
    required int slotIndex,
    String? title,
    bool? titleEditedByUser,
    SlotStatus? status,
    String? posterTag,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final List<PlanSlot> posts = List<PlanSlot>.of(_plan.posts);
    posts[slotIndex] = posts[slotIndex].copyWith(
      title: title ?? posts[slotIndex].title,
      titleEditedByUser:
          titleEditedByUser ?? posts[slotIndex].titleEditedByUser,
      status: status ?? posts[slotIndex].status,
      posterTag: posterTag ?? posts[slotIndex].posterTag,
    );
    _plan = _plan.copyWith(posts: posts);
    return _plan;
  }

  @override
  Future<ArticleState> fetchArticle({int? week, int? season}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const ArticleState(
      weekNumber: 3,
      season: 1,
      newsletterName: 'The Onboarding Letter',
      article: WeeklyArticle(
        id: 'mock-article-1',
        weekNumber: 3,
        season: 1,
        title: 'Onboarding is a design problem, not a documentation problem',
        thesis:
            'Teams keep fixing onboarding by writing more documentation, when '
            'the failure is almost always a design failure in the first week.',
        body:
            'Most teams treat onboarding as a documentation exercise. Write '
            'enough down, the thinking goes, and a new joiner will find their '
            'way.\n\nIt does not work, and the reason is not effort.\n\n'
            '(…full article body…)',
        sections: <String>[
          'The first week decides the year',
          'Three metrics nobody tracks',
          'The handover problem',
          'A checklist you can steal',
        ],
      ),
    );
  }

  @override
  Future<String> fetchArticleBody({int? week, int? season}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    // The fixture carries its body inline; the real one fetches it. The split
    // is a wire concern, so the fake answers the same question either way.
    return (await fetchArticle(week: week, season: season)).article?.body ?? '';
  }

  @override
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return null;
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<PlannerRepository> plannerRepositoryProvider =
    Provider<PlannerRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePlannerRepository();
      return ApiPlannerRepository(ref.watch(dioClientProvider));
    });
