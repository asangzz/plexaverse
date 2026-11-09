import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/plan/plan_refusal.dart';
import '../../../core/platform/image_picking.dart';
import '../data/ai_tools_repositories.dart';
import '../domain/ai_tool_failure.dart';
import '../domain/headshot_session.dart';

part 'headshots_controller.g.dart';

/// The `/headshots` wizard.
///
/// The whole flow is one value ([HeadshotSession]) rather than the web's ten
/// `useState` calls, so the screen cannot render a combination the flow cannot
/// be in — `step: generate` with nothing generating, for instance, which the
/// web can reach when a request fails between the two setters.
@riverpod
class HeadshotsController extends _$HeadshotsController {
  @override
  HeadshotSession build() => const HeadshotSession();

  /// The plan refusal behind the current error, if that is what it was.
  ///
  /// Held here rather than on [HeadshotSession] because that is a freezed
  /// value and adding a field needs a codegen run. It is always written
  /// BEFORE the state assignment that rebuilds the page, so a build that sees
  /// `insufficientXp` also sees the refusal it belongs to.
  PlanRefusal? get refusal => _refusal;
  PlanRefusal? _refusal;

  void goTo(HeadshotStep step) => state = state.copyWith(step: step);

  void chooseStyle(HeadshotStyle style) => state = state.copyWith(style: style);

  void chooseBackground(HeadshotBackground background) =>
      state = state.copyWith(background: background);

  /// Opens the camera roll (or the camera) and attaches one reference photo.
  ///
  /// Returns a message to show, or null when there is nothing to say —
  /// cancelling the picker is a decision, not an error.
  ///
  /// This screen shipped for months behind a note claiming the build had no
  /// photo picker. That stopped being true when `image_picker` landed for the
  /// composer; the note outlived the limitation it described, which is the
  /// worst kind of placeholder — one that tells the user a false thing about
  /// their own app.
  Future<String?> pickPhoto(ImageSourceKind source) async {
    if (state.photos.length >= maxHeadshotPhotos) {
      return 'That is the maximum of $maxHeadshotPhotos photos.';
    }
    final ImagePickResult result = await ref
        .read(imagePickingProvider)
        .pick(source);
    switch (result) {
      case PickedImage(:final String dataUri):
        addPhotos(<String>[dataUri]);
        return null;
      case ImagePickCancelled():
        return null;
      case ImagePickFailure(:final String? message):
        return message ?? 'Could not open your photos.';
    }
  }

  /// Attach reference photos as `data:image/…;base64,…` URIs.
  void addPhotos(List<String> dataUris) {
    if (dataUris.isEmpty) return;
    final List<String> next = <String>[...state.photos, ...dataUris];
    state = state.copyWith(
      photos: next.length > maxHeadshotPhotos
          ? next.sublist(0, maxHeadshotPhotos)
          : next,
      error: null,
    );
  }

  void removePhoto(int index) {
    if (index < 0 || index >= state.photos.length) return;
    final List<String> next = List<String>.of(state.photos)..removeAt(index);
    state = state.copyWith(photos: next);
  }

  /// `POST /ai/headshot` — paid by the plan, four portraits, all or nothing.
  ///
  /// The server generates the four in parallel and rejects the whole call if
  /// any one of them fails. That is why there is no per-image state here:
  /// there is nothing partial to show.
  ///
  /// Returns the plan refusal when the plan said no, so the page can open the
  /// plan sheet once — an event, not something every rebuild re-reads.
  Future<PlanRefusal?> generate() async {
    if (state.generating) return null;
    if (!state.canGenerate) {
      state = state.copyWith(
        error: 'Add at least $minHeadshotPhotos reference photos first.',
      );
      return null;
    }

    _refusal = null;

    state = state.copyWith(
      step: HeadshotStep.generate,
      generating: true,
      error: null,
      insufficientXp: false,
    );

    try {
      final HeadshotResult result = await ref
          .read(aiToolsRepositoryProvider)
          .generateHeadshots(
            photos: state.photos,
            style: state.style,
            background: state.background,
          );
      state = state.copyWith(
        step: HeadshotStep.results,
        generating: false,
        results: result.headshots,
      );
      return null;
    } on AiToolFailure catch (e) {
      // Back to the step the user can act on, exactly as the web does: a
      // failed generation must not strand them on a spinner screen.
      _refusal = e.refusal;
      state = state.copyWith(
        step: HeadshotStep.style,
        generating: false,
        error: e.message,
        insufficientXp: e.refusedByPlan,
      );
      return e.refusal;
    }
  }

  /// "Finish step" — close out the roadmap's Level 1 Step 5.
  ///
  /// The call is idempotent server-side, so a double tap cannot close the step
  /// twice. It deliberately does not navigate: the roadmap is another slice
  /// and the dashboard picks the completion up on its next read.
  Future<void> finishStep() async {
    if (state.finishing || state.finished) return;
    state = state.copyWith(finishing: true, error: null);
    try {
      // Level 1, Step 5 — the same pair the web sends from this page.
      await ref
          .read(aiToolsRepositoryProvider)
          .completeRoadmapStep(levelId: 1, stepId: 5);
      state = state.copyWith(finishing: false, finished: true);
    } on AiToolFailure catch (e) {
      state = state.copyWith(finishing: false, error: e.message);
    }
  }

  /// "Generate new" — drop the photos and the results, keep nothing.
  void restart() => state = const HeadshotSession();
}
