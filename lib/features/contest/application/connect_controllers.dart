import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../engagement/data/engagement_repositories.dart';
import '../../engagement/domain/engagement_repository.dart';
import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'connect_controllers.g.dart';

// "Connect with leaders" — the contest's Monday and Thursday level. It is the
// Connection Sprint (`/connections`) opened from the path, as on the web
// (`?from=contest`): the same cards and the same notes, but the targets come
// from the contest's own route and Finish pays the contest task instead of
// crediting the roadmap step.
//
// TRUSTED, NOT AUDITED
//   LinkedIn has no API that says a request went out, so the level is paid on
//   the learner's word, once a day. A repeat Finish is harmless: the server
//   answers `alreadyDone` and pays nothing more.

/// `GET /contest/tasks/connect` — today's leaders, with the sent ticks.
///
/// Free on a contest Monday or Thursday and bounded by the day's stored
/// batch: a re-read replays it, and there is no "new set" to ask for. On any
/// other day the plan gate applies and refuses as `ai/connections` does.
///
/// ## The ticks are the day's, not the page's
///
/// It is the SAME daily batch the ordinary `/connections` page shows — the
/// server keeps one per user per day — so a note copied there counts here
/// and the other way round. The ticks are read from and written to the
/// shared day row, as `ConnectionsController` does. Held only in this
/// auto-dispose notifier they would vanish when the page was popped, and a
/// learner who stepped out to LinkedIn would come back to `0 / 5`.
@riverpod
class ContestConnectTargets extends _$ContestConnectTargets {
  @override
  Future<ConnectionBatch> build() async {
    final ContestRepository contest = ref.watch(contestRepositoryProvider);
    final EngagementRepository day = ref.watch(engagementRepositoryProvider);

    // Both at once — but not through `.wait`, which would wrap a refusal of
    // the targets in a ParallelWaitError and lose the type the page
    // branches on. The day row is read leniently: losing the ticks costs a
    // re-copy, losing the targets costs the level.
    final Future<PlexaSession> session = day.fetchDaySession().then(
      (PlexaSession s) => s,
      onError: (Object _) => const PlexaSession(),
    );
    final ConnectionBatch batch = await contest.fetchConnectTargets();
    final List<String> done = (await session).doneIn(PlexaLane.connections);
    return batch.copyWith(
      connections: <ConnectionTarget>[
        for (int i = 0; i < batch.connections.length; i++)
          batch.connections[i].copyWith(
            isSent: done.contains(plexaItemId(PlexaLane.connections, i)),
          ),
      ],
    );
  }

  /// The learner copied this note, so the request counts as sent.
  ///
  /// Optimistic, and put back if the day row refuses it — the ordinary
  /// page's rule: a tick that stays after a failed write says something is
  /// recorded that is not.
  Future<void> markSent(int index) async {
    final ConnectionBatch? batch = state.value;
    if (batch == null || index < 0 || index >= batch.connections.length) return;
    if (batch.connections[index].isSent) return;

    state = AsyncData<ConnectionBatch>(
      batch.copyWith(connections: _withSent(batch.connections, index, true)),
    );

    try {
      await ref
          .read(engagementRepositoryProvider)
          .setDayItemDone(
            lane: PlexaLane.connections,
            itemId: plexaItemId(PlexaLane.connections, index),
          );
    } on Object {
      if (!ref.mounted) return;
      final ConnectionBatch? current = state.value;
      if (current != null) {
        state = AsyncData<ConnectionBatch>(
          current.copyWith(
            connections: _withSent(current.connections, index, false),
          ),
        );
      }
    }
  }

  static List<ConnectionTarget> _withSent(
    List<ConnectionTarget> targets,
    int index,
    bool isSent,
  ) {
    final List<ConnectionTarget> next = List<ConnectionTarget>.of(targets);
    next[index] = next[index].copyWith(isSent: isSent);
    return next;
  }
}

/// Where the level's Finish stands.
class ContestConnectBusy {
  const ContestConnectBusy({
    this.busy = false,
    this.error,
    this.locked = false,
  });

  final bool busy;

  /// The server's refusal, in its own words.
  final String? error;

  /// The refusal was the gate (409 LOCKED): an earlier level of today is
  /// still open. Said with the way back to the path.
  final bool locked;
}

/// `POST /contest/tasks/connect` — "Finish and collect XP".
///
/// Never the roadmap's `completeStep`: in contest mode the page pays the
/// contest task and nothing else.
@riverpod
class ContestConnectActions extends _$ContestConnectActions {
  @override
  ContestConnectBusy build() => const ContestConnectBusy();

  /// Records the level. True when the server took it — a repeat included —
  /// and the page goes back to the path.
  Future<bool> complete() async {
    if (state.busy) return false;
    state = const ContestConnectBusy(busy: true);
    try {
      await ref.read(contestRepositoryProvider).completeConnect();
      if (!ref.mounted) return false;
      state = const ContestConnectBusy();
      refreshContestStanding(ref.invalidate);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = ContestConnectBusy(
        error: contestMessage(e),
        locked: e is ContestLocked,
      );
      return false;
    }
  }
}
