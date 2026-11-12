import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_links.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'feed_comments_controllers.g.dart';

// "Post 5 valuable comments": five comments in the learner's own LinkedIn
// feed, each link pasted here AS IT GOES — one at a time — and each paid its
// share of the day's total as it lands. LinkedIn tells us nothing back, so an
// admin audits the day after; a false claim is taken back with a penalty on
// top. Nothing here decides a payment, a duplicate across days or an audit:
// the server does. The link is checked here only so a wrong one is flagged
// in its field before it is sent, in the server's own terms.

/// `GET /contest/tasks/feed-comments` — open, done (with the links and what
/// each paid) or revoked, and the numbers the page quotes: the day's total,
/// each comment's share, and what a false claim costs.
///
/// A pure read, so unlike the comment level it is not held behind the gate:
/// the page still waits for the path before drawing the form.
///
/// Re-read when the app comes back to the foreground, as the web re-reads on
/// focus: the learner has been on LinkedIn, and a revoke or another device's
/// send reaches them by no other road.
@riverpod
Future<FeedCommentsView> feedComments(Ref ref) {
  final AppLifecycleListener listener = AppLifecycleListener(
    onResume: ref.invalidateSelf,
  );
  ref.onDispose(listener.dispose);
  return ref.watch(contestRepositoryProvider).fetchFeedComments();
}

/// Today's links as the page should draw them: the read's, or the last
/// send's when that is further on. The web's `effective`.
class FeedCommentsNow {
  const FeedCommentsNow({
    required this.links,
    required this.status,
    this.linkPoints,
    this.pointsApplied,
  });

  final List<String> links;

  /// What each of [links] paid; null on a day sent five-at-once.
  final List<int>? linkPoints;
  final FeedCommentsStatus status;

  /// What the day has paid so far.
  final int? pointsApplied;
}

/// The read, moved on by the last accepted send — so the field steps to the
/// next comment the moment a send succeeds, before the re-read lands.
///
/// That send's XP is known; one in between (two sends before a re-read)
/// is not, so it shows none. A revoked day is the read's, whatever was sent.
FeedCommentsNow effectiveFeed(
  FeedCommentsView view,
  FeedCommentSubmitResult? last,
) {
  if (last == null ||
      last.links.length <= view.links.length ||
      view.status == FeedCommentsStatus.revoked) {
    return FeedCommentsNow(
      links: view.links,
      linkPoints: view.linkPoints,
      status: view.status,
      pointsApplied: view.pointsApplied,
    );
  }
  final List<int>? read = view.linkPoints;
  return FeedCommentsNow(
    links: last.links,
    linkPoints: <int>[
      for (int i = 0; i < last.links.length; i++)
        i == last.n - 1
            ? last.pointsApplied
            : (read != null && i < read.length ? read[i] : 0),
    ],
    status: last.status == FeedCommentSubmitStatus.done
        ? FeedCommentsStatus.done
        : FeedCommentsStatus.open,
    pointsApplied: last.dayPoints,
  );
}

/// What a send has in flight, and what it last heard back.
class FeedCommentsSend {
  const FeedCommentsSend({this.busy = false, this.error, this.last});

  final bool busy;

  /// The server's refusal of the last send, in its words. Shown under the
  /// field, where a link the check here caught would show.
  final String? error;

  /// The last accepted send, kept until the next one lands: it moves the
  /// field on ([effectiveFeed]) and says "Comment n sent".
  final FeedCommentSubmitResult? last;
}

/// Send ONE of today's comment links: `POST /contest/tasks/feed-comments`.
@riverpod
class FeedCommentsActions extends _$FeedCommentsActions {
  @override
  FeedCommentsSend build() => const FeedCommentsSend();

  /// Checks [raw] against today's links the way the server does, then sends
  /// it. True when it was accepted.
  ///
  /// A link the check refuses is never sent: the field already shows why,
  /// from the same check, and a request that can only come back 400 or 409
  /// would add nothing but a second sentence.
  Future<bool> send(String raw) async {
    final FeedCommentsView? view = ref.read(feedCommentsProvider).value;
    if (view == null || state.busy) return false;
    final FeedCommentSubmitResult? last = state.last;
    if (checkFeedCommentLink(raw, effectiveFeed(view, last).links) != null) {
      return false;
    }
    state = FeedCommentsSend(busy: true, last: last);
    try {
      final FeedCommentSubmitResult result = await ref
          .read(contestRepositoryProvider)
          .submitFeedComment(raw.trim());
      if (!ref.mounted) return true;
      state = FeedCommentsSend(last: result);
      // Each link pays at once: the path, the total and the rank all move,
      // and the task's own read shows the link in the list.
      ref.invalidate(feedCommentsProvider);
      refreshContestStanding(ref.invalidate);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = FeedCommentsSend(error: contestMessage(e), last: last);
      // Sent from another device, revoked, or the day rolled: a re-read
      // shows where it stands. LOCKED means the path moved. A failure that
      // never reached the server changed nothing.
      if (e is ContestLocked) ref.invalidate(contestPathProvider);
      if (e is ContestRefusal && e is! ContestUnavailable) {
        ref.invalidate(feedCommentsProvider);
      }
      return false;
    }
  }

  /// The learner is typing a new link: the last refusal no longer applies.
  void clearError() {
    if (state.error == null) return;
    state = FeedCommentsSend(busy: state.busy, last: state.last);
  }
}
