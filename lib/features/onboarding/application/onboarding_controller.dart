import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';

part 'onboarding_controller.g.dart';

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
@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConfig.onboardingKey) ?? false;
  }

  /// Mark onboarding as completed and persist the flag.
  ///
  /// Sets the state optimistically to `true` first so the router's onboarding
  /// gate releases immediately (the carousel's "Get Started" tap flows straight
  /// through to `/login`), then writes the persisted flag so the next cold
  /// start skips the carousel.
  Future<void> complete() async {
    state = const AsyncData<bool>(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.onboardingKey, true);
  }
}
