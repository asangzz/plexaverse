import 'dart:async';

import 'package:flutter/widgets.dart'
    show AppLifecycleState, WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/calendar_repositories.dart';
import '../domain/calendar_month.dart';
import '../domain/calendar_post.dart';

part 'calendar_controller.g.dart';

/// How often the calendar re-reads itself.
///
/// The web sets `refetchInterval: 60_000` on `useCalendarPosts` for a concrete
/// reason: a post published by Cloud Tasks changes status on the SERVER with no
/// client involvement, so without a poll the grid keeps showing "Scheduled" for
/// something that went out an hour ago.
const Duration kCalendarPollInterval = Duration(minutes: 1);

/// The calendar's posts, already split into the grid bucket and the pending
/// backlog.
///
/// ## Why the split happens here and not on the server
///
/// The web's `/api/calendar/posts` returns `{scheduled, pending}` ready-made.
/// The mobile API has no such route — only `GET /posts` — so this controller
/// fetches the flat list and applies the server's own bucketing rule through
/// `splitCalendarBuckets`. The rule lives in the domain layer precisely so it
/// can be checked against `lib/services/calendar.service.ts` without reading a
/// widget.
@riverpod
class CalendarController extends _$CalendarController {
  @override
  Future<CalendarBuckets> build() async {
    // Registered BEFORE the first await so the timer is always torn down with
    // the provider, including when build itself throws.
    final Timer timer = Timer.periodic(kCalendarPollInterval, (Timer _) {
      // The web pairs its interval with `refetchIntervalInBackground: false`.
      // The phone's equivalent of a hidden tab is a backgrounded app, and
      // polling there spends the user's battery and mobile data on a screen
      // nobody is looking at.
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        ref.invalidateSelf();
      }
    });
    ref.onDispose(timer.cancel);

    final List<CalendarPost> posts = await ref
        .watch(calendarRepositoryProvider)
        .fetchPosts();
    return splitCalendarBuckets(posts);
  }

  /// Moves [postId] to [when] and re-reads.
  ///
  /// Deliberately NOT optimistic. Scheduling is the one action on this screen
  /// whose server side does real work — it re-queues the Cloud Task, rewrites
  /// the Google Calendar event and detaches the post from its planner slot — so
  /// a local guess at the result can be wrong in ways the user would only find
  /// out about when the post failed to go out. The caller shows a busy state
  /// for the round-trip instead.
  Future<void> reschedule({
    required String postId,
    required DateTime when,
  }) async {
    await ref
        .read(calendarRepositoryProvider)
        .reschedulePost(postId: postId, scheduledFor: when);
    ref.invalidateSelf();
    await future;
  }
}
