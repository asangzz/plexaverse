import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/home_controllers.dart';
import '../../domain/home_repository.dart';
import '../../domain/roadmap_level.dart';
import '../widgets/home_states.dart';
import '../widgets/levels_panel.dart';
import '../widgets/roadmap_timeline.dart';
import '../widgets/season_two_view.dart';
import '../../../preferences/application/preferences_controller.dart';

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
/// the XP balance in the header — nothing else.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZaveScaffold(
      // No title: the screen carries its own heading inside the timeline
      // ("Your 66-day plan"), and Zave screens never wear both.
      actions: <Widget>[_XpPill()],
      body: _HomeBody(),
    );
  }
}

/// The XP balance, where the web puts it — up in the mobile header.
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
      data: (XpBalance value) => Padding(
        padding: EdgeInsets.only(right: ZaveSpace.sm),
        child: ZavePill(
          label: '${value.balance} XP',
          color: ZaveColors.amber,
          leading: const ZaveDot(ZaveColors.amber),
        ),
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

    return prefs.when(
      loading: () => HomeSkeleton(topInset: topInset),
      error: (Object _, StackTrace _) => HomeError(
        topInset: topInset,
        onRetry: () => ref.invalidate(preferencesControllerProvider),
      ),
      data: (UserPreferences preferences) => preferences.isSeason2
          ? _SeasonTwoBody(preferences: preferences, topInset: topInset)
          : _SeasonOneBody(topInset: topInset),
    );
  }
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

  /// The web's mobile split: a `58vh` scroll column with a `40vh` sheet over
  /// it, expanding to `82vh`. Kept as ratios rather than viewport heights so
  /// they survive whatever chrome the shell puts above and below.
  static const double _timelineFraction = 0.58;
  static const double _sheetCollapsed = 0.42;
  static const double _sheetExpanded = 0.82;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RoadmapLevel>> levels = ref.watch(
      roadmapLevelsProvider,
    );
    final AsyncValue<int> activeDay = ref.watch(activeRoadmapDayProvider);

    if (levels.isLoading || activeDay.isLoading) {
      return HomeSkeleton(topInset: topInset);
    }
    if (levels.hasError || activeDay.hasError) {
      return HomeError(
        topInset: topInset,
        onRetry: () =>
            ref.read(roadmapProgressControllerProvider.notifier).refresh(),
      );
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
              Align(
                alignment: Alignment.centerRight,
                child: ZaveButton(
                  label: 'Open planner',
                  trailing: const Icon(Icons.arrow_forward),
                  onPressed: () => _start(context, '/planner'),
                ),
              ),
              SizedBox(height: ZaveSpace.lg),
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
