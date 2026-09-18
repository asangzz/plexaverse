import 'package:flutter/material.dart';

import '../../router/zave_destinations.dart';
import '../../theme/zave/zave.dart';
import 'zave_press.dart';

/// The "More" sheet — every navigable destination that did not fit the bottom
/// bar, still grouped and ordered exactly as the web sidebar groups them.
///
/// This is the other half of the bottom bar: together they must cover the whole
/// visible nav tree, so a user never loses access to something the web offers
/// them. Rows use the `.navItem` recipe, and the group headers use `.kicker`.
class ZaveMoreSheet extends StatelessWidget {
  const ZaveMoreSheet({
    required this.destinations,
    required this.currentRoute,
    required this.onSelect,
    this.footer,
    super.key,
  });

  final List<ZaveDestination> destinations;
  final String currentRoute;
  final ValueChanged<String> onSelect;

  /// Sign-out and the app version — the web sidebar's footer block.
  final Widget? footer;

  /// Opens the sheet. Returns the chosen route, or null if dismissed.
  static Future<String?> show(
    BuildContext context, {
    required List<ZaveDestination> destinations,
    required String currentRoute,
    Widget? footer,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => ZaveMoreSheet(
        destinations: destinations,
        currentRoute: currentRoute,
        footer: footer,
        onSelect: (String route) => Navigator.of(ctx).pop(route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Preserve the web's group order without sorting: walk the list and start a
    // new section whenever the group label changes.
    final List<Widget> children = <Widget>[];
    String group = '';
    for (final ZaveDestination d in destinations) {
      if (d.group != group) {
        group = d.group;
        children
          ..add(SizedBox(height: ZaveSpace.xl))
          ..add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ZaveSpace.sm),
              child: Text(group.toUpperCase(), style: ZaveType.kicker),
            ),
          )
          ..add(SizedBox(height: ZaveSpace.md));
      }
      children.add(
        _MoreRow(
          destination: d,
          selected: d.route == currentRoute,
          onTap: () => onSelect(d.route),
        ),
      );
      children.add(SizedBox(height: ZaveSpace.xs));
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            ZaveSpace.gutter,
            ZaveSpace.md,
            ZaveSpace.gutter,
            ZaveSpace.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Grab handle.
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ZaveColors.rule,
                    borderRadius: ZaveRadius.pillBr,
                  ),
                ),
              ),
              ...children,
              if (footer != null) ...<Widget>[
                SizedBox(height: ZaveSpace.xl),
                Container(height: 1, color: ZaveColors.rule),
                SizedBox(height: ZaveSpace.lg),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `.navItem` — active inverts to solid white with ink letters.
class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final ZaveDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? ZaveColors.ink : ZaveColors.ink62;

    return Semantics(
      button: true,
      selected: selected,
      child: ZavePress(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            padding: ZaveSpace.navItemPad,
            constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
            decoration: selected
                ? ZaveSurface.navItemSelected
                : ZaveSurface.navItem,
            child: Row(
              children: <Widget>[
                Icon(destination.icon, size: 20, color: fg),
                SizedBox(width: ZaveSpace.navItemGap),
                Expanded(
                  child: Text(
                    destination.label,
                    style: ZaveType.navLabel.copyWith(color: fg),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
