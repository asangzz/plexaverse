import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/presentation/widgets/billing_state_picker.dart';

/// Onboarding's "Which State are you in?" step — the web's
/// `components/onboarding/BillingStateStep.tsx`.
///
/// WHERE IT SITS. Straight after the LinkedIn connect and BEFORE the plan
/// step, because the plan step can take a payment and the buyer's State has
/// to be on record before any supply (Circular 242/36/2024-GST para 4.5.2):
/// every GST invoice names it, and it decides CGST + SGST or IGST.
///
/// WHO SEES IT. A buyer in India with no State on record — decided by the
/// controller (`billingStateStepAsks`). Plexa's line above asks the
/// question, so the panel is the picker and a Continue.
///
/// PRE-SELECTED FROM THE REGION, NEVER SUBMITTED FOR THEM: Continue stays
/// disabled while nothing is chosen, and only the buyer's tap saves.
class BillingStatePanel extends StatelessWidget {
  const BillingStatePanel({
    required this.onSubmit,
    this.preset,
    this.busy = false,
    this.error,
    super.key,
  });

  final ValueChanged<String> onSubmit;
  final String? preset;
  final bool busy;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ZaveSpace.xl),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardBr,
      ),
      child: BillingStatePicker(
        preset: preset,
        busy: busy,
        error: error,
        submitLabel: 'Continue',
        onSubmit: onSubmit,
      ),
    );
  }
}
