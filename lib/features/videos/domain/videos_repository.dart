import 'video_item.dart';

export 'video_item.dart';

/// Thrown when the video library can't be read — the UI maps it to the
/// shared network-error view. Single-sentinel convention (one const
/// exception per feature, no `Either`), matching the other slices.
class VideosUnavailable implements Exception {
  const VideosUnavailable();
}

/// Seam between the Videos tab and its backend.
///
/// Future-returning fetch (ProHealth convention) — the library list is a
/// one-shot load driven by an `AsyncNotifier`; there is no live store to
/// watch. Throws [VideosUnavailable] on failure.
abstract class VideosRepository {
  /// Fetch the user's video library, newest first (the order the fixture /
  /// endpoint delivers).
  Future<List<VideoItem>> fetchVideos();
}
