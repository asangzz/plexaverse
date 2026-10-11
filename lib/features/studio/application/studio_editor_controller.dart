import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/studio_repositories.dart';
import '../domain/ai_designer.dart';
import '../domain/studio_design.dart';
import 'studio_controller.dart';
import 'studio_editor_state.dart';

part 'studio_editor_controller.g.dart';

/// One design, open for light editing.
///
/// **Scope, stated once so it is not re-litigated by accident:** Studio on a
/// phone is VIEW plus LIGHT EDIT. This controller can retype a text layer and
/// swap an image layer, and that is all it can do. There is no move, no
/// resize, no new element and no vector tooling, because there is no canvas
/// editor on this platform — the web's is 4,400 lines of pointer maths against
/// a 280px-panel layout that does not survive a 375px viewport.
///
/// Edits are applied to the in-memory tree immediately and pushed with an
/// explicit [save]. See [StudioEditorState.dirty] for why there is no
/// autosave.
@riverpod
class StudioEditor extends _$StudioEditor {
  @override
  Future<StudioEditorState> build(String designId) async {
    final StudioDesign design = await ref
        .watch(studioRepositoryProvider)
        .fetchDesign(designId);
    return StudioEditorState(design: design);
  }

  /// Retypes a text layer.
  void editText(String elementId, String text) {
    _mutate(
      elementId,
      (StudioElement e) => e.copyWith(text: text),
      (Map<String, dynamic> raw) => <String, dynamic>{...raw, 'text': text},
    );
  }

  /// Points an image layer at a different image.
  ///
  /// [url] may be an `https://` URL or a `data:image/…;base64,…` URI — the
  /// AI-generated path produces the latter, and the renderer handles both.
  void swapImage(String elementId, String url) {
    _mutate(
      elementId,
      (StudioElement e) => e.copyWith(imageUrl: url),
      (Map<String, dynamic> raw) => <String, dynamic>{...raw, 'imageUrl': url},
    );
  }

  /// Points an image layer at a pasted URL, rejecting anything that is not
  /// one. Returns false when the URL was refused.
  ///
  /// The check is here rather than in the sheet because "is this a thing we
  /// can send" is a decision about the edit, not about the box it was typed
  /// into — the same reason `TemplateCreatorController` validates its
  /// reference URL on the controller and refuses it with this same sentence.
  bool swapImageFromUrl(String elementId, String url) {
    final String trimmed = url.trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      _setSwapError('That does not look like an image URL.');
      return false;
    }
    swapImage(elementId, trimmed);
    return true;
  }

  /// Generates a replacement image for [elementId] and applies it. Returns
  /// false when nothing was swapped.
  ///
  /// **The in-flight flag and the failure both live in [state], not in the
  /// swap sheet.** `POST /ai/image` costs XP and takes tens of seconds, and
  /// the sheet is dismissible throughout; when the sheet owned this, leaving
  /// it mid-call discarded an image the user had already paid for and left
  /// the design untouched. Here the image lands on the design whether or not
  /// anyone is still looking at the sheet.
  Future<bool> generateImageInto({
    required String elementId,
    required String prompt,
    required String aspectRatio,
  }) async {
    final StudioEditorState? current = state.value;
    if (current == null) return false;

    final String trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      _setSwapError('Say what the image should be.');
      return false;
    }
    // One generation at a time across the whole design. The tapped layer's
    // own button is already closed by [StudioEditorState.isSwapping]; this
    // catches the other way in — dismissing a sheet mid-call and opening a
    // second layer's — and says so rather than doing nothing visible.
    if (current.swappingElementId != null) {
      _setSwapError('An image is still being generated. Give it a moment.');
      return false;
    }

    state = AsyncData<StudioEditorState>(
      current.copyWith(swappingElementId: elementId, clearSwapError: true),
    );
    try {
      final String uri = await ref
          .read(studioRepositoryProvider)
          .generateImage(prompt: trimmed, aspectRatio: aspectRatio);
      if (!ref.mounted) return false;
      swapImage(elementId, uri);
      return true;
    } on Object {
      _setSwapError('That image did not come back. It may be an XP balance.');
      return false;
    } finally {
      // The user can pop the design page mid-call, which disposes this
      // autoDispose provider; writing `state` afterwards throws out of the
      // `finally`.
      if (ref.mounted) {
        final StudioEditorState? latest = state.value;
        if (latest != null) {
          state = AsyncData<StudioEditorState>(
            latest.copyWith(clearSwapping: true),
          );
        }
      }
    }
  }

  /// Drops the last swap failure — called when the sheet reopens, so a stale
  /// sentence does not sit under a fresh prompt.
  void clearSwapError() {
    final StudioEditorState? current = state.value;
    if (current == null || current.swapError == null) return;
    state = AsyncData<StudioEditorState>(
      current.copyWith(clearSwapError: true),
    );
  }

  void _setSwapError(String message) {
    if (!ref.mounted) return;
    final StudioEditorState? current = state.value;
    if (current == null) return;
    state = AsyncData<StudioEditorState>(current.copyWith(swapError: message));
  }

  /// Adopts a design the AI Designer proposed, wholesale.
  ///
  /// This is the one edit that discards the raw mirror, because the model
  /// authored a new tree rather than patching the old one — there is nothing
  /// left of the original to preserve unknown fields from.
  void applyDesign(StudioDesignData proposed) {
    final StudioEditorState? current = state.value;
    if (current == null) return;
    state = AsyncData<StudioEditorState>(
      current.copyWith(
        design: current.design.copyWith(data: proposed),
        dirty: true,
        clearSaveError: true,
      ),
    );
  }

  /// Pushes the edits. Reports failure in state rather than throwing: this is
  /// called from a button, and an unhandled rejection there is a silent loss.
  Future<void> save() async {
    final StudioEditorState? current = state.value;
    if (current == null || current.saving) return;

    state = AsyncData<StudioEditorState>(
      current.copyWith(saving: true, clearSaveError: true),
    );
    try {
      final StudioDesign saved = await ref
          .read(studioRepositoryProvider)
          .updateDesign(current.design.id, data: current.data);
      // The PATCH response carries the row, but its `data` may come back
      // as the server re-serialised it; keep the tree we just sent so the
      // preview cannot flicker back to a pre-edit state.
      state = AsyncData<StudioEditorState>(
        StudioEditorState(design: saved.copyWith(data: current.data)),
      );
      // The library row's `updatedAt` just moved.
      ref.invalidate(studioDesignsControllerProvider);
    } on Object catch (error) {
      state = AsyncData<StudioEditorState>(
        current.copyWith(saving: false, saveError: error.toString()),
      );
    }
  }

  void _mutate(
    String elementId,
    StudioElement Function(StudioElement) update,
    Map<String, dynamic> Function(Map<String, dynamic>) rawUpdate,
  ) {
    final StudioEditorState? current = state.value;
    if (current == null) return;
    state = AsyncData<StudioEditorState>(
      current.copyWith(
        design: current.design.copyWith(
          data: current.data.patch(elementId, update, rawUpdate),
        ),
        dirty: true,
        clearSaveError: true,
      ),
    );
  }
}

/// The AI Designer conversation for one design.
///
/// Keyed by design id so switching designs does not inherit the previous
/// design's chat — the route is stateless and replays whatever history it is
/// given, so a leaked conversation would actively mislead the model.
@riverpod
class AiDesigner extends _$AiDesigner {
  @override
  List<AiDesignerTurn> build(String designId) => const <AiDesignerTurn>[];

  /// True while a turn is in flight. Derived from the pending bubble rather
  /// than stored, so the two can never disagree.
  ///
  /// The UI reads the same thing off the turn list it already watches — a
  /// getter on the notifier does not rebuild anything.
  bool get isBusy => state.any((AiDesignerTurn t) => t.pending);

  /// Sends one turn.
  ///
  /// The user's bubble and a pending assistant bubble go in immediately; the
  /// pending one is replaced by the reply, or turned into a failed bubble.
  /// A design generation takes tens of seconds, and an empty panel for that
  /// long reads as a broken button.
  Future<void> send(
    String prompt, {
    required StudioCanvas canvas,
    StudioDesignData? currentDesign,
  }) async {
    final String trimmed = prompt.trim();
    if (trimmed.isEmpty || isBusy) return;

    final String stamp = DateTime.now().microsecondsSinceEpoch.toString();
    final List<AiDesignerTurn> history = <AiDesignerTurn>[
      ...state,
      AiDesignerTurn(
        id: 'u-$stamp',
        role: AiDesignerRole.user,
        content: trimmed,
      ),
    ];
    state = <AiDesignerTurn>[
      ...history,
      AiDesignerTurn(
        id: 'a-$stamp',
        role: AiDesignerRole.assistant,
        pending: true,
      ),
    ];

    try {
      final AiDesignerReply reply = await ref
          .read(studioRepositoryProvider)
          .askDesigner(
            history: history,
            canvas: canvas,
            currentDesign: currentDesign,
          );
      state = <AiDesignerTurn>[
        ...history,
        AiDesignerTurn(
          id: 'a-$stamp',
          role: AiDesignerRole.assistant,
          content: reply.message,
          design: reply.design,
        ),
      ];
    } on Object {
      state = <AiDesignerTurn>[
        ...history,
        AiDesignerTurn(
          id: 'a-$stamp',
          role: AiDesignerRole.assistant,
          content:
              'That did not come back. It may be an XP balance, or the '
              'designer may be busy — try again.',
          failed: true,
        ),
      ];
    }
  }

  void clear() => state = const <AiDesignerTurn>[];
}
