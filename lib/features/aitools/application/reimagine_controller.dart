import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ai_tools_repositories.dart';
import '../domain/ai_tool_failure.dart';
import '../domain/studio_template.dart';

part 'reimagine_controller.g.dart';

/// Which category chip is selected on Reimagine. `null` is "All templates".
///
/// Kept out of [ReimagineController] on purpose: the web fetches the gallery
/// once and filters it in memory, so a chip tap must not refetch. Putting the
/// selection into the controller's `build` would make every tap a request.
@riverpod
class ReimagineCategory extends _$ReimagineCategory {
  @override
  String? build() => null;

  void select(String? category) => state = category;
}

/// The Reimagine gallery — `GET /studio/templates`.
///
/// Mirrors the web's `useStudioTemplates`: one fetch, cached, shared with any
/// other surface that wants the same list.
@riverpod
class ReimagineController extends _$ReimagineController {
  @override
  Future<List<StudioTemplate>> build() =>
      ref.watch(aiToolsRepositoryProvider).fetchStudioTemplates();
}

/// Copying a template into the user's own designs — `POST /studio/copy`.
///
/// Separate from [ReimagineController] because the gallery is not invalidated
/// by a copy: the copy is private and never a template, so it can never appear
/// in this list. Refetching after it would be a request that provably changes
/// nothing.
@riverpod
class TemplateCopyController extends _$TemplateCopyController {
  @override
  TemplateCopyState build() => const TemplateCopyState();

  Future<void> copy(StudioTemplate template) async {
    if (state.busy) return;
    state = TemplateCopyState(copyingId: template.id);

    try {
      final StudioTemplate copied = await ref
          .read(aiToolsRepositoryProvider)
          .copyStudioTemplate(
            sourceId: template.id,
            // The web's exact naming, so a design copied on the phone and one
            // copied on the web are indistinguishable in the designs list.
            name: '${template.name} (My Copy)',
          );
      state = TemplateCopyState(copied: copied, copiedFromId: template.id);
    } on AiToolFailure catch (e) {
      state = TemplateCopyState(error: e.message);
    }
  }

  /// Clears the banner after the user has read it.
  void dismiss() => state = const TemplateCopyState();
}
