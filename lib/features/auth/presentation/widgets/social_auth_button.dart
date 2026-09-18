import 'package:flutter/material.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

enum SocialButtonProvider { google, linkedIn }

class SocialAuthButton extends StatelessWidget {
  final SocialButtonProvider provider;
  final bool isLoading;
  final bool isDark;

  /// Whether this is the "Sign In" flow.
  /// When false (Create Account) the label changes to "Sign up with …".
  final bool isSignIn;
  final VoidCallback? onPressed;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
    this.isDark = true,
    this.isSignIn = true,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (provider) {
      SocialButtonProvider.google =>
        isSignIn ? 'Continue with Google' : 'Sign up with Google',
      SocialButtonProvider.linkedIn =>
        isSignIn ? 'Continue with LinkedIn' : 'Sign up with LinkedIn',
    };

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: isDark ? _darkStyle() : _lightStyle(),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? Colors.white : PlexaversePalette.grey800,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProviderIcon(provider: provider, isDark: isDark),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              ),
      ),
    );
  }

  ButtonStyle _darkStyle() => OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.06),
        foregroundColor: PlexaversePalette.grey50,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 52),
        textStyle: AppTextTheme.labelLarge,
        disabledForegroundColor: PlexaversePalette.grey600,
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.03),
      );

  // Light mode: white fill, 12 px rounded, thin visible border — no hard shadow
  ButtonStyle _lightStyle() => OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: PlexaversePalette.grey900,
        side: const BorderSide(color: Color(0xFFBBBBBB), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 52),
        textStyle:
            AppTextTheme.labelLarge.copyWith(fontWeight: FontWeight.w500),
        disabledForegroundColor: PlexaversePalette.grey400,
        disabledBackgroundColor: PlexaversePalette.grey100,
      );
}

// ─── Provider icon widgets ───────────────────────────────────────────────────

class _ProviderIcon extends StatelessWidget {
  final SocialButtonProvider provider;
  final bool isDark;
  const _ProviderIcon({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return switch (provider) {
      SocialButtonProvider.google => CustomPaint(
          size: const Size(20, 20),
          painter: _GoogleGPainter(
            backgroundColor:
                isDark ? const Color(0xFF1A1A2E) : Colors.white,
          ),
        ),
      SocialButtonProvider.linkedIn => const _LinkedInLogo(),
    };
  }
}

/// Draws the official multi-coloured Google "G" logo.
class _GoogleGPainter extends CustomPainter {
  final Color backgroundColor;
  const _GoogleGPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawArc(canvas, center, radius, -23, 71, const Color(0xFF4285F4));
    _drawArc(canvas, center, radius, 48, 65, const Color(0xFF34A853));
    _drawArc(canvas, center, radius, 113, 65, const Color(0xFFFBBC05));
    _drawArc(canvas, center, radius, 178, 92, const Color(0xFFEA4335));

    // Horizontal bar (right arm of the G)
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - radius * 0.2,
        radius - radius * 0.2,
        radius * 0.4,
      ),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.fill,
    );

    // Inner circle cutout — must match button background
    canvas.drawCircle(
        center, radius * 0.58, Paint()..color = backgroundColor);
  }

  void _drawArc(Canvas canvas, Offset center, double radius, double startDeg,
      double sweepDeg, Color color) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.79),
      startDeg * 3.14159265 / 180,
      sweepDeg * 3.14159265 / 180,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.42,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleGPainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor;
}

/// LinkedIn "in" logo — always blue/white, mode-independent.
class _LinkedInLogo extends StatelessWidget {
  const _LinkedInLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF0077B5),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: const Text(
        'in',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          fontFamily: 'Georgia',
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
