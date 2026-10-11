// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missions_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The preferences row the three mission pages read and write, plus the
/// LinkedIn slug they build hand-off URLs from.
///
/// One provider shared by all three missions rather than one each: they edit
/// DIFFERENT COLUMNS OF THE SAME ROW (headline, summary + skills, position),
/// and a user who fixes their headline on one screen should see it on the next
/// without a refetch.

@ProviderFor(MissionProfileController)
final missionProfileControllerProvider = MissionProfileControllerProvider._();

/// The preferences row the three mission pages read and write, plus the
/// LinkedIn slug they build hand-off URLs from.
///
/// One provider shared by all three missions rather than one each: they edit
/// DIFFERENT COLUMNS OF THE SAME ROW (headline, summary + skills, position),
/// and a user who fixes their headline on one screen should see it on the next
/// without a refetch.
final class MissionProfileControllerProvider
    extends $AsyncNotifierProvider<MissionProfileController, MissionProfile> {
  /// The preferences row the three mission pages read and write, plus the
  /// LinkedIn slug they build hand-off URLs from.
  ///
  /// One provider shared by all three missions rather than one each: they edit
  /// DIFFERENT COLUMNS OF THE SAME ROW (headline, summary + skills, position),
  /// and a user who fixes their headline on one screen should see it on the next
  /// without a refetch.
  MissionProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missionProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missionProfileControllerHash();

  @$internal
  @override
  MissionProfileController create() => MissionProfileController();
}

String _$missionProfileControllerHash() =>
    r'aef719edeba00fbcef5221700e928fa728f95dd4';

/// The preferences row the three mission pages read and write, plus the
/// LinkedIn slug they build hand-off URLs from.
///
/// One provider shared by all three missions rather than one each: they edit
/// DIFFERENT COLUMNS OF THE SAME ROW (headline, summary + skills, position),
/// and a user who fixes their headline on one screen should see it on the next
/// without a refetch.

abstract class _$MissionProfileController
    extends $AsyncNotifier<MissionProfile> {
  FutureOr<MissionProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MissionProfile>, MissionProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MissionProfile>, MissionProfile>,
              AsyncValue<MissionProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The banner template carousel.
///
/// Its own provider: the Studio template list is the slowest read on any of
/// these screens, and it must not delay the position field the user is
/// already typing into.

@ProviderFor(bannerTemplates)
final bannerTemplatesProvider = BannerTemplatesProvider._();

/// The banner template carousel.
///
/// Its own provider: the Studio template list is the slowest read on any of
/// these screens, and it must not delay the position field the user is
/// already typing into.

final class BannerTemplatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BannerTemplate>>,
          List<BannerTemplate>,
          FutureOr<List<BannerTemplate>>
        >
    with
        $FutureModifier<List<BannerTemplate>>,
        $FutureProvider<List<BannerTemplate>> {
  /// The banner template carousel.
  ///
  /// Its own provider: the Studio template list is the slowest read on any of
  /// these screens, and it must not delay the position field the user is
  /// already typing into.
  BannerTemplatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannerTemplatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannerTemplatesHash();

  @$internal
  @override
  $FutureProviderElement<List<BannerTemplate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BannerTemplate>> create(Ref ref) {
    return bannerTemplates(ref);
  }
}

String _$bannerTemplatesHash() => r'32975a3b215a7cb4a7624dace6564655f07dda4d';

/// The Season 1 recap numbers.

@ProviderFor(seasonRecap)
final seasonRecapProvider = SeasonRecapProvider._();

/// The Season 1 recap numbers.

final class SeasonRecapProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeasonRecap>,
          SeasonRecap,
          FutureOr<SeasonRecap>
        >
    with $FutureModifier<SeasonRecap>, $FutureProvider<SeasonRecap> {
  /// The Season 1 recap numbers.
  SeasonRecapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonRecapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonRecapHash();

  @$internal
  @override
  $FutureProviderElement<SeasonRecap> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeasonRecap> create(Ref ref) {
    return seasonRecap(ref);
  }
}

String _$seasonRecapHash() => r'9a66024bd2340ee99bf3cd6fa8325bb0cd11f11c';

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

@ProviderFor(HeadlineHookController)
final headlineHookControllerProvider = HeadlineHookControllerProvider._();

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
final class HeadlineHookControllerProvider
    extends $NotifierProvider<HeadlineHookController, HeadlineHookState> {
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
  HeadlineHookControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headlineHookControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headlineHookControllerHash();

  @$internal
  @override
  HeadlineHookController create() => HeadlineHookController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadlineHookState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadlineHookState>(value),
    );
  }
}

String _$headlineHookControllerHash() =>
    r'89870950ebb4c7afcfae5259ac32a8efd74aadc3';

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

abstract class _$HeadlineHookController extends $Notifier<HeadlineHookState> {
  HeadlineHookState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HeadlineHookState, HeadlineHookState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HeadlineHookState, HeadlineHookState>,
              HeadlineHookState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One run of the About Odyssey: draft, curate the skill stack, finish.
///
/// The skill list is here and not on the page because it is the payload:
/// [finish] posts it, and "no duplicates, at most ten" are decisions about
/// what gets sent. The summary stays in the page's `TextEditingController` —
/// that is the one piece of form state the rule names as the widget's.

@ProviderFor(AboutOdysseyController)
final aboutOdysseyControllerProvider = AboutOdysseyControllerProvider._();

/// One run of the About Odyssey: draft, curate the skill stack, finish.
///
/// The skill list is here and not on the page because it is the payload:
/// [finish] posts it, and "no duplicates, at most ten" are decisions about
/// what gets sent. The summary stays in the page's `TextEditingController` —
/// that is the one piece of form state the rule names as the widget's.
final class AboutOdysseyControllerProvider
    extends $NotifierProvider<AboutOdysseyController, AboutOdysseyState> {
  /// One run of the About Odyssey: draft, curate the skill stack, finish.
  ///
  /// The skill list is here and not on the page because it is the payload:
  /// [finish] posts it, and "no duplicates, at most ten" are decisions about
  /// what gets sent. The summary stays in the page's `TextEditingController` —
  /// that is the one piece of form state the rule names as the widget's.
  AboutOdysseyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutOdysseyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutOdysseyControllerHash();

  @$internal
  @override
  AboutOdysseyController create() => AboutOdysseyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutOdysseyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutOdysseyState>(value),
    );
  }
}

String _$aboutOdysseyControllerHash() =>
    r'4074cf326d28f7836da576e87e8c136efdec874e';

/// One run of the About Odyssey: draft, curate the skill stack, finish.
///
/// The skill list is here and not on the page because it is the payload:
/// [finish] posts it, and "no duplicates, at most ten" are decisions about
/// what gets sent. The summary stays in the page's `TextEditingController` —
/// that is the one piece of form state the rule names as the widget's.

abstract class _$AboutOdysseyController extends $Notifier<AboutOdysseyState> {
  AboutOdysseyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AboutOdysseyState, AboutOdysseyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AboutOdysseyState, AboutOdysseyState>,
              AboutOdysseyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One run of Banner Blueprint: export the chosen banner, record the step.
///
/// Which template the carousel is showing stays on the page — that is a
/// selection inside one local control, and the `GlobalKey` it attaches to the
/// active card is a render-object handle that cannot live anywhere else.
/// Everything the export and the completion DO lives here.

@ProviderFor(BannerBlueprintController)
final bannerBlueprintControllerProvider = BannerBlueprintControllerProvider._();

/// One run of Banner Blueprint: export the chosen banner, record the step.
///
/// Which template the carousel is showing stays on the page — that is a
/// selection inside one local control, and the `GlobalKey` it attaches to the
/// active card is a render-object handle that cannot live anywhere else.
/// Everything the export and the completion DO lives here.
final class BannerBlueprintControllerProvider
    extends $NotifierProvider<BannerBlueprintController, BannerBlueprintState> {
  /// One run of Banner Blueprint: export the chosen banner, record the step.
  ///
  /// Which template the carousel is showing stays on the page — that is a
  /// selection inside one local control, and the `GlobalKey` it attaches to the
  /// active card is a render-object handle that cannot live anywhere else.
  /// Everything the export and the completion DO lives here.
  BannerBlueprintControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannerBlueprintControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannerBlueprintControllerHash();

  @$internal
  @override
  BannerBlueprintController create() => BannerBlueprintController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BannerBlueprintState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BannerBlueprintState>(value),
    );
  }
}

String _$bannerBlueprintControllerHash() =>
    r'bc00c8400290c98a5a3ce6b39d8fdd872f3e86ca';

/// One run of Banner Blueprint: export the chosen banner, record the step.
///
/// Which template the carousel is showing stays on the page — that is a
/// selection inside one local control, and the `GlobalKey` it attaches to the
/// active card is a render-object handle that cannot live anywhere else.
/// Everything the export and the completion DO lives here.

abstract class _$BannerBlueprintController
    extends $Notifier<BannerBlueprintState> {
  BannerBlueprintState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BannerBlueprintState, BannerBlueprintState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BannerBlueprintState, BannerBlueprintState>,
              BannerBlueprintState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
