/// The placement test's sentences that depend on the numbers, ported from the
/// web's `components/placement/*` so both platforms say the same thing.
///
/// Pure: every clock reading is passed in, so a test can stand anywhere in an
/// attempt's life. Nothing here takes an item and an answer — there is
/// nowhere a correctness check could be bolted on.
library;

import 'package:intl/intl.dart';

import 'cefr_band.dart';
import 'placement_models.dart';

/// An open attempt closes this long after its last answer (or its start)
/// — `INACTIVITY_CLOSE_HOURS` in the web's `lib/placement/engine.ts`.
const int inactivityCloseHours = 24;

/// ... and never later than this long after its start (`MAX_ATTEMPT_HOURS`).
const int maxAttemptHours = 48;

/// A completed test can be retaken this long after it was set
/// (`RETAKE_COOLDOWN_DAYS`).
const int retakeCooldownDays = 30;

/// Inside this many hours of the close, the question screen names the time
/// instead of the rules.
const int soonHours = 2;

/// A span of hours in words: "24 hours", "2 days". Fed the engine's numbers,
/// so the copy moves when they do.
String spanWords(int hours) =>
    hours > 24 && hours % 24 == 0 ? '${hours ~/ 24} days' : '$hours hours';

/// What walking away does to a level. It can never leave a learner better off
/// than never having started, so it can lower a level and never raise it.
const String unfinishedRule =
    'An unfinished test can lower your level, never raise it.';

/// A part a closed test never got far enough to score. "Not tested" rather
/// than "not reached": the learner may have answered a question or two in it.
const String notTestedLabel = 'Not tested';

/// Under the tiles of a result that closed on a walk-away.
const String closedEarlyLine =
    'This test closed before it finished. A part marked not tested had too '
    'few answers to score, and an unfinished test can lower your level, never '
    'raise it.';

/// The attempt on screen closed with answers in it, and is now the latest
/// result with `closedEarly` set.
const String closedNotice = 'That test has closed. Your result is below.';

/// The attempt on screen is the latest result but did NOT close early: it was
/// finished — all three parts — somewhere else. Telling that learner their
/// test was cut short would be false.
const String finishedElsewhereNotice =
    'That test was finished. Your result is below.';

const String answerNotSavedNotice = 'That answer was not saved.';

/// Above the first question, when Continue found the offered test closed and
/// began a new one.
const String newAttemptNotice = 'Your earlier test closed. This is a new one.';

/// An answer refused as NOT_FOUND, and the re-read shows that attempt neither
/// open nor the latest result: nothing in it was answered in time.
const String clearedNotice =
    'Nothing was answered in time, so that test was cleared. You can start '
    'again.';

/// Writing refused as already complete, and the re-read shows it is in.
const String writingInNotice = 'Your writing is already in.';

/// Writing refused as already complete, and the result it was for no longer
/// takes any (a newer result replaced it).
const String writingClosedNotice =
    'Writing can no longer be added to that result.';

/// What became of [attemptId], read off a status taken after it moved on:
/// closed early on what it held, or finished somewhere else. Null when it is
/// not the latest result — cleared with nothing answered, still open, or the
/// read failed — and then no level is claimed for it.
String? endedNotice(String? attemptId, PlacementStatus? fresh) {
  final PlacementSummary? latest = fresh?.latest;
  if (attemptId == null || latest == null || latest.attemptId != attemptId) {
    return null;
  }
  return latest.closedEarly ? closedNotice : finishedElsewhereNotice;
}

/// What the band changes, said so it stays true: a lesson snapshots its band
/// when it is first opened and is never rebuilt, so "your lessons are now at
/// B1" would be false for one already open.
String newLessonsLine(CefrBand band) =>
    'New lessons are written at ${band.wire}. A lesson you have already '
    'opened keeps its level.';

/// When the test can be taken again, counted from when THIS result was set —
/// writing can be added to a result days later, and "in 30 days" on that
/// screen would name a date that is not the real one.
String retakeLine(DateTime? completedAt, {required DateTime now}) {
  if (completedAt == null) {
    return 'You can retake the test $retakeCooldownDays days after you took '
        'it.';
  }
  final DateTime at = completedAt.add(const Duration(days: retakeCooldownDays));
  return at.isAfter(now)
      ? 'You can retake the test on ${longDate(at)}.'
      : 'You can retake the test now.';
}

/// The intro's line under "Pick up where you left off": when the open attempt
/// closes, and what that does. With nothing answered, closing CLEARS the
/// attempt — "closes with what you have answered" would promise a result that
/// is never made.
String closesLine({required DateTime? closesAt, required int answered}) {
  final String when = closesAt == null ? '' : dateTime(closesAt);
  final String idle = spanWords(inactivityCloseHours);
  if (answered == 0) {
    return when.isNotEmpty
        ? 'Continue by $when. After that, this test is cleared and you can '
              'start again.'
        : 'Nothing is answered yet. If you leave it for $idle, this test is '
              'cleared and you can start again.';
  }
  return when.isNotEmpty
      ? 'Continue by $when. After that, the test closes with what you have '
            'answered. $unfinishedRule'
      : 'Leave it for $idle, or take more than ${spanWords(maxAttemptHours)} '
            'in all, and the test closes with what you have answered. '
            '$unfinishedRule';
}

/// The question screen's line under Next.
///
/// The rules while the close is far off; the time to answer by once it is
/// within [soonHours]; and, past it by THIS device's clock, that the time may
/// have run out — but Next stays live. The deadline is the server's: a clock
/// that runs fast would otherwise freeze a learner out of answers the server
/// still takes, and an answer sent too late is simply refused.
String leaveLine({
  required DateTime? closesAt,
  required int answered,
  required DateTime now,
}) {
  final bool unanswered = answered == 0;
  if (closesAt != null && !closesAt.isAfter(now)) {
    return 'The time for this test may have run out. Press Next and we will '
        'check.';
  }
  final bool soon =
      closesAt != null &&
      closesAt.difference(now) <= const Duration(hours: soonHours);
  if (soon) {
    final String when = timeOfDay(closesAt);
    return unanswered
        ? 'Answer by $when, or this test is cleared.'
        : 'Answer by $when, or the test closes with what you have answered.';
  }
  return unanswered
      ? 'Leave it for ${spanWords(inactivityCloseHours)} and this test is '
            'cleared.'
      : 'Your answers save as you go. Leave it for '
            '${spanWords(inactivityCloseHours)}, or take more than '
            '${spanWords(maxAttemptHours)} in all, and it closes with what you '
            'have answered.';
}

/// The moments [leaveLine]'s wording changes at, after [now]: the start of
/// the "soon" window and the close itself. The question screen wakes at each.
List<DateTime> leaveLineTurns(DateTime? closesAt, DateTime now) => <DateTime>[
  if (closesAt != null) ...<DateTime>[
    closesAt.subtract(const Duration(hours: soonHours)),
    closesAt,
  ],
].where((DateTime at) => at.isAfter(now)).toList(growable: false);

/// The bar fills toward the estimate and stops short of it. The total is an
/// estimate — the staircase decides when a part is done — so a full bar with
/// questions still coming would be a small lie. The last answer carries the
/// learner to the result instead.
double progressOf(int answered, int estimatedTotal) {
  if (estimatedTotal <= 0) return 0;
  return (answered / estimatedTotal).clamp(0, 0.95).toDouble();
}

/// "Question 7 of about 24", or just "Question 27" once past the estimate.
String questionCount(int answered, int estimatedTotal) {
  final int n = answered + 1;
  return n <= estimatedTotal
      ? 'Question ${_count(n)} of about ${_count(estimatedTotal)}'
      : 'Question ${_count(n)}';
}

/// "3 questions answered. Your answers are saved."
String answeredLine(int answered) => answered > 0
    ? '${_count(answered)} ${answered == 1 ? 'question' : 'questions'} '
          'answered. Your answers are saved.'
    : 'No questions answered yet.';

/// "12 December 2026", in the device's locale and zone.
String longDate(DateTime at) => DateFormat.yMMMMd().format(at.toLocal());

/// "Sunday, November 8 at 10:00 AM" — a moment within a day or two of now,
/// in the device's own locale and zone, so no year.
String dateTime(DateTime at) {
  final DateTime local = at.toLocal();
  return '${DateFormat.MMMMEEEEd().format(local)} at '
      '${DateFormat.jm().format(local)}';
}

/// "10:40 PM" — for a moment within the next couple of hours, where a weekday
/// and a date would be noise.
String timeOfDay(DateTime at) => DateFormat.jm().format(at.toLocal());

String _count(int n) => NumberFormat.decimalPattern().format(n);
