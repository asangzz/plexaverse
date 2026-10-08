import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The signed-out entry screen: wordmark, hero, two ways in.
///
/// Ported from the Orbit reference with Plexaverse's name on it. The shape is
/// theirs — centred wordmark over a beta pill, a two-line heading whose second
/// line carries the lavender ramp, the orbit art, a lead, and two full-width
/// buttons with their icons divided off from their labels.
///
/// ## What is deliberately not here
///
/// **The page dots.** The reference shows four, which promises a four-slide
/// carousel. There is one slide's worth of copy in this product and inventing
/// three more would be writing marketing, not building a screen. Dots that do
/// not page are worse than no dots: they say content exists that does not.
///
/// **The email FORM.** The reference's second button is a route, not a field —
/// tapping it hands over to the existing email screen with all its validation
/// and consent intact. Nothing about the auth flow changed here; this is the
/// door in front of it.
class AuthWelcome extends StatelessWidget {
  const AuthWelcome({
    required this.onGoogle,
    required this.onEmail,
    this.googleBusy = false,
    super.key,
  });

  final VoidCallback? onGoogle;
  final VoidCallback onEmail;
  final bool googleBusy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(flex: 2),

        const _Wordmark(),
        SizedBox(height: ZaveSpace.xl),

        // Two lines, the second in the ramp. The break is hard-coded rather
        // than left to the layout: the whole effect is one plain line above
        // one coloured line, and a heading that rewrapped on a narrow phone
        // would put half the colour on the wrong row.
        Text('Automate your', textAlign: TextAlign.center, style: ZaveType.h2),
        ZaveGradientText('LinkedIn presence', style: ZaveType.h2),

        const Spacer(),
        // Flexible, not a fixed height: this is the one element that should
        // give way when the screen is short, because the buttons and the
        // heading must not.
        Flexible(
          flex: 14,
          child: Image.asset(
            'assets/branding/orbit_hero.png',
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),

        Text(
          'Your AI co-pilot for building a\nLinkedIn presence that compounds.',
          textAlign: TextAlign.center,
          style: ZaveType.lead,
        ),

        const Spacer(flex: 3),

        _AuthChoice(
          icon: const _ProviderLetter('G'),
          label: 'Sign in with Google',
          primary: true,
          busy: googleBusy,
          onPressed: onGoogle,
        ),
        SizedBox(height: ZaveSpace.md),
        _AuthChoice(
          icon: const Icon(Icons.mail_outline, size: 20),
          label: 'Sign in with Email',
          onPressed: onEmail,
        ),

        SizedBox(height: ZaveSpace.lg),
      ],
    );
  }
}

/// The mark beside the name.
///
/// No BETA pill. The reference carries one because Orbit is in beta; this
/// product is not, and shipping someone else's disclaimer as decoration is how
/// a mockup detail becomes a claim.
class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The foreground variant: the mark in white on transparent. The full
        // app icon is the same mark on a black tile, which would sit here as a
        // visible square on a ground that is not quite black.
        Image.asset(
          'assets/branding/logo_mark.png',
          // Height only. The mark is taller than it is wide, and forcing a
          // square would squash it.
          height: 28,
          filterQuality: FilterQuality.medium,
        ),
        SizedBox(width: ZaveSpace.md),
        Text('Plexaverse', style: ZaveType.wordmark),
      ],
    );
  }
}

/// One of the two ways in.
///
/// Not [ZaveButton]: the reference divides the icon off from the label with a
/// hairline, which no button in the kit does, and adding the rule to the
/// shared button for one screen would put it on every screen.
class _AuthChoice extends StatelessWidget {
  const _AuthChoice({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.busy = false,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final Color fg = ZaveColors.white;

    return Semantics(
      button: true,
      label: label,
      child: ZavePress(
        enabled: onPressed != null && !busy,
        child: GestureDetector(
          onTap: busy ? null : onPressed,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 58,
            decoration: primary
                ? BoxDecoration(
                    color: ZaveColors.violet,
                    borderRadius: ZaveRadius.pillBr,
                    boxShadow: ZaveShadow.bloom,
                  )
                : BoxDecoration(
                    borderRadius: ZaveRadius.pillBr,
                    border: Border.all(
                      color: ZaveGlass.controlBorder,
                      width: 1,
                    ),
                  ),
            alignment: Alignment.center,
            child: busy
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconTheme.merge(
                        data: IconThemeData(color: fg),
                        child: icon,
                      ),
                      SizedBox(width: ZaveSpace.lg),
                      // The divider. It is what makes these read as the
                      // reference's buttons rather than as icon-and-label.
                      Container(
                        width: 1,
                        height: 22,
                        color: primary
                            ? ZaveColors.rule
                            : ZaveGlass.controlBorder,
                      ),
                      SizedBox(width: ZaveSpace.lg),
                      // Flexible: "Continue with Google" past the icon and the
                      // divider is wider than a 375pt screen leaves, and a
                      // bare Text in a Row cannot give any of it back.
                      Flexible(
                        child: Text(
                          label,
                          style: ZaveType.button.copyWith(color: fg),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// The letterform that stands in for a vendor logo.
///
/// The same decision `SocialAuthButton` already made and documented: this app
/// ships no vendor logo assets, and a hand-drawn approximation of Google's
/// mark is worse than a letter on both counts — it looked wrong, and their
/// brand guidelines require the real asset rather than a redraw.
///
/// Manrope is Zave's naming face, which is what a wordmark is.
class _ProviderLetter extends StatelessWidget {
  const _ProviderLetter(this.glyph);

  final String glyph;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 20,
    child: Text(
      glyph,
      textAlign: TextAlign.center,
      style: ZaveType.button.copyWith(color: ZaveColors.white),
    ),
  );
}
