import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../application/contest_controllers.dart';
import '../../application/contest_home_controllers.dart';
import '../../domain/contest_dates.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import '../widgets/contest_board_view.dart';
import '../widgets/contest_join_card.dart';
import '../widgets/contest_kit.dart';
import '../widgets/contest_section_bar.dart';
import '../widgets/contest_skeletons.dart';
import '../widgets/path/path_view.dart';
import '../widgets/paused_notice.dart';
import '../widgets/rail/consistency_card.dart';
import '../widgets/rail/daily_quests.dart';
import '../widgets/rail/mini_board.dart';
import '../widgets/rail/prize_card.dart';
import '../widgets/rail/week_tasks_card.dart';
import '../widgets/roadmap_line.dart';
import '../widgets/stats_bar.dart';

/// `/contest` — the Business English contest, for one participant. The
/// signed-in home. A port of the web's `ContestClient.tsx`.
///
/// ## The states
///
///   * Loading → the running page's own shape ([ContestDashboardSkeleton]):
///     most visitors are running entrants.
///   * Failed → said in words, with Plexa fixing it with a wrench.
///   * No contest → "No contest right now", and the way back to the roadmap.
///   * Not joined, contest over → "This contest has ended": no join card
///     (joining a finished contest would only be refused) and no board,
///     whose names were shared with participants only.
///   * Not joined → the join card.
///   * Joined, before day 1 or after the last → the quiet page: the header,
///     the standing and the board — the final standings, on winner day.
///   * Joined and running → the path, then the prize, the board preview,
///     today's quests, the week's LinkedIn tasks and the full board, under a
///     small section bar that jumps between them.
///
/// ## Two reads, one owner each
///
/// The overview owns who the learner is in the contest — XP, rank, streak,
/// the prize. The path owns what the week holds and where each level
/// stands. Neither restates the other, so the stats bar and the path cannot
/// disagree about a figure, and the path is only read for a running
/// entrant: a join card has no week to draw.
///
/// ## The roadmap stays the bigger goal
///
/// The contest is an overlay on the 1000-day roadmap, not a replacement for
/// it. One quiet line at the foot of every state says so ([RoadmapLine]).
///
/// ## Plexa at phone width
///
/// The web hides every moment below 640px, and the app is all phone; copied
/// literally, the contest would show none. They are shown here — each is
/// decoration, and the screen always says in words what it means.
class ContestPage extends ConsumerWidget {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-reads the standing and the path whenever the app comes back to the
    // foreground: an approval or an audit reaches the learner no other way.
    ref.watch(contestResumeRefreshProvider);
    final AsyncValue<ContestOverview?> overview = ref.watch(
      contestOverviewProvider,
    );

    // A value being re-read is still a value: a pull to refresh must not
    // blank the page to its skeleton and rebuild the path under it.
    final Widget body;
    if (overview.hasValue) {
      body = _forOverview(overview.value);
    } else if (overview.hasError) {
      body = _Quiet(children: <Widget>[_LoadFailed(error: overview.error!)]);
    } else {
      body = const _Quiet(
        maxWidth: _runningWidth,
        children: <Widget>[ContestDashboardSkeleton()],
      );
    }

    return ContestGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(bottom: false, child: body),
      ),
    );
  }

  Widget _forOverview(ContestOverview? overview) {
    if (overview == null) {
      return const _Quiet(
        children: <Widget>[_Empty(title: 'No contest right now')],
      );
    }
    final ContestEntryView? entry = overview.entry;
    if (entry != null && overview.isRunning) {
      return _Running(overview: overview, entry: entry);
    }
    if (entry != null) {
      return _Quiet(
        children: <Widget>[_JoinedQuiet(overview: overview, entry: entry)],
      );
    }
    if (overview.isEnded) {
      return const _Quiet(
        children: <Widget>[_Empty(title: 'This contest has ended')],
      );
    }
    return _Quiet(
      children: <Widget>[
        ContestJoinCard(overview: overview),
        SizedBox(height: ZaveSpace.xxl),
        RoadmapLine(lastDayKey: overview.contest.lastDayKey),
      ],
    );
  }
}

/// The running page's column: the web's centre column, 600 wide at most.
const double _runningWidth = 600;

/// The quiet pages' frame.
const double _quietWidth = 960;

/// Pull to refresh, on every state: the web's `refreshStanding`, and then
/// the overview it waits on.
Future<void> _refresh(WidgetRef ref) async {
  refreshContestStanding(ref.invalidate);
  try {
    await ref.read(contestOverviewProvider.future);
  } on Object {
    // The page draws the failure; the spinner only has to stop.
  }
}

/// The scrolling frame of every state but the running one.
class _Quiet extends ConsumerWidget {
  const _Quiet({required this.children, this.maxWidth = _quietWidth});

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: ZaveColors.white,
      backgroundColor: ZaveColors.deep,
      onRefresh: () => _refresh(ref),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          ZaveSpace.gutter,
          ZaveSpace.xl,
          ZaveSpace.gutter,
          // Clears the shell's More and Write buttons.
          ZaveSpace.section,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

PlexaMomentClip _clipFor(ContestMoment moment) => switch (moment) {
  ContestMoment.joined => PlexaMomentClip.contestJoined,
  ContestMoment.streakReset => PlexaMomentClip.streakReset,
  ContestMoment.streakFlame => PlexaMomentClip.streakFlame,
  ContestMoment.finale => PlexaMomentClip.contestFinale,
};

/// "Could not load the contest", with Plexa and her wrench.
class _LoadFailed extends ConsumerWidget {
  const _LoadFailed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FailurePanel(
      title: 'Could not load the contest',
      message: contestMessage(error),
      onRetry: () => unawaited(_refresh(ref)),
    );
  }
}

/// A read that failed: the dot and its word, the sentence, a way to try
/// again, and Plexa mending it. The web says "refresh the page"; a phone
/// has no page to refresh, so the button does it — and a pull still does.
class _FailurePanel extends StatelessWidget {
  const _FailurePanel({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      padding: EdgeInsets.all(ZaveSpace.xl),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ContestDot(tone: ContestTone.idle, label: title),
                SizedBox(height: ZaveSpace.sm),
                Text(message, style: ContestType.meta),
                SizedBox(height: ZaveSpace.lg),
                ContestGhostPill(label: 'Try again', onPressed: onRetry),
              ],
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          const PlexaMoment(PlexaMomentClip.oopsWrench, width: 120),
        ],
      ),
    );
  }
}

/// No contest to show: none running, or one that ended without the
/// learner. Plexa scans the horizon for the next.
class _Empty extends StatelessWidget {
  const _Empty({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
          child: PlexaMoment(PlexaMomentClip.waitingRoom, width: 200),
        ),
        SizedBox(height: ZaveSpace.lg),
        Semantics(
          header: true,
          child: Text(title, style: ContestType.pageTitle),
        ),
        SizedBox(height: ZaveSpace.lg),
        Text(
          'The next one will show up here. Your lessons and your roadmap '
          'carry on as usual.',
          style: ContestType.lead,
        ),
        SizedBox(height: ZaveSpace.lg),
        const RoadmapLine(),
      ],
    );
  }
}

/// Joined, but not running: before day 1, or after the last day — the final
/// standings.
class _JoinedQuiet extends ConsumerStatefulWidget {
  const _JoinedQuiet({required this.overview, required this.entry});

  final ContestOverview overview;
  final ContestEntryView entry;

  @override
  ConsumerState<_JoinedQuiet> createState() => _JoinedQuietState();
}

class _JoinedQuietState extends ConsumerState<_JoinedQuiet> {
  /// When this page was opened — what "just joined" is measured against, as
  /// the web measures it once per visit.
  final DateTime _openedAt = DateTime.now();

  /// The meter's card, for the stats bar's figure to bring into view — the
  /// web's `#consistency`, a link on this page too.
  final GlobalKey _consistencyAnchor = GlobalKey(
    debugLabel: 'contest-quiet-consistency',
  );

  void _revealConsistency() {
    final BuildContext? target = _consistencyAnchor.currentContext;
    if (target == null) return;
    final bool still = MediaQuery.disableAnimationsOf(context);
    unawaited(
      Scrollable.ensureVisible(
        target,
        duration: still ? Duration.zero : const Duration(milliseconds: 400),
        curve: ZaveMotion.curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ContestOverview overview = widget.overview;
    final ContestInfo contest = overview.contest;
    final ContestMoment? moment = quietMoment(overview, _openedAt);
    final ConsistencyView? meter = watchConsistency(ref);
    final String months = plural(contest.rewardMonths, 'month', 'months');
    final String reward =
        'The top ${formatCount(contest.rewardTopN)} get $months free for the '
        'next contest.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (moment != null) ...<Widget>[
          Center(child: PlexaMoment(_clipFor(moment), width: 200)),
          SizedBox(height: ZaveSpace.lg),
        ],
        ContestKicker(
          overview.isEnded
              ? 'Ended'
              : 'Starts ${dayKeyShort(contest.firstDayKey)}',
        ),
        SizedBox(height: ZaveSpace.md),
        Semantics(
          header: true,
          child: Text(contest.title, style: ContestType.pageTitle),
        ),
        SizedBox(height: ZaveSpace.md),
        // "For first place" reads as a promise still open once it is
        // settled, so a finished contest says who it goes to.
        Text(
          overview.isEnded
              ? 'Final standings. ${contest.prizeTitle} goes to first place. '
                    '$reward'
              : '${contest.prizeTitle} for first place. $reward',
          style: ContestType.lead,
        ),
        SizedBox(height: ZaveSpace.xxl),
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: StatsBar(
              streak: widget.entry.streak,
              total: widget.entry.total,
              rank: widget.entry.rank,
              consistency: meter?.figure,
              onConsistencyTap: _revealConsistency,
            ),
          ),
        ),
        // The meter, when it has something to say — before day 1 it is
        // no_contest and shows nothing; after the end it still counts the
        // contest's days in this billing window.
        if (meter != null && !meter.state.isHidden) ...<Widget>[
          SizedBox(height: ZaveSpace.xxl),
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: KeyedSubtree(
                key: _consistencyAnchor,
                child: const ConsistencyCard(),
              ),
            ),
          ),
        ],
        SizedBox(height: ZaveSpace.xxl),
        ContestBoardView(
          entrants: overview.entrants,
          rewardTopN: contest.rewardTopN,
          rewardMonths: contest.rewardMonths,
        ),
        SizedBox(height: ZaveSpace.xxl),
        RoadmapLine(lastDayKey: contest.lastDayKey),
      ],
    );
  }
}

/// A running entrant's page: the stats, the path, the rail's cards and the
/// full board, in one scroll under the section bar.
class _Running extends ConsumerStatefulWidget {
  const _Running({required this.overview, required this.entry});

  final ContestOverview overview;
  final ContestEntryView entry;

  @override
  ConsumerState<_Running> createState() => _RunningState();
}

class _RunningState extends ConsumerState<_Running> {
  /// Where each section starts, for the section bar to bring it to the top.
  final Map<ContestSection, GlobalKey> _anchors = <ContestSection, GlobalKey>{
    for (final ContestSection s in ContestSection.values)
      s: GlobalKey(debugLabel: 'contest-${s.name}'),
  };

  /// When this page was opened — what "just joined" is measured against.
  final DateTime _openedAt = DateTime.now();

  /// The consistency meter's card, for the stats bar's figure to bring into
  /// view — the web's `#consistency`. Not a section-bar stop: the web's
  /// tabs have none either.
  final GlobalKey _consistencyAnchor = GlobalKey(
    debugLabel: 'contest-consistency',
  );

  void _goTo(ContestSection section) =>
      _reveal(_anchors[section]?.currentContext);

  void _reveal(BuildContext? target) {
    if (target == null) return;
    final bool still = MediaQuery.disableAnimationsOf(context);
    unawaited(
      Scrollable.ensureVisible(
        target,
        duration: still ? Duration.zero : const Duration(milliseconds: 400),
        curve: ZaveMotion.curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ContestOverview overview = widget.overview;
    final ContestInfo contest = overview.contest;
    final ContestEntryView entry = widget.entry;
    final AsyncValue<ContestPath> path = ref.watch(contestPathProvider);
    final LessonProgress? lesson = lessonProgressOf(
      ref.watch(todayQuizProvider).value,
    );
    final ContestMoment? moment = runningMoment(entry, _openedAt);
    final ConsistencyView? meter = watchConsistency(ref);

    // The rail's cards read the path only when it says running; loading,
    // failed or briefly out of step with the overview, they say so in
    // words rather than drawing an empty week.
    final ContestPath? week = path.value;
    final ContestPath? ready = week?.status == ContestPathStatus.running
        ? week
        : null;
    final bool pathLoading = !path.hasValue && !path.hasError;
    const String waiting = 'This week is not in yet.';

    return Column(
      children: <Widget>[
        ContestSectionBar(onSelect: _goTo),
        Expanded(
          child: RefreshIndicator(
            color: ZaveColors.white,
            backgroundColor: ZaveColors.deep,
            onRefresh: () => _refresh(ref),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.gutter,
                ZaveSpace.gutter,
                ZaveSpace.gutter,
                ZaveSpace.section,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _runningWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StatsBar(
                        streak: entry.streak,
                        total: entry.total,
                        rank: entry.rank,
                        dayNumber: overview.dayNumber,
                        consistency: meter?.figure,
                        onConsistencyTap: () =>
                            _reveal(_consistencyAnchor.currentContext),
                      ),
                      if (entry.scoringPaused) ...<Widget>[
                        SizedBox(height: ZaveSpace.gutter),
                        PausedNotice(freeDays: contest.freeDays),
                      ],
                      if (moment != null) ...<Widget>[
                        SizedBox(height: ZaveSpace.gutter),
                        Center(
                          child: PlexaMoment(_clipFor(moment), width: 180),
                        ),
                      ],
                      SizedBox(height: ZaveSpace.gutter),
                      KeyedSubtree(
                        key: _anchors[ContestSection.path],
                        child: _PathArea(
                          path: path,
                          title: contest.title,
                          lesson: lesson,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xxl),
                      // The rail's first card, as on the web; nothing at all
                      // while it loads, fails or has nothing to say.
                      if (meter != null && !meter.state.isHidden) ...<Widget>[
                        KeyedSubtree(
                          key: _consistencyAnchor,
                          child: ConsistencyCard(path: ready),
                        ),
                        SizedBox(height: ZaveSpace.cardGap),
                      ],
                      PrizeCard(contest: contest),
                      SizedBox(height: ZaveSpace.cardGap),
                      MiniBoard(
                        rewardTopN: contest.rewardTopN,
                        onViewAll: () => _goTo(ContestSection.leaderboard),
                      ),
                      SizedBox(height: ZaveSpace.cardGap),
                      KeyedSubtree(
                        key: _anchors[ContestSection.quests],
                        child: DailyQuests(
                          quests: ready == null
                              ? const <Quest>[]
                              : questsFor(ready.today, lesson),
                          emptyNote: ready == null ? waiting : null,
                          loading: pathLoading,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.cardGap),
                      KeyedSubtree(
                        key: _anchors[ContestSection.linkedIn],
                        child: WeekTasksCard(
                          days: ready?.days ?? const <PathDay>[],
                          claims: ready?.claims ?? const <PostClaim>[],
                          emptyNote: ready == null ? waiting : null,
                          loading: pathLoading,
                        ),
                      ),
                      const SizedBox(height: 40),
                      KeyedSubtree(
                        key: _anchors[ContestSection.leaderboard],
                        child: ContestBoardView(
                          entrants: overview.entrants,
                          rewardTopN: contest.rewardTopN,
                          rewardMonths: contest.rewardMonths,
                        ),
                      ),
                      SizedBox(height: ZaveSpace.xxl),
                      RoadmapLine(lastDayKey: contest.lastDayKey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The path, or what stands in for it: its skeleton while the week loads,
/// the failure in words, or — when the overview says running and the path
/// does not, the day having turned over between the two reads — a line
/// saying so rather than an empty path.
class _PathArea extends ConsumerWidget {
  const _PathArea({
    required this.path,
    required this.title,
    required this.lesson,
  });

  final AsyncValue<ContestPath> path;
  final String title;
  final LessonProgress? lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ContestPath? week = path.value;
    if (week == null && path.hasError) {
      return _FailurePanel(
        title: 'Could not load this week',
        message: contestMessage(path.error!),
        onRetry: () => ref.invalidate(contestPathProvider),
      );
    }
    if (week == null) return const PathSkeleton();
    if (!week.hasWeek) {
      return Text(
        'This week’s path is not ready yet. Refresh in a moment.',
        style: ContestType.meta,
      );
    }
    return PathView(path: week, title: title, lesson: lesson);
  }
}
