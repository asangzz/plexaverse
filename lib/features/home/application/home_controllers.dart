import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/home_repositories.dart';
import '../domain/home_repository.dart';
import '../domain/roadmap_level.dart';

part 'home_controllers.g.dart';

/// The signed-in user's preferences.
///
/// **This provider lives in the home slice on purpose, and temporarily.**
/// `features/preferences/` currently contains a domain model and nothing else —
/// no repository, no provider — yet the home screen cannot choose between the
/// Season 1 roadmap and the Season 2 dashboard without `currentSeason`, and
/// several other screens will need the same row. When the preferences slice
/// grows a data layer this should move there wholesale and this file should
/// The user's position on the 66-day roadmap.
///
/// The web caches this for 30 seconds and busts the browser cache on every
/// fetch; here the equivalent is simply that the provider is re-read on
/// invalidation and on a pull-to-refresh.
@riverpod
class RoadmapProgressController extends _$RoadmapProgressController {
  @override
  Future<RoadmapProgress> build() =>
      ref.watch(homeRepositoryProvider).fetchRoadmapProgress();

  /// Re-read from the server. Used by pull-to-refresh and after the user
  /// returns from a task screen, where the step they just did may now be done.
  void refresh() => ref.invalidateSelf();
}

/// The 66 days, with progress folded in.
///
/// Derived rather than stored: the roadmap is a pure function of the progress
/// payload plus today's date, and caching it separately is how the two drift.
@riverpod
Future<List<RoadmapLevel>> roadmapLevels(Ref ref) async {
  final RoadmapProgress progress = await ref.watch(
    roadmapProgressControllerProvider.future,
  );
  return buildRoadmap(progress);
}

/// Which day the mission panel is showing.
///
/// Null means "follow the roadmap" — the active day, or day 1 when nothing is
/// active. The user overrides it by tapping a day row or scrolling one to the
/// centre of the timeline, exactly as the web's scroll-snap selection does.
@riverpod
class SelectedRoadmapDay extends _$SelectedRoadmapDay {
  @override
  int? build() => null;

  void select(int day) {
    if (state != day) state = day;
  }
}

/// The day the panel actually renders: the user's selection if they made one,
/// otherwise the roadmap's own active day.
@riverpod
Future<int> activeRoadmapDay(Ref ref) async {
  final int? selected = ref.watch(selectedRoadmapDayProvider);
  if (selected != null) return selected;

  final List<RoadmapLevel> levels = await ref.watch(
    roadmapLevelsProvider.future,
  );
  for (final RoadmapLevel level in levels) {
    if (level.status == LevelStatus.active) return level.id;
  }
  return levels.isEmpty ? 1 : levels.first.id;
}

/// The XP balance shown in the header.
///
/// The web refetches this every 30 seconds; a phone in a user's pocket does not
/// need a background poll for a number that only moves when the user does
/// something, so this refreshes on invalidation instead. Flagged as a
/// deliberate departure rather than an omission.
@riverpod
Future<XpBalance> xpBalance(Ref ref) =>
    ref.watch(homeRepositoryProvider).fetchXpBalance();
