import '../../home/domain/roadmap_level.dart';
import '../../home/domain/roadmap_progress.dart';

/// Today's roadmap task for one engagement screen.
///
/// Both `/comments` and `/connections` are **roadmap-mission deep links**:
/// neither appears in the web's sidebar, and both are reached from the Season 1
/// roadmap ("Comment on posts", "Send connection requests"). So each screen has
/// to locate its own step before it can say what "done" means or credit the
/// user for finishing.
///
/// ## Why this reuses the home slice's roadmap
///
/// The 66-day roadmap is a pure, client-side table — `getBaseRoadmap()` on the
/// web, [buildRoadmap] here — and the home slice already ports it in full,
/// including the progress fold that marks steps complete. A second copy in this
/// slice would be ~470 lines that silently drift from the one the dashboard
/// renders, and the two screens would then disagree about which day it is. Only
/// pure domain is imported; this slice owns its own repository and does its own
/// read, because the home repository is deliberately read-only (completing a
/// step is a write it refuses to have).
class EngagementMission {
  const EngagementMission({
    required this.levelId,
    required this.stepId,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.targetCount,
    required this.isCompleted,
  });

  /// The day, 1..66. Half of the server's composite key `'<levelId>-<stepId>'`.
  final int levelId;

  /// The step within the day. The other half of that key.
  final int stepId;

  final String title;
  final String description;
  final int xpReward;

  /// How many items count as done.
  final int targetCount;

  /// Already credited. The user may still work the screen — the roadmap's own
  /// rows stay tappable after completion — but there is nothing left to claim.
  final bool isCompleted;

  /// Finds the step whose `moduleLink` is [moduleLink] on TODAY's day.
  ///
  /// Returns null when today's day has no such step, which is a real state
  /// rather than a failure:
  ///
  ///  • a company-brand user has no `/connections` step at all (a Company Page
  ///    cannot send connection requests) and their comment step points at
  ///    `/company-auto-comment`, not `/comments`;
  ///  • Season 2+ users are past day 66.
  ///
  /// The web's `/connections` blocks its entire page on a null step and spins
  /// forever when one is missing. This port deliberately does not reproduce
  /// that: the screen still generates and still works, and only the
  /// claim-your-XP action is withheld, with a note saying why.
  ///
  /// [fallbackTarget] mirrors the web's `match(/(\d+)/)` default — the count is
  /// the first integer in the step's description, and the web falls back to 3
  /// for comments and 10 for connections when the description carries none.
  static EngagementMission? locate(
    RoadmapProgress progress, {
    required String moduleLink,
    required int fallbackTarget,
  }) {
    final List<RoadmapLevel> levels = buildRoadmap(progress);
    if (levels.isEmpty) return null;

    // Always TODAY's day, so "finish step" marks the key the dashboard checks,
    // not some earlier day's step that happens to be the first unfinished one.
    // Clamped to the table's length: Season 2+ users have a currentDay past 66
    // and the roadmap simply stops there.
    final int raw = progress.currentDay;
    final int day = raw < 1 ? 1 : (raw > levels.length ? levels.length : raw);

    RoadmapLevel? level;
    for (final RoadmapLevel candidate in levels) {
      if (candidate.id == day) {
        level = candidate;
        break;
      }
    }
    if (level == null) return null;

    RoadmapStep? step;
    for (final RoadmapStep candidate in level.steps) {
      if (candidate.moduleLink == moduleLink) {
        step = candidate;
        break;
      }
    }
    if (step == null) return null;

    return EngagementMission(
      levelId: level.id,
      stepId: step.id,
      title: step.title,
      description: step.description,
      xpReward: step.xpReward,
      targetCount: targetCountFrom(step.description, fallbackTarget),
      isCompleted: step.isCompleted,
    );
  }

  /// The web's rule, verbatim: the first integer anywhere in the step's
  /// description, or [fallback] when it has none.
  ///
  /// Exposed rather than inlined because it is the one piece of this that is
  /// genuinely surprising — the target count is parsed out of display copy, so
  /// rewording a description can change what "done" means.
  static int targetCountFrom(String description, int fallback) {
    final RegExpMatch? match = RegExp(r'\d+').firstMatch(description);
    if (match == null) return fallback;
    return int.tryParse(match.group(0)!) ?? fallback;
  }
}
