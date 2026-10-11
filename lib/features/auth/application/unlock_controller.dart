import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/security/biometric_auth_service.dart';
import 'app_lock_controller.dart';
import 'sign_out_controller.dart';

part 'unlock_controller.g.dart';

/// What the unlock gate is doing, and how the last attempt went.
///
/// Two independent flags rather than one phase enum, because the two
/// operations are genuinely concurrent: "Log out instead" stays tappable while
/// the system prompt is up, which is the whole point of offering it there — a
/// user whose biometrics changed is stuck behind a prompt they cannot pass.
/// So a biometric failure landing mid-sign-out must not re-enable the Unlock
/// button, and collapsing these into an `AuthBusy`-style enum is exactly how
/// it would.
class UnlockState {
  const UnlockState({
    this.authenticating = false,
    this.signingOut = false,
    this.lastFailure,
  });

  /// Nothing in flight, nothing to report.
  static const UnlockState idle = UnlockState();

  /// The system prompt is up.
  final bool authenticating;

  /// A sign-out is in flight; the router will redirect when it lands.
  final bool signingOut;

  /// The last attempt's outcome when it was not a success — the thing the page
  /// turns into a sentence. Null means "nothing to report", which is a fresh
  /// gate rather than a failure that went missing.
  ///
  /// [BiometricOutcome] rather than the copy itself: user-facing text is
  /// presentation's, the same split `AuthController` draws.
  final BiometricOutcome? lastFailure;

  /// Either operation is in flight.
  bool get busy => authenticating || signingOut;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnlockState &&
          other.authenticating == authenticating &&
          other.signingOut == signingOut &&
          other.lastFailure == lastFailure;

  @override
  int get hashCode => Object.hash(authenticating, signingOut, lastFailure);
}

/// The biometric unlock gate's two use cases — prompt, and give up and sign
/// out — and the state around them.
///
/// ## Why this is not on the page
///
/// It was: `_inProgress`, `_loggingOut` and `_message` were fields on
/// `_UnlockPageState`, and the switch that read the prompt's outcome ran
/// `if (!mounted) return;` first. Two things followed from that.
///
/// The visible one is the ordinary in-flight-flag complaint ARCHITECTURE.md
/// tabulates: a failure recorded after a `mounted` check is a failure the user
/// never sees.
///
/// The worse one is that `BiometricOutcome.success` was handled on the far
/// side of the same guard — and success is where [AppLock.unlock] is called,
/// which is the ONLY thing that lets the router redirect back into the app. A
/// page rebuilt while the system prompt was up (the prompt itself backgrounds
/// the app, which is why `persistAcrossBackgrounding` is set) therefore
/// dropped a successful unlock on the floor and left a user who had just
/// proved who they were still staring at the gate. That is the same shape as
/// the login defect in the doc's table — tokens written, gate never
/// invalidated — one screen over.
///
/// ## The keep-alive link is load-bearing, for the same reason
///
/// Each use case pins this notifier with `ref.keepAlive()` and releases it in
/// a `finally`, copying `AuthController`. The provider is autoDispose and the
/// page is its only listener, so a rebuild mid-prompt would otherwise tear the
/// notifier down during the await and make the `state =` after it throw —
/// losing the outcome in a new way while fixing the old one. Releasing the
/// link rather than declaring `keepAlive: true` is what lets a fresh gate open
/// idle.
@riverpod
class UnlockController extends _$UnlockController {
  @override
  UnlockState build() => UnlockState.idle;

  /// Shows the system prompt and, on success, clears the lock.
  ///
  /// Re-entrant by one call only: the page auto-prompts from its first frame
  /// AND the Unlock button calls this, so a rebuild must not stack two
  /// prompts. The guard covers a sign-out too — once the user has chosen to
  /// leave, a prompt is no longer worth raising.
  Future<void> authenticate() async {
    if (state.busy) return;

    final link = ref.keepAlive();
    state = const UnlockState(authenticating: true);
    try {
      final BiometricOutcome outcome = await ref
          .read(biometricAuthServiceProvider)
          .authenticate(reason: 'Unlock Plexaverse to continue.');

      switch (outcome) {
        case BiometricOutcome.success:
          // Clearing the lock lets the router redirect back into the app.
          // Nothing resets `authenticating` here: the redirect is already in
          // flight and the button must not come back to life under the user's
          // thumb. The provider disposing with the page is what clears it.
          ref.read(appLockProvider.notifier).unlock();
        case BiometricOutcome.lockedOut:
        case BiometricOutcome.unavailable:
        case BiometricOutcome.failed:
        case BiometricOutcome.canceled:
          // `signingOut` is carried through rather than reset: the user may
          // have tapped "Log out instead" while the prompt was up.
          state = UnlockState(
            signingOut: state.signingOut,
            lastFailure: outcome,
          );
      }
    } finally {
      link.close();
    }
  }

  /// Gives up on the prompt and signs out; the router redirects to `/login`
  /// once the gate re-resolves.
  ///
  /// Deliberately does NOT wait for, or refuse because of, an in-flight
  /// prompt — that is the escape hatch for a user whose biometrics no longer
  /// work. Any failure already on screen is left there.
  Future<void> signOut() async {
    if (state.signingOut) return;

    final link = ref.keepAlive();
    state = UnlockState(
      authenticating: state.authenticating,
      signingOut: true,
      lastFailure: state.lastFailure,
    );
    try {
      await ref.read(signOutControllerProvider.notifier).signOut();
    } finally {
      link.close();
    }
  }
}
