// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the profile header shown at the top of the Settings screen.
///
/// `AsyncValue` drives the three states: loading → a compact placeholder,
/// error → a small inline retry (the theme/locale controls below stay usable
/// since they are local-only), data → the avatar + name + handle header.
/// Retry re-runs it via `ref.invalidate` / `.future`. Auto-retry is globally
/// disabled — recovery is explicit.

@ProviderFor(SettingsProfileController)
final settingsProfileControllerProvider = SettingsProfileControllerProvider._();

/// Loads the profile header shown at the top of the Settings screen.
///
/// `AsyncValue` drives the three states: loading → a compact placeholder,
/// error → a small inline retry (the theme/locale controls below stay usable
/// since they are local-only), data → the avatar + name + handle header.
/// Retry re-runs it via `ref.invalidate` / `.future`. Auto-retry is globally
/// disabled — recovery is explicit.
final class SettingsProfileControllerProvider
    extends $AsyncNotifierProvider<SettingsProfileController, SettingsProfile> {
  /// Loads the profile header shown at the top of the Settings screen.
  ///
  /// `AsyncValue` drives the three states: loading → a compact placeholder,
  /// error → a small inline retry (the theme/locale controls below stay usable
  /// since they are local-only), data → the avatar + name + handle header.
  /// Retry re-runs it via `ref.invalidate` / `.future`. Auto-retry is globally
  /// disabled — recovery is explicit.
  SettingsProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsProfileControllerHash();

  @$internal
  @override
  SettingsProfileController create() => SettingsProfileController();
}

String _$settingsProfileControllerHash() =>
    r'819e6232556c1bf553c718c2648f6925074cb888';

/// Loads the profile header shown at the top of the Settings screen.
///
/// `AsyncValue` drives the three states: loading → a compact placeholder,
/// error → a small inline retry (the theme/locale controls below stay usable
/// since they are local-only), data → the avatar + name + handle header.
/// Retry re-runs it via `ref.invalidate` / `.future`. Auto-retry is globally
/// disabled — recovery is explicit.

abstract class _$SettingsProfileController
    extends $AsyncNotifier<SettingsProfile> {
  FutureOr<SettingsProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SettingsProfile>, SettingsProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsProfile>, SettingsProfile>,
              AsyncValue<SettingsProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
