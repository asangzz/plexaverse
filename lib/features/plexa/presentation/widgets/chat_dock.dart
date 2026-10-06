import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/zave/zave_kit.dart';

/// The dock — what the user can say next.
///
/// A port of the dock primitives in `components/chat/PlexaChatKit.tsx`. The
/// thread has no text field anywhere: every turn the user can take is a chip,
/// and the chip IS the message. That constraint is deliberate — a free-text
/// box would invite questions Plexa cannot answer inside a hand-off flow, and
/// the whole surface is built to be finished with a thumb.

/// A row of chips. Wraps, because two chips plus a long label will not fit a
/// narrow phone on one line.
class ChipRow extends StatelessWidget {
  const ChipRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(
    // Centred, like the day chat's own dock. The reply chip's lane parity is
    // a shape argument, not a position one — it is the BOX that has to match
    // the bubble it becomes, and on a phone both fit one line anyway.
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 10.w,
    runSpacing: 10.h,
    children: children,
  );
}

/// What the dock shows when there is nothing to say yet — a spinner and a
/// line, so the sheet is never silently empty while it waits.
class DockHint extends StatelessWidget {
  const DockHint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 16.r,
          width: 16.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5761EB)),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: ZaveColors.ink35,
          ),
        ),
      ],
    ),
  );
}

/// The chip that carries the turn forward.
///
/// With [reply] it is drawn as the message the user is ABOUT to send: the same
/// box as a user bubble — 14px radius with the top-right corner at 4 — hollow
/// at rest, filling as it is pressed. On release the chip unmounts and the
/// bubble mounts into the same box in the same lane, so the eye reads
/// substitution rather than replacement. The parity is the trick; don't tidy
/// the numbers.
class PrimaryChip extends StatefulWidget {
  const PrimaryChip({
    required this.label,
    required this.onPressed,
    this.icon,
    this.reply = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;

  /// Render in the user's lane as an unsent draft.
  final bool reply;

  final bool enabled;

  @override
  State<PrimaryChip> createState() => _PrimaryChipState();
}

class _PrimaryChipState extends State<PrimaryChip> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.icon != null) ...<Widget>[
          Opacity(opacity: 0.9, child: widget.icon),
          SizedBox(width: widget.reply ? 10.w : 8.w),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: widget.reply
                ? GoogleFonts.urbanist(
                    // Body weight, like a bubble. 600 reads as a button, and
                    // this is supposed to read as something the user said.
                    fontSize: 14.sp,
                    height: 1.65,
                    fontWeight: FontWeight.w400,
                    color: ZaveColors.white,
                  )
                : GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ZaveColors.white,
                  ),
          ),
        ),
        if (widget.reply) ...<Widget>[
          SizedBox(width: 10.w),
          Opacity(
            opacity: _down ? 1 : 0.6,
            child: Icon(
              Icons.send_rounded,
              size: 14.sp,
              color: ZaveColors.white,
            ),
          ),
        ],
      ],
    );

    final BorderRadius radius = widget.reply
        ? BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: const Radius.circular(4),
            bottomLeft: Radius.circular(14.r),
            bottomRight: Radius.circular(14.r),
          )
        : BorderRadius.circular(12.r);

    return ZavePress(
      enabled: widget.enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapCancel: () => _set(false),
        onTapUp: (_) => _set(false),
        onTap: widget.enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: ZaveMotion.quick,
          curve: ZaveMotion.curve,
          padding: widget.reply
              ? EdgeInsets.fromLTRB(15.w, 11.h, 13.w, 11.h)
              : EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: widget.reply && !_down
                // Hollow. An unchosen option must never render in the same
                // fill as one already committed, or the thread stops
                // answering "what have I said" against "what can I pick".
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0x385761EB), Color(0x244752D9)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF5761EB), Color(0xFF4752D9)],
                  ),
            border: Border.all(
              // Carries the 3:1 boundary contrast against the sheet's near
              // black on its own, because the hollow fill cannot.
              color: const Color(0xE65761EB),
            ),
            boxShadow: widget.reply && !_down
                // An unsent message hasn't landed, so it casts nothing.
                ? null
                : const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x8C5761EB),
                      blurRadius: 22,
                      spreadRadius: -8,
                      offset: Offset(0, 6),
                    ),
                  ],
          ),
          child: content,
        ),
      ),
    );
  }
}

/// The quiet option. Ghost fill, muted label.
///
/// With [reply] it takes the user lane's corner and keeps its ghost fill, and
/// gets NO send glyph — a skip is a refusal to send, not a message.
class SecondaryChip extends StatelessWidget {
  const SecondaryChip({
    required this.label,
    required this.onPressed,
    this.icon,
    this.reply = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool reply;

  @override
  Widget build(BuildContext context) => ZavePress(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          border: Border.all(color: const Color(0x1AFFFFFF)),
          borderRadius: reply
              ? BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: const Radius.circular(4),
                  bottomLeft: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                )
              : BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Opacity(opacity: 0.6, child: icon),
              SizedBox(width: 7.w),
            ],
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0x8CFFFFFF),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
