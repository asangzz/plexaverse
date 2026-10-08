import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/mock/fake_autopost_state.dart';
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
        // The route has always sent these two back; nothing read them until
        // the poster call needed a brief to draw from.
        content: data?['content'] as String?,
        posterTitle: data?['posterTitle'] as String?,
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

  /// Slot post type → the poster's visual category. A faithful copy of the
  /// web's `SLOT_TYPE_TO_POSTER_CATEGORY`, which both the planner's preview
  /// panel and its generating modal keep their own copy of. Living here rather
  /// than in the controller keeps a wire value out of the feature's logic —
  /// these are the route's `PosterCategory` strings, not ours.
  static const Map<String, String> _posterCategoryForSlotType =
      <String, String>{
        'niche': 'technical',
        'general': 'thought_leadership',
        'productive': 'thought_leadership',
        'light': 'social_media',
      };

  @override
  Future<String?> generateSlotPoster({
    required String topic,
    required String content,
    required String posterTitle,
    required String slotType,
    required String userName,
    String? profileImageUrl,
    String? posterTag,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'topic': topic,
      'content': content,
      'posterTitle': posterTitle,
      'userName': userName,
      'category': _posterCategoryForSlotType[slotType] ?? 'thought_leadership',
      // Routes the image to the provider this day's type is configured for —
      // without it the planner's own button draws the slot on a different
      // model from the one the Cloud Task would have picked for it.
      'postType': slotType,
      // Sent even when null, which is what the server reads to mean "no style
      // reference". Omitting the key and sending null are the same thing here,
      // but the explicit null matches what the web and the chain send.
      'posterTag': posterTag,
    };
    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      body['profileImageUrl'] = profileImageUrl;
    }

    final Response<Map<String, dynamic>> response = await _client
        .post<Map<String, dynamic>>(ApiPaths.aiPoster, data: body);
    return response.data?['imageUrl'] as String?;
  }

  @override
  Future<void> attachPostImage({
    required String postId,
    required String imageUrl,
  }) async {
    await _client.patch<Map<String, dynamic>>(
      ApiPaths.post(postId),
      data: <String, dynamic>{'imageUrl': imageUrl},
    );
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
          // Read off the shared table, not written out again. These used to
          // be two literals here: formats of 'image'/'poll' — values the
          // server's PostFormat does not contain, rendered straight onto the
          // pill the user reads — and a Friday poll, which is a day the week
          // stopped having when Friday became a video script.
          format: dayFormatAt(i),
          type: dayTypeAt(i),
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

  /// The week the fake pretends it is. Weeks after this have no plan yet.
  static const int _currentWeek = 3;

  @override
  Future<PlannerState> fetchWeek({int? week, int? season}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final int asked = week ?? _currentWeek;

    // A week that has not been generated yet.
    //
    // This used to ignore its arguments entirely and hand back week 3's plan
    // whatever was asked for, so `plan == null` — the whole locked-preview
    // branch at the top of PlannerPage.build, and the `_UpcomingWeek` card it
    // renders — was unreachable on the build this app is manually tested on.
    // The server answers exactly this for any week the Saturday run has not
    // reached: no plan, plus the season roadmap's own topic so the week can
    // still be previewed.
    if (asked > _currentWeek) {
      final int ahead = asked - _currentWeek;
      return PlannerState(
        plan: null,
        currentWeekNumber: _currentWeek,
        currentSeason: 1,
        upcomingTopic: _upcoming[(ahead - 1) % _upcoming.length].$1,
        upcomingPhase: _upcoming[(ahead - 1) % _upcoming.length].$2,
        upcomingTitle: _upcoming[(ahead - 1) % _upcoming.length].$3,
      );
    }

    // A week already behind us is finished: every post day published, and
    // nothing left to approve. Returning the CURRENT week's plan verbatim for
    // week 2 put a half-done week under a "Week 2" heading and left the
    // finished-week state — the one a user browsing back actually sees —
    // without a fixture. The titles are reused; the state is not.
    if (asked < _currentWeek) {
      return PlannerState(
        plan: _plan.copyWith(
          weekNumber: asked,
          posts: <PlanSlot>[
            for (final PlanSlot slot in _plan.posts)
              slot.isPublishable
                  ? slot.copyWith(
                      status: SlotStatus.published,
                      postId: 'mock-post-w$asked-${slot.day}',
                    )
                  : slot,
          ],
        ),
        currentWeekNumber: _currentWeek,
        currentSeason: 1,
      );
    }

    return PlannerState(
      plan: _plan,
      currentWeekNumber: _currentWeek,
      currentSeason: 1,
    );
  }

  /// What the season roadmap already holds for weeks nobody has generated.
  /// `title` is the Thursday newsletter's, as the season plan writes it.
  static const List<(String, String, String)> _upcoming =
      <(String, String, String)>[
        (
          'What the first ninety days should actually cost',
          'Credibility',
          'Onboarding is a budget line, not a kindness',
        ),
        (
          'The handover nobody writes down',
          'Credibility',
          'Every departure takes a manual with it',
        ),
        (
          'Hiring for the job you will have in a year',
          'Authority',
          'Most job specs describe the last person who left',
        ),
      ];

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

    // The roadmap's "awaiting approval" card becomes "scheduled" — the same
    // move the server makes, on the same event. Both surfaces read one row.
    FakeAutoPostState.approved();

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

    // Five days in seven have nothing for the post generator to make, and the
    // server refuses them with NOT_A_POST_DAY before spending any XP. The fake
    // used to generate a post for any index, so the one failure kind a user
    // can actually reach by tapping — and the branch that tells them a retry
    // will never work — could not be walked in mock at all.
    if (!slot.isPublishable) {
      throw const PlannerGenerateFailure(
        kind: PlannerGenerateFailureKind.notAPostDay,
        message: 'That day is not a post day.',
      );
    }

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

  /// A 1×1 transparent PNG — the same stand-in the fake compose repository
  /// uses. It lays the image panel out correctly without shipping a fixture,
  /// and it keeps the mock flavor walking the poster branch: returning null
  /// here would mean mock quietly reproduces the very bug this pair of calls
  /// exists to fix.
  static const String _pixel =
      'data:image/png;base64,'
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
      'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

  @override
  Future<String?> generateSlotPoster({
    required String topic,
    required String content,
    required String posterTitle,
    required String slotType,
    required String userName,
    String? profileImageUrl,
    String? posterTag,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _pixel;
  }

  @override
  Future<void> attachPostImage({
    required String postId,
    required String imageUrl,
  }) async {
    // The fake's plan holds no bodies, so there is nothing to hang this on.
    // Still an await, because the controller's timing — the row sits in
    // `generating` until both calls return — is the thing mock is for.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

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
      article: _articleFixture.copyWith(
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
    // The updated article, as the route answers. Returning null meant any
    // caller that reconciles from the response — rather than re-fetching —
    // took the empty branch in mock and the real one against a server, which
    // is a difference the fake exists to NOT have.
    return _articleNow();
  }

  @override
  Future<WeeklyArticle?> markArticlePublished({
    required int weekNumber,
    required int season,
    String? publishedUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _articlePublishedAt = DateTime.now().toUtc().toIso8601String();
    return _articleNow();
  }

  /// The one article every path in this fake reads from.
  static final WeeklyArticle _articleFixture = const WeeklyArticle(
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
  );

  /// The article as it stands, body stripped — the shape the route returns
  /// from both POST actions. Built from the same two fields `fetchArticle`
  /// reads back, so the three can never drift apart.
  WeeklyArticle _articleNow() => _articleFixture.copyWith(
    body: '',
    scheduledFor: _articleScheduledFor,
    publishedAt: _articlePublishedAt,
  );
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
