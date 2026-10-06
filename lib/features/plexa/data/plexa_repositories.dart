import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../domain/plexa_day.dart';
import '../domain/plexa_repository.dart';

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
}

/// In-memory [PlexaRepository] for the `mock` flavor.
///
/// Seeded so every state the screen can render is reachable without a server:
/// one lane prepared and partly cleared, one prepared and untouched, and one
/// NOT prepared — that last is the state most likely to be got wrong, because
/// "nothing generated yet" and "nothing left to do" look identical unless the
/// screen is built to tell them apart.
class FakePlexaRepository implements PlexaRepository {
  PlexaSession _session = const PlexaSession(comments: <String>['comments:0']);

  @override
  Future<PlexaDay> fetchDay() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return PlexaDay(
      session: _session,
      topic: 'onboarding',
      comments: const PlexaLaneState<PlexaComment>(
        ready: true,
        items: <PlexaComment>[
          PlexaComment(
            id: 'comments:0',
            comment:
                'The part people miss is that a first week is a design '
                'problem, not a documentation one. Writing more down does not '
                'fix a week nobody shaped.',
            searchKeywords: 'remote onboarding first week',
            targetPostTitle: 'a founder post about onboarding',
          ),
          PlexaComment(
            id: 'comments:1',
            comment:
                'Time-to-first-commit is the only onboarding metric most '
                'teams measure, and it is the least interesting of the three.',
            searchKeywords: 'engineering onboarding metrics',
            targetPostTitle: 'an engineering-leadership post',
          ),
        ],
      ),
      topVoices: const PlexaLaneState<PlexaTopVoice>(
        ready: true,
        items: <PlexaTopVoice>[
          PlexaTopVoice(
            id: 'shown-1',
            postUrl: 'https://www.linkedin.com/feed/update/urn:li:share:tv1',
            authorName: 'Priya Raman',
            firstLine:
                'Most onboarding decks are written for the person who wrote '
                'them.',
            comment:
                'The decks that worked for us were the ones a new joiner '
                'could skip entirely and still land.',
          ),
          PlexaTopVoice(
            id: 'shown-2',
            postUrl: 'https://www.linkedin.com/feed/update/urn:li:share:tv2',
            authorName: 'Dev Kulkarni',
            firstLine: 'We stopped doing week-one demos. Retention went up.',
            comment:
                'Curious whether the demo was the cost, or the rehearsal '
                'around it.',
            actedAt: '2026-10-06T09:00:00.000Z',
          ),
        ],
      ),
      // Deliberately not ready: the screen must offer to prepare it rather
      // than render an empty lane that looks finished.
      connections: const PlexaLaneState<PlexaConnection>(),
    );
  }

  @override
  Future<PlexaSession> setItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
    String? topVoiceId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final List<String> current = List<String>.of(_session.doneIn(lane));
    if (done) {
      if (!current.contains(itemId)) current.add(itemId);
    } else {
      current.remove(itemId);
    }
    _session = lane == PlexaLane.comments
        ? _session.copyWith(comments: current)
        : _session.copyWith(connections: current);
    return _session;
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
