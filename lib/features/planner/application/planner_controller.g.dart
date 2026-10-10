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

String _$plannerWeekHash() => r'5d4061bffbd049b5c9218c5ad0e767231cdf2ac8';

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

String _$plannerControllerHash() => r'66f6ed037d646be0e85c415c46b2ea07887a96f6';

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
    r'bdf4bec643ba0f834bafad45fe22bb4d76f2a93b';

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
