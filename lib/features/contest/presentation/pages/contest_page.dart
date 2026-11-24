import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../application/contest_controllers.dart';
import '../../application/contest_home_controllers.dart';
import '../../domain/contest_dates.dart';
import '../../domain/contest_repository.dart';
import '../../domain/levels_words.dart';
import '../../../placement/presentation/widgets/placement_level_hint.dart';
import '../widgets/contest_board_view.dart';
import '../widgets/contest_kit.dart';
import '../widgets/contest_section_bar.dart';
import '../widgets/contest_skeletons.dart';
import '../widgets/featured/hall_of_fame.dart';
import '../widgets/featured/learners_of_the_week.dart';
import '../widgets/featured/shoutout_card.dart';
import '../widgets/name_on_board_card.dart';
import '../widgets/path/path_view.dart';
import '../widgets/paused_notice.dart';
import '../widgets/rail/consistency_card.dart';
import '../widgets/rail/daily_quests.dart';
import '../widgets/rail/mini_board.dart';
import '../widgets/rail/prize_card.dart';
import '../widgets/rail/week_tasks_card.dart';
import '../widgets/roadmap_line.dart';
import '../widgets/stats_bar.dart';
import '../widgets/web_link.dart';

/// `/contest` — the learner's levels: the day's path, XP and the top
/// learners. The signed-in home. A port of the web's `ContestClient.tsx`
/// (`/levels`).
///
/// Owner, 24 Nov 2026: learners are never told about a contest. There is no
/// join card and no contest page — the home is the Duolingo-style level path
/// (Level 1, Level 2 …), and the levels reset every three months, a new
/// round. The mechanics are unchanged; only the words and the way in moved.
///
/// ## The states
///
///   * Loading → the running page's own shape ([ContestDashboardSkeleton]):
///     most visitors are entered and the round is running.
///   * Failed → said in words, with Plexa fixing it with a wrench.
///   * No round, or one that ENDED → "New levels are on the way": rounds run
///     back to back and the next starts on its own, so this shows only when
///     automatic rounds are switched off. Never the ended round's standings
///     as a page of their own: its result is the Hall of Fame card.
///   * Entered, round running → the path, then the rail's cards and the full
///     board, under a small section bar that jumps between them.
///   * Entered, round not started yet → when Level 1 opens.
///   * Running or upcoming with no entry → entering failed on the server (it
///     never throws; it logs). A pull, or "Try again", reads again, which
///     retries it.
///   * Every state → the Hall of Fame (a finalised round's consenting top
///     learners, for 30 days), and the way to the published rules.
///
/// ## No join step
///
/// Reading is joining: `GET /contest` enters the learner in the running
/// round, anonymously, before it answers — the app is never refused for an
/// 18+ declaration. Their name is shown to other learners only once they
/// switch "Show my name to other learners" on ([NameOnBoardCard]) — here or
/// in Settings. Never assumed.
///
/// ## The shoutout (owner, 22 Nov 2026: the prize is a profile shoutout)
///
/// An entered learner gets the "Feature me if I make it" card — the
/// `contest_shoutout` consent, un-ticked until they agree; so does a winner
/// of a round whose Hall of Fame is showing, in every state. A running
/// learner who has finished today's lesson also gets "Learners of the week",
/// above the full board: never a level, never inside one, and with no XP,
/// rank or order — the server sends none.
///
/// ## Two reads, one owner each
///
/// The overview owns who the learner is in the round — XP, rank, streak. The
/// path owns what the week holds and where each level stands. Neither
/// restates the other, so the stats bar and the path cannot disagree about a
/// figure.
///
/// ## The roadmap stays the bigger goal
///
/// The levels are an overlay on the 1000-day roadmap, not a replacement for
/// it. One quiet line at the foot of every state says so ([RoadmapLine]).
///
/// ## Plexa at phone width
///
/// The web hides every moment below 640px, and the app is all phone; copied
/// literally, the page would show none. They are shown here — each is
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
    // No round, or one that ended with no next one yet (automatic rounds
    // switched off). Its result is the Hall of Fame card, never a page.
    if (overview == null || overview.isEnded) {
      return _Quiet(
        children: <Widget>[
          const _Empty(
            title: 'New levels are on the way',
            line:
                'Levels reset every $kRoundMonths months, and the next round '
                'starts soon. Your roadmap carries on as usual.',
          ),
          const _WinnerShoutout(padding: EdgeInsets.only(top: 40)),
          const HallOfFame(padding: EdgeInsets.only(top: 40)),
          SizedBox(height: ZaveSpace.xxl),
          const ContestRulesLine(),
        ],
      );
    }
    final ContestEntryView? entry = overview.entry;
    if (entry != null && overview.isRunning) {
      return _Running(overview: overview, entry: entry);
    }
    if (entry != null) {
      return _Quiet(
        children: <Widget>[_Upcoming(overview: overview, entry: entry)],
      );
    }
    // Running or upcoming and still no entry: entering failed on the server.
    // Reading again retries it.
    return const _Quiet(
      children: <Widget>[
        _Empty(
          title: 'Your levels are not ready yet',
          line: 'We could not open your levels just now.',
          retry: true,
        ),
        _WinnerShoutout(padding: EdgeInsets.only(top: 40)),
        HallOfFame(padding: EdgeInsets.only(top: 40)),
      ],
    );
  }
}

/// The "Feature me" card outside a running round — only for a winner of a
/// round whose Hall of Fame is showing (`viewerPlaced`). A result is fixed
/// after its results week, when this page has usually moved on to the next
/// round, and the shoutout is only theirs if they say yes. The web's
/// `WinnerShoutout`.
class _WinnerShoutout extends ConsumerWidget {
  const _WinnerShoutout({this.padding = EdgeInsets.zero});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool placed =
        ref.watch(contestFeaturedProvider).value?.viewerPlaced ?? false;
    if (!placed) return const SizedBox.shrink();
    return ShoutoutCard(padding: padding);
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

/// "Could not load your levels", with Plexa and her wrench.
class _LoadFailed extends ConsumerWidget {
  const _LoadFailed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FailurePanel(
      title: 'Could not load your levels',
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

/// No round to show — none running, or one that ended with no next one —
/// or an entry the server could not make. Plexa scans the horizon for the
/// next.
class _Empty extends ConsumerWidget {
  const _Empty({required this.title, required this.line, this.retry = false});

  final String title;
  final String line;

  /// Offer "Try again": reading the overview again is what enters them.
  final bool retry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        Text(line, style: ContestType.lead),
        if (retry) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          ContestGhostPill(
            label: 'Try again',
            onPressed: () => unawaited(_refresh(ref)),
          ),
        ],
        SizedBox(height: ZaveSpace.lg),
        const RoadmapLine(),
      ],
    );
  }
}

/// Entered, and the round has not started yet: when Level 1 opens. The
/// web's `Upcoming`.
class _Upcoming extends ConsumerStatefulWidget {
  const _Upcoming({required this.overview, required this.entry});

  final ContestOverview overview;
  final ContestEntryView entry;

  @override
  ConsumerState<_Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends ConsumerState<_Upcoming> {
  /// When this page was opened — what "just entered" is measured against, as
  /// the web measures it once per visit.
  final DateTime _openedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ContestOverview overview = widget.overview;
    final ContestInfo contest = overview.contest;
    final ContestMoment? moment = quietMoment(overview, _openedAt);
    final ConsistencyView? meter = watchConsistency(ref);
    final String opens = dayKeyShort(contest.firstDayKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (moment != null) ...<Widget>[
          Center(child: PlexaMoment(_clipFor(moment), width: 200)),
          SizedBox(height: ZaveSpace.lg),
        ],
        ContestKicker('Opens $opens'),
        SizedBox(height: ZaveSpace.md),
        Semantics(
          header: true,
          child: Text('Your levels', style: ContestType.pageTitle),
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Level 1 opens on $opens. You are in: there is nothing to join.',
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
            ),
          ),
        ),
        // The web's max-w-[600px]: a consent card should not stretch to a
        // tablet's full width.
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ShoutoutCard(padding: EdgeInsets.only(top: ZaveSpace.xxl)),
                NameOnBoardCard(padding: EdgeInsets.only(top: ZaveSpace.xxl)),
              ],
            ),
          ),
        ),
        HallOfFame(padding: EdgeInsets.only(top: ZaveSpace.xxl)),
        SizedBox(height: ZaveSpace.xxl),
        const ContestRulesLine(),
        SizedBox(height: ZaveSpace.md),
        const RoadmapLine(),
      ],
    );
  }
}

/// A running learner's page: the stats, the path, the rail's cards and the
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
                      ] else if (entry.freeDaysLeft > 0) ...<Widget>[
                        // The paid condition, said before the XP it governs
                        // (the web's FreeDaysLine): an auto-entered learner
                        // never saw onboarding's step or a join card.
                        SizedBox(height: ZaveSpace.gutter),
                        Text(
                          freeDaysLine(entry.freeDaysLeft),
                          key: const ValueKey<String>('free-days-line'),
                          style: ContestType.meta.copyWith(height: 1.6),
                        ),
                      ],
                      // The placement nudge used to sit on the join card;
                      // with no join step it sits over the path. Nothing
                      // once the learner is placed.
                      PlacementLevelHint(
                        padding: EdgeInsets.only(top: ZaveSpace.gutter),
                      ),
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
                          title: 'Your levels',
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
                      // The week's featured learners — after today's lesson
                      // only, which the server decides; nothing before it.
                      LearnersOfTheWeek(
                        padding: EdgeInsets.only(bottom: ZaveSpace.xxl),
                      ),
                      KeyedSubtree(
                        key: _anchors[ContestSection.leaderboard],
                        child: ContestBoardView(
                          entrants: overview.entrants,
                          rewardTopN: contest.rewardTopN,
                          rewardMonths: contest.rewardMonths,
                        ),
                      ),
                      NameOnBoardCard(
                        padding: EdgeInsets.only(top: ZaveSpace.xxl),
                      ),
                      ShoutoutCard(
                        padding: EdgeInsets.only(top: ZaveSpace.xxl),
                      ),
                      HallOfFame(padding: EdgeInsets.only(top: ZaveSpace.xxl)),
                      SizedBox(height: ZaveSpace.xxl),
                      const ContestRulesLine(),
                      SizedBox(height: ZaveSpace.md),
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
