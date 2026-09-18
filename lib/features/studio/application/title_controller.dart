import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/title_repositories.dart';
import '../domain/title_creator.dart';
import 'title_creator_state.dart';

part 'title_controller.g.dart';

/// The Profile Title Creator wizard — the web's `/title-creator`.
///
/// Roadmap level 1, step 4. Three steps: type your current headline, pick who
/// the new one is FOR, read the result.
@riverpod
class TitleCreatorController extends _$TitleCreatorController {
  /// The minimum the web enforces before it will analyse a headline.
  static const int minHeadlineLength = 5;

  /// The roadmap coordinates this screen closes out, as the web passes them.
  static const int _roadmapLevelId = 1;
  static const int _roadmapStepId = 4;

  @override
  TitleCreatorState build() => const TitleCreatorState();

  void setHeadline(String value) =>
      state = state.copyWith(headline: value, clearError: true);

  /// Step 1 → 2.
  ///
  /// The analysis is a courtesy, not a gate: its only job is to let step 2 say
  /// "Your profile focus: Product Manager". The route never 5xxs — it returns a
  /// usable shell when Gemini is unavailable — so a failure here still
  /// advances rather than stranding the user one step from the thing they
  /// came for.
  Future<void> analyze() async {
    final String headline = state.headline.trim();
    if (headline.length < minHeadlineLength) {
      state = state.copyWith(error: 'Please enter a longer headline');
      return;
    }
    if (state.busy) return;

    state = state.copyWith(busy: true, clearError: true);
    try {
      final ProfessionAnalysis analysis = await ref
          .read(titleRepositoryProvider)
          .analyzeProfession(headline);
      state = state.copyWith(
        analysis: analysis,
        step: TitleStep.priority,
        busy: false,
      );
    } on Object {
      state = state.copyWith(
        analysis: const ProfessionAnalysis(),
        step: TitleStep.priority,
        busy: false,
      );
    }
  }

  /// Step 2 → 3. Choosing IS generating, exactly as on the web.
  Future<void> choose(TitlePriority priority) async {
    if (state.busy) return;
    state = state.copyWith(
      priority: priority,
      step: TitleStep.result,
      busy: true,
      clearError: true,
      clearResult: true,
    );
    try {
      final TitleSuggestion result = await ref
          .read(titleRepositoryProvider)
          .suggestTitle(headline: state.headline.trim(), priority: priority);
      state = state.copyWith(result: result, busy: false);
    } on Object {
      // Back to step 2, where the user can pick again — the same recovery the
      // web performs. Stranding them on an empty result screen would leave no
      // control that does anything.
      state = state.copyWith(
        step: TitleStep.priority,
        busy: false,
        error: 'Could not write a headline. Try again.',
      );
    }
  }

  /// "Try again" — back to step 1 with the typed headline intact.
  void restart() => state = TitleCreatorState(headline: state.headline);

  /// "Complete quest". Idempotent server-side, so a double tap is harmless.
  Future<void> completeQuest() => ref
      .read(titleRepositoryProvider)
      .completeRoadmapStep(levelId: _roadmapLevelId, stepId: _roadmapStepId);
}
