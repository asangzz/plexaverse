// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headshots_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The `/headshots` wizard.
///
/// The whole flow is one value ([HeadshotSession]) rather than the web's ten
/// `useState` calls, so the screen cannot render a combination the flow cannot
/// be in — `step: generate` with nothing generating, for instance, which the
/// web can reach when a request fails between the two setters.

@ProviderFor(HeadshotsController)
final headshotsControllerProvider = HeadshotsControllerProvider._();

/// The `/headshots` wizard.
///
/// The whole flow is one value ([HeadshotSession]) rather than the web's ten
/// `useState` calls, so the screen cannot render a combination the flow cannot
/// be in — `step: generate` with nothing generating, for instance, which the
/// web can reach when a request fails between the two setters.
final class HeadshotsControllerProvider
    extends $NotifierProvider<HeadshotsController, HeadshotSession> {
  /// The `/headshots` wizard.
  ///
  /// The whole flow is one value ([HeadshotSession]) rather than the web's ten
  /// `useState` calls, so the screen cannot render a combination the flow cannot
  /// be in — `step: generate` with nothing generating, for instance, which the
  /// web can reach when a request fails between the two setters.
  HeadshotsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headshotsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headshotsControllerHash();

  @$internal
  @override
  HeadshotsController create() => HeadshotsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadshotSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadshotSession>(value),
    );
  }
}

String _$headshotsControllerHash() =>
    r'14b0a192cb02eb48b239efb03e2cc335804fff68';

/// The `/headshots` wizard.
///
/// The whole flow is one value ([HeadshotSession]) rather than the web's ten
/// `useState` calls, so the screen cannot render a combination the flow cannot
/// be in — `step: generate` with nothing generating, for instance, which the
/// web can reach when a request fails between the two setters.

abstract class _$HeadshotsController extends $Notifier<HeadshotSession> {
  HeadshotSession build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HeadshotSession, HeadshotSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HeadshotSession, HeadshotSession>,
              HeadshotSession,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
