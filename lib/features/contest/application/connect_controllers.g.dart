// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /contest/tasks/connect` — today's leaders, with the sent ticks.
///
/// Free on a contest Monday or Thursday and bounded by the day's stored
/// batch: a re-read replays it, and there is no "new set" to ask for. On any
/// other day the plan gate applies and refuses as `ai/connections` does.
///
/// ## The ticks are the day's, not the page's
///
/// It is the SAME daily batch the ordinary `/connections` page shows — the
/// server keeps one per user per day — so a note copied there counts here
/// and the other way round. The ticks are read from and written to the
/// shared day row, as `ConnectionsController` does. Held only in this
/// auto-dispose notifier they would vanish when the page was popped, and a
/// learner who stepped out to LinkedIn would come back to `0 / 5`.

@ProviderFor(ContestConnectTargets)
final contestConnectTargetsProvider = ContestConnectTargetsProvider._();

/// `GET /contest/tasks/connect` — today's leaders, with the sent ticks.
///
/// Free on a contest Monday or Thursday and bounded by the day's stored
/// batch: a re-read replays it, and there is no "new set" to ask for. On any
/// other day the plan gate applies and refuses as `ai/connections` does.
///
/// ## The ticks are the day's, not the page's
///
/// It is the SAME daily batch the ordinary `/connections` page shows — the
/// server keeps one per user per day — so a note copied there counts here
/// and the other way round. The ticks are read from and written to the
/// shared day row, as `ConnectionsController` does. Held only in this
/// auto-dispose notifier they would vanish when the page was popped, and a
/// learner who stepped out to LinkedIn would come back to `0 / 5`.
final class ContestConnectTargetsProvider
    extends $AsyncNotifierProvider<ContestConnectTargets, ConnectionBatch> {
  /// `GET /contest/tasks/connect` — today's leaders, with the sent ticks.
  ///
  /// Free on a contest Monday or Thursday and bounded by the day's stored
  /// batch: a re-read replays it, and there is no "new set" to ask for. On any
  /// other day the plan gate applies and refuses as `ai/connections` does.
  ///
  /// ## The ticks are the day's, not the page's
  ///
  /// It is the SAME daily batch the ordinary `/connections` page shows — the
  /// server keeps one per user per day — so a note copied there counts here
  /// and the other way round. The ticks are read from and written to the
  /// shared day row, as `ConnectionsController` does. Held only in this
  /// auto-dispose notifier they would vanish when the page was popped, and a
  /// learner who stepped out to LinkedIn would come back to `0 / 5`.
  ContestConnectTargetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestConnectTargetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestConnectTargetsHash();

  @$internal
  @override
  ContestConnectTargets create() => ContestConnectTargets();
}

String _$contestConnectTargetsHash() =>
    r'a352973e7970769e7c9843b0d81c203b337f302f';

/// `GET /contest/tasks/connect` — today's leaders, with the sent ticks.
///
/// Free on a contest Monday or Thursday and bounded by the day's stored
/// batch: a re-read replays it, and there is no "new set" to ask for. On any
/// other day the plan gate applies and refuses as `ai/connections` does.
///
/// ## The ticks are the day's, not the page's
///
/// It is the SAME daily batch the ordinary `/connections` page shows — the
/// server keeps one per user per day — so a note copied there counts here
/// and the other way round. The ticks are read from and written to the
/// shared day row, as `ConnectionsController` does. Held only in this
/// auto-dispose notifier they would vanish when the page was popped, and a
/// learner who stepped out to LinkedIn would come back to `0 / 5`.

abstract class _$ContestConnectTargets extends $AsyncNotifier<ConnectionBatch> {
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

/// `POST /contest/tasks/connect` — "Finish and collect XP".
///
/// Never the roadmap's `completeStep`: in contest mode the page pays the
/// contest task and nothing else.

@ProviderFor(ContestConnectActions)
final contestConnectActionsProvider = ContestConnectActionsProvider._();

/// `POST /contest/tasks/connect` — "Finish and collect XP".
///
/// Never the roadmap's `completeStep`: in contest mode the page pays the
/// contest task and nothing else.
final class ContestConnectActionsProvider
    extends $NotifierProvider<ContestConnectActions, ContestConnectBusy> {
  /// `POST /contest/tasks/connect` — "Finish and collect XP".
  ///
  /// Never the roadmap's `completeStep`: in contest mode the page pays the
  /// contest task and nothing else.
  ContestConnectActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestConnectActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestConnectActionsHash();

  @$internal
  @override
  ContestConnectActions create() => ContestConnectActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContestConnectBusy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContestConnectBusy>(value),
    );
  }
}

String _$contestConnectActionsHash() =>
    r'11bd5a56d46f22da4f8f0fb564f7f14ea73f96e6';

/// `POST /contest/tasks/connect` — "Finish and collect XP".
///
/// Never the roadmap's `completeStep`: in contest mode the page pays the
/// contest task and nothing else.

abstract class _$ContestConnectActions extends $Notifier<ContestConnectBusy> {
  ContestConnectBusy build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContestConnectBusy, ContestConnectBusy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContestConnectBusy, ContestConnectBusy>,
              ContestConnectBusy,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
