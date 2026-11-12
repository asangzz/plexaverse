import 'package:flutter/material.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_words.dart';
import 'lesson_chest.dart';

/// The week trophy at the end of the path: the week's bonus for finishing
/// every day's lesson in it. A port of the web's trophy `Chest`.
///
/// ## The server decides it
///
/// [trophy] is `weekTrophy(path.weekReward)` — the same rule the answer that
/// pays the bonus uses — so it cannot open on a week that was never paid, or
/// stay shut on one that was.
///
/// ## The red tag sits under it
///
/// A week that can no longer be earned (a day's lesson went unfinished) is
/// drawn shut with its cup dimmed and a red tag saying what it cost. The web
/// puts that tag beside the trophy on a desktop and under it on a phone; a
/// phone is all this app is drawn for.
///
/// Unlike the chest it is spoken: it pays, so a screen reader hears its
/// state in words.
class WeekTrophyView extends StatelessWidget {
  const WeekTrophyView({required this.trophy, required this.offset, super.key});

  final WeekTrophy trophy;

  /// The path's sideways swing at this step, in logical pixels.
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: trophy.label,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Transform.translate(
              offset: Offset(offset, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 96,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: chestDecoration(open: trophy.open),
                    // Dim the cup, not the box: the box's opacity would dim
                    // the red tag too.
                    child: Opacity(
                      opacity: trophy.missed ? 0.6 : 1,
                      child: Icon(
                        AppIcons.trophy,
                        size: 42,
                        color: trophy.open ? ZaveColors.white : kShutGlyph,
                      ),
                    ),
                  ),
                  if (trophy.missed) ...<Widget>[
                    const SizedBox(height: 20),
                    _MissedTag(trophy.label),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// What an incomplete week cost: "−500 XP missed · incomplete week".
class _MissedTag extends StatelessWidget {
  const _MissedTag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x24FF6B6B),
        border: Border.all(color: const Color(0x8CFF6B6B)),
        borderRadius: ZaveRadius.pillBr,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ZaveType.label.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFFF8F8F),
        ),
      ),
    );
  }
}
