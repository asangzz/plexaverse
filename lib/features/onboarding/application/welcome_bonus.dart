import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/onboarding_repositories.dart';

/// Whether to celebrate the welcome bonus — the web's `freshRegistration`.
///
/// Re-read after the LinkedIn connect and after a company page is saved, the
/// two moments the server credits the bonus.
final FutureProvider<bool> welcomeBonusProvider =
    FutureProvider.autoDispose<bool>(
      (Ref ref) =>
          ref.watch(onboardingRepositoryProvider).hasFreshWelcomeBonus(),
    );
