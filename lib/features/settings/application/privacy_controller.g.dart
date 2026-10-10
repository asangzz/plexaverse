// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The DPDP rights family: export (s11), erasure (s12), grievance (s13) and
/// nomination (s14).
///
/// All five calls used to run from `_DataPrivacySectionState`, which imported
/// `data/` and read `settingsRepositoryProvider` itself — presentation
/// reaching past application straight into data, which is the one dependency
/// direction ARCHITECTURE.md forbids. The cost was not stylistic: the
/// in-flight flag those calls shared was a widget field, so an IRREVERSIBLE
/// request was gated by state that dies with the screen, and everything after
/// an await — including the sign-out that has to follow an erasure — was
/// conditional on the user not having navigated away. [ConsentController],
/// which lives next door and serves the same section, was already doing this
/// correctly; this is its missing other half.

@ProviderFor(PrivacyController)
final privacyControllerProvider = PrivacyControllerProvider._();

/// The DPDP rights family: export (s11), erasure (s12), grievance (s13) and
/// nomination (s14).
///
/// All five calls used to run from `_DataPrivacySectionState`, which imported
/// `data/` and read `settingsRepositoryProvider` itself — presentation
/// reaching past application straight into data, which is the one dependency
/// direction ARCHITECTURE.md forbids. The cost was not stylistic: the
/// in-flight flag those calls shared was a widget field, so an IRREVERSIBLE
/// request was gated by state that dies with the screen, and everything after
/// an await — including the sign-out that has to follow an erasure — was
/// conditional on the user not having navigated away. [ConsentController],
/// which lives next door and serves the same section, was already doing this
/// correctly; this is its missing other half.
final class PrivacyControllerProvider
    extends $NotifierProvider<PrivacyController, bool> {
  /// The DPDP rights family: export (s11), erasure (s12), grievance (s13) and
  /// nomination (s14).
  ///
  /// All five calls used to run from `_DataPrivacySectionState`, which imported
  /// `data/` and read `settingsRepositoryProvider` itself — presentation
  /// reaching past application straight into data, which is the one dependency
  /// direction ARCHITECTURE.md forbids. The cost was not stylistic: the
  /// in-flight flag those calls shared was a widget field, so an IRREVERSIBLE
  /// request was gated by state that dies with the screen, and everything after
  /// an await — including the sign-out that has to follow an erasure — was
  /// conditional on the user not having navigated away. [ConsentController],
  /// which lives next door and serves the same section, was already doing this
  /// correctly; this is its missing other half.
  PrivacyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyControllerHash();

  @$internal
  @override
  PrivacyController create() => PrivacyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$privacyControllerHash() => r'1aa8b351ae530c3503ea6c31a3becf87f7195c59';

/// The DPDP rights family: export (s11), erasure (s12), grievance (s13) and
/// nomination (s14).
///
/// All five calls used to run from `_DataPrivacySectionState`, which imported
/// `data/` and read `settingsRepositoryProvider` itself — presentation
/// reaching past application straight into data, which is the one dependency
/// direction ARCHITECTURE.md forbids. The cost was not stylistic: the
/// in-flight flag those calls shared was a widget field, so an IRREVERSIBLE
/// request was gated by state that dies with the screen, and everything after
/// an await — including the sign-out that has to follow an erasure — was
/// conditional on the user not having navigated away. [ConsentController],
/// which lives next door and serves the same section, was already doing this
/// correctly; this is its missing other half.

abstract class _$PrivacyController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
