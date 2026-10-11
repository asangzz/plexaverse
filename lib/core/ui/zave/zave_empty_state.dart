import 'package:flutter/widgets.dart';

import '../../theme/zave/zave.dart';
import '../app_icons.dart';
import 'zave_card.dart';

/// How much room the state has to fill.
enum ZaveEmptyLayout {
  /// Left-aligned inside a card, in the flow of a page. The dominant shape:
  /// a dot, a kicker, a heading, and usually a line under it.
  card,

  /// Centred in whatever space it is given, led by a large muted glyph. For
  /// a whole pane with nothing in it — an empty drawer, an empty tab — where
  /// a small card marooned at the top reads as a loading failure.
  pane,
}

/// "There is nothing here, and that is not a problem."
///
/// ## Why this exists
///
/// Ten screens wrote their own. They had converged on roughly the same shape
/// — a [ZaveCard] holding a [ZaveDot] in [ZaveColors.ink35], an uppercase
/// kicker, an [ZaveType.h3] heading and sometimes a muted line — but every
/// one of them had drifted somewhere: the kicker was "NOTHING HERE" in three
/// places, "NOTHING HERE YET" in two and absent in the rest; some took an
/// action as a `Widget`, some as a label plus a callback; two were still
/// Material, centred, with `scheme.onSurface.withValues(alpha: 0.2)` and the
/// old `AppSpacing`; and two were a bare sentence in a card with none of it.
///
/// None of that is visible one screen at a time. It is very visible moving
/// between them, which is what a user does.
///
/// ## The inert dot
///
/// [ZaveColors.ink35], never amber. Zave spends amber on "this needs you",
/// and an empty list does not: nothing has gone wrong, there is simply
/// nothing yet. An empty state that looks like a warning teaches the user to
/// distrust the warnings.
///
/// ## [boxed]
///
/// False when the caller already supplies the card. Settings does — its
/// sections wrap their child in a [ZaveCard] — and a component that drew its
/// own would nest a bordered card inside a bordered card, which is a defect
/// this codebase has already shipped once.
class ZaveEmptyState extends StatelessWidget {
  const ZaveEmptyState({
    required this.title,
    this.kicker = 'NOTHING HERE',
    this.body,
    this.action,
    this.icon,
    this.dotColor = ZaveColors.ink35,
    this.layout = ZaveEmptyLayout.card,
    this.boxed = true,
    this.size = ZaveCardSize.medium,
    this.padding,
    super.key,
  });

  /// The line that says what is missing. Sentence case, [ZaveType.h3].
  final String title;

  /// The uppercase label beside the dot. Overridable because "ALL CAUGHT UP"
  /// and "NOTHING HERE" are not the same news, and the difference between an
  /// inbox you have cleared and a list you have never filled is worth a word.
  ///
  /// **Null omits the dot and the kicker row entirely.** For a tight sheet
  /// that already carries a kicker of its own: the calendar day sheet opens
  /// with `CalendarSheetTitle(kicker: 'Pick a post')`, and a second uppercase
  /// label four rows under the first reads as a nested section rather than as
  /// one empty list.
  ///
  /// Ignored by [ZaveEmptyLayout.pane], which leads with [icon] instead.
  final String? kicker;

  /// The muted line under the title, where there is more to say.
  final String? body;

  /// Usually a [ZaveButton]. A `Widget` rather than a label and a callback so
  /// a caller can pass two buttons, a row, or a link — three of the old
  /// states needed one of those and had to be a separate class to get it.
  final Widget? action;

  /// Leads [ZaveEmptyLayout.pane]. Defaults to [AppIcons.empty].
  final IconData? icon;

  /// The dot's colour. [ZaveColors.ink35] — inert — for almost every caller,
  /// and the default for the reason in the class doc.
  ///
  /// [ZaveColors.green] is the one other defensible value: a list that is
  /// empty because the user CLEARED it is a success, not an absence. "All
  /// caught up, no drafts or missed approvals" is news worth a green dot.
  /// Amber still never belongs here — an empty state that looks like a
  /// warning teaches the user to distrust the warnings.
  final Color dotColor;

  final ZaveEmptyLayout layout;

  /// Draw the surrounding [ZaveCard]. See the class doc.
  final bool boxed;

  /// Forwarded to the [ZaveCard] when [boxed]. A gallery's empty state sits
  /// where a large card was and keeps its radius.
  final ZaveCardSize size;

  /// Forwarded to the [ZaveCard] when [boxed]. Null keeps the card's own.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => switch (layout) {
    ZaveEmptyLayout.card => _boxed(_card()),
    ZaveEmptyLayout.pane => _pane(),
  };

  Widget _boxed(Widget child) => boxed ? ZaveCard(child: child) : child;

  Widget _card() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      if (kicker case final String label) ...<Widget>[
        Row(
          children: <Widget>[
            // Inert, not waiting. See [dotColor].
            ZaveDot(dotColor),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: Text(
                label,
                style: ZaveType.kicker,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
      ],
      Text(title, style: ZaveType.h3),
      if (body case final String text) ...<Widget>[
        SizedBox(height: ZaveSpace.md),
        Text(text, style: ZaveType.bodyMuted),
      ],
      if (action case final Widget widget) ...<Widget>[
        SizedBox(height: ZaveSpace.lg),
        widget,
      ],
    ],
  );

  // Scrollable, though it almost never scrolls.
  //
  // A pane takes whatever height it is given, and a glyph plus a heading
  // plus two lines of body does not fit in every box a caller might hand
  // it — a short sheet, a landscape phone, a reader at 200% text size. An
  // overflowing Column paints the yellow-and-black stripes over the copy;
  // this simply lets the user move it.
  Widget _pane() => Center(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: ZaveSpace.xl,
        vertical: ZaveSpace.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon ?? AppIcons.empty, size: 44, color: ZaveColors.ink35),
          SizedBox(height: ZaveSpace.lg),
          Text(title, style: ZaveType.h3, textAlign: TextAlign.center),
          if (body case final String text) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(text, style: ZaveType.bodyMuted, textAlign: TextAlign.center),
          ],
          if (action case final Widget widget) ...<Widget>[
            SizedBox(height: ZaveSpace.xl),
            widget,
          ],
        ],
      ),
    ),
  );
}
