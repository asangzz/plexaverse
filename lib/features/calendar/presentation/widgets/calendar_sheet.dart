import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The chrome every calendar sheet shares: the ground gradient, a top hairline,
/// a grab handle and the Zave gutter.
///
/// The web renders these surfaces two ways — a bottom sheet under `lg` and a
/// right-hand drawer above it. A phone only ever gets the first, so only the
/// first is ported; the drawer form has no meaning here.
///
/// [footer] is pinned below the scrolling body, matching the web's sheets,
/// which keep their one action reachable without scrolling to the end of a long
/// day.
class CalendarSheet extends StatelessWidget {
  const CalendarSheet({
    required this.children,
    this.footer,
    this.maxHeightFactor = 0.85,
    super.key,
  });

  final List<Widget> children;
  final Widget? footer;

  /// The web caps its bottom sheet at `max-h-[85vh]`.
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
      ),
      decoration: BoxDecoration(
        // The sheet sits on the same ground as the app rather than on a
        // one-off surface colour — the web's `#0d0a1f` panel has no Zave
        // counterpart, and inventing one would put a sixth grey in the system.
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: ZaveSpace.md),
            const CalendarSheetHandle(),
            SizedBox(height: ZaveSpace.lg),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  ZaveSpace.gutter,
                  0,
                  ZaveSpace.gutter,
                  ZaveSpace.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
            if (footer != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  ZaveSpace.gutter,
                  0,
                  ZaveSpace.gutter,
                  ZaveSpace.lg,
                ),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

/// The grab handle at the top of a sheet.
///
/// A static rule-coloured pill: 4 tall, 40 wide. Neither figure is a Zave token
/// because the system has none for a drag handle; they are the platform's own
/// convention and the web sheet's own `w-10 h-1`.
class CalendarSheetHandle extends StatelessWidget {
  const CalendarSheetHandle({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 4,
    width: 40,
    decoration: BoxDecoration(
      color: ZaveColors.rule,
      borderRadius: ZaveRadius.pillBr,
    ),
  );
}

/// A sheet's title block — kicker over a heading, with an optional trailing
/// widget on the kicker line.
class CalendarSheetTitle extends StatelessWidget {
  const CalendarSheetTitle({
    required this.kicker,
    required this.title,
    this.trailing,
    super.key,
  });

  final String kicker;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(child: Text(kicker.toUpperCase(), style: ZaveType.kicker)),
          ?trailing,
        ],
      ),
      SizedBox(height: ZaveSpace.sm),
      Text(title, style: ZaveType.h3),
    ],
  );
}
