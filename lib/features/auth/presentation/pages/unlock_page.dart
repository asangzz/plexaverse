import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/app_icons.dart';
import '../../application/app_lock_controller.dart';
import '../../application/sign_out_controller.dart';

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
class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key});

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  bool _inProgress = false;
  bool _loggingOut = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_inProgress || _loggingOut) return;
    setState(() {
      _inProgress = true;
      _message = null;
    });
    final outcome = await ref
        .read(biometricAuthServiceProvider)
        .authenticate(reason: 'Unlock Plexaverse to continue.');
    if (!mounted) return;
    switch (outcome) {
      case BiometricOutcome.success:
        // Clearing the lock lets the router redirect back into the app.
        ref.read(appLockProvider.notifier).unlock();
      case BiometricOutcome.lockedOut:
        setState(() {
          _inProgress = false;
          _message =
              'Too many attempts. Try again later or log out to sign in with '
              'your password.';
        });
      case BiometricOutcome.unavailable:
      case BiometricOutcome.failed:
      case BiometricOutcome.canceled:
        setState(() {
          _inProgress = false;
          _message = 'Unlock failed. Try again or log out instead.';
        });
    }
  }

  Future<void> _logOut() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    // Signs out; the router redirects to /login once the gate re-resolves.
    await ref.read(signOutControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                  _message ??
                      'Confirm it\'s you to get back into Plexaverse.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _message != null ? scheme.error : null,
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        _inProgress || _loggingOut ? null : _authenticate,
                    icon: _inProgress
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
                  onPressed: _loggingOut ? null : _logOut,
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
