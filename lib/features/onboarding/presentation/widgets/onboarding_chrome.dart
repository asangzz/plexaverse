import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The setup progress bar.
///
/// The web's is a 3px track with a three-stop gradient fill (indigo → cyan →
/// green). Zave has no decorative gradient, and a fill that changes hue as it
/// grows would be reading as three different statuses on the way to done — so
/// the fill is white, which is this system's "active" surface, and the
/// percentage beside it is `.num` (periwinkle, the counter face).
///
/// The floor of 5% is the web's and worth keeping: step one still has to look
/// like progress rather than like nothing has happened.
class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({required this.percent, super.key});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: ZaveRadius.pillBr,
            child: Stack(
              children: <Widget>[
                Container(height: ZaveSpace.xs, color: ZaveColors.rule),
                AnimatedFractionallySizedBox(
                  // The web animates this over 0.45s; ZaveMotion.page is the
                  // nearest token and the only one long enough to read as a
                  // bar filling rather than a bar jumping.
                  duration: ZaveMotion.page,
                  curve: ZaveMotion.curve,
                  widthFactor: (percent / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: ZaveSpace.xs,
                    color: ZaveColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: ZaveSpace.md),
        Text('$percent%', style: ZaveType.num),
      ],
    );
  }
}

/// The bottom band the step's control sits in.
///
/// Midnight at 78% over the same backdrop blur as the sticky header, with a
/// single hairline on top instead of underneath — so the thread scrolls under
/// it exactly as it scrolls under the header.
class OnboardingDock extends StatelessWidget {
  const OnboardingDock({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ZaveSurface.headerBlurSigma,
          sigmaY: ZaveSurface.headerBlurSigma,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: ZaveGlass.headerFill,
            border: Border(
              top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ZaveSpace.gutter,
            vertical: ZaveSpace.lg,
          ),
          child: ConstrainedBox(
            // The web pins the band between 72 and min(60dvh, 560px). The floor
            // is what stops it collapsing and re-expanding as the control
            // swaps for the typing hint; the ceiling keeps a long panel from
            // eating the conversation, and the panel scrolls inside it.
            constraints: BoxConstraints(
              minHeight: ZaveSpace.section,
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            // A shrink-wrapping list, NOT a SingleChildScrollView: a scroll
            // view given a bounded height fills it, so the band would sit at
            // 60% of the screen on every step, chip rows included. shrinkWrap
            // sizes to the control and lets the ceiling above do the capping.
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              // Never bounces past its own content into the thread behind it.
              physics: const ClampingScrollPhysics(),
              children: <Widget>[child],
            ),
          ),
        ),
      ),
    );
  }
}

/// The centred "Plexa is typing…" / "Setting things up…" line.
///
/// The web's `DockHint`. On a panel step this replaces the composer while Plexa
/// is speaking — which also holds the band's height, and stops anyone typing
/// into a half-asked question.
class DockHint extends StatelessWidget {
  const DockHint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: ZaveSpace.lg,
          width: ZaveSpace.lg,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: ZaveSpace.md),
        Text(text, style: ZaveType.caption),
      ],
    );
  }
}
