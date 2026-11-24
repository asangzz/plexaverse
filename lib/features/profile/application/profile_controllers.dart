import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_sharing.dart';
import '../../contest/application/contest_controllers.dart';
import '../data/profile_repositories.dart';
import '../domain/public_profile.dart';

export '../domain/public_profile.dart';

part 'profile_controllers.g.dart';

// The public profile's server reads and writes (owner, 24 Nov 2026), with
// their busy and error state off the widgets. Each is one mobile route; no
// rule of the server's is restated here.

/// `GET /profile` — the handle and the `public_profile` consent. The section
/// draws its box from this, so it is never pre-ticked.
@riverpod
class PublicProfileSettingsController
    extends _$PublicProfileSettingsController {
  @override
  Future<PublicProfileSettings> build() =>
      ref.watch(profileRepositoryProvider).fetchSettings();

  /// The server's answer to a write, kept as the settings — never a locally
  /// toggled guess: only the server knows whether the consent was recorded.
  void settle(PublicProfileSettings settings) =>
      state = AsyncData<PublicProfileSettings>(settings);
}

/// `GET /profile?handle=` — is this handle free for the user? Asked only for
/// a handle that already passes the shape rule, and only once typing pauses.
@riverpod
Future<HandleAvailability> handleAvailability(Ref ref, String handle) =>
    ref.watch(profileRepositoryProvider).checkHandle(handle);

/// Where a publish or an unpublish stands — the section's button and the
/// line beside it.
class PublicProfileSave {
  const PublicProfileSave({
    this.saving = false,
    this.error,
    this.adultRequired = false,
    this.saved,
  });

  final bool saving;

  /// The server's sentence for a refused write. Null while nothing went
  /// wrong.
  final String? error;

  /// The refusal was ADULT_REQUIRED: the 18+ box shows.
  final bool adultRequired;

  /// What the last successful write did, in a sentence.
  final String? saved;
}

/// `PUT /profile` — publish at a handle, or unpublish. A success writes the
/// server's answer into the settings and re-reads the shoutout card's view
/// of it; a refusal re-reads the settings rather than assume.
@riverpod
class PublicProfileActions extends _$PublicProfileActions {
  @override
  PublicProfileSave build() => const PublicProfileSave();

  /// Clears a shown line — the form was touched again.
  void reset() {
    if (state.saving) return;
    state = const PublicProfileSave();
  }

  /// Publish at [handle]: the person ticked "Publish my profile" and pressed
  /// Save (or "Feature me"). [adult] is the 18+ tick, sent only when it was
  /// asked for and ticked.
  Future<bool> publish({required String handle, bool adult = false}) => _write(
    () => ref
        .read(profileRepositoryProvider)
        .publish(handle: handle, adult: adult),
    saved: 'Your page is live.',
  );

  /// Unpublish: the whole withdrawal, one tap.
  Future<bool> unpublish() => _write(
    () => ref.read(profileRepositoryProvider).unpublish(),
    saved: 'Your page is offline and your handle is freed.',
  );

  Future<bool> _write(
    Future<PublicProfileSettings> Function() send, {
    required String saved,
  }) async {
    if (state.saving) return false;
    state = const PublicProfileSave(saving: true);
    try {
      final PublicProfileSettings settings = await send();
      if (!ref.mounted) return false;
      state = PublicProfileSave(saved: saved);
      ref
          .read(publicProfileSettingsControllerProvider.notifier)
          .settle(settings);
      // The levels' follow level and featured cards read who is public.
      ref.invalidate(contestFeaturedProvider);
      return true;
    } on Object catch (e) {
      if (!ref.mounted) return false;
      state = PublicProfileSave(
        error: e is ProfileFailure
            ? e.message
            : 'That did not come through. Try again.',
        adultRequired: e is ProfileAdultRequired,
      );
      ref.invalidate(publicProfileSettingsControllerProvider);
      return false;
    }
  }
}

/// Where a CV download stands.
class CvDownload {
  const CvDownload({this.busy = false, this.error});

  final bool busy;

  /// Why there is no CV, or why it did not come through. Null while nothing
  /// went wrong.
  final String? error;
}

/// `GET /profile/cv`, then the share sheet: the PDF is written to the
/// device's temp folder and handed to the user to save or send. Never kept
/// by the app, as the server never keeps it.
@riverpod
class CvDownloadActions extends _$CvDownloadActions {
  @override
  CvDownload build() => const CvDownload();

  Future<void> download() async {
    if (state.busy) return;
    state = const CvDownload(busy: true);
    try {
      final CvFile cv = await ref.read(profileRepositoryProvider).downloadCv();
      if (!ref.mounted) return;
      final ShareResult shared = await ref
          .read(imageSharingProvider)
          .shareBytesFile(bytes: cv.bytes, fileName: cv.fileName);
      if (!ref.mounted) return;
      state = CvDownload(
        error: shared is ShareFailed
            ? 'Could not hand over your CV. Try again.'
            : null,
      );
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = CvDownload(
        error: e is ProfileFailure
            ? e.message
            : 'Could not make your CV. Try again.',
      );
    }
  }
}
