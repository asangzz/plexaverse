// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The company banner screen.
///
/// **This screen departs from the web deliberately.** The web renders the
/// banner to a PNG, downloads it, and then walks the user through uploading it
/// by hand — because a browser page has no way to write a company page's cover
/// image. The mobile API does: `POST /linkedin/company-banner` performs the
/// register-upload / PUT / partial-update dance server-side. So this screen
/// APPLIES the banner instead of asking the user to go and do it, and keeps
/// the web's manual instructions only as the fallback for when it cannot.

@ProviderFor(BannerController)
final bannerControllerProvider = BannerControllerProvider._();

/// The company banner screen.
///
/// **This screen departs from the web deliberately.** The web renders the
/// banner to a PNG, downloads it, and then walks the user through uploading it
/// by hand — because a browser page has no way to write a company page's cover
/// image. The mobile API does: `POST /linkedin/company-banner` performs the
/// register-upload / PUT / partial-update dance server-side. So this screen
/// APPLIES the banner instead of asking the user to go and do it, and keeps
/// the web's manual instructions only as the fallback for when it cannot.
final class BannerControllerProvider
    extends $AsyncNotifierProvider<BannerController, BannerState> {
  /// The company banner screen.
  ///
  /// **This screen departs from the web deliberately.** The web renders the
  /// banner to a PNG, downloads it, and then walks the user through uploading it
  /// by hand — because a browser page has no way to write a company page's cover
  /// image. The mobile API does: `POST /linkedin/company-banner` performs the
  /// register-upload / PUT / partial-update dance server-side. So this screen
  /// APPLIES the banner instead of asking the user to go and do it, and keeps
  /// the web's manual instructions only as the fallback for when it cannot.
  BannerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannerControllerHash();

  @$internal
  @override
  BannerController create() => BannerController();
}

String _$bannerControllerHash() => r'f9237edbd169217070377b5bc73d46fb1784126f';

/// The company banner screen.
///
/// **This screen departs from the web deliberately.** The web renders the
/// banner to a PNG, downloads it, and then walks the user through uploading it
/// by hand — because a browser page has no way to write a company page's cover
/// image. The mobile API does: `POST /linkedin/company-banner` performs the
/// register-upload / PUT / partial-update dance server-side. So this screen
/// APPLIES the banner instead of asking the user to go and do it, and keeps
/// the web's manual instructions only as the fallback for when it cannot.

abstract class _$BannerController extends $AsyncNotifier<BannerState> {
  FutureOr<BannerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BannerState>, BannerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BannerState>, BannerState>,
              AsyncValue<BannerState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
