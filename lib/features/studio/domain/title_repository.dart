import 'title_creator.dart';

/// Backs the Profile Title Creator — the web's `/title-creator`.
///
/// Three calls, in the order the wizard makes them. All three routes exist on
/// the mobile API; none is invented.
abstract class TitleRepository {
  /// Step 1 → 2. Reads a profession out of the user's current headline so
  /// step 2 can address them by what they do.
  Future<ProfessionAnalysis> analyzeProfession(String headline);

  /// Step 2 → 3. Writes the optimised headline.
  Future<TitleSuggestion> suggestTitle({
    required String headline,
    required TitlePriority priority,
  });

  /// "Complete quest" — closes out the roadmap step this screen belongs to
  /// (the web calls it with level 1, step 4).
  ///
  /// Idempotent server-side, so a double tap costs nothing.
  Future<void> completeRoadmapStep({required int levelId, required int stepId});
}
