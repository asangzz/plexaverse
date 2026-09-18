import 'package:flutter/widgets.dart';

import '../../../../core/ui/zave/zave_kit.dart';

enum SocialButtonProvider { google, linkedIn }

/// A social sign-in button — "Continue with Google" / "Continue with LinkedIn".
///
/// Built from [ZaveButton] in its `ghost` role: these are NOT the primary
/// action on the screen (the email CTA is), and Zave allows exactly one solid
/// white button per screen.
///
/// **The brand marks are deliberately monochrome.** The pre-alignment button
/// painted Google's four-colour "G" and LinkedIn's `#0077B5` tile. Zave's first
/// rule is that colour only ever names a status, and a vendor logo is the one
/// thing on the screen that names nothing — so the glyphs are drawn in the
/// button's own foreground instead. If the official marks are required for
/// vendor-branding compliance they have to ship as image assets, which is a
/// change outside this feature (see the summary).
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
      icon: _ProviderGlyph(provider: provider),
    );
  }
}

/// The 20-logical-pixel letterform that stands in for the vendor logo.
///
/// Manrope is the naming face in Zave ([ZaveType.button]), which is exactly
/// what a wordmark is, so the glyphs use it at the icon size the button's own
/// [IconTheme] would have given a real icon.
class _ProviderGlyph extends StatelessWidget {
  const _ProviderGlyph({required this.provider});

  final SocialButtonProvider provider;

  @override
  Widget build(BuildContext context) {
    final String glyph = switch (provider) {
      SocialButtonProvider.google => 'G',
      SocialButtonProvider.linkedIn => 'in',
    };

    return SizedBox(
      width: ZaveSpace.xl,
      child: Text(
        glyph,
        textAlign: TextAlign.center,
        style: ZaveType.button.copyWith(color: ZaveColors.white),
      ),
    );
  }
}
