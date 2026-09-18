import 'package:flutter/widgets.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The "or continue with email" rule between the social buttons and the form.
///
/// Zave build: two [ZaveColors.rule] hairlines with a [ZaveType.kicker] label
/// between them. The kicker is uppercased at the call site because Flutter has
/// no `text-transform` (see [ZaveType.kicker]).
///
/// The pre-alignment version took an `isDark` flag and picked between a white
/// and a black hairline. Zave is dark-only by design (see `ZaveTheme`), so the
/// flag is gone rather than defaulted.
class AuthDivider extends StatelessWidget {
  const AuthDivider({this.label = 'or continue with email', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Widget line = Container(height: 1, color: ZaveColors.rule);

    return Row(
      children: <Widget>[
        Expanded(child: line),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ZaveSpace.md),
          child: Text(label.toUpperCase(), style: ZaveType.kicker),
        ),
        Expanded(child: line),
      ],
    );
  }
}
