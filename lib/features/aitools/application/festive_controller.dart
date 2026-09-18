import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// One run of the customizer: generate a poster, then save it somewhere it can
/// be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.
@riverpod
class FestivePosterController extends _$FestivePosterController {
  @override
  FestivePosterState build(String templateId) => const FestivePosterState();

  /// `POST /festive/generate` — 800 XP, charged only on success.
  Future<void> generate(FestiveCustomizations customizations) async {
    if (state.isBusy) return;
    state = const FestivePosterState(busy: FestivePosterBusy.generating);

    try {
      final FestivePoster poster = await ref
          .read(aiToolsRepositoryProvider)
          .generateFestivePoster(
            templateId: templateId,
            customizations: customizations,
          );
      state = FestivePosterState(poster: poster);
    } on AiToolFailure catch (e) {
      state = FestivePosterState(
        error: e.message,
        insufficientXp: e.insufficientXp,
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
    final FestivePoster? poster = state.poster;
    if (poster == null || poster.imageUrl.isEmpty || state.isBusy) return;

    state = state.copyWith(busy: FestivePosterBusy.saving, error: null);
    try {
      final String url = await ref
          .read(aiToolsRepositoryProvider)
          .uploadDataUri(poster.imageUrl);
      state = state.copyWith(busy: FestivePosterBusy.idle, savedUrl: url);
    } on AiToolFailure catch (e) {
      state = state.copyWith(
        busy: FestivePosterBusy.idle,
        error: e.message,
        insufficientXp: e.insufficientXp,
      );
    }
  }

  /// Back to the form, keeping whatever the user typed. The web calls this
  /// "Regenerate" and does the same thing: it clears the image, not the input.
  void reset() => state = const FestivePosterState();
}
