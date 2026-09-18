import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repositories.dart';
import '../domain/settings_profile.dart';

part 'settings_profile_controller.g.dart';

/// Loads the profile header shown at the top of the Settings screen.
///
/// `AsyncValue` drives the three states: loading → a compact placeholder,
/// error → a small inline retry (the theme/locale controls below stay usable
/// since they are local-only), data → the avatar + name + handle header.
/// Retry re-runs it via `ref.invalidate` / `.future`. Auto-retry is globally
/// disabled — recovery is explicit.
@riverpod
class SettingsProfileController extends _$SettingsProfileController {
  @override
  Future<SettingsProfile> build() {
    return ref.watch(settingsRepositoryProvider).fetchProfile();
  }
}
