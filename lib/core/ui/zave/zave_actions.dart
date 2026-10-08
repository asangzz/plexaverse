/// The two floating actions that replaced the bottom bar.
///
/// Write is the product's primary action and keeps the violet disc it had in
/// the centre of the bar. More is the whole of navigation now, and is drawn to
/// sit beside Write without competing with it.
library;

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// The centre compose button — solid white, the one primary action in the app
/// shell. Mirrors the web's "Write" nav item.
/// The secondary action beside [ZaveComposeButton]: everywhere else in the app.
///
/// Since the bottom bar went, this is the ONLY way to reach any screen other
/// than the one you are on — so it is a permanent fixture, not an overflow.
///
/// It wears the compose button's ring and nothing else of it: the same
/// hairline `nowBorder`, a fill so low it reads as transparent, and no bloom.
/// The bloom is what makes the violet disc look pressed-forward, so dropping
/// it is what makes this read as the quieter of the pair while the two still
/// look like one control.
///
/// Not fully transparent, because `extendBody: true` scrolls content UNDER
/// these buttons — a ring with nothing behind it disappears over a card and
/// reappears over the ground, which looks like a rendering fault rather than a
/// style. `ghostFill` is 8% white: enough to hold its shape over anything,
/// far too little to compete with the violet.
class ZaveMoreButton extends StatelessWidget {
  const ZaveMoreButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  /// Matches [ZaveComposeButton.size] — a pair of different-sized discs reads
  /// as a mistake.
  static const double size = ZaveComposeButton.size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'More',
      child: ZavePress(
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            // ClipOval + BackdropFilter, the same treatment the bottom bar
            // used before it went (`headerBlurSigma`, there in a ClipRect).
            // A low-alpha fill alone still let a line of body text read
            // straight through the disc, which is what made it look like a
            // hole rather than a control; blurring what is behind it settles
            // the icon on something instead of over something.
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: ZaveSurface.headerBlurSigma,
                  sigmaY: ZaveSurface.headerBlurSigma,
                ),
                child: Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    color: ZaveGlass.ghostFill,
                    shape: BoxShape.circle,
                    border: Border.all(color: ZaveGlass.nowBorder, width: 1),
                    // The inner white glow. Inset rather than cast, so it
                    // lifts the inside of the disc off whatever is behind it
                    // without putting a halo on the ground around it — that
                    // halo is the compose button's bloom, and it is the one
                    // thing separating the two.
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x1FFFFFFF),
                        blurRadius: 12,
                        spreadRadius: -2,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: ZaveColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZaveComposeButton extends StatelessWidget {
  const ZaveComposeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  /// The button's diameter. The bar reserves a gap wider than this.
  static const double size = 56;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Write',
      child: ZavePress(
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: size,
              width: size,
              // A violet disc inside a hairline ring, which is how the
              // reference draws its centre action: the ring separates the
              // button from the bar behind it without needing a cut-out, and
              // the bloom is the same light the primary button casts.
              decoration: BoxDecoration(
                color: ZaveColors.violet,
                shape: BoxShape.circle,
                border: Border.all(color: ZaveGlass.nowBorder, width: 1),
                boxShadow: ZaveShadow.bloom,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: ZaveColors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
