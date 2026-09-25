import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// `Your activity ›` — a section title with its way in on the right.
///
/// The reference uses two forms and they are not interchangeable: a bare
/// chevron when the section continues sideways (a scrolling strip whose rest
/// is off-screen), and words — `See All` — when it opens a different screen.
/// Pass [actionLabel] for the second; leave it null for the first.
///
/// The title is `.h3`, not `.kicker`: these are names of things, and the
/// reference sets them in sentence case at reading size rather than as
/// spaced-out uppercase labels.
class ZaveSectionHeader extends StatelessWidget {
  const ZaveSectionHeader({
    required this.title,
    this.onTap,
    this.actionLabel,
    super.key,
  });

  final String title;
  final VoidCallback? onTap;

  /// Words instead of a chevron, for a section that opens a screen.
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      children: <Widget>[
        Expanded(child: Text(title, style: ZaveType.h3)),
        if (onTap != null)
          if (actionLabel != null)
            Text(
              actionLabel!,
              style: ZaveType.label.copyWith(color: ZaveColors.ink62),
            )
          else
            Icon(Icons.chevron_right, size: 22, color: ZaveColors.ink62),
      ],
    );

    if (onTap == null) return row;
    return ZavePress(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      ),
    );
  }
}

/// The reference's page opening: a small tinted kicker over a large centred
/// heading.
///
/// Both are centred, which is the whole device — every other heading in this
/// app is left-aligned, so centring is what marks a screen as an entry point
/// rather than a list. Use it at the top of a destination, never mid-page.
///
/// The kicker is lavender rather than [ZaveColors.ink45]: it is the only small
/// text in the reference that carries colour, and it is what stops the big
/// heading from starting cold.
class ZaveHeroHeading extends StatelessWidget {
  const ZaveHeroHeading({required this.kicker, required this.title, super.key});

  final String kicker;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          kicker,
          textAlign: TextAlign.center,
          style: ZaveType.label.copyWith(color: ZaveColors.lavenderLo),
        ),
        SizedBox(height: ZaveSpace.sm),
        Text(title, textAlign: TextAlign.center, style: ZaveType.h2),
      ],
    );
  }
}
