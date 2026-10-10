// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'festive_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which festive category chip is selected. `null` is "All templates".
///
/// Same reasoning as Reimagine's: the list is fetched once and filtered in
/// memory, so a chip tap costs nothing.

@ProviderFor(FestiveCategory)
final festiveCategoryProvider = FestiveCategoryProvider._();

/// Which festive category chip is selected. `null` is "All templates".
///
/// Same reasoning as Reimagine's: the list is fetched once and filtered in
/// memory, so a chip tap costs nothing.
final class FestiveCategoryProvider
    extends $NotifierProvider<FestiveCategory, String?> {
  /// Which festive category chip is selected. `null` is "All templates".
  ///
  /// Same reasoning as Reimagine's: the list is fetched once and filtered in
  /// memory, so a chip tap costs nothing.
  FestiveCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'festiveCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$festiveCategoryHash();

  @$internal
  @override
  FestiveCategory create() => FestiveCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$festiveCategoryHash() => r'dfcf352b2eb0ab6c00a019668dc4a2bed1048844';

/// Which festive category chip is selected. `null` is "All templates".
///
/// Same reasoning as Reimagine's: the list is fetched once and filtered in
/// memory, so a chip tap costs nothing.

abstract class _$FestiveCategory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The festive gallery — `GET /festive/templates`.
///
/// The web's `useFestiveTemplates` also runs a templates → Figma-sync →
/// templates waterfall on an empty result. There is no mobile route for that
/// sync, so an empty gallery stays empty here and the screen says the
/// templates are still being prepared — which is the honest version of the
/// same state.

@ProviderFor(FestiveController)
final festiveControllerProvider = FestiveControllerProvider._();

/// The festive gallery — `GET /festive/templates`.
///
/// The web's `useFestiveTemplates` also runs a templates → Figma-sync →
/// templates waterfall on an empty result. There is no mobile route for that
/// sync, so an empty gallery stays empty here and the screen says the
/// templates are still being prepared — which is the honest version of the
/// same state.
final class FestiveControllerProvider
    extends $AsyncNotifierProvider<FestiveController, FestiveGallery> {
  /// The festive gallery — `GET /festive/templates`.
  ///
  /// The web's `useFestiveTemplates` also runs a templates → Figma-sync →
  /// templates waterfall on an empty result. There is no mobile route for that
  /// sync, so an empty gallery stays empty here and the screen says the
  /// templates are still being prepared — which is the honest version of the
  /// same state.
  FestiveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'festiveControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$festiveControllerHash();

  @$internal
  @override
  FestiveController create() => FestiveController();
}

String _$festiveControllerHash() => r'7f15fefcec97f1f25323193a4101e5475b2bcfc7';

/// The festive gallery — `GET /festive/templates`.
///
/// The web's `useFestiveTemplates` also runs a templates → Figma-sync →
/// templates waterfall on an empty result. There is no mobile route for that
/// sync, so an empty gallery stays empty here and the screen says the
/// templates are still being prepared — which is the honest version of the
/// same state.

abstract class _$FestiveController extends $AsyncNotifier<FestiveGallery> {
  FutureOr<FestiveGallery> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FestiveGallery>, FestiveGallery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FestiveGallery>, FestiveGallery>,
              AsyncValue<FestiveGallery>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// One run of the customizer: pick a logo, generate a poster, then save it
/// somewhere it can be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.

@ProviderFor(FestivePosterController)
final festivePosterControllerProvider = FestivePosterControllerFamily._();

/// One run of the customizer: pick a logo, generate a poster, then save it
/// somewhere it can be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.
final class FestivePosterControllerProvider
    extends $NotifierProvider<FestivePosterController, FestiveCustomizerState> {
  /// One run of the customizer: pick a logo, generate a poster, then save it
  /// somewhere it can be used.
  ///
  /// Scoped per template id so opening a second template does not show the first
  /// one's poster. Without the family, closing and reopening the sheet on a
  /// different tile would surface a stale image that belongs to another design.
  FestivePosterControllerProvider._({
    required FestivePosterControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'festivePosterControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$festivePosterControllerHash();

  @override
  String toString() {
    return r'festivePosterControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FestivePosterController create() => FestivePosterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FestiveCustomizerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FestiveCustomizerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FestivePosterControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$festivePosterControllerHash() =>
    r'd8c206ff0319c9b41216ef93b47d8adc1b44d7f5';

/// One run of the customizer: pick a logo, generate a poster, then save it
/// somewhere it can be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.

final class FestivePosterControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FestivePosterController,
          FestiveCustomizerState,
          FestiveCustomizerState,
          FestiveCustomizerState,
          String
        > {
  FestivePosterControllerFamily._()
    : super(
        retry: null,
        name: r'festivePosterControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One run of the customizer: pick a logo, generate a poster, then save it
  /// somewhere it can be used.
  ///
  /// Scoped per template id so opening a second template does not show the first
  /// one's poster. Without the family, closing and reopening the sheet on a
  /// different tile would surface a stale image that belongs to another design.

  FestivePosterControllerProvider call(String templateId) =>
      FestivePosterControllerProvider._(argument: templateId, from: this);

  @override
  String toString() => r'festivePosterControllerProvider';
}

/// One run of the customizer: pick a logo, generate a poster, then save it
/// somewhere it can be used.
///
/// Scoped per template id so opening a second template does not show the first
/// one's poster. Without the family, closing and reopening the sheet on a
/// different tile would surface a stale image that belongs to another design.

abstract class _$FestivePosterController
    extends $Notifier<FestiveCustomizerState> {
  late final _$args = ref.$arg as String;
  String get templateId => _$args;

  FestiveCustomizerState build(String templateId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<FestiveCustomizerState, FestiveCustomizerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FestiveCustomizerState, FestiveCustomizerState>,
              FestiveCustomizerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
