import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/global_timeline_repository_providers.dart';
import '../domain/global_timeline_repository.dart';

export '../domain/global_timeline_repository.dart'
    show kTimelineStartYear, kTimelineEndYear;

part 'global_timeline_controller.g.dart';

/// Everything the Global Timeline screen renders in one shot: the merged +
/// sorted event list for the year-axis markers/popups, and the raw wonder
/// list for the wonder-track layout.
typedef GlobalTimelineOverview =
    ({List<TimelineEvent> events, List<WonderMarker> wonders});

/// Loads the Global Timeline screen. Global events and wonders are fetched
/// in parallel and merged exactly like Wonderous's `TimelineLogic.init()`:
/// each wonder contributes a synthetic "Construction of {title} begins."
/// event at its `startYr`, the combined list is sorted by year ascending,
/// and both the merged events and the raw wonders are exposed together so
/// the page and its wonder-track widgets can render as one unit.
/// `AsyncValue` drives the page states: loading → skeleton, error → shared
/// network-error view (with retry), data → the screen. Retry re-runs it via
/// `ref.invalidate`.
@riverpod
class GlobalTimelineController extends _$GlobalTimelineController {
  @override
  Future<GlobalTimelineOverview> build() async {
    final repository = ref.watch(globalTimelineRepositoryProvider);
    final (globalEvents, wonders) = await (
      repository.fetchGlobalEvents(),
      repository.fetchWonders(),
    ).wait;

    final events = <TimelineEvent>[
      ...globalEvents,
      ...wonders.map(
        (w) => TimelineEvent(
          year: w.startYr,
          description: 'Construction of ${w.title} begins.',
        ),
      ),
    ]..sort((a, b) => a.year.compareTo(b.year));

    return (events: events, wonders: wonders);
  }
}
