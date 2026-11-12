import 'package:flutter/widgets.dart';

/// A label between two rules — the path's day dividers, the board's "Top 10
/// get 3 months free", the mini board's "Top 10 finalists".
///
/// The label keeps its own width and the rules take what is left, down to
/// [minRule] each; a label too long for that wraps rather than pushing the
/// row off the screen. A plain Row of two Expanded rules around a Text would
/// overflow on the narrowest phone at the largest text size.
class LabelledRule extends StatelessWidget {
  const LabelledRule({
    required this.label,
    required this.colour,
    this.thickness = 1,
    this.gap = 12,
    this.minRule = 16,
    super.key,
  });

  final Widget label;
  final Color colour;
  final double thickness;

  /// Between each rule and the label.
  final double gap;

  /// The least each rule keeps, so the label still reads as sitting on one.
  final double minRule;

  @override
  Widget build(BuildContext context) {
    final Widget rule = Expanded(
      child: SizedBox(
        height: thickness,
        child: ColoredBox(color: colour),
      ),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final double room = c.maxWidth - 2 * (gap + minRule);
        return Row(
          children: <Widget>[
            rule,
            SizedBox(width: gap),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: room < 0 ? 0 : room),
              child: label,
            ),
            SizedBox(width: gap),
            rule,
          ],
        );
      },
    );
  }
}
