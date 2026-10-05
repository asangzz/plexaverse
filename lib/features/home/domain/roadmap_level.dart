/// The 66-day roadmap: its days, its tasks, and how progress is applied to it.
///
/// A direct port of the web's `lib/roadmap-data.ts` (`getBaseRoadmap`) plus the
/// progress-application pass that lives inside `GamifiedRoadmap.tsx`. The two
/// are fused into [buildRoadmap] here because nothing in this app ever wants
/// the base roadmap on its own.
///
/// **The roadmap is synthetic.** All 66 days always exist; the server sends
/// only which day it is and which steps are done. That is why this screen has
/// no empty state — there is no such thing as "no roadmap".
library;

import 'package:intl/intl.dart';

import '../../../core/week/week_shape.dart';
import 'roadmap_planets.dart';
import 'roadmap_progress.dart';

/// Where a day stands.
///
/// Derived exactly as the web derives it, including the part that surprises
/// people: a day that is unlocked, not finished and not today is **missed**,
/// not "pending". The roadmap is a streak, and it says so.
enum LevelStatus { completed, active, missed, locked }

/// One task on one day.
class RoadmapStep {
  const RoadmapStep({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.moduleLink,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isPending = false,
    this.isUpcoming = false,
  });

  /// 1..5. Half of the composite completion key `'<levelId>-<stepId>'`.
  final int id;

  /// The stable identifier LOGIC keys on. [title] is display copy and is
  /// rewritten at runtime (see the publish-post overrides in [buildRoadmap]);
  /// keying anything on it would break the moment the copy changed.
  final String key;

  final String title;
  final String description;
  final int xpReward;

  /// A web-identical route path (the same strings `ZaveRoutes` carries). The
  /// whole point of the shared route table is that this string resolves to the
  /// same screen on both platforms.
  final String moduleLink;

  final bool isCompleted;

  /// Today's day, not yet done. Renders as IN PROGRESS.
  final bool isCurrent;

  /// A day already past, not done. Renders as MISSED.
  final bool isPending;

  /// A day still ahead. Renders as UPCOMING.
  final bool isUpcoming;

  RoadmapStep copyWith({
    String? title,
    String? description,
    String? moduleLink,
    bool? isCompleted,
    bool? isCurrent,
    bool? isPending,
    bool? isUpcoming,
  }) => RoadmapStep(
    id: id,
    key: key,
    title: title ?? this.title,
    description: description ?? this.description,
    xpReward: xpReward,
    moduleLink: moduleLink ?? this.moduleLink,
    isCompleted: isCompleted ?? this.isCompleted,
    isCurrent: isCurrent ?? this.isCurrent,
    isPending: isPending ?? this.isPending,
    isUpcoming: isUpcoming ?? this.isUpcoming,
  );
}

/// One day of the 66.
class RoadmapLevel {
  const RoadmapLevel({
    required this.id,
    required this.subtitle,
    required this.isUnlocked,
    required this.steps,
  });

  /// The day number, 1..66.
  final int id;

  /// The plain-English progression label under the day ("Finding your voice").
  final String subtitle;

  final bool isUnlocked;
  final List<RoadmapStep> steps;

  /// The web's `getLevelStatus`, unchanged.
  LevelStatus get status {
    if (!isUnlocked) return LevelStatus.locked;
    if (steps.isNotEmpty && steps.every((RoadmapStep s) => s.isCompleted)) {
      return LevelStatus.completed;
    }
    if (steps.any((RoadmapStep s) => s.isCurrent)) return LevelStatus.active;
    return LevelStatus.missed;
  }

  int get doneCount => steps.where((RoadmapStep s) => s.isCompleted).length;

  /// `levelCompletion` — rounded percentage, 0 when the day has no tasks.
  int get completionPercent {
    if (steps.isEmpty) return 0;
    return (doneCount / steps.length * 100).round();
  }
}

// ── Copy tables, ported verbatim ────────────────────────────────────────────

/// `ROADMAP_LEVEL_NAMES` — one label per day for days 1–65. Day 66 is
/// "You did it!". The list is CLAMPED, never wrapped, so a user's label can
/// never appear to reset to "Getting started" halfway through the journey.
const List<String> roadmapLevelNames = <String>[
  'Getting started',
  'Building momentum',
  'Finding your voice',
  'Growing your network',
  'Creating content',
  'Boosting engagement',
  'Sharing expertise',
  'Representing your brand',
  'Building influence',
  'Becoming trusted',
  'Trusted expert',
  'Setting trends',
  'Building community',
  'Collaborating widely',
  'Leading with new ideas',
  'Reaching more people',
  'LinkedIn expert',
  'Confident poster',
  'Steady growth',
  'Making a difference',
  'Strong connector',
  'Consistent creator',
  'Highly engaged',
  'Trusted influencer',
  'Finding your rhythm',
  'Building the habit',
  'Showing up daily',
  'Growing steadily',
  'Expanding your reach',
  'Wider audience',
  'Getting recognized',
  'A familiar name',
  'Building authority',
  'Respected voice',
  'Go-to expert',
  'Thought partner',
  'Sparking discussion',
  'Fresh perspectives',
  'Inspiring others',
  'Bringing people together',
  'Well connected',
  'Trusted connector',
  'Real impact',
  'Mentor to many',
  'Active leader',
  'Standout creator',
  'Top of the feed',
  'Sought-after voice',
  'Industry regular',
  'Recognized authority',
  'Established expert',
  'Community leader',
  'Field leader',
  'Influential voice',
  'Master creator',
  'LinkedIn leader',
  'LinkedIn authority',
  'Trusted advisor',
  'Proven expert',
  'Category leader',
  'Standout brand',
  'Powerful presence',
  'Lasting influence',
  'Legacy builder',
  'Icon status',
];

/// The day-1..4 profile-setup extras, personal brand. Appended as step 4.
const List<_ExtraTask> _extraPersonalTasks = <_ExtraTask>[
  _ExtraTask(
    key: 'profile-title',
    title: 'Write your profile title',
    description: 'Create a clear, professional title for your profile',
    link: '/title-creator',
  ),
  _ExtraTask(
    key: 'banner',
    title: 'Design your banner',
    description: 'Create a custom banner image for your profile',
    link: '/roadmap/banner-blueprint',
  ),
  _ExtraTask(
    key: 'headline',
    title: 'Update your headline',
    description:
        'Improve your headline, tidy your profile URL, and add a Featured '
        'section',
    link: '/roadmap/headline-hook',
  ),
  _ExtraTask(
    key: 'about',
    title: 'Write your About section',
    description:
        'Write a 3-paragraph About section about the problem you solve',
    link: '/roadmap/about-odyssey',
  ),
];

/// The company-brand extras — only two, and deliberately so: Template Creator
/// is hidden from the company nav in v1, so there is no banner task to
/// deep-link into, and the "reply to page comments" action already recurs as
/// the daily step.
const List<_ExtraTask> _extraCompanyTasks = <_ExtraTask>[
  _ExtraTask(
    key: 'about',
    title: 'Write your About Us',
    description: 'Write a clear About section focused on your mission',
    link: '/roadmap/about-odyssey',
  ),
  _ExtraTask(
    key: 'page-growth',
    title: 'Check your page growth',
    description: 'Review your Company Page analytics and follower growth',
    link: '/company-analytics',
  ),
];

class _ExtraTask {
  const _ExtraTask({
    required this.key,
    required this.title,
    required this.description,
    required this.link,
  });

  final String key;
  final String title;
  final String description;
  final String link;
}

/// The Sunday-only fifth task.
///
/// It is a TASK and not a notification because LinkedIn shares no analytics for
/// personal profiles with any app, so the numbers can only come from the user —
/// and a nudge in a tray gets ignored, leaving the season's only metric empty.
/// It is id **5**, not 4, so it cannot collide with the profile extras on a day
/// 1–4 that happens to fall on a Sunday.
const int weeklyReachStepId = 5;

/// Before this day a new user has barely posted and has nothing to report.
const int _firstReachDay = 7;

/// Does roadmap day [day] fall on a Sunday?
///
/// Calendar arithmetic off the start date, matching the web's `setDate`. A user
/// near midnight in an unusual timezone may see the task a day either side;
/// for a weekly ritual that is not worth a timezone dependency.
bool _isSunday(int day, DateTime startedAt) =>
    DateTime(
      startedAt.year,
      startedAt.month,
      startedAt.day + (day - 1),
    ).weekday ==
    DateTime.sunday;

/// Mon = 0 … Sun = 6 — the Content Planner's slot index.
///
/// The web computes this from JS's Sunday-is-0 week; Dart's
/// [DateTime.weekday] is Monday-is-1, so the conversion is a plain subtraction
/// and lands on exactly the same index.
int plannerSlotForToday([DateTime? now]) => (now ?? DateTime.now()).weekday - 1;

/// Builds the 66 days with [progress] applied.
///
/// Order of operations matters and is the web's: the base roadmap is built for
/// the brand type FIRST (which decides whether step 3 exists at all and which
/// extras land on days 1–4), then progress is folded over it in one forward
/// pass that carries `allDoneSoFar` — that carry is what unlocks a day the
/// user has run ahead to.
/// How far back the roadmap is built from today. Mirrors `DAYS_BEHIND`.
const int roadmapDaysBehind = 13;

/// How far forward. Mirrors `DAYS_AHEAD`.
const int roadmapDaysAhead = 7;

/// First day the roadmap builds, clamped to the start of the arc.
int _windowStart(int today) {
  final int from = today - roadmapDaysBehind;
  return from < 1 ? 1 : from;
}

/// Last day the roadmap builds, clamped to the end of the arc.
int _windowEnd(int today) {
  final int to = today + roadmapDaysAhead;
  return to > roadmapTotalDays ? roadmapTotalDays : to;
}

List<RoadmapLevel> buildRoadmap(RoadmapProgress progress, {DateTime? now}) {
  final bool isCompany = progress.isCompany;
  final DateTime today = now ?? DateTime.now();

  // Company pages get real analytics from LinkedIn's API, so asking a company
  // to transcribe its own numbers by hand would be busywork — no Sunday task.
  final DateTime? reachAnchor = isCompany ? null : progress.roadmapStartedAt;

  final List<_ExtraTask> extras = isCompany
      ? _extraCompanyTasks
      : _extraPersonalTasks;

  // Company brand publishes to the Page, personal to the personal feed.
  final String postCreateRoute = isCompany ? '/company-post' : '/create';

  final int slotToday = plannerSlotForToday(today);
  final String scheduledWhen = progress.scheduledPostAt == null
      ? ''
      : DateFormat('EEE, h:mm a').format(progress.scheduledPostAt!.toLocal());

  final List<RoadmapLevel> levels = <RoadmapLevel>[];
  // Days before the window are behind the user and necessarily "done so far"
  // as far as unlocking is concerned — the window always starts at or before
  // today, so nothing it skips is a future day that could still be locked.
  bool allDoneSoFar = true;

  // A WINDOW, not the whole arc.
  //
  // This loop ran to `roadmapTotalDays`, which was 66. It is a thousand now,
  // and building every day eagerly means a thousand RoadmapLevels of three to
  // five steps each — several thousand objects rebuilt on every progress
  // change, for a screen that shows about twenty rows.
  //
  // The web windows the same list to today − 13 … today + 7
  // (`DAYS_BEHIND` / `DAYS_AHEAD` in GamifiedRoadmap.tsx) and this matches it.
  // Thirteen behind is what makes the catch-up stretch reachable without
  // scrolling a year; seven ahead is one planning week.
  final int from = _windowStart(progress.currentDay);
  final int to = _windowEnd(progress.currentDay);

  for (int day = from; day <= to; day++) {
    final bool isToday = progress.currentDay == day;
    final bool isPast = progress.currentDay > day;
    final bool isUnlocked = day == 1 || isToday || isPast || allDoneSoFar;

    // Does this day produce a post at all?
    //
    // Five of seven days no longer do: Wednesday and Friday are video scripts,
    // Thursday is the newsletter, and the weekend is off. Asking for a post on
    // those days is asking for something the plan does not contain — the
    // planner has no slot to generate and the publish chain has nothing to
    // send, so the mission could only ever sit there unfinished.
    //
    // Without a start date the weekday is unknowable, so the step stays. That
    // is what every caller wanting only a step's copy or route gets today, and
    // it is the safe direction to be wrong in. The web reasons identically
    // (`dayPosts` in lib/roadmap-data.ts).
    final DateTime? startedAt = progress.roadmapStartedAt;
    final bool dayPosts =
        startedAt == null ||
        dayKindAt(weekdayIndexForDay(day, startedAt)) == DayKind.post;

    final List<RoadmapStep> steps = <RoadmapStep>[
      if (dayPosts)
        RoadmapStep(
          id: 1,
          key: 'publish-post',
          title: 'Publish a post',
          description: 'Write and publish a post to grow your authority.',
          xpReward: 100,
          moduleLink: postCreateRoute,
        ),
      RoadmapStep(
        id: 2,
        key: 'comment',
        title: isCompany ? 'Reply to page comments' : 'Comment on posts',
        description: isCompany
            ? 'Reply to comments coming into your Company Page inbox.'
            : 'Leave helpful comments on recent posts to get noticed.',
        xpReward: 50,
        moduleLink: isCompany ? '/company-auto-comment' : '/comments',
      ),
      // A Company Page cannot send connection requests, so step 3 is dropped
      // for company entirely — its daily routine is publish + reply.
      if (!isCompany)
        const RoadmapStep(
          id: 3,
          key: 'connect',
          title: 'Send connection requests',
          description: 'Send connection requests to grow your network.',
          xpReward: 50,
          moduleLink: '/connections',
        ),
      if (day - 1 < extras.length)
        RoadmapStep(
          id: 4,
          key: extras[day - 1].key,
          title: extras[day - 1].title,
          description: extras[day - 1].description,
          xpReward: 100,
          moduleLink: extras[day - 1].link,
        ),
      if (reachAnchor != null &&
          day >= _firstReachDay &&
          _isSunday(day, reachAnchor))
        const RoadmapStep(
          id: weeklyReachStepId,
          key: 'weekly-reach',
          title: "Log this week's reach",
          description:
              'Download your LinkedIn analytics (one button, top right) and '
              'upload it — Plexa reads the rest.',
          xpReward: 100,
          moduleLink: '/persona?focus=reach',
        ),
    ];

    bool levelFullyDone = true;
    final List<RoadmapStep> applied = steps
        .map((RoadmapStep step) {
          final bool isCompleted = progress.isStepDone(day, step.id);
          if (!isCompleted) levelFullyDone = false;

          String title = step.title;
          String description = step.description;
          String moduleLink = step.moduleLink;

          if (step.key == 'publish-post') {
            // The daily post is managed in the Content Planner now, so this task
            // ALWAYS routes there — never to the from-scratch compose screen, and
            // this holds even once the task is done.
            moduleLink = '/planner?slot=$slotToday';

            if (!isCompleted) {
              if (progress.pendingPostIdToday != null) {
                // A post is awaiting approval. The task is NOT done until the user
                // approves it, so the copy asks for exactly that.
                title = '✅ Approve Your Daily Post';
                description =
                    'Your AI-crafted post is ready for review. Approve it in the '
                    'Content Planner.';
              } else if (progress.scheduledPostId != null) {
                title = '🗓️ Your Next Post Is Scheduled';
                description = scheduledWhen.isEmpty
                    ? 'Your AI-crafted post is approved and scheduled to publish. '
                          'Tap to review or edit it.'
                    : 'Your AI-crafted post is approved and scheduled for '
                          '$scheduledWhen. Tap to review or edit it.';
              } else {
                // Nothing pending or scheduled — the auto-post did not run.
                // Prompt a manual generate on TOMORROW's slot.
                title = "📝 Generate tomorrow's post";
                description =
                    'No post lined up for tomorrow yet. Generate it now — the '
                    "Content Planner opens right on tomorrow's slot.";
                moduleLink = '/planner?slot=${(slotToday + 1) % 7}';
              }
            }
          }

          return step.copyWith(
            title: title,
            description: description,
            moduleLink: moduleLink,
            isCompleted: isCompleted,
            // Every step of today's day counts as "current" until it is done.
            isCurrent: isToday && !isCompleted,
            isPending: !isCompleted && isPast,
            isUpcoming: day > progress.currentDay,
          );
        })
        .toList(growable: false);

    if (!levelFullyDone) allDoneSoFar = false;

    levels.add(
      RoadmapLevel(
        id: day,
        subtitle: day == roadmapTotalDays
            ? 'You did it!'
            : roadmapLevelNames[day - 1 < roadmapLevelNames.length
                  ? day - 1
                  : roadmapLevelNames.length - 1],
        isUnlocked: isUnlocked,
        steps: applied,
      ),
    );
  }

  return levels;
}

/// "Three small things." reads better than "3 small things." — the Zave voice.
String countWord(int n) => switch (n) {
  0 => 'Zero',
  1 => 'One',
  2 => 'Two',
  3 => 'Three',
  4 => 'Four',
  5 => 'Five',
  6 => 'Six',
  _ => '$n',
};
