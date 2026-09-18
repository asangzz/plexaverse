import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The chrome every sheet in this slice sits in.
///
/// The web renders these as centred modals (`max-w-5xl`, `max-h-[90vh]`,
/// `grid lg:grid-cols-2`) that collapse to one column below 1024px — which is
/// to say, on every phone the modal is already a single stacked column behind
/// a scrim. A bottom sheet is that same shape expressed in the grammar a phone
/// actually has, so nothing about the layout is invented here; only the way it
/// arrives is.
///
/// It caps at 90% of the screen so the page behind stays visible — a sheet
/// that fills the screen is a page, and the user loses the thread of where
/// they were.
class AiToolSheet extends StatelessWidget {
  const AiToolSheet({required this.children, super.key});

  final List<Widget> children;

  /// Opens [child] as a Zave sheet. `isScrollControlled` so a sheet with a
  /// text field can lift clear of the keyboard.
  static Future<T?> show<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lift the sheet clear of the keyboard: these sheets are mostly forms,
      // and a field under the keyboard is a field the user cannot see while
      // typing into it.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
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

/// The drag handle. A hairline pill, not a shadow or a bar — the same rule
/// that keeps depth in the fill step keeps this one flat.
///
/// 4 x 40 is a raw pair because Zave has no token for it: the web has no
/// bottom sheets and therefore no grabber to port. It matches the planner's,
/// which is the existing precedent in this app.
class _Grabber extends StatelessWidget {
  const _Grabber();

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
