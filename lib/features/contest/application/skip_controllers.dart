import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import '../domain/contest_words.dart';
import 'contest_controllers.dart';

part 'skip_controllers.g.dart';

// Skip (owner, 17 Nov 2026) — the web's `useSkipLevel` and `useSkipGuard`.
//
// Only the node the path marks `canSkip` can be skipped, and the server
// decides that; nothing here restates the gate. A skip pays nothing and moves
// no XP, so the standing is not re-read — the path and the lesson are.

/// How long every Skip control stays hidden after a skip lands. The web's
/// `SKIP_GUARD_MS`.
const Duration kSkipGuard = Duration(milliseconds: 600);

/// The double-tap guard every Skip control shares.
///
/// After a skip resolves, the NEXT level's Skip can be drawn in the very spot
/// the finger is still on — the node card, the lesson header, the checkpoint,
/// a level page opened after it — and the server cannot tell two valid
/// presses apart. So every Skip is hidden for [kSkipGuard] after a skip.
///
/// Kept alive and shared, not per widget: the page a skip opens is a fresh
/// widget, and a per-widget flag would start it uncooled — exactly the double
/// skip this exists to stop. The web keeps it as module state for the same
/// reason.
@Riverpod(keepAlive: true)
class SkipCooldown extends _$SkipCooldown {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    return false;
  }

  /// Start (or restart) the cooldown — once a skip has succeeded.
  void start() {
    _timer?.cancel();
    state = true;
    _timer = Timer(kSkipGuard, () {
      _timer = null;
      state = false;
    });
  }

  /// End any cooldown at once (tests).
  void reset() {
    _timer?.cancel();
    _timer = null;
    state = false;
  }
}

/// What a skip came to.
class SkipOutcome {
  const SkipOutcome({
    required this.nodeId,
    required this.alreadySkipped,
    this.next,
  });

  final String nodeId;
  final bool alreadySkipped;

  /// Today's open level after the skip (the first today/rejected node), or
  /// null when none is — never a skipped one.
  final PathNode? next;
}

/// Skip [nodeId] and learn where it leads: the request, then the path and
/// today's lesson re-read — the path WAITED for, so a page that does not draw
/// it still learns which level is open next — then the shared cooldown.
/// Throws the refusal; a refusal that means the path moved re-reads it.
///
/// One body for every Skip control (the node card, a level's own page, the
/// lesson player), so they cannot disagree about what a skip does.
Future<SkipOutcome> performSkip(Ref ref, String nodeId) async {
  final SkipResult result;
  try {
    result = await ref.read(contestRepositoryProvider).skipLevel(nodeId);
  } on Object catch (e) {
    // The path moved under the learner: the re-read shows where it went.
    if (e is ContestWrongDay ||
        e is ContestLocked ||
        e is ContestNotOpen ||
        e is ContestAlreadyDone) {
      ref.invalidate(contestPathProvider);
    }
    rethrow;
  }
  // A skip moves no XP: the standing stays; the path and the lesson move.
  ref.invalidate(contestPathProvider);
  ref.invalidate(todayQuizProvider);
  ContestPath? path;
  // Listened to while it loads: an unwatched read would be disposed before
  // it landed.
  final sub = ref.listen(contestPathProvider, (_, _) {});
  try {
    path = await ref.read(contestPathProvider.future);
  } on Object {
    // Where to go next is unknown; the path is where to go.
  } finally {
    sub.close();
  }
  // Started once the fresh path is in, so the window is not spent on the
  // fetch.
  ref.read(skipCooldownProvider.notifier).start();
  return SkipOutcome(
    nodeId: result.nodeId.isEmpty ? nodeId : result.nodeId,
    alreadySkipped: result.alreadySkipped,
    next: path == null ? null : openLevelOf(path.days),
  );
}

/// A skip in flight, or the refusal it met.
class SkipBusy {
  const SkipBusy({this.busyNodeId, this.error, this.errorNodeId});

  /// The node being skipped.
  final String? busyNodeId;

  /// The server's sentence for the last refused skip.
  final String? error;

  /// Which node [error] belongs to.
  final String? errorNodeId;

  bool get isBusy => busyNodeId != null;

  /// The refusal for [nodeId], or null.
  String? errorFor(String nodeId) => errorNodeId == nodeId ? error : null;
}

/// `POST /contest/skip`, with its busy and error state off the widget.
///
/// A success re-reads the path and today's lesson, WAITS for the path, and
/// says which level is open next — so the caller can move on without reading
/// the cache itself — then starts [SkipCooldown].
@riverpod
class ContestSkipActions extends _$ContestSkipActions {
  @override
  SkipBusy build() => const SkipBusy();

  /// Skip [nodeId]; null when it was refused (the sentence is in [state]) or
  /// another skip is already in flight.
  Future<SkipOutcome?> skip(String nodeId) async {
    if (state.isBusy) return null;
    state = SkipBusy(busyNodeId: nodeId);
    // Held while it runs: a page left mid-skip must still re-read the path.
    final link = ref.keepAlive();
    try {
      final SkipOutcome outcome = await performSkip(ref, nodeId);
      if (ref.mounted) state = const SkipBusy();
      return outcome;
    } on Object catch (e) {
      if (ref.mounted) {
        state = SkipBusy(error: contestMessage(e), errorNodeId: nodeId);
      }
      return null;
    } finally {
      link.close();
    }
  }

  /// Forget the last refusal.
  void clearError() {
    if (state.error != null) state = const SkipBusy();
  }
}
