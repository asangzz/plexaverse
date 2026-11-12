// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `GET /contest` — the contest and the user's entry. Null when there is no
/// contest at all.
///
/// One provider for every surface that shows the XP, the streak or the rank,
/// so two of them can never disagree about the figures.
///
/// The entry carries the learner's band, which the placement test sets. A
/// band move is counted in the placement slice, and watching the count
/// re-reads this wherever it is shown — the web's `invalidateBand`.

@ProviderFor(contestOverview)
final contestOverviewProvider = ContestOverviewProvider._();

/// `GET /contest` — the contest and the user's entry. Null when there is no
/// contest at all.
///
/// One provider for every surface that shows the XP, the streak or the rank,
/// so two of them can never disagree about the figures.
///
/// The entry carries the learner's band, which the placement test sets. A
/// band move is counted in the placement slice, and watching the count
/// re-reads this wherever it is shown — the web's `invalidateBand`.

final class ContestOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ContestOverview?>,
          ContestOverview?,
          FutureOr<ContestOverview?>
        >
    with $FutureModifier<ContestOverview?>, $FutureProvider<ContestOverview?> {
  /// `GET /contest` — the contest and the user's entry. Null when there is no
  /// contest at all.
  ///
  /// One provider for every surface that shows the XP, the streak or the rank,
  /// so two of them can never disagree about the figures.
  ///
  /// The entry carries the learner's band, which the placement test sets. A
  /// band move is counted in the placement slice, and watching the count
  /// re-reads this wherever it is shown — the web's `invalidateBand`.
  ContestOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestOverviewHash();

  @$internal
  @override
  $FutureProviderElement<ContestOverview?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ContestOverview?> create(Ref ref) {
    return contestOverview(ref);
  }
}

String _$contestOverviewHash() => r'e4baddb3f2fe6f92b76329a4ed6ec20be5203b16';

/// `GET /contest/path` — this week's levels and their states.

@ProviderFor(contestPath)
final contestPathProvider = ContestPathProvider._();

/// `GET /contest/path` — this week's levels and their states.

final class ContestPathProvider
    extends
        $FunctionalProvider<
          AsyncValue<ContestPath>,
          ContestPath,
          FutureOr<ContestPath>
        >
    with $FutureModifier<ContestPath>, $FutureProvider<ContestPath> {
  /// `GET /contest/path` — this week's levels and their states.
  ContestPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestPathHash();

  @$internal
  @override
  $FutureProviderElement<ContestPath> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ContestPath> create(Ref ref) {
    return contestPath(ref);
  }
}

String _$contestPathHash() => r'5951332cfb2b4fd583ecc2d09b435166a39338b7';

/// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
/// board for `max(rewardTopN, 3)`.
///
/// Every row shows its band, so a band move re-reads it, as it does the
/// overview.

@ProviderFor(contestBoard)
final contestBoardProvider = ContestBoardFamily._();

/// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
/// board for `max(rewardTopN, 3)`.
///
/// Every row shows its band, so a band move re-reads it, as it does the
/// overview.

final class ContestBoardProvider
    extends
        $FunctionalProvider<
          AsyncValue<BoardResult>,
          BoardResult,
          FutureOr<BoardResult>
        >
    with $FutureModifier<BoardResult>, $FutureProvider<BoardResult> {
  /// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
  /// board for `max(rewardTopN, 3)`.
  ///
  /// Every row shows its band, so a band move re-reads it, as it does the
  /// overview.
  ContestBoardProvider._({
    required ContestBoardFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'contestBoardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contestBoardHash();

  @override
  String toString() {
    return r'contestBoardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BoardResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BoardResult> create(Ref ref) {
    final argument = this.argument as int;
    return contestBoard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContestBoardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contestBoardHash() => r'c9c1cbadf0f969e53f14f31346150530d44f2caf';

/// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
/// board for `max(rewardTopN, 3)`.
///
/// Every row shows its band, so a band move re-reads it, as it does the
/// overview.

final class ContestBoardFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BoardResult>, int> {
  ContestBoardFamily._()
    : super(
        retry: null,
        name: r'contestBoardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// `GET /contest/board?limit=` — the full board asks for 50, the rail's mini
  /// board for `max(rewardTopN, 3)`.
  ///
  /// Every row shows its band, so a band move re-reads it, as it does the
  /// overview.

  ContestBoardProvider call(int limit) =>
      ContestBoardProvider._(argument: limit, from: this);

  @override
  String toString() => r'contestBoardProvider';
}

/// `GET /contest/lesson` — today's lesson as it stands. A pure read: the
/// path's START ring and the daily quests take their counts from it.
///
/// Not the lesson player's state. The player opens the day with a `POST`
/// and holds its own run; re-reading this mid-lesson must not move it.

@ProviderFor(todayQuiz)
final todayQuizProvider = TodayQuizProvider._();

/// `GET /contest/lesson` — today's lesson as it stands. A pure read: the
/// path's START ring and the daily quests take their counts from it.
///
/// Not the lesson player's state. The player opens the day with a `POST`
/// and holds its own run; re-reading this mid-lesson must not move it.

final class TodayQuizProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayQuiz>,
          TodayQuiz,
          FutureOr<TodayQuiz>
        >
    with $FutureModifier<TodayQuiz>, $FutureProvider<TodayQuiz> {
  /// `GET /contest/lesson` — today's lesson as it stands. A pure read: the
  /// path's START ring and the daily quests take their counts from it.
  ///
  /// Not the lesson player's state. The player opens the day with a `POST`
  /// and holds its own run; re-reading this mid-lesson must not move it.
  TodayQuizProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayQuizProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayQuizHash();

  @$internal
  @override
  $FutureProviderElement<TodayQuiz> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodayQuiz> create(Ref ref) {
    return todayQuiz(ref);
  }
}

String _$todayQuizHash() => r'0e7056617430f814b15f7faa1509f86ba9da7663';

/// Today's level of [kind], gated or not.
///
/// The comment level's GET writes the day's row and may spend a model call,
/// and the server does not check the gate there: read this first, and do
/// not make that call while it says locked.

@ProviderFor(todayLock)
final todayLockProvider = TodayLockFamily._();

/// Today's level of [kind], gated or not.
///
/// The comment level's GET writes the day's row and may spend a model call,
/// and the server does not check the gate there: read this first, and do
/// not make that call while it says locked.

final class TodayLockProvider
    extends $FunctionalProvider<TodayLock, TodayLock, TodayLock>
    with $Provider<TodayLock> {
  /// Today's level of [kind], gated or not.
  ///
  /// The comment level's GET writes the day's row and may spend a model call,
  /// and the server does not check the gate there: read this first, and do
  /// not make that call while it says locked.
  TodayLockProvider._({
    required TodayLockFamily super.from,
    required PathNodeKind super.argument,
  }) : super(
         retry: null,
         name: r'todayLockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todayLockHash();

  @override
  String toString() {
    return r'todayLockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TodayLock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodayLock create(Ref ref) {
    final argument = this.argument as PathNodeKind;
    return todayLock(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodayLock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodayLock>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TodayLockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todayLockHash() => r'463906f70ab8c30196a9af5140ad2131fe8c5f9e';

/// Today's level of [kind], gated or not.
///
/// The comment level's GET writes the day's row and may spend a model call,
/// and the server does not check the gate there: read this first, and do
/// not make that call while it says locked.

final class TodayLockFamily extends $Family
    with $FunctionalFamilyOverride<TodayLock, PathNodeKind> {
  TodayLockFamily._()
    : super(
        retry: null,
        name: r'todayLockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Today's level of [kind], gated or not.
  ///
  /// The comment level's GET writes the day's row and may spend a model call,
  /// and the server does not check the gate there: read this first, and do
  /// not make that call while it says locked.

  TodayLockProvider call(PathNodeKind kind) =>
      TodayLockProvider._(argument: kind, from: this);

  @override
  String toString() => r'todayLockProvider';
}

/// Re-reads the standing and the path whenever the app comes back to the
/// foreground — the web's refetch on mount and on focus.
///
/// An approval, a rejection or an audit's revoke reaches the learner by no
/// other road: none of them sends a notification, so the path is the only
/// place they show, and a phone left on the contest overnight would
/// otherwise show yesterday's gate. Today's lesson read is re-read with
/// them, so the path's START ring cannot measure a new day against an old
/// count.
///
/// A contest screen watches it to switch it on; it lives only while one
/// does.

@ProviderFor(contestResumeRefresh)
final contestResumeRefreshProvider = ContestResumeRefreshProvider._();

/// Re-reads the standing and the path whenever the app comes back to the
/// foreground — the web's refetch on mount and on focus.
///
/// An approval, a rejection or an audit's revoke reaches the learner by no
/// other road: none of them sends a notification, so the path is the only
/// place they show, and a phone left on the contest overnight would
/// otherwise show yesterday's gate. Today's lesson read is re-read with
/// them, so the path's START ring cannot measure a new day against an old
/// count.
///
/// A contest screen watches it to switch it on; it lives only while one
/// does.

final class ContestResumeRefreshProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Re-reads the standing and the path whenever the app comes back to the
  /// foreground — the web's refetch on mount and on focus.
  ///
  /// An approval, a rejection or an audit's revoke reaches the learner by no
  /// other road: none of them sends a notification, so the path is the only
  /// place they show, and a phone left on the contest overnight would
  /// otherwise show yesterday's gate. Today's lesson read is re-read with
  /// them, so the path's START ring cannot measure a new day against an old
  /// count.
  ///
  /// A contest screen watches it to switch it on; it lives only while one
  /// does.
  ContestResumeRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestResumeRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestResumeRefreshHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return contestResumeRefresh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$contestResumeRefreshHash() =>
    r'9a4ee4efdf2f835ebe967c891e7450ab37861bae';
