import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// Says, in as many words, that something the web can do is not wired here
/// yet — and why.
///
/// This slice needs it three times, which is unusual and worth stating: all
/// three surfaces want to read a photo off the device, and the app ships no
/// image-picker package. The alternative — a dropzone that opens nothing, or a
/// button that silently does nothing — is the failure mode this whole
/// alignment exists to undo: the previous client rendered every screen against
/// an invented endpoint map and looked online while 404ing.
///
/// Amber, because Zave has no red and this is a "waiting on something" state,
/// not a destructive one.
class AiToolNote extends StatelessWidget {
  const AiToolNote({required this.message, this.title, super.key});

  /// Optional heading, when the note is the whole content of a panel.
  final String? title;

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          // Nudge the dot onto the first line's optical centre.
          padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
          child: const ZaveDot(ZaveColors.amber),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null) ...<Widget>[
                Text(
                  title!,
                  style: ZaveType.label.copyWith(color: ZaveColors.white),
                ),
                SizedBox(height: ZaveSpace.xs),
              ],
              Text(message, style: ZaveType.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// [AiToolNote] inside a `.row` panel, for when it sits among controls rather
/// than as a whole card's content.
class AiToolNoteRow extends StatelessWidget {
  const AiToolNoteRow({required this.message, this.title, super.key});

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: ZaveSpace.rowPad,
    decoration: ZaveSurface.row,
    child: AiToolNote(title: title, message: message),
  );
}

/// The one XP line every AI tool carries — "800 XP per poster".
///
/// The web paints this in `#5761EB` on a tinted panel. In Zave a brand fill is
/// reserved for the XP / upgrade path, and this IS the XP path, so the cost is
/// spelled in [ZaveColors.amber] (points) on a plain `.row`. Blue is kept for
/// the button that actually takes you to billing.
class XpCostRow extends StatelessWidget {
  const XpCostRow({required this.cost, required this.detail, super.key});

  /// e.g. `'800 XP per poster'`.
  final String cost;

  /// The sentence under it, e.g. what the spend buys.
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: ZaveSpace.rowPad,
    decoration: ZaveSurface.row,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
          child: const ZaveDot(ZaveColors.amber),
        ),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                cost,
                style: ZaveType.label.copyWith(color: ZaveColors.amber),
              ),
              SizedBox(height: ZaveSpace.xs),
              Text(detail, style: ZaveType.caption),
            ],
          ),
        ),
      ],
    ),
  );
}
