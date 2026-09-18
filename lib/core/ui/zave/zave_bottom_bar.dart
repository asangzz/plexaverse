import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// One entry in the bottom bar.
class ZaveBarItem {
  const ZaveBarItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

/// The Zave bottom navigation bar.
///
/// ## How this is faithful to a design that has no bottom bar
///
/// The web has a desktop sidebar, so there is no bottom bar to copy pixel for
/// pixel. What carries over is the *language*, and the selection rule is the
/// load-bearing part: in Zave, **selected inverts to solid white with ink
/// letters** (`.navItemOn`, `.chipOn`). So the active tab gets a white pill
/// behind its icon and an ink glyph, exactly like an active sidebar item — not
/// a tinted icon, not an underline, and not a coloured indicator.
///
/// The surface itself reuses the sticky-header recipe (midnight at 78% over an
/// 18px backdrop blur with a single hairline), flipped to a top border.
///
/// The centre compose button is separate — see [ZaveComposeButton]. "Write" is
/// the product's primary action, and Zave reserves solid white for the one
/// primary action on a screen, so it is a button rather than a fifth tab.
class ZaveBottomBar extends StatelessWidget {
  const ZaveBottomBar({
    required this.items,
    required this.currentRoute,
    required this.onSelect,
    this.compose,
    super.key,
  });

  final List<ZaveBarItem> items;
  final String currentRoute;
  final ValueChanged<String> onSelect;

  /// The centre compose button, inserted at the midpoint of [items]. With an
  /// even item count this yields the familiar 2 · action · 2 layout.
  final Widget? compose;

  static const double _height = 64;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    final List<Widget> children = <Widget>[];
    final int mid = items.length ~/ 2;
    for (int i = 0; i < items.length; i++) {
      if (compose != null && i == mid) {
        children.add(SizedBox(width: ZaveSpace.xxl + ZaveSpace.lg));
      }
      final ZaveBarItem item = items[i];
      children.add(
        Expanded(
          child: _ZaveTab(
            item: item,
            selected: currentRoute == item.route,
            onTap: () => onSelect(item.route),
          ),
        ),
      );
    }

    final Widget bar = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ZaveSurface.headerBlurSigma,
          sigmaY: ZaveSurface.headerBlurSigma,
        ),
        child: Container(
          height: _height + bottomInset,
          padding: EdgeInsets.only(bottom: bottomInset),
          decoration: BoxDecoration(
            color: ZaveGlass.headerFill,
            border: const Border(
              top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
            ),
          ),
          child: Row(children: children),
        ),
      ),
    );

    if (compose == null) return bar;

    // The compose button overhangs the bar's top edge, so the stack must not
    // clip it.
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: <Widget>[
        bar,
        Positioned(top: -18, child: compose!),
      ],
    );
  }
}

class _ZaveTab extends StatelessWidget {
  const _ZaveTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ZaveBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: ZavePress(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: ZaveMotion.fast,
                curve: ZaveMotion.curve,
                padding: EdgeInsets.symmetric(
                  horizontal: ZaveSpace.lg,
                  vertical: ZaveSpace.xs,
                ),
                decoration: BoxDecoration(
                  color: selected ? ZaveColors.white : Colors.transparent,
                  borderRadius: ZaveRadius.pillBr,
                ),
                child: Icon(
                  item.icon,
                  size: 22,
                  color: selected ? ZaveColors.ink : ZaveColors.ink62,
                ),
              ),
              SizedBox(height: ZaveSpace.xs),
              Text(
                item.label,
                style: ZaveType.navLabel.copyWith(
                  fontSize: 11,
                  color: selected ? ZaveColors.white : ZaveColors.ink50,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The centre compose button — solid white, the one primary action in the app
/// shell. Mirrors the web's "Write" nav item.
class ZaveComposeButton extends StatelessWidget {
  const ZaveComposeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  static const double _size = 56;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Write',
      child: ZavePress(
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: _size,
              width: _size,
              decoration: const BoxDecoration(
                color: ZaveColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: ZaveColors.ink,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
