import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/zave/zave.dart';
import 'zave_button.dart';

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
    // Three fixed layers, cheapest first: the vertical wash, the cool fill
    // light at the bottom-right, then the violet key at the top-left. The key
    // goes on last so it sits over the fill where the two overlap — a fill
    // light painted on top of a key is how you get a flat, milky middle.
    //
    // All three are plain gradients on DecoratedBoxes: no blur, no shader
    // layers, nothing that repaints on scroll. The ground is behind every
    // screen in the app, so it has to be free.
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: ZaveGround.base),
      child: glow
          ? DecoratedBox(
              decoration: const BoxDecoration(gradient: ZaveGround.counter),
              child: DecoratedBox(
                decoration: const BoxDecoration(gradient: ZaveGround.bloom),
                child: DecoratedBox(
                  // Last, so it darkens the corners of both lights rather
                  // than being lit back up by them.
                  decoration: const BoxDecoration(
                    gradient: ZaveGround.vignette,
                  ),
                  child: child,
                ),
              ),
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
    this.largeTitle,
    this.subtitle,
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

  /// The EXPANDED header: a large `.h2` title, and an optional `.lead` under
  /// it, both living in the bar rather than at the top of the body.
  ///
  /// Use this instead of starting the scroll view with an h2. A screen that
  /// did that and passed no [title] produced a header holding nothing but a
  /// back arrow, with its real title floating underneath — an empty strip
  /// above the thing the strip was supposed to name.
  ///
  /// Mutually exclusive with [title], which is the compact variant: one line
  /// of `.h3` beside the back button. Most screens want that one. Reach for
  /// this where the title IS the top of the page.
  final String? largeTitle;

  /// Sits under [largeTitle]. Ignored without one.
  final String? subtitle;

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
    // A back control, on every screen that has somewhere to go back to.
    //
    // ## Why this is here and not on each page
    //
    // iOS has no system back button, and these routes have no edge-swipe
    // either: `_fullScreen` builds a `CupertinoPage` now precisely so that
    // gesture exists, but a gesture is not a visible affordance and plenty of
    // people never learn it. Of the 22 pushed screens, NINE had no way back at
    // all — Settings, Accounts, Schedules, Studio, Festive and the four
    // company screens. You could reach them and then you were stuck.
    //
    // Doing it per page is what produced that: a page only got a back button
    // if its author remembered, and `hasHeader` is false unless a page passes
    // a title, a leading or actions — so a screen that draws its own big h2
    // inside the scroll view got no header, and therefore nowhere to put one.
    //
    // `canPop` is the whole condition, and it is the right one: the four shell
    // branches sit at the root of their navigator and answer false, so Home,
    // Plan, Calendar and Posts do not sprout a back arrow. Anything pushed
    // over them answers true. A page that wants something else in that slot
    // still passes its own `leading` and keeps it.
    final bool canPop = Navigator.of(context).canPop();
    final Widget? effectiveLeading =
        leading ??
        (canPop
            ? ZaveIconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null);

    assert(
      title == null || largeTitle == null,
      'Pass title OR largeTitle, not both — they are two renderings of the '
      'same thing and a screen never wears two titles.',
    );

    final bool hasHeader =
        title != null ||
        largeTitle != null ||
        effectiveLeading != null ||
        (actions?.isNotEmpty ?? false);
    final double topInset = MediaQuery.paddingOf(context).top;

    return ZaveGroundBox(
      glow: glow,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: hasHeader
            ? _ZaveHeader(
                title: title,
                largeTitle: largeTitle,
                subtitle: subtitle,
                leading: effectiveLeading,
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
    this.largeTitle,
    this.subtitle,
    this.leading,
    this.actions,
  });

  final String? title;
  final String? largeTitle;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;

  /// The status-bar inset this header paints over and must account for.
  final double topInset;

  /// The control row — back button, actions, and the compact title.
  static const double _height = 56;

  /// The expanded block under that row: the `.h2`, and the `.lead` if there is
  /// one.
  ///
  /// Computed from the type scale rather than eyeballed, and capped at one
  /// line each, because `preferredSize` has to be known before anything is
  /// laid out: a title that wrapped past this would be clipped by the
  /// Scaffold rather than growing the bar. Short titles are the rule here —
  /// "Settings", "Accounts", "Your Persona" — and a screen whose title cannot
  /// fit one line wants the compact [title] instead.
  double get _expandedBlock {
    if (largeTitle == null) return 0;
    final double titleLine = ZaveType.h2.fontSize! * 1.05;
    final double subLine = subtitle == null
        ? 0
        : ZaveType.lead.fontSize! * 1.6 + ZaveSpace.xs;
    return ZaveSpace.sm + titleLine + subLine + ZaveSpace.lg;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(_height + _expandedBlock + topInset);

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
          height: _height + _expandedBlock + topInset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expanded, not a fixed 56: the Scaffold can hand this box a
              // pixel less than `preferredSize` asked for (rounding, or a
              // test harness with no status-bar inset), and a rigid row then
              // overflows the Column by that pixel. Letting the row take
              // whatever is left after the title block absorbs the difference
              // and keeps the measured constant honest.
              Expanded(
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
              if (largeTitle != null) ...<Widget>[
                SizedBox(height: ZaveSpace.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ZaveSpace.gutter),
                  child: Text(
                    largeTitle!,
                    style: ZaveType.h2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  SizedBox(height: ZaveSpace.xs),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ZaveSpace.gutter),
                    child: Text(
                      subtitle!,
                      style: ZaveType.lead,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
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
