import 'timeline_event.dart';
import 'wonder_marker.dart';

export 'timeline_event.dart';
export 'wonder_marker.dart';

/// The year the Global Timeline starts at (3000 BCE), ported verbatim from
/// Wonderous's `WondersLogic.timelineStartYear`. This port has no
/// `WondersLogic` class — these two constants are the surviving pieces of
/// it.
const int kTimelineStartYear = -3000;

/// The year the Global Timeline ends at (2200 CE), ported verbatim from
/// Wonderous's `WondersLogic.timelineEndYear`.
const int kTimelineEndYear = 2200;

/// Thrown when the global events / wonders can't be read — the UI maps it
/// to the shared network-error view. Single-sentinel convention (one const
/// exception per feature, no `Either`), matching the other slices.
class TimelineUnavailable implements Exception {
  const TimelineUnavailable();
}

/// Seam between the Global Timeline screen and its backend.
///
/// Future-returning fetches (ProHealth convention) — the screen is a
/// one-shot load driven by an `AsyncNotifier` that awaits both in parallel;
/// there is no live store to watch. Both throw [TimelineUnavailable] on
/// failure.
abstract class GlobalTimelineRepository {
  /// Fetch the world-history events plotted on the timeline's year axis.
  Future<List<TimelineEvent>> fetchGlobalEvents();

  /// Fetch the 8 wonder construction-span markers for the wonder tracks.
  Future<List<WonderMarker>> fetchWonders();
}
