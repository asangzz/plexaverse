import 'package:flutter/material.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../contest_kit.dart';

/// The fill and ledge the chest and the week trophy share: gold once
/// earned, the dark slab until then.
BoxDecoration chestDecoration({required bool open}) => BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(18)),
  color: open ? null : ContestColors.slab,
  gradient: open
      ? const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[ContestColors.amber, Color(0xFFF5A623)],
        )
      : null,
  boxShadow: open
      ? const <BoxShadow>[
          BoxShadow(color: Color(0x73FFD166), blurRadius: 26),
          BoxShadow(color: Color(0xFFB9770E), offset: Offset(0, 8)),
        ]
      : const <BoxShadow>[
          BoxShadow(color: Color(0xFF10163A), offset: Offset(0, 8)),
        ],
);

/// The shut chest's glyph colour, and the shut trophy's.
const Color kShutGlyph = Color(0xFF323A85);

/// The chest after today's LAST lesson part: shut until the day's lesson is
/// finished, gold once it is. The web's `Chest`.
///
/// Decoration: it opens nothing and says nothing to a screen reader — the
/// lesson parts beside it already say how far the day has got. Its label
/// ("Lesson chest", "Lesson done") is a desktop-width side label on the web,
/// which a phone does not draw.
class LessonChest extends StatelessWidget {
  const LessonChest({required this.open, required this.offset, super.key});

  final bool open;

  /// The path's sideways swing at this step, in logical pixels.
  final double offset;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 96,
        child: Center(
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: Container(
              width: 80,
              height: 66,
              alignment: Alignment.center,
              decoration: chestDecoration(open: open),
              child: Icon(
                AppIcons.chest,
                size: 34,
                color: open ? ZaveColors.white : kShutGlyph,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
