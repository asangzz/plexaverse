import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/home_repositories.dart';
import '../domain/home_repository.dart';
import '../domain/roadmap_level.dart';

part 'home_controllers.g.dart';

/// The user's position on the 1000-day roadmap.
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

/// The journey's days, with progress folded in.
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
