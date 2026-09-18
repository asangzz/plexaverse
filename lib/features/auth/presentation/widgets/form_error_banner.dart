import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The form-level error banner above the auth form ("Incorrect email or
/// password", "Something went wrong").
///
/// **Amber, not red — Zave has no red.** The pre-alignment banner used
/// `PlexaversePalette.error` (a red) with a 3px left rail. In Zave a negative
/// or failed state is [ZaveColors.amber] ("points, waiting" is the token's
/// primary meaning; it is also the palette's only warning colour, and
/// `ZaveField` already uses it for its own error border, so the banner and the
/// field it explains now agree).
///
/// Depth is a fill step, never a shadow: the banner sits on [ZaveGlass.rest]
/// with an amber hairline rather than an amber wash, so the colour reads as a
/// status marker and not as a second surface.
class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveColors.amber, width: 1),
        borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            // Nudge the dot onto the first line's optical centre. The dot is
            // 9px against a 17px line, so half the difference is the inset.
            padding: EdgeInsets.only(top: ZaveSpace.xs),
            child: const ZaveDot(ZaveColors.amber),
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text(
              message,
              style: ZaveType.body.copyWith(color: ZaveColors.ink85),
            ),
          ),
        ],
      ),
    );
  }
}
