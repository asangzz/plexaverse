import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/image_picking.dart' show PickedImage;

import '../../../core/network/failure.dart';
import '../../../core/plan/plan_refusal.dart';
import '../../settings/application/settings_controllers.dart';
import '../../settings/domain/settings_entities.dart';
import '../../posts/application/post_library_controllers.dart';
import '../data/planner_repositories.dart';
import '../domain/plan_slot.dart';
import '../domain/planner_repository.dart';
import '../domain/post_formats.dart';
import '../domain/video_script.dart';
import '../domain/weekly_article.dart';

part 'planner_controller.g.dart';

/// Which week the planner is showing.
///
/// Null means "whatever the server says is current" — the server owns the
/// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
/// and the client must not recompute it or it will ask for a week the plan was
/// never saved under.
@riverpod
class PlannerWeek extends _$PlannerWeek {
  @override
  ({int? week, int? season}) build() => (week: null, season: null);

  void show(int week, int season) => state = (week: week, season: season);

  /// Back to the server's idea of now.
  void showCurrent() => state = (week: null, season: null);

  /// A week of the current journey (the server fills in its season).
  void showWeek(int week) => state = (week: week, season: null);
}

/// One unit of work the planner can have open on a day.
enum SlotWork {
  /// Writing, or rewriting, the day's post.
  writing,

  /// Drawing a new poster for the post the day already has.
  poster,

  /// Rewriting the day's title.
  title,

  /// Saving the sheet's edits to the title and the body.
  saving,

  /// Writing the day's video script, or recording that it went out.
  script,

  /// "Fix with AI" — the review's rewrite.
  refine,

  /// The day's photo is uploading.
  photo,

  /// The day's image is being made through /planner/image.
  image,

  /// The week's news is being searched or picked.
  news,
}

/// What the planner has in flight, per day.
///
/// ## Why this is not five `bool`s on the slot sheet
///
/// It was, until this change. The sheet is a modal bottom sheet, every one of
/// these operations is a model call that takes seconds, and four of the five
/// count against the plan — so the ordinary gesture of swiping the sheet away while one is
/// running destroyed the only record that it was running. Re-opening the day
/// then showed "Write this post", "New image" or "Write the script" fully
/// live, and a second tap bought a second one.
///
/// The slot's own `status` covers exactly one of the five: [SlotWork.writing]
/// is also guarded by `SlotStatus.generating`, which the server sets under a
/// row lock. The other four have no server-side marker at all —
/// `regeneratePoster` draws an image without touching the slot's status, and
/// `VideoScriptsController.generate` is deliberately not optimistic — so for
/// those the widget's flag was the ONLY thing standing between a dismissed
/// sheet and a duplicate charge.
///
/// ## Why keepAlive, and why per-slot
///
/// `keepAlive` because the point is to outlive the sheet: an autoDispose
/// provider whose only watcher is that sheet would be torn down by the same
/// swipe, which is the defect rather than the fix. Nothing accumulates — every
/// entry is cleared in a `finally` and a day with no work open is removed from
/// the map, so the steady state is empty.
///
/// Per-slot rather than one screen-wide flag for the reason the schedules list
/// learned the hard way: one boolean cannot say WHICH day is working, and the
/// week strip behind the sheet shows all seven.
@Riverpod(keepAlive: true)
class PlannerBusy extends _$PlannerBusy {
  @override
  Map<int, Set<SlotWork>> build() => const <int, Set<SlotWork>>{};

  /// Runs [action] with [work] marked open on [slotIndex].
  ///
  /// The marker is cleared in a `finally`, so a throwing use case — and
  /// [PlannerController.generate] rethrows [PlannerGenerateFailure] on purpose
  /// — leaves no day stuck spinning.
  Future<T> run<T>(
    int slotIndex,
    SlotWork work,
    Future<T> Function() action,
  ) async {
    _mark(slotIndex, work, open: true);
    try {
      return await action();
    } finally {
      _mark(slotIndex, work, open: false);
    }
  }

  void _mark(int slotIndex, SlotWork work, {required bool open}) {
    final Map<int, Set<SlotWork>> next = <int, Set<SlotWork>>{...state};
    final Set<SlotWork> running = <SlotWork>{...?next[slotIndex]};
    if (open) {
      running.add(work);
    } else {
      running.remove(work);
    }
    if (running.isEmpty) {
      next.remove(slotIndex);
    } else {
      next[slotIndex] = running;
    }
    state = next;
  }
}

/// The week plan.
@riverpod
class PlannerController extends _$PlannerController {
  @override
  Future<PlannerState> build() {
    final ({int? week, int? season}) target = ref.watch(plannerWeekProvider);
    return ref
        .watch(plannerRepositoryProvider)
        .fetchWeek(week: target.week, season: target.season);
  }

  /// Approves a generated draft.
  ///
  /// Optimistic: the slot flips immediately and is reconciled from the server's
  /// response. Approving is the single most-tapped action on this screen and a
  /// round-trip of dead UI for it reads as a broken button.
  /// Writes the post for a slot, or replaces it when [force] is true.
  ///
  /// Marks the slot `generating` locally first so the row shows work in
  /// progress — the server does the same thing under a row lock, and the
  /// call takes seconds, not milliseconds. On any failure the local state is
  /// re-read rather than guessed: the server rolls the slot back to
  /// `planned`, and inventing that here would be a second source of truth.
  ///
  /// Rethrows [PlannerGenerateFailure] so the caller can say which of the
  /// three things the user has to do.
  ///
  /// In-flight on [PlannerBusy] rather than on the sheet that started it: the
  /// optimistic `generating` status below covers the row behind the sheet, but
  /// not the sheet's own button once the sheet has been dismissed and
  /// re-opened.
  Future<GeneratedSlot?> generate(int slotIndex, {bool force = false}) => ref
      .read(plannerBusyProvider.notifier)
      .run(
        slotIndex,
        SlotWork.writing,
        () => _generate(slotIndex, force: force),
      );

  Future<GeneratedSlot?> _generate(int slotIndex, {bool force = false}) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return null;

    final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
    optimistic[slotIndex] = optimistic[slotIndex].copyWith(
      status: SlotStatus.generating,
    );
    state = AsyncData<PlannerState>(
      current!.copyWith(plan: plan.copyWith(posts: optimistic)),
    );

    try {
      // The slot's own format decides which generator runs. Branching here
      // rather than inside the repository keeps the two server routes
      // visible as two routes — they claim and roll back independently.
      final PlannerRepository repo = ref.read(plannerRepositoryProvider);
      final bool isCarousel = plan.posts[slotIndex].format == 'carousel';
      final GeneratedSlot result = isCarousel
          ? await repo.generateSlotCarousel(
              planId: plan.id,
              slotIndex: slotIndex,
              force: force,
            )
          : await repo.generateSlotPost(
              planId: plan.id,
              slotIndex: slotIndex,
              force: force,
            );
      // The carousel route draws its own slides; only the text path leaves a
      // day needing artwork. Before the refetch, so the invalidation that
      // reloads the row happens once, with the image already attached.
      if (!isCarousel) await _attachPoster(repo, plan, slotIndex, result);
      ref.invalidateSelf();
      return result;
    } on PlannerGenerateFailure {
      ref.invalidateSelf();
      rethrow;
    } on Object {
      ref.invalidateSelf();
      return null;
    }
  }

  /// Draws the day's poster and hangs it on the post that was just written.
  ///
  /// ## Why this is a second call
  ///
  /// `generatePlannerPost` returns a body and nothing else — by design. The
  /// poster is a separate model call with its own price, and the server has
  /// never drawn one as part of generating a slot; the web's planner makes
  /// this same pair of calls, in this same order. A client that stops at the
  /// first one therefore produces a post with no image, which is exactly what
  /// the phone did: both of the week's posted days are `text_image`, so every
  /// planner post generated on mobile arrived as bare text while the identical
  /// slot generated on web arrived with a poster.
  ///
  /// ## Why nothing in here is fatal
  ///
  /// The post already exists and has already counted against the plan. A
  /// poster that fails costs the user an image they can redo; letting that failure escape
  /// would cost them the post, and the planner row would roll back to
  /// `planned` over artwork. So every step swallows: no poster, no `imageUrl`
  /// in the answer, or a PATCH that does not land all leave the day exactly as
  /// a successful text-only generation would have.
  Future<void> _attachPoster(
    PlannerRepository repo,
    WeekPlan plan,
    int slotIndex,
    GeneratedSlot result,
  ) async {
    final PlanSlot slot = plan.posts[slotIndex];
    // `alreadyGenerated` means another request wrote this slot — its poster
    // went with it, and drawing a second one would charge for an image that
    // replaces one already on the post.
    if (result.alreadyGenerated) return;
    final String? postId = result.postId;
    if (postId == null || postId.isEmpty) return;

    // A playbook day's image is made by the kind its format wants, through
    // /planner/image — never the old poster: a photo day wants the user's
    // photo and a card day a card, and an AI poster on either would charge
    // for an image the format does not use (PLANNER_REDESIGN.md §3.8).
    if (slot.isNewShape) {
      await _attachSlotImage(repo, plan, slotIndex);
      return;
    }
    if (slot.format != 'text_image') return;

    // The badge is decoration. The web sends an empty name and no avatar when
    // the session has not loaded and gets a poster back regardless, so a
    // profile read that fails must not stop the image.
    String userName = '';
    String? profileImageUrl;
    try {
      final AccountSnapshot account = await ref.read(
        accountSnapshotProvider.future,
      );
      userName = account.user.name;
      profileImageUrl = account.user.avatarUrl;
    } on Object {
      userName = '';
      profileImageUrl = null;
    }

    try {
      final String? imageUrl = await repo.generateSlotPoster(
        topic: plan.topic ?? '',
        content: _posterBrief(result.content, slot.title, plan.topic),
        // The slot's title, not the server's echo of it: the user may have
        // renamed the day, and the overlay should carry what they see.
        posterTitle: slot.title,
        slotType: slot.type,
        userName: userName,
        profileImageUrl: profileImageUrl,
        posterTag: slot.posterTag,
      );
      if (imageUrl == null || imageUrl.isEmpty) return;
      // The raw `data:` URI goes up as-is — the server turns it into a Storage
      // upload on the way in. See [PlannerRepository.attachPostImage].
      await repo.attachPostImage(postId: postId, imageUrl: imageUrl);
    } on Object {
      // Deliberately swallowed — see the doc comment.
    }
  }

  /// Draws a NEW poster for the post a slot already has.
  ///
  /// The deliberate opposite of [_attachPoster] in two ways. It runs on
  /// demand rather than as a silent tail of generation, so its failure is
  /// REPORTED — the user pressed a button that uses their plan, and
  /// swallowing that would leave them staring at the old image wondering whether anything
  /// happened. And it draws from the post's own body rather than from a
  /// generation result, because by now the user may have edited the words the
  /// picture is supposed to illustrate.
  ///
  /// Returns whether a new image landed.
  ///
  /// The one use case with NO server-side marker: nothing about the slot
  /// changes while the image is being drawn, so [PlannerBusy] is the only
  /// record that a paid-for poster is already on its way.
  /// The image a playbook day gets right after its text is written — the
  /// web's `autoImageMode`. Posters and cards are made at once. A photo day
  /// only when the user already gave a photo (`auto` then honours their
  /// consent: the photo as a reference with it, as it is without); with no
  /// photo the image step asks for one instead of drawing a fallback card.
  ///
  /// Swallows every failure, like the poster before it: a missing image is a
  /// step the user can redo, never a lost post.
  Future<void> _attachSlotImage(
    PlannerRepository repo,
    WeekPlan plan,
    int slotIndex,
  ) async {
    // The image follows the format the post was WRITTEN in, not the planned
    // one: generation moves a day to a fallback format when its facts were
    // spent in between, or when a news pick went stale, and rewrites the
    // slot's formatId / imageKind to match (the web's `writtenSlot`). So the
    // day is re-read rather than trusted from the plan captured before the
    // call — that also carries the company photo → text card rule.
    final PlanSlot slot;
    try {
      final PlannerState fresh = await repo.fetchWeek(
        week: plan.weekNumber,
        season: plan.season,
      );
      final PlanSlot? written = fresh.plan?.posts.elementAtOrNull(slotIndex);
      if (written == null) return;
      slot = written;
    } on Object {
      return;
    }
    final ImageKind? kind = slot.imageKind;
    if (kind == null || !slot.hasPost) return;
    if (kind == ImageKind.photo && !slot.hasReferencePhoto) return;
    try {
      await repo.makeSlotImage(
        weekNumber: plan.weekNumber,
        season: plan.season,
        dayIndex: slotIndex,
        mode: SlotImageMode.auto,
      );
    } on Object {
      // Nothing to undo: the post is written and the image step stays open.
    }
  }

  // ── The playbook week: review, image step, news ─────────────────────────

  /// "Fix with AI" for one day. Says what came back on [plannerNotesProvider]
  /// and rethrows a [PlannerActionFailure] (a plan refusal carries
  /// `refusal`, for the sheet).
  Future<RefineResult> refine(int slotIndex) => _noted(
    slotIndex,
    SlotWork.refine,
    fallback: 'Could not fix this post.',
    () async {
      final WeekPlan plan = _requirePlan(slotIndex);
      final ({int week, int season})? asked = _weekOnScreen();
      try {
        final RefineResult r = await ref
            .read(plannerRepositoryProvider)
            .refinePost(
              weekNumber: plan.weekNumber,
              season: plan.season,
              dayIndex: slotIndex,
            );
        _note(
          slotIndex,
          SlotWork.refine,
          r.ok && r.changed
              ? 'Rewritten to pass the review.'
              : r.ok
              ? 'It already passes.'
              : 'Plexa could not fix every rule — edit the post, or write it '
                    'again.',
          week: asked,
        );
        return r;
      } finally {
        _refreshSlot(plan, slotIndex);
      }
    },
  );

  /// Stores the day's photo; its 10-minute preview goes on
  /// [plannerPhotoPreviewsProvider]. Rethrows [PlannerActionFailure].
  Future<SlotPhotoUpload> uploadPhoto(int slotIndex, PickedImage photo) =>
      _noted(
        slotIndex,
        SlotWork.photo,
        fallback: 'Could not upload the photo.',
        () async {
          final WeekPlan plan = _requirePlan(slotIndex);
          final ({int week, int season})? asked = _weekOnScreen();
          try {
            final SlotPhotoUpload r = await ref
                .read(plannerRepositoryProvider)
                .uploadSlotPhoto(
                  weekNumber: plan.weekNumber,
                  season: plan.season,
                  dayIndex: slotIndex,
                  bytes: photo.bytes,
                  filename: photo.name,
                );
            // Not onto another week's same weekday (see [_note]).
            if (_weekOnScreen() == asked) {
              ref
                  .read(plannerPhotoPreviewsProvider.notifier)
                  .set(slotIndex, r.previewUrl);
            }
            _note(slotIndex, SlotWork.photo, 'Photo added.', week: asked);
            return r;
          } finally {
            ref.invalidateSelf();
          }
        },
      );

  /// Makes the day's image in [mode]. `consent` is the user's tick on "send
  /// my photo to OpenAI" — never set unasked. Rethrows
  /// [PlannerActionFailure].
  Future<SlotImageMade> makeImage(
    int slotIndex,
    SlotImageMode mode, {
    bool consent = false,
  }) => _noted(
    slotIndex,
    SlotWork.image,
    fallback: 'Could not create the image.',
    () async {
      final WeekPlan plan = _requirePlan(slotIndex);
      final ({int week, int season})? asked = _weekOnScreen();
      try {
        final SlotImageMade r = await ref
            .read(plannerRepositoryProvider)
            .makeSlotImage(
              weekNumber: plan.weekNumber,
              season: plan.season,
              dayIndex: slotIndex,
              mode: mode,
              consent: consent,
            );
        _note(
          slotIndex,
          SlotWork.image,
          'Image added to the post.',
          week: asked,
        );
        return r;
      } on PlannerActionFailure catch (e) {
        // The image step's own words for the refusals it can act on.
        final String? line = switch (e.code) {
          'CONSENT_REQUIRED' =>
            'Tick the box to send your photo to OpenAI first.',
          'NO_PHOTO' => 'Add a photo first.',
          'NO_POST' => 'Write the post first — then make its image.',
          _ => null,
        };
        if (line == null) rethrow;
        throw PlannerActionFailure(code: e.code, message: line);
      } finally {
        _refreshSlot(plan, slotIndex);
      }
    },
  );

  /// Finds (or refreshes) the week's headlines. Rethrows
  /// [PlannerActionFailure].
  Future<NewsResult> findNews() {
    final int day = _newsDay();
    return _noted(
      day,
      SlotWork.news,
      fallback: 'Could not reach the news just now.',
      () async {
        final WeekPlan plan = _requirePlan(day);
        final ({int week, int season})? asked = _weekOnScreen();
        try {
          final NewsResult r = await ref
              .read(plannerRepositoryProvider)
              .findNews(weekNumber: plan.weekNumber, season: plan.season);
          if (r.refreshFoundNone) {
            _note(
              day,
              SlotWork.news,
              'No newer headlines — kept the ones you had.',
              week: asked,
            );
          }
          return r;
        } finally {
          ref.invalidateSelf();
        }
      },
    );
  }

  /// Picks the headline the news post is written from. Rethrows
  /// [PlannerActionFailure].
  Future<NewsResult> pickNews(int pickedIndex) {
    final int day = _newsDay();
    return _noted(
      day,
      SlotWork.news,
      fallback: 'Could not save your pick.',
      () async {
        final WeekPlan plan = _requirePlan(day);
        try {
          return await ref
              .read(plannerRepositoryProvider)
              .pickNews(
                weekNumber: plan.weekNumber,
                season: plan.season,
                pickedIndex: pickedIndex,
              );
        } finally {
          ref.invalidateSelf();
        }
      },
    );
  }

  int _newsDay() => newsDayFor(state.value?.plan?.weekNumber ?? 0).dayIndex;

  /// Runs [action] under the day's busy flag, clearing the day's note for
  /// [work] first and writing the failure's sentence there after. The note
  /// lives on [plannerNotesProvider], so it outlives a sheet dismissed
  /// mid-call (ARCHITECTURE.md: no widget holds an async outcome).
  Future<T> _noted<T>(
    int slotIndex,
    SlotWork work,
    Future<T> Function() action, {
    required String fallback,
  }) => ref.read(plannerBusyProvider.notifier).run(slotIndex, work, () async {
    ref.read(plannerNotesProvider.notifier).clear(slotIndex, work);
    final ({int week, int season})? asked = _weekOnScreen();
    try {
      return await action();
    } on PlannerActionFailure catch (e) {
      _note(slotIndex, work, e.message ?? fallback, isError: true, week: asked);
      rethrow;
    } on Object {
      _note(slotIndex, work, fallback, isError: true, week: asked);
      throw PlannerActionFailure(code: 'FAILED', message: fallback);
    }
  });

  /// Writes a day's note — unless the planner moved to another week while
  /// the call ran: the notes are keyed by day index, so a late note would
  /// land on the same weekday of the week now on screen.
  void _note(
    int slotIndex,
    SlotWork work,
    String text, {
    bool isError = false,
    ({int week, int season})? week,
  }) {
    if (week != null && _weekOnScreen() != week) return;
    ref
        .read(plannerNotesProvider.notifier)
        .say(slotIndex, work, text, isError: isError);
  }

  /// The week actually on screen — not the request record, which can name
  /// the same week two ways ((null, null) for "this week", or its number).
  ({int week, int season})? _weekOnScreen() {
    final WeekPlan? plan = state.value?.plan;
    return plan == null ? null : (week: plan.weekNumber, season: plan.season);
  }

  WeekPlan _requirePlan(int slotIndex) {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null || slotIndex < 0 || slotIndex >= plan.posts.length) {
      throw const PlannerActionFailure(
        code: 'NOT_FOUND',
        message: 'That day is no longer in this week.',
      );
    }
    return plan;
  }

  /// The plan (review, image, news) and the post body (refined text, new
  /// image) both moved on the server.
  void _refreshSlot(WeekPlan plan, int slotIndex) {
    final String? postId = plan.posts[slotIndex].postId;
    if (postId != null && postId.isNotEmpty) {
      ref.invalidate(postDetailProvider(postId));
    }
    ref.invalidateSelf();
  }

  Future<bool> regeneratePoster(int slotIndex) => ref
      .read(plannerBusyProvider.notifier)
      .run(slotIndex, SlotWork.poster, () => _regeneratePoster(slotIndex));

  Future<bool> _regeneratePoster(int slotIndex) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null || slotIndex >= plan.posts.length) return false;

    final PlanSlot slot = plan.posts[slotIndex];
    final String? postId = slot.postId;
    if (postId == null || postId.isEmpty) return false;

    final PlannerRepository repo = ref.read(plannerRepositoryProvider);

    String userName = '';
    String? profileImageUrl;
    try {
      final AccountSnapshot account = await ref.read(
        accountSnapshotProvider.future,
      );
      userName = account.user.name;
      profileImageUrl = account.user.avatarUrl;
    } on Object {
      userName = '';
      profileImageUrl = null;
    }

    // The words as they stand now, not as they were generated.
    String? body;
    try {
      body = (await ref.read(postDetailProvider(postId).future)).content;
    } on Object {
      body = null;
    }

    final String? imageUrl = await repo.generateSlotPoster(
      topic: plan.topic ?? '',
      content: _posterBrief(body, slot.title, plan.topic),
      posterTitle: slot.title,
      slotType: slot.type,
      userName: userName,
      profileImageUrl: profileImageUrl,
      posterTag: slot.posterTag,
    );
    if (imageUrl == null || imageUrl.isEmpty) return false;

    await repo.attachPostImage(postId: postId, imageUrl: imageUrl);
    // Both: the planner carries the slot's preview, the post detail carries
    // the full image, and the sheet shows one of each.
    ref.invalidate(postDetailProvider(postId));
    ref.invalidateSelf();
    return true;
  }

  /// What the poster is drawn FROM: the body just written, then the day's
  /// title, then the week's topic. The web's `postContent || title || topic`,
  /// and the order matters — an empty brief still returns a poster, just a
  /// generic one that illustrates nothing the post says.
  static String _posterBrief(String? content, String title, String? topic) {
    for (final String? candidate in <String?>[content, title, topic]) {
      final String value = candidate?.trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  /// Replaces the week's topic and re-plans the unwritten days.
  ///
  /// Returns the failure message, or null on success. Non-destructive by
  /// contract — days already generated keep their posts — which is why this
  /// does not warn before running.
  Future<String?> changeTopic(String topic) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null) return 'No plan to change.';
    try {
      await ref
          .read(plannerRepositoryProvider)
          .changeTopic(planId: plan.id, topic: topic);
      ref.invalidateSelf();
      return null;
    } on Object {
      return "Couldn't re-plan the week. Try again.";
    }
  }

  /// Rewrites one day's title. Returns the failure message, or null.
  Future<String?> regenerateTitle(int slotIndex) => ref
      .read(plannerBusyProvider.notifier)
      .run(slotIndex, SlotWork.title, () => _regenerateTitle(slotIndex));

  Future<String?> _regenerateTitle(int slotIndex) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null) return null;
    try {
      await ref
          .read(plannerRepositoryProvider)
          .regenerateTitle(planId: plan.id, slotIndex: slotIndex);
      ref.invalidateSelf();
      return null;
    } on Object {
      return "Couldn't rewrite that title. Try again.";
    }
  }

  /// Approves a generated draft, and reports what that actually did.
  ///
  /// Goes through [PlannerRepository.approveSlot] rather than the generic slot
  /// patch: approving moves the Post row too, which is the part that queues
  /// it for publishing. Returns the outcome so the caller can say when it will
  /// go out — or say plainly that nothing was queued — instead of leaving the
  /// user to infer it from a status chip.
  Future<ApproveResult?> approve(int slotIndex) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return null;

    final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
    optimistic[slotIndex] = optimistic[slotIndex].copyWith(
      status: SlotStatus.approved,
    );
    state = AsyncData<PlannerState>(
      current!.copyWith(plan: plan.copyWith(posts: optimistic)),
    );

    try {
      final result = await ref
          .read(plannerRepositoryProvider)
          .approveSlot(planId: plan.id, slotIndex: slotIndex);
      // Every approve answer carries the RAW stored row — no read-time
      // reconciliation, no previews — so it never replaces the planner's
      // state: thumbnails would vanish, a day the publish gate held would
      // read "approved" again, and a held answer's own day too. Keep the
      // optimistic flip (none for a held answer, which moved nothing) and
      // re-read.
      if (result.held) {
        state = AsyncData<PlannerState>(current);
      }
      ref.invalidateSelf();
      return result;
    } on Object {
      // Put the server's truth back. A failed approve that still looks
      // approved is worse than one that visibly did not take.
      ref.invalidateSelf();
      return null;
    }
  }

  /// Writes the sheet's edits: the title to the SLOT row, the body to the
  /// POST row.
  ///
  /// A null argument means the user never touched that field. The dirty flags
  /// that decide it stay on the sheet — only a text field knows whether its
  /// contents are something a person typed or something we put there — but
  /// everything after that decision is a use case: two rows, two endpoints, an
  /// order between them, and one sentence to show when one refuses.
  ///
  /// It lived on `_SlotSheetState` until this change, and the price of that
  /// placement was a widget holding `postLibraryRepositoryProvider` — another
  /// slice's DATA layer — and then hand-invalidating that slice's cache
  /// afterwards, because having written around the controller that owns the
  /// post there was nothing else that could have told it.
  ///
  /// ## The body call sends `content` and NOTHING else. That is load-bearing.
  ///
  /// `updateUserPost` detaches a post from its planner day whenever
  /// `scheduledFor` is PRESENT in the request body — changed or not, null or
  /// not. It clears the slot's `postId` and drops the day back to `planned`.
  /// So the obvious shape for an edit form, one call carrying every field,
  /// would blank the very day it was saving. [PostDetail.save] is used here
  /// rather than the post repository precisely because it cannot send
  /// `scheduledFor`; [PostDetail.setSchedule] is the method that can, and
  /// nothing on this path may ever reach for it.
  ///
  /// Returns an error sentence, or null when everything the user changed
  /// landed.
  Future<String?> saveSlotEdits(int slotIndex, {String? title, String? body}) =>
      ref
          .read(plannerBusyProvider.notifier)
          .run(
            slotIndex,
            SlotWork.saving,
            () => _saveSlotEdits(slotIndex, title: title, body: body),
          );

  Future<String?> _saveSlotEdits(
    int slotIndex, {
    String? title,
    String? body,
  }) async {
    final WeekPlan? plan = state.value?.plan;
    if (plan == null || slotIndex >= plan.posts.length) {
      return 'That day is no longer in this week.';
    }
    final PlanSlot slot = plan.posts[slotIndex];

    try {
      // Title first, so a rename that lands is visible even when the body
      // call is the one that refuses. Through [rename] rather than a bare
      // patch because that is what sets `titleEditedByUser` — the flag that
      // stops the next regenerate overwriting a title someone typed by hand.
      final String trimmed = title?.trim() ?? '';
      if (trimmed.isNotEmpty && trimmed != slot.title) {
        await rename(slotIndex, trimmed);
      }

      // The body goes up exactly as typed. The trim is only to ask whether
      // there is anything here at all — emptying a post is not a save, and
      // the user's own trailing blank line is theirs to keep.
      final String? postId = slot.postId;
      if (body != null && body.trim().isNotEmpty && postId != null) {
        await ref.read(postDetailProvider(postId).notifier).save(content: body);
        // Then re-read both sides. The PATCH answers with the list shape,
        // which carries no `contentEdited`, and the server mirrors a fresh
        // ADVISORY review onto the slot — so without these the review panel
        // would go on saying the user's own words will be "held".
        ref.invalidate(postDetailProvider(postId));
        ref.invalidateSelf();
      }
      return null;
    } on PlannerGenerateFailure catch (e) {
      return e.message ?? 'That did not save.';
    } on Object {
      return 'That did not save. Try again.';
    }
  }

  /// Renames a slot. [titleEditedByUser] tells the generator not to overwrite
  /// it on a regenerate.
  Future<void> rename(int slotIndex, String title) =>
      _patch(slotIndex, title: title, titleEditedByUser: true);

  Future<void> setPosterTag(int slotIndex, String tag) =>
      _patch(slotIndex, posterTag: tag);

  Future<void> _patch(
    int slotIndex, {
    String? title,
    bool? titleEditedByUser,
    SlotStatus? status,
    String? posterTag,
  }) async {
    final PlannerState? current = state.value;
    final WeekPlan? plan = current?.plan;
    if (plan == null) return;

    if (status != null || title != null) {
      final List<PlanSlot> optimistic = List<PlanSlot>.of(plan.posts);
      optimistic[slotIndex] = optimistic[slotIndex].copyWith(
        status: status ?? optimistic[slotIndex].status,
        title: title ?? optimistic[slotIndex].title,
      );
      state = AsyncData<PlannerState>(
        current!.copyWith(plan: plan.copyWith(posts: optimistic)),
      );
    }

    try {
      final WeekPlan updated = await ref
          .read(plannerRepositoryProvider)
          .updateSlot(
            planId: plan.id,
            slotIndex: slotIndex,
            title: title,
            titleEditedByUser: titleEditedByUser,
            status: status,
            posterTag: posterTag,
          );
      state = AsyncData<PlannerState>(current!.copyWith(plan: updated));
    } on Object {
      // Put the server's truth back. A failed approve that still looks approved
      // is worse than one that visibly did not take.
      ref.invalidateSelf();
    }
  }
}

/// The week's video scripts, keyed to the week on screen.
///
/// Its own controller for the same reason the article has one: a script is not
/// one of the week's posts. It is prepared and handed over, it never reaches
/// the publish ladder, and a failed read of it must not cost the user their
/// plan — the planner renders fine with no scripts, it just cannot say which
/// hand-off days are done.
///
/// Watches the PLAN rather than [plannerWeekProvider]. That provider holds
/// `(null, null)` for "whatever the server thinks is current", and the scripts
/// route has no such default — it requires real numbers. Taking them off the
/// loaded plan also guarantees the scripts belong to the week being drawn
/// rather than to today, which matters the moment the user pages backwards.
@riverpod
class VideoScriptsController extends _$VideoScriptsController {
  @override
  Future<List<VideoScript>> build() async {
    final PlannerState planner = await ref.watch(
      plannerControllerProvider.future,
    );
    final WeekPlan? plan = planner.plan;
    if (plan == null) return const <VideoScript>[];

    try {
      return await ref
          .read(plannerRepositoryProvider)
          .fetchWeekScripts(week: plan.weekNumber, season: plan.season);
    } on Object {
      // Swallowed, like the service's own read. The planner is still correct
      // without this; it just falls back to "not written yet" on the two
      // video days, which is the honest answer when we cannot tell.
      return const <VideoScript>[];
    }
  }

  /// The script for one slot, or null.
  VideoScript? forDay(int dayIndex) {
    for (final VideoScript v in state.value ?? const <VideoScript>[]) {
      if (v.dayIndex == dayIndex) return v;
    }
    return null;
  }

  /// Records that the user filmed and posted one.
  ///
  /// The only way a script is ever closed out — see [VideoScript]. Optimistic,
  /// because the user is telling US what they did and the server stores
  /// exactly that; the only failure is a tick that comes back.
  Future<bool> markPosted(int dayIndex) => ref
      .read(plannerBusyProvider.notifier)
      .run(dayIndex, SlotWork.script, () => _markPosted(dayIndex));

  Future<bool> _markPosted(int dayIndex) async {
    final List<VideoScript>? current = state.value;
    if (current == null) return false;
    final int i = current.indexWhere((VideoScript v) => v.dayIndex == dayIndex);
    if (i == -1 || current[i].isPosted) return false;

    state = AsyncData<List<VideoScript>>(
      List<VideoScript>.of(current)
        ..[i] = current[i].copyWith(status: 'published'),
    );

    try {
      final VideoScript? saved = await ref
          .read(plannerRepositoryProvider)
          .markScriptPosted(
            weekNumber: current[i].weekNumber,
            season: current[i].season,
            dayIndex: dayIndex,
          );
      if (saved == null) {
        // 404 — the row went away under us. Put the tick back rather than
        // leaving a day marked done that the server has no record of.
        state = AsyncData<List<VideoScript>>(current);
        return false;
      }
      state = AsyncData<List<VideoScript>>(
        List<VideoScript>.of(state.value ?? current)..[i] = saved,
      );
      return true;
    } on Object {
      state = AsyncData<List<VideoScript>>(current);
      return false;
    }
  }

  /// Writes the script for a day Sunday did not.
  ///
  /// Returns an error sentence, or null on success. Not optimistic — there is
  /// nothing to show until the model answers, and a spinner that resolves into
  /// real content is the honest shape for a call that takes seconds.
  ///
  /// Being non-optimistic is exactly why the in-flight marker has to be on
  /// [PlannerBusy]: nothing anywhere says a script is being written until one
  /// arrives, so a sheet dismissed mid-call and re-opened offered "Write the
  /// script" again.
  Future<String?> generate(int dayIndex, {bool force = false}) => ref
      .read(plannerBusyProvider.notifier)
      .run(dayIndex, SlotWork.script, () => _generate(dayIndex, force: force));

  Future<String?> _generate(int dayIndex, {bool force = false}) async {
    final PlannerState? planner = ref.read(plannerControllerProvider).value;
    final WeekPlan? plan = planner?.plan;
    if (plan == null) return 'The week has not loaded yet.';

    try {
      final VideoScript written = await ref
          .read(plannerRepositoryProvider)
          .generateScript(
            weekNumber: plan.weekNumber,
            season: plan.season,
            dayIndex: dayIndex,
            force: force,
          );
      final List<VideoScript> next = List<VideoScript>.of(
        state.value ?? const <VideoScript>[],
      );
      final int i = next.indexWhere((VideoScript v) => v.dayIndex == dayIndex);
      if (i == -1) {
        next.add(written);
      } else {
        next[i] = written;
      }
      state = AsyncData<List<VideoScript>>(next);
      return null;
    } on Failure catch (f) {
      return f.message;
    } on Object catch (e) {
      // The plan's refusal says when the limit resets; the generic line
      // would invite a retry that is refused the same way.
      return PlanRefusal.fromError(e)?.displayMessage() ??
          'The script could not be written. Try again.';
    }
  }
}

/// The week's long-form article — Thursday's newsletter.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.
@riverpod
class ArticleController extends _$ArticleController {
  @override
  Future<ArticleState> build() {
    final ({int? week, int? season}) target = ref.watch(plannerWeekProvider);
    return ref
        .watch(plannerRepositoryProvider)
        .fetchArticle(week: target.week, season: target.season);
  }

  /// Sets — or clears — the reminder for the week's article.
  ///
  /// Returns an error sentence, or null on success. The server's own words are
  /// passed through on a refusal: "pick a time that has not already passed"
  /// tells the user what to do and a generic failure does not.
  ///
  /// Not optimistic. This is a deliberate choice with a time attached, and a
  /// reminder that appeared to save and then reverted would be worse than one
  /// that took a moment — the user cannot tell whether to expect the nudge.
  /// The article's body, fetched only when something is about to show it.
  ///
  /// The week summary deliberately does not carry it — it was ninety percent
  /// of that response for text no card renders. Null on failure, so the
  /// caller can say so rather than opening an empty sheet or copying nothing.
  ///
  /// Here rather than on the page: reading a repository is the data layer's
  /// business, and the page was importing `data/` for this one call.
  Future<String?> fetchArticleBody(ArticleState a) async {
    final WeeklyArticle? article = a.article;
    if (article == null) return null;
    if (article.hasBody) return article.body;
    try {
      return await ref
          .read(plannerRepositoryProvider)
          .fetchArticleBody(week: a.weekNumber, season: a.season);
    } on Object {
      return null;
    }
  }

  Future<String?> setArticleReminder(DateTime? when) async {
    final ArticleState? current = state.value;
    if (current?.article == null) {
      return 'There is no article to remind you about.';
    }

    try {
      await ref
          .read(plannerRepositoryProvider)
          .setArticleSchedule(
            weekNumber: current!.weekNumber,
            season: current.season,
            when: when,
          );
      ref.invalidateSelf();
      return null;
    } on PlannerScheduleRefused catch (e) {
      return e.message;
    } on Failure catch (f) {
      return f.message;
    } on Object {
      return 'That reminder did not save. Try again.';
    }
  }

  /// Records the name of the newsletter the user created on LinkedIn.
  ///
  /// Returns an error sentence, or null on success.
  ///
  /// Optimistic on the NAME, which is safe — the user typed it and the server
  /// stores it verbatim — and deliberately NOT optimistic on
  /// `isFirstArticle`. That flag does not mean "has a name"; it means LinkedIn
  /// will ask them to create the newsletter while they publish, which is true
  /// for this edition whatever we record. The web makes the same distinction
  /// and for the same reason: flipping it here would delete the
  /// create-a-newsletter step from under the user at exactly the moment they
  /// open LinkedIn and are asked to create one.
  Future<String?> setNewsletterName(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return 'Give the newsletter a name first.';

    final ArticleState? current = state.value;
    if (current != null) {
      state = AsyncData<ArticleState>(
        current.copyWith(newsletterName: trimmed),
      );
    }

    try {
      await ref.read(plannerRepositoryProvider).setNewsletterName(trimmed);
      // DELIBERATELY NOT `invalidateSelf()`.
      //
      // The server answers `isFirstArticle: !newsletterName`, so a refetch
      // here would come back false — and the card's create-a-newsletter note
      // is keyed on that flag. The user would watch the step disappear
      // seconds after naming it, at precisely the moment they tap "Copy &
      // open editor" and LinkedIn asks them to create one.
      //
      // The flag does not mean "has a name". It means LinkedIn will ask them
      // to CREATE the newsletter while they publish THIS edition, which is
      // still true. Recording the name is not creating the newsletter;
      // LinkedIn is where it comes into being. So the local patch stands and
      // the server's answer is picked up on the next natural read — next
      // week, or a pull-to-refresh — by which time it is correct.
      //
      // The web guards the same moment the same way, with its
      // `serverSaysFirst || savedNewsletterName !== null`. Nothing on this
      // screen reads `newsletterCreatedAt`, so skipping the refetch costs
      // nothing.
      return null;
    } on Failure catch (f) {
      if (current != null) state = AsyncData<ArticleState>(current);
      return f.message;
    } on Object {
      if (current != null) state = AsyncData<ArticleState>(current);
      return 'That did not save. Try again.';
    }
  }

  /// Records that the user pasted the article into LinkedIn themselves.
  ///
  /// This is the ONLY way an article is ever marked published: the API cannot
  /// publish one, so it never gets a LinkedIn share URN and the normal
  /// publish path can never close it out.
  Future<void> markPublished({String? url}) async {
    final ArticleState? current = state.value;
    if (current?.article == null) return;

    await ref
        .read(plannerRepositoryProvider)
        .markArticlePublished(
          weekNumber: current!.weekNumber,
          season: current.season,
          publishedUrl: url,
        );
    ref.invalidateSelf();
  }
}

/// Whether the week's news search is switched on, and whether the system
/// searches for this user. Off on any failure — the picker then hides itself
/// on a day with no headlines (the web's `useNewsStatus`).
@riverpod
Future<NewsStatus> plannerNewsStatus(Ref ref) =>
    ref.watch(plannerRepositoryProvider).fetchNewsStatus();

/// One line the planner says about a day's playbook action — what came back,
/// or why not.
class PlannerNote {
  const PlannerNote(this.text, {this.isError = false});

  final String text;
  final bool isError;
}

/// The latest note per day and action (refine, photo, image, news). Owned
/// here rather than by the sheet's widgets, so a note survives the sheet
/// being swiped away mid-call. Reset when the planner shows another week —
/// the notes are keyed by day index.
@Riverpod(keepAlive: true)
class PlannerNotes extends _$PlannerNotes {
  @override
  Map<String, PlannerNote> build() {
    ref.watch(plannerWeekProvider);
    return const <String, PlannerNote>{};
  }

  static String keyOf(int slotIndex, SlotWork work) => '$slotIndex:${work.name}';

  void say(int slotIndex, SlotWork work, String text, {bool isError = false}) =>
      state = <String, PlannerNote>{
        ...state,
        keyOf(slotIndex, work): PlannerNote(text, isError: isError),
      };

  void clear(int slotIndex, SlotWork work) {
    final String k = keyOf(slotIndex, work);
    if (!state.containsKey(k)) return;
    state = <String, PlannerNote>{...state}..remove(k);
  }
}

/// The 10-minute signed preview of a photo uploaded this session, per day.
/// Shown, never stored on the server or reused after the week changes.
@Riverpod(keepAlive: true)
class PlannerPhotoPreviews extends _$PlannerPhotoPreviews {
  @override
  Map<int, String> build() {
    ref.watch(plannerWeekProvider);
    return const <int, String>{};
  }

  void set(int slotIndex, String? url) {
    final Map<int, String> next = <int, String>{...state};
    if (url == null || url.isEmpty) {
      next.remove(slotIndex);
    } else {
      next[slotIndex] = url;
    }
    state = next;
  }
}
