import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/planner_controller.dart';
import '../../data/planner_repositories.dart';
import '../../domain/plan_slot.dart';
import '../../domain/video_script.dart';
import '../../domain/weekly_article.dart';
import '../widgets/article_card.dart';
import '../widgets/slot_card.dart';
import '../../domain/planner_repository.dart';

/// **Plan** — the content planner. The web's `/planner`.
///
/// A week is not seven posts that share a topic. It is **one long-form article
/// plus six posts that argue facets of it** (CLAUDE.md §6b), and the screen is
/// laid out to say so: the article sits at the top as the week's spine, and the
/// seven day slots hang off it.
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

        // The article first: it is the week's spine, and the weekday titles are
        // chosen from ITS section headings rather than re-derived from the
        // topic. Putting the days first would read as seven angles that happen
        // to share a subject, which is the thing this design exists to avoid.
        article.when(
          loading: () => const _CardSkeleton(height: 180),
          error: (Object e, StackTrace _) => const SizedBox.shrink(),
          data: (ArticleState a) => ArticleCard(
            state: a,
            onOpen: () => _openArticle(context, ref, a),
            onCopy: () => _copyArticle(context, ref, a),
            onMarkPublished: () =>
                ref.read(articleControllerProvider.notifier).markPublished(),
            onNameNewsletter: () => _nameNewsletter(context, ref, a),
          ),
        ),

        // The week at a glance, before the day-by-day. The reference opens its
        // Training screen the same way: two readings side by side, then the
        // list underneath. Both numbers here are counted off `plan`, and the
        // wedge draws the same ratio the first one states.
        SizedBox(height: ZaveSpace.xl),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: _tileWidth,
                  child: ZaveStatCard(
                    label: 'Published',
                    sublabel: 'this week',
                    value: '${plan.publishedCount}',
                    unit: 'of ${plan.liveSlotCount}',
                    chart: plan.liveSlotCount == 0
                        ? null
                        : ZaveAreaWedge(
                            progress: plan.publishedCount / plan.liveSlotCount,
                          ),
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                SizedBox(
                  width: _tileWidth,
                  child: ZaveStatCard(
                    label: 'Week',
                    sublabel: plan.phase ?? 'of the season',
                    value: '${plan.weekNumber}',
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: ZaveSpace.xxl),
        ZaveSectionHeader(
          title: 'The week',
          actionLabel: '${plan.publishedCount}/${plan.liveSlotCount} published',
          onTap: () {},
        ),
        SizedBox(height: ZaveSpace.lg),

        for (int i = 0; i < plan.posts.length; i++) ...<Widget>[
          SlotCard(
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
          SizedBox(height: ZaveSpace.md),
        ],
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

  void _openSlot(BuildContext context, PlanSlot slot, int slotIndex) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) =>
          _SlotSheet(slot: slot, slotIndex: slotIndex),
    );
  }

  /// The body, fetched when it is actually needed.
  ///
  /// The summary does not carry it — it was ninety percent of that response
  /// for text the card never shows. Returns null if the fetch fails, and the
  /// caller says so rather than opening an empty sheet or silently copying
  /// nothing.
  Future<String?> _articleBody(WidgetRef ref, ArticleState a) async {
    if (a.article!.hasBody) return a.article!.body;
    try {
      return await ref
          .read(plannerRepositoryProvider)
          .fetchArticleBody(week: a.weekNumber, season: a.season);
    } on Object {
      return null;
    }
  }

  Future<void> _openArticle(
    BuildContext context,
    WidgetRef ref,
    ArticleState a,
  ) async {
    if (a.article == null) return;
    final String? body = await _articleBody(ref, a);
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
    final String? body = await _articleBody(ref, a);
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
    final int week = plan?.weekNumber ?? state.currentWeekNumber;
    final int season = plan?.season ?? 1;
    // Null means "whatever the server calls now" — so a pinned week is the
    // only way to know the user has navigated away from it.
    final bool browsing = ref.watch(plannerWeekProvider).week != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
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
        SizedBox(height: ZaveSpace.lg),
        Row(
          children: <Widget>[
            ZaveButton(
              label: 'Previous',
              icon: const Icon(Icons.chevron_left),
              // Week 1 is the floor — there is no week 0 to fetch, and a
              // disabled control says that better than an error would.
              onPressed: week <= 1
                  ? null
                  : () => ref
                        .read(plannerWeekProvider.notifier)
                        .show(week - 1, season),
            ),
            SizedBox(width: ZaveSpace.sm),
            ZaveButton(
              label: 'Next',
              trailing: const Icon(Icons.chevron_right),
              onPressed: () =>
                  ref.read(plannerWeekProvider.notifier).show(week + 1, season),
            ),
            if (browsing) ...<Widget>[
              SizedBox(width: ZaveSpace.md),
              ZaveButton(
                label: 'This week',
                onPressed: () =>
                    ref.read(plannerWeekProvider.notifier).showCurrent(),
              ),
            ],
          ],
        ),
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
class _SlotSheet extends ConsumerStatefulWidget {
  const _SlotSheet({required this.slot, required this.slotIndex});

  final PlanSlot slot;
  final int slotIndex;

  @override
  ConsumerState<_SlotSheet> createState() => _SlotSheetState();
}

class _SlotSheetState extends ConsumerState<_SlotSheet> {
  bool _busy = false;
  bool _titleBusy = false;
  bool _scriptBusy = false;

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

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
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
    // The sheet holds a snapshot of the slot, so the new title lands on the
    // week behind it rather than here. Closing is the honest move — leaving
    // a stale title on screen after a successful rewrite reads as a no-op.
    if (failure == null) {
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failure, style: ZaveType.body)));
  }

  PlanSlot get slot => widget.slot;

  /// Nothing written yet — the day is a title and an angle and no post.
  /// Only a post day has anything to generate.
  ///
  /// `isPublishable` first, because the server refuses the other five days
  /// with NOT_A_POST_DAY and a button that can only ever fail is worse than no
  /// button — the user spends a tap and a round trip to be told no.
  bool get _canGenerate =>
      slot.isPublishable &&
      slot.postId == null &&
      slot.status != SlotStatus.generating;

  /// A draft exists and can be thrown away for a different one. Never once it
  /// is on LinkedIn: there is nothing to replace at that point.
  bool get _canRegenerate =>
      slot.isPublishable &&
      slot.postId != null &&
      slot.status != SlotStatus.generating &&
      slot.status != SlotStatus.published;

  Future<void> _run({required bool force}) async {
    if (force) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text('Write it again?'),
          content: const Text(
            'This replaces the current draft with a new one and costs XP. '
            'The old draft is deleted.',
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(note, style: ZaveType.body)));
  }

  @override
  Widget build(BuildContext context) {
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
        Text(slot.title, style: ZaveType.h2),
        // Free, so no confirm — and it clears the server's
        // `titleEditedByUser`, which is what stops a later regenerate from
        // quietly overwriting a title someone typed by hand.
        if (slot.status != SlotStatus.published) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Align(
            alignment: Alignment.centerLeft,
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
        // The planner's primary action. Without it this sheet was a read-only
        // description of a day the user could do nothing about.
        if (_canGenerate || _canRegenerate) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          if (_canGenerate)
            ZaveButton.primary(
              label: slot.format == 'carousel'
                  ? 'Build this carousel'
                  : 'Write this post',
              expand: true,
              busy: _busy,
              onPressed: _busy ? null : () => _run(force: false),
            )
          else
            ZaveButton(
              label: slot.format == 'carousel'
                  ? 'Build it again'
                  : 'Write it again',
              expand: true,
              busy: _busy,
              onPressed: _busy ? null : () => _run(force: true),
            ),
        ],
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
