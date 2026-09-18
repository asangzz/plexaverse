// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the first-run onboarding carousel has been completed.
///
/// Ported from `lib/core/providers/onboarding_provider.dart`
/// (`OnboardingNotifier extends Notifier<bool?>`) into the feature-first
/// application layer. The old provider used an explicit tri-state
/// `bool?` — `null` = still loading, `false` = not done, `true` = done — and
/// hand-rolled a `Future(_load)` kick in `build`. That tri-state is now
/// expressed idiomatically as an [AsyncNotifier]`<bool>`: the loading state IS
/// the "null" case, `AsyncData(false)` is not-done, `AsyncData(true)` is done.
///
/// The router (`core/router/redirect.dart`) reads this via
/// `ref.read(onboardingControllerProvider)` and pattern-matches on
/// `AsyncData<bool>` — `true` gates the user through to the auth flow, and a
/// value that is still resolving holds the cold-start splash. An error reading
/// the flag is treated by the router as "completed" (fail open — a returning
/// user is never trapped in the carousel), so this controller does not need to
/// suppress read failures itself.
///
/// **keepAlive is mandatory:** the router reads the state on every navigation
/// via `ref.read(onboardingControllerProvider)` and subscribes to it in its
/// `refreshListenable`; autoDispose would tear the notifier down between reads
/// and re-run the SharedPreferences load, flickering the guard back into its
/// resolving state.
///
/// Persistence uses the same [SharedPreferences] key as before
/// ([AppConfig.onboardingKey] == `'onboarding_done'`) so an app already past
/// onboarding stays past it across the migration.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Whether the first-run onboarding carousel has been completed.
///
/// Ported from `lib/core/providers/onboarding_provider.dart`
/// (`OnboardingNotifier extends Notifier<bool?>`) into the feature-first
/// application layer. The old provider used an explicit tri-state
/// `bool?` — `null` = still loading, `false` = not done, `true` = done — and
/// hand-rolled a `Future(_load)` kick in `build`. That tri-state is now
/// expressed idiomatically as an [AsyncNotifier]`<bool>`: the loading state IS
/// the "null" case, `AsyncData(false)` is not-done, `AsyncData(true)` is done.
///
/// The router (`core/router/redirect.dart`) reads this via
/// `ref.read(onboardingControllerProvider)` and pattern-matches on
/// `AsyncData<bool>` — `true` gates the user through to the auth flow, and a
/// value that is still resolving holds the cold-start splash. An error reading
/// the flag is treated by the router as "completed" (fail open — a returning
/// user is never trapped in the carousel), so this controller does not need to
/// suppress read failures itself.
///
/// **keepAlive is mandatory:** the router reads the state on every navigation
/// via `ref.read(onboardingControllerProvider)` and subscribes to it in its
/// `refreshListenable`; autoDispose would tear the notifier down between reads
/// and re-run the SharedPreferences load, flickering the guard back into its
/// resolving state.
///
/// Persistence uses the same [SharedPreferences] key as before
/// ([AppConfig.onboardingKey] == `'onboarding_done'`) so an app already past
/// onboarding stays past it across the migration.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, bool> {
  /// Whether the first-run onboarding carousel has been completed.
  ///
  /// Ported from `lib/core/providers/onboarding_provider.dart`
  /// (`OnboardingNotifier extends Notifier<bool?>`) into the feature-first
  /// application layer. The old provider used an explicit tri-state
  /// `bool?` — `null` = still loading, `false` = not done, `true` = done — and
  /// hand-rolled a `Future(_load)` kick in `build`. That tri-state is now
  /// expressed idiomatically as an [AsyncNotifier]`<bool>`: the loading state IS
  /// the "null" case, `AsyncData(false)` is not-done, `AsyncData(true)` is done.
  ///
  /// The router (`core/router/redirect.dart`) reads this via
  /// `ref.read(onboardingControllerProvider)` and pattern-matches on
  /// `AsyncData<bool>` — `true` gates the user through to the auth flow, and a
  /// value that is still resolving holds the cold-start splash. An error reading
  /// the flag is treated by the router as "completed" (fail open — a returning
  /// user is never trapped in the carousel), so this controller does not need to
  /// suppress read failures itself.
  ///
  /// **keepAlive is mandatory:** the router reads the state on every navigation
  /// via `ref.read(onboardingControllerProvider)` and subscribes to it in its
  /// `refreshListenable`; autoDispose would tear the notifier down between reads
  /// and re-run the SharedPreferences load, flickering the guard back into its
  /// resolving state.
  ///
  /// Persistence uses the same [SharedPreferences] key as before
  /// ([AppConfig.onboardingKey] == `'onboarding_done'`) so an app already past
  /// onboarding stays past it across the migration.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'423a21bc78db68b9c751b014ec9804838ffed39f';

/// Whether the first-run onboarding carousel has been completed.
///
/// Ported from `lib/core/providers/onboarding_provider.dart`
/// (`OnboardingNotifier extends Notifier<bool?>`) into the feature-first
/// application layer. The old provider used an explicit tri-state
/// `bool?` — `null` = still loading, `false` = not done, `true` = done — and
/// hand-rolled a `Future(_load)` kick in `build`. That tri-state is now
/// expressed idiomatically as an [AsyncNotifier]`<bool>`: the loading state IS
/// the "null" case, `AsyncData(false)` is not-done, `AsyncData(true)` is done.
///
/// The router (`core/router/redirect.dart`) reads this via
/// `ref.read(onboardingControllerProvider)` and pattern-matches on
/// `AsyncData<bool>` — `true` gates the user through to the auth flow, and a
/// value that is still resolving holds the cold-start splash. An error reading
/// the flag is treated by the router as "completed" (fail open — a returning
/// user is never trapped in the carousel), so this controller does not need to
/// suppress read failures itself.
///
/// **keepAlive is mandatory:** the router reads the state on every navigation
/// via `ref.read(onboardingControllerProvider)` and subscribes to it in its
/// `refreshListenable`; autoDispose would tear the notifier down between reads
/// and re-run the SharedPreferences load, flickering the guard back into its
/// resolving state.
///
/// Persistence uses the same [SharedPreferences] key as before
/// ([AppConfig.onboardingKey] == `'onboarding_done'`) so an app already past
/// onboarding stays past it across the migration.

abstract class _$OnboardingController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
