import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/calendar_month.dart';
import '../domain/calendar_post.dart';
import '../domain/calendar_repository.dart';
import '../domain/post_schedule.dart';

/// Retained for the fake repository's fixture slice. The real calendar no
/// longer pages `GET /posts` — it asks `GET /calendar` for a date window and
/// gets both buckets back already split.
const int kCalendarPostPageSize = 100;

/// Dio-backed [CalendarRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner payload — a bare `List` for
/// `GET /posts`, and a `Map` everywhere else.
class ApiCalendarRepository implements CalendarRepository {
  const ApiCalendarRepository(this._client);

  final DioClient _client;

  @override
  Future<CalendarBuckets> fetchBuckets({DateTime? from, DateTime? to}) async {
    // `/calendar`, not `/posts`. The old call selected `imageUrl` — 252 KB a
    // row on the live table, because most posts hold a base64 `data:` image
    // inline — for a screen that draws no images. A hundred rows of it was
    // 18 MB and 45 seconds, against a 30-second receive timeout, which is
    // what "The calendar did not load" actually was.
    final response = await _client.get<dynamic>(
      ApiPaths.calendar,
      queryParameters: <String, dynamic>{
        'from': ?from?.toUtc().toIso8601String(),
        'to': ?to?.toUtc().toIso8601String(),
      },
    );

    final dynamic data = response.data;
    if (data is! Map<String, dynamic>) return const CalendarBuckets();

    List<CalendarPost> bucket(Object? raw) => <CalendarPost>[
      if (raw is List)
        for (final dynamic row in raw)
          if (row is Map<String, dynamic>) CalendarPost.fromJson(row),
    ];

    // Already split by the server, so `splitCalendarBuckets` is not used on
    // this path. The rule it encodes still lives in the domain layer and is
    // still what the FAKE repository applies.
    return CalendarBuckets(
      scheduled: bucket(data['scheduled']),
      pending: bucket(data['pending']),
    );
  }

  @override
  Future<CalendarPost> reschedulePost({
    required String postId,
    required DateTime scheduledFor,
    String? accountId,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.post(postId),
      data: <String, dynamic>{
        // The server stores UTC and renders in the user's zone; sending a
        // local-time string would shift every scheduled post by the offset.
        'scheduledFor': scheduledFor.toUtc().toIso8601String(),
        'status': CalendarPostStatus.scheduled.wire,
        'accountId': ?accountId,
      },
    );
    final Map<String, dynamic>? post = response.data;
    if (post == null) {
      throw StateError('posts PATCH returned no post');
    }
    return CalendarPost.fromJson(post);
  }

  @override
  Future<List<PostSchedule>> fetchSchedules() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.schedules,
    );
    return _scheduleList(response.data?['schedules']);
  }

  @override
  Future<PostSchedule> createSchedule({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    required String timezone,
    String? topicId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.schedules,
      data: <String, dynamic>{
        'linkedinAccountId': linkedinAccountId,
        'dayOfWeek': dayOfWeek,
        'timeOfDay': timeOfDay,
        'timezone': timezone,
        // Explicit null is meaningful here — it clears the topic — so this
        // one is NOT elided when absent.
        'topicId': topicId,
      },
    );
    final Map<String, dynamic>? schedule = response.data;
    if (schedule == null) {
      throw StateError('schedules POST returned no schedule');
    }
    return PostSchedule.fromJson(schedule);
  }

  @override
  Future<PostSchedule> updateSchedule({
    required String id,
    bool? isActive,
    List<int>? dayOfWeek,
    String? timeOfDay,
    String? topicId,
  }) async {
    // Send only what changed: the route forwards any key that is present, so a
    // null we did not mean would overwrite a real value.
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.schedule(id),
      data: <String, dynamic>{
        'isActive': ?isActive,
        'dayOfWeek': ?dayOfWeek,
        'timeOfDay': ?timeOfDay,
        'topicId': ?topicId,
      },
    );
    final Map<String, dynamic>? schedule = response.data;
    if (schedule == null) {
      throw StateError('schedules PATCH returned no schedule');
    }
    return PostSchedule.fromJson(schedule);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _client.delete<Map<String, dynamic>>(ApiPaths.schedule(id));
  }

  @override
  Future<List<CalendarAccount>> fetchAccounts() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiPaths.linkedInAccounts,
    );
    final Object? raw = response.data?['accounts'];
    if (raw is! List) return const <CalendarAccount>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CalendarAccount.fromJson)
        .toList(growable: false);
  }

  @override
  Future<List<ScheduleTopic>> fetchTopics() async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.topics);
    final Object? raw = response.data?['topics'];
    if (raw is! List) return const <ScheduleTopic>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ScheduleTopic.fromJson)
        .toList(growable: false);
  }

  static List<PostSchedule> _scheduleList(Object? raw) {
    if (raw is! List) return const <PostSchedule>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(PostSchedule.fromJson)
        .toList(growable: false);
  }
}

/// In-memory [CalendarRepository] for the `mock` flavor.
///
/// Shaped like a real mid-month state so every state the screen can render is
/// reachable without a backend: published posts behind today, a queue ahead of
/// it, one failed publish, one approval that already lapsed, and two drafts.
class FakeCalendarRepository implements CalendarRepository {
  FakeCalendarRepository() {
    final DateTime today = DateTime.now();
    DateTime at(int dayOffset, int hour, int minute) =>
        DateTime(today.year, today.month, today.day + dayOffset, hour, minute);

    _posts = <CalendarPost>[
      CalendarPost(
        id: 'mock-post-1',
        title: 'The first week decides the year',
        content:
            'Most teams treat onboarding as a documentation exercise. Write '
            'enough down, the thinking goes, and a new joiner will find their '
            'way. It does not work, and the reason is not effort.',
        status: CalendarPostStatus.published,
        publishedAt: at(-4, 9, 0),
        createdAt: at(-6, 11, 0),
      ),
      CalendarPost(
        id: 'mock-post-2',
        title: 'Three onboarding metrics nobody tracks',
        content:
            'Time-to-first-commit is the one everybody quotes. Here are the '
            'three that actually predict whether someone stays.',
        status: CalendarPostStatus.published,
        publishedAt: at(-2, 9, 0),
        createdAt: at(-5, 11, 0),
      ),
      CalendarPost(
        id: 'mock-post-3',
        title: 'What a good day one actually looks like',
        content:
            'Hour by hour, the day-one plan we run, and the two things we '
            'deliberately do NOT do on it.',
        status: CalendarPostStatus.scheduled,
        scheduledFor: at(1, 9, 0),
        createdAt: at(-1, 11, 0),
      ),
      CalendarPost(
        id: 'mock-post-4',
        title: 'The handover problem',
        content:
            'Every onboarding failure I have looked at closely turned out to '
            'be a handover failure wearing a different hat.',
        status: CalendarPostStatus.approved,
        scheduledFor: at(2, 12, 0),
        createdAt: at(-1, 12, 0),
      ),
      CalendarPost(
        id: 'mock-post-5',
        title: 'Which of these breaks your onboarding?',
        content: 'A poll. Pick the one that hurts most.',
        status: CalendarPostStatus.pendingApproval,
        scheduledFor: at(3, 15, 0),
        createdAt: at(-1, 13, 0),
      ),
      CalendarPost(
        id: 'mock-post-6',
        content:
            'A checklist you can steal. Twelve lines, no tooling required, '
            'and it works on week one of any team.',
        status: CalendarPostStatus.failed,
        scheduledFor: at(-1, 18, 0),
        createdAt: at(-3, 9, 0),
      ),
      CalendarPost(
        id: 'mock-post-7',
        content:
            'The thing nobody says about mentorship pairing: the mentor needs '
            'onboarding too.',
        status: CalendarPostStatus.pendingApproval,
        scheduledFor: at(-3, 9, 0),
        createdAt: at(-4, 9, 0),
      ),
      CalendarPost(
        id: 'mock-post-8',
        content:
            'Draft — why we stopped writing onboarding docs and started '
            'recording onboarding sessions instead.',
        createdAt: at(-1, 16, 0),
      ),
      CalendarPost(
        id: 'mock-post-9',
        content: 'Draft — the 30/60/90 template, rewritten for small teams.',
        createdAt: at(0, 8, 0),
      ),
    ];
  }

  late List<CalendarPost> _posts;

  static const CalendarAccount _account = CalendarAccount(
    id: 'mock-account-1',
    profileName: 'Asang Borkar',
  );

  static const ScheduleTopic _topic = ScheduleTopic(
    id: 'mock-topic-1',
    name: 'Engineering onboarding',
  );

  List<PostSchedule> _schedules = const <PostSchedule>[
    PostSchedule(
      id: 'mock-schedule-1',
      linkedinAccountId: 'mock-account-1',
      topicId: 'mock-topic-1',
      dayOfWeek: <int>[1, 2, 3, 4, 5],
      timeOfDay: '09:00',
      topic: _topic,
      linkedinAccount: _account,
    ),
    PostSchedule(
      id: 'mock-schedule-2',
      linkedinAccountId: 'mock-account-1',
      dayOfWeek: <int>[0, 6],
      timeOfDay: '18:30',
      isActive: false,
      linkedinAccount: _account,
    ),
  ];

  int _nextId = 3;

  static const Duration _latency = Duration(milliseconds: 320);

  @override
  Future<CalendarBuckets> fetchBuckets({DateTime? from, DateTime? to}) async {
    await Future<void>.delayed(_latency);
    // The fixtures are not date-windowed; the split rule is the real thing.
    return splitCalendarBuckets(_posts);
  }

  @override
  Future<CalendarPost> reschedulePost({
    required String postId,
    required DateTime scheduledFor,
    String? accountId,
  }) async {
    await Future<void>.delayed(_latency);
    final int index = _posts.indexWhere((CalendarPost p) => p.id == postId);
    if (index == -1) throw StateError('mock: unknown post $postId');
    final CalendarPost moved = _posts[index].copyWith(
      scheduledFor: scheduledFor,
      status: CalendarPostStatus.scheduled,
    );
    _posts = <CalendarPost>[
      for (int i = 0; i < _posts.length; i++)
        if (i == index) moved else _posts[i],
    ];
    return moved;
  }

  @override
  Future<List<PostSchedule>> fetchSchedules() async {
    await Future<void>.delayed(_latency);
    return _schedules;
  }

  @override
  Future<PostSchedule> createSchedule({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    required String timezone,
    String? topicId,
  }) async {
    await Future<void>.delayed(_latency);
    final PostSchedule created = PostSchedule(
      id: 'mock-schedule-${_nextId++}',
      linkedinAccountId: linkedinAccountId,
      topicId: topicId,
      dayOfWeek: dayOfWeek,
      timeOfDay: timeOfDay,
      timezone: timezone,
      topic: topicId == null ? null : _topic,
      linkedinAccount: _account,
    );
    _schedules = <PostSchedule>[created, ..._schedules];
    return created;
  }

  @override
  Future<PostSchedule> updateSchedule({
    required String id,
    bool? isActive,
    List<int>? dayOfWeek,
    String? timeOfDay,
    String? topicId,
  }) async {
    await Future<void>.delayed(_latency);
    final int index = _schedules.indexWhere((PostSchedule s) => s.id == id);
    if (index == -1) throw StateError('mock: unknown schedule $id');
    final PostSchedule updated = _schedules[index].copyWith(
      isActive: isActive ?? _schedules[index].isActive,
      dayOfWeek: dayOfWeek ?? _schedules[index].dayOfWeek,
      timeOfDay: timeOfDay ?? _schedules[index].timeOfDay,
      topicId: topicId ?? _schedules[index].topicId,
    );
    _schedules = <PostSchedule>[
      for (int i = 0; i < _schedules.length; i++)
        if (i == index) updated else _schedules[i],
    ];
    return updated;
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await Future<void>.delayed(_latency);
    _schedules = _schedules
        .where((PostSchedule s) => s.id != id)
        .toList(growable: false);
  }

  @override
  Future<List<CalendarAccount>> fetchAccounts() async {
    await Future<void>.delayed(_latency);
    return const <CalendarAccount>[_account];
  }

  @override
  Future<List<ScheduleTopic>> fetchTopics() async {
    await Future<void>.delayed(_latency);
    return const <ScheduleTopic>[_topic];
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the planner and posts slices.
final Provider<CalendarRepository> calendarRepositoryProvider =
    Provider<CalendarRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeCalendarRepository();
      return ApiCalendarRepository(ref.watch(dioClientProvider));
    });
