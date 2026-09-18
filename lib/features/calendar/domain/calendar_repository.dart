import 'calendar_post.dart';
import 'post_schedule.dart';

/// The seam between the Calendar / Schedules screens and the backend.
///
/// Resolved mock-or-real by `calendarRepositoryProvider` on `useFakeBackend`,
/// exactly as the planner and posts slices do.
///
/// ## Everything here maps to a route that exists
///
/// Every method below is backed by a constant in `ApiPaths`, which is in turn
/// backed by a `route.ts` under `app/api/mobile/v1/`. Two consequences worth
/// knowing before you extend this:
///
///   • **There is no `/calendar/posts`.** The web's calendar calls a
///     purpose-built endpoint that returns pre-bucketed, date-ranged, trimmed
///     posts. Mobile has only `GET /posts` (status / cursor / limit — no date
///     range), so [fetchPosts] pulls a page and `splitCalendarBuckets` does the
///     bucketing on the client.
///   • **There is no per-post "schedule" route.** Moving a post to a day is a
///     `PATCH /posts/{id}` that sets `scheduledFor` + `status`; the server's
///     `updateUserPost` then re-queues the Cloud Task, re-syncs the Google
///     Calendar event and detaches the post from its planner slot. That whole
///     chain is why the client must not try to "also" write a schedule row.
abstract class CalendarRepository {
  /// The posts the calendar draws from, newest first.
  ///
  /// [limit] is capped server-side at 100. Because there is no date filter,
  /// paging back far enough to cover an arbitrary month is not possible in one
  /// call — see the note above.
  Future<List<CalendarPost>> fetchPosts({int limit});

  /// Moves a post to [scheduledFor] and puts it in the `scheduled` state.
  ///
  /// [accountId] is sent only when the post has no account yet; the server
  /// otherwise picks one itself when a post is scheduled without one.
  Future<CalendarPost> reschedulePost({
    required String postId,
    required DateTime scheduledFor,
    String? accountId,
  });

  /// The recurring auto-post schedules.
  Future<List<PostSchedule>> fetchSchedules();

  Future<PostSchedule> createSchedule({
    required String linkedinAccountId,
    required List<int> dayOfWeek,
    required String timeOfDay,
    required String timezone,
    String? topicId,
  });

  /// Partial update — send only what changed. Used for the pause/resume toggle
  /// and for editing days or time.
  Future<PostSchedule> updateSchedule({
    required String id,
    bool? isActive,
    List<int>? dayOfWeek,
    String? timeOfDay,
    String? topicId,
  });

  Future<void> deleteSchedule(String id);

  /// The connected LinkedIn accounts, for the create-schedule form.
  Future<List<CalendarAccount>> fetchAccounts();

  /// The user's topics, for the create-schedule form.
  Future<List<ScheduleTopic>> fetchTopics();
}
