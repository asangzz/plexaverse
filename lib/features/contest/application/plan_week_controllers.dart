import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contest_repositories.dart';
import '../domain/contest_repository.dart';
import 'contest_controllers.dart';

part 'plan_week_controllers.g.dart';

// Sunday's level: plan THIS week. A port of the web's
// `components/contest/tasks/WeekPlanGuide.tsx`.
//
// Sunday is the week's first day, so the week it plans is the one it starts.
// It asks for no links: it shows the week as the Planner has it, day by day,
// with what to get ready, and for each piece the learner posts by hand the
// date the path will ask for its link — that day's own level. Every word of
// the day list is the server's (`PlanWeekDay.status`, `.instruction`), read
// off the planner's own data; nothing here knows which weekday does what.
//
// "I've planned this week" pays nothing and is refused until the week exists
// in the Planner — the button says so rather than failing.

/// Under a disabled "I've planned this week". The web's `NO_PLAN_LINE`, and
/// the server's NOT_READY sentence.
const String kNoPlanLine = 'Generate this week in the Planner first.';

/// `GET /contest/tasks/plan` — this planner week, day by day.
///
/// Always a view, even with no contest: why the level is unavailable or
/// locked rides on it. Re-read on every open (auto-dispose), as the web's
/// `refetchOnMount` — the learner goes to the Planner and comes back
/// expecting what they just did there.
@riverpod
Future<PlanWeekView> contestPlanWeek(Ref ref) =>
    ref.watch(contestRepositoryProvider).fetchPlanWeek();

/// Where marking the week stands.
class PlanWeekMark {
  const PlanWeekMark({
    this.busy = false,
    this.done = false,
    this.error,
    this.locked = false,
  });

  final bool busy;

  /// Marked from this screen. The level shows done at once, before the
  /// re-read view says so itself.
  final bool done;

  /// The server's refusal, in its own words.
  final String? error;

  /// The refusal was the gate (409 LOCKED): the sentence comes with the way
  /// back to the path, where the earlier level is.
  final bool locked;
}

/// `POST /contest/tasks/plan` — "I've planned this week".
@riverpod
class PlanWeekActions extends _$PlanWeekActions {
  @override
  PlanWeekMark build() => const PlanWeekMark();

  Future<void> complete() async {
    if (state.busy || state.done) return;
    state = const PlanWeekMark(busy: true);
    try {
      await ref.read(contestRepositoryProvider).completePlanWeek();
      if (!ref.mounted) return;
      state = const PlanWeekMark(done: true);
      ref.invalidate(contestPlanWeekProvider);
      refreshContestStanding(ref.invalidate);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = PlanWeekMark(
        error: contestMessage(e),
        locked: e is ContestLocked,
      );
      // The server answered: the week may have moved under the page (marked
      // elsewhere, the day turned, the plan just generated). A failure that
      // never reached it changed nothing, and a re-read would only fail
      // again in place of the view the learner is reading.
      if (e is ContestRefusal && e is! ContestUnavailable) {
        ref.invalidate(contestPlanWeekProvider);
      }
    }
  }
}
