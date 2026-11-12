import 'package:intl/intl.dart';

import 'placement_models.dart';

export 'cefr_band.dart';
export 'placement_models.dart';

/// Seam between the placement test and the backend.
///
/// Five routes and the consent ledger, mirroring the web's `/api/placement/*`
/// under `/api/mobile/v1`. Start and answer resolve to the NEXT step — never a
/// verdict on the last one; writing and finish to the result.
///
/// ## Every refusal arrives as its own type
///
/// The server answers with the web's own statuses — 403 CONSENT_REQUIRED, 429
/// COOLDOWN, 503 GRADING_UNAVAILABLE — which the interceptor files as an auth
/// failure and two network blips. Read by class, a cooldown would say "check
/// your connection" and a consent refusal would look like a sign-out. So the
/// repository reads the code first and throws one of the types below; the page
/// branches on those, never on a status.
abstract class PlacementRepository {
  /// `GET /placement`. Not a pure read: an attempt past its closing time is
  /// settled first, which can move the band.
  Future<PlacementStatus> fetchStatus();

  /// `POST /placement/start`. Resumes the open attempt, or (cooldown
  /// permitting) opens one. [PlacementCooldown] inside the 30 days.
  Future<PlacementStep> start();

  /// `POST /placement/answer` with `{attemptId, itemId, value}`. [value] is the
  /// option's TEXT and [itemId] the step's handle exactly as received.
  ///
  /// The answer that finishes the third part completes the attempt and sets
  /// the band in the same write; its step is the writing stage.
  Future<PlacementStep> answer({
    required String attemptId,
    required String itemId,
    required String value,
  });

  /// `POST /placement/finish` with `{attemptId}` — "Skip writing", and any
  /// later look at a result. Writes nothing new.
  Future<PlacementResult> finish(String attemptId);

  /// `POST /placement/writing` with `{attemptId, text}`. Graded by a model;
  /// never moves the band. [PlacementConsentRequired] until
  /// [grantWritingConsent] has been recorded.
  Future<PlacementResult> submitWriting({
    required String attemptId,
    required String text,
  });

  /// `PATCH /user/consent` with `{purpose: 'assessment_grading', granted: true,
  /// source: 'in_context'}` — the writing step's own card, so the ledger
  /// records where the yes was given rather than calling it a settings toggle.
  Future<void> grantWritingConsent();
}

/// Every placement refusal the page acts on. Each carries the server's
/// sentence, already finished, so the page can show it as it is.
sealed class PlacementFailure implements Exception {
  const PlacementFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 429 COOLDOWN: a test was completed in the last 30 days.
///
/// "When" is the whole answer, so [nextRetakeAt] rides with it. The
/// interceptor drops the envelope's `details`, which is where the server puts
/// it — the repository reads it off the raw response body.
final class PlacementCooldown extends PlacementFailure {
  const PlacementCooldown(super.message, {this.nextRetakeAt});

  final DateTime? nextRetakeAt;
}

/// 403 CONSENT_REQUIRED: grading sends the text to an AI provider, and the
/// learner has not agreed to that (or withdrew it in Settings since the page
/// loaded). The answer is the consent card, not an error.
final class PlacementConsentRequired extends PlacementFailure {
  const PlacementConsentRequired(super.message);
}

/// 503 GRADING_UNAVAILABLE: the model failed for a reason worth retrying.
/// Nothing was stored, the writing step is still open, and the level never
/// waited on it — keep the draft and offer the same button again.
final class PlacementGradingUnavailable extends PlacementFailure {
  const PlacementGradingUnavailable(super.message);
}

/// 409 ALREADY_COMPLETE: the attempt on screen moved on — finished elsewhere,
/// closed after it was left too long, or its writing is already in.
final class PlacementAlreadyComplete extends PlacementFailure {
  const PlacementAlreadyComplete(super.message);
}

/// 404 NOT_FOUND: not this learner's attempt, or one that expired with nothing
/// answered and was cleared.
final class PlacementNotFound extends PlacementFailure {
  const PlacementNotFound(super.message);
}

/// 409 NOT_READY: writing or finishing before the three parts are done.
final class PlacementNotReady extends PlacementFailure {
  const PlacementNotReady(super.message);
}

/// 400 VALIDATION_FAILED: the server's own sentence for a request it would
/// not take — a stale handle, an option it does not know, writing too short.
final class PlacementRejected extends PlacementFailure {
  const PlacementRejected(super.message);
}

/// Anything else: the connection, a limiter, a 500. Carries the server's
/// sentence when there was one.
final class PlacementUnavailable extends PlacementFailure {
  const PlacementUnavailable([super.message = placementFallbackMessage]);
}

/// What a request that failed says when the server said nothing usable.
const String placementFallbackMessage = 'Something went wrong. Try again.';

/// The page's words for GRADING_UNAVAILABLE, whatever the route carries.
///
/// It is the one refusal a learner meets mid-task with a draft in the box, and
/// the page has to say three things the route's wording may not: the draft is
/// safe to send again, the level does not wait on it, try again (`errorWords`
/// on the web).
const String gradingUnavailableMessage =
    'Could not grade your writing just now. Your level is already set. Try '
    'again in a moment.';

/// One sentence for anything a placement call can throw, so no screen ever
/// shows a stack trace or a class name.
String placementMessage(Object error) => switch (error) {
  PlacementGradingUnavailable() => gradingUnavailableMessage,
  PlacementCooldown(:final String message, :final DateTime? nextRetakeAt)
      when message.isEmpty && nextRetakeAt != null =>
    'You can retake the test on '
        '${DateFormat.yMMMMd().format(nextRetakeAt.toLocal())}.',
  PlacementFailure(:final String message) when message.isNotEmpty => message,
  _ => placementFallbackMessage,
};
