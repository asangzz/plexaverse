import '../../../core/mock/mock_api.dart';
import '../domain/global_timeline_repository.dart';

const String _kGlobalEventsAsset = 'assets/mock/timeline/global_events.json';
const String _kWondersAsset = 'assets/mock/timeline/wonders.json';

/// Bundled-JSON [GlobalTimelineRepository] for the `mock` flavor. Loads
/// `assets/mock/timeline/{global_events,wonders}.json` (with simulated
/// latency so the loading state is observable) through the real
/// `fromJson`s, and honours connectivity (online-first): offline throws
/// exactly like the gated Dio path would, so the UI shows the same
/// network-error state.
class MockGlobalTimelineRepository implements GlobalTimelineRepository {
  const MockGlobalTimelineRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Future<List<TimelineEvent>> fetchGlobalEvents() async {
    if (isOffline?.call() ?? false) throw const TimelineUnavailable();
    try {
      final list = await MockApi.loadArray(_kGlobalEventsAsset);
      return list
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const TimelineUnavailable();
    }
  }

  @override
  Future<List<WonderMarker>> fetchWonders() async {
    if (isOffline?.call() ?? false) throw const TimelineUnavailable();
    try {
      final list = await MockApi.loadArray(_kWondersAsset);
      return list
          .map((e) => WonderMarker.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const TimelineUnavailable();
    }
  }
}
