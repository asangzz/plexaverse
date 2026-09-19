import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/auth_repository.dart';
import 'consent_block.dart';

/// The notice step of a Google sign-up.
///
/// Reached only when the server answered `consent_required`, which it does
/// **without writing anything**. So dismissing this sheet leaves no account
/// and no record — that is the point of the server deferring the write, and
/// why the dismissal path here simply returns null rather than trying to
/// clean anything up.
class ConsentSheet extends StatefulWidget {
  const ConsentSheet({
    required this.profile,
    required this.purposes,
    super.key,
  });

  final GoogleProfile profile;
  final List<ConsentPurposeOption> purposes;

  /// Returns the decision, or null if the user backed out.
  static Future<ConsentDecision?> show(
    BuildContext context, {
    required GoogleProfile profile,
    required List<ConsentPurposeOption> purposes,
  }) {
    return showModalBottomSheet<ConsentDecision>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // Deliberately dismissible. A consent step you cannot back out of is
      // not a free choice.
      isDismissible: true,
      builder: (BuildContext ctx) =>
          ConsentSheet(profile: profile, purposes: purposes),
    );
  }

  @override
  State<ConsentSheet> createState() => _ConsentSheetState();
}

class _ConsentSheetState extends State<ConsentSheet> {
  ConsentDecision _decision = const ConsentDecision(
    acceptedNotice: false,
    consents: <String, bool>{},
  );

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('CREATE YOUR ACCOUNT', style: ZaveType.kicker),
              SizedBox(height: ZaveSpace.md),
              Text('One last thing', style: ZaveType.h2),
              SizedBox(height: ZaveSpace.md),
              Text(
                'Signing in as ${widget.profile.email}.',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.xl),
              ConsentBlock(
                decision: _decision,
                purposes: widget.purposes,
                onChanged: (ConsentDecision d) => setState(() => _decision = d),
              ),
              SizedBox(height: ZaveSpace.xl),
              ZaveButton.primary(
                label: 'Create account',
                expand: true,
                // Disabled until the required box is ticked — the same gate
                // the web's submit button uses, and the same one the server
                // enforces. Three layers, because this is the one the Act
                // actually cares about.
                onPressed: _decision.isComplete
                    ? () => Navigator.of(context).pop(_decision)
                    : null,
              ),
              SizedBox(height: ZaveSpace.md),
              ZaveButton(
                label: 'Not now',
                expand: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
