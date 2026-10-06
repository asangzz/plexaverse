import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/plexa_repositories.dart';
import '../domain/plexa_day.dart';

part 'plexa_controller.g.dart';

/// The day's conversation.
///
/// One fetch, then local edits folded over it. The screen is a thread the user
/// walks down, so a reload after every tap would scroll them away from the
/// item they just finished — and the server returns the new session from the
/// write anyway, which is the whole reason that endpoint answers with it.
@riverpod
class PlexaController extends _$PlexaController {
  @override
  Future<PlexaDay> build() => ref.watch(plexaRepositoryProvider).fetchDay();

  /// Mark one item done, or undo it.
  ///
  /// ## Optimistic, and why that is right here rather than everywhere
  ///
  /// The publish path in this app is deliberately NOT optimistic: a row that
  /// says "Published" when nothing reached LinkedIn is the one lie it must
  /// never tell. This is the opposite case. Nothing is being claimed about
  /// LinkedIn — the user is telling US they did something, the server stores
  /// exactly that, and the failure mode is a tick that comes back.
  ///
  /// In a thread, waiting a round trip to Tokyo before the row ticks is the
  /// difference between a conversation and a form.
  Future<void> setDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
    String? topVoiceId,
  }) async {
    final PlexaDay? current = state.value;
    if (current == null) return;

    state = AsyncData<PlexaDay>(
      _withLocal(current, lane, itemId, done, topVoiceId),
    );

    try {
      final PlexaSession server = await ref
          .read(plexaRepositoryProvider)
          .setItemDone(
            lane: lane,
            itemId: itemId,
            done: done,
            topVoiceId: topVoiceId,
          );
      final PlexaDay? latest = state.value;
      if (latest == null) return;
      // The server's answer wins. It is idempotent on the id, so this mostly
      // confirms what was already drawn — but it also repairs a count that
      // drifted from a tap made on another device earlier in the day.
      state = AsyncData<PlexaDay>(latest.copyWith(session: server));
    } on Object {
      // Put it back. A tick that silently stays after a failed write is worse
      // than one that disappears: the user believes the day is recorded and it
      // is not.
      final PlexaDay? latest = state.value;
      if (latest != null) {
        state = AsyncData<PlexaDay>(
          _withLocal(latest, lane, itemId, !done, topVoiceId),
        );
      }
    }
  }

  /// Applies one clear/unclear to a day, including the Top Voices stamp that
  /// lives on the item rather than in the session.
  PlexaDay _withLocal(
    PlexaDay day,
    PlexaLane lane,
    String itemId,
    bool done,
    String? topVoiceId,
  ) {
    final List<String> next = List<String>.of(day.session.doneIn(lane));
    if (done) {
      if (!next.contains(itemId)) next.add(itemId);
    } else {
      next.remove(itemId);
    }

    final PlexaSession session = lane == PlexaLane.comments
        ? day.session.copyWith(comments: next)
        : day.session.copyWith(connections: next);

    if (topVoiceId == null || topVoiceId.isEmpty) {
      return day.copyWith(session: session);
    }

    // That lane reads its own `actedAt`, not the session, so the optimistic
    // edit has to move the stamp or the row would not tick.
    return day.copyWith(
      session: session,
      topVoices: day.topVoices.copyWith(
        items: day.topVoices.items
            .map(
              (PlexaTopVoice t) => t.id == topVoiceId
                  ? t.copyWith(
                      actedAt: done
                          ? DateTime.now().toUtc().toIso8601String()
                          : null,
                    )
                  : t,
            )
            .toList(growable: false),
      ),
    );
  }

  /// Re-read the day from the server.
  ///
  /// `invalidateSelf`, the way the planner refreshes: it re-runs [build] and
  /// Riverpod keeps the previous value on the AsyncLoading, so the thread stays
  /// on screen while it reloads instead of collapsing to a spinner.
  void refresh() => ref.invalidateSelf();
}
