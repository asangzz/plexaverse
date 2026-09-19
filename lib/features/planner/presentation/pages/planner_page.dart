import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/planner_controller.dart';
import '../../domain/plan_slot.dart';
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

    return ZaveScaffold(
      title: 'Plan',
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(plannerControllerProvider);
          ref.invalidate(articleControllerProvider);
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
            ref: ref,
          ),
        ),
      ),
    );
  }
}

class _PlannerBody extends StatelessWidget {
  const _PlannerBody({
    required this.state,
    required this.article,
    required this.ref,
  });

  final PlannerState state;
  final AsyncValue<ArticleState> article;
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
            onOpen: () => _openArticle(context, a),
            onMarkPublished: () =>
                ref.read(articleControllerProvider.notifier).markPublished(),
          ),
        ),

        SizedBox(height: ZaveSpace.xxl),
        Row(
          children: <Widget>[
            Text('THE WEEK', style: ZaveType.kicker),
            const Spacer(),
            Text(
              '${plan.publishedCount}/${plan.liveSlotCount} published',
              style: ZaveType.caption.copyWith(color: ZaveColors.mint),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),

        for (int i = 0; i < plan.posts.length; i++) ...<Widget>[
          SlotCard(
            slot: plan.posts[i],
            isToday: plan.posts[i].day == today,
            onTap: () => _openSlot(context, plan.posts[i]),
            onApprove: plan.posts[i].needsApproval
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
    final ApproveResult? result =
        await ref.read(plannerControllerProvider.notifier).approve(index);
    if (!context.mounted) return;

    final String message;
    if (result == null) {
      message = "That didn't go through. Try again.";
    } else if (result.scheduledFor != null) {
      message = 'Approved — publishing ${_whenLabel(result.scheduledFor!)}.';
    } else if (result.postUpdated) {
      message = "Approved. That slot's time has passed, so publish it "
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
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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

  void _openSlot(BuildContext context, PlanSlot slot) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _SlotSheet(slot: slot),
    );
  }

  void _openArticle(BuildContext context, ArticleState a) {
    if (a.article == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _ArticleSheet(article: a.article!),
    );
  }
}

/// The week header.
///
/// The web renders this as a PAIR rather than two stacked bars (commit
/// b4d9f1b) — the week/phase on one side and the topic on the other, reading as
/// one object.
class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.state, required this.plan});

  final PlannerState state;
  final WeekPlan? plan;

  @override
  Widget build(BuildContext context) {
    final String? topic = plan?.topic ?? state.upcomingTopic;
    final String? phase = plan?.phase ?? state.upcomingPhase;
    final int week = plan?.weekNumber ?? state.currentWeekNumber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text('Week $week', style: ZaveType.h2),
            SizedBox(width: ZaveSpace.sm),
            Text('planner', style: plannerSerif(size: 26, color: ZaveColors.peri)),
          ],
        ),
        if (phase != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(phase.toUpperCase(), style: ZaveType.kicker),
        ],
        if (topic != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(topic, style: ZaveType.lead),
        ],
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
            state.upcomingTitle ?? state.upcomingTopic ?? 'This week is planned',
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
class _SlotSheet extends StatelessWidget {
  const _SlotSheet({required this.slot});

  final PlanSlot slot;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label}) signal = slotSignal(slot);

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
        Text('SUNDAY ARTICLE', style: ZaveType.kicker),
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
