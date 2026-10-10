import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_picking.dart';
import '../data/ai_tools_repositories.dart';
import '../domain/ai_tool_failure.dart';
import '../domain/festive_template.dart';

part 'festive_controller.g.dart';

/// Which festive category chip is selected. `null` is "All templates".
///
/// Same reasoning as Reimagine's: the list is fetched once and filtered in
/// memory, so a chip tap costs nothing.
@riverpod
class FestiveCategory extends _$FestiveCategory {
  @override
  String? build() => null;

  void select(String? category) => state = category;
}

/// The festive gallery — `GET /festive/templates`.
///
/// The web's `useFestiveTemplates` also runs a templates → Figma-sync →
/// templates waterfall on an empty result. There is no mobile route for that
/// sync, so an empty gallery stays empty here and the screen says the
/// templates are still being prepared — which is the honest version of the
/// same state.
@riverpod
class FestiveController extends _$FestiveController {
  @override
  Future<FestiveGallery> build() =>
      ref.watch(aiToolsRepositoryProvider).fetchFestiveTemplates();
}

/// Everything one run of the customizer holds: the two server round-trips AND
/// the logo that goes onto them.
///
/// [FestivePosterState] describes what `/festive/generate` and `/upload/image`
/// came back with, which is why it is a domain type. The logo is the other
/// half — an input the user assembles BEFORE any XP is spent — and assembling
/// it is a use case (open the picker, upload the bytes, keep the URL), so it
/// is owned here rather than by whichever widget happens to host the control.
///
/// The two halves have to be ONE value because [busy] has to be one value.
/// While they were two — the logo's flag on the sheet's `State`, the rest on
/// this controller — neither gate could see the other: Generate stayed live
/// through a logo upload, the tap read a `logoUrl` that was still null, and
/// the user was charged 800 XP for a poster missing the logo they had just
/// picked.
class FestiveCustomizerState {
  const FestiveCustomizerState({
    this.run = const FestivePosterState(),
    this.logoUrl,
    this.uploadingLogo = false,
  });

  /// The generate-then-save round-trip: what it is doing, what came back.
  final FestivePosterState run;

  /// The logo's storage URL, once one has been picked and uploaded. Null is
  /// "no logo", which the server composites around rather than failing on.
  final String? logoUrl;

  final bool uploadingLogo;

  /// The single gate. Every control on the form reads this, and so does every
  /// method below: a tap that slips past the UI still cannot start a second
  /// operation on top of the first.
  bool get busy => uploadingLogo || run.isBusy;

  /// No sentinel for clearing [logoUrl], because nothing clears it —
  /// [FestivePosterController.reset] deliberately carries it across.
  FestiveCustomizerState copyWith({
    FestivePosterState? run,
    String? logoUrl,
    bool? uploadingLogo,
  }) => FestiveCustomizerState(
    run: run ?? this.run,
    logoUrl: logoUrl ?? this.logoUrl,
    uploadingLogo: uploadingLogo ?? this.uploadingLogo,
  );

  @override
  bool operator ==(Object other) =>
      other is FestiveCustomizerState &&
      other.run == run &&
      other.logoUrl == logoUrl &&
      other.uploadingLogo == uploadingLogo;

  @override
  int get hashCode => Object.hash(run, logoUrl, uploadingLogo);
}

/// One run of the customizer: pick a logo, generate a poster, then save it
/// somewhere it can be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.
@riverpod
class FestivePosterController extends _$FestivePosterController {
  @override
  FestiveCustomizerState build(String templateId) =>
      const FestiveCustomizerState();

  /// Opens the camera roll and puts the chosen logo into storage.
  ///
  /// Returns a message to show, or null when there is nothing to say —
  /// a dismissed picker is a decision, not a failure.
  ///
  /// This ran on the sheet, which is how the 800 XP charge described on
  /// [FestiveCustomizerState] was reachable: the flag it kept there was the
  /// half of the form's gate this controller could not see. Raising that flag
  /// here, rather than leaving it to the caller, is the whole point of the
  /// move — a gate the caller can forget is not a gate.
  Future<String?> pickLogo() async {
    if (state.busy) return null;
    // Raised BEFORE the picker opens rather than around the upload alone: the
    // sheet stays mounted and tappable while the platform picker is up, and a
    // logo the user is still choosing must gate Generate exactly as an
    // in-flight upload does.
    state = state.copyWith(uploadingLogo: true);
    try {
      final ImagePickResult picked = await ref
          .read(imagePickingProvider)
          .pick(ImageSourceKind.gallery);
      switch (picked) {
        case PickedImage(:final String dataUri):
          final String url = await ref
              .read(aiToolsRepositoryProvider)
              .uploadDataUri(dataUri);
          // The sheet can be dismissed mid-upload, which disposes this
          // autoDispose provider. `ref.mounted` is what the widget's own
          // `mounted` check was on this path — dropping it in the move would
          // trade a discarded URL for a throw.
          if (ref.mounted) state = state.copyWith(logoUrl: url);
        // Closing the picker is a decision.
        case ImagePickCancelled():
          break;
        case ImagePickFailure(:final String? message):
          return message ?? 'Could not open your photos.';
      }
    } on Object {
      // Deliberately wider than the `on AiToolFailure` the paid calls use: a
      // logo that did not upload costs nothing, so it gets a snackbar rather
      // than the amber card that explains a spend.
      return "That logo didn't upload. Try again.";
    } finally {
      if (ref.mounted) state = state.copyWith(uploadingLogo: false);
    }
    return null;
  }

  /// `POST /festive/generate` — 800 XP, charged only on success.
  Future<void> generate(FestiveCustomizations customizations) async {
    // [FestiveCustomizerState.busy], not `run.isBusy`: a logo still uploading
    // means the poster this would pay for is not the poster the user asked
    // for. The form gates the button too, but the money is spent here.
    if (state.busy) return;

    final String? logoUrl = state.logoUrl;
    state = FestiveCustomizerState(
      run: const FestivePosterState(busy: FestivePosterBusy.generating),
      logoUrl: logoUrl,
    );

    try {
      final FestivePoster poster = await ref
          .read(aiToolsRepositoryProvider)
          .generateFestivePoster(
            templateId: templateId,
            // Stamped from state, not read off the argument: the form carries
            // no logo of its own any more, so there is no second copy that can
            // disagree with this one.
            customizations: customizations.copyWith(logoUrl: logoUrl),
          );
      state = state.copyWith(run: FestivePosterState(poster: poster));
    } on AiToolFailure catch (e) {
      state = state.copyWith(
        run: FestivePosterState(
          error: e.message,
          insufficientXp: e.insufficientXp,
        ),
      );
    }
  }

  /// `POST /upload/image` — put the inline poster into storage.
  ///
  /// This exists because the poster comes back as a `data:` URI, and a data
  /// URI is not something the user can do anything with: LinkedIn cannot
  /// fetch one, and neither can the composer. Uploading turns it into a link
  /// that can be pasted anywhere.
  Future<void> save() async {
    final FestivePoster? poster = state.run.poster;
    if (poster == null || poster.imageUrl.isEmpty || state.busy) return;

    state = state.copyWith(
      run: state.run.copyWith(busy: FestivePosterBusy.saving, error: null),
    );
    try {
      final String url = await ref
          .read(aiToolsRepositoryProvider)
          .uploadDataUri(poster.imageUrl);
      state = state.copyWith(
        run: state.run.copyWith(busy: FestivePosterBusy.idle, savedUrl: url),
      );
    } on AiToolFailure catch (e) {
      state = state.copyWith(
        run: state.run.copyWith(
          busy: FestivePosterBusy.idle,
          error: e.message,
          insufficientXp: e.insufficientXp,
        ),
      );
    }
  }

  /// Back to the form, keeping whatever the user typed. The web calls this
  /// "Regenerate" and does the same thing: it clears the image, not the input.
  ///
  /// The logo is input, so it survives too — it is already in storage, and
  /// re-picking the same file would cost the user a second trip for nothing.
  /// That fell out for free while the URL sat on the widget, which outlived
  /// this call; now that the state is in one place it has to be carried
  /// across on purpose.
  void reset() => state = FestiveCustomizerState(logoUrl: state.logoUrl);
}
