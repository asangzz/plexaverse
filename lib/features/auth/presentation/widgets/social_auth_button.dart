import 'package:flutter/widgets.dart';

import '../../../../core/ui/zave/zave_kit.dart';

enum SocialButtonProvider { google, linkedIn }

/// A social sign-in button — "Continue with Google" / "Continue with LinkedIn".
///
/// Built from [ZaveButton] in its `ghost` role: these are NOT the primary
/// action on the screen (the email CTA is), and Zave allows exactly one solid
/// white button per screen.
///
/// **The marks are the real ones now.** This button used to draw the letter
/// "G" and the letters "in" in Manrope, on the reading that Zave's colour rule
/// forbids a vendor logo. That reading held up until you look at the screen: a
/// letterform in the app's own typeface is not a logo, it is a one-character
/// label, and a user scanning for the Google button looks for the Google mark.
/// Google's sign-in branding guidance also requires their actual mark, which
/// makes a substitute a compliance problem rather than a style choice.
///
/// See [ZaveBrandMark] for the bounded exception this creates. The marks are
/// drawn with `onColor`, in the button's own foreground: every one of these
/// brands publishes a monochrome treatment for dark surfaces, and a saturated
/// brand blue on a dark ghost button fights the label beside it.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
    this.isSignIn = true,
    super.key,
  });

  final SocialButtonProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Sign-in vs create-account wording. Unchanged behaviour.
  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    final String label = switch (provider) {
      SocialButtonProvider.google =>
        isSignIn ? 'Continue with Google' : 'Sign up with Google',
      SocialButtonProvider.linkedIn =>
        isSignIn ? 'Continue with LinkedIn' : 'Sign up with LinkedIn',
    };

    return ZaveButton(
      label: label,
      onPressed: onPressed,
      busy: isLoading,
      expand: true,
      icon: ZaveBrandMark(switch (provider) {
        SocialButtonProvider.google => ZaveBrand.google,
        SocialButtonProvider.linkedIn => ZaveBrand.linkedIn,
      }, onColor: true),
    );
  }
}
