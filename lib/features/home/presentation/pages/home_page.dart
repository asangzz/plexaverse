import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_destinations.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/application/preferences_controller.dart';
import '../../../missions/application/journey_controller.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/connections_controller.dart';
import '../../application/home_controllers.dart';
import '../../domain/levels_finished.dart';
import '../../domain/roadmap_level.dart';
import '../../domain/roadmap_progress.dart';
import '../widgets/connection_checkpoint.dart';
import '../widgets/home_states.dart';
import '../widgets/roadmap_timeline.dart';

/// **The roadmap** — the web's `/roadmap`, "LinkedIn Personal Branding
/// Roadmap".
///
/// Still called `HomePage` because it was home until the contest took that
/// place (web, 11 Nov 2026); the router decides where it is mounted, and
/// renaming the class would only move that decision into a diff.
///
/// The 1000-day journey's planet timeline over a sheet of check-ins, at the
/// user's day of their CURRENT journey. There is one mode. The old Season 2
/// "black hole" loop is gone from the product, and a user on journey 2 or
/// later is simply at their own roadmap day on the same view.
///
/// **It hands out no daily missions** (web, 12 Nov 2026). The day's comment,
/// connection and post moved to the levels' daily path, so the "Open Plexa"
/// day chat and the missions panel are gone and a day row opens nothing. Each
/// row behind today, and today, says how much of that day's levels was
/// finished instead (25 Nov 2026).
///
/// **The sheet asks for connections only** (web, 25 Nov 2026): the weekly
/// connection count. The follower card left it; `FollowerCheckpoint` is kept,
/// unrendered, until the owner decides to delete it.
///
/// Day 1000 is a finish line. When the journey is finished this screen still
/// renders normally, and offers the journey-complete screen once per app
/// session on top of it — see [_JourneyFinishLine].
///
/// There is deliberately **no stat grid and no recent-posts list**. The web
/// used to fire an eight-query dashboard fetch here whose result was never
/// drawn, and blocked first paint on it; it was removed, and re-adding one on
/// mobile would re-import the same mistake. What this screen asks the server
/// for is the roadmap, the levels finished per day, the preferences and the
/// connections check-in — nothing else.
///
/// The wallet XP pill that sat in the top-right corner is gone with wallet XP
/// itself: the plan pays for AI features now, and "XP" means only the contest
/// score, which lives on the contest screens.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // No header: the timeline runs to the top of the screen the way it was
    // drawn to.
    return const ZaveScaffold(body: _JourneyFinishLine(child: _HomeBody()));
  }
}

/// Owns every loading and error state on this screen.
///
/// Built as its own widget rather than inline in [HomePage] so that
/// [ZaveScaffold.contentTop] resolves: the inset is published *below* the
/// scaffold, and a screen that reads it from its own `build` silently gets the
/// status-bar height instead and renders its first line under the header.
class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double topInset = ZaveScaffold.contentTop(context);
    final AsyncValue<UserPreferences> prefs = ref.watch(
      preferencesControllerProvider,
    );

    // A value that is being refreshed is still a value. `when` treats any
    // loading as "nothing to show", so every preferences invalidation used to
    // blank the whole screen to a skeleton and rebuild the timeline under it.
    if (prefs.hasValue) return _JourneyBody(topInset: topInset);

    return prefs.when(
      loading: () => HomeSkeleton(topInset: topInset),
      error: (Object _, StackTrace _) => HomeError(
        topInset: topInset,
        onRetry: () => ref.invalidate(preferencesControllerProvider),
      ),
      data: (UserPreferences _) => _JourneyBody(topInset: topInset),
    );
  }
}

/// Offers the journey-complete screen once per app session when the journey
/// is finished.
///
/// The web's `/roadmap` redirects a finished user to `/journey-complete`
/// until they press "Keep going for now", which sets a session cookie. The app
/// does the same with [journeyCompletePromptProvider], and marks it as soon as
/// it pushes — back is also "not now", and a home that re-pushed after every
/// pop would be a screen nobody could leave.
///
/// A push, not a replacement of the body: home keeps rendering the journey
/// underneath, so dismissing the screen lands somewhere real.
///
/// `listenManual` with `fireImmediately`, because the finished state is
/// usually already in the cache when home mounts, and a plain listener only
/// fires on CHANGES. The push waits a frame — go_router will not accept one
/// mid-build.
class _JourneyFinishLine extends ConsumerStatefulWidget {
  const _JourneyFinishLine({required this.child});

  final Widget child;

  @override
  ConsumerState<_JourneyFinishLine> createState() => _JourneyFinishLineState();
}

class _JourneyFinishLineState extends ConsumerState<_JourneyFinishLine> {
  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<UserPreferences>>(
      preferencesControllerProvider,
      (AsyncValue<UserPreferences>? _, AsyncValue<UserPreferences> next) {
        final UserPreferences? prefs = next.value;
        if (prefs == null || !prefs.journeyFinished) return;
        if (ref.read(journeyCompletePromptProvider)) return;
        // Marked before the push, not after: a second preferences emission
        // in the same frame must not queue a second screen.
        ref.read(journeyCompletePromptProvider.notifier).markHandled();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.push(ZaveRoutes.journeyComplete);
        });
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Opens the planner.
///
/// A tab route SWITCHES; everything else pushes. This pushed unconditionally,
/// so "Open planner" put a second PlannerPage on the Plan branch's own stack —
/// back went from the planner to an identical planner. It was invisible while
/// nothing drew a back button; the moment ZaveScaffold started showing one,
/// the duplicate had an arrow pointing at its own twin. Asked of the tab table
/// rather than assumed, because which screens are shell branches is the
/// router's decision, not this screen's.
void _openPlanner(BuildContext context) {
  if (tabRoutes.contains(ZaveRoutes.planner)) {
    context.go(ZaveRoutes.planner);
  } else {
    context.push(ZaveRoutes.planner);
  }
}

/// The journey — the planet timeline over a draggable check-in sheet.
class _JourneyBody extends ConsumerWidget {
  const _JourneyBody({required this.topInset});

  final double topInset;

  /// The web's mobile split: a `58vh` scroll column with a sheet over it,
  /// `40vh` collapsed and `82vh` expanded. Kept as ratios rather than viewport
  /// heights so they survive whatever chrome the shell puts above and below.
  ///
  /// The collapsed size was 0.56 while the sheet led with the day's step card,
  /// which was the screen's action and had to be readable without a drag. The
  /// planner button and the connections check-in are all the sheet holds now,
  /// as on the web, so it is the web's 0.40 again and the timeline gets its
  /// space back.
  static const double _timelineFraction = 0.58;
  static const double _sheetCollapsed = 0.40;
  static const double _sheetExpanded = 0.82;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RoadmapProgress> progress = ref.watch(
      roadmapProgressControllerProvider,
    );
    final AsyncValue<List<RoadmapLevel>> levels = ref.watch(
      roadmapLevelsProvider,
    );
    // A failed read draws no figures, as the web's `useLevelsFinished` does,
    // and never holds the roadmap back: it is watched, not awaited.
    final AsyncValue<LevelsFinished> finished = ref.watch(
      levelsFinishedProvider,
    );
    final Map<int, LevelsFinishedDay> figures = finished.hasError
        ? const <int, LevelsFinishedDay>{}
        : finished.value?.byDay ?? const <int, LevelsFinishedDay>{};

    // A VALUE beats a refresh. `isLoading` was checked first, and that is what
    // made the timeline flicker: every rebuild of a provider this screen
    // watches passes through a loading state — and this returned the
    // skeleton, destroying RoadmapTimeline, its ScrollController and its
    // scroll position, then rebuilding it a frame later. On screen that is a
    // white card flashing over the planet and the timeline jumping instead of
    // scrolling.
    //
    // A dependency rebuild KEEPS the previous data: the state is
    // `AsyncLoading(value: …)` with `hasValue` true. So there is a day to draw
    // the whole time, and the skeleton is only for when there genuinely is
    // not one.
    if (!levels.hasValue || !progress.hasValue) {
      if (levels.hasError || progress.hasError) {
        return HomeError(
          topInset: topInset,
          onRetry: () =>
              ref.read(roadmapProgressControllerProvider.notifier).refresh(),
        );
      }
      return HomeSkeleton(topInset: topInset);
    }

    final List<RoadmapLevel> days = levels.requireValue;
    // The roadmap is synthetic and never empty, so this cannot happen
    // — but reading `.first` off an empty list would take the whole screen
    // down, and the error card is the honest answer either way.
    if (days.isEmpty) {
      return HomeError(
        topInset: topInset,
        onRetry: () =>
            ref.read(roadmapProgressControllerProvider.notifier).refresh(),
      );
    }

    final int today = progress.requireValue.currentDay;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * _timelineFraction,
              child: RoadmapTimeline(
                levels: days,
                today: today,
                topInset: topInset,
                levelsFinished: figures,
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: _sheetCollapsed,
              minChildSize: _sheetCollapsed,
              maxChildSize: _sheetExpanded,
              snap: true,
              builder: (BuildContext context, ScrollController controller) =>
                  _CheckInSheet(
                    controller: controller,
                    onRefresh: () async {
                      ref
                          .read(roadmapProgressControllerProvider.notifier)
                          .refresh();
                      ref.invalidate(levelsFinishedProvider);
                      ref.invalidate(connectionSummaryProvider);
                      await ref.read(roadmapProgressControllerProvider.future);
                    },
                  ),
            ),
          ],
        );
      },
    );
  }
}

/// The connections check-in, as a sheet.
///
/// The web renders this as a sticky right-hand card on desktop and a fixed
/// 40vh/82vh sheet on mobile, expanding once its content is scrolled. A
/// [DraggableScrollableSheet] is the same object with the drag handled by the
/// platform instead of by a scroll listener.
///
/// One deliberate move: the web floats the "Open planner" button OUTSIDE the
/// sheet, just above it. With a draggable sheet there is no stable "just above"
/// — the button would slide under the sheet as it opens — so it rides at the
/// top of the sheet's own content instead, which is where it reads in the same
/// order.
class _CheckInSheet extends StatelessWidget {
  const _CheckInSheet({required this.controller, required this.onRefresh});

  final ScrollController controller;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
        child: RefreshIndicator(
          color: ZaveColors.white,
          backgroundColor: ZaveColors.deep,
          onRefresh: onRefresh,
          child: ListView(
            controller: controller,
            padding: EdgeInsets.fromLTRB(
              ZaveSpace.gutter,
              ZaveSpace.md,
              ZaveSpace.gutter,
              // Clears the shell's bottom bar, which the body extends behind.
              ZaveSpace.section,
            ),
            children: <Widget>[
              // The sheet's grab handle, at the same metrics the planner
              // sheet uses so the two read as one component.
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
              SizedBox(height: ZaveSpace.lg),
              // The roadmap's one way into the work: the week's shape lives in
              // the planner, and the day's tasks live in the contest. Full
              // width, as the web's phone panel draws it.
              ZaveButton(
                label: 'Open planner',
                icon: const Icon(AppIcons.calendar),
                trailing: const Icon(AppIcons.forward),
                expand: true,
                onPressed: () => _openPlanner(context),
              ),
              SizedBox(height: ZaveSpace.xl),
              // The one thing the roadmap asks for (web, 25 Nov 2026): asked
              // weekly, standing where the day's missions used to. Connection
              // growth is where the connect and invite levels show up.
              const ConnectionCheckpoint(),
            ],
          ),
        ),
      ),
    );
  }
}
