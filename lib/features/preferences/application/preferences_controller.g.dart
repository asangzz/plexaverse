// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The preferences row — the app's ONE reader of the keystone state.
///
/// It used to live in `features/settings`, which is where it was first needed.
/// By then home had grown its own `homeUserPreferences` provider and compose
/// was fetching `/user/preferences` inline inside its own repository. Three
/// readers of the state that decides the navigation, which home screen renders
/// and which composer you get is three chances for them to disagree about what
/// brand the user runs — so they are one now, and it lives in the slice that
/// owns the model rather than in the first screen that happened to want it.
///
/// Writes are **partial**: every mutator sends only the keys it changed. The
/// server's schema is `.strict()`, so an unknown key rejects the entire
/// payload with a 400 rather than being dropped, and it strips undefined keys
/// so a small write can never null out an unrelated column.

@ProviderFor(PreferencesController)
final preferencesControllerProvider = PreferencesControllerProvider._();

/// The preferences row — the app's ONE reader of the keystone state.
///
/// It used to live in `features/settings`, which is where it was first needed.
/// By then home had grown its own `homeUserPreferences` provider and compose
/// was fetching `/user/preferences` inline inside its own repository. Three
/// readers of the state that decides the navigation, which home screen renders
/// and which composer you get is three chances for them to disagree about what
/// brand the user runs — so they are one now, and it lives in the slice that
/// owns the model rather than in the first screen that happened to want it.
///
/// Writes are **partial**: every mutator sends only the keys it changed. The
/// server's schema is `.strict()`, so an unknown key rejects the entire
/// payload with a 400 rather than being dropped, and it strips undefined keys
/// so a small write can never null out an unrelated column.
final class PreferencesControllerProvider
    extends $AsyncNotifierProvider<PreferencesController, UserPreferences> {
  /// The preferences row — the app's ONE reader of the keystone state.
  ///
  /// It used to live in `features/settings`, which is where it was first needed.
  /// By then home had grown its own `homeUserPreferences` provider and compose
  /// was fetching `/user/preferences` inline inside its own repository. Three
  /// readers of the state that decides the navigation, which home screen renders
  /// and which composer you get is three chances for them to disagree about what
  /// brand the user runs — so they are one now, and it lives in the slice that
  /// owns the model rather than in the first screen that happened to want it.
  ///
  /// Writes are **partial**: every mutator sends only the keys it changed. The
  /// server's schema is `.strict()`, so an unknown key rejects the entire
  /// payload with a 400 rather than being dropped, and it strips undefined keys
  /// so a small write can never null out an unrelated column.
  PreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesControllerHash();

  @$internal
  @override
  PreferencesController create() => PreferencesController();
}

String _$preferencesControllerHash() =>
    r'08b1e7c36273b1c003ddbe587dbb8515813925ee';

/// The preferences row — the app's ONE reader of the keystone state.
///
/// It used to live in `features/settings`, which is where it was first needed.
/// By then home had grown its own `homeUserPreferences` provider and compose
/// was fetching `/user/preferences` inline inside its own repository. Three
/// readers of the state that decides the navigation, which home screen renders
/// and which composer you get is three chances for them to disagree about what
/// brand the user runs — so they are one now, and it lives in the slice that
/// owns the model rather than in the first screen that happened to want it.
///
/// Writes are **partial**: every mutator sends only the keys it changed. The
/// server's schema is `.strict()`, so an unknown key rejects the entire
/// payload with a 400 rather than being dropped, and it strips undefined keys
/// so a small write can never null out an unrelated column.

abstract class _$PreferencesController extends $AsyncNotifier<UserPreferences> {
  FutureOr<UserPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserPreferences>, UserPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserPreferences>, UserPreferences>,
              AsyncValue<UserPreferences>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
