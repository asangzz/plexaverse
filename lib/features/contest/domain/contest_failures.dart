import '../../../core/plan/plan_refusal.dart';

/// Every refusal from the contest's routes the UI has to tell apart.
///
/// ## Read by CODE, at any status
///
/// The mobile routes answer with the web's codes AND the web's statuses, and
/// the network layer files three of those statuses under the wrong class: a
/// 403 is an `AuthFailure` — "your session expired" — and a 429 or 503 a
/// network blip. None of the contest's refusals is either. So the repository
/// maps `Failure.errorCode` first and only falls back to the class when no
/// code it knows came back — `NOT_ENTERED` is "join first" whether the lesson
/// routes send it as 403 or the task routes as 404.
///
/// Each carries the server's own sentence. The defaults are the web's
/// sentences for the same refusal, used only when the server sent none.
sealed class ContestRefusal implements Exception {
  const ContestRefusal(this.message);

  /// Safe to show as-is.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// NOT_ENTERED: signed in, not a participant. Join first.
final class ContestNotEntered extends ContestRefusal {
  const ContestNotEntered([super.message = 'Join the contest first.']);
}

/// NOT_RUNNING: no contest is running — none at all, one not started, or
/// one over. From join it means there is nothing to join, which the join
/// card says in a neutral tone rather than as a failure.
final class ContestNotRunning extends ContestRefusal {
  const ContestNotRunning([
    super.message = 'There is no contest running right now.',
  ]);
}

/// LOCKED: today's earlier level is not finished — the path opens one level
/// at a time. The cure is to re-read the path, which says which.
final class ContestLocked extends ContestRefusal {
  const ContestLocked([
    super.message = 'Finish or skip today’s earlier levels first.',
  ]);
}

/// STALE_QUIZ: today's questions changed since they were loaded (a placement
/// moved the band). Re-read the lesson; the page says the questions were
/// updated rather than that something failed.
final class ContestStale extends ContestRefusal {
  const ContestStale([
    super.message =
        'Today’s quiz changed since this page loaded. Reload for today’s questions.',
  ]);
}

/// NOT_TODAY: the lesson being answered is yesterday's. Re-read it.
final class ContestNotToday extends ContestRefusal {
  const ContestNotToday([
    super.message = 'That quiz has closed. Reload for today’s.',
  ]);
}

/// NO_QUIZ: there is no lesson today at this band.
final class ContestNoQuiz extends ContestRefusal {
  const ContestNoQuiz([super.message = 'There is no quiz today.']);
}

/// WRONG_DAY: the task is not offered today, on the contest's clock.
final class ContestWrongDay extends ContestRefusal {
  const ContestWrongDay([super.message = 'That task is not open today.']);
}

/// TOO_EARLY: a claim before the day its piece goes out.
final class ContestTooEarly extends ContestRefusal {
  const ContestTooEarly([
    super.message = 'You can share it from the day it goes out.',
  ]);
}

/// NOT_READY: the planner piece, or the planner week, does not exist yet.
final class ContestNotReady extends ContestRefusal {
  const ContestNotReady([super.message = 'Create it in the planner first.']);
}

/// NOT_OPEN: the comment level was not opened (or could not be written)
/// today, so there is nothing to submit to.
final class ContestNotOpen extends ContestRefusal {
  const ContestNotOpen([super.message = 'Open today’s comment level first.']);
}

/// ALREADY_DONE: done, approved, or all five already in.
final class ContestAlreadyDone extends ContestRefusal {
  const ContestAlreadyDone([super.message = 'That one is already done.']);
}

/// DUPLICATE_URL: the link was already sent or claimed.
final class ContestDuplicateUrl extends ContestRefusal {
  const ContestDuplicateUrl([
    super.message = 'That link has already been claimed.',
  ]);
}

/// BAD_URL: the link fails the URL rule.
final class ContestBadUrl extends ContestRefusal {
  const ContestBadUrl([
    super.message = 'That is not a link to a LinkedIn post.',
  ]);
}

/// INVALID_LINKEDIN_URL: the "Feature me" card's link is not a public
/// LinkedIn profile (`https://www.linkedin.com/in/<slug>`). Shown beside the
/// field.
final class ContestBadProfileLink extends ContestRefusal {
  const ContestBadProfileLink([
    super.message =
        'Paste the link to your public LinkedIn profile, like '
        'https://www.linkedin.com/in/your-name.',
  ]);
}

/// ADULT_REQUIRED: being featured needs "I am 18 or older" on record — the
/// "Feature me" card asks for the tick and sends it with the link.
final class ContestAdultRequired extends ContestRefusal {
  const ContestAdultRequired([
    super.message = 'Confirm that you are 18 or older to be featured.',
  ]);
}

/// REVOKED: the day or the week was audited and found false. Final.
final class ContestRevoked extends ContestRefusal {
  const ContestRevoked([
    super.message = 'This was removed after review, so nothing more counts.',
  ]);
}

/// CONFLICT: lost a race with another request. Re-read and try again.
final class ContestConflict extends ContestRefusal {
  const ContestConflict([
    super.message =
        'Something changed at the same moment. Reload and try again.',
  ]);
}

/// TOO_LARGE: the screenshot is over 8 MB.
final class ContestTooLarge extends ContestRefusal {
  const ContestTooLarge([super.message = 'That screenshot is over 8 MB.']);
}

/// INVALID_IMAGE: not an image, or not one the server can read.
final class ContestInvalidImage extends ContestRefusal {
  const ContestInvalidImage([
    super.message = 'The screenshot must be an image.',
  ]);
}

/// STORAGE_UNAVAILABLE: the private proof store is not set up, or the upload
/// failed. Retryable, and not the user's fault.
final class ContestStorageUnavailable extends ContestRefusal {
  const ContestStorageUnavailable([
    super.message =
        'The screenshot could not be stored just now. Try again in a moment.',
  ]);
}

/// VALIDATION_FAILED: the request was malformed — "Pick one of the options.",
/// "Fill all 4 blanks.", "Paste the link to your comment." The server's
/// sentence is the whole point, so it is always shown.
final class ContestInvalid extends ContestRefusal {
  const ContestInvalid([
    super.message = 'That was not accepted. Check it and try again.',
  ]);
}

/// PROFILE_INCOMPLETE on the connect level's targets: no usable profession
/// to aim them at. The remedy is the profile, not a retry.
final class ContestProfileIncomplete extends ContestRefusal {
  const ContestProfileIncomplete([
    super.message = 'Add your profession to your profile first.',
  ]);
}

/// The plan said no — the connect level's targets on a day the contest does
/// not lift the plan gate. Shown with `PlanLimitSheet`, never with a retry.
final class ContestPlanRefused extends ContestRefusal {
  ContestPlanRefused(this.refusal) : super(refusal.displayMessage());

  final PlanRefusal refusal;
}

/// Anything the contest's own vocabulary does not cover: no connection, a
/// timeout, a 500. [message] is already the sentence for it.
final class ContestUnavailable extends ContestRefusal {
  const ContestUnavailable([
    super.message = 'That did not come through. Try again.',
  ]);
}

/// One sentence for anything a contest call can throw.
///
/// The UI never renders an exception's `toString()`. A [ContestRefusal]
/// carries its sentence; anything else — a parse error, a bug — gets the
/// one generic line rather than a stack-trace fragment.
String contestMessage(Object error) => switch (error) {
  ContestRefusal(:final String message) => message,
  _ => 'That did not come through. Try again.',
};
