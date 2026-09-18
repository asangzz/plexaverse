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
