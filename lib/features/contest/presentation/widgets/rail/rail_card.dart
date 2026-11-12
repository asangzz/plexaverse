import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../contest_kit.dart';

/// The rail's card: the 5% glass panel with a title row. The web's
/// `RailCard`.
///
/// The web's rail sits beside the path on a desktop and stacks under it on a
/// phone; the app is a phone, so these are simply the cards under the path,
/// each reached from the section bar.
class RailCard extends StatelessWidget {
  const RailCard({required this.child, this.title, this.aside, super.key});

  final Widget child;
  final String? title;

  /// The small periwinkle word at the title's right: "View all", "Resets at
  /// midnight", "+640 XP".
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    final String? heading = title;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (heading != null) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(heading, style: railTitle),
                  ),
                ),
                if (aside case final Widget side) ...<Widget>[
                  const SizedBox(width: 12),
                  side,
                ],
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

/// A rail card's title: Manrope 17 / 800.
TextStyle get railTitle => GoogleFonts.manrope(
  fontSize: 17,
  fontWeight: FontWeight.w800,
  color: ZaveColors.white,
);

/// The rail's supporting text: 13 at 62% white.
TextStyle get railMuted =>
    ZaveType.body.copyWith(fontSize: 13, height: 1.5, color: ZaveColors.ink62);

/// The aside's type: 12 / 800, upper-case, periwinkle.
TextStyle get railAsideStyle => GoogleFonts.manrope(
  fontSize: 12,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.2,
  color: ContestColors.peri,
  fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
);

/// The title's aside, as words or as a link.
class RailAside extends StatelessWidget {
  const RailAside(this.text, {this.onTap, super.key});

  final String text;

  /// Null draws the words alone.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(text.toUpperCase(), style: railAsideStyle);
    final VoidCallback? tap = onTap;
    if (tap == null) return label;
    return Semantics(
      link: true,
      label: text,
      excludeSemantics: true,
      child: InkWell(
        onTap: tap,
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: label,
            ),
          ),
        ),
      ),
    );
  }
}
