import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../onboarding/domain/onboarding_step.dart'
    show kRegistrationXpLabel;

/// The one-off "+2,500 XP" celebration — the web's `XPWelcomeAnimation` in
/// `app/(dashboard)/onboarding/OnboardingClient.tsx`.
///
/// Shown once, for an account whose welcome bonus has only just landed. Tap
/// anywhere, or wait four seconds, and it goes. Plexa is held while it is up
/// (see `PlexaMascot.hold`): her entrance is the first seconds of the hello
/// clip, and behind this nobody would see it.
///
/// The colours are the web's own for this moment — the indigo and green of
/// the XP mark — not Zave tokens; like the intro, it is the new design.
class WelcomeBonusOverlay extends StatefulWidget {
  const WelcomeBonusOverlay({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  State<WelcomeBonusOverlay> createState() => _WelcomeBonusOverlayState();
}

class _WelcomeBonusOverlayState extends State<WelcomeBonusOverlay>
    with TickerProviderStateMixin {
  static const Color _indigo = Color(0xFF5761EB);
  static const Color _green = Color(0xFF00DC82);

  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final AnimationController _rings = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  Timer? _auto;
  bool _gone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_auto != null) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else {
      _enter.forward();
      _rings.repeat();
    }
    _auto = Timer(const Duration(seconds: 4), _dismiss);
  }

  void _dismiss() {
    if (_gone) return;
    _gone = true;
    widget.onDismiss();
  }

  @override
  void dispose() {
    _auto?.cancel();
    _enter.dispose();
    _rings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> pop = CurvedAnimation(
      parent: _enter,
      curve: Curves.easeOutBack,
    );
    final Animation<double> fade = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0, 0.5),
    );

    return Semantics(
      liveRegion: true,
      button: true,
      label: 'Welcome bonus, plus $kRegistrationXpLabel XP. Tap to continue.',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _dismiss,
        child: FadeTransition(
          opacity: fade,
          // The web's `bg-black/80 backdrop-blur-sm`: dimmed AND blurred, so
          // the intro's line behind does not read through the numbers.
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 220,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          for (int i = 1; i <= 3; i++)
                            AnimatedBuilder(
                              animation: _rings,
                              builder: (BuildContext context, Widget? _) {
                                final double t = (_rings.value + i * 0.15) % 1;
                                return Opacity(
                                  opacity: (0.6 * (1 - t)).clamp(0, 1),
                                  child: Transform.scale(
                                    scale: 0.5 + t * (2 + i * 0.5),
                                    child: Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: <Color>[
                                            const Color(
                                              0xFF7000FF,
                                            ).withValues(alpha: 0.3 / i),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ScaleTransition(
                            scale: pop,
                            child: RotationTransition(
                              turns: Tween<double>(
                                begin: -0.5,
                                end: 0,
                              ).animate(pop),
                              child: Container(
                                width: 96,
                                height: 96,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[_indigo, _indigo, _green],
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: _indigo.withValues(alpha: 0.4),
                                      blurRadius: 60,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'XP',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome Bonus!',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ScaleTransition(
                      scale: pop,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect r) => const LinearGradient(
                          colors: <Color>[_green, _indigo],
                        ).createShader(r),
                        child: Text(
                          '+$kRegistrationXpLabel XP',
                          style: GoogleFonts.urbanist(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap anywhere to continue',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: const Color(0xFF979797),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
