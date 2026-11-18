import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_links.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'claim_controllers.g.dart';

// One post-link claim, as a level of its posting day. A port of the web's
// `components/contest/tasks/ClaimLevel.tsx`.
//
// WHERE IT LIVES
//   The Wednesday video's link is a level on Wednesday's path, after that
//   day's other levels; the article's, Thursday's. A late claim — a past
//   day's, or last week's still unpaid — opens here from the week card.
//   Either way the level is named by the piece's `kind` and `occurrence`,
//   which arrive in the route and are sent back to the server unchanged.
//
// WHY THE XP WAITS
//   LinkedIn cannot tell us a post went out, so the piece is claimed by its
//   link and our team checks it before the XP lands. [kClaimsLine] says that
//   in one line, so "pending" reads as expected rather than alarming.

/// The web's `CLAIMS_LINE`.
const String kClaimsLine =
    'XP lands when you share the post link — from the day it goes out — and '
    'our team checks it.';

/// Said, before anything is sent, for a link that fails the server's own
/// rule ([isLinkedInPostUrl]) — a profile or a search, say — in words that
/// say what a post link looks like.
const String kNotAPostLinkLine =
    'That is not a LinkedIn post link. Open the post on LinkedIn and copy its '
    'address, which starts with https://www.linkedin.com/posts/ or '
    '/feed/update/.';

/// The claim a level is about, and whether today's gate holds it.
class ClaimLevel {
  const ClaimLevel({this.claim, this.lockedDetail});

  /// From `path.claims`, matched on `(kind, occurrence)` the way the claim
  /// endpoint matches it. Null when the path lists no such piece.
  final PostClaim? claim;

  /// On its posting day the claim waits behind the day's earlier levels: the
  /// node's "Unlocks after …" line while it does. Null otherwise — a late
  /// claim is never gated.
  final String? lockedDetail;
}

/// The claim named by [kind] and [occurrence], read off [path].
ClaimLevel claimLevelOf(ContestPath? path, ClaimKind kind, String occurrence) {
  PathNode? node;
  for (final PathNode n in path?.today?.nodes ?? const <PathNode>[]) {
    if (n.claim?.kind == kind && n.claim?.occurrence == occurrence) {
      node = n;
      break;
    }
  }
  return ClaimLevel(
    claim: path?.claimFor(kind, occurrence),
    lockedDetail: node?.state == PathNodeState.locked
        ? (node?.detail ?? 'Finish or skip today’s earlier levels first')
        : null,
  );
}

/// Where sending the link stands.
class ClaimSend {
  const ClaimSend({
    this.busy = false,
    this.problem,
    this.error,
    this.locked = false,
    this.sent,
  });

  final bool busy;

  /// The link failed the rule here, before it was sent.
  final String? problem;

  /// The server's refusal, in its own words.
  final String? error;

  /// The refusal was the gate (409 LOCKED).
  final bool locked;

  /// The claim as the server answered it: pending, with the link it
  /// normalised. Shown at once, before the re-read path says so itself.
  final PostClaim? sent;
}

/// `POST /contest/tasks/claim` for one piece.
@riverpod
class ClaimActions extends _$ClaimActions {
  @override
  ClaimSend build(ClaimKind kind, String occurrence) => const ClaimSend();

  /// The field changed: what was said about the last link no longer applies.
  void edited() {
    if (state.problem == null && state.error == null) return;
    state = const ClaimSend();
  }

  /// Checks [raw] against the server's rule, then sends it.
  Future<void> submit(String raw) async {
    if (state.busy || state.sent != null) return;
    final String link = raw.trim();
    if (!isLinkedInPostUrl(link)) {
      state = const ClaimSend(problem: kNotAPostLinkLine);
      return;
    }
    state = const ClaimSend(busy: true);
    try {
      final ClaimResult result = await ref
          .read(contestRepositoryProvider)
          .claimPostLink(kind: kind, occurrence: occurrence, postUrl: link);
      if (!ref.mounted) return;
      state = ClaimSend(sent: result.claim);
      refreshContestStanding(ref.invalidate);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = ClaimSend(error: contestMessage(e), locked: e is ContestLocked);
    }
  }
}
