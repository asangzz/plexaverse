import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import 'chat_lane.dart';

/// A reply chip — **the answer chip IS the user's own message.**
///
/// This is web commit 786847f, and it is the defining interaction of the
/// onboarding flow. The chip is the same box, in the same lane, at the same
/// width as the bubble it becomes; on tap the chip unmounts and the bubble
/// mounts into that box, so the eye reads substitution rather than a control
/// disappearing and a message arriving. There is no transition and no timer,
/// deliberately — a cross-fade would turn a substitution into two events.
///
/// The web keeps the illusion with arithmetic (its chip carries a border the
/// bubble lacks, so its padding is one pixel tighter on each axis). Here both
/// boxes are the Zave chip: same [ZaveSpace.chipPad], same pill radius, same
/// [ZaveType.label] — the sent state is simply the selected one.
///
/// **Pressing previews the send.** The web fades in the sent bubble's exact
/// gradient under the pointer; Zave's equivalent of "this is the chosen one" is
/// the inversion to solid white with ink letters, so holding the chip shows it
/// as the message it is about to become.
class ReplyChip extends StatefulWidget {
  const ReplyChip({required this.label, required this.onTap, super.key});

  /// Also the text of the bubble this becomes. The two must never diverge.
  final String label;

  final VoidCallback? onTap;

  @override
  State<ReplyChip> createState() => _ReplyChipState();
}

class _ReplyChipState extends State<ReplyChip> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final Color fg = _pressed ? ZaveColors.ink : ZaveColors.ink85;

    return Semantics(
      button: true,
      label: widget.label,
      child: ZavePress(
        enabled: widget.onTap != null,
        child: GestureDetector(
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            padding: ZaveSpace.chipPad,
            constraints: BoxConstraints(
              minHeight: ZaveSpace.minTapTarget,
              maxWidth: ChatLaneMetrics.maxBubbleWidth(context),
            ),
            decoration: _pressed ? ZaveSurface.chipSelected : ZaveSurface.chip,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.label,
                    style: ZaveType.label.copyWith(color: fg),
                  ),
                ),
                SizedBox(width: ZaveSpace.sm),
                // Decorative: the chip's accessible name is exactly its label,
                // so the glyph is excluded rather than described.
                ExcludeSemantics(
                  // 14, matching the web's 13px paper plane: small enough to
                  // stay a hint rather than a second control.
                  child: Icon(Icons.send_outlined, size: 14, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A skip, in the reply lane.
///
/// Keeps the chip's box but takes the ghost fill and gets **no** send glyph —
/// the web's reasoning, kept verbatim: *"a skip is a refusal to send, not a
/// message."* It also does not preview the inversion, for the same reason.
class ReplySkipChip extends StatelessWidget {
  const ReplySkipChip({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ZavePress(
        enabled: onTap != null,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: ZaveSpace.chipPad,
            constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
            decoration: BoxDecoration(
              color: ZaveGlass.ghostFill,
              border: Border.all(color: ZaveColors.rule, width: 1),
              borderRadius: ZaveRadius.pillBr,
            ),
            child: Text(
              label,
              style: ZaveType.label.copyWith(color: ZaveColors.ink62),
            ),
          ),
        ),
      ),
    );
  }
}

/// Puts a row of reply chips in the user's lane.
///
/// The web's `UserTurnRow`: right-aligned, capped at the bubble width, with a
/// 36px spacer where the user's avatar sits on a real message — so the chips
/// line up with the bubble they are about to become rather than with the edge
/// of the screen.
class ReplyLane extends StatelessWidget {
  const ReplyLane({required this.chips, this.hint, super.key});

  final List<Widget> chips;

  /// The right-hand mirror of the "PLEXA" eyebrow. Onboarding sets it to "Tap
  /// to send" and only until the user has sent anything — after that the
  /// gesture has been learned and the hint is noise.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (hint != null) ...<Widget>[
                Text(hint!.toUpperCase(), style: ZaveType.kicker),
                SizedBox(height: ZaveSpace.xs),
              ],
              Wrap(
                alignment: WrapAlignment.end,
                spacing: ZaveSpace.sm,
                runSpacing: ZaveSpace.sm,
                children: chips,
              ),
            ],
          ),
        ),
        SizedBox(width: ZaveSpace.md),
        SizedBox(height: ChatLaneMetrics.avatar, width: ChatLaneMetrics.avatar),
      ],
    );
  }
}
