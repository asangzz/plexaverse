// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_level_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /contest/tasks/comment`, behind the path's gate.
///
/// ## The gate comes first, and it is not a formality
///
/// This GET WRITES. The day's first read builds the level — the server picks
/// the post and spends a model call on the comment — and the server does not
/// check the gate here; only the answer does. A level read while the path
/// still shows it locked would spend the call and write the day's row for a
/// level the learner cannot play yet. The web waits on the path for the same
/// reason (`useTodayLock`); this waits too, and never asks while locked.
///
/// A path that FAILED is not a gate: the level is read, and the answer's 409
/// LOCKED still holds.
///
/// ## Writing
///
/// While another request is writing today's comment, the level comes back
/// unavailable with reason `writing`. It is asked again every
/// [kCommentWritingPoll] until it lands. The timer belongs to the read, so
/// leaving the page stops it.

@ProviderFor(CommentLevelController)
final commentLevelControllerProvider = CommentLevelControllerProvider._();

/// `GET /contest/tasks/comment`, behind the path's gate.
///
/// ## The gate comes first, and it is not a formality
///
/// This GET WRITES. The day's first read builds the level — the server picks
/// the post and spends a model call on the comment — and the server does not
/// check the gate here; only the answer does. A level read while the path
/// still shows it locked would spend the call and write the day's row for a
/// level the learner cannot play yet. The web waits on the path for the same
/// reason (`useTodayLock`); this waits too, and never asks while locked.
///
/// A path that FAILED is not a gate: the level is read, and the answer's 409
/// LOCKED still holds.
///
/// ## Writing
///
/// While another request is writing today's comment, the level comes back
/// unavailable with reason `writing`. It is asked again every
/// [kCommentWritingPoll] until it lands. The timer belongs to the read, so
/// leaving the page stops it.
final class CommentLevelControllerProvider
    extends $AsyncNotifierProvider<CommentLevelController, CommentLevelState> {
  /// `GET /contest/tasks/comment`, behind the path's gate.
  ///
  /// ## The gate comes first, and it is not a formality
  ///
  /// This GET WRITES. The day's first read builds the level — the server picks
  /// the post and spends a model call on the comment — and the server does not
  /// check the gate here; only the answer does. A level read while the path
  /// still shows it locked would spend the call and write the day's row for a
  /// level the learner cannot play yet. The web waits on the path for the same
  /// reason (`useTodayLock`); this waits too, and never asks while locked.
  ///
  /// A path that FAILED is not a gate: the level is read, and the answer's 409
  /// LOCKED still holds.
  ///
  /// ## Writing
  ///
  /// While another request is writing today's comment, the level comes back
  /// unavailable with reason `writing`. It is asked again every
  /// [kCommentWritingPoll] until it lands. The timer belongs to the read, so
  /// leaving the page stops it.
  CommentLevelControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentLevelControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentLevelControllerHash();

  @$internal
  @override
  CommentLevelController create() => CommentLevelController();
}

String _$commentLevelControllerHash() =>
    r'2e87d7e308dc6e5fde327f13c7cdcd9cdc8c0183';

/// `GET /contest/tasks/comment`, behind the path's gate.
///
/// ## The gate comes first, and it is not a formality
///
/// This GET WRITES. The day's first read builds the level — the server picks
/// the post and spends a model call on the comment — and the server does not
/// check the gate here; only the answer does. A level read while the path
/// still shows it locked would spend the call and write the day's row for a
/// level the learner cannot play yet. The web waits on the path for the same
/// reason (`useTodayLock`); this waits too, and never asks while locked.
///
/// A path that FAILED is not a gate: the level is read, and the answer's 409
/// LOCKED still holds.
///
/// ## Writing
///
/// While another request is writing today's comment, the level comes back
/// unavailable with reason `writing`. It is asked again every
/// [kCommentWritingPoll] until it lands. The timer belongs to the read, so
/// leaving the page stops it.

abstract class _$CommentLevelController
    extends $AsyncNotifier<CommentLevelState> {
  FutureOr<CommentLevelState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CommentLevelState>, CommentLevelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommentLevelState>, CommentLevelState>,
              AsyncValue<CommentLevelState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The comment player: tap a bank word into the next empty blank, tap a
/// filled blank to send its word back, check the whole sequence, and after a
/// miss try again with the right picks kept.
///
/// Only the day's FIRST submission can pay, and the server decides that. A
/// miss shows every right word (the answer always carries them) and the
/// learner may submit again until it is right — the comment is theirs to
/// post either way.

@ProviderFor(CommentLevelActions)
final commentLevelActionsProvider = CommentLevelActionsProvider._();

/// The comment player: tap a bank word into the next empty blank, tap a
/// filled blank to send its word back, check the whole sequence, and after a
/// miss try again with the right picks kept.
///
/// Only the day's FIRST submission can pay, and the server decides that. A
/// miss shows every right word (the answer always carries them) and the
/// learner may submit again until it is right — the comment is theirs to
/// post either way.
final class CommentLevelActionsProvider
    extends $NotifierProvider<CommentLevelActions, CommentPlay> {
  /// The comment player: tap a bank word into the next empty blank, tap a
  /// filled blank to send its word back, check the whole sequence, and after a
  /// miss try again with the right picks kept.
  ///
  /// Only the day's FIRST submission can pay, and the server decides that. A
  /// miss shows every right word (the answer always carries them) and the
  /// learner may submit again until it is right — the comment is theirs to
  /// post either way.
  CommentLevelActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentLevelActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentLevelActionsHash();

  @$internal
  @override
  CommentLevelActions create() => CommentLevelActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentPlay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentPlay>(value),
    );
  }
}

String _$commentLevelActionsHash() =>
    r'30cc6267ad9b18369408861151eeccdd9239f869';

/// The comment player: tap a bank word into the next empty blank, tap a
/// filled blank to send its word back, check the whole sequence, and after a
/// miss try again with the right picks kept.
///
/// Only the day's FIRST submission can pay, and the server decides that. A
/// miss shows every right word (the answer always carries them) and the
/// learner may submit again until it is right — the comment is theirs to
/// post either way.

abstract class _$CommentLevelActions extends $Notifier<CommentPlay> {
  CommentPlay build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CommentPlay, CommentPlay>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommentPlay, CommentPlay>,
              CommentPlay,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
