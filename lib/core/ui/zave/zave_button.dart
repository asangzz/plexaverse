import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// Which of Zave's four button roles this is.
///
/// The roles are not sizes and they are not interchangeable. Each one encodes a
/// rule from the web design system, and the rules are the point:
enum ZaveButtonKind {
  /// Solid white, ink letters. **Reserved for the ONE primary action on a
  /// screen.** If a screen has two white buttons, one of them is wrong.
  primary,

  /// [primary]'s compact size — same meaning, same one-per-screen rule.
  primarySmall,

  /// Glass. The default for everything that is not the primary action.
  ghost,

  /// Solid [ZaveColors.blue]. **Only for the XP / upgrade path.** Blue is a
  /// status in this system, so a blue button that does not lead to XP or
  /// billing is a miscolour, not a style choice.
  brand,
}

/// A Zave button.
///
/// Always a full pill — there is no rounded-rectangle variant, at any size.
class ZaveButton extends StatelessWidget {
  const ZaveButton({
    required this.label,
    required this.onPressed,
    this.kind = ZaveButtonKind.ghost,
    this.icon,
    this.trailing,
    this.expand = false,
    this.busy = false,
    super.key,
  });

  /// Convenience constructor for the one primary action on a screen.
  const ZaveButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
    this.expand = false,
    this.busy = false,
    super.key,
  }) : kind = ZaveButtonKind.primary;

  /// Convenience constructor for the XP / upgrade path.
  const ZaveButton.brand({
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
    this.expand = false,
    this.busy = false,
    super.key,
  }) : kind = ZaveButtonKind.brand;

  final String label;

  /// `null` disables the button (and, with [busy], is how you block a
  /// double-submit).
  final VoidCallback? onPressed;

  final ZaveButtonKind kind;
  final Widget? icon;
  final Widget? trailing;

  /// Stretch to the available width. A phone's primary action usually should.
  final bool expand;

  /// Swap the label for a spinner. The button keeps its measured width so the
  /// layout does not jump when it flips.
  final bool busy;

  bool get _enabled => onPressed != null && !busy;

  @override
  Widget build(BuildContext context) {
    final (BoxDecoration deco, TextStyle style, EdgeInsets pad) = switch (kind) {
      ZaveButtonKind.primary => (
        BoxDecoration(
          color: ZaveColors.white,
          borderRadius: ZaveRadius.pillBr,
        ),
        ZaveType.buttonLarge,
        ZaveSpace.btnPrimaryPad,
      ),
      ZaveButtonKind.primarySmall => (
        BoxDecoration(
          color: ZaveColors.white,
          borderRadius: ZaveRadius.pillBr,
        ),
        ZaveType.button.copyWith(color: ZaveColors.ink),
        ZaveSpace.btnPrimarySmPad,
      ),
      ZaveButtonKind.ghost => (
        BoxDecoration(
          color: ZaveGlass.ghostFill,
          border: Border.all(color: ZaveGlass.hoverBorder, width: 1),
          borderRadius: ZaveRadius.pillBr,
        ),
        ZaveType.button.copyWith(color: ZaveColors.white),
        ZaveSpace.btnGhostPad,
      ),
      ZaveButtonKind.brand => (
        BoxDecoration(
          color: ZaveColors.blue,
          borderRadius: ZaveRadius.pillBr,
        ),
        ZaveType.buttonBrand,
        ZaveSpace.btnBrandPad,
      ),
    };

    final Color fg = style.color ?? ZaveColors.white;

    Widget content = busy
        ? SizedBox(
            height: (style.fontSize ?? 16) + 4,
            width: (style.fontSize ?? 16) + 4,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Text(
            label,
            style: style,
            textAlign: TextAlign.center,
            // A pill never wraps. Without this, a button squeezed by a Row
            // wraps its label one character per line rather than shrinking,
            // because the Flexible below hands it an arbitrarily narrow box.
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          );

    if (icon != null || trailing != null) {
      content = Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            IconTheme.merge(
              data: IconThemeData(color: fg, size: 20),
              child: icon!,
            ),
            SizedBox(width: ZaveSpace.sm + 2), // CSS gap: 10px
          ],
          Flexible(child: content),
          if (trailing != null) ...<Widget>[
            SizedBox(width: ZaveSpace.sm + 2),
            IconTheme.merge(
              data: IconThemeData(color: fg, size: 20),
              child: trailing!,
            ),
          ],
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: ZavePress(
        enabled: _enabled,
        child: Opacity(
          // `.btnPrimary:disabled { opacity: 0.5 }` — keyed to onPressed, NOT
          // to _enabled. A busy button is not taking taps, but it is working,
          // and dimming it to 50% made its spinner nearly invisible.
          opacity: onPressed == null ? 0.5 : 1,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? onPressed : null,
              borderRadius: ZaveRadius.pillBr,
              splashColor: fg.withValues(alpha: 0.08),
              highlightColor: Colors.transparent,
              child: Container(
                decoration: deco,
                padding: pad,
                constraints: BoxConstraints(
                  minHeight: ZaveSpace.minTapTarget,
                ),
                width: expand ? double.infinity : null,
                alignment: Alignment.center,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.iconBtn` — a 38px glass circle.
///
/// 38px is below Material's 48px minimum tap target, so the visual stays 38 and
/// the widget pads itself out to [ZaveSpace.minTapTarget]. Shrinking the target
/// to match the web's pixel size would make it genuinely hard to hit.
class ZaveIconButton extends StatelessWidget {
  const ZaveIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Widget button = ZavePress(
      enabled: onPressed != null,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: ZaveSpace.iconBtn,
            width: ZaveSpace.iconBtn,
            decoration: ZaveSurface.iconButton,
            child: IconTheme.merge(
              data: const IconThemeData(color: ZaveColors.white, size: 18),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      label: tooltip,
      child: SizedBox(
        height: ZaveSpace.minTapTarget,
        width: ZaveSpace.minTapTarget,
        child: Center(child: button),
      ),
    );
  }
}
