// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which week the planner is showing.
///
/// Null means "whatever the server says is current" — the server owns the
/// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
/// and the client must not recompute it or it will ask for a week the plan was
/// never saved under.

@ProviderFor(PlannerWeek)
final plannerWeekProvider = PlannerWeekProvider._();

/// Which week the planner is showing.
///
/// Null means "whatever the server says is current" — the server owns the
/// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
/// and the client must not recompute it or it will ask for a week the plan was
/// never saved under.
final class PlannerWeekProvider
    extends $NotifierProvider<PlannerWeek, ({int? season, int? week})> {
  /// Which week the planner is showing.
  ///
  /// Null means "whatever the server says is current" — the server owns the
  /// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
  /// and the client must not recompute it or it will ask for a week the plan was
  /// never saved under.
  PlannerWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerWeekHash();

  @$internal
  @override
  PlannerWeek create() => PlannerWeek();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int? season, int? week}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int? season, int? week})>(value),
    );
  }
}

String _$plannerWeekHash() => r'9ac67e62786fb16af335254aee63cc168dcc2cf9';

/// Which week the planner is showing.
///
/// Null means "whatever the server says is current" — the server owns the
/// current-week calculation (a calendar Sun–Sat anchor off roadmapStartedAt),
/// and the client must not recompute it or it will ask for a week the plan was
/// never saved under.

abstract class _$PlannerWeek extends $Notifier<({int? season, int? week})> {
  ({int? season, int? week}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<({int? season, int? week}), ({int? season, int? week})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({int? season, int? week}),
                ({int? season, int? week})
              >,
              ({int? season, int? week}),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
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

@ProviderFor(PlannerBusy)
final plannerBusyProvider = PlannerBusyProvider._();

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
final class PlannerBusyProvider
    extends $NotifierProvider<PlannerBusy, Map<int, Set<SlotWork>>> {
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
  PlannerBusyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerBusyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerBusyHash();

  @$internal
  @override
  PlannerBusy create() => PlannerBusy();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, Set<SlotWork>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, Set<SlotWork>>>(value),
    );
  }
}

String _$plannerBusyHash() => r'2495daf62a21de9703ac5aad5fd4c2bb949020d7';

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

abstract class _$PlannerBusy extends $Notifier<Map<int, Set<SlotWork>>> {
  Map<int, Set<SlotWork>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<int, Set<SlotWork>>, Map<int, Set<SlotWork>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, Set<SlotWork>>, Map<int, Set<SlotWork>>>,
              Map<int, Set<SlotWork>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The week plan.

@ProviderFor(PlannerController)
final plannerControllerProvider = PlannerControllerProvider._();

/// The week plan.
final class PlannerControllerProvider
    extends $AsyncNotifierProvider<PlannerController, PlannerState> {
  /// The week plan.
  PlannerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerControllerHash();

  @$internal
  @override
  PlannerController create() => PlannerController();
}

String _$plannerControllerHash() => r'330b3a878eec12fb7ccacda76db4c0e6b1c5ffa7';

/// The week plan.

abstract class _$PlannerController extends $AsyncNotifier<PlannerState> {
  FutureOr<PlannerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlannerState>, PlannerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlannerState>, PlannerState>,
              AsyncValue<PlannerState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
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

@ProviderFor(VideoScriptsController)
final videoScriptsControllerProvider = VideoScriptsControllerProvider._();

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
final class VideoScriptsControllerProvider
    extends $AsyncNotifierProvider<VideoScriptsController, List<VideoScript>> {
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
  VideoScriptsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoScriptsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoScriptsControllerHash();

  @$internal
  @override
  VideoScriptsController create() => VideoScriptsController();
}

String _$videoScriptsControllerHash() =>
    r'def2fe6025a537107ec43f0ce30b6f714dd57b60';

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

abstract class _$VideoScriptsController
    extends $AsyncNotifier<List<VideoScript>> {
  FutureOr<List<VideoScript>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<VideoScript>>, List<VideoScript>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VideoScript>>, List<VideoScript>>,
              AsyncValue<List<VideoScript>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The week's long-form article — Thursday's newsletter.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.

@ProviderFor(ArticleController)
final articleControllerProvider = ArticleControllerProvider._();

/// The week's long-form article — Thursday's newsletter.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.
final class ArticleControllerProvider
    extends $AsyncNotifierProvider<ArticleController, ArticleState> {
  /// The week's long-form article — Thursday's newsletter.
  ///
  /// Separate from [PlannerController] because the article is not one of the
  /// week's posts — it is the week's spine, it generates even in maintenance
  /// mode, and a failed article must never cost the user their plan.
  ArticleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'articleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$articleControllerHash();

  @$internal
  @override
  ArticleController create() => ArticleController();
}

String _$articleControllerHash() => r'028d1da4bb897bdde852be5078ec73cdac5f32bb';

/// The week's long-form article — Thursday's newsletter.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.

abstract class _$ArticleController extends $AsyncNotifier<ArticleState> {
  FutureOr<ArticleState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ArticleState>, ArticleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ArticleState>, ArticleState>,
              AsyncValue<ArticleState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether the week's news search is switched on, and whether the system
/// searches for this user. Off on any failure — the picker then hides itself
/// on a day with no headlines (the web's `useNewsStatus`).

@ProviderFor(plannerNewsStatus)
final plannerNewsStatusProvider = PlannerNewsStatusProvider._();

/// Whether the week's news search is switched on, and whether the system
/// searches for this user. Off on any failure — the picker then hides itself
/// on a day with no headlines (the web's `useNewsStatus`).

final class PlannerNewsStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<NewsStatus>,
          NewsStatus,
          FutureOr<NewsStatus>
        >
    with $FutureModifier<NewsStatus>, $FutureProvider<NewsStatus> {
  /// Whether the week's news search is switched on, and whether the system
  /// searches for this user. Off on any failure — the picker then hides itself
  /// on a day with no headlines (the web's `useNewsStatus`).
  PlannerNewsStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerNewsStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerNewsStatusHash();

  @$internal
  @override
  $FutureProviderElement<NewsStatus> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NewsStatus> create(Ref ref) {
    return plannerNewsStatus(ref);
  }
}

String _$plannerNewsStatusHash() => r'f74bc5ae9f03eee79de7a9800b09cbbd56ead4cd';

/// The latest note per day and action (refine, photo, image, news). Owned
/// here rather than by the sheet's widgets, so a note survives the sheet
/// being swiped away mid-call. Reset when the planner shows another week —
/// the notes are keyed by day index.

@ProviderFor(PlannerNotes)
final plannerNotesProvider = PlannerNotesProvider._();

/// The latest note per day and action (refine, photo, image, news). Owned
/// here rather than by the sheet's widgets, so a note survives the sheet
/// being swiped away mid-call. Reset when the planner shows another week —
/// the notes are keyed by day index.
final class PlannerNotesProvider
    extends $NotifierProvider<PlannerNotes, Map<String, PlannerNote>> {
  /// The latest note per day and action (refine, photo, image, news). Owned
  /// here rather than by the sheet's widgets, so a note survives the sheet
  /// being swiped away mid-call. Reset when the planner shows another week —
  /// the notes are keyed by day index.
  PlannerNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerNotesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerNotesHash();

  @$internal
  @override
  PlannerNotes create() => PlannerNotes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, PlannerNote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, PlannerNote>>(value),
    );
  }
}

String _$plannerNotesHash() => r'cb3e3e9f409dc14184349cef0e0168f0c8161d0a';

/// The latest note per day and action (refine, photo, image, news). Owned
/// here rather than by the sheet's widgets, so a note survives the sheet
/// being swiped away mid-call. Reset when the planner shows another week —
/// the notes are keyed by day index.

abstract class _$PlannerNotes extends $Notifier<Map<String, PlannerNote>> {
  Map<String, PlannerNote> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, PlannerNote>, Map<String, PlannerNote>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, PlannerNote>, Map<String, PlannerNote>>,
              Map<String, PlannerNote>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The 10-minute signed preview of a photo uploaded this session, per day.
/// Shown, never stored on the server or reused after the week changes.

@ProviderFor(PlannerPhotoPreviews)
final plannerPhotoPreviewsProvider = PlannerPhotoPreviewsProvider._();

/// The 10-minute signed preview of a photo uploaded this session, per day.
/// Shown, never stored on the server or reused after the week changes.
final class PlannerPhotoPreviewsProvider
    extends $NotifierProvider<PlannerPhotoPreviews, Map<int, String>> {
  /// The 10-minute signed preview of a photo uploaded this session, per day.
  /// Shown, never stored on the server or reused after the week changes.
  PlannerPhotoPreviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerPhotoPreviewsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerPhotoPreviewsHash();

  @$internal
  @override
  PlannerPhotoPreviews create() => PlannerPhotoPreviews();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, String>>(value),
    );
  }
}

String _$plannerPhotoPreviewsHash() =>
    r'2bdbfd0f4bd82b21f7132ff82dd26b4845ae33f1';

/// The 10-minute signed preview of a photo uploaded this session, per day.
/// Shown, never stored on the server or reused after the week changes.

abstract class _$PlannerPhotoPreviews extends $Notifier<Map<int, String>> {
  Map<int, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, String>, Map<int, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, String>, Map<int, String>>,
              Map<int, String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
