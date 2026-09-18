import 'avatar_look.dart';
import 'avatar_profile.dart';

export 'avatar_look.dart';
export 'avatar_profile.dart';

/// Thrown when the avatar profile / looks can't be read — the UI maps it to
/// the shared network-error view. Single-sentinel convention (one const
/// exception per feature, no `Either`), matching the other slices.
class AvatarsUnavailable implements Exception {
  const AvatarsUnavailable();
}

/// Seam between the Avatars tab and its backend.
///
/// Future-returning fetches (ProHealth convention) — the tab is a one-shot
/// load driven by an `AsyncNotifier` that awaits both in parallel; there is
/// no live store to watch. Both throw [AvatarsUnavailable] on failure.
abstract class AvatarsRepository {
  /// Fetch the avatar identity for the header pill + voice bar.
  Future<AvatarProfile> fetchProfile();

  /// Fetch the look cards for the grid, in display order.
  Future<List<AvatarLook>> fetchLooks();
}
