import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/app_icons.dart';
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
/// Migrated to ProHealth's unlock-gate structure (RULINGS ruling 12), rendered
/// with Plexaverse product conventions: theme-driven colours (no expressive_m3),
/// [ScreenUtil] responsive scaling, and the shared [AppIcons] indirection.
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final UnlockState unlock = ref.watch(unlockControllerProvider);
    final String? message = _messageFor(unlock.lastFailure);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 72.r,
                  height: 72.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primaryContainer,
                  ),
                  child: Icon(
                    AppIcons.fingerprint,
                    size: 30.r,
                    color: scheme.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  'Locked',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  message ?? 'Confirm it\'s you to get back into Plexaverse.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: message != null ? scheme.error : null,
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: unlock.busy
                        ? null
                        : () => ref
                              .read(unlockControllerProvider.notifier)
                              .authenticate(),
                    icon: unlock.authenticating
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Icon(AppIcons.lock),
                    label: const Text('Unlock'),
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                TextButton(
                  onPressed: unlock.signingOut
                      ? null
                      : () => ref
                            .read(unlockControllerProvider.notifier)
                            .signOut(),
                  child: const Text('Log out instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
