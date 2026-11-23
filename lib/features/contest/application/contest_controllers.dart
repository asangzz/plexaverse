import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/zave_routes.dart';
import '../../placement/application/placement_controllers.dart';
import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import '../domain/contest_words.dart';

part 'contest_controllers.g.dart';

// The contest's server reads, shared by every contest screen.
//
// Each is a plain read of one route — no copy of a server rule lives here.
// After any contest write succeeds, a screen calls [refreshContestStanding],
// which is the web's `refreshStanding`: the write may have moved the XP, the
// streak, the gate and the board at once, and only the server knows which.

/// `GET /contest` — the contest and the user's entry. Null when there is no
/// contest at all.
///
/// One provider for every surface that shows the XP, the streak or the rank,
/// so two of them can never disagree about the figures.
///
/// The entry carries the learner's band, which the placement test sets. A
/// band move is counted in the placement slice, and watching the count
/// re-reads this wherever it is shown — the web's `invalidateBand`.
@riverpod
Future<ContestOverview?> contestOverview(Ref ref) {
  ref.watch(placementBandChangesProvider);
  return ref.watch(contestRepositoryProvider).fetchOverview();
}

/// `GET /contest/path` — this week's levels and their states.
@riverpod
Future<ContestPath> contestPath(Ref ref) =>
    ref.watch(contestRepositoryProvider).fetchPath();

/// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
/// board for `max(rewardTopN, 3)`.
///
/// Every row shows its band, so a band move re-reads it, as it does the
/// overview.
@riverpod
Future<BoardResult> contestBoard(Ref ref, int limit) {
  ref.watch(placementBandChangesProvider);
  return ref.watch(contestRepositoryProvider).fetchBoard(limit: limit);
}

/// `GET /contest/lesson` — today's lesson as it stands. A pure read: the
/// path's START ring and the daily quests take their counts from it.
///
/// Not the lesson player's state. The player opens the day with a `POST`
/// and holds its own run; re-reading this mid-lesson must not move it.
@riverpod
Future<TodayQuiz> todayQuiz(Ref ref) =>
    ref.watch(contestRepositoryProvider).fetchTodayQuiz();

/// `GET /contest/consistency` — the consistency meter (owner, 17 Nov 2026).
/// A pure read: contest XP earned ÷ XP on offer this billing month.
///
/// Re-read with the standing ([refreshContestStanding]), since the meter
/// counts what the path pays, and on resume — an admin's review lands no
/// other way. The card and the stats bar's figure both read this one.
@riverpod
Future<ConsistencyView> contestConsistency(Ref ref) =>
    ref.watch(contestRepositoryProvider).fetchConsistency();

/// `GET /contest/featured` — "Learners of the week" and the Hall of Fame
/// (owner, 22 Nov 2026: the prize is a profile shoutout). A pure read.
///
/// Everyone in it agreed to be featured, and the server checks that on every
/// read, so it is held only while a screen shows it — a learner who
/// withdrew is gone on the next read. The week's card opens when today's
/// lesson is finished, so the lesson's answers re-read it (the web's
/// `useAnswerContestQuiz`); a resume re-reads it too, as a new week or a
/// finalised contest arrives no other way.
@riverpod
Future<ContestFeatured> contestFeatured(Ref ref) =>
    ref.watch(contestRepositoryProvider).fetchFeatured();

/// `GET /contest/shoutout` — the viewer's own "Feature me if I make it"
/// choice. The card draws its box from this, so it is never pre-ticked.
@riverpod
class ContestShoutout extends _$ContestShoutout {
  @override
  Future<ShoutoutSettings> build() =>
      ref.watch(contestRepositoryProvider).fetchShoutout();

  /// The server's answer to a save, kept as the choice — the web's
  /// `setQueryData`. Never a locally toggled guess: only the server knows
  /// whether a consent was recorded.
  void settle(ShoutoutSettings settings) =>
      state = AsyncData<ShoutoutSettings>(settings);
}

/// `ref.invalidate`, from a widget's `WidgetRef` or a controller's `Ref` —
/// both tear off to this shape, so one helper serves both.
typedef ContestInvalidate = void Function(ProviderOrFamily provider);

/// Re-read everything a contest write can move: the standing (XP, streak,
/// rank), the path (the gate, the level's state), the board, today's lesson
/// and the consistency meter, which counts what the path pays. The web's
/// `refreshStanding`.
///
/// ```dart
/// refreshContestStanding(ref.invalidate);
/// ```
///
/// Call it after every write that succeeded, and on no other occasion: a
/// re-read is how a refusal's cause is learnt (a 409 LOCKED means the path
/// moved), but a guess at the new state is how the screen and the server
/// drift apart.
void refreshContestStanding(ContestInvalidate invalidate) {
  invalidate(contestOverviewProvider);
  invalidate(contestPathProvider);
  invalidate(contestBoardProvider);
  invalidate(todayQuizProvider);
  invalidate(contestConsistencyProvider);
}

/// Whether today's level of a kind waits on an earlier one — read off the
/// path, never decided here. The web's `useTodayLock`.
class TodayLock {
  const TodayLock({this.locked, this.pending = false});

  /// The node's "Unlocks after …" line while it is gated; null when it is
  /// not (open, finished, or not on today's path at all).
  final String? locked;

  /// The path has not answered yet. A player whose own read lands first
  /// keeps its skeleton until this clears — or a locked level opens playable
  /// and then jumps to "Not open yet". A FAILED path is not pending: the
  /// level opens, and the server's 409 LOCKED still holds.
  final bool pending;

  bool get isLocked => locked != null;
}

/// Today's level of [kind], gated or not.
///
/// The comment level's GET writes the day's row and may spend a model call,
/// and the server does not check the gate there: read this first, and do
/// not make that call while it says locked.
@riverpod
TodayLock todayLock(Ref ref, PathNodeKind kind) {
  final AsyncValue<ContestPath> path = ref.watch(contestPathProvider);
  final PathNode? node = path.value?.todayNode(kind);
  return TodayLock(
    locked: node?.state == PathNodeState.locked
        ? (node?.detail ?? 'Finish or skip today’s earlier levels first')
        : null,
    pending: !path.hasValue && !path.hasError,
  );
}

/// Where a level opens in the app, or null when it opens nothing.
///
/// Dispatched on the node's KIND (and its claim), never on its `href`: that
/// is the web's path for it, which the web can change without the app
/// knowing. Null for a level [canOpen] refuses — locked, missed, revoked,
/// nothing to do — and for a kind this build does not know.
String? contestLevelRoute(PathNode node) {
  if (!canOpen(node)) return null;
  return switch (node.kind) {
    // A skipped part opens on itself — the web's `?part=k`.
    PathNodeKind.lesson => switch ((node.state, node.part)) {
      (PathNodeState.skipped, final NodePart part) =>
        '${ZaveRoutes.contestLesson}?part=${part.index}',
      _ => ZaveRoutes.contestLesson,
    },
    PathNodeKind.comment => ZaveRoutes.contestComment,
    PathNodeKind.feedComments => ZaveRoutes.contestFeedComments,
    PathNodeKind.weeklyInvites => ZaveRoutes.contestInvites,
    PathNodeKind.planWeek => ZaveRoutes.contestPlan,
    // The Connection Sprint, in contest mode.
    PathNodeKind.connectLeaders => '${ZaveRoutes.connections}?from=contest',
    PathNodeKind.article || PathNodeKind.video => switch (node.claim) {
      final NodeClaim claim => contestClaimRoute(claim.kind, claim.occurrence),
      null => null,
    },
    PathNodeKind.unknown => null,
  };
}

/// The claim level for one piece — from its node, or from the week card's
/// "Share link" for a piece whose day has passed. Null for a piece this
/// build cannot name.
String? contestClaimRoute(ClaimKind kind, String occurrence) {
  if (kind == ClaimKind.unknown || occurrence.isEmpty) return null;
  return Uri(
    path: ZaveRoutes.contestClaim,
    queryParameters: <String, String>{
      'kind': kind.wire,
      'occurrence': occurrence,
    },
  ).toString();
}

/// Where a finished level sends the learner, and what the button says.
class NextLevel {
  const NextLevel({required this.route, required this.label});

  final String route;

  /// "Next: Comment on a top voice", or "Back to the path".
  final String label;

  /// Nothing else is open today: the button leads back to the path.
  bool get isBackToPath => route == ZaveRoutes.contest;
}

/// The next open level on today's path, after finishing a level of
/// [finished]. The web's `useNextLevel`.
///
/// The finishing write re-reads the path, so the gate has already opened
/// what follows. Until the path is in, while it still shows the level just
/// finished, or when nothing is left today, it is the path itself.
NextLevel nextOpenLevel(ContestPath? path, PathNodeKind finished) {
  const NextLevel back = NextLevel(
    route: ZaveRoutes.contest,
    label: 'Back to the path',
  );
  final List<PathDay> days = path?.days ?? const <PathDay>[];
  final String? id = currentNodeId(days);
  if (id == null) return back;
  PathNode? node;
  for (final PathNode n in path?.today?.nodes ?? const <PathNode>[]) {
    if (n.id == id) node = n;
  }
  if (node == null || node.kind == finished) return back;
  final String? route = contestLevelRoute(node);
  if (route == null) return back;
  return NextLevel(route: route, label: 'Next: ${levelName(node)}');
}

/// Re-reads the standing and the path whenever the app comes back to the
/// foreground — the web's refetch on mount and on focus.
///
/// An approval, a rejection or an audit's revoke reaches the learner by no
/// other road: none of them sends a notification, so the path is the only
/// place they show, and a phone left on the contest overnight would
/// otherwise show yesterday's gate. Today's lesson read is re-read with
/// them, so the path's START ring cannot measure a new day against an old
/// count.
///
/// A contest screen watches it to switch it on; it lives only while one
/// does.
@riverpod
void contestResumeRefresh(Ref ref) {
  final AppLifecycleListener listener = AppLifecycleListener(
    onResume: () {
      ref.invalidate(contestOverviewProvider);
      ref.invalidate(contestPathProvider);
      ref.invalidate(todayQuizProvider);
      ref.invalidate(contestConsistencyProvider);
      ref.invalidate(contestFeaturedProvider);
    },
  );
  ref.onDispose(listener.dispose);
}
