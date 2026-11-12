// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The learner's band, the last result, an open attempt, and whether Start
/// works — `GET /placement`.
///
/// Read by the placement page and by `PlacementLevelHint` on the contest's
/// join card. Not a pure read: an attempt past its closing time is settled on
/// the server by this very request, which can move the band with no write
/// from here to say so — so every read reports its band to
/// [PlacementBandChanges].

@ProviderFor(placementStatus)
final placementStatusProvider = PlacementStatusProvider._();

/// The learner's band, the last result, an open attempt, and whether Start
/// works — `GET /placement`.
///
/// Read by the placement page and by `PlacementLevelHint` on the contest's
/// join card. Not a pure read: an attempt past its closing time is settled on
/// the server by this very request, which can move the band with no write
/// from here to say so — so every read reports its band to
/// [PlacementBandChanges].

final class PlacementStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlacementStatus>,
          PlacementStatus,
          FutureOr<PlacementStatus>
        >
    with $FutureModifier<PlacementStatus>, $FutureProvider<PlacementStatus> {
  /// The learner's band, the last result, an open attempt, and whether Start
  /// works — `GET /placement`.
  ///
  /// Read by the placement page and by `PlacementLevelHint` on the contest's
  /// join card. Not a pure read: an attempt past its closing time is settled on
  /// the server by this very request, which can move the band with no write
  /// from here to say so — so every read reports its band to
  /// [PlacementBandChanges].
  PlacementStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placementStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placementStatusHash();

  @$internal
  @override
  $FutureProviderElement<PlacementStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlacementStatus> create(Ref ref) {
    return placementStatus(ref);
  }
}

String _$placementStatusHash() => r'86e1b07866da46d34e6675daff53ed08d174ed5d';

/// Counts the moments the learner's band may have moved.
///
/// The band is shown outside this slice — the contest overview carries it on
/// the entry, the board beside every row — and each of those reads goes stale
/// the moment it moves. This slice does not import the contest's providers;
/// they watch this count instead, so a bump re-reads them wherever they are
/// (`noticeBandMove` and `invalidateBand` on the web).
///
/// It moves on a write that can set the band (the last answer, writing,
/// finish, a start that replaced the offered attempt) and on a status read
/// that finds a different band from the last one — a test closed on a
/// walk-away sets its band on a READ, and no write is there to say so.

@ProviderFor(PlacementBandChanges)
final placementBandChangesProvider = PlacementBandChangesProvider._();

/// Counts the moments the learner's band may have moved.
///
/// The band is shown outside this slice — the contest overview carries it on
/// the entry, the board beside every row — and each of those reads goes stale
/// the moment it moves. This slice does not import the contest's providers;
/// they watch this count instead, so a bump re-reads them wherever they are
/// (`noticeBandMove` and `invalidateBand` on the web).
///
/// It moves on a write that can set the band (the last answer, writing,
/// finish, a start that replaced the offered attempt) and on a status read
/// that finds a different band from the last one — a test closed on a
/// walk-away sets its band on a READ, and no write is there to say so.
final class PlacementBandChangesProvider
    extends $NotifierProvider<PlacementBandChanges, int> {
  /// Counts the moments the learner's band may have moved.
  ///
  /// The band is shown outside this slice — the contest overview carries it on
  /// the entry, the board beside every row — and each of those reads goes stale
  /// the moment it moves. This slice does not import the contest's providers;
  /// they watch this count instead, so a bump re-reads them wherever they are
  /// (`noticeBandMove` and `invalidateBand` on the web).
  ///
  /// It moves on a write that can set the band (the last answer, writing,
  /// finish, a start that replaced the offered attempt) and on a status read
  /// that finds a different band from the last one — a test closed on a
  /// walk-away sets its band on a READ, and no write is there to say so.
  PlacementBandChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placementBandChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placementBandChangesHash();

  @$internal
  @override
  PlacementBandChanges create() => PlacementBandChanges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$placementBandChangesHash() =>
    r'8ea490d1b54093fd55d14ab7f1a81a50de6e8a0f';

/// Counts the moments the learner's band may have moved.
///
/// The band is shown outside this slice — the contest overview carries it on
/// the entry, the board beside every row — and each of those reads goes stale
/// the moment it moves. This slice does not import the contest's providers;
/// they watch this count instead, so a bump re-reads them wherever they are
/// (`noticeBandMove` and `invalidateBand` on the web).
///
/// It moves on a write that can set the band (the last answer, writing,
/// finish, a start that replaced the offered attempt) and on a status read
/// that finds a different band from the last one — a test closed on a
/// walk-away sets its band on a READ, and no write is there to say so.

abstract class _$PlacementBandChanges extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The placement test: intro → questions → writing → result.
///
/// A port of the web's `PlacementClient.tsx`, whose header is the long
/// version of the rules below.
///
/// ## Nothing here learns whether an answer was right
///
/// An answer resolves to the next step. There is no verdict to hold, so none
/// is held, and the question screen draws nothing that could be read as one.
///
/// ## An open attempt can end under any move
///
/// It closes 24 hours after its last answer or 48 after its start, lazily, on
/// whichever request next reads it. So an answer can come back
/// ALREADY_COMPLETE (closed, or finished on the web) or NOT_FOUND (cleared,
/// nothing answered), Continue can come back COOLDOWN, and Skip NOT_READY.
/// Each of those sends the learner back to the intro — but only once a fresh
/// status has landed: the cached one still says the attempt is open, and an
/// intro drawn from it would offer a Continue the server would refuse. The
/// notice is decided by that read, not by the refusal: a refusal says the
/// attempt moved on, never how.
///
/// GRADING_UNAVAILABLE is not one of those. It is the provider's moment, not
/// the attempt's: nothing was stored, the writing step is still open, and the
/// draft stays in the box for another try.
///
/// Not keepAlive: leaving the page discards the screen, and nothing is lost —
/// every answer is saved before the next question shows, and Start resumes
/// the open attempt on the same question.

@ProviderFor(PlacementFlow)
final placementFlowProvider = PlacementFlowProvider._();

/// The placement test: intro → questions → writing → result.
///
/// A port of the web's `PlacementClient.tsx`, whose header is the long
/// version of the rules below.
///
/// ## Nothing here learns whether an answer was right
///
/// An answer resolves to the next step. There is no verdict to hold, so none
/// is held, and the question screen draws nothing that could be read as one.
///
/// ## An open attempt can end under any move
///
/// It closes 24 hours after its last answer or 48 after its start, lazily, on
/// whichever request next reads it. So an answer can come back
/// ALREADY_COMPLETE (closed, or finished on the web) or NOT_FOUND (cleared,
/// nothing answered), Continue can come back COOLDOWN, and Skip NOT_READY.
/// Each of those sends the learner back to the intro — but only once a fresh
/// status has landed: the cached one still says the attempt is open, and an
/// intro drawn from it would offer a Continue the server would refuse. The
/// notice is decided by that read, not by the refusal: a refusal says the
/// attempt moved on, never how.
///
/// GRADING_UNAVAILABLE is not one of those. It is the provider's moment, not
/// the attempt's: nothing was stored, the writing step is still open, and the
/// draft stays in the box for another try.
///
/// Not keepAlive: leaving the page discards the screen, and nothing is lost —
/// every answer is saved before the next question shows, and Start resumes
/// the open attempt on the same question.
final class PlacementFlowProvider
    extends $NotifierProvider<PlacementFlow, PlacementFlowState> {
  /// The placement test: intro → questions → writing → result.
  ///
  /// A port of the web's `PlacementClient.tsx`, whose header is the long
  /// version of the rules below.
  ///
  /// ## Nothing here learns whether an answer was right
  ///
  /// An answer resolves to the next step. There is no verdict to hold, so none
  /// is held, and the question screen draws nothing that could be read as one.
  ///
  /// ## An open attempt can end under any move
  ///
  /// It closes 24 hours after its last answer or 48 after its start, lazily, on
  /// whichever request next reads it. So an answer can come back
  /// ALREADY_COMPLETE (closed, or finished on the web) or NOT_FOUND (cleared,
  /// nothing answered), Continue can come back COOLDOWN, and Skip NOT_READY.
  /// Each of those sends the learner back to the intro — but only once a fresh
  /// status has landed: the cached one still says the attempt is open, and an
  /// intro drawn from it would offer a Continue the server would refuse. The
  /// notice is decided by that read, not by the refusal: a refusal says the
  /// attempt moved on, never how.
  ///
  /// GRADING_UNAVAILABLE is not one of those. It is the provider's moment, not
  /// the attempt's: nothing was stored, the writing step is still open, and the
  /// draft stays in the box for another try.
  ///
  /// Not keepAlive: leaving the page discards the screen, and nothing is lost —
  /// every answer is saved before the next question shows, and Start resumes
  /// the open attempt on the same question.
  PlacementFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placementFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placementFlowHash();

  @$internal
  @override
  PlacementFlow create() => PlacementFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlacementFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlacementFlowState>(value),
    );
  }
}

String _$placementFlowHash() => r'cc27c6c42a41ce7a7e781a02f1e3b2a5d8466da1';

/// The placement test: intro → questions → writing → result.
///
/// A port of the web's `PlacementClient.tsx`, whose header is the long
/// version of the rules below.
///
/// ## Nothing here learns whether an answer was right
///
/// An answer resolves to the next step. There is no verdict to hold, so none
/// is held, and the question screen draws nothing that could be read as one.
///
/// ## An open attempt can end under any move
///
/// It closes 24 hours after its last answer or 48 after its start, lazily, on
/// whichever request next reads it. So an answer can come back
/// ALREADY_COMPLETE (closed, or finished on the web) or NOT_FOUND (cleared,
/// nothing answered), Continue can come back COOLDOWN, and Skip NOT_READY.
/// Each of those sends the learner back to the intro — but only once a fresh
/// status has landed: the cached one still says the attempt is open, and an
/// intro drawn from it would offer a Continue the server would refuse. The
/// notice is decided by that read, not by the refusal: a refusal says the
/// attempt moved on, never how.
///
/// GRADING_UNAVAILABLE is not one of those. It is the provider's moment, not
/// the attempt's: nothing was stored, the writing step is still open, and the
/// draft stays in the box for another try.
///
/// Not keepAlive: leaving the page discards the screen, and nothing is lost —
/// every answer is saved before the next question shows, and Start resumes
/// the open attempt on the same question.

abstract class _$PlacementFlow extends $Notifier<PlacementFlowState> {
  PlacementFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlacementFlowState, PlacementFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlacementFlowState, PlacementFlowState>,
              PlacementFlowState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
