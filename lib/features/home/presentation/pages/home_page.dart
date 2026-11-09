import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_destinations.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/plexa_day_sheet.dart';
import '../../../preferences/application/preferences_controller.dart';
import '../../../missions/application/journey_controller.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/home_controllers.dart';
import '../../domain/roadmap_level.dart';
import '../widgets/follower_checkpoint.dart';
import '../widgets/home_states.dart';
import '../widgets/levels_panel.dart';
import '../widgets/roadmap_timeline.dart';

/// **Home** — the web's `/dashboard`.
///
/// The landing surface, and the screen the product is actually about: the
/// 1000-day journey's planet timeline with its mission sheet, at the user's
/// day of their CURRENT journey. There is one mode. The old Season 2 "black
/// hole" loop is gone from the product, and a user on journey 2 or later is
/// simply at their own roadmap day on the same view.
///
/// Day 1000 is a finish line. When the journey is finished this screen still
/// renders normally, and offers the journey-complete screen once per app
/// session on top of it — see [_JourneyFinishLine].
///
/// There is deliberately **no stat grid and no recent-posts list**. The web
/// used to fire an eight-query dashboard fetch here whose result was never
/// drawn, and blocked first paint on it; it was removed, and re-adding one on
/// mobile would re-import the same mistake. What this screen asks the server
/// for is the roadmap and the preferences — nothing else.
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
/// The web's `/dashboard` redirects a finished user to `/journey-complete`
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

/// Opens a task's screen.
///
/// The link is a web route path verbatim (`/planner?slot=3`, `/comments`,
/// `/roadmap/headline-hook`). That is the whole point of the byte-identical
/// route table: the roadmap does not need a translation layer, and a task that
/// works on the web works here.
void _start(BuildContext context, String link) {
  if (link.isEmpty) return;

  // A tab route SWITCHES; everything else pushes.
  //
  // This pushed unconditionally, so "Open planner" put a second PlannerPage on
  // the Plan branch's own stack — back went from the planner to an identical
  // planner. It was invisible while nothing drew a back button; the moment
  // ZaveScaffold started showing one, the duplicate had an arrow pointing at
  // its own twin.
  //
  // Compared on the PATH, because roadmap links carry query strings
  // (`/planner?slot=3`) and those are still that tab, not a new screen. `go`
  // keeps the query and switches the branch rather than stacking.
  final String path = Uri.parse(link).path;
  if (tabRoutes.contains(path)) {
    context.go(link);
  } else {
    context.push(link);
  }
}

/// The journey — the planet timeline over a draggable mission sheet.
class _JourneyBody extends ConsumerWidget {
  const _JourneyBody({required this.topInset});

  final double topInset;

  /// The web's mobile split: a `58vh` scroll column with a sheet over it,
  /// expanding to `82vh`. Kept as ratios rather than viewport heights so they
  /// survive whatever chrome the shell puts above and below.
  ///
  /// The collapsed size is 0.56 rather than the web's 0.40, and the extra is
  /// spent on one thing: a whole step card, numeral included.
  ///
  /// The live step is now the screen's action — there is no button repeating
  /// it — so a card you have to drag the sheet open to read is an action in a
  /// drawer. What the extra covers is the empty stretch of timeline between
  /// the orbit and the sheet, which was carrying nothing.
  static const double _timelineFraction = 0.58;
  static const double _sheetCollapsed = 0.56;
  static const double _sheetExpanded = 0.82;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RoadmapLevel>> levels = ref.watch(
      roadmapLevelsProvider,
    );
    final AsyncValue<int> activeDay = ref.watch(activeRoadmapDayProvider);

    // A VALUE beats a refresh. `isLoading` was checked first, and that is what
    // made the timeline flicker: `activeRoadmapDay` watches the selected day,
    // so every scroll that names a new day rebuilds it into a loading state —
    // and this returned the skeleton, destroying RoadmapTimeline, its
    // ScrollController and its scroll position, then rebuilding it a frame
    // later at the new day. On screen that is a white card flashing over the
    // planet and the timeline jumping instead of scrolling.
    //
    // A dependency rebuild KEEPS the previous data: the state is
    // `AsyncLoading(value: …)` with `hasValue` true. So there is a day to draw
    // the whole time, and the skeleton is only for when there genuinely is
    // not one.
    if (!levels.hasValue || !activeDay.hasValue) {
      if (levels.hasError || activeDay.hasError) {
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

    final int selected = activeDay.requireValue;
    final RoadmapLevel level = days.firstWhere(
      (RoadmapLevel l) => l.id == selected,
      orElse: () => days.first,
    );

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
                selectedDay: selected,
                topInset: topInset,
                onSelectDay: (int day) =>
                    ref.read(selectedRoadmapDayProvider.notifier).select(day),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: _sheetCollapsed,
              minChildSize: _sheetCollapsed,
              maxChildSize: _sheetExpanded,
              snap: true,
              builder: (BuildContext context, ScrollController controller) =>
                  _MissionSheet(
                    level: level,
                    controller: controller,
                    onRefresh: () async {
                      ref
                          .read(roadmapProgressControllerProvider.notifier)
                          .refresh();
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

/// The mission surface, as a sheet.
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
class _MissionSheet extends StatelessWidget {
  const _MissionSheet({
    required this.level,
    required this.controller,
    required this.onRefresh,
  });

  final RoadmapLevel level;
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
              // Open Plexa is the primary of the two: it is the day's work,
              // where the planner is the week's shape. The web mounts the
              // same chat on its roadmap for the same reason.
              //
              // A sheet, not a route. The roadmap stays underneath it, which
              // is what the web does and what makes closing the chat feel
              // like putting something down rather than going back.
              ZaveButton.primary(
                label: 'Open Plexa',
                icon: const Icon(AppIcons.sparkle),
                expand: true,
                onPressed: () => showPlexaDay(context),
              ),
              SizedBox(height: ZaveSpace.md),
              Align(
                alignment: Alignment.centerRight,
                child: ZaveButton(
                  label: 'Open planner',
                  trailing: const Icon(AppIcons.forward),
                  onPressed: () => _start(context, '/planner'),
                ),
              ),
              SizedBox(height: ZaveSpace.xl),
              // Above the day's missions, where the number means something.
              // The phase checkpoints ARE follower counts, and this is the
              // only way one can reach us — so without it the roadmap names a
              // target it cannot measure the user against.
              FollowerCheckpoint(currentDay: level.id),
              SizedBox(height: ZaveSpace.xl),
              LevelsPanel(
                level: level,
                onStart: (String link) => _start(context, link),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
