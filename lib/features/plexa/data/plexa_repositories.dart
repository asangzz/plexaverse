import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/plexa_day.dart';
import '../domain/plexa_repository.dart';
import 'fake_day_session.dart';

/// Dio-backed [PlexaRepository].
///
/// [DioClient] unwraps the `{data, error, meta}` envelope, so `response.data`
/// is already the inner payload.
///
/// ## One call, by design
///
/// The web assembles this thread from four requests — progress, comments,
/// connections, curated posts — because its dashboard pages have already
/// fetched the last three, so the chat reads caches warm in the browser. A
/// phone has none of that, and each trip is ~500-900ms to Supabase in Tokyo.
/// `GET /plexa/day` on mobile therefore returns all four at once.
///
/// There is no `generate` here on purpose. The aggregate never charges, and
/// the two paid batches are created through the engagement repository's
/// existing calls, where the XP cost is attached to a decision the user made
/// rather than to opening a screen.
class ApiPlexaRepository implements PlexaRepository {
  const ApiPlexaRepository(this._client);

  final DioClient _client;

  @override
  Future<PlexaDay> fetchDay() async {
    final response = await _client.get<Map<String, dynamic>>(ApiPaths.plexaDay);
    final Map<String, dynamic>? data = response.data;
    if (data == null) return const PlexaDay();
    return PlexaDay.fromWire(data);
  }

  @override
  Future<PlexaSession> setItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
    String? topVoiceId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiPaths.plexaDay,
      data: <String, dynamic>{
        'lane': lane.wire,
        'itemId': itemId,
        'done': done,
        if (topVoiceId != null && topVoiceId.isNotEmpty)
          'topVoiceId': topVoiceId,
      },
    );
    return PlexaSession.fromWire(
      response.data?['session'] as Map<String, dynamic>?,
    );
  }

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    // No `task: 'complete_step'`. The web sends one because its route
    // multiplexes several writes onto one endpoint; the mobile route reads
    // only these two fields and has no discriminator.
    await _client.post<Map<String, dynamic>>(
      ApiPaths.roadmapProgress,
      data: <String, dynamic>{'levelId': levelId, 'stepId': stepId},
    );
  }
}

/// In-memory [PlexaRepository] for the `mock` flavor.
///
/// Seeded so every state the conversation can reach is walkable without a
/// server: a curated post, two niche comments, one connection request, and one
/// item already cleared so the resume line ("Picking up at 2 of 4") is
/// exercised rather than assumed.
///
/// The ids carry the web's `tv:` / `nw:` / `cn:` prefixes, because a fake that
/// used a different scheme would hide the one bug this shape exists to
/// prevent.
class FakePlexaRepository implements PlexaRepository {
  // The row is shared with the engagement fakes — see FakeDaySession.

  @override
  Future<PlexaDay> fetchDay() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return PlexaDay(
      session: FakeDaySession.current,
      topic: 'onboarding',
      ready: const PlexaReady(
        comments: true,
        connections: true,
        topVoices: true,
      ),
      items: const <DayItem>[
        DayItem(
          id: 'tv:shown-1',
          lane: PlexaLane.comments,
          headline:
              'Most onboarding decks are written for the person who '
              'wrote them.',
          context: 'Priya Raman · priyaraman',
          draft:
              'The decks that worked for us were the ones a new joiner '
              'could skip entirely and still land.',
          url: 'https://www.linkedin.com/feed/update/urn:li:share:tv1',
          topVoiceId: 'shown-1',
        ),
        DayItem(
          id: 'tv:shown-2',
          lane: PlexaLane.comments,
          headline: 'We stopped doing week-one demos. Retention went up.',
          context: 'Dev Kulkarni · devk',
          draft:
              'Curious whether the demo was the cost, or the rehearsal '
              'around it.',
          url: 'https://www.linkedin.com/feed/update/urn:li:share:tv2',
          topVoiceId: 'shown-2',
        ),
        DayItem(
          id: 'nw:0',
          lane: PlexaLane.comments,
          headline: 'A founder post about onboarding',
          context: 'search: remote onboarding first week',
          draft:
              'The part people miss is that a first week is a design '
              'problem, not a documentation one.',
          url:
              'https://www.linkedin.com/search/results/content/'
              '?keywords=remote%20onboarding%20first%20week',
        ),
        DayItem(
          id: 'cn:0',
          lane: PlexaLane.connections,
          headline: 'Head of Product at Razorpay',
          draft:
              'Hi — I lead product on a small team shipping into Indian '
              'fintech, and I have been following how your payments surface '
              'handles failed-retry UX. Would be glad to connect.',
          url:
              'https://www.linkedin.com/search/results/people/'
              '?keywords=Head%20of%20Product%20Razorpay',
        ),
      ],
    );
  }

  @override
  Future<PlexaSession> setItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
    String? topVoiceId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return FakeDaySession.setDone(lane: lane, itemId: itemId, done: done);
  }

  /// Recorded rather than ignored, so a mock run can assert that finishing a
  /// lane credited exactly one step.
  final List<({int levelId, int stepId})> completed =
      <({int levelId, int stepId})>[];

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    completed.add((levelId: levelId, stepId: stepId));
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors the other slices.
final Provider<PlexaRepository> plexaRepositoryProvider =
    Provider<PlexaRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakePlexaRepository();
      return ApiPlexaRepository(ref.watch(dioClientProvider));
    });
