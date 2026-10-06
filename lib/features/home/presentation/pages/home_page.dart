import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/home_controllers.dart';
import '../../domain/home_repository.dart';
import '../../domain/roadmap_level.dart';
import '../widgets/follower_checkpoint.dart';
import '../widgets/home_states.dart';
import '../widgets/levels_panel.dart';
import '../widgets/roadmap_timeline.dart';
import '../widgets/season_two_view.dart';
import '../../../plexa/presentation/plexa_day_sheet.dart';
import '../../../preferences/application/preferences_controller.dart';
import '../../../../core/router/zave_routes.dart';

/// **Home** — the web's `/dashboard`.
///
/// The landing surface, and the screen the product is actually about. It
/// renders **exactly one of two things**, chosen by `UserPreferences
/// .currentSeason`:
///
/// * **Season 1** (the default, and what nearly every user sees) — the 66-day
///   planet timeline with its mission sheet.
/// * **Season 2** — the black hole and its four-phase weekly cycle.
///
/// There is deliberately **no stat grid and no recent-posts list**. The web
/// used to fire an eight-query dashboard fetch here whose result was never
/// drawn, and blocked first paint on it; it was removed, and re-adding one on
/// mobile would re-import the same mistake. What this screen asks the server
/// for is the roadmap, the preferences that choose between the two seasons, and
/// the XP balance in the corner — nothing else.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // No header at all — not even for the XP pill.
    //
    // `actions` alone was enough to build one, so home wore a full sticky
    // header (blur, hairline, the lot) to carry a single read-only pill. The
    // pill stays where it was; it is now laid over the body rather than
    // mounted in chrome, so the timeline runs to the top of the screen the
    // way it was drawn to.
    return const ZaveScaffold(body: _HomeWithXp());
  }
}

/// The roadmap, with the XP balance laid over its top-right corner.
///
/// [IgnorePointer] because the pill is a readout, not a control: overlaying it
/// must not take taps away from the timeline underneath, and the orbit is
/// exactly where a thumb reaches for the current day.
class _HomeWithXp extends StatelessWidget {
  const _HomeWithXp();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const _HomeBody(),
        Positioned(
          top: MediaQuery.paddingOf(context).top + ZaveSpace.sm,
          right: ZaveSpace.gutter,
          child: const IgnorePointer(child: _XpPill()),
        ),
      ],
    );
  }
}

/// The XP balance, where the web puts it — top-right of the home screen.
///
/// Amber because amber is Zave's word for points. (Blue is "the XP *path*" and
/// belongs to the buttons that lead to buying or earning it, not to a readout
/// of how much you already have.)
class _XpPill extends ConsumerWidget {
  const _XpPill();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<XpBalance> xp = ref.watch(xpBalanceProvider);

    return xp.when(
      // A failed XP read must never take the home screen with it — the balance
      // is decoration on a screen whose job is the roadmap.
      error: (Object _, StackTrace _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      data: (XpBalance value) => ZavePill(
        label: '${value.balance} XP',
        color: ZaveColors.amber,
        leading: const ZaveDot(ZaveColors.amber),
      ),
    );
  }
}

/// Picks the season, and owns every loading and error state on this screen.
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

    // Same rule as the timeline below: a value that is being refreshed is
    // still a value. `when` treats any loading as "nothing to show", so every
    // preferences invalidation used to blank the whole screen to a skeleton
    // and rebuild the timeline underneath it.
    if (prefs.hasValue) return _seasonBody(prefs.requireValue, topInset);

    return prefs.when(
      loading: () => HomeSkeleton(topInset: topInset),
      error: (Object _, StackTrace _) => HomeError(
        topInset: topInset,
        onRetry: () => ref.invalidate(preferencesControllerProvider),
      ),
      data: (UserPreferences preferences) => _seasonBody(preferences, topInset),
    );
  }

  /// Three states, not two. A user past day 66 who has not chosen a Season 2
  /// path belongs on the Season Complete screen — the route existed and
  /// nothing ever navigated to it, so finishing the 66-day arc simply carried
  /// on showing a roadmap with nothing left in it.
  Widget _seasonBody(UserPreferences preferences, double topInset) =>
      switch (preferences) {
        final UserPreferences p when p.isSeason2 => _SeasonTwoBody(
          preferences: p,
          topInset: topInset,
        ),
        final UserPreferences p when p.seasonOneFinished =>
          const _SeasonOneFinishedRedirect(),
        _ => _SeasonOneBody(topInset: topInset),
      };
}

/// Opens a task's screen.
///
/// The link is a web route path verbatim (`/planner?slot=3`, `/comments`,
/// `/roadmap/headline-hook`). That is the whole point of the byte-identical
/// route table: the roadmap does not need a translation layer, and a task that
/// works on the web works here.
void _start(BuildContext context, String link) {
  if (link.isEmpty) return;
  context.push(link);
}

/// Season 1 — the 66-day timeline over a draggable mission sheet.
class _SeasonOneBody extends ConsumerWidget {
  const _SeasonOneBody({required this.topInset});

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
    // The roadmap is synthetic and always 66 days long, so this cannot happen
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
                icon: const Icon(Icons.auto_awesome_outlined),
                expand: true,
                onPressed: () => showPlexaDay(context),
              ),
              SizedBox(height: ZaveSpace.md),
              Align(
                alignment: Alignment.centerRight,
                child: ZaveButton(
                  label: 'Open planner',
                  trailing: const Icon(Icons.arrow_forward),
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

/// Season 2 — the black hole and the day's habits.
class _SeasonTwoBody extends ConsumerWidget {
  const _SeasonTwoBody({required this.preferences, required this.topInset});

  final UserPreferences preferences;
  final double topInset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RoadmapProgress> progress = ref.watch(
      roadmapProgressControllerProvider,
    );

    return progress.when(
      loading: () => HomeSkeleton(topInset: topInset),
      error: (Object _, StackTrace _) => HomeError(
        topInset: topInset,
        onRetry: () =>
            ref.read(roadmapProgressControllerProvider.notifier).refresh(),
      ),
      data: (RoadmapProgress value) => SeasonTwoView(
        progress: value,
        contentMode: preferences.contentMode,
        seasonStartedAt: preferences.seasonStartedAt,
        roadmapStartedAt: preferences.roadmapStartedAt,
        topInset: topInset,
        onStart: (String link) => _start(context, link),
      ),
    );
  }
}

/// Sends a user who has finished Season 1 to the Season Complete screen.
///
/// A redirect rather than rendering the screen inline: Season Complete is a
/// full-screen route with its own back behaviour, and the user may want to
/// look at their dashboard again before deciding. Replacing the home body
/// with it would leave them nowhere to go back to.
///
/// Fired once per mount, after the first frame — navigating during build
/// throws, and go_router needs the tree settled before it will accept a push.
class _SeasonOneFinishedRedirect extends StatefulWidget {
  const _SeasonOneFinishedRedirect();

  @override
  State<_SeasonOneFinishedRedirect> createState() =>
      _SeasonOneFinishedRedirectState();
}

class _SeasonOneFinishedRedirectState
    extends State<_SeasonOneFinishedRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.push(ZaveRoutes.seasonComplete);
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
