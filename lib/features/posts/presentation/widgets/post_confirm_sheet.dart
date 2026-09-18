import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// A destructive confirmation, as a sheet.
///
/// The web asks with `confirm('Are you sure you want to delete this post?')` —
/// a browser dialog it does not style. A phone has no equivalent, and a
/// Material [AlertDialog] would drag in Material's own surface, type and button
/// shapes, none of which are Zave. So the question is asked on the app's own
/// ground instead.
///
/// The consequence is marked in **amber, not red** — Zave has no red token at
/// all, and amber is the system's "this needs your attention" signal. It is
/// carried by the dot and kicker rather than by tinting the button, because a
/// [ZaveButton] takes no colour: colour in this system names a status, and a
/// button is a control, not a status.
///
/// The white primary goes to "Keep it", not to the delete. The one white button
/// on a surface is its recommended action, and on a confirmation the
/// recommended action is the safe one.
Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final bool? result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => _ConfirmSheet(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
    ),
  );
  return result ?? false;
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
  });

  final String title;
  final String message;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding: EdgeInsets.all(ZaveSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              SizedBox(height: ZaveSpace.xl),
              Row(
                children: <Widget>[
                  const ZaveDot(ZaveColors.amber),
                  SizedBox(width: ZaveSpace.sm),
                  Text('THIS CANNOT BE UNDONE', style: ZaveType.kicker),
                ],
              ),
              SizedBox(height: ZaveSpace.md),
              Text(title, style: ZaveType.h3),
              SizedBox(height: ZaveSpace.md),
              Text(message, style: ZaveType.bodyMuted),
              SizedBox(height: ZaveSpace.xl),
              ZaveButton(
                label: confirmLabel,
                icon: const Icon(Icons.delete_outline),
                expand: true,
                onPressed: () => Navigator.of(context).pop(true),
              ),
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: 'Keep it',
                kind: ZaveButtonKind.primarySmall,
                expand: true,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
