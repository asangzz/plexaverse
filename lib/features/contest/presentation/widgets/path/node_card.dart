import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import 'path_node.dart';

/// The card a level opens: what it is, what it pays, and the way in. A port
/// of the web's `NodeCard.tsx`.
///
/// ## In the path, under its node
///
/// It drops in under the node's row and pushes the rest of the path down,
/// rather than covering it — the path stays readable around it, as
/// Duolingo's does.
///
/// ## A locked level still opens its card
///
/// Tapping a future day and seeing nothing would read as broken. The card
/// says what the level holds and what it pays, and its button is disabled —
/// the one thing a locked level cannot do is start. A level of today waiting
/// on an earlier one says which: its detail is the server's "Unlocks after
/// Lesson part 3 of 3".
///
/// ## Where the button goes is not decided here
///
/// [onOpen] is the path's, which dispatches on the level's kind. The card
/// only decides whether there is anywhere to go ([canOpen]).
///
/// ## The current level can be skipped
///
/// The one node the server marks `canSkip` (the gate's open level) carries a
/// quiet "Skip this level" under its button (owner, 17 Nov 2026). It pays
/// nothing; the level stays open until the day ends. On success the path
/// closes the card and START moves on; [skipHidden] covers a card opened
/// again within the double-tap guard's window.
class NodeCard extends StatelessWidget {
  const NodeCard({
    required this.node,
    required this.dayName,
    required this.onOpen,
    this.onSkip,
    this.skipping = false,
    this.skipError,
    this.skipHidden = false,
    super.key,
  });

  final PathNode node;

  /// "Wed · Day 17" — the kicker's first half.
  final String dayName;
  final VoidCallback onOpen;

  /// Skip this level. Null: no Skip on this card.
  final VoidCallback? onSkip;

  /// The skip is being sent.
  final bool skipping;

  /// The server's sentence for a refused skip of this level.
  final String? skipError;

  /// The double-tap guard is cooling down after a skip: no Skip right now.
  final bool skipHidden;

  /// The card's colour by kind: the lesson's blue, LinkedIn's, the plan's
  /// green.
  static Color fillFor(PathNodeKind kind) => switch (kind) {
    PathNodeKind.lesson => ContestColors.lesson,
    PathNodeKind.planWeek => ContestColors.plan,
    PathNodeKind.unknown => ContestColors.slab,
    _ => ContestColors.linkedIn,
  };

  @override
  Widget build(BuildContext context) {
    final bool dark = isDarkState(node.state);
    final bool opens = canOpen(node);
    final Color fill = dark ? ContestColors.slab : fillFor(node.kind);
    final TextStyle line = ZaveType.body.copyWith(
      fontSize: 14,
      height: 1.5,
      color: const Color(0xCCFFFFFF),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380),
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: dark
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: node.kind == PathNodeKind.planWeek
                        ? const Color(0x6610A37F)
                        : const Color(0x732F3AF7),
                    blurRadius: 40,
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$dayName · ${kindWord(node.kind)}'.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.44,
                color: const Color(0xB3FFFFFF),
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 6),
            Semantics(
              header: true,
              child: Text(
                node.title,
                style: GoogleFonts.manrope(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: ZaveColors.white,
                ),
              ),
            ),
            if (node.detail case final String detail) ...<Widget>[
              const SizedBox(height: 4),
              Text(detail, style: line),
            ],
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(text: stateWord(node.state)),
                  if (node.points > 0) ...<InlineSpan>[
                    const TextSpan(text: ' · '),
                    TextSpan(
                      text: '+${formatCount(node.points)} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ContestColors.amber,
                      ),
                    ),
                  ],
                ],
              ),
              style: line,
            ),
            const SizedBox(height: 14),
            if (opens)
              _CardButton(
                label: actionWord(node),
                color: dark ? ContestColors.ink : fill,
                onTap: onOpen,
              )
            else
              _CardButton(
                label: node.state == PathNodeState.locked
                    ? 'Locked'
                    : 'Nothing to open',
              ),
            if (node.canSkip && !skipHidden && onSkip != null) ...<Widget>[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ContestTextLink(
                  label: skipping ? 'Skipping…' : kSkipLabel,
                  colour: const Color(0xD9FFFFFF),
                  textAlign: TextAlign.center,
                  onTap: skipping ? null : onSkip,
                ),
              ),
            ],
            if (skipError case final String error) ...<Widget>[
              const SizedBox(height: 4),
              Semantics(
                liveRegion: true,
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: line.copyWith(fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The card's one button: white on its own ledge, in the card's colour, when
/// it opens; a faint, disabled slab when it does not. Upper-cased as drawn,
/// and spoken as written.
class _CardButton extends StatelessWidget {
  const _CardButton({required this.label, this.color, this.onTap});

  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    final TextStyle style = GoogleFonts.manrope(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: enabled ? color : ZaveColors.ink50,
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
    const BorderRadius radius = BorderRadius.all(Radius.circular(14));
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: enabled ? ZaveColors.white : const Color(0x1AFFFFFF),
          boxShadow: enabled
              ? const <BoxShadow>[
                  BoxShadow(color: Color(0xFFC7CBF5), offset: Offset(0, 4)),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            highlightColor: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  label.toUpperCase(),
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
