/// The contest's Zave vocabulary, in one place — a port of the web's
/// `components/contest/ui.tsx`.
///
/// ## Why the contest has its own
///
/// The contest page is drawn on its own navy ground, with a white pill as the
/// one primary action and a coloured dot that always carries its word. Every
/// contest screen — the path, the lesson, each task — shares that, and the
/// second copy of a panel's radius and border is where two screens start to
/// drift a pixel apart. So the pieces live here, once, and the screens are
/// built from them.
///
/// The rules it keeps, from the web's header:
///   • Ground — one glow, top-left, painted once by the page.
///   • Depth — the glass fill step, never a shadow.
///   • Accent — ONE solid white pill per screen. Everything else is a ghost.
///   • Colour — only names a status. Amber is points and "waiting on you".
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/contest_controllers.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';

/// The contest's colours. Each is the web's token, and the Zave one where
/// the two are the same value.
abstract final class ContestColors {
  /// Done, live. `--zv-green`.
  static const Color green = ZaveColors.green;

  /// Green that has to stay legible as text on the dark ground.
  static const Color mint = ZaveColors.mint;

  /// Points, and waiting on someone. `--zv-amber`.
  static const Color amber = ZaveColors.amber;

  /// Kickers and links. `--zv-peri`.
  static const Color peri = ZaveColors.peri;

  /// Letters on a white pill. `--zv-ink`.
  static const Color ink = ZaveColors.ink;

  /// The one failure a contest screen names — a wrong answer, a removed
  /// level. Zave has no red; the web borrows the console's danger for the
  /// dot and a lighter red for the word.
  static const Color wrongDot = Color(0xFFE5484D);
  static const Color wrongText = Color(0xFFFF9592);

  /// The streak's flame.
  static const Color flame = Color(0xFFFF9F5C);

  /// The ground: a navy wash, lit once from the top-left.
  static const Color groundTop = Color(0xFF050A24);
  static const Color groundFoot = Color(0xFF071445);
  static const Color groundGlow = Color(0xFF0D2A9E);

  /// A level's colour by kind: the lesson's blue, LinkedIn's blue, the
  /// planner's green — and the dark slab of a level with nothing to open
  /// (locked, missed, unavailable, removed).
  static const Color lesson = ZaveColors.blue;
  static const Color linkedIn = Color(0xFF0A66C2);
  static const Color plan = Color(0xFF0F8A63);
  static const Color slab = Color(0xFF1A2150);
}

/// The contest's type, where it differs from the app's.
abstract final class ContestType {
  /// Manrope 13 / 700, uppercase, +0.14em, periwinkle. Upper-case the
  /// string yourself — see [ZaveType.kicker].
  static TextStyle get kicker => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.14 * 13.sp,
    color: ContestColors.peri,
  );

  /// The page title — the app's `.h2`.
  static TextStyle get pageTitle => ZaveType.h2;

  /// A section's title: Manrope 24 / 800.
  static TextStyle get sectionTitle => GoogleFonts.manrope(
    fontSize: 24.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.035 * 24.sp,
    height: 1.05,
    color: ZaveColors.white,
  );

  /// A card's own heading — the app's `.h3`.
  static TextStyle get cardTitle => ZaveType.h3;

  /// The paragraph under a title: 17 at 62% white.
  static TextStyle get lead => ZaveType.body.copyWith(
    fontSize: 17.sp,
    height: 1.6,
    color: ZaveColors.ink62,
  );

  /// Supporting text: 14 at 50% white.
  static TextStyle get meta => ZaveType.caption.copyWith(fontSize: 14.sp);
}

/// The contest's ground, painted by the page rather than inherited: a navy
/// wash with one glow at the top-left. The web's `GROUND`.
///
/// Fixed to the screen like the app's own ground: the glow is the page's one
/// light source, and it does not scroll away.
class ContestGround extends StatelessWidget {
  const ContestGround({required this.child, super.key});

  final Widget child;

  static const LinearGradient _wash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ContestColors.groundTop, ContestColors.groundFoot],
  );

  static const RadialGradient _glow = RadialGradient(
    center: Alignment(-0.6, -1.2),
    radius: 1.1,
    colors: <Color>[ContestColors.groundGlow, Color(0x000D2A9E)],
    stops: <double>[0, 0.6],
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: _wash),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: _glow),
        child: child,
      ),
    );
  }
}

/// A panel at rest: radius 22, the glass fill and its hairline. The web's
/// `panel`.
class ContestPanel extends StatelessWidget {
  const ContestPanel({required this.child, this.padding, super.key});

  final Widget child;

  /// Defaults to 20 all round, the web's `p-5`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardMdBr,
      ),
      child: child,
    );
  }
}

/// A tile or a field inside a panel: the nested radius, 18. The web's `tile`.
class ContestTile extends StatelessWidget {
  const ContestTile({required this.child, this.padding, super.key});

  final Widget child;

  /// Defaults to 16 all round.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardSmBr,
      ),
      child: child,
    );
  }
}

/// What a [ContestDot] says about a thing.
enum ContestTone {
  /// Done, in: green dot, mint word.
  live,

  /// Waiting — on the learner or on our team: amber.
  waiting,

  /// Not open, nothing to do: a faint dot, a muted word.
  idle,

  /// Wrong or removed: red.
  wrong,
}

/// The status dot, with its word. The word is not optional — that is why
/// this is a widget and not a colour: a bare dot says nothing to anyone who
/// cannot tell the hues apart. The web's `Dot`.
class ContestDot extends StatelessWidget {
  const ContestDot({required this.tone, required this.label, super.key});

  final ContestTone tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (Color dot, Color text) = switch (tone) {
      ContestTone.live => (ContestColors.green, ContestColors.mint),
      ContestTone.waiting => (ContestColors.amber, ContestColors.amber),
      ContestTone.idle => (ZaveColors.ink35, ZaveColors.ink50),
      ContestTone.wrong => (ContestColors.wrongDot, ContestColors.wrongText),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExcludeSemantics(child: ZaveDot(dot, size: 8.r)),
        SizedBox(width: ZaveSpace.sm),
        Flexible(
          child: Text(
            label,
            style: ZaveType.body.copyWith(fontSize: 14.sp, color: text),
          ),
        ),
      ],
    );
  }
}

/// The kicker over a title, in capitals. The web's `kicker`.
class ContestKicker extends StatelessWidget {
  const ContestKicker(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: ContestType.kicker);
}

/// "+60 XP" with the bolt — what a level pays, as every level's header shows
/// it. Signed with a true minus for a penalty. The web's `XpTag`.
class XpTag extends StatelessWidget {
  const XpTag({required this.points, this.size = 15, super.key});

  final int points;

  /// The figure's size; the bolt follows it.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: contestXp(points),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(AppIcons.bolt, size: (size + 1).sp, color: ContestColors.amber),
          SizedBox(width: 6.w),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: '${signed(points)} '),
                TextSpan(
                  text: 'XP',
                  style: TextStyle(
                    color: ZaveColors.ink50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            style: GoogleFonts.manrope(
              fontSize: size.sp,
              fontWeight: FontWeight.w800,
              color: ContestColors.amber,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// The one primary action on a contest screen: a white pill with ink
/// letters. ONE per screen. The web's `pillPrimary`.
class ContestPrimaryPill extends StatelessWidget {
  const ContestPrimaryPill({
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.busy = false,
    this.expand = false,
    super.key,
  });

  final String label;

  /// Null disables it.
  final VoidCallback? onPressed;
  final IconData? leading;
  final IconData? trailing;

  /// Shows a spinner and takes no taps; the pill keeps its width.
  final bool busy;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      label: label,
      onPressed: onPressed,
      leading: leading,
      trailing: trailing,
      busy: busy,
      expand: expand,
      fill: ZaveColors.white,
      border: null,
      foreground: ContestColors.ink,
      textStyle: GoogleFonts.manrope(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: ContestColors.ink,
      ),
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
    );
  }
}

/// Everything that is not the one primary action: glass, a hairline,
/// near-white letters. The web's `pillGhost`.
class ContestGhostPill extends StatelessWidget {
  const ContestGhostPill({
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.busy = false,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leading;
  final IconData? trailing;
  final bool busy;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      label: label,
      onPressed: onPressed,
      leading: leading,
      trailing: trailing,
      busy: busy,
      expand: expand,
      fill: ZaveGlass.rest,
      border: ZaveGlass.restBorder,
      foreground: ZaveColors.ink85,
      textStyle: GoogleFonts.manrope(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: ZaveColors.ink85,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.onPressed,
    required this.busy,
    required this.expand,
    required this.fill,
    required this.border,
    required this.foreground,
    required this.textStyle,
    required this.padding,
    this.leading,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leading;
  final IconData? trailing;
  final bool busy;
  final bool expand;
  final Color fill;
  final Color? border;
  final Color foreground;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  bool get _enabled => onPressed != null && !busy;

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      label,
      style: textStyle,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
    final double iconSize = (textStyle.fontSize ?? 16) + 2;
    Widget content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (leading != null) ...<Widget>[
          Icon(leading, size: iconSize, color: foreground),
          SizedBox(width: ZaveSpace.sm),
        ],
        Flexible(child: text),
        if (trailing != null) ...<Widget>[
          SizedBox(width: ZaveSpace.sm),
          Icon(trailing, size: iconSize, color: foreground),
        ],
      ],
    );
    if (busy) {
      // The label stays, invisible, so the pill does not collapse to its
      // spinner under the finger that pressed it.
      content = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(opacity: 0, child: content),
          SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          ),
        ],
      );
    }
    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      excludeSemantics: true,
      child: ZavePress(
        enabled: _enabled,
        child: Opacity(
          opacity: onPressed == null ? 0.5 : 1,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? onPressed : null,
              borderRadius: ZaveRadius.pillBr,
              splashColor: foreground.withValues(alpha: 0.08),
              highlightColor: Colors.transparent,
              child: Container(
                width: expand ? double.infinity : null,
                constraints: const BoxConstraints(
                  minHeight: ZaveSpace.minTapTarget,
                ),
                padding: padding,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: ZaveRadius.pillBr,
                  border: border == null ? null : Border.all(color: border!),
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An inline link in periwinkle, Zave's colour for links.
class _TextLink extends StatelessWidget {
  const _TextLink({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = ZaveType.body.copyWith(
      fontSize: 15.sp,
      color: ContestColors.peri,
    );
    return Semantics(
      link: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 15.sp, color: ContestColors.peri),
                SizedBox(width: ZaveSpace.sm),
              ],
              Flexible(child: Text(label, style: style)),
            ],
          ),
        ),
      ),
    );
  }
}

/// A quiet text link in periwinkle for a secondary action — Skip, never the
/// screen's one white pill. Disabled (dimmed) while [onTap] is null.
class ContestTextLink extends StatelessWidget {
  const ContestTextLink({
    required this.label,
    required this.onTap,
    this.fontSize = 14,
    this.colour = ContestColors.peri,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final double fontSize;
  final Color colour;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              widthFactor: 1,
              child: Opacity(
                opacity: enabled ? 1 : 0.6,
                child: Text(
                  label,
                  textAlign: textAlign,
                  style: ZaveType.body.copyWith(
                    fontSize: fontSize.sp,
                    fontWeight: FontWeight.w600,
                    color: colour,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Back to the contest" — every level's way home. The web's `BackToPath`.
class BackToPath extends StatelessWidget {
  const BackToPath({super.key});

  @override
  Widget build(BuildContext context) => _TextLink(
    label: 'Back to the contest',
    icon: AppIcons.back,
    onTap: () => context.go(ZaveRoutes.contest),
  );
}

/// What a locked level shows in place of its form: which level comes first,
/// and the way back. The web's `LockedNotice`.
///
/// [detail] is the path node's own line, "Unlocks after Lesson part 3 of 3"
/// — read from `todayLockProvider`, never composed here.
class LockedNotice extends StatelessWidget {
  const LockedNotice({required this.detail, super.key});

  final String detail;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ContestDot(tone: ContestTone.idle, label: 'Not open yet'),
            SizedBox(height: ZaveSpace.sm),
            Text(
              '$detail. Levels open one after another — finish or skip it first.',
              style: ZaveType.body.copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: ZaveSpace.xs),
            _TextLink(
              label: 'Back to the path',
              onTap: () => context.go(ZaveRoutes.contest),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where a finished level sends the learner: "Next: Comment on a top voice
/// →", the next open level on today's path, or "Back to the path" when nothing else is
/// open today. The web's `NextLevelButton` — the screen's one white pill.
class NextLevelPill extends ConsumerWidget {
  const NextLevelPill({required this.from, this.expand = false, super.key});

  /// The kind of the level just finished. While the path still shows it as
  /// the current one, the pill leads back to the path.
  final PathNodeKind from;
  final bool expand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NextLevel next = nextOpenLevel(
      ref.watch(contestPathProvider).value,
      from,
    );
    return ContestPrimaryPill(
      label: next.label,
      trailing: AppIcons.forward,
      expand: expand,
      onPressed: () => context.go(next.route),
    );
  }
}

/// The glyph a level kind is drawn with, the same on its node, its card and
/// its task's header: the lesson a star, LinkedIn's levels by what they ask
/// for, the week's plan a sparkle.
IconData contestKindIcon(PathNodeKind kind) => switch (kind) {
  PathNodeKind.lesson => AppIcons.star,
  PathNodeKind.connectLeaders => AppIcons.linkedInIn,
  PathNodeKind.comment => AppIcons.comment,
  PathNodeKind.feedComments => AppIcons.forum,
  PathNodeKind.weeklyInvites => AppIcons.camera,
  PathNodeKind.planWeek => AppIcons.sparkle,
  PathNodeKind.article => AppIcons.article,
  PathNodeKind.video => AppIcons.play,
  PathNodeKind.unknown => AppIcons.lock,
};
