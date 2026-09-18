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

String _$plannerControllerHash() => r'55b447d18b5146a5cb92640c0335f3808e366f3b';

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

/// The week's Sunday article.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.

@ProviderFor(ArticleController)
final articleControllerProvider = ArticleControllerProvider._();

/// The week's Sunday article.
///
/// Separate from [PlannerController] because the article is not one of the
/// week's posts — it is the week's spine, it generates even in maintenance
/// mode, and a failed article must never cost the user their plan.
final class ArticleControllerProvider
    extends $AsyncNotifierProvider<ArticleController, ArticleState> {
  /// The week's Sunday article.
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

String _$articleControllerHash() => r'58f0263b8e55ec6310274f30f6e7c6f736110bab';

/// The week's Sunday article.
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
