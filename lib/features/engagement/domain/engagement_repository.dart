import '../../home/domain/roadmap_progress.dart';
import 'comment_draft.dart';
import 'connection_target.dart';

export '../../home/domain/roadmap_progress.dart';
export 'comment_draft.dart';
export 'connection_target.dart';
export 'engagement_mission.dart';

/// Why a generation could not happen.
///
/// The two daily habits are the only screens in the app that can be refused for
/// a reason the user can DO something about, so the refusal is typed rather
/// than collapsed into one "unavailable". Each value maps to a different screen
/// and a different next action; a single error card would send a user with an
/// empty profile to the pricing page.
enum EngagementBlock {
  /// 402 — the XP balance will not cover the batch. Next action: buy XP.
  insufficientXp,

  /// 400 `PROFILE_INCOMPLETE` — no profession on the profile, or a placeholder
  /// one ("Professional", "User"). Next action: finish the profile. The server
  /// refuses BEFORE spending XP, which is the point of the check.
  profileIncomplete,

  /// Anything else — a model failure, a dropped connection, a 5xx. Retryable.
  unavailable,
}

/// A refusal from an engagement endpoint.
///
/// Carries the server's own sentence where there is one: the backend words
/// these better than a client-side guess can, and quoting it is how the user
/// finds out that (say) their headline is the problem rather than their plan.
class EngagementFailure implements Exception {
  const EngagementFailure(this.kind, {this.message, this.requiredXp});

  final EngagementBlock kind;

  /// The backend's message, when the envelope carried one.
  final String? message;

  /// How much XP a fresh batch needs.
  ///
  /// Almost always null today: the service throws `INSUFFICIENT_XP` with
  /// `details.requiredXP`, but the mobile envelope's error mapper drops the
  /// details block, so the number never reaches this client. The screen prices
  /// the action from the last successful batch's `xpCost` instead and says
  /// nothing when it has none — see the note in the summary for the orchestrator.
  final int? requiredXp;

  @override
  String toString() => 'EngagementFailure($kind, $message)';
}

/// Seam between the two daily-habit screens and the backend.
///
/// One repository for both screens because they are one habit: the roadmap
/// pairs "Comment on posts" and "Send connection requests" on every one of the
/// 66 days, and both close out through the same `/roadmap/progress` write.
abstract class EngagementRepository {
  /// `POST /ai/comments`.
  ///
  /// [topic] is normally empty — the server picks a broad, high-volume topic
  /// from the user's niche, and the web's topic field is unreachable in
  /// practice. It is passed through for the golden-hour deep link, which names
  /// the topic the user's own post is about.
  Future<CommentBatch> generateComments({String? topic});

  /// `POST /ai/connections`.
  ///
  /// No input: the server reads the target audience off the user's profile
  /// (headline, falling back to profession) and refuses with
  /// [EngagementBlock.profileIncomplete] when there is nothing usable there.
  Future<ConnectionBatch> findConnections();

  /// `POST /ai/style-memory` — fire and forget.
  ///
  /// Called when the user has rewritten a draft comment. Teaching the model the
  /// user's own edit is the entire mechanism behind the product's "sounds like
  /// me" claim, and it must never surface an error: the user did not ask for
  /// this call and cannot act on its failure.
  Future<void> teachStyle({required String text, String? topic});

  /// `GET /roadmap/progress` — which day it is and what is already done.
  Future<RoadmapProgress> fetchRoadmapProgress();

  /// `POST /roadmap/progress` — credit the step.
  ///
  /// Idempotent server-side, so a double tap cannot double-award.
  Future<void> completeStep({required int levelId, required int stepId});
}
