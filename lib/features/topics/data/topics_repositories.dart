import 'package:dio/dio.dart' show DioException;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/failure.dart';
import '../domain/topics_repository.dart';

/// Dio-backed [TopicsRepository].
///
/// [DioClient] already unwraps the `{data, error, meta}` envelope, so on
/// success `response.data` is the inner payload — an object for a single
/// topic, `{topics: [...]}` for the list.
class ApiTopicsRepository implements TopicsRepository {
  const ApiTopicsRepository(this._client);

  final DioClient _client;

  @override
  Future<List<Topic>> fetchTopics() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.topics);
      return _topics(response.data?['topics']);
    } on DioException catch (e) {
      throw _translate(e);
    } on Object {
      throw const TopicsUnavailable();
    }
  }

  @override
  Future<Topic> createTopic({
    required String name,
    required List<String> keywords,
    String? description,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.topics,
        data: <String, dynamic>{
          'name': name,
          // Sent explicitly as null rather than omitted: the web posts
          // `description || null`, and the column is nullable, so an empty box
          // means "no description" rather than "leave whatever was there".
          'description': description,
          'keywords': keywords,
        },
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const TopicsUnavailable();
      return Topic.fromJson(data);
    } on TopicsUnavailable {
      rethrow;
    } on DioException catch (e) {
      throw _translate(e);
    } on Object {
      throw const TopicsUnavailable();
    }
  }

  @override
  Future<Topic> setActive({required String id, required bool isActive}) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        ApiPaths.topic(id),
        // Only what changed. The handler copies through the keys it finds, so
        // a field we did not mean to send would overwrite a real value.
        data: <String, dynamic>{'isActive': isActive},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const TopicsUnavailable();
      return Topic.fromJson(data);
    } on TopicsUnavailable {
      rethrow;
    } on DioException catch (e) {
      throw _translate(e);
    } on Object {
      throw const TopicsUnavailable();
    }
  }

  @override
  Future<void> deleteTopic(String id) async {
    try {
      await _client.delete<Map<String, dynamic>>(ApiPaths.topic(id));
    } on DioException catch (e) {
      throw _translate(e);
    } on Object {
      throw const TopicsUnavailable();
    }
  }

  @override
  Future<List<SuggestedTopic>> suggestTopics() async {
    try {
      // No body. The server reads the user's profession / headline / industry
      // and any company context from their preferences row; sending a profile
      // from the client would let a stale one drive the prompt.
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.aiSuggestTopics,
      );
      final Object? raw = response.data?['topics'];
      if (raw is! List) return const <SuggestedTopic>[];
      return <SuggestedTopic>[
        for (final Object? item in raw)
          if (item is Map<String, dynamic>) SuggestedTopic.fromJson(item),
      ];
    } on DioException catch (e) {
      throw _translate(e);
    } on Object {
      throw const TopicsUnavailable();
    }
  }

  @override
  Future<void> recordTopicsFoundation() async {
    // Level 5, Step 1 — "Content Strategy Foundations". The two numbers are
    // the web's, from `updateProgress.mutate({levelId: 5, stepId: 1})`.
    await _client.post<Map<String, dynamic>>(
      ApiPaths.roadmapProgress,
      data: <String, dynamic>{'levelId': 5, 'stepId': 1},
    );
  }

  List<Topic> _topics(Object? raw) {
    if (raw is! List) return const <Topic>[];
    return <Topic>[
      for (final Object? item in raw)
        if (item is Map<String, dynamic>) Topic.fromJson(item),
    ];
  }

  TopicsUnavailable _translate(DioException e) {
    final Object? failure = e.error;
    if (failure is! Failure) return const TopicsUnavailable();
    final TopicsFailure reason = switch (failure.errorCode) {
      'PROFILE_INCOMPLETE' => TopicsFailure.profileIncomplete,
      'INSUFFICIENT_XP' => TopicsFailure.insufficientXp,
      'NOT_CONFIGURED' => TopicsFailure.notConfigured,
      'UPSTREAM_FAILED' => TopicsFailure.upstream,
      _ => TopicsFailure.unknown,
    };
    return TopicsUnavailable(reason, failure.message);
  }
}

/// In-memory [TopicsRepository] for the `mock` flavor.
///
/// Seeded with **two** topics on purpose: that is the state where the Level 5
/// goal card is still showing, so the counter, the goal copy and the
/// disappearance of the card after a third topic is added are all reachable
/// without editing a fixture.
class FakeTopicsRepository implements TopicsRepository {
  FakeTopicsRepository();

  int _nextId = 3;

  List<Topic> _topics = const <Topic>[
    Topic(
      id: 'mock-topic-1',
      name: 'Onboarding design',
      description:
          'Why the first week decides the year, and what a good day one '
          'actually looks like.',
      keywords: <String>['onboarding', 'retention', 'people ops'],
      createdAt: '2026-09-12T09:00:00.000Z',
      scheduleCount: 2,
    ),
    Topic(
      id: 'mock-topic-2',
      name: 'Engineering handovers',
      description: null,
      keywords: <String>['handover', 'documentation'],
      isActive: false,
      createdAt: '2026-09-08T09:00:00.000Z',
    ),
  ];

  @override
  Future<List<Topic>> fetchTopics() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _topics;
  }

  @override
  Future<Topic> createTopic({
    required String name,
    required List<String> keywords,
    String? description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final Topic created = Topic(
      id: 'mock-topic-${_nextId++}',
      name: name,
      description: description,
      keywords: keywords,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
    _topics = <Topic>[created, ..._topics];
    return created;
  }

  @override
  Future<Topic> setActive({required String id, required bool isActive}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _topics = <Topic>[
      for (final Topic t in _topics)
        if (t.id == id) t.copyWith(isActive: isActive) else t,
    ];
    return _topics.firstWhere((Topic t) => t.id == id);
  }

  @override
  Future<void> deleteTopic(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _topics = _topics.where((Topic t) => t.id != id).toList(growable: false);
  }

  @override
  Future<List<SuggestedTopic>> suggestTopics() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return const <SuggestedTopic>[
      SuggestedTopic(
        name: 'Hiring without a recruiter',
        description:
            'What a small team can do itself, where an agency actually earns '
            'its fee, and the three steps most founders skip.',
        keywords: <String>['hiring', 'startups', 'talent'],
      ),
      SuggestedTopic(
        name: 'Remote team rituals',
        description:
            'The handful of recurring meetings that survive contact with a '
            'distributed team, and the ones that quietly stop being useful.',
        keywords: <String>['remote', 'culture', 'rituals'],
      ),
      SuggestedTopic(
        name: 'Measuring developer experience',
        description:
            'Four signals that predict whether engineers stay, none of which '
            'is lines of code.',
        keywords: <String>['dx', 'engineering', 'metrics'],
      ),
    ];
  }

  @override
  Future<void> recordTopicsFoundation() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<TopicsRepository> topicsRepositoryProvider =
    Provider<TopicsRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeTopicsRepository();
      return ApiTopicsRepository(ref.watch(dioClientProvider));
    });
