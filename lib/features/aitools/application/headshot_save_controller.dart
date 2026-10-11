import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_sharing.dart';
import '../domain/headshot_session.dart';
import 'headshots_controller.dart';

part 'headshot_save_controller.g.dart';

/// Which generated portraits are being handed to the share sheet.
///
/// ## Why this is not a `_busy` on the Save button
///
/// It was one, on the `State` of the button beside each portrait. The download
/// keeps running after the results step is rebuilt — and the results step IS
/// rebuilt, every time [HeadshotsController] publishes a new session — so the
/// flag that said a save was open died with the widget that started it and the
/// button came back enabled on top of its own in-flight download.
///
/// ## Why a set of indexes and not one bool
///
/// There are four portraits and four buttons. A single flag would grey out all
/// four because one was saving, which is the "pausing one schedule greyed out
/// every other row" defect at a smaller scale. The index is the key, exactly as
/// settings keys its writes by name.
///
/// ## Why it is not a field on [HeadshotSession]
///
/// [HeadshotSession] models the wizard the SERVER knows about — the step, the
/// photos, the generation, the roadmap credit. A share sheet the user may
/// dismiss is none of those things and has no bearing on what `/ai/headshot`
/// was asked for; folding it in would make a value that is about one request
/// also about something that never leaves the phone.
@riverpod
class HeadshotSaveController extends _$HeadshotSaveController {
  @override
  Set<int> build() => const <int>{};

  /// Whether the portrait at [index] is being saved. Call through `.select` so
  /// one button rebuilds for its own save and not for its neighbour's.
  bool isSaving(int index) => state.contains(index);

  /// Downloads the portrait at [index] and offers it to the user as a file.
  ///
  /// Returns the message to show, or null when there is nothing to say — a
  /// dismissed share sheet is a decision, the same rule the pickers follow.
  ///
  /// The URL is read from the session rather than taken as an argument: the
  /// results are the controller's, and a copy passed down from the widget is a
  /// second version of the same fact that can disagree with the first.
  Future<String?> save(int index) async {
    if (state.contains(index)) return null;

    final HeadshotSession session = ref.read(headshotsControllerProvider);
    if (index < 0 || index >= session.results.length) return null;
    final String url = session.results[index];

    state = <int>{...state, index};
    try {
      final ShareResult result = await ref
          .read(imageSharingProvider)
          .shareImageUrl(
            url: url,
            fileName: 'plexaverse-headshot-${index + 1}.png',
          );
      return switch (result) {
        ShareSucceeded() => 'Saved.',
        ShareDismissed() => null,
        ShareFailed(:final String? message) =>
          message ?? "Couldn't save that one. Try again.",
      };
    } finally {
      // Leaving the screen mid-save disposes this provider, and writing
      // `state` on a disposed Ref throws out of the `finally` — which would
      // replace whatever the save actually returned with an unhandled error.
      if (ref.mounted) state = <int>{...state}..remove(index);
    }
  }
}
