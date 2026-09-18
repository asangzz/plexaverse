import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/missions_repositories.dart';
import '../domain/missions_repository.dart';

part 'missions_controllers.g.dart';

/// The preferences row the three mission pages read and write, plus the
/// LinkedIn slug they build hand-off URLs from.
///
/// One provider shared by all three missions rather than one each: they edit
/// DIFFERENT COLUMNS OF THE SAME ROW (headline, summary + skills, position),
/// and a user who fixes their headline on one screen should see it on the next
/// without a refetch.
@riverpod
class MissionProfileController extends _$MissionProfileController {
  @override
  Future<MissionProfile> build() =>
      ref.watch(missionsRepositoryProvider).fetchProfile();

  /// Partial save. Only the keys passed are sent — the server's schema is
  /// `.strict()`, so an unknown key rejects the whole payload with a 400
  /// rather than being quietly dropped.
  ///
  /// Not optimistic: unlike approving a planner slot, these are typed edits the
  /// user already sees on screen, so there is nothing to make responsive. What
  /// matters is that a failed save is visible, and the caller surfaces it.
  Future<void> save(Map<String, dynamic> patch) async {
    final MissionProfile updated = await ref
        .read(missionsRepositoryProvider)
        .updatePreferences(patch);
    state = AsyncData<MissionProfile>(updated);
  }

  /// Marks one roadmap step complete.
  ///
  /// Deliberately does not touch this controller's state — the roadmap's
  /// progress lives behind the home screen's own provider, which re-reads when
  /// the user lands back on it. Idempotent server-side, so a double-tap is
  /// safe.
  Future<MissionStepResult> completeStep({
    required int levelId,
    required int stepId,
  }) => ref
      .read(missionsRepositoryProvider)
      .completeStep(levelId: levelId, stepId: stepId);

  /// The Headline Hook's "AI Spark".
  Future<String> suggestHeadline(String headline) {
    final MissionProfile? profile = state.value;
    return ref
        .read(missionsRepositoryProvider)
        .suggestHeadline(
          headline: headline,
          priority: profile?.aiPriority ?? 'recruiter',
        );
  }

  /// The About Odyssey's "AI Spark".
  Future<String> generateAbout() {
    final MissionProfile? profile = state.value;
    final UserPreferences prefs = profile?.preferences ?? UserPreferences.empty;
    return ref
        .read(missionsRepositoryProvider)
        .generateAbout(
          profession: prefs.profession ?? '',
          priority: profile?.aiPriority ?? 'recruiter',
          headline: prefs.headline,
          industry: prefs.industry,
        );
  }
}

/// The banner template carousel.
///
/// Its own provider: the Studio template list is the slowest read on any of
/// these screens, and it must not delay the position field the user is
/// already typing into.
@riverpod
Future<List<BannerTemplate>> bannerTemplates(Ref ref) =>
    ref.watch(missionsRepositoryProvider).fetchBannerTemplates();

/// The Season 1 recap numbers.
@riverpod
Future<SeasonRecap> seasonRecap(Ref ref) =>
    ref.watch(missionsRepositoryProvider).fetchSeasonRecap();
