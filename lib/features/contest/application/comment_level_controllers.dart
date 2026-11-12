import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/link_opening.dart';
import '../../../core/security/clipboard_policy.dart';
import '../data/contest_repositories.dart';
import '../domain/contest_links.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'comment_level_controllers.g.dart';

// The daily comment level: a top voice's post, a comment on it with three to
// five words missing, and a bank of words to fill them from.
//
// The level is the server's — the post, the comment, which words are right,
// what the day pays. What lives here is the gate in front of the read, the
// learner's picks while they play, and the hand-off to LinkedIn once the
// comment is right. We never post it for them.

/// How long to wait before asking again while another request is writing
/// today's comment — the web's `refetchInterval` while `reason === 'writing'`.
const Duration kCommentWritingPoll = Duration(seconds: 3);

/// What the comment level's page can show, decided before the level is read.
sealed class CommentLevelState {
  const CommentLevelState();
}

/// The path has not answered, so whether the level is gated is not known yet
/// — and the read waits with it.
final class CommentLevelWaiting extends CommentLevelState {
  const CommentLevelWaiting();
}

/// Gated behind an earlier level of today. Nothing was read.
final class CommentLevelLocked extends CommentLevelState {
  const CommentLevelLocked(this.detail);

  /// The node's own "Unlocks after …" line.
  final String detail;
}

/// Read: open, done, or unavailable with its reason.
final class CommentLevelReady extends CommentLevelState {
  const CommentLevelReady(this.level);

  final CommentLevelView level;
}

/// `GET /contest/tasks/comment`, behind the path's gate.
///
/// ## The gate comes first, and it is not a formality
///
/// This GET WRITES. The day's first read builds the level — the server picks
/// the post and spends a model call on the comment — and the server does not
/// check the gate here; only the answer does. A level read while the path
/// still shows it locked would spend the call and write the day's row for a
/// level the learner cannot play yet. The web waits on the path for the same
/// reason (`useTodayLock`); this waits too, and never asks while locked.
///
/// A path that FAILED is not a gate: the level is read, and the answer's 409
/// LOCKED still holds.
///
/// ## Writing
///
/// While another request is writing today's comment, the level comes back
/// unavailable with reason `writing`. It is asked again every
/// [kCommentWritingPoll] until it lands. The timer belongs to the read, so
/// leaving the page stops it.
@riverpod
class CommentLevelController extends _$CommentLevelController {
  @override
  Future<CommentLevelState> build() async {
    // Only the two facts the gate turns on. A re-read path that changes
    // neither must not re-read the level: that would also rebuild the player
    // under the learner's picks.
    final (String? locked, bool pending) = ref.watch(
      todayLockProvider(
        PathNodeKind.comment,
      ).select((TodayLock lock) => (lock.locked, lock.pending)),
    );
    if (pending) return const CommentLevelWaiting();
    if (locked != null) return CommentLevelLocked(locked);

    final CommentLevelView level = await ref
        .watch(contestRepositoryProvider)
        .fetchCommentLevel();
    if (level.isWriting) {
      final Timer again = Timer(kCommentWritingPoll, ref.invalidateSelf);
      ref.onDispose(again.cancel);
    }
    return CommentLevelReady(level);
  }

  /// A submission's level, straight from its answer — the web's
  /// `setQueryData`. A right one arrives done, with the comment and the
  /// post's link, and shows at once rather than after a second read.
  void landed(CommentLevelView level) {
    state = AsyncData<CommentLevelState>(CommentLevelReady(level));
  }
}

/// The post's link, if the app may open it: https on a LinkedIn host.
///
/// The server only filters it to https. The web also requires a LinkedIn
/// host before `window.open`, and so does this — a link the learner did not
/// choose is handed to the OS only when it goes where the level says it
/// does. Null hides "Open post" and says to find it in the feed instead.
String? commentPostUrl(CommentLevelView level) {
  final String? raw = level.post?.postUrl;
  return isLinkedInHost(raw) ? raw!.trim() : null;
}

/// How "Comment on LinkedIn" went.
enum CommentHandOff {
  /// Not pressed yet.
  idle,

  /// Copied, and the post handed to LinkedIn — or there was no post to open.
  /// The level is finished; the page goes back to the path.
  copied,

  /// The clipboard refused. The comment stays on screen to copy by hand,
  /// with "Open post" for after.
  refused,

  /// Copied, but nothing could open the post. The comment is on the
  /// clipboard; "Open post" stays to try again.
  notOpened,
}

/// The player's picks and what is in flight — held here, not on the widget:
/// a submission outlives a rebuild, and its verdict decides what every blank
/// and the result bar show.
class CommentPlay {
  const CommentPlay({
    this.slots = const <int?>[],
    this.graded,
    this.busy = false,
    this.error,
    this.handOff = CommentHandOff.idle,
  });

  /// The bank word in each blank, by its index in the bank, left to right;
  /// null is an empty blank. An index rather than the word: a tap means
  /// "that chip".
  final List<int?> slots;

  /// The last submission while its verdict is up. Always a miss — a right
  /// one lands as a done level, and the player gives way to it.
  final CommentSubmitResult? graded;

  /// A submission is out.
  final bool busy;

  /// The refusal of the last submission, in the server's words.
  final String? error;

  final CommentHandOff handOff;

  int get filled => slots.where((int? s) => s != null).length;

  /// Every blank has a word: Check can go.
  bool get full => slots.isNotEmpty && filled == slots.length;

  /// The bank indexes already in a blank.
  Set<int> get used => <int>{for (final int? s in slots) ?s};

  /// Nothing moves while a verdict is up or a submission is out.
  bool get frozen => graded != null || busy;
}

/// The comment player: tap a bank word into the next empty blank, tap a
/// filled blank to send its word back, check the whole sequence, and after a
/// miss try again with the right picks kept.
///
/// Only the day's FIRST submission can pay, and the server decides that. A
/// miss shows every right word (the answer always carries them) and the
/// learner may submit again until it is right — the comment is theirs to
/// post either way.
@riverpod
class CommentLevelActions extends _$CommentLevelActions {
  @override
  CommentPlay build() {
    // Fresh blanks for a fresh level — one written afresh by another request
    // starts empty, as the web keys its player by the level's text. A level
    // that only changed state (the miss's firstTry, a re-read) keeps them.
    final (int, String)? key = ref.watch(
      commentLevelControllerProvider.select(
        (AsyncValue<CommentLevelState> s) => switch (s.value) {
          CommentLevelReady(:final CommentLevelView level) => (
            level.blankCount ?? 0,
            '${level.template}\u0000${level.bank.join('\u0000')}',
          ),
          _ => null,
        },
      ),
    );
    return CommentPlay(slots: List<int?>.filled(key?.$1 ?? 0, null));
  }

  CommentLevelView? get _level =>
      switch (ref.read(commentLevelControllerProvider).value) {
        CommentLevelReady(:final CommentLevelView level) => level,
        _ => null,
      };

  /// A bank word into the next empty blank, left to right.
  void place(int bankIndex) {
    final CommentLevelView? level = _level;
    if (level == null || state.frozen) return;
    if (bankIndex < 0 || bankIndex >= level.bank.length) return;
    if (state.used.contains(bankIndex)) return;
    final int at = state.slots.indexOf(null);
    if (at == -1) return;
    state = CommentPlay(
      slots: List<int?>.of(state.slots)..[at] = bankIndex,
      error: state.error,
    );
  }

  /// A filled blank's word back to the bank.
  void takeBack(int slot) {
    if (state.frozen || slot < 0 || slot >= state.slots.length) return;
    state = CommentPlay(
      slots: List<int?>.of(state.slots)..[slot] = null,
      error: state.error,
    );
  }

  /// Submit the whole sequence: `POST /contest/tasks/comment/answer`.
  Future<void> check() async {
    final CommentLevelView? level = _level;
    if (level == null || !state.full || state.frozen) return;
    final List<int?> slots = state.slots;
    final List<String> words = <String>[
      for (final int? i in slots) level.bank[i!],
    ];
    state = CommentPlay(slots: slots, busy: true);
    try {
      final CommentSubmitResult result = await ref
          .read(contestRepositoryProvider)
          .submitComment(words);
      if (!ref.mounted) return;
      ref.read(commentLevelControllerProvider.notifier).landed(result.level);
      refreshContestStanding(ref.invalidate);
      state = CommentPlay(slots: slots, graded: result.correct ? null : result);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = CommentPlay(slots: slots, error: contestMessage(e));
      // A refusal is learnt by re-reading: LOCKED means the path moved, and
      // anything else the server named means the level may have (another
      // device, the day rolled). A failure that never reached it changed
      // nothing, so it re-reads nothing.
      if (e is ContestLocked) ref.invalidate(contestPathProvider);
      if (e is ContestRefusal && e is! ContestUnavailable) {
        ref.invalidate(commentLevelControllerProvider);
      }
    }
  }

  /// After a miss: clear the wrong blanks, keep the right ones.
  void tryAgain() {
    final CommentSubmitResult? graded = state.graded;
    if (graded == null) return;
    state = CommentPlay(
      slots: <int?>[
        for (int i = 0; i < state.slots.length; i++)
          i < graded.blanks.length && graded.blanks[i].correct
              ? state.slots[i]
              : null,
      ],
    );
  }

  /// "Comment on LinkedIn": copy the finished comment, then open the post.
  ///
  /// The clipboard FIRST. The next thing the learner does is paste, and the
  /// open sends this app to the background — a copy left until after it
  /// could be refused, or land after they have already pasted nothing. The
  /// post opens only through [commentPostUrl].
  Future<CommentHandOff> handOff() async {
    final CommentLevelView? level = _level;
    final String? comment = level?.comment;
    if (level == null || comment == null || comment.isEmpty || state.busy) {
      return state.handOff;
    }
    // One hand-off at a time: a second tap must not open the post twice.
    state = CommentPlay(
      slots: state.slots,
      busy: true,
      handOff: state.handOff,
    );
    try {
      await ClipboardPolicy.copyNonSensitive(comment);
    } on Object {
      if (ref.mounted) _say(CommentHandOff.refused);
      return CommentHandOff.refused;
    }
    final CommentHandOff outcome = await _open(level)
        ? CommentHandOff.copied
        : CommentHandOff.notOpened;
    if (ref.mounted) _say(outcome);
    return outcome;
  }

  /// "Open post", for after a copy by hand or a failed open. True when the
  /// post opened.
  ///
  /// After a failed open the comment was already copied, so an open now
  /// finishes the hand-off. After a refused copy it does not: the learner
  /// copied it by hand, or has yet to.
  Future<bool> openPost() async {
    final CommentLevelView? level = _level;
    if (level == null || commentPostUrl(level) == null) return false;
    final bool opened = await _open(level);
    if (opened && ref.mounted && state.handOff == CommentHandOff.notOpened) {
      _say(CommentHandOff.copied);
    }
    return opened;
  }

  /// True when the post opened, or when there is no post to open.
  Future<bool> _open(CommentLevelView level) async {
    final String? url = commentPostUrl(level);
    if (url == null) return true;
    return await ref.read(linkOpeningProvider).open(url) is LinkOpened;
  }

  void _say(CommentHandOff handOff) => state = CommentPlay(
    slots: state.slots,
    graded: state.graded,
    handOff: handOff,
  );
}
