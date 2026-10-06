// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engagement_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where the user is on the 66-day roadmap.
///
/// Read once per screen and shared by both, rather than folded into each
/// batch controller: the two habits sit on the SAME day, and a failed roadmap
/// read must not take the generated batch down with it. The screens render the
/// batch and the mission independently for exactly that reason.

@ProviderFor(engagementProgress)
final engagementProgressProvider = EngagementProgressProvider._();

/// Where the user is on the 66-day roadmap.
///
/// Read once per screen and shared by both, rather than folded into each
/// batch controller: the two habits sit on the SAME day, and a failed roadmap
/// read must not take the generated batch down with it. The screens render the
/// batch and the mission independently for exactly that reason.

final class EngagementProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoadmapProgress>,
          RoadmapProgress,
          FutureOr<RoadmapProgress>
        >
    with $FutureModifier<RoadmapProgress>, $FutureProvider<RoadmapProgress> {
  /// Where the user is on the 66-day roadmap.
  ///
  /// Read once per screen and shared by both, rather than folded into each
  /// batch controller: the two habits sit on the SAME day, and a failed roadmap
  /// read must not take the generated batch down with it. The screens render the
  /// batch and the mission independently for exactly that reason.
  EngagementProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'engagementProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$engagementProgressHash();

  @$internal
  @override
  $FutureProviderElement<RoadmapProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RoadmapProgress> create(Ref ref) {
    return engagementProgress(ref);
  }
}

String _$engagementProgressHash() =>
    r'f871949ec6cbed625ea9afdd32edecde52ab697f';

/// Today's roadmap step for one of the two habit screens.
///
/// Null is a real answer, not an error — see [EngagementMission.locate]. The
/// family key is the web-identical `moduleLink` the roadmap stores, which is
/// the same string as the route, so `/comments` and `/connections` are the
/// only two values that ever reach it.

@ProviderFor(engagementMission)
final engagementMissionProvider = EngagementMissionFamily._();

/// Today's roadmap step for one of the two habit screens.
///
/// Null is a real answer, not an error — see [EngagementMission.locate]. The
/// family key is the web-identical `moduleLink` the roadmap stores, which is
/// the same string as the route, so `/comments` and `/connections` are the
/// only two values that ever reach it.

final class EngagementMissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<EngagementMission?>,
          EngagementMission?,
          FutureOr<EngagementMission?>
        >
    with
        $FutureModifier<EngagementMission?>,
        $FutureProvider<EngagementMission?> {
  /// Today's roadmap step for one of the two habit screens.
  ///
  /// Null is a real answer, not an error — see [EngagementMission.locate]. The
  /// family key is the web-identical `moduleLink` the roadmap stores, which is
  /// the same string as the route, so `/comments` and `/connections` are the
  /// only two values that ever reach it.
  EngagementMissionProvider._({
    required EngagementMissionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'engagementMissionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$engagementMissionHash();

  @override
  String toString() {
    return r'engagementMissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EngagementMission?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EngagementMission?> create(Ref ref) {
    final argument = this.argument as String;
    return engagementMission(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EngagementMissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$engagementMissionHash() => r'484bce24311b2fc969d2f9278c4f46e73b236948';

/// Today's roadmap step for one of the two habit screens.
///
/// Null is a real answer, not an error — see [EngagementMission.locate]. The
/// family key is the web-identical `moduleLink` the roadmap stores, which is
/// the same string as the route, so `/comments` and `/connections` are the
/// only two values that ever reach it.

final class EngagementMissionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EngagementMission?>, String> {
  EngagementMissionFamily._()
    : super(
        retry: null,
        name: r'engagementMissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Today's roadmap step for one of the two habit screens.
  ///
  /// Null is a real answer, not an error — see [EngagementMission.locate]. The
  /// family key is the web-identical `moduleLink` the roadmap stores, which is
  /// the same string as the route, so `/comments` and `/connections` are the
  /// only two values that ever reach it.

  EngagementMissionProvider call(String moduleLink) =>
      EngagementMissionProvider._(argument: moduleLink, from: this);

  @override
  String toString() => r'engagementMissionProvider';
}

/// The day's comment batch.
///
/// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
/// topic=…`) asks for comments about the user's OWN post rather than the
/// server's niche pick. A null or empty topic is the ordinary path and lets the
/// server choose.
///
/// Generation fires on first watch, which mirrors the web: the page has no
/// "generate" button in practice, because it auto-fetches on mount and the
/// day's batch is replayed for free afterwards.

@ProviderFor(CommentsController)
final commentsControllerProvider = CommentsControllerFamily._();

/// The day's comment batch.
///
/// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
/// topic=…`) asks for comments about the user's OWN post rather than the
/// server's niche pick. A null or empty topic is the ordinary path and lets the
/// server choose.
///
/// Generation fires on first watch, which mirrors the web: the page has no
/// "generate" button in practice, because it auto-fetches on mount and the
/// day's batch is replayed for free afterwards.
final class CommentsControllerProvider
    extends $AsyncNotifierProvider<CommentsController, CommentBatch> {
  /// The day's comment batch.
  ///
  /// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
  /// topic=…`) asks for comments about the user's OWN post rather than the
  /// server's niche pick. A null or empty topic is the ordinary path and lets the
  /// server choose.
  ///
  /// Generation fires on first watch, which mirrors the web: the page has no
  /// "generate" button in practice, because it auto-fetches on mount and the
  /// day's batch is replayed for free afterwards.
  CommentsControllerProvider._({
    required CommentsControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'commentsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsControllerHash();

  @override
  String toString() {
    return r'commentsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentsController create() => CommentsController();

  @override
  bool operator ==(Object other) {
    return other is CommentsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsControllerHash() =>
    r'dd33d000e7b116995e1c1a09b663210d27980422';

/// The day's comment batch.
///
/// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
/// topic=…`) asks for comments about the user's OWN post rather than the
/// server's niche pick. A null or empty topic is the ordinary path and lets the
/// server choose.
///
/// Generation fires on first watch, which mirrors the web: the page has no
/// "generate" button in practice, because it auto-fetches on mount and the
/// day's batch is replayed for free afterwards.

final class CommentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentsController,
          AsyncValue<CommentBatch>,
          CommentBatch,
          FutureOr<CommentBatch>,
          String?
        > {
  CommentsControllerFamily._()
    : super(
        retry: null,
        name: r'commentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The day's comment batch.
  ///
  /// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
  /// topic=…`) asks for comments about the user's OWN post rather than the
  /// server's niche pick. A null or empty topic is the ordinary path and lets the
  /// server choose.
  ///
  /// Generation fires on first watch, which mirrors the web: the page has no
  /// "generate" button in practice, because it auto-fetches on mount and the
  /// day's batch is replayed for free afterwards.

  CommentsControllerProvider call(String? topic) =>
      CommentsControllerProvider._(argument: topic, from: this);

  @override
  String toString() => r'commentsControllerProvider';
}

/// The day's comment batch.
///
/// Keyed by [topic] so the golden-hour deep link (`?context=golden_hour&
/// topic=…`) asks for comments about the user's OWN post rather than the
/// server's niche pick. A null or empty topic is the ordinary path and lets the
/// server choose.
///
/// Generation fires on first watch, which mirrors the web: the page has no
/// "generate" button in practice, because it auto-fetches on mount and the
/// day's batch is replayed for free afterwards.

abstract class _$CommentsController extends $AsyncNotifier<CommentBatch> {
  late final _$args = ref.$arg as String?;
  String? get topic => _$args;

  FutureOr<CommentBatch> build(String? topic);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CommentBatch>, CommentBatch>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommentBatch>, CommentBatch>,
              AsyncValue<CommentBatch>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// The day's connection targets.

@ProviderFor(ConnectionsController)
final connectionsControllerProvider = ConnectionsControllerProvider._();

/// The day's connection targets.
final class ConnectionsControllerProvider
    extends $AsyncNotifierProvider<ConnectionsController, ConnectionBatch> {
  /// The day's connection targets.
  ConnectionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionsControllerHash();

  @$internal
  @override
  ConnectionsController create() => ConnectionsController();
}

String _$connectionsControllerHash() =>
    r'62f7721648c351ae6c729487c44a986ca7ebfc08';

/// The day's connection targets.

abstract class _$ConnectionsController extends $AsyncNotifier<ConnectionBatch> {
  FutureOr<ConnectionBatch> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ConnectionBatch>, ConnectionBatch>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConnectionBatch>, ConnectionBatch>,
              AsyncValue<ConnectionBatch>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Claiming the roadmap step's XP.
///
/// Its own notifier rather than a flag on either batch controller, because the
/// write is about the ROADMAP, not about the batch: it must survive a batch
/// refresh, and it invalidates [engagementProgressProvider] so the step comes
/// back marked complete without a second round of guessing on the client.
///
/// Not optimistic. Awarding XP in the UI before the server has recorded it is
/// the one thing a gamified surface must never get wrong — a step that looks
/// claimed but was not is a support ticket, and the write is a single fast POST.

@ProviderFor(StepCompletion)
final stepCompletionProvider = StepCompletionProvider._();

/// Claiming the roadmap step's XP.
///
/// Its own notifier rather than a flag on either batch controller, because the
/// write is about the ROADMAP, not about the batch: it must survive a batch
/// refresh, and it invalidates [engagementProgressProvider] so the step comes
/// back marked complete without a second round of guessing on the client.
///
/// Not optimistic. Awarding XP in the UI before the server has recorded it is
/// the one thing a gamified surface must never get wrong — a step that looks
/// claimed but was not is a support ticket, and the write is a single fast POST.
final class StepCompletionProvider
    extends $AsyncNotifierProvider<StepCompletion, bool> {
  /// Claiming the roadmap step's XP.
  ///
  /// Its own notifier rather than a flag on either batch controller, because the
  /// write is about the ROADMAP, not about the batch: it must survive a batch
  /// refresh, and it invalidates [engagementProgressProvider] so the step comes
  /// back marked complete without a second round of guessing on the client.
  ///
  /// Not optimistic. Awarding XP in the UI before the server has recorded it is
  /// the one thing a gamified surface must never get wrong — a step that looks
  /// claimed but was not is a support ticket, and the write is a single fast POST.
  StepCompletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepCompletionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepCompletionHash();

  @$internal
  @override
  StepCompletion create() => StepCompletion();
}

String _$stepCompletionHash() => r'4695bf45c4533cf2061a1ad38870234360d9d61d';

/// Claiming the roadmap step's XP.
///
/// Its own notifier rather than a flag on either batch controller, because the
/// write is about the ROADMAP, not about the batch: it must survive a batch
/// refresh, and it invalidates [engagementProgressProvider] so the step comes
/// back marked complete without a second round of guessing on the client.
///
/// Not optimistic. Awarding XP in the UI before the server has recorded it is
/// the one thing a gamified surface must never get wrong — a step that looks
/// claimed but was not is a support ticket, and the write is a single fast POST.

abstract class _$StepCompletion extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
