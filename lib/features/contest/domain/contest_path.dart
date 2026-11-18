import 'package:freezed_annotation/freezed_annotation.dart';

part 'contest_path.freezed.dart';
part 'contest_path.g.dart';

/// What a level on the path is. Mirrors `PathNodeKind` in the web's
/// `lib/contest-path-types.ts`, plus [unknown].
///
/// ## [unknown] is a guard, not a kind
///
/// The web can add a level this build has never heard of. Mapped onto any
/// real kind it would open that kind's screen — a new level's node opening
/// the lesson — so it lands here instead, and [PathNode] draws it locked with
/// nothing to open. The switch over this enum stays exhaustive, so every
/// screen that routes on it has to say what [unknown] does.
enum PathNodeKind {
  lesson,
  @JsonValue('connect_leaders')
  connectLeaders,
  comment,
  @JsonValue('feed_comments')
  feedComments,
  @JsonValue('weekly_invites')
  weeklyInvites,
  @JsonValue('plan_week')
  planWeek,
  article,
  video,
  unknown;

  /// The server's spelling — what a level's id and the web's routes use.
  String get wire => switch (this) {
    PathNodeKind.connectLeaders => 'connect_leaders',
    PathNodeKind.feedComments => 'feed_comments',
    PathNodeKind.weeklyInvites => 'weekly_invites',
    PathNodeKind.planWeek => 'plan_week',
    _ => name,
  };

  static PathNodeKind parse(String? raw) {
    for (final PathNodeKind k in PathNodeKind.values) {
      if (k != PathNodeKind.unknown && k.wire == raw) return k;
    }
    return PathNodeKind.unknown;
  }

  /// A post-link claim: the planner's article or one of its videos, claimed
  /// as a level of the day it goes out.
  bool get isClaim =>
      this == PathNodeKind.article || this == PathNodeKind.video;
}

/// Where a level stands. Mirrors `PathNodeState`.
///
/// Every state the server can send is here, and an unknown one reads as
/// [locked]: drawn dark, opening nothing, and passed over by the START
/// bubble. That is the one reading under which a state this build cannot
/// interpret does nothing it was not told to do.
enum PathNodeState {
  /// A day not reached — or, today, a level waiting on the one before it
  /// (`detail` says which: "Unlocks after …").
  locked,

  /// Open now and not done: where START sits.
  today,

  /// Finished and paid.
  done,

  /// A past day's level left undone. It does not come back — and a late
  /// joiner's days before they joined read as missed too, which is the
  /// server's choice and is not a failure of theirs.
  missed,

  /// Proof sent, waiting for an admin.
  pending,

  /// Proof approved and paid.
  approved,

  /// Sent back; `detail` says why. It can be sent again, and it counts as
  /// the current level.
  rejected,

  /// Paid, then audited and found a false claim: the XP taken back with a
  /// penalty. Final — it never opens again.
  revoked,

  /// Today, with nothing to do (no post in the learner's topics, a comment
  /// that could not be written). Passed over by the gate.
  unavailable,

  /// Today's level the learner passed over with Skip (owner, 17 Nov 2026).
  /// It stays open — `href` kept — until the contest day ends, lets the next
  /// level open (the gate passes it), and pays as usual if done after all.
  /// Tomorrow it reads [missed]. A state read off the level's own rows (done,
  /// pending, …) always beats it.
  skipped;

  String get wire => name;

  static PathNodeState parse(String? raw) {
    for (final PathNodeState s in PathNodeState.values) {
      if (s.name == raw) return s;
    }
    return PathNodeState.locked;
  }
}

/// Which planner piece a claim is: the Thursday article or a video. The same
/// [unknown] guard as [PathNodeKind] — an unknown piece is never claimed as
/// an article by default.
enum ClaimKind {
  article,
  video,
  unknown;

  String get wire => name;

  static ClaimKind parse(String? raw) => switch (raw) {
    'article' => ClaimKind.article,
    'video' => ClaimKind.video,
    _ => ClaimKind.unknown,
  };
}

/// Where a claim stands on the week card. Mirrors `PostClaim['status']`.
enum ClaimStatus {
  /// Not in the planner yet, or before the day it goes out.
  @JsonValue('not_ready')
  notReady,

  /// Its day has come and nothing is sent: "Share link".
  open,
  pending,
  approved,
  rejected,
}

/// Which part of the day's lesson a lesson node is.
///
/// `index` is 1-based; [start] and [end] are the half-open question range as
/// the SERVER cut it, so the START ring measures the same part the node's
/// detail counts. Absent from a server that predates parts.
@freezed
abstract class NodePart with _$NodePart {
  const factory NodePart({
    @Default(1) int index,
    @Default(1) int total,
    int? start,
    int? end,
  }) = _NodePart;

  factory NodePart.fromJson(Map<String, dynamic> json) =>
      _$NodePartFromJson(json);
}

/// The piece a claim node stands for, as the claim endpoint takes it.
@freezed
abstract class NodeClaim with _$NodeClaim {
  const factory NodeClaim({
    @JsonKey(unknownEnumValue: ClaimKind.unknown)
    @Default(ClaimKind.unknown)
    ClaimKind kind,

    /// Opaque. Sent back unchanged with the link — `"<week>:<journey>"` for
    /// the article and `"<week>:<journey>:<day>"` for a video today, but the
    /// shape is the server's to change.
    @Default('') String occurrence,
  }) = _NodeClaim;

  factory NodeClaim.fromJson(Map<String, dynamic> json) =>
      _$NodeClaimFromJson(json);
}

/// One level on the path. Mirrors `PathNode`.
///
/// ## [href] is a web path, and nothing here routes on it
///
/// The server fills it with the WEB's address for the level
/// (`/contest/lesson`, `/connections?from=contest`, …). The app dispatches on
/// [kind] and [claim] instead and reads [href] only as "this level opens":
/// routed blindly, a web path the app does not register is a "Page not
/// found", where an unknown kind simply opens nothing.
@freezed
abstract class PathNode with _$PathNode {
  const PathNode._();

  const factory PathNode({
    /// Opaque and stable within the path: `<day>:lesson:<k>`, `<day>:<kind>`,
    /// and `<day>:<kind>:<occurrence>` for a claim.
    @Default('') String id,
    @JsonKey(unknownEnumValue: PathNodeKind.unknown)
    @Default(PathNodeKind.unknown)
    PathNodeKind kind,

    /// Forced to [PathNodeState.locked] for an [PathNodeKind.unknown] kind,
    /// whatever the server said — see [PathNodeKind.unknown].
    @JsonKey(
      readValue: _stateUnlessUnknown,
      unknownEnumValue: PathNodeState.locked,
    )
    @Default(PathNodeState.locked)
    PathNodeState state,

    /// The server's copy: "Lesson · part 2 of 3", "Comment on a top voice".
    @Default('') String title,

    /// A promise while the level is open, a receipt once it is closed — what
    /// it pays, still could pay, or did pay. Never recomputed here.
    @Default(0) int points,

    /// Null when there is nothing to open. A WEB path — see the class doc.
    @JsonKey(readValue: _hrefUnlessUnknown) String? href,

    /// One line: "5 questions", "2 of 5 answered", "Unlocks after Lesson part
    /// 3 of 3", "Rejected: …", "Removed: … — −80 XP".
    String? detail,

    /// Today's work already part done (some of the day's feed comments
    /// sent): the button says Continue, and [points] is what is left.
    @Default(false) bool started,

    /// Lesson nodes only.
    NodePart? part,

    /// Claim nodes only.
    NodeClaim? claim,

    /// The one level Skip may be pressed on: today's open level (the gate's
    /// first node still holding the chain, in state today or rejected). On at
    /// most one node, and absent everywhere else. Forced false for an
    /// [PathNodeKind.unknown] kind — a level this build cannot open is not
    /// one to pass over either.
    @JsonKey(readValue: _canSkipUnlessUnknown) @Default(false) bool canSkip,
  }) = _PathNode;

  factory PathNode.fromJson(Map<String, dynamic> json) =>
      _$PathNodeFromJson(json);

  bool get isLesson => kind == PathNodeKind.lesson;
}

bool _knownKind(Map<dynamic, dynamic> json) =>
    PathNodeKind.parse(json['kind'] as String?) != PathNodeKind.unknown;

Object? _stateUnlessUnknown(Map<dynamic, dynamic> json, String key) =>
    _knownKind(json) ? json[key] : PathNodeState.locked.wire;

Object? _hrefUnlessUnknown(Map<dynamic, dynamic> json, String key) =>
    _knownKind(json) ? json[key] : null;

Object? _canSkipUnlessUnknown(Map<dynamic, dynamic> json, String key) =>
    _knownKind(json) && json[key] == true;

/// One day of the shown week. Mirrors `PathDay`.
@freezed
abstract class PathDay with _$PathDay {
  const factory PathDay({
    @Default(0) int dayNumber,

    /// `YYYY-MM-DD` in the CONTEST's timezone. Read as a calendar date; a
    /// weekday computed from the device's clock can be a day off.
    @Default('') String dayKey,

    /// 0 = Sunday … 6 = Saturday, from the server.
    @Default(0) int weekday,
    @Default(false) bool isToday,
    @Default(<PathNode>[]) List<PathNode> nodes,
  }) = _PathDay;

  factory PathDay.fromJson(Map<String, dynamic> json) =>
      _$PathDayFromJson(json);
}

/// A planner piece the learner claims by its post link. Mirrors `PostClaim`.
@freezed
abstract class PostClaim with _$PostClaim {
  const PostClaim._();

  const factory PostClaim({
    @JsonKey(unknownEnumValue: ClaimKind.unknown)
    @Default(ClaimKind.unknown)
    ClaimKind kind,

    /// Sent back unchanged with the link.
    @Default('') String occurrence,
    @Default('') String title,

    /// The planner day it goes out, in the USER's timezone (the planner's),
    /// not the contest's — which is why a user outside India can see it a
    /// day early. Null when unknown.
    String? postingDayKey,

    /// The first day a link is accepted: the posting day itself.
    String? opensOnKey,

    /// An unknown status reads as not ready: nothing to share yet.
    @JsonKey(unknownEnumValue: ClaimStatus.notReady)
    @Default(ClaimStatus.notReady)
    ClaimStatus status,

    /// The link sent, normalised by the server. Null until one is.
    String? postUrl,

    /// What an approval pays.
    @Default(0) int points,
    String? rejectReason,
  }) = _PostClaim;

  factory PostClaim.fromJson(Map<String, dynamic> json) =>
      _$PostClaimFromJson(json);
}

/// The daily feed-comments task's numbers, as the path carries them.
@freezed
abstract class FeedCommentsRule with _$FeedCommentsRule {
  const factory FeedCommentsRule({
    /// How many links the day asks for.
    @Default(5) int perDay,

    /// What the five pay IN TOTAL.
    @Default(0) int points,

    /// What a false claim costs on top of taking back what it paid.
    @Default(0) int penalty,
  }) = _FeedCommentsRule;

  factory FeedCommentsRule.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentsRuleFromJson(json);
}

/// The shown week's bonus for finishing every day's lesson in it — the week
/// trophy. Mirrors `WeekReward`; the server decides all of it.
@freezed
abstract class WeekReward with _$WeekReward {
  const factory WeekReward({
    /// What the week pays (the contest's rule).
    @Default(0) int points,

    /// Every lesson the week asks for is finished.
    @Default(false) bool earned,

    /// What the ledger paid; null when not earned, or earned while scoring
    /// was paused.
    int? paid,

    /// A day the week asked for went unfinished: it can no longer be earned.
    @Default(false) bool missedDay,
  }) = _WeekReward;

  factory WeekReward.fromJson(Map<String, dynamic> json) =>
      _$WeekRewardFromJson(json);
}

/// Why the path has no week to draw, or that it has one. Mirrors
/// `ContestPathStatus`.
///
/// An unknown status reads as [noContest]: anything but [running] draws no
/// path, and "nothing running" is the reading that promises nothing.
enum ContestPathStatus {
  @JsonValue('no_contest')
  noContest,
  @JsonValue('not_joined')
  notJoined,
  upcoming,
  ended,
  running,
}

/// `GET /contest/path` → `{path}`: this week's days and their levels.
/// Mirrors `ContestPath` in the web's `lib/contest-path-types.ts`.
///
/// Fully server-decided. Which day offers what, the one-level-at-a-time gate,
/// the streak, the week trophy, the claims: none of it is computed here, and
/// none of it may be. The client draws.
@freezed
abstract class ContestPath with _$ContestPath {
  const ContestPath._();

  const factory ContestPath({
    @JsonKey(unknownEnumValue: ContestPathStatus.noContest)
    @Default(ContestPathStatus.noContest)
    ContestPathStatus status,
    String? contestId,

    /// Today's contest day (1 = the start date). Shown as "Day D" — never
    /// beside [finalDay].
    int? dayNumber,

    /// The last day's number. **Never rendered**: no "Day D of N".
    int? finalDay,

    /// The contest week shown — 1 is the Sunday-to-Saturday week the contest
    /// starts in. Shown as "Week W".
    int? weekNumber,

    /// This calendar week, SUNDAY to Saturday in the contest's timezone,
    /// clipped to the contest. Empty unless [status] is running.
    @Default(<PathDay>[]) List<PathDay> days,

    /// This planner week's article and videos, plus last week's still
    /// unpaid ones. The week card lists claims from here, not from nodes.
    @Default(<PostClaim>[]) List<PostClaim> claims,
    FeedCommentsRule? feedComments,
    WeekReward? weekReward,
  }) = _ContestPath;

  factory ContestPath.fromJson(Map<String, dynamic> json) =>
      _$ContestPathFromJson(json);

  /// A week to draw. The overview can say running a moment before the path
  /// does (around midnight); the page says "not ready yet" rather than
  /// drawing an empty path.
  bool get hasWeek => status == ContestPathStatus.running && days.isNotEmpty;

  /// Today, when it is in the shown week.
  PathDay? get today {
    for (final PathDay d in days) {
      if (d.isToday) return d;
    }
    return null;
  }

  /// Today's level of [kind] — the first, for a kind a day can hold twice.
  PathNode? todayNode(PathNodeKind kind) {
    for (final PathNode n in today?.nodes ?? const <PathNode>[]) {
      if (n.kind == kind) return n;
    }
    return null;
  }

  /// Today's level of [kind] — for a claim, the one for [occurrence] (a day
  /// can hold two pieces); otherwise the first of the kind. What a level's
  /// own page reads its Skip off.
  PathNode? todayNodeFor(PathNodeKind kind, {String? occurrence}) {
    for (final PathNode n in today?.nodes ?? const <PathNode>[]) {
      if (n.kind != kind) continue;
      if (occurrence != null && n.claim?.occurrence != occurrence) continue;
      return n;
    }
    return null;
  }

  /// The claim the path lists for a piece, matched the way the claim
  /// endpoint matches it.
  PostClaim? claimFor(ClaimKind kind, String occurrence) {
    for (final PostClaim c in claims) {
      if (c.kind == kind && c.occurrence == occurrence) return c;
    }
    return null;
  }
}
