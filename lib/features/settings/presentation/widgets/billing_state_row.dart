import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/application/billing_state_controller.dart';
import '../../../pricing/domain/pricing_repository.dart';
import '../../../pricing/presentation/widgets/billing_state_picker.dart';

/// Settings → Billing → **Your State** — the buyer's GST State, shown and
/// changeable (the web's `GstDetailsPanel`).
///
/// Asked in onboarding and before a payment when missing; here it can be
/// seen and changed at any time (source `settings`). Changing it moves only
/// invoices issued afterwards — every issued document keeps the State it was
/// issued with — and the row says so.
///
/// Shown to an India account (the server's reading of the region) or to
/// anyone with a State on record; a buyer abroad pays in dollars and has no
/// GST State to show. Nothing at all while it loads or when it cannot be
/// read — the State is never a reason to put an error under someone's plan.
class BillingStateRow extends ConsumerStatefulWidget {
  const BillingStateRow({super.key});

  @override
  ConsumerState<BillingStateRow> createState() => _BillingStateRowState();
}

class _BillingStateRowState extends ConsumerState<BillingStateRow> {
  /// The picker is open in place of the State's name.
  bool _editing = false;

  /// The last change went through — "Saved." until the picker opens again.
  bool _justSaved = false;

  @override
  Widget build(BuildContext context) {
    final BillingState? data = ref.watch(billingStateProvider).value;
    if (data == null || !(data.isIndia || data.declared)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: ZaveSpace.lg),
        Container(height: 1, color: ZaveColors.rule),
        SizedBox(height: ZaveSpace.lg),
        Text('YOUR STATE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.xs),
        if (_editing)
          BillingStateForm(
            source: BillingStateSource.settings,
            onSaved: (SavedBillingState _) => setState(() {
              _editing = false;
              _justSaved = true;
            }),
            onCancel: () => setState(() => _editing = false),
          )
        else ...<Widget>[
          Text(data.stateName ?? 'Not set yet', style: ZaveType.label),
          SizedBox(height: ZaveSpace.xs),
          Text(
            '$kBillingStateReason $kBillingStateChangeNote',
            style: ZaveType.caption,
          ),
          if (_justSaved) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text('Saved.', style: ZaveType.label),
            ),
          ],
          SizedBox(height: ZaveSpace.md),
          ZaveButton(
            label: data.declared ? 'Change State' : 'Add your State',
            onPressed: () {
              ref
                  .read(
                    billingStateSaveProvider(
                      BillingStateSource.settings,
                    ).notifier,
                  )
                  .reset();
              setState(() {
                _justSaved = false;
                _editing = true;
              });
            },
          ),
        ],
      ],
    );
  }
}
