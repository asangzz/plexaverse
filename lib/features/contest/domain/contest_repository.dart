import 'dart:typed_data';

import 'contest_board.dart';
import 'contest_consistency.dart';
import 'contest_featured.dart';
import 'contest_overview.dart';
import 'contest_path.dart';
import 'contest_tasks.dart';
import 'today_quiz.dart';

export 'contest_board.dart';
export 'contest_consistency.dart';
export 'contest_failures.dart';
export 'contest_featured.dart';
export 'contest_overview.dart';
export 'contest_path.dart';
export 'contest_tasks.dart';
export 'today_quiz.dart';

/// Seam between the contest's screens and the backend.
///
/// One method per mobile route, each the twin of the web's `/api/contest/**`
/// route of the same name: the same service, the same body inside `data`,
/// the same refusal codes. Every refusal the UI branches on arrives as a
/// [ContestRefusal] subtype; anything else as [ContestUnavailable] — so a
/// screen switches on types and never reads a status code.
///
/// ## What is NOT here, on purpose
///
/// No method decides anything the server decides: which day offers which
/// task, the gate, the streak, the week trophy, a rank, an answer's
/// verdict. A screen draws what these return.
abstract class ContestRepository {
  /// `GET /contest` — null when there is no round at all (still a 200).
  ///
  /// READING IS JOINING (owner, 24 Nov 2026): before it answers, the server
  /// starts the next round if the last has ended and enters the caller in the
  /// running one, anonymously — so there is no join step, and no join call
  /// here. The leaderboard-name consent is asked in context instead (the
  /// levels page's "Show my name to other learners").
  Future<ContestOverview?> fetchOverview();

  /// `GET /contest/board?limit=` — the server's default (50) when [limit] is
  /// null, clamped to 1–200.
  Future<BoardResult> fetchBoard({int? limit});

  /// `GET /contest/path?followLevel=1` — this week's levels, fully decided
  /// by the server, with the follow level: this build draws it.
  Future<ContestPath> fetchPath();

  /// `GET /contest/lesson` — today's lesson as it stands. A pure read.
  Future<TodayQuiz> fetchTodayQuiz();

  /// `POST /contest/lesson` — opens today's lesson, and answers it as it
  /// stands after. The day's first open writes the learner's own questions
  /// with a model call (two-minute budget). AWAIT IT before the first
  /// answer: an answer that lands first fixes the day to the set questions
  /// alone, for good. [ContestNotRunning], [ContestNotEntered].
  Future<TodayQuiz> startLesson();

  /// `POST /contest/quiz/answer` `{day, itemId, value}`.
  ///
  /// [day] is `TodayQuiz.day` as loaded; [value] is the option's TEXT. The
  /// first attempt at a question is final; a repeat answers the stored one
  /// with `replay: true`. [ContestStale] and [ContestNotToday] both mean
  /// "re-read today's lesson"; [ContestNotRunning], [ContestNotEntered],
  /// [ContestNoQuiz], [ContestConflict], [ContestInvalid].
  Future<QuizAnswerResult> answerQuiz({
    required int day,
    required String itemId,
    required String value,
  });

  /// `GET /contest/tasks/comment` — today's comment level.
  ///
  /// A GET that WRITES: the day's first open builds the level with a model
  /// call, and the server does not check the gate. Never call it while the
  /// path shows the level locked. Not running and not joined arrive as an
  /// unavailable level with a reason, not as refusals.
  Future<CommentLevelView> fetchCommentLevel();

  /// `POST /contest/tasks/comment/answer` `{words}` — the bank words picked
  /// for the blanks, in order. Only the day's first submission can pay.
  /// [ContestLocked], [ContestNotOpen], [ContestWrongDay],
  /// [ContestAlreadyDone], [ContestConflict], [ContestNotRunning],
  /// [ContestNotEntered], [ContestInvalid].
  Future<CommentSubmitResult> submitComment(List<String> words);

  /// `GET /contest/tasks/feed-comments` — today's feed-comments task.
  /// A pure read; it does not check the gate.
  Future<FeedCommentsView> fetchFeedComments();

  /// `POST /contest/tasks/feed-comments` `{link}` — ONE comment's link,
  /// paid its share as it lands. [ContestBadUrl], [ContestDuplicateUrl],
  /// [ContestRevoked], [ContestAlreadyDone], [ContestLocked],
  /// [ContestWrongDay], [ContestConflict], [ContestNotRunning],
  /// [ContestNotEntered], [ContestInvalid].
  Future<FeedCommentSubmitResult> submitFeedComment(String link);

  /// `GET /contest/tasks/connect` — today's leaders to connect with; a model
  /// call on the day's first ask, the day's batch replayed after.
  ///
  /// Free on a contest Monday or Thursday; any other day the plan gate
  /// applies and refuses as `ai/connections` does — [ContestPlanRefused],
  /// shown with `PlanLimitSheet`. [ContestProfileIncomplete] when there is
  /// no usable profession.
  Future<ConnectionBatch> fetchConnectTargets();

  /// `POST /contest/tasks/connect` — the flow's Finish. `alreadyDone` on a
  /// repeat. [ContestWrongDay], [ContestLocked], [ContestNotRunning],
  /// [ContestNotEntered].
  Future<ConnectTaskResult> completeConnect();

  /// `POST /contest/tasks/invites`, multipart, field `screenshot` — the
  /// week's sent-invitations screenshot. Paid at once, checked after.
  ///
  /// [filename]'s extension decides the part's content type, which must be
  /// `image/*`. At most 8 MB: [ContestTooLarge]. [ContestInvalidImage],
  /// [ContestStorageUnavailable] (retryable), [ContestWrongDay],
  /// [ContestAlreadyDone], [ContestRevoked], [ContestLocked],
  /// [ContestConflict], [ContestNotRunning], [ContestNotEntered].
  Future<InvitesSubmitResult> submitInvites(Uint8List bytes, String filename);

  /// `GET /contest/tasks/plan` — this planner week, day by day.
  Future<PlanWeekView> fetchPlanWeek();

  /// `POST /contest/tasks/plan` — "I've planned this week". [ContestNotReady]
  /// until the week exists in the Planner; [ContestWrongDay],
  /// [ContestLocked], [ContestNotRunning], [ContestNotEntered].
  Future<PlanWeekResult> completePlanWeek();

  /// `POST /contest/tasks/claim` `{kind, occurrence, postUrl}` — claims the
  /// article or a video by its post's link; waits for an admin's approval.
  /// [occurrence] is the path's, sent back unchanged. [ContestBadUrl],
  /// [ContestTooEarly], [ContestNotReady], [ContestAlreadyDone],
  /// [ContestDuplicateUrl], [ContestLocked], [ContestConflict],
  /// [ContestNotRunning], [ContestNotEntered], [ContestInvalid].
  Future<ClaimResult> claimPostLink({
    required ClaimKind kind,
    required String occurrence,
    required String postUrl,
  });

  /// `POST /contest/skip` `{nodeId}` — skip today's CURRENT level, the one
  /// node the path marks `canSkip`. Pays nothing; the level stays open as
  /// `skipped` until the day ends. A repeat is a success with
  /// `alreadySkipped`. [ContestInvalid] (not on today's path),
  /// [ContestWrongDay] (the day rolled over — re-read the path),
  /// [ContestAlreadyDone], [ContestNotOpen] (nothing to do, or not the
  /// current level), [ContestLocked] ("Finish or skip … first."),
  /// [ContestNotRunning], [ContestNotEntered].
  Future<SkipResult> skipLevel(String nodeId);

  /// `GET /contest/consistency` — the consistency meter: contest XP earned ÷
  /// XP on offer over the learner's billing window. A pure read. `state`
  /// off, no_contest or not_joined means show nothing; compare with
  /// `atOrAbove`, never by re-deriving it from `percent`. No price in this
  /// phase.
  Future<ConsistencyView> fetchConsistency();

  /// `GET /contest/featured` — "Learners of the week" and the Hall of Fame.
  /// A pure read; everyone in it agreed to be featured, checked on every
  /// read, so it is never kept past the screen that shows it. The week's
  /// people come only once today's lesson is finished, with no XP, no rank
  /// and no order.
  Future<ContestFeatured> fetchFeatured();

  /// `GET /contest/shoutout` — the viewer's own "Feature me if I make it"
  /// choice and the profile link on record.
  Future<ShoutoutSettings> fetchShoutout();

  /// `PUT /contest/shoutout` — agree (`featured: true` with a public profile
  /// link, or none to confirm the one on record; [adult] is the card's "I am
  /// 18 or older" tick, needed while no declaration is on record) or
  /// withdraw (`featured: false`, which also erases the link and never fails
  /// on one). Answers the new choice. [ContestBadProfileLink],
  /// [ContestAdultRequired], [ContestInvalid].
  Future<ShoutoutSettings> setShoutout({
    required bool featured,
    String? linkedinUrl,
    bool adult = false,
  });

  /// `GET /contest/tasks/follow-winners` — "Follow last round's top
  /// learners": who is in it, and each one's two steps. Not running and not
  /// entered arrive as an unavailable view with a reason, not as refusals.
  Future<FollowWinnersView> fetchFollowWinners();

  /// `POST /contest/tasks/follow-winners` `{handle, step}` — step 1 tapped
  /// ([FollowWinnerStep.linkedin], SELF-REPORTED: LinkedIn tells no app who
  /// follows whom), or step 2 re-checked after the follow itself
  /// ([FollowWinnerStep.plexaverse] — the server believes only the follow
  /// row). Both done → paid once, whichever lands second. [ContestInvalid],
  /// [ContestNotRunning], [ContestNotEntered], [ContestNotInLevel].
  Future<FollowWinnerStepResult> recordFollowWinnerStep({
    required String handle,
    required FollowWinnerStep step,
  });
}
