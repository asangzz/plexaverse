import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/unlock_controller.dart';

/// The biometric / device-credential unlock gate (root navigator), shown over
/// everything when a signed-in session is locked — on resume from background or
/// relaunch after the app was killed.
///
/// Auto-prompts on open. On success it clears the lock and the router returns
/// the user to where they were. "Log out instead" signs out to /login as the
/// fallback when biometrics changed, the device is locked out, or the user
/// simply prefers to re-enter their password.
///
/// Built from the Zave kit, like everything else behind it.
///
/// It was not, for longer than anything else: a bare [Scaffold] on flat
/// midnight with none of [ZaveGroundBox]'s wash, Material's `FilledButton`
/// and `TextButton`, and a 72pt disc filled with `scheme.primaryContainer` —
/// a key [ZaveTheme] never sets, so it fell through to Material's baseline
/// indigo, a colour that appears nowhere else in this app. The gate is shown
/// over everything on resume from background and on relaunch, which makes it
/// one of the most-seen screens in the product and the worst one to leave
/// looking borrowed.
///
/// **Both operations live on [UnlockController], not here.** `_inProgress`,
/// `_loggingOut` and `_message` were fields on this State, read after an
/// `if (!mounted) return;` — which lost a failure the user never got to see
/// and, worse, could drop a SUCCESSFUL unlock, since clearing the lock sat on
/// the far side of the same guard. What is left on the page is the copy for
/// each outcome, which is the layer that owns user-facing text.
class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key});

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  @override
  void initState() {
    super.initState();
    // Auto-prompt from the first frame. The controller's own guard is what
    // keeps a rebuild from stacking a second prompt on the first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(unlockControllerProvider.notifier).authenticate();
    });
  }

  /// The sentence for each outcome.
  ///
  /// Null is "nothing to report" — a fresh gate, or a success on its way to a
  /// redirect — and renders the standing prompt instead.
  static String? _messageFor(BiometricOutcome? outcome) => switch (outcome) {
    null || BiometricOutcome.success => null,
    BiometricOutcome.lockedOut =>
      'Too many attempts. Try again later or log out to sign in with '
          'your password.',
    BiometricOutcome.unavailable ||
    BiometricOutcome.failed ||
    BiometricOutcome.canceled => 'Unlock failed. Try again or log out instead.',
  };

  @override
  Widget build(BuildContext context) {
    final UnlockState unlock = ref.watch(unlockControllerProvider);
    final String? message = _messageFor(unlock.lastFailure);

    return ZaveScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ZaveSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // The `now` step — the kit's "this is the one" surface, the
              // same tone ZaveRowCircle uses for the day you are on.
              Container(
                width: 72.r,
                height: 72.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ZaveGlass.now,
                  border: Border.fromBorderSide(
                    BorderSide(color: ZaveGlass.nowBorder),
                  ),
                ),
                child: Icon(
                  AppIcons.fingerprint,
                  size: 30.r,
                  color: ZaveColors.white,
                ),
              ),
              SizedBox(height: ZaveSpace.xl),
              Text('Locked', textAlign: TextAlign.center, style: ZaveType.h2),
              SizedBox(height: ZaveSpace.sm),
              Text(
                message ?? 'Confirm it\'s you to get back into Plexaverse.',
                textAlign: TextAlign.center,
                // Amber, not `scheme.error`: Zave has no red, and a failed
                // unlock is "try again", not "something is broken".
                style: message != null
                    ? ZaveType.body.copyWith(color: ZaveColors.amber)
                    : ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.xxl),
              ZaveButton.primary(
                label: 'Unlock',
                expand: true,
                icon: const Icon(AppIcons.lock),
                busy: unlock.authenticating,
                onPressed: unlock.busy
                    ? null
                    : () => ref
                          .read(unlockControllerProvider.notifier)
                          .authenticate(),
              ),
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: 'Log out instead',
                expand: true,
                busy: unlock.signingOut,
                onPressed: unlock.signingOut
                    ? null
                    : () =>
                          ref.read(unlockControllerProvider.notifier).signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
