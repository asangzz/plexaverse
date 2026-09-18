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

  @override
  Widget build(BuildContext context) {
    final bool hasHeader =
        title != null || leading != null || (actions?.isNotEmpty ?? false);

    return ZaveGroundBox(
      glow: glow,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: hasHeader ? _ZaveHeader(
          title: title,
          leading: leading,
          actions: actions,
        ) : null,
        body: SafeArea(top: !hasHeader, bottom: safeBottom, child: body),
        bottomNavigationBar: bottomBar,
        floatingActionButton: floatingAction,
      ),
    );
  }
}

/// The sticky header: midnight at 78% over an 18px backdrop blur (sigma 9),
/// with a single bottom hairline.
class _ZaveHeader extends StatelessWidget implements PreferredSizeWidget {
  const _ZaveHeader({this.title, this.leading, this.actions});

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  static const double _height = 56;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

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
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          height: _height + MediaQuery.paddingOf(context).top,
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
