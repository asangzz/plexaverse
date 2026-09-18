import 'package:flutter/material.dart';

/// Shared full-screen background for the Videos / Avatars / Account screens
/// (screenshots 2354, 2369, 2370, 2374 — byte-identical across all four).
///
/// The reference is NOT the flat deep-navy: it is a diagonal linear gradient
/// from navy-indigo `#0B0E3E` at the top-left to pure black `#000002` at the
/// bottom-right. Verified by edge-strip sampling: the right edge at the top
/// equals the left edge at ~20% height — exactly the iso-lines of a
/// topLeft→bottomRight linear gradient on a 412×916 frame.
///
/// Stops were fitted against the sampled strips (projection
/// t = 0.168·x + 0.832·y); linear interpolation between these stops
/// reproduces every sampled point within ±1/channel.
class SkinPageBackground extends StatelessWidget {
  const SkinPageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0E3E), // 0.000 navy-indigo
            Color(0xFF090C33), // 0.170
            Color(0xFF070929), // 0.340
            Color(0xFF06071F), // 0.500
            Color(0xFF05061A), // 0.585 deep navy
            Color(0xFF03030F), // 0.750
            Color(0xFF010105), // 0.914
            Color(0xFF000002), // 1.000 black
          ],
          stops: [0.0, 0.17, 0.34, 0.50, 0.585, 0.75, 0.914, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
