import 'package:flutter/widgets.dart' show GlobalKey;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_sharing.dart';
import '../data/missions_repositories.dart';
import '../domain/missions_repository.dart';
import 'mission_form_state.dart';

export 'mission_form_state.dart';

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

/// One run of the Headline Hook: optimise, save, finish.
///
/// The three in-flight flags and the message sat on the page's `State`. Every
/// one of them is the state of an async use case, so every one of them was
/// wrong the moment the page was disposed mid-call — the `finally` that
/// cleared the spinner was already guarded by `mounted`, and the failure the
/// `catch` recorded went nowhere when it was not.
///
/// The page keeps its `TextEditingController` and its three-item LinkedIn
/// checklist. Those are genuinely its own: nothing is sent from them, no
/// second screen asks, and a disposed page cannot make either answer wrong.
@riverpod
class HeadlineHookController extends _$HeadlineHookController {
  @override
  HeadlineHookState build() => const HeadlineHookState();

  /// The "AI Spark". Returns the optimised headline for the caller to put in
  /// the field, or null when there is nothing to put there.
  ///
  /// The text comes IN rather than being read from a controller this does not
  /// own — the field stays the page's, and what to do with the answer stays
  /// the page's too.
  Future<String?> suggest(String current) async {
    // Unreachable from the UI, which disables the button while `suggesting`.
    // Kept because a gate the caller can forget is not a gate.
    if (state.suggesting) return null;

    final String headline = current.trim();
    if (headline.length < 5) {
      state = state.copyWith(
        notice: const MissionNotice.warning(
          'Write a basic headline first so the model has something to '
          'optimise.',
        ),
      );
      return null;
    }

    state = state.copyWith(suggesting: true, clearNotice: true);
    String? suggested;
    MissionNotice notice;
    try {
      suggested = await ref
          .read(missionProfileControllerProvider.notifier)
          .suggestHeadline(headline);
      notice = const MissionNotice.success('Headline optimised.');
    } on Object {
      notice = const MissionNotice.warning(
        'That did not generate. Try again in a moment.',
      );
    }
    // `ref.mounted`, not the caller's `mounted`: the page may be gone, and
    // writing state on a disposed notifier throws.
    if (ref.mounted) {
      state = state.copyWith(suggesting: false, notice: notice);
    }
    return suggested;
  }

  /// Writes the headline to the preferences row without completing the step.
  Future<void> saveDraft(String headline) async {
    if (state.saving) return;

    state = state.copyWith(saving: true, clearNotice: true);
    MissionNotice notice;
    try {
      await ref.read(missionProfileControllerProvider.notifier).save(
        <String, dynamic>{'headline': headline.trim()},
      );
      notice = const MissionNotice.success('Headline saved.');
    } on Object {
      notice = const MissionNotice.warning('Could not save that headline.');
    }
    if (ref.mounted) state = state.copyWith(saving: false, notice: notice);
  }

  /// Records the step. Returns true when the caller may leave the screen.
  ///
  /// [checklistDone] is the page's two gating switches, resolved. The switches
  /// themselves stay on the widget — they are taps with no meaning anywhere
  /// else — but whether they add up to "done" is a decision about whether
  /// something is complete, and that is this layer's.
  ///
  /// `finishing` is deliberately NOT cleared on success: the button goes on
  /// spinning until the route pops, which is what the user is waiting for.
  Future<bool> finish({
    required int levelId,
    required int stepId,
    required bool checklistDone,
  }) async {
    if (state.finishing) return false;
    if (!checklistDone) {
      state = state.copyWith(
        notice: const MissionNotice.warning('Finish the checklist first.'),
      );
      return false;
    }

    state = state.copyWith(finishing: true, clearNotice: true);
    try {
      await ref
          .read(missionProfileControllerProvider.notifier)
          .completeStep(levelId: levelId, stepId: stepId);
      return true;
    } on Object {
      if (ref.mounted) {
        state = state.copyWith(
          finishing: false,
          notice: const MissionNotice.warning('Could not record that step.'),
        );
      }
      return false;
    }
  }
}

/// One run of the About Odyssey: draft, curate the skill stack, finish.
///
/// The skill list is here and not on the page because it is the payload:
/// [finish] posts it, and "no duplicates, at most ten" are decisions about
/// what gets sent. The summary stays in the page's `TextEditingController` —
/// that is the one piece of form state the rule names as the widget's.
@riverpod
class AboutOdysseyController extends _$AboutOdysseyController {
  /// The web refuses to complete the step below this. A floor, not a target:
  /// three real paragraphs are far longer.
  static const int minSummaryLength = 50;

  /// LinkedIn's own ceiling on the skill list a profile shows.
  static const int maxSkills = 10;

  @override
  AboutOdysseyState build() => const AboutOdysseyState();

  /// The skill list as it currently stands: the edited one, or the
  /// preferences row's own until the user touches it.
  ///
  /// A `read`, not a `watch` — this controller must not rebuild when the
  /// profile does, or the save inside [finish] would reset the very flags
  /// that say [finish] is running.
  List<String> get skills =>
      state.skills ??
      ref.read(missionProfileControllerProvider).value?.preferences.skills ??
      const <String>[];

  /// The "AI Spark". Returns the drafted About body, or null.
  Future<String?> generate() async {
    if (state.generating) return null;

    final MissionProfile? profile = ref
        .read(missionProfileControllerProvider)
        .value;
    if ((profile?.preferences.profession ?? '').isEmpty) {
      state = state.copyWith(
        notice: const MissionNotice.warning(
          'Set your profession in Settings first — the draft is built around '
          'it.',
        ),
      );
      return null;
    }

    state = state.copyWith(generating: true, clearNotice: true);
    String? about;
    MissionNotice notice;
    try {
      about = await ref
          .read(missionProfileControllerProvider.notifier)
          .generateAbout();
      notice = const MissionNotice.success('About section drafted.');
    } on Object {
      notice = const MissionNotice.warning(
        'That did not generate. Try again in a moment.',
      );
    }
    if (ref.mounted) {
      state = state.copyWith(generating: false, notice: notice);
    }
    return about;
  }

  /// Adds [skill] to the stack. Returns true when it went on — which is the
  /// caller's signal to clear its input field, and the only thing about this
  /// the field needs to know.
  bool addSkill(String skill) {
    final String trimmed = skill.trim();
    if (trimmed.isEmpty) return false;

    final List<String> current = skills;
    if (current.contains(trimmed)) {
      state = state.copyWith(
        notice: const MissionNotice.warning(
          'That skill is already on the list.',
        ),
      );
      return false;
    }
    if (current.length >= maxSkills) {
      state = state.copyWith(
        notice: const MissionNotice.warning(
          'LinkedIn shows $maxSkills skills — remove one first.',
        ),
      );
      return false;
    }

    state = state.copyWith(skills: <String>[...current, trimmed]);
    return true;
  }

  void removeSkill(String skill) => state = state.copyWith(
    skills: skills.where((String s) => s != skill).toList(growable: false),
  );

  /// Saves the summary and the skill stack, then records the step. Returns
  /// true when the caller may leave the screen.
  ///
  /// The save runs BEFORE the completion, and the order is load-bearing: if
  /// the save fails the step must not be recorded against work that was never
  /// persisted.
  Future<bool> finish({
    required int levelId,
    required int stepId,
    required String summaryText,
  }) async {
    if (state.finishing) return false;

    final String summary = summaryText.trim();
    if (summary.length < minSummaryLength) {
      state = state.copyWith(
        notice: const MissionNotice.warning(
          'Write a more substantial About section before finishing.',
        ),
      );
      return false;
    }

    state = state.copyWith(finishing: true, clearNotice: true);
    try {
      final MissionProfileController profile = ref.read(
        missionProfileControllerProvider.notifier,
      );
      await profile.save(<String, dynamic>{
        'summary': summary,
        'skills': skills,
      });
      await profile.completeStep(levelId: levelId, stepId: stepId);
      return true;
    } on Object {
      if (ref.mounted) {
        state = state.copyWith(
          finishing: false,
          notice: const MissionNotice.warning('Could not save those changes.'),
        );
      }
      return false;
    }
  }
}

/// One run of Banner Blueprint: export the chosen banner, record the step.
///
/// Which template the carousel is showing stays on the page — that is a
/// selection inside one local control, and the `GlobalKey` it attaches to the
/// active card is a render-object handle that cannot live anywhere else.
/// Everything the export and the completion DO lives here.
@riverpod
class BannerBlueprintController extends _$BannerBlueprintController {
  /// LinkedIn's own cover width. Exporting the on-screen thumbnail instead
  /// would give the user something that looks right in the app and blurry on
  /// their profile — which is the only place it is going.
  static const double coverWidth = 1584;

  @override
  BannerBlueprintState build() => const BannerBlueprintState();

  /// Renders the widget behind [boundaryKey] and hands it to the share sheet,
  /// where iOS offers "Save Image".
  ///
  /// The key comes in because a render boundary is the page's by nature;
  /// `ImageSharingService.shareWidgetPng` already takes one, so this is the
  /// seam the core service was written against, not a new one.
  Future<void> saveBanner(GlobalKey boundaryKey) async {
    if (state.saving) return;

    state = state.copyWith(saving: true);
    MissionNotice? notice;
    try {
      final ShareResult result = await ref
          .read(imageSharingProvider)
          .shareWidgetPng(
            boundaryKey: boundaryKey,
            fileName: 'plexaverse-linkedin-banner.png',
            targetWidth: coverWidth,
          );
      switch (result) {
        case ShareSucceeded():
          notice = const MissionNotice.success(
            'Saved. Set it as your cover photo on LinkedIn.',
          );
        // Dismissing the sheet is a decision, not a failure.
        case ShareDismissed():
          break;
        case ShareFailed(:final String? message):
          notice = MissionNotice.warning(
            message ?? "Couldn't save the banner. Try again.",
          );
      }
    } finally {
      // A null `notice` leaves the previous one standing, which is what a
      // dismissed share sheet should do: the user decided nothing.
      if (ref.mounted) {
        state = state.copyWith(saving: false, notice: notice);
      }
    }
  }

  /// Records the step. Returns true when the caller may leave the screen.
  Future<bool> finish({required int levelId, required int stepId}) async {
    if (state.finishing) return false;

    state = state.copyWith(finishing: true, clearNotice: true);
    try {
      await ref
          .read(missionProfileControllerProvider.notifier)
          .completeStep(levelId: levelId, stepId: stepId);
      return true;
    } on Object {
      if (ref.mounted) {
        state = state.copyWith(
          finishing: false,
          notice: const MissionNotice.warning('Could not record that step.'),
        );
      }
      return false;
    }
  }
}
