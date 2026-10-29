import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/learn_unit.dart';

/// The glyph for one level of the climb.
///
/// Only three of the seven are their own icon. A draft is [AppIcons.create],
/// a poster is [AppIcons.image] and a read-back is [AppIcons.eye] — because
/// those levels ARE those things, and inventing a second glyph for each would
/// make the ladder look like seven unrelated features.
IconData iconForLevel(LevelKind kind) => switch (kind) {
  LevelKind.vocabulary => AppIcons.book,
  LevelKind.hook => AppIcons.quote,
  LevelKind.substance => AppIcons.briefcase,
  LevelKind.close => AppIcons.campaign,
  LevelKind.draft => AppIcons.create,
  LevelKind.visual => AppIcons.image,
  LevelKind.review => AppIcons.eye,
};

/// One node on the path.
///
/// ## The shape is the status
///
/// A node says what it is before any text is read: a filled violet disc with
/// a raised lip is available, a flat green one is done, a flat glass one is
/// locked. That is Duolingo's trick and it is not decoration — a path of
/// thirty nodes is unreadable if you have to parse a label on each one to
/// know where you are.
///
/// ## The lip
///
/// A hard offset shadow with no blur, which is not a Zave token and is
/// deliberate: it is what makes the live node read as a physical button
/// rather than a flat circle, and it is the one idiom this screen borrows
/// wholesale from the web's own path. Zave's [ZaveShadow] set has nothing
/// with a zero blur because nothing else in the product wants one.
class LevelNode extends StatelessWidget {
  const LevelNode({
    required this.kind,
    required this.status,
    this.label,
    this.onTap,
    super.key,
  });

  final LevelKind kind;
  final LevelStatus status;

  /// Shown in the bubble above the node — but only on the one that is
  /// available. Every node carrying its title turns the path back into the
  /// list it exists not to be.
  final String? label;

  final VoidCallback? onTap;

  static const double size = 68;

  static const List<BoxShadow> _lip = <BoxShadow>[
    BoxShadow(color: Color(0x59000000), offset: Offset(0, 6)),
  ];

  @override
  Widget build(BuildContext context) {
    final bool complete = status == LevelStatus.complete;
    final bool locked = status == LevelStatus.locked;
    final bool available = !complete && !locked;

    final Color fill = complete
        ? ZaveColors.green
        : locked
        ? ZaveGlass.rest
        : ZaveColors.violet;
    final Color ink = complete
        ? ZaveColors.ink
        : locked
        ? ZaveColors.ink35
        : ZaveColors.white;

    final Widget disc = Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        boxShadow: locked ? null : _lip,
      ),
      // A done node keeps its OWN glyph rather than swapping to a tick, as
      // the web's does. The green already says finished; the glyph is what
      // lets a learner scan the path and see which level was which.
      child: Icon(
        locked ? AppIcons.lock : iconForLevel(kind),
        size: 26,
        color: ink,
      ),
    );

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      label: label == null
          ? null
          : '${label!}, ${complete
                ? 'complete'
                : locked
                ? 'locked'
                : 'next'}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (available && label != null) ...<Widget>[
            _Bubble(text: label!),
            SizedBox(height: ZaveSpace.sm),
          ],
          if (onTap == null)
            disc
          else
            ZavePress(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: disc,
              ),
            ),
        ],
      ),
    );
  }
}

/// The white tag over the live node — the one piece of text on the path.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: ZaveSpace.md,
      vertical: ZaveSpace.xs,
    ),
    decoration: BoxDecoration(
      color: ZaveColors.white,
      borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
      boxShadow: ZaveShadow.lifted,
    ),
    child: Text(
      text.toUpperCase(),
      style: ZaveType.kicker.copyWith(color: ZaveColors.ink),
    ),
  );
}
