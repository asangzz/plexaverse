import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/chat_bubble.dart';

/// The chat surface's own measurements, ported from
/// `components/chat/PlexaChatKit.tsx`.
///
/// Deliberately NOT the Zave card geometry. A bubble is not a card: it is
/// small, it repeats down a column, and it carries a tail. The web's numbers
/// are reproduced here rather than approximated with the nearest Zave token so
/// the two surfaces can be held side by side and compared — which is how this
/// port came to be rewritten in the first place.
class _Bubble {
  const _Bubble._();

  /// `borderRadius: 14` with the speaker's TOP corner at 4.
  ///
  /// The top, not the bottom. A tail at the top points back up at the avatar
  /// beside it and at the line before it, which is what groups a run of
  /// messages into one speaker's turn.
  static double get radius => 14.r;
  static const Radius tail = Radius.circular(4);

  /// `padding: '12px 16px'`.
  static EdgeInsets get pad =>
      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w);

  /// The avatar, and the spacer that stands in for it on a grouped message so
  /// the column does not shift.
  static double get avatar => 36.r;

  /// `gap-3` between avatar and bubble; `gap-1.5` inside the column.
  static double get rowGap => 12.w;
  static double get colGap => 6.h;

  /// `max-w-[78%]`.
  static const double maxWidthFraction = 0.78;

  /// `space-y-4` — between every line in the thread.
  static double get gap => 16.h;
}

/// The vertical rhythm of the thread, for the list that lays it out.
double get chatBubbleGap => _Bubble.gap;

/// Plexa's avatar — a gradient ring around the mark on a near-black disc.
///
/// The ring is violet → cyan → green, the product's full spectrum, and it is
/// the only place in the app where all three appear at once. That is what
/// makes a 36px circle read as *the assistant* rather than as a generic
/// contact photo.
class BotAvatar extends StatelessWidget {
  const BotAvatar({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final double d = size ?? _Bubble.avatar;
    return Container(
      height: d,
      width: d,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF5761EB),
            Color(0xFF00C6FF),
            ZaveColors.green,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x595761EB), blurRadius: 16, spreadRadius: -2),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF0E0E14),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/branding/logo_mark.png',
          width: d * 0.62,
          height: d * 0.62,
          fit: BoxFit.contain,
          // The ring already identifies the speaker. A broken-image glyph in
          // the middle of it would be worse than an empty disc.
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// The user's side of the thread — their initial on glass, or a person glyph.
///
/// The web puts the signed-in user's photo or initial here, free, because the
/// session is already in the browser's hands. This app has no cached display
/// name: the session store holds tokens only, and the one provider that knows
/// the name is `accountSnapshot`, which is cold on this path.
///
/// So an initial costs a `GET /account` round trip to draw one letter, on a
/// sheet whose whole design is about not making the user wait. The glyph is
/// the honest answer — and a wrong-looking initial ("Y", from the literal
/// string "You") is worse than no initial at all. Pass a real [name] when a
/// caller already has one.
class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final String? initial = (name == null || name!.trim().isEmpty)
        ? null
        : name!.trim().characters.first.toUpperCase();

    return Container(
      height: _Bubble.avatar,
      width: _Bubble.avatar,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ZaveFill.rest,
        border: Border.all(color: ZaveColors.rule),
      ),
      child: initial == null
          ? Icon(AppIcons.person, size: 14.sp, color: ZaveColors.ink62)
          : Text(
              initial,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                color: ZaveColors.white,
              ),
            ),
    );
  }
}

/// One line of the conversation.
///
/// Plexa's lines sit left behind her avatar; the user's sit right, inverted.
/// The avatar and the PLEXA label are drawn only on the FIRST bubble of a run
/// — a column of identical discs reads as six speakers rather than one.
class ChatBubbleView extends StatelessWidget {
  const ChatBubbleView({
    required this.bubble,
    required this.isGroupStart,
    this.userName,
    super.key,
  });

  final ChatBubble bubble;

  /// This bubble starts a new run by the same speaker.
  final bool isGroupStart;

  /// The signed-in user's display name, when the caller has one.
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final bool isBot = bubble.role == ChatRole.bot;

    final Widget gutter = isGroupStart
        ? (isBot ? const BotAvatar() : _UserAvatar(name: userName))
        : SizedBox(width: _Bubble.avatar);

    final Widget column = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * _Bubble.maxWidthFraction,
      ),
      child: Column(
        crossAxisAlignment: isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isBot && isGroupStart) ...<Widget>[
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: _Bubble.colGap),
              child: Text('PLEXA', style: _plexaLabel),
            ),
          ],
          Container(
            padding: _Bubble.pad,
            decoration: isBot
                ? BoxDecoration(
                    gradient: ZaveFill.rest,
                    border: ZaveEdgeBorder(
                      gradient: ZaveEdge.rest,
                      highlight: ZaveEdge.bevel,
                    ),
                    borderRadius: _radius(isBot: true),
                  )
                : BoxDecoration(
                    gradient: ZaveAccent.violetCard,
                    borderRadius: _radius(isBot: false),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x8C5433D8),
                        blurRadius: 28,
                        spreadRadius: -10,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
            child: Text(
              bubble.text,
              // `whitespace-pre-line` on the web: an item's first line is
              // "Comment 1 of 4 — Author · handle\nThe headline", and the
              // break is the whole reason the two read as separate facts.
              style: _bubbleText.copyWith(
                color: isBot ? const Color(0xFFE2E2EA) : ZaveColors.white,
              ),
            ),
          ),
          if (bubble.badge != null) ...<Widget>[
            SizedBox(height: _Bubble.colGap),
            _Badge(text: bubble.badge!, tone: bubble.badgeTone),
          ],
        ],
      ),
    );

    // No margin of its own: the thread owns the rhythm, at one uniform
    // `space-y-4` between every line. Varying the gap by grouping was a guess,
    // and it made a run of Plexa's lines read as one paragraph break up.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isBot
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        if (isBot) ...<Widget>[gutter, SizedBox(width: _Bubble.rowGap)],
        Flexible(child: column),
        if (!isBot) ...<Widget>[SizedBox(width: _Bubble.rowGap), gutter],
      ],
    );
  }

  BorderRadius _radius({required bool isBot}) => BorderRadius.only(
    topLeft: isBot ? _Bubble.tail : Radius.circular(_Bubble.radius),
    topRight: isBot ? Radius.circular(_Bubble.radius) : _Bubble.tail,
    bottomLeft: Radius.circular(_Bubble.radius),
    bottomRight: Radius.circular(_Bubble.radius),
  );
}

TextStyle get _bubbleText => GoogleFonts.urbanist(
  fontSize: 14.sp,
  height: 1.65,
  fontWeight: FontWeight.w400,
);

TextStyle get _plexaLabel => GoogleFonts.jetBrainsMono(
  fontSize: 9.sp,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.18 * 9.sp,
  color: const Color(0xB35761EB),
);

/// The small green qualifier under a user line — "COPIED".
///
/// Green, and the same green as every other confirmation in the product. It
/// sits outside the bubble rather than inside it because it is not something
/// the user said: it is the app reporting what it did on their behalf.
class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.tone});

  final String text;
  final ChatBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final bool ok = tone == ChatBadgeTone.ok;
    final Color ink = ok ? ZaveColors.green : ZaveColors.amber;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ink.withValues(alpha: 0.10),
        border: Border.all(color: ink.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(ZaveRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(ok ? AppIcons.check : AppIcons.warning, size: 9.sp, color: ink),
          SizedBox(width: 5.w),
          Text(
            text.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.12 * 9.sp,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Three dots, while Plexa is composing.
///
/// The pause is the point: it is what makes the thread read as someone
/// thinking rather than as a form that printed itself.
class TypingBubble extends StatefulWidget {
  const TypingBubble({required this.collapseAvatar, super.key});

  /// The previous line was also Plexa's, so the avatar is already drawn.
  final bool collapseAvatar;

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  // 0.8s per dot with a 0.18s stagger across three — the last one starts at
  // 0.36s, so the cycle has to be long enough to hold all three.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1160),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      if (widget.collapseAvatar)
        SizedBox(width: _Bubble.avatar)
      else
        const BotAvatar(),
      SizedBox(width: _Bubble.rowGap),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: ZaveFill.rest,
          border: ZaveEdgeBorder(gradient: ZaveEdge.rest),
          borderRadius: BorderRadius.only(
            topLeft: _Bubble.tail,
            topRight: Radius.circular(_Bubble.radius),
            bottomLeft: Radius.circular(_Bubble.radius),
            bottomRight: Radius.circular(_Bubble.radius),
          ),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (BuildContext context, Widget? _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < 3; i++) ...<Widget>[
                if (i > 0) SizedBox(width: 4.w),
                _dot(i),
              ],
            ],
          ),
        ),
      ),
    ],
  );

  Widget _dot(int i) {
    // 0.8s of motion inside a 1.16s cycle, offset by 0.18s per dot. Outside
    // its own window the dot rests at the bottom at 0.3 opacity.
    const double cycle = 1160;
    const double span = 800 / cycle;
    final double start = (i * 180) / cycle;
    final double local = ((_c.value - start) % 1) / span;
    final double t = local >= 0 && local <= 1 ? local : 0;
    final double wave = t < 0.5 ? t * 2 : (1 - t) * 2;

    return Transform.translate(
      offset: Offset(0, -4 * wave),
      child: Opacity(
        opacity: 0.3 + 0.7 * wave,
        child: Container(
          height: 6.r,
          width: 6.r,
          decoration: const BoxDecoration(
            color: Color(0xB35761EB),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
