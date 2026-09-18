import '../../../core/mock/mock_api.dart';
import '../domain/videos_repository.dart';

const String _kVideosAsset = 'assets/mock/videos/videos.json';

/// Bundled-JSON [VideosRepository] for the `mock` flavor. Loads
/// `assets/mock/videos/videos.json` (with simulated latency so the loading
/// state is observable) through the real [VideoItem.fromJson], and honours
/// connectivity (online-first): offline throws exactly like the gated Dio
/// path would, so the UI shows the same network-error state.
class MockVideosRepository implements VideosRepository {
  const MockVideosRepository({this.isOffline});

  final bool Function()? isOffline;

  @override
  Future<List<VideoItem>> fetchVideos() async {
    if (isOffline?.call() ?? false) throw const VideosUnavailable();
    try {
      final list = await MockApi.loadArray(_kVideosAsset);
      return list
          .map((e) => VideoItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object {
      throw const VideosUnavailable();
    }
  }
}
