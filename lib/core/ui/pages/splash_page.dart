import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../responsive/screen_util.dart';
import '../../theme/app_spacing.dart';
import '../../theme/plexaverse_colors.dart';

/// Cold-start splash on the full-bleed brand violet. Shown while the session,
/// app-lock and onboarding state resolve; the **router redirect owns all
/// navigation** — this page never pushes/pops.
///
/// A soft halo behind the wordmark with three pulsing dots below. Under
/// Reduce Motion the dots are swapped for a static localized label so nothing
/// animates. Sets a light status bar via [AnnotatedRegion] since the violet
/// surface is dark.
///
/// Ported from the ProHealth reference (`core/ui/pages/splash_page.dart`),
/// re-skinned to the Plexaverse brand (violet `#6C63FF`, `appName` wordmark).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      if (_controller.isAnimating) _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    const brandStart = PlexaversePalette.primary;
    const brandEnd = PlexaversePalette.primaryDark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[brandStart, brandEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Halo(child: _Wordmark(text: AppL10n.of(context).appName)),
                SizedBox(height: AppSpacing.xl.h),
                if (reduceMotion)
                  Text(
                    AppL10n.of(context).loading,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  _PulsingDots(controller: _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.child});

  final Widget child;

  static const double _size = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size.r,
      height: _size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: 0.16),
            Colors.transparent,
          ],
        ),
      ),
      child: child,
    );
  }
}

class _PulsingDots extends StatelessWidget {
  const _PulsingDots({required this.controller});

  final AnimationController controller;

  static const int _count = 3;
  static const double _dotSize = 8;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < _count; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final phase = (controller.value + i / _count) % 1.0;
                final scale = 0.6 + 0.4 * (1 - (phase - 0.5).abs() * 2);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: _dotSize.r,
                    height: _dotSize.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
