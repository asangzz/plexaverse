import 'calendar_month.dart';
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
///   • **`GET /calendar` returns the buckets already split.** It wraps the
///     same `getCalendarBuckets` the web calls, so the date windowing, the
///     per-status caps, the 280-char content trim and the `data:`-thumbnail
///     guard are one implementation rather than two. Mobile used to read
///     `GET /posts?limit=100` and bucket on the client, which meant carrying
///     `imageUrl` — 252 KB a row on the live table — for a screen that draws
///     no images at all.
///   • **There is no per-post "schedule" route.** Moving a post to a day is a
///     `PATCH /posts/{id}` that sets `scheduledFor` + `status`; the server's
///     `updateUserPost` then re-queues the Cloud Task, re-syncs the Google
///     Calendar event and detaches the post from its planner slot. That whole
///     chain is why the client must not try to "also" write a schedule row.
abstract class CalendarRepository {
  /// The calendar's two buckets for the window [from]..[to].
  ///
  /// Both default server-side (today − 7d to today + 60d) and the server
  /// refuses a window wider than 400 days — the per-status caps bound the
  /// rows, not the scan.
  Future<CalendarBuckets> fetchBuckets({DateTime? from, DateTime? to});

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
