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

/// One rung, on the path.
///
/// Three states and they must be told apart at a glance, because the whole
/// point of a path is that you can see where you are without reading:
/// complete is green and filled, available is the violet "this one" disc, and
/// locked is flat glass at reduced contrast.
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
  final String? label;
  final VoidCallback? onTap;

  static const double _size = 56;

  @override
  Widget build(BuildContext context) {
    final bool complete = status == LevelStatus.complete;
    final bool locked = status == LevelStatus.locked;

    final Color fill = complete
        ? ZaveColors.green.withValues(alpha: 0.18)
        : locked
        ? ZaveGlass.rest
        : ZaveColors.violet;
    final Color border = complete
        ? ZaveColors.green
        : locked
        ? ZaveGlass.restBorder
        : ZaveColors.violet;
    final Color ink = complete
        ? ZaveColors.green
        : locked
        ? ZaveColors.ink35
        : ZaveColors.white;

    final Widget disc = Container(
      height: _size,
      width: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1.5),
        // Only the live one glows. A path where every node glows has no "you
        // are here".
        boxShadow: !complete && !locked ? ZaveShadow.bloom : null,
      ),
      child: Icon(
        complete ? AppIcons.check : iconForLevel(kind),
        size: 22,
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
          if (onTap == null)
            disc
          else
            ZavePress(
              child: GestureDetector(onTap: onTap, child: disc),
            ),
          if (label case final String text) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            SizedBox(
              width: 86,
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ZaveType.caption.copyWith(
                  color: locked ? ZaveColors.ink35 : ZaveColors.ink85,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
