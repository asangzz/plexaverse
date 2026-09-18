import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/onboarding_repository.dart';

/// Shared geometry for both lanes of the onboarding thread.
///
/// The web caps a bubble column at `max-w-[78%]` and sets both avatars to 36px.
/// Zave pins neither, so the percentage is carried verbatim and the avatar
/// takes [ZaveSpace.iconBtn] (38) — the nearest token, and the size Zave
/// already uses for a small circular element.
class ChatLaneMetrics {
  const ChatLaneMetrics._();

  /// The widest a bubble or a reply chip may be, so the opposite lane is
  /// always visibly present.
  static double maxBubbleWidth(BuildContext context) =>
      (MediaQuery.sizeOf(context).width - ZaveSpace.gutter * 2) * 0.78;

  static double get avatar => ZaveSpace.iconBtn;
}

/// One line in the thread.
///
/// ## Why the user's bubble is solid white
///
/// The web paints it with an indigo gradient (`#5761EB → #4752d9`) and a
/// coloured shadow. Neither survives a port to Zave: colour here only ever
/// names a status, [ZaveColors.blue] is reserved for the XP / upgrade path, and
/// depth is a fill step rather than a shadow. But Zave already has a way to say
/// "this one is the chosen thing" — **selected inverts to solid white with ink
/// text** — and that is precisely what a sent answer is. So the user's bubble
/// is the inversion and the bot's is ordinary glass, which keeps the two lanes
/// as far apart as the web's colours did, in this system's own grammar.
///
/// ## Why it is a full pill
///
/// Zave admits no rounded-rectangle pressable, and the reply chip that becomes
/// this bubble is a pressable. Making the chip a pill and the bubble a rounded
/// rectangle would break the one mechanic this screen is built on — that the
/// draft and the message it becomes are the same box in the same lane — so
/// BOTH are pills. The answers are chip labels and single sentences, which a
/// pill carries without looking stretched.
class ChatMessageRow extends StatelessWidget {
  const ChatMessageRow({
    required this.message,
    required this.grouped,
    super.key,
  });

  final ChatMessage message;

  /// The previous line was from the same speaker. Hides the avatar (replaced by
  /// a spacer so the column does not jump) and drops the eyebrow.
  final bool grouped;

  bool get _isBot => message.role == ChatRole.bot;

  @override
  Widget build(BuildContext context) {
    final Widget bubble = _isBot
        ? _BotBubble(text: message.text)
        : _UserBubble(text: message.text);

    final Widget column = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ChatLaneMetrics.maxBubbleWidth(context),
      ),
      child: Column(
        crossAxisAlignment: _isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          if (_isBot && !grouped) ...<Widget>[
            Text('Plexa'.toUpperCase(), style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.xs),
          ],
          bubble,
          if (message.badge != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            // Green means done. The badge says a thing landed — "Role set",
            // "Saved" — which is the token's exact meaning.
            ZavePill(
              label: message.badge!,
              color: ZaveColors.green,
              leading: const ZaveDot(ZaveColors.green),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.lg),
      child: Row(
        mainAxisAlignment: _isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (_isBot) ...<Widget>[
            grouped ? const _AvatarSpacer() : const PlexaAvatar(),
            SizedBox(width: ZaveSpace.md),
          ],
          Flexible(child: column),
          if (!_isBot) ...<Widget>[
            SizedBox(width: ZaveSpace.md),
            grouped ? const _AvatarSpacer() : const _UserAvatar(),
          ],
        ],
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Text(text, style: ZaveType.body),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.chipPad,
      decoration: ZaveSurface.chipSelected,
      child: Text(text, style: ZaveType.label.copyWith(color: ZaveColors.ink)),
    );
  }
}

/// Plexa's avatar.
///
/// The web draws a two-pixel gradient ring (indigo → cyan → green) with a glow.
/// Zave has neither decorative gradients nor glows, so the mark is the
/// [ZaveGlass.now] step — the "this is the one speaking" surface — with the
/// wordmark's initial in white.
class PlexaAvatar extends StatelessWidget {
  const PlexaAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ChatLaneMetrics.avatar,
      width: ChatLaneMetrics.avatar,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ZaveGlass.now,
        border: Border.all(color: ZaveGlass.nowBorder, width: 1),
        shape: BoxShape.circle,
      ),
      child: Text('P', style: ZaveType.label.copyWith(color: ZaveColors.white)),
    );
  }
}

/// The user's avatar. Glass rather than white: the bubble beside it is already
/// the white surface, and two white discs in one row read as one control.
class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ChatLaneMetrics.avatar,
      width: ChatLaneMetrics.avatar,
      decoration: ZaveSurface.iconButton,
      // 18 is the icon size ZaveIconButton uses inside the same 38px circle.
      child: const Icon(Icons.person_outline, size: 18),
    );
  }
}

/// Holds the avatar's column open on a grouped line, so the bubbles above and
/// below stay on the same edge.
class _AvatarSpacer extends StatelessWidget {
  const _AvatarSpacer();

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: ChatLaneMetrics.avatar, width: ChatLaneMetrics.avatar);
}

/// The typing bubble — three dots in Plexa's own lane.
///
/// Zave ships tokens for exactly this ([ZaveMotion.thinkingDot] and its two
/// opacity bounds are documented as "the thinking dots on AI surfaces"), so the
/// web's `0.8s / delay i*0.18` cadence gives way to the system's own 1.2s
/// cycle. The stagger is kept, because three dots pulsing in unison is a
/// loading spinner and three dots pulsing in sequence is someone typing.
class TypingRow extends StatefulWidget {
  const TypingRow({required this.grouped, super.key});

  final bool grouped;

  @override
  State<TypingRow> createState() => _TypingRowState();
}

class _TypingRowState extends State<TypingRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ZaveMotion.thinkingDot,
  )..repeat();

  static const int _dots = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          widget.grouped ? const _AvatarSpacer() : const PlexaAvatar(),
          SizedBox(width: ZaveSpace.md),
          Container(
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.row,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < _dots; i++) ...<Widget>[
                  // 6px between 6px dots — the web's spacing, and there is no
                  // Zave token at that size.
                  if (i > 0) SizedBox(width: ZaveSpace.xs + 2),
                  _Dot(controller: _controller, index: i),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.controller, required this.index});

  final AnimationController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        // Each dot runs the same cycle a third of a beat behind the last.
        final double phase = (controller.value + index / 3) % 1.0;
        // The web's keyframes: dim at the ends, bright at 40% through.
        final double t = phase < 0.4 ? phase / 0.4 : (1 - phase) / 0.6;
        final double opacity =
            ZaveMotion.thinkingDotMin +
            (ZaveMotion.thinkingDotMax - ZaveMotion.thinkingDotMin) * t;
        return Opacity(opacity: opacity.clamp(0.0, 1.0), child: child);
      },
      child: ZaveDot(ZaveColors.ink62, size: ZaveSpace.sm - 2),
    );
  }
}
