import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/planner_controller.dart';
import '../../../posts/application/post_library_controllers.dart';
import '../../../posts/domain/library_post.dart';
import '../../domain/plan_slot.dart';
import '../../domain/video_script.dart';
import '../../domain/weekly_article.dart';
import '../widgets/article_card.dart';
import '../widgets/slot_card.dart';
import '../../domain/planner_repository.dart';

/// **Plan** — the content planner. The web's `/planner`.
///
/// A week is not seven posts that share a topic. It is **one long-form
/// newsletter on Thursday plus two posts and two video scripts that argue
/// facets of it** (CLAUDE.md §6b), and the screen is laid out to say so: the
/// article sits at the top as the week's spine, and the seven day slots —
/// including the two weekend rest days — hang off it.
///
/// The web renders the days as a seven-column grid on a wide screen and stacks
/// them below its `lg` breakpoint. A phone always gets the stacked form, which
/// is the web's own mobile rendering rather than a mobile-specific invention.
class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlannerState> planner = ref.watch(
      plannerControllerProvider,
    );
    final AsyncValue<ArticleState> article = ref.watch(
      articleControllerProvider,
    );
    final AsyncValue<List<VideoScript>> scripts = ref.watch(
      videoScriptsControllerProvider,
    );

    return ZaveScaffold(
      // No header. The body opens with its own `Week N` / `planner` lockup,
      // and a Zave screen never wears both.
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(plannerControllerProvider);
          ref.invalidate(articleControllerProvider);
          ref.invalidate(videoScriptsControllerProvider);
          await ref.read(plannerControllerProvider.future);
        },
        child: planner.when(
          loading: () => const _PlannerSkeleton(),
          error: (Object e, StackTrace _) => _PlannerError(
            onRetry: () => ref.invalidate(plannerControllerProvider),
          ),
          data: (PlannerState state) => _PlannerBody(
            state: state,
            article: article,
            scripts: scripts,
            ref: ref,
          ),
        ),
      ),
    );
  }
}

class _PlannerBody extends StatelessWidget {
  /// Two tiles across a phone, with the second ending flush rather than cut
  /// off: unlike the home strip there is no third card to hint at, so an
  /// overhang here would promise something that is not there.
  static const double _tileWidth = 164;

  /// How wide one day is in the week strip.
  ///
  /// Most of the screen, but deliberately not all of it: the sliver of the
  /// next card showing past the edge is the only thing that says the row
  /// scrolls. Capped so it does not become a single absurd card on a tablet.
  static double _dayCardWidth(BuildContext context) {
    final double usable =
        MediaQuery.sizeOf(context).width - ZaveSpace.gutter * 2;
    return math.min(usable * 0.86, 340);
  }

  const _PlannerBody({
    required this.state,
    required this.article,
    required this.scripts,
    required this.ref,
  });

  final PlannerState state;
  final AsyncValue<ArticleState> article;
  final AsyncValue<List<VideoScript>> scripts;
  final WidgetRef ref;

  /// Today's weekday name, matched against the slot's `day`.
  static String _todayName() {
    const List<String> names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[DateTime.now().weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final WeekPlan? plan = state.plan;

    if (plan == null) {
      return ZaveScrollView(
        children: <Widget>[
          _WeekHeader(state: state, plan: null),
          SizedBox(height: ZaveSpace.xl),
          _UpcomingWeek(state: state),
        ],
      );
    }

    final String today = _todayName();

    return ZaveScrollView(
      children: <Widget>[
        _WeekHeader(state: state, plan: plan),
        SizedBox(height: ZaveSpace.xl),

        // The week is a SETUP before it is a schedule.
        //
        // Three things have to exist before a week is really planned: the
        // Thursday article has to be scheduled, the two posts written, and
        // the two scripts drafted. Previously all of that was one long
        // column, so the only way to know what was still outstanding was to
        // scroll the whole week and work it out. As steps, the page says it.
        //
        // The tabs are not gated. The article is written unattended by the
        // Sunday batch, not by the user, so a week whose article generation
        // failed would lock someone out of their posts for no reason they
        // caused. Progress is reported; nothing is withheld.
        _WeekSetup(
          plan: plan,
          article: article,
          scripts: scripts,
          articleCard: article.when(
            loading: () => const _CardSkeleton(height: 180),
            error: (Object e, StackTrace _) => const SizedBox.shrink(),
            data: (ArticleState a) => ArticleCard(
              state: a,
              onOpen: () => _openArticle(context, ref, a),
              onCopy: () => _copyArticle(context, ref, a),
              onMarkPublished: () =>
                  ref.read(articleControllerProvider.notifier).markPublished(),
              onNameNewsletter: () => _nameNewsletter(context, ref, a),
              onSetReminder: () => _setReminder(context, ref, a),
            ),
          ),
          analytics: _WeekAnalytics(plan: plan, tileWidth: _tileWidth),
          dayCard: (int i) => SlotCard(
            slot: plan.posts[i],
            isToday: plan.posts[i].day == today,
            handoff: _handoffFor(plan.posts[i], i, scripts, article),
            onTap: () => _openSlot(context, plan.posts[i], i),
            // Approve is a publish action: it moves a slot to `approved` and
            // the chain ships it. A video script and the newsletter are never
            // shipped by us, so offering it there would promise something the
            // product cannot do. `needsApproval` alone used to be the gate.
            onApprove:
                plan.posts[i].isPublishable && plan.posts[i].needsApproval
                ? () => _approve(context, ref, i)
                : null,
          ),
          dayCardWidth: _dayCardWidth(context),
        ),
      ],
    );
  }

  /// Approves a slot and says what happened.
  ///
  /// Approving is the moment the user hands the post over to the publisher,
  /// so the confirmation names the time it will go out. The two quieter
  /// outcomes are stated rather than glossed: a slot whose send time has
  /// already passed is approved but NOT queued (the server refuses to
  /// back-date), and a slot with no generated post has nothing to queue at
  /// all. Both used to read as plain success.
  Future<void> _approve(BuildContext context, WidgetRef ref, int index) async {
    final ApproveResult? result = await ref
        .read(plannerControllerProvider.notifier)
        .approve(index);
    if (!context.mounted) return;

    final String message;
    if (result == null) {
      message = "That didn't go through. Try again.";
    } else if (result.scheduledFor != null) {
      message = 'Approved — publishing ${_whenLabel(result.scheduledFor!)}.';
    } else if (result.postUpdated) {
      message =
          "Approved. That slot's time has passed, so publish it "
          'yourself when you are ready.';
    } else {
      message = 'Approved. Nothing is queued yet — this day has no post.';
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
  }

  /// "today at 09:00" / "Mon at 09:00" / "12 Oct at 09:00".
  static String _whenLabel(DateTime when) {
    const List<String> days = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final DateTime now = DateTime.now();
    final String time =
        '${when.hour.toString().padLeft(2, '0')}:'
        '${when.minute.toString().padLeft(2, '0')}';
    final Duration ahead = when.difference(
      DateTime(now.year, now.month, now.day),
    );
    if (when.year == now.year &&
        when.month == now.month &&
        when.day == now.day) {
      return 'today at $time';
    }
    if (ahead.inDays < 7) return '${days[when.weekday - 1]} at $time';
    return '${when.day} ${months[when.month - 1]} at $time';
  }

  /// Where a hand-off day has actually got to.
  ///
  /// The slot cannot answer this — `status` is written only by the
  /// post-generation path, which a video or newsletter day never reaches — so
  /// it comes from the thing that really holds the state: the script row for a
  /// video day, the article row for Thursday.
  ///
  /// Null while either is still loading, which the card renders as a quiet
  /// label rather than guessing "to write" and correcting itself a beat later.
  static HandoffState? _handoffFor(
    PlanSlot slot,
    int slotIndex,
    AsyncValue<List<VideoScript>> scripts,
    AsyncValue<ArticleState> article,
  ) {
    switch (slot.kind) {
      case DayKind.videoScript:
        final List<VideoScript>? all = scripts.value;
        if (all == null) return null;
        for (final VideoScript v in all) {
          if (v.dayIndex == slotIndex) {
            return v.isPosted ? HandoffState.posted : HandoffState.ready;
          }
        }
        return HandoffState.notWritten;
      case DayKind.article:
        final ArticleState? a = article.value;
        if (a == null) return null;
        final WeeklyArticle? written = a.article;
        if (written == null) return HandoffState.notWritten;
        return written.isPublished ? HandoffState.posted : HandoffState.ready;
      case DayKind.post:
      case DayKind.rest:
        return null;
    }
  }

  /// Asks for the newsletter's name, and records it.
  ///
  /// A sheet rather than a dialog, because the model's five candidate names
  /// are the point: naming a newsletter from nothing is the hardest blank page
  /// in the product, and the candidates are written in the same call as the
  /// first article precisely so the user never faces it empty.
  Future<void> _nameNewsletter(
    BuildContext context,
    WidgetRef ref,
    ArticleState state,
  ) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xB3000000),
      builder: (BuildContext ctx) => _NewsletterSheet(
        suggestions:
            state.article?.newsletterNameSuggestions ?? const <String>[],
      ),
    );
    if (name == null) return;

    final String? failure = await ref
        .read(articleControllerProvider.notifier)
        .setNewsletterName(name);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            failure ?? 'Saved. Captions will name it from now on.',
            style: ZaveType.body,
          ),
        ),
      );
  }

  /// Picks when to be reminded to paste the article in — or clears it.
  ///
  /// A date then a time, which is two taps more than a single sheet would be,
  /// but both are the platform's own pickers: they handle the locale, the
  /// 12/24-hour setting and the calendar, and a hand-rolled one would get at
  /// least one of those wrong for somebody.
  ///
  /// The clear path lives here rather than on the card because it only exists
  /// once a reminder does, and a second control on the row for a state most
  /// users are never in would cost everyone the space.
  Future<void> _setReminder(
    BuildContext context,
    WidgetRef ref,
    ArticleState state,
  ) async {
    final DateTime? existing = state.article?.reminderAt();

    if (existing != null) {
      final bool? clear = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext ctx) => _Sheet(
          children: <Widget>[
            Text('Reminder', style: ZaveType.h3),
            SizedBox(height: ZaveSpace.sm),
            Text(
              'We will nudge you at this time. We cannot post the article for '
              'you — LinkedIn has no API for articles — so this is a reminder '
              'to paste it in yourself.',
              style: ZaveType.bodyMuted,
            ),
            SizedBox(height: ZaveSpace.xl),
            ZaveButton.primary(
              label: 'Pick a different time',
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            SizedBox(height: ZaveSpace.md),
            ZaveButton(
              label: 'Clear the reminder',
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );
      if (clear == null || !context.mounted) return;
      if (clear) {
        await _saveReminder(context, ref, null);
        return;
      }
    }

    final DateTime now = DateTime.now();
    if (!context.mounted) return;
    final DateTime? day = await showDatePicker(
      context: context,
      initialDate: existing ?? now.add(const Duration(days: 1)),
      // Today at the earliest — the server refuses a time that has passed, and
      // offering yesterday would be offering a guaranteed rejection.
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (day == null || !context.mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: existing == null
          ? const TimeOfDay(hour: 9, minute: 0)
          : TimeOfDay.fromDateTime(existing),
    );
    if (time == null || !context.mounted) return;

    await _saveReminder(
      context,
      ref,
      DateTime(day.year, day.month, day.day, time.hour, time.minute),
    );
  }

  Future<void> _saveReminder(
    BuildContext context,
    WidgetRef ref,
    DateTime? when,
  ) async {
    final String? failure = await ref
        .read(articleControllerProvider.notifier)
        .setArticleReminder(when);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            failure ??
                (when == null
                    ? 'Reminder cleared.'
                    : 'We will nudge you then.'),
            style: ZaveType.body,
          ),
        ),
      );
  }

  void _openSlot(BuildContext context, PlanSlot slot, int slotIndex) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _SlotSheet(slotIndex: slotIndex),
    );
  }

  Future<void> _openArticle(
    BuildContext context,
    WidgetRef ref,
    ArticleState a,
  ) async {
    if (a.article == null) return;
    final String? body = await ref.read(articleControllerProvider.notifier).fetchArticleBody(a);
    if (!context.mounted) return;
    if (body == null) {
      _say(context, "The article didn't load. Try again.");
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) =>
          _ArticleSheet(article: a.article!.copyWith(body: body)),
    );
  }

  Future<void> _copyArticle(
    BuildContext context,
    WidgetRef ref,
    ArticleState a,
  ) async {
    if (a.article == null) return;
    final String? body = await ref.read(articleControllerProvider.notifier).fetchArticleBody(a);
    if (!context.mounted) return;
    if (body == null || body.isEmpty) {
      _say(context, "The article didn't load, so there was nothing to copy.");
      return;
    }
    await Clipboard.setData(ClipboardData(text: body));
    if (!context.mounted) return;

    // Copy, then open LinkedIn's own article editor — the web's
    // `SundayArticlePanel` does both on one button, because the article
    // cannot be published through the API and pasting it is its only route.
    //
    // `openLinkKeepingClipboard`, never `openLinkOrCopy`: the clipboard is
    // holding 1,200-1,800 words that took a model call to produce, and the
    // copy fallback would replace them with a link to the editor.
    final bool opened = await openLinkKeepingClipboard(
      ref,
      linkedInArticleComposerUrl,
    );
    if (!context.mounted) return;
    _say(
      context,
      opened
          ? 'Article copied — paste it into the editor.'
          : 'Article copied. Open LinkedIn and start a new article to paste '
                'it.',
    );
  }

  void _say(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
  }
}

/// The week header.
///
/// The web renders this as a PAIR rather than two stacked bars (commit
/// b4d9f1b) — the week/phase on one side and the topic on the other, reading as
/// one object.
class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({required this.state, required this.plan});

  final PlannerState state;
  final WeekPlan? plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? topic = plan?.topic ?? state.upcomingTopic;
    final String? phase = plan?.phase ?? state.upcomingPhase;
    // The week being VIEWED. `plan` is null for any week the Saturday run
    // has not reached, so falling back to `currentWeekNumber` put "Week 3"
    // above week 9's locked preview — the heading contradicting the card
    // under it. The pinned week is the only thing that knows where the user
    // navigated to.
    final int week =
        ref.watch(plannerWeekProvider).week ??
        plan?.weekNumber ??
        state.currentWeekNumber;
    final int season = plan?.season ?? 1;
    // Null means "whatever the server calls now" — so a pinned week is the
    // only way to know the user has navigated away from it.
    final bool browsing = ref.watch(plannerWeekProvider).week != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Scaled down to fit rather than ellipsised or wrapped. "Week 12
        // planner" at h2 plus a 26pt serif is 54px wider than a 375pt screen
        // leaves, and the two halves are one phrase: truncating gives
        // "Week 12 planne…", and wrapping puts the serif word alone on a
        // second line. Shrinking the pair keeps it reading as a title.
        // Title on the left, the two week arrows on the right of the same
        // line. They used to be a row of labelled buttons under the topic,
        // which cost a full line of a phone screen to say "Previous" and
        // "Next" — words the arrows already say. Up here they also sit where
        // the thing they change is written, so it reads as one control.
        Row(
          children: <Widget>[
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text('Week $week', style: ZaveType.h2),
                    SizedBox(width: ZaveSpace.sm),
                    Text(
                      'planner',
                      style: plannerSerif(size: 26, color: ZaveColors.peri),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: ZaveSpace.sm),
            ZaveIconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous week',
              // Week 1 is the floor — there is no week 0 to fetch, and a
              // disabled control says that better than an error would.
              onPressed: week <= 1
                  ? null
                  : () => ref
                        .read(plannerWeekProvider.notifier)
                        .show(week - 1, season),
            ),
            SizedBox(width: ZaveSpace.xs),
            ZaveIconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next week',
              onPressed: () => ref
                  .read(plannerWeekProvider.notifier)
                  .show(week + 1, season),
            ),
          ],
        ),
        if (phase != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(phase.toUpperCase(), style: ZaveType.kicker),
        ],
        if (topic != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Text(topic, style: ZaveType.lead)),
              // Changing the topic re-plans only the days that have not been
              // written, so it is offered wherever the topic is shown rather
              // than hidden behind a menu. Not on a past week: re-planning
              // days that have already gone out would be a lie about history.
              if (plan != null && !browsing) ...<Widget>[
                SizedBox(width: ZaveSpace.md),
                ZaveButton(
                  label: 'Change',
                  onPressed: () => _editTopic(context, ref, topic),
                ),
              ],
            ],
          ),
        ],
        // The way back, and only when there is somewhere to come back FROM.
        //
        // A chip rather than a button: it is a return to the default, not an
        // action on the week, and a full-width button for it outranked the
        // week's own content. The web says "Back to this week" and so does
        // this — "This week" alone reads as a label for where you already
        // are, which is exactly the state in which this is not shown.
        if (browsing) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveChip(
              label: 'Back to this week',
              selected: false,
              icon: const Icon(Icons.refresh, size: 14),
              onTap: () =>
                  ref.read(plannerWeekProvider.notifier).showCurrent(),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editTopic(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final String? next = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => _ChangeTopicDialog(current: current),
    );
    if (next == null || !context.mounted) return;

    final String? failure = await ref
        .read(plannerControllerProvider.notifier)
        .changeTopic(next);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            failure ??
                'Re-planned. Days you have already written are unchanged.',
            style: ZaveType.body,
          ),
        ),
      );
  }
}

/// Typing a new topic for the week.
///
/// The 120-character cap matches the server's, which exists so a topic
/// cannot become a prompt. Enforcing it here as well means the user is told
/// while they type rather than after they submit.
class _ChangeTopicDialog extends StatefulWidget {
  const _ChangeTopicDialog({required this.current});

  final String current;

  @override
  State<_ChangeTopicDialog> createState() => _ChangeTopicDialogState();
}

class _ChangeTopicDialogState extends State<_ChangeTopicDialog> {
  static const int _maxLength = 120;
  late final TextEditingController _topic = TextEditingController(
    text: widget.current,
  );

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String value = _topic.text.trim();
    final bool ready =
        value.isNotEmpty &&
        value != widget.current &&
        value.length <= _maxLength;

    return AlertDialog(
      title: const Text("This week's topic"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'The days you have not written yet will be re-planned around this. '
            'Anything already written, approved or published stays as it is.',
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _topic,
            hint: 'What this week is about',
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            '${value.length} / $_maxLength',
            style: ZaveType.caption.copyWith(
              color: value.length > _maxLength
                  ? ZaveColors.amber
                  : ZaveColors.ink62,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: ready ? () => Navigator.of(context).pop(value) : null,
          child: Text(
            'Re-plan',
            style: ZaveType.button.copyWith(
              color: ready ? ZaveColors.white : ZaveColors.ink35,
            ),
          ),
        ),
      ],
    );
  }
}

/// A week that has not been generated yet.
///
/// Not an error and not empty: the season roadmap already decided this week's
/// topic and title, so the screen previews them rather than showing nothing.
class _UpcomingWeek extends StatelessWidget {
  const _UpcomingWeek({required this.state});

  final PlannerState state;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Text('NOT WRITTEN YET', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            state.upcomingTitle ??
                state.upcomingTopic ??
                'This week is planned',
            style: ZaveType.h3,
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            'The week is written on Saturday, together with its article.',
            style: ZaveType.bodyMuted,
          ),
        ],
      ),
    );
  }
}

/// A slot's detail, as a bottom sheet — the phone's stand-in for the web's
/// right-hand preview rail.
/// One day, one sheet: the post as it will go out, and everything that
/// changes it.
///
/// ## Why this is the only sheet
///
/// There were briefly two. Tapping the poster opened a viewer and tapping
/// anywhere else opened this, because the poster thumbnail sat in its own
/// `GestureDetector` inside the card and won the tap arena against the card's.
/// One card, two mutually exclusive targets, two unrelated sheets — and
/// neither of them showed the post. This sheet showed the PLAN for the day
/// (title, angle, hashtags) and the viewer showed the artwork, so the words
/// that were actually going to be published appeared in neither.
///
/// So: the card has one tap target again, and this is what it opens. The
/// full-bleed [showPosterSheet] still exists, but only as the zoom you reach
/// by tapping the poster inside here — a crop is a thumbnail, and the whole
/// image is one tap further in, not a different destination.
///
/// ## Why it reads the slot live
///
/// It used to be handed a [PlanSlot] by value at open time, and every planner
/// mutation ends in `invalidateSelf()` — which rebuilds the week BEHIND the
/// sheet and leaves the sheet showing the old one. That was survivable while
/// the sheet showed only a title: "Rewrite the title" simply closed itself
/// afterwards, and a comment here said so. It is not survivable now. A sheet
/// that shows the body and the poster, and offers a button to replace each,
/// must show what those buttons produced.
///
/// So it takes the INDEX and reads the slot from the provider. Three
/// consequences worth knowing: `invalidateSelf` keeps the previous value while
/// it refetches, so the sheet does not blank mid-action; the plan can be null
/// or shorter than the index when the week behind changes, which closes the
/// sheet rather than throwing; and the body is keyed on `postId`, so a
/// regenerate that creates a new post reloads it instead of showing the old
/// draft's text.
class _SlotSheet extends ConsumerStatefulWidget {
  const _SlotSheet({required this.slotIndex});

  final int slotIndex;

  @override
  ConsumerState<_SlotSheet> createState() => _SlotSheetState();
}

class _SlotSheetState extends ConsumerState<_SlotSheet> {
  bool _busy = false;
  bool _titleBusy = false;
  bool _scriptBusy = false;
  bool _posterBusy = false;
  bool _saving = false;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  /// Which post the body field was filled from.
  ///
  /// A regenerate replaces the post rather than editing it, so the id changes
  /// under the sheet. Keying on it is what reloads the field instead of
  /// leaving the previous draft's text in a box labelled with the new one.
  String? _bodyLoadedFor;

  /// The title the server last gave us, so an AI rewrite lands in the field
  /// while a half-typed edit is not thrown away by an unrelated rebuild.
  String? _titleLoadedFrom;

  bool _titleDirty = false;
  bool _bodyDirty = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
  }

  // ── Video-script day ──────────────────────────────────────────────────────

  Future<void> _generateScript() async {
    setState(() => _scriptBusy = true);
    String? failure;
    try {
      failure = await ref
          .read(videoScriptsControllerProvider.notifier)
          .generate(widget.slotIndex);
    } finally {
      if (mounted) setState(() => _scriptBusy = false);
    }
    if (!mounted || failure == null) return;
    _say(failure);
  }

  Future<void> _markScriptPosted() async {
    setState(() => _scriptBusy = true);
    bool saved = false;
    try {
      saved = await ref
          .read(videoScriptsControllerProvider.notifier)
          .markPosted(widget.slotIndex);
    } finally {
      if (mounted) setState(() => _scriptBusy = false);
    }
    if (!mounted) return;
    // Said out loud only on failure. On success the row behind the sheet turns
    // green and the button becomes a tick, which is the louder signal.
    if (!saved) _say('That did not save. Try again.');
  }

  Future<void> _copyCaption(VideoScript script) async {
    await Clipboard.setData(ClipboardData(text: script.caption));
    if (mounted) _say('Caption copied.');
  }

  // ── Editing ───────────────────────────────────────────────────────────────

  /// The Save button, and nothing else.
  ///
  /// Which row gets written, in what order, and what to say when one refuses
  /// is [PlannerController.saveSlotEdits] now. This used to do all of it from
  /// here — including reaching into `posts/data/` for a repository the sheet
  /// had no business holding, and then invalidating that slice's post cache
  /// by hand because it had just written around it. The server trap that
  /// shapes the call (only `content` may go up, or the planner day is blanked)
  /// is documented there, where the call actually is.
  ///
  /// Null means "untouched": the dirty flags stay here because only the field
  /// can tell a typed edit from a value the sheet filled in.
  Future<void> _save() async {
    setState(() => _saving = true);
    String? failure;
    try {
      failure = await ref
          .read(plannerControllerProvider.notifier)
          .saveSlotEdits(
            widget.slotIndex,
            title: _titleDirty ? _title.text : null,
            body: _bodyDirty ? _body.text : null,
          );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    if (!mounted) return;
    if (failure != null) {
      _say(failure);
      return;
    }
    setState(() {
      _titleDirty = false;
      _bodyDirty = false;
    });
    _say('Saved.');
  }

  Future<void> _rewriteTitle() async {
    setState(() => _titleBusy = true);
    String? failure;
    try {
      failure = await ref
          .read(plannerControllerProvider.notifier)
          .regenerateTitle(widget.slotIndex);
    } finally {
      if (mounted) setState(() => _titleBusy = false);
    }
    if (!mounted) return;
    if (failure != null) {
      _say(failure);
      return;
    }
    // The sheet reads the slot live now, so the new title arrives here. Clear
    // the dirty flag or the next save would write the old typed one back over
    // the rewrite the user just asked for.
    setState(() {
      _titleDirty = false;
      _titleLoadedFrom = null;
    });
  }

  // ── Generation ────────────────────────────────────────────────────────────

  /// Nothing written yet — the day is a title and an angle and no post.
  /// Only a post day has anything to generate.
  ///
  /// `isPublishable` first, because the server refuses the other five days
  /// with NOT_A_POST_DAY and a button that can only ever fail is worse than no
  /// button — the user spends a tap and a round trip to be told no.
  bool _canGenerate(PlanSlot slot) =>
      slot.isPublishable &&
      slot.postId == null &&
      slot.status != SlotStatus.generating;

  /// A draft exists and can be thrown away for a different one. Never once it
  /// is on LinkedIn: there is nothing to replace at that point.
  bool _canRegenerate(PlanSlot slot) =>
      slot.isPublishable &&
      slot.postId != null &&
      slot.status != SlotStatus.generating &&
      slot.status != SlotStatus.published;

  Future<void> _run(PlanSlot slot, {required bool force}) async {
    if (force) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text('Write it again?'),
          content: Text(
            _bodyDirty
                // The edits are in a field that is about to be replaced, and
                // the post behind it is about to be deleted. Saying so is the
                // difference between a choice and a surprise.
                ? 'This replaces the current draft with a new one and costs '
                      'XP. Your unsaved edits to this post will be lost. The '
                      'poster is kept.'
                : 'This replaces the current draft with a new one and costs '
                      'XP. The old draft is deleted. The poster is kept — '
                      'use "New image" to change that.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancel',
                style: ZaveType.button.copyWith(color: ZaveColors.ink62),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                'Replace',
                // Amber, not red. Zave has no red.
                style: ZaveType.button.copyWith(color: ZaveColors.amber),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _busy = true);
    // Empty means "nothing to say", which no path currently produces —
    // but a future branch that stays silent should not have to reach for a
    // nullable just to do so.
    String note = '';
    try {
      final GeneratedSlot? result = await ref
          .read(plannerControllerProvider.notifier)
          .generate(widget.slotIndex, force: force);
      note = switch (result) {
        null => "That didn't go through. Try again.",
        GeneratedSlot(alreadyGenerated: true) => 'That day already has a post.',
        _ => force ? 'Rewritten.' : 'Written. Review it, then approve.',
      };
      // The new post is a different row, so the field must refill from it
      // rather than keep the replaced draft's words.
      if (result != null && !result.alreadyGenerated) {
        _bodyLoadedFor = null;
        _bodyDirty = false;
      }
    } on PlannerGenerateFailure catch (e) {
      note = switch (e.kind) {
        // The server's message names the price and the balance, which is the
        // one thing a generic "not enough XP" would lose.
        PlannerGenerateFailureKind.insufficientXp =>
          e.message ?? 'Not enough XP to write this one.',
        PlannerGenerateFailureKind.noLinkedinAccount =>
          'Connect a LinkedIn account first — Settings › Connected Accounts.',
        // Never "try again". A retry cannot succeed on a day the week gives no
        // post to, and the server's own message names which kind of day it is.
        PlannerGenerateFailureKind.notAPostDay =>
          e.message ?? 'This day is not a post — there is nothing to write.',
        PlannerGenerateFailureKind.failed =>
          e.message ?? "That didn't go through. Try again.",
      };
    } finally {
      if (mounted) setState(() => _busy = false);
    }

    if (!mounted || note.isEmpty) return;
    _say(note);
  }

  /// Draws a new poster for the post that already exists.
  ///
  /// Separate from [_run] because the two are separate costs and separate
  /// intents: rewriting the words keeps the picture, and this changes the
  /// picture without touching a word. Collapsing them into one "regenerate"
  /// is what made the old flow charge for artwork nobody asked to change.
  Future<void> _newPoster(PlanSlot slot) async {
    setState(() => _posterBusy = true);
    String note;
    try {
      final bool ok = await ref
          .read(plannerControllerProvider.notifier)
          .regeneratePoster(widget.slotIndex);
      note = ok
          ? 'New image.'
          : 'The image did not come back. Your post is unchanged.';
    } on Object {
      note = 'The image did not come back. Your post is unchanged.';
    } finally {
      if (mounted) setState(() => _posterBusy = false);
    }
    if (mounted) _say(note);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PlannerState> planner = ref.watch(
      plannerControllerProvider,
    );
    final List<PlanSlot> posts = planner.value?.plan?.posts ?? <PlanSlot>[];

    // The week behind the sheet changed out from under it — browsing to
    // another week, or a plan that went away. Closing is the only honest
    // answer; the alternative is a range error or a sheet editing a day that
    // is no longer on screen.
    if (widget.slotIndex >= posts.length) {
      return const _Sheet(
        children: <Widget>[
          Text('That day is no longer in this week.'),
        ],
      );
    }
    final PlanSlot slot = posts[widget.slotIndex];

    // Refill the title field whenever the server's title changes and the user
    // has not typed over it.
    if (!_titleDirty && _titleLoadedFrom != slot.title) {
      _titleLoadedFrom = slot.title;
      _title.text = slot.title;
    }

    final AsyncValue<List<VideoScript>> scripts = ref.watch(
      videoScriptsControllerProvider,
    );
    final VideoScript? script = slot.kind == DayKind.videoScript
        ? <VideoScript?>[...?scripts.value]
              .where((VideoScript? v) => v?.dayIndex == widget.slotIndex)
              .firstOrNull
        : null;

    final ({Color color, String label}) signal = slotSignal(
      slot,
      handoff: slot.kind != DayKind.videoScript
          ? null
          : scripts.value == null
          ? null
          : script == null
          ? HandoffState.notWritten
          : script.isPosted
          ? HandoffState.posted
          : HandoffState.ready,
    );

    // The post itself, once the day has one. Lazily — the planner payload
    // carries no body, and seven of them would be most of the response.
    final String? postId = slot.postId;
    final AsyncValue<LibraryPost>? post = postId == null
        ? null
        : ref.watch(postDetailProvider(postId));
    if (post?.value case final LibraryPost p when _bodyLoadedFor != p.id) {
      _bodyLoadedFor = p.id;
      _body.text = p.content;
      _bodyDirty = false;
    }

    final String? poster =
        slot.fullImageUrl ?? post?.value?.imageUrl ?? slot.previewImageUrl;
    final bool editable = slot.status != SlotStatus.published;

    return _Sheet(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(slot.day.toUpperCase(), style: ZaveType.kicker),
            const Spacer(),
            ZaveDot(signal.color),
            SizedBox(width: ZaveSpace.sm),
            Text(
              signal.label,
              style: ZaveType.caption.copyWith(color: signal.color),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),

        // ── Title ────────────────────────────────────────────────────────
        if (editable)
          ZaveField(
            controller: _title,
            label: 'TITLE',
            maxLines: 2,
            onChanged: (_) {
              if (!_titleDirty) setState(() => _titleDirty = true);
            },
          )
        else
          Text(slot.title, style: ZaveType.h2),
        if (editable) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Align(
            alignment: Alignment.centerLeft,
            // Free, so no confirm — and it clears the server's
            // `titleEditedByUser`, which is what stops a later regenerate
            // from quietly overwriting a title someone typed by hand.
            child: ZaveButton(
              label: 'Rewrite the title',
              busy: _titleBusy,
              onPressed: _titleBusy ? null : _rewriteTitle,
            ),
          ),
        ],

        if (slot.angle.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Text('ANGLE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(slot.angle, style: ZaveType.bodyMuted),
        ],
        if (slot.hashtags.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              for (final String tag in slot.hashtags)
                ZavePill(label: '#$tag', color: ZaveColors.peri),
            ],
          ),
        ],

        // ── The poster ───────────────────────────────────────────────────
        if (poster case final String src when src.isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          GestureDetector(
            // The whole image, one tap further in — this is a 16:9 crop of a
            // taller poster.
            onTap: () =>
                showPosterSheet(context, imageUrl: src, title: slot.title),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  src,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],

        // ── The post ─────────────────────────────────────────────────────
        if (post != null) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          switch (post) {
            AsyncValue<LibraryPost>(hasValue: true) => editable
                ? ZaveField(
                    controller: _body,
                    label: 'POST',
                    maxLines: 14,
                    minLines: 6,
                    onChanged: (_) {
                      if (!_bodyDirty) setState(() => _bodyDirty = true);
                    },
                  )
                : Text(post.value!.content, style: ZaveType.body),
            AsyncValue<LibraryPost>(hasError: true) => Text(
              'The post could not be loaded.',
              style: ZaveType.bodyMuted,
            ),
            _ => Text('Loading the post…', style: ZaveType.bodyMuted),
          },
        ],

        // A video day. Without this the sheet offered one action — rewriting
        // the title of a script it could not show — on a day whose entire
        // output is that script.
        if (slot.kind == DayKind.videoScript) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          if (scripts.isLoading && scripts.value == null)
            Text('Loading the script…', style: ZaveType.bodyMuted)
          else if (script == null)
            _ScriptMissing(busy: _scriptBusy, onGenerate: _generateScript)
          else
            _ScriptBody(
              script: script,
              busy: _scriptBusy,
              onCopyCaption: () => _copyCaption(script),
              onPosted: script.isPosted ? null : _markScriptPosted,
            ),
        ],

        // ── Actions ──────────────────────────────────────────────────────
        if (editable && (_titleDirty || _bodyDirty)) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          ZaveButton.primary(
            label: 'Save changes',
            expand: true,
            busy: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
        if (_canGenerate(slot) || _canRegenerate(slot)) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          if (_canGenerate(slot))
            ZaveButton.primary(
              label: slot.format == 'carousel'
                  ? 'Build this carousel'
                  : 'Write this post',
              expand: true,
              busy: _busy,
              onPressed: _busy ? null : () => _run(slot, force: false),
            )
          else ...<Widget>[
            ZaveButton(
              label: slot.format == 'carousel'
                  ? 'Build it again'
                  : 'Write it again',
              expand: true,
              busy: _busy,
              onPressed: _busy ? null : () => _run(slot, force: true),
            ),
            // Only where the day actually carries one. Offering new artwork
            // on a text-only day would charge for an image nothing shows.
            if (slot.format == 'text_image') ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: poster == null ? 'Add an image' : 'New image',
                expand: true,
                busy: _posterBusy,
                onPressed: _posterBusy ? null : () => _newPoster(slot),
              ),
            ],
          ],
        ],
      ],
    );
  }
}

/// Which part of the week's setup is on screen.
enum _SetupTab { article, posts, scripts, analytics }

/// The week as a setup, then the week as a schedule.
///
/// ## Why steps
///
/// A planned week is three pieces of work with an order to them — the
/// Thursday article is the spine, the weekday titles are chosen from ITS
/// section headings, and the two scripts hang off the same topic (CLAUDE.md
/// §6b). Shown as one column, that order was invisible and so was the
/// progress: the only way to learn that Friday still had no script was to
/// scroll to Friday.
///
/// ## Why the tabs are not gated
///
/// The article is written unattended by the Sunday batch, and
/// `generateWeeklyArticle` NEVER throws — a model hiccup returns null and the
/// week carries on without one, deliberately. Gating posts behind a scheduled
/// article would turn that survivable miss into a locked week, which is the
/// exact trade §6b says not to make. So every tab is reachable and the ticks
/// report rather than enforce.
///
/// The full week strip appears underneath once all three are done: before
/// that it is a duplicate of the steps above it, and after it is the thing
/// the page is actually for.
class _WeekSetup extends StatefulWidget {
  const _WeekSetup({
    required this.plan,
    required this.article,
    required this.scripts,
    required this.articleCard,
    required this.analytics,
    required this.dayCard,
    required this.dayCardWidth,
  });

  final WeekPlan plan;
  final AsyncValue<ArticleState> article;
  final AsyncValue<List<VideoScript>> scripts;

  /// Built by the page, which owns the article's callbacks.
  final Widget articleCard;
  final Widget analytics;

  /// One day of the week, by slot index — the same card the strip uses.
  final Widget Function(int index) dayCard;
  final double dayCardWidth;

  @override
  State<_WeekSetup> createState() => _WeekSetupState();
}

class _WeekSetupState extends State<_WeekSetup> {
  _SetupTab _tab = _SetupTab.article;

  /// Scheduled, or already out. Either way the user has nothing left to do
  /// with it — and `isPublished` matters because the article is the one thing
  /// in the week we cannot publish for them (there is no LinkedIn article
  /// endpoint), so "I published it" is the only completion it ever gets.
  bool get _articleDone {
    final WeeklyArticle? a = widget.article.value?.article;
    if (a == null) return false;
    return a.isPublished || a.hasReminder();
  }

  List<int> get _postDays => <int>[
    for (int i = 0; i < widget.plan.posts.length; i++)
      if (widget.plan.posts[i].kind == DayKind.post) i,
  ];

  List<int> get _scriptDays => <int>[
    for (int i = 0; i < widget.plan.posts.length; i++)
      if (widget.plan.posts[i].kind == DayKind.videoScript) i,
  ];

  bool get _postsDone =>
      _postDays.isNotEmpty &&
      _postDays.every((int i) => widget.plan.posts[i].hasPost);

  bool get _scriptsDone {
    final List<VideoScript>? written = widget.scripts.value;
    if (written == null) return false;
    final List<int> days = _scriptDays;
    return days.isNotEmpty &&
        days.every(
          (int i) => written.any((VideoScript v) => v.dayIndex == i),
        );
  }

  bool _done(_SetupTab tab) => switch (tab) {
    _SetupTab.article => _articleDone,
    _SetupTab.posts => _postsDone,
    _SetupTab.scripts => _scriptsDone,
    _SetupTab.analytics => false,
  };

  /// Left for the next step, right for the previous. Stops at both ends
  /// rather than wrapping: a stepper that loops from Analytics back to
  /// Article reads as having lost your place.
  void _onSwipe(DragEndDetails details) {
    final double v = details.primaryVelocity ?? 0;
    // A deliberate flick, not a stray horizontal wobble during a vertical
    // scroll — the page itself scrolls vertically and those drags are rarely
    // perfectly straight.
    if (v.abs() < 200) return;
    final int next = _tab.index + (v < 0 ? 1 : -1);
    if (next < 0 || next >= _SetupTab.values.length) return;
    setState(() => _tab = _SetupTab.values[next]);
  }

  @override
  Widget build(BuildContext context) {
    final bool setUp = _articleDone && _postsDone && _scriptsDone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Sideways rather than wrapped: four labels do not fit a phone's
        // width, and a Wrap would stack them two-by-two into something that
        // no longer reads as a row of steps.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final _SetupTab tab in _SetupTab.values) ...<Widget>[
                // A chevron between each pair, the way a stepper draws its
                // connector. Not a control — the chips are the control, and a
                // second tappable thing doing the same job in a 4pt gap
                // between two of them is a mis-tap waiting to happen.
                if (tab != _SetupTab.article) ...<Widget>[
                  SizedBox(width: ZaveSpace.xs),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: ZaveColors.ink35,
                  ),
                  SizedBox(width: ZaveSpace.xs),
                ],
                ZaveChip(
                  label: switch (tab) {
                    _SetupTab.article => '1 · Article',
                    _SetupTab.posts => '2 · Posts',
                    _SetupTab.scripts => '3 · Scripts',
                    _SetupTab.analytics => 'Analytics',
                  },
                  selected: _tab == tab,
                  // A tick, not a count: the step is done or it is not, and a
                  // half-written week is still a week with work left in it.
                  icon: _done(tab)
                      ? const Icon(Icons.check, size: 14)
                      : null,
                  onTap: _tab == tab ? null : () => setState(() => _tab = tab),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),

        // Swipe to change step.
        //
        // ## The nested-gesture problem, and why this is not a PageView
        //
        // Two of the four steps contain a horizontally scrolling strip of day
        // cards, so an outer horizontal drag and an inner one are competing
        // for the same gesture. A `PageView` would also have to be given a
        // fixed height — and the steps differ by hundreds of pixels, from a
        // row of stat tiles to a full article card, so any number would be
        // wrong for three of them.
        //
        // A plain drag recognizer solves both. The inner `SingleChildScrollView`
        // sits deeper in the hit-test path, so when a drag STARTS on the day
        // strip the strip wins the arena and scrolls as before; this one only
        // ever sees drags that began somewhere else on the step. That is
        // exactly the behaviour wanted: the cards still swipe, and the step
        // still swipes, and neither steals from the other.
        GestureDetector(
          // Opaque so a drag starting on empty ground inside the step still
          // registers — without it only the painted children are draggable
          // and the Analytics step is mostly empty.
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: _onSwipe,
          child: switch (_tab) {
            _SetupTab.article => widget.articleCard,
            _SetupTab.posts => _StepDays(
              label: 'The two posts this week publishes.',
              days: _postDays,
              dayCard: widget.dayCard,
              width: widget.dayCardWidth,
            ),
            _SetupTab.scripts => _StepDays(
              label: 'We write these; you record and post them.',
              days: _scriptDays,
              dayCard: widget.dayCard,
              width: widget.dayCardWidth,
            ),
            _SetupTab.analytics => widget.analytics,
          },
        ),

        // The whole week, once there is a whole week to show.
        if (setUp) ...<Widget>[
          SizedBox(height: ZaveSpace.xxl),
          ZaveSectionHeader(
            title: 'The week',
            actionLabel:
                '${widget.plan.publishedCount}/${widget.plan.liveSlotCount} published',
            onTap: () {},
          ),
          SizedBox(height: ZaveSpace.lg),
          _DayStrip(
            count: widget.plan.posts.length,
            dayCard: widget.dayCard,
            width: widget.dayCardWidth,
          ),
        ],
      ],
    );
  }
}

/// The days belonging to one step, as a horizontal strip.
class _StepDays extends StatelessWidget {
  const _StepDays({
    required this.label,
    required this.days,
    required this.dayCard,
    required this.width,
  });

  final String label;
  final List<int> days;
  final Widget Function(int index) dayCard;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Text(
        'This week has none of these.',
        style: ZaveType.bodyMuted,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.bodyMuted),
        SizedBox(height: ZaveSpace.lg),
        _DayStrip(
          count: days.length,
          dayCard: (int i) => dayCard(days[i]),
          width: width,
        ),
      ],
    );
  }
}

/// A row of day cards that scrolls sideways.
///
/// `IntrinsicHeight` rather than a fixed height: the cards differ by several
/// hundred pixels depending on whether the day has a poster, an Approve
/// button or a hand-off, and a hardcoded number would be wrong for most of
/// them the moment any of that changes. It also makes every card as tall as
/// the tallest, which is what stops the row looking ragged.
class _DayStrip extends StatelessWidget {
  const _DayStrip({
    required this.count,
    required this.dayCard,
    required this.width,
  });

  final int count;
  final Widget Function(int index) dayCard;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < count; i++) ...<Widget>[
                if (i > 0) SizedBox(width: ZaveSpace.md),
                // The card ends short of the edge so the next one is visibly
                // there — the affordance that says this scrolls at all.
                SizedBox(width: width, child: dayCard(i)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The Analytics step: what the week has actually done.
class _WeekAnalytics extends StatelessWidget {
  const _WeekAnalytics({required this.plan, required this.tileWidth});

  final WeekPlan plan;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    final int published = plan.publishedCount;
    final int live = plan.liveSlotCount;
    final int written = plan.posts
        .where((PlanSlot s) => s.isPublishable && s.hasPost)
        .length;
    final int awaiting = plan.awaitingApproval.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Both numbers are counted off `plan`, and the wedge draws the same
        // ratio the first one states.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: tileWidth,
                  child: ZaveStatCard(
                    label: 'Published',
                    sublabel: 'this week',
                    value: '$published',
                    unit: 'of $live',
                    chart: live == 0
                        ? null
                        : ZaveAreaWedge(progress: published / live),
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                SizedBox(
                  width: tileWidth,
                  child: ZaveStatCard(
                    label: 'Week',
                    sublabel: plan.phase ?? 'of the season',
                    value: '${plan.weekNumber}',
                    filled: true,
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                SizedBox(
                  width: tileWidth,
                  child: ZaveStatCard(
                    label: 'Written',
                    sublabel: 'ready to go out',
                    value: '$written',
                    unit: 'of $live',
                  ),
                ),
                if (awaiting > 0) ...<Widget>[
                  SizedBox(width: ZaveSpace.md),
                  SizedBox(
                    width: tileWidth,
                    child: ZaveStatCard(
                      label: 'Awaiting you',
                      sublabel: 'needs approval',
                      value: '$awaiting',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The full article body, for reading and copying.
class _ArticleSheet extends StatelessWidget {
  const _ArticleSheet({required this.article});

  final WeeklyArticle article;

  @override
  Widget build(BuildContext context) {
    return _Sheet(
      children: <Widget>[
        Text('NEWSLETTER', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(article.title, style: plannerSerif(size: 28)),
        if (article.thesis != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Text(article.thesis!, style: ZaveType.lead),
        ],
        SizedBox(height: ZaveSpace.xl),
        Container(height: 1, color: ZaveColors.rule),
        SizedBox(height: ZaveSpace.xl),
        Text(article.body, style: ZaveType.body),
      ],
    );
  }
}

/// Shared bottom-sheet chrome.
class _Sheet extends StatelessWidget {
  const _Sheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ZaveColors.rule,
                    borderRadius: ZaveRadius.pillBr,
                  ),
                ),
              ),
              SizedBox(height: ZaveSpace.xl),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _PlannerSkeleton extends StatelessWidget {
  const _PlannerSkeleton();

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      const _CardSkeleton(height: 92),
      SizedBox(height: ZaveSpace.xl),
      const _CardSkeleton(height: 180),
      SizedBox(height: ZaveSpace.xxl),
      for (int i = 0; i < 4; i++) ...<Widget>[
        const _CardSkeleton(height: 120),
        SizedBox(height: ZaveSpace.md),
      ],
    ],
  );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}

class _PlannerError extends StatelessWidget {
  const _PlannerError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Amber, not red: Zave has no red, and a failed fetch is
                // "needs attention", not a destructive state.
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.sm),
                Text('COULD NOT LOAD', style: ZaveType.kicker),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            Text("This week's plan didn't load.", style: ZaveType.h3),
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    ],
  );
}

/// Sunday's batch has not written this day's script, or it failed.
///
/// The web shows the same control for the same reason: before it existed the
/// panel read "it will appear here" with nothing behind it, so a failed Sunday
/// left the user waiting on something that was never coming.
class _ScriptMissing extends StatelessWidget {
  const _ScriptMissing({required this.busy, required this.onGenerate});

  final bool busy;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('SCRIPT', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.sm),
      Text(
        'Scripts are written on Sunday with the rest of the week. You can '
        'have this one now.',
        style: ZaveType.bodyMuted,
      ),
      SizedBox(height: ZaveSpace.lg),
      ZaveButton.primary(
        label: busy ? 'Writing the script…' : 'Write this script',
        expand: true,
        busy: busy,
        onPressed: busy ? null : onGenerate,
      ),
    ],
  );
}

/// The script itself: the hook, the shot list, the caption, and the one
/// control that can ever close it out.
///
/// ## Why a shot list and not a page of prose
///
/// Someone is going to hold a phone and film this. They need to know what to
/// say, roughly when, and what is on screen while they say it. A wall of text
/// also invites reading it aloud, which is the most recognisable way a
/// LinkedIn video looks scripted.
class _ScriptBody extends StatelessWidget {
  const _ScriptBody({
    required this.script,
    required this.busy,
    required this.onCopyCaption,
    required this.onPosted,
  });

  final VideoScript script;
  final bool busy;
  final VoidCallback onCopyCaption;

  /// Null once it is posted — there is nothing left to say.
  final VoidCallback? onPosted;

  @override
  Widget build(BuildContext context) {
    final int runtime = script.runtimeSeconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('FIRST LINE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        Container(
          width: double.infinity,
          padding: ZaveSpace.rowPad,
          decoration: BoxDecoration(
            gradient: ZaveFill.rest,
            border: ZaveEdgeBorder(
              gradient: ZaveEdge.rest,
              highlight: ZaveEdge.bevel,
            ),
            borderRadius: ZaveRadius.cardSmBr,
          ),
          // The single most load-bearing sentence in a short video — it is
          // what decides whether the next four seconds happen — so it gets
          // its own box rather than becoming beat zero of the list.
          child: Text(script.hook, style: ZaveType.lead),
        ),

        if (script.hasBeats) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          Row(
            children: <Widget>[
              Expanded(child: Text('SHOT LIST', style: ZaveType.kicker)),
              if (runtime > 0)
                Text('about ${runtime}s', style: ZaveType.caption),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          for (final VideoBeat beat in script.beats) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 42,
                  child: Text(
                    beat.timecode,
                    style: ZaveType.mono.copyWith(
                      color: ZaveColors.lavenderLo,
                      height: 1.45,
                    ),
                  ),
                ),
                SizedBox(width: ZaveSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(beat.say, style: ZaveType.body),
                      if (beat.show.trim().isNotEmpty) ...<Widget>[
                        SizedBox(height: 2),
                        Text(beat.show, style: ZaveType.caption),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
          ],
        ],

        if (script.caption.trim().isNotEmpty) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Row(
            children: <Widget>[
              Expanded(child: Text('CAPTION', style: ZaveType.kicker)),
              ZaveButton(label: 'Copy', onPressed: onCopyCaption),
            ],
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(script.caption, style: ZaveType.bodyMuted),
        ],

        SizedBox(height: ZaveSpace.xl),
        Text(
          // Said plainly, and only here. The user is about to look for a
          // publish button; this is why there isn't one.
          'LinkedIn’s video upload is a different API from a text post and we '
          'cannot put this up for you. Film it, post it, then mark it here.',
          style: ZaveType.caption,
        ),
        SizedBox(height: ZaveSpace.md),
        if (onPosted == null)
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.green),
              SizedBox(width: ZaveSpace.sm),
              Text(
                'Posted',
                style: ZaveType.label.copyWith(color: ZaveColors.green),
              ),
            ],
          )
        else
          ZaveButton.primary(
            label: 'I posted this',
            expand: true,
            busy: busy,
            onPressed: busy ? null : onPosted,
          ),
      ],
    );
  }
}

/// Name the newsletter.
///
/// The candidates are the whole reason this is a sheet and not a one-line
/// dialog. A newsletter name is the hardest blank page in the product — it is
/// permanent, public, and the user is being asked for it in the middle of
/// publishing something else — so the model writes five with the first article
/// and they are offered before the keyboard is.
///
/// Tapping one fills the field rather than submitting. The user should see
/// what they are about to commit to, and they frequently want to edit a
/// candidate by a word.
class _NewsletterSheet extends StatefulWidget {
  const _NewsletterSheet({required this.suggestions});

  final List<String> suggestions;

  @override
  State<_NewsletterSheet> createState() => _NewsletterSheetState();
}

class _NewsletterSheetState extends State<_NewsletterSheet> {
  final TextEditingController _controller = TextEditingController();

  /// The server's cap, mirrored so the field cannot compose a name the save
  /// will refuse.
  static const int _maxLength = 120;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final String name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: Border.all(color: ZaveGlass.headerBorder),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardMd),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Name your newsletter', style: ZaveType.h3),
              SizedBox(height: ZaveSpace.sm),
              Text(
                // Says plainly what this is and is not. The user is about to
                // be asked for the same thing by LinkedIn, and a screen that
                // implied we had created it for them would be a lie they
                // discover thirty seconds later.
                'Create it in LinkedIn’s own composer while you publish, then '
                'tell us what you called it. Every later edition goes into the '
                'same newsletter.',
                style: ZaveType.bodyMuted,
              ),

              if (widget.suggestions.isNotEmpty) ...<Widget>[
                SizedBox(height: ZaveSpace.xl),
                Text('IDEAS', style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.sm),
                Wrap(
                  spacing: ZaveSpace.sm,
                  runSpacing: ZaveSpace.sm,
                  children: <Widget>[
                    for (final String s in widget.suggestions)
                      ZaveChip(
                        label: s,
                        selected: _controller.text.trim() == s,
                        // Fills the field, does not submit. The user should
                        // see what they are committing to, and they often
                        // want to change a candidate by one word.
                        onTap: () => setState(() {
                          _controller
                            ..text = s
                            ..selection = TextSelection.collapsed(
                              offset: s.length,
                            );
                        }),
                      ),
                  ],
                ),
              ],

              SizedBox(height: ZaveSpace.xl),
              ZaveField(
                controller: _controller,
                hint: 'The Onboarding Letter',
                maxLength: _maxLength,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _save(),
              ),

              SizedBox(height: ZaveSpace.lg),
              ZaveButton.primary(
                label: 'Save the name',
                expand: true,
                // Disabled on empty rather than saving and failing: the server
                // refuses a blank name, and a button that can only error is
                // worse than one that waits.
                onPressed: _controller.text.trim().isEmpty ? null : _save,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
