import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/week/week_shape.dart';
import '../../../core/network/dio_client.dart';
import '../domain/plan_slot.dart';
import '../domain/planner_repository.dart';
import '../domain/video_script.dart';
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
  Future<List<VideoScript>> fetchWeekScripts({
    required int week,
    required int season,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.plannerVideoScript,
      queryParameters: <String, dynamic>{'week': week, 'season': season},
    );
    final Object? raw = response.data?['scripts'];
    if (raw is! List) return const <VideoScript>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(VideoScript.fromJson)
        .toList(growable: false);
  }

  @override
  Future<VideoScript?> markScriptPosted({
    required int weekNumber,
    required int season,
    required int dayIndex,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.plannerVideoScript,
        data: <String, dynamic>{
          'weekNumber': weekNumber,
          'season': season,
          'dayIndex': dayIndex,
          'action': 'posted',
        },
      );
      final Object? script = response.data?['script'];
      return script is Map<String, dynamic>
          ? VideoScript.fromJson(script)
          : null;
    } on DioException catch (e) {
      // 404 is "no script for that slot", which is a state rather than a
      // fault — the user tapped on a day Sunday never wrote. Null says so;
      // anything else is a real failure the screen should surface.
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<VideoScript> generateScript({
    required int weekNumber,
    required int season,
    required int dayIndex,
    bool force = false,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plannerVideoScript,
      data: <String, dynamic>{
        'weekNumber': weekNumber,
        'season': season,
        'dayIndex': dayIndex,
        'action': 'generate',
        if (force) 'force': true,
      },
    );
    final Object? script = response.data?['script'];
    if (script is! Map<String, dynamic>) {
      throw StateError('The script could not be written.');
    }
    return VideoScript.fromJson(script);
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
  Future<String> setNewsletterName(String name) async {
    final String trimmed = name.trim();
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plannerNewsletter,
      data: <String, dynamic>{'name': trimmed},
    );
    // The server trims too and its answer is authoritative, but it is the same
    // string — so falling back to ours keeps the caller from having to handle
    // a null it can reason about perfectly well.
    return response.data?['newsletterName'] as String? ?? trimmed;
  }

  @override
  Future<WeeklyArticle?> setArticleSchedule({
    required int weekNumber,
    required int season,
    required DateTime? when,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.plannerArticle,
        data: <String, dynamic>{
          'weekNumber': weekNumber,
          'season': season,
          'action': 'schedule',
          // Explicitly null to CLEAR. Omitting the key would read as "leave it
          // alone", and there would be no way to cancel a reminder.
          'scheduledFor': when?.toUtc().toIso8601String(),
        },
      );
      final Object? article = response.data?['article'];
      return article is Map<String, dynamic>
          ? WeeklyArticle.fromJson(article)
          : null;
    } on DioException catch (e) {
      final int? status = e.response?.statusCode;
      if (status == 400 || status == 404) {
        throw PlannerScheduleRefused(
          _serverMessage(e) ?? 'That reminder could not be set.',
        );
      }
      rethrow;
    }
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
      // Carries the REAL week shape. It used to omit `kind` entirely, so every
      // one of the seven days resolved to DayKind.post — which meant the mock
      // flavor, the thing this app is manually tested on, showed a week the
      // product stopped producing: seven publishable posts, a Generate button
      // on all of them, and no video or newsletter day at all. A fixture that
      // disagrees with the server about the shape of the week hides exactly
      // the bugs it exists to surface.
      for (int i = 0; i < 7; i++)
        PlanSlot(
          day: _days[i],
          format: _formats[i],
          type: i == 4 ? 'poll' : (i.isEven ? 'niche' : 'productive'),
          rawKind: dayKindAt(i).wire,
          restDay: dayKindAt(i) == DayKind.rest,
          title: <String>[
            'The first week decides the year',
            'Three onboarding metrics nobody tracks',
            'What a good day one actually looks like',
            'The handover problem, and how to fix it',
            'Which of these breaks your onboarding?',
            'A checklist you can steal',
            'Why onboarding is a design problem',
          ][i],
          // Only a post day has a publish ladder to climb. The two video days
          // and Thursday stay `planned` for ever on the server too — their
          // real state lives in the script and article rows.
          status: switch (i) {
            0 || 1 => SlotStatus.published,
            _ => SlotStatus.planned,
          },
          postId: i <= 1 ? 'mock-post-$i' : null,
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

  /// Seeded so both video states are walkable without a server: Wednesday is
  /// written and waiting, Friday has nothing — which is the state the
  /// Generate button exists for and the one Sunday's batch failing leaves
  /// behind.
  List<VideoScript> _scripts = <VideoScript>[
    const VideoScript(
      id: 'mock-script-wed',
      weekNumber: 3,
      season: 1,
      dayIndex: 2,
      title: 'The onboarding deck nobody reads',
      hook: 'Your onboarding deck is written for the person who wrote it.',
      caption:
          'We rebuilt ours around the first question a new joiner actually '
          'asks. Week-one attrition halved.\n\nThe deck was never the '
          'problem. The order was.',
      beats: <VideoBeat>[
        VideoBeat(
          seconds: 0,
          say: 'Your onboarding deck is written for the person who wrote it.',
          show: 'Talking to camera, no titles yet.',
        ),
        VideoBeat(
          seconds: 4,
          say:
              'Ours opened with the org chart. Nobody asked for the org '
              'chart.',
          show: 'Cut to a slide of an org chart, then cut away fast.',
        ),
        VideoBeat(
          seconds: 11,
          say:
              'The first question is always the same — what am I supposed to '
              'do today.',
          show: 'Text on screen: "what do I do today?"',
        ),
        VideoBeat(
          seconds: 18,
          say:
              'So we put that on slide one, and moved everything else behind '
              'it.',
          show: 'New deck, slide one, held for a beat.',
        ),
        VideoBeat(
          seconds: 26,
          say: 'Week-one attrition halved. Same content. Different order.',
          show: 'Back to camera.',
        ),
      ],
    ),
  ];

  @override
  Future<List<VideoScript>> fetchWeekScripts({
    required int week,
    required int season,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _scripts;
  }

  @override
  Future<VideoScript?> markScriptPosted({
    required int weekNumber,
    required int season,
    required int dayIndex,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final int i = _scripts.indexWhere(
      (VideoScript v) => v.dayIndex == dayIndex,
    );
    if (i == -1) return null;
    final VideoScript posted = _scripts[i].copyWith(
      status: 'published',
      publishedAt: DateTime.now().toUtc().toIso8601String(),
    );
    _scripts = List<VideoScript>.of(_scripts)..[i] = posted;
    return posted;
  }

  @override
  Future<VideoScript> generateScript({
    required int weekNumber,
    required int season,
    required int dayIndex,
    bool force = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final VideoScript written = VideoScript(
      id: 'mock-script-$dayIndex',
      weekNumber: weekNumber,
      season: season,
      dayIndex: dayIndex,
      title: 'Written on demand',
      hook: 'Nobody gets promoted for the work nobody can see.',
      caption:
          'Write the summary. Send it upward. It is not bragging, it is '
          'reporting.',
      beats: const <VideoBeat>[
        VideoBeat(
          seconds: 0,
          say: 'Nobody gets promoted for the work nobody can see.',
          show: 'Camera, close.',
        ),
        VideoBeat(
          seconds: 6,
          say: 'Not because it did not happen — because nobody was told.',
          show: 'Text on screen: "nobody was told".',
        ),
        VideoBeat(
          seconds: 14,
          say: 'Five lines on a Friday. What shipped, what it changed.',
          show: 'A short written list, held.',
        ),
      ],
    );
    final int i = _scripts.indexWhere(
      (VideoScript v) => v.dayIndex == dayIndex,
    );
    _scripts = List<VideoScript>.of(_scripts);
    if (i == -1) {
      _scripts.add(written);
    } else {
      _scripts[i] = written;
    }
    return written;
  }

  @override
  Future<ArticleState> fetchArticle({int? week, int? season}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return ArticleState(
      weekNumber: 3,
      season: 1,
      // Held, not hardcoded. It used to be a literal, which meant
      // `isFirstArticle` was false for ever under the fake and the whole
      // name-your-newsletter flow — the one this fixture exists to let someone
      // walk — was unreachable on the build the app is manually tested on.
      newsletterName: _newsletterName,
      // Exactly how the server computes it.
      isFirstArticle: _newsletterName == null,
      article:
          const WeeklyArticle(
            id: 'mock-article-1',
            weekNumber: 3,
            season: 1,
            newsletterNameSuggestions: <String>[
              'The Onboarding Letter',
              'First Week',
              'Day One',
              'The Joining Note',
              'Week One Review',
            ],
            // The SERVER counts this, from a body this fixture only stubs.
            // Left unset it rendered "0 min read" on the one build the app is
            // manually tested on — a number that is never zero in production,
            // for an article the spec puts at 1200–1800 words.
            readingMinutes: 7,
            title:
                'Onboarding is a design problem, not a documentation problem',
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
          ).copyWith(
            // Read back from what setArticleSchedule and markArticlePublished
            // stored, so both flows are walkable end to end against the fake.
            scheduledFor: _articleScheduledFor,
            publishedAt: _articlePublishedAt,
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

  /// Null to begin with, so the first-article flow is the state the mock
  /// opens in. Set by [setNewsletterName] and read back by [fetchArticle],
  /// which is what makes the whole loop walkable without a server.
  String? _newsletterName;

  @override
  Future<String> setNewsletterName(String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _newsletterName = name.trim();
  }

  /// Held so fetchArticle can read them back. Both start null, which is the
  /// state the reminder prompt and the "I published it" button exist for — a
  /// fixture that returned either would hide the flow it stands in for.
  String? _articleScheduledFor;
  String? _articlePublishedAt;

  @override
  Future<WeeklyArticle?> setArticleSchedule({
    required int weekNumber,
    required int season,
    required DateTime? when,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    // Refuses for the same two reasons the server does, so both failure
    // messages are walkable without a backend.
    if (_articlePublishedAt != null) {
      throw const PlannerScheduleRefused(
        'You have already published this one — there is nothing left to '
        'remind you about.',
      );
    }
    if (when != null && !when.isAfter(DateTime.now())) {
      throw const PlannerScheduleRefused(
        'Pick a time that has not already passed.',
      );
    }
    _articleScheduledFor = when?.toUtc().toIso8601String();
    return null;
  }

  @override
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _articlePublishedAt = DateTime.now().toUtc().toIso8601String();
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
