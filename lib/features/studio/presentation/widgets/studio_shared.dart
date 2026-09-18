import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// Chrome shared by every Studio bottom sheet.
///
/// The phone's stand-in for the web editor's two 280px floating side panels,
/// which cannot coexist on a 375px viewport (280 + 280 + 32 = 592). One sheet
/// at a time, opened from the header, is the honest translation.
class StudioSheet extends StatelessWidget {
  const StudioSheet({
    required this.children,
    this.padBottomInset = false,
    super.key,
  });

  final List<Widget> children;

  /// Adds the keyboard inset. Set it on a sheet that contains a text field —
  /// without it the composer sits underneath the keyboard.
  final bool padBottomInset;

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: EdgeInsets.only(
            bottom: padBottomInset
                ? MediaQuery.viewInsetsOf(context).bottom
                : 0,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ZaveSpace.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Center(child: _Grabber()),
                SizedBox(height: ZaveSpace.xl),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) => Container(
    height: ZaveSpace.xs,
    width: ZaveSpace.xxl + ZaveSpace.sm,
    decoration: BoxDecoration(
      color: ZaveColors.rule,
      borderRadius: ZaveRadius.pillBr,
    ),
  );
}

/// A resting glass block used while something loads.
///
/// Zave has no shimmer: depth is a fill step and nothing in this system
/// animates for decoration. A skeleton is simply the surface the content will
/// arrive on, at the size it will take.
class StudioSkeleton extends StatelessWidget {
  const StudioSkeleton({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}

/// The one card this slice uses for every "nothing here / it failed / it is
/// not available" state.
///
/// One widget rather than three because the three differ only in their words:
/// the dot colour names the status (amber waits, ink-35 is inert) and the
/// optional action is the only control. Zave has no red, so a failure is
/// amber — it needs attention, it is not destructive.
class StudioNotice extends StatelessWidget {
  const StudioNotice({
    required this.kicker,
    required this.title,
    this.body,
    this.dotColor = ZaveColors.ink35,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String kicker;
  final String title;
  final String? body;
  final Color dotColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// A failure. Amber, because Zave has no red.
  const StudioNotice.failure({
    required this.title,
    this.body,
    this.actionLabel = 'Try again',
    required this.onAction,
    super.key,
  }) : kicker = 'COULD NOT LOAD',
       dotColor = ZaveColors.amber;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZaveDot(dotColor),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text(kicker.toUpperCase(), style: ZaveType.kicker)),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(title, style: ZaveType.h3),
        if (body != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(body!, style: ZaveType.bodyMuted),
        ],
        if (actionLabel != null && onAction != null) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    ),
  );
}

/// States, in plain words, that a control cannot work yet and why.
///
/// Used where a screen's surface is genuinely built but the endpoint or the
/// platform capability behind it does not exist on mobile. The precedent is
/// the settings slice, which renders a disabled switch with an honest note
/// rather than a control that silently swallows a 404 — a dead control that
/// LOOKS live is the failure mode this exists to prevent.
class StudioUnavailable extends StatelessWidget {
  const StudioUnavailable({
    required this.title,
    required this.reason,
    this.detail,
    super.key,
  });

  final String title;

  /// What is missing, named exactly — an endpoint path, or a capability.
  final String reason;

  /// What the user can do instead, when there is something.
  final String? detail;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Amber: waiting on something, not broken and not destructive.
            const ZaveDot(ZaveColors.amber),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text('NOT AVAILABLE YET', style: ZaveType.kicker)),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Text(title, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.md),
        Text(reason, style: ZaveType.bodyMuted),
        if (detail != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(detail!, style: ZaveType.caption),
        ],
      ],
    ),
  );
}
