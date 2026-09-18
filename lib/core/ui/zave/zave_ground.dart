import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';

/// The app ground — the gradient every signed-in Zave screen sits on.
///
/// Reproduces `.root` from the web's `zave.module.css`: a midnight→deep
/// vertical wash with **one** blue glow at the top-left.
///
/// The glow appears exactly once, anchored to the top of the screen, and does
/// NOT scroll with the content. That is deliberate: a single fixed light source
/// is what gives the page a top. Repeating it down a scroll view (or letting it
/// scroll away) loses the effect entirely.
class ZaveGroundBox extends StatelessWidget {
  const ZaveGroundBox({required this.child, this.glow = true, super.key});

  final Widget child;

  /// Draw the top-left glow. Turn it off for a surface that is already inside
  /// another [ZaveGroundBox] — two glows is one too many.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: ZaveGround.base),
      child: glow
          ? DecoratedBox(
              decoration: const BoxDecoration(gradient: ZaveGround.glow),
              child: child,
            )
          : child,
    );
  }
}

/// A Zave screen scaffold: the ground, a sticky blurred header, and a body.
///
/// Use this instead of a bare [Scaffold] on every signed-in screen — it is what
/// makes the app read as one surface rather than a stack of separately-styled
/// pages.
class ZaveScaffold extends StatelessWidget {
  const ZaveScaffold({
    required this.body,
    this.title,
    this.leading,
    this.actions,
    this.bottomBar,
    this.floatingAction,
    this.glow = true,
    this.safeBottom = true,
    super.key,
  });

  final Widget body;

  /// Rendered as `.h3` in the sticky header. Omit for a screen that supplies
  /// its own large [ZaveType.h2] title inside the scroll view — a screen should
  /// not carry both.
  final String? title;

  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final Widget? floatingAction;
  final bool glow;
  final bool safeBottom;

  /// The top inset a scrolling body must leave clear of the sticky header.
  ///
  /// [ZaveScaffold] extends its body BEHIND the header so content scrolls
  /// under the blur, exactly as the web's sticky header does. Flutter puts the
  /// header's height into the body's `MediaQuery.padding.top` for that reason —
  /// but a [ListView] given an explicit `padding:` discards it, and the first
  /// item renders under the header.
  ///
  /// So a scrolling body inside a [ZaveScaffold] must start its padding here:
  ///
  /// ```dart
  /// ListView(
  ///   padding: EdgeInsets.fromLTRB(
  ///     ZaveSpace.gutter,
  ///     ZaveScaffold.contentTop(context) + ZaveSpace.xl,
  ///     ZaveSpace.gutter,
  ///     ZaveSpace.section,
  ///   ),
  /// ```
  static double contentTop(BuildContext context) {
    final _ZaveContentInset? inset = context
        .dependOnInheritedWidgetOfExactType<_ZaveContentInset>();
    // No ZaveScaffold header above us (a bare screen, a sheet, a test) — the
    // status bar is then the only thing to clear.
    return inset?.top ?? MediaQuery.paddingOf(context).top;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasHeader =
        title != null || leading != null || (actions?.isNotEmpty ?? false);
    final double topInset = MediaQuery.paddingOf(context).top;

    return ZaveGroundBox(
      glow: glow,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: hasHeader
            ? _ZaveHeader(
                title: title,
                leading: leading,
                actions: actions,
                // The header draws its own status-bar padding, so its
                // preferredSize must include that inset — otherwise Scaffold
                // under-reports the header height, puts too little into the
                // body's MediaQuery padding, and the first line of content
                // renders clipped underneath it.
                topInset: topInset,
              )
            : null,
        body: _ZaveContentInset(
          // The exact height ZaveScaffold just built its header at, published
          // so a scrolling body can clear it. Derived here rather than read
          // back from MediaQuery: Scaffold's own inset bookkeeping does not
          // survive the SafeArea below, and a screen silently rendering its
          // title under the header is not a failure anyone notices in review.
          // With a header the body extends BEHIND it (SafeArea top is off), so
          // content must clear the header AND the status bar. Without one,
          // SafeArea(top: true) already consumes the status bar, so the inset
          // is zero — publishing it again double-padded every headerless
          // screen by the notch height.
          top: hasHeader ? _ZaveHeader._height + topInset : 0,
          child: SafeArea(top: !hasHeader, bottom: safeBottom, child: body),
        ),
        bottomNavigationBar: bottomBar,
        floatingActionButton: floatingAction,
      ),
    );
  }
}

/// The sticky header: midnight at 78% over an 18px backdrop blur (sigma 9),
/// with a single bottom hairline.
class _ZaveHeader extends StatelessWidget implements PreferredSizeWidget {
  const _ZaveHeader({
    required this.topInset,
    this.title,
    this.leading,
    this.actions,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  /// The status-bar inset this header paints over and must account for.
  final double topInset;

  static const double _height = 56;

  @override
  Size get preferredSize => Size.fromHeight(_height + topInset);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ZaveSurface.headerBlurSigma,
          sigmaY: ZaveSurface.headerBlurSigma,
        ),
        child: Container(
          decoration: ZaveSurface.header,
          padding: EdgeInsets.only(top: topInset),
          height: _height + topInset,
          child: Row(
            children: <Widget>[
              SizedBox(width: ZaveSpace.gutter),
              if (leading != null) ...<Widget>[
                leading!,
                SizedBox(width: ZaveSpace.md),
              ],
              Expanded(
                child: title == null
                    ? const SizedBox.shrink()
                    : Text(
                        title!,
                        style: ZaveType.h3,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              ...?actions,
              SizedBox(width: ZaveSpace.gutter),
            ],
          ),
        ),
      ),
    );
  }
}


/// Carries the height of the [ZaveScaffold] header above a body, so a
/// scrolling child can clear it. Read via [ZaveScaffold.contentTop].
class _ZaveContentInset extends InheritedWidget {
  const _ZaveContentInset({required this.top, required super.child});

  final double top;

  @override
  bool updateShouldNotify(_ZaveContentInset oldWidget) => oldWidget.top != top;
}

/// The standard scrolling body for a [ZaveScaffold].
///
/// Use this instead of a bare [ListView]. It applies the Zave side gutter, the
/// bottom section space, and — the part that is easy to get wrong — the exact
/// top inset needed to clear the sticky header.
///
/// That inset cannot be applied by the screen itself without care: a screen
/// calling [ZaveScaffold.contentTop] from its own `build` passes a context
/// ABOVE the scaffold, where the inset is not in scope, and silently gets the
/// status-bar height instead. Its title then renders underneath the header.
/// This widget is built below the scaffold, so it reads the real value.
class ZaveScrollView extends StatelessWidget {
  const ZaveScrollView({
    required this.children,
    this.controller,
    this.gutter = true,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  /// Apply the side gutter. Turn it off for a full-bleed body that pads its
  /// own rows (a list of edge-to-edge cards).
  final bool gutter;

  @override
  Widget build(BuildContext context) {
    final double side = gutter ? ZaveSpace.gutter : 0;
    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(
        side,
        ZaveScaffold.contentTop(context) + ZaveSpace.xl,
        side,
        ZaveSpace.section,
      ),
      children: children,
    );
  }
}
