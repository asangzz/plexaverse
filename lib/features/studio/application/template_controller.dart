import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/widgets/canvas_presets.dart';
import 'template_creator_state.dart';

part 'template_controller.g.dart';

/// The Template Creator wizard — the web's `/template-creator`.
///
/// ## Why this controller has no repository
///
/// The web's terminal action is `POST /api/ai/template-creator`. **That route
/// has no mobile counterpart** — there is no `app/api/mobile/v1/ai/
/// template-creator/route.ts` — so there is nothing for a repository to call.
///
/// Rather than invent a path and let the 404 be swallowed by a `catch`, the
/// wizard is built end to end and the generate step says plainly what is
/// missing. Every choice the user makes here is real state in the shape the
/// endpoint will want, so wiring it later is a repository and one call, not a
/// screen.
@riverpod
class TemplateCreatorController extends _$TemplateCreatorController {
  @override
  TemplateCreatorState build() => const TemplateCreatorState();

  void setReference(String url) {
    final String trimmed = url.trim();
    if (!_looksLikeUrl(trimmed)) {
      state = state.copyWith(error: 'That does not look like an image URL.');
      return;
    }
    state = state.copyWith(referenceImageUrl: trimmed, clearError: true);
  }

  void setLogo(String url) {
    final String trimmed = url.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(clearLogo: true, clearError: true);
      return;
    }
    if (!_looksLikeUrl(trimmed)) {
      state = state.copyWith(error: 'That does not look like an image URL.');
      return;
    }
    state = state.copyWith(logoImageUrl: trimmed, clearError: true);
  }

  void setPreset(CanvasPreset preset) =>
      state = state.copyWith(preset: preset, clearError: true);

  void setStyle(String styleId) =>
      state = state.copyWith(styleId: styleId, clearError: true);

  void setIncludeText(bool value) => state = state.copyWith(includeText: value);

  void setName(String name) => state = state.copyWith(name: name);

  void setCategory(String category) =>
      state = state.copyWith(category: category);

  /// Forward. The web gates the same transition on a reference image.
  void next() {
    switch (state.step) {
      case TemplateStep.upload:
        if (!state.hasReference) {
          state = state.copyWith(error: 'Add a reference image to carry on.');
          return;
        }
        state = state.copyWith(step: TemplateStep.configure, clearError: true);
      case TemplateStep.configure:
        state = state.copyWith(step: TemplateStep.generate, clearError: true);
      case TemplateStep.generate:
      case TemplateStep.result:
        // There is nowhere further to go until the endpoint exists.
        break;
    }
  }

  void back() {
    switch (state.step) {
      case TemplateStep.upload:
        break;
      case TemplateStep.configure:
        state = state.copyWith(step: TemplateStep.upload, clearError: true);
      case TemplateStep.generate:
      case TemplateStep.result:
        state = state.copyWith(step: TemplateStep.configure, clearError: true);
    }
  }

  static bool _looksLikeUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');
}
