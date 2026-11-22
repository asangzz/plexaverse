import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/billing_state_controller.dart';
import '../../domain/pricing_repository.dart';

/// "Which State are you in?" — the buyer's GST State, the web's
/// `components/billing/BillingStatePicker.tsx`.
///
/// ONE PICKER, EVERY PLACE: onboarding's step before the plan, Settings →
/// Billing, and inline before a payment (the plan step, Pricing, Settings'
/// way back). The same list, sentence and rule everywhere.
///
/// PRE-SELECTED, NEVER SUBMITTED FOR THEM. It starts on [preset] — the State
/// on record, else the one the server's region points at — and only the
/// button sends it, which stays disabled while nothing is chosen. So the
/// record is always the buyer's own choice.
///
/// A web `<select>` becomes a field that opens a sheet of the States: a
/// 36-line dropdown is not a phone control.
///
/// Holds only what the buyer has picked and not yet sent. Whether a save is
/// running, and why one failed, belong to whoever saves ([busy], [error]):
/// onboarding's chat, or [BillingStateForm].
class BillingStatePicker extends StatefulWidget {
  const BillingStatePicker({
    required this.onSubmit,
    this.preset,
    this.busy = false,
    this.error,
    this.submitLabel = 'Save',
    this.submitKind = ZaveButtonKind.primary,
    this.showQuestion = false,
    this.onCancel,
    super.key,
  });

  /// Called with a declarable code only — never an empty choice.
  final ValueChanged<String> onSubmit;

  /// What the field shows until the buyer picks: the State on record, else
  /// the server's suggestion, else nothing.
  final String? preset;

  /// A save is running: the controls hold still.
  final bool busy;

  /// Why the last save did not go through, in one sentence.
  final String? error;

  /// The button's words. "Continue" in onboarding, "Save and continue"
  /// before a payment.
  final String submitLabel;

  /// Brand (blue) where the button carries on into a payment — the one
  /// thing blue is for.
  final ZaveButtonKind submitKind;

  /// Print the question as a heading. Onboarding leaves it to Plexa's line
  /// above the panel.
  final bool showQuestion;

  /// A secondary "Cancel", for Settings' change and the inline checkout ask.
  final VoidCallback? onCancel;

  /// The field's label — the web's `<label>`.
  static const String fieldLabel = 'State or Union Territory';

  /// What the field says before anything is chosen.
  static const String placeholder = 'Choose your State or UT';

  /// The web's `#e5484d` — the one red this product uses for "this did not
  /// work", as the plan step's errors do.
  static const Color _alert = Color(0xFFE5484D);

  @override
  State<BillingStatePicker> createState() => _BillingStatePickerState();
}

class _BillingStatePickerState extends State<BillingStatePicker> {
  /// Null until the buyer picks; until then the field shows [preset].
  String? _picked;

  String? get _value => _picked ?? widget.preset;

  Future<void> _choose() async {
    final String? code = await showBillingStateSheet(context, selected: _value);
    if (code == null || !mounted) return;
    setState(() => _picked = code);
  }

  @override
  Widget build(BuildContext context) {
    final String? value = _value;
    final String? name = billingStateName(value);
    final bool chosen = isBillingStateCode(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showQuestion) ...<Widget>[
          Text(kBillingStateQuestion, style: ZaveType.label),
          SizedBox(height: ZaveSpace.xs),
        ],
        Text(kBillingStateReason, style: ZaveType.caption),
        SizedBox(height: ZaveSpace.md),
        Text(
          BillingStatePicker.fieldLabel.toUpperCase(),
          style: ZaveType.kicker,
        ),
        SizedBox(height: ZaveSpace.sm),
        Semantics(
          button: true,
          enabled: !widget.busy,
          label:
              '${BillingStatePicker.fieldLabel}: '
              '${name ?? BillingStatePicker.placeholder}',
          excludeSemantics: true,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey<String>('billing-state-field'),
              onTap: widget.busy ? null : _choose,
              borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
              child: Container(
                padding: ZaveSpace.inputPad,
                decoration: BoxDecoration(
                  color: ZaveGlass.controlFill,
                  border: Border.all(color: ZaveColors.rule),
                  borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name ?? BillingStatePicker.placeholder,
                        style: ZaveType.body.copyWith(
                          color: name == null
                              ? ZaveColors.ink35
                              : ZaveColors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: ZaveSpace.md),
                    const Icon(
                      AppIcons.chevronDown,
                      color: ZaveColors.ink45,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.error != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              widget.error!,
              style: ZaveType.label.copyWith(color: BillingStatePicker._alert),
            ),
          ),
        ],
        SizedBox(height: ZaveSpace.lg),
        // Full width and stacked: "Save and continue" beside a Cancel does
        // not fit a phone's card.
        ZaveButton(
          kind: widget.submitKind,
          expand: true,
          label: widget.busy ? 'Saving…' : widget.submitLabel,
          busy: widget.busy,
          // Disabled while nothing is chosen: the record must be the
          // buyer's own choice, never an empty one. While busy the button
          // takes no tap but is not dimmed — its spinner is the news.
          onPressed: chosen ? () => widget.onSubmit(value!) : null,
        ),
        if (widget.onCancel != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          ZaveButton(
            label: 'Cancel',
            expand: true,
            onPressed: widget.busy ? null : widget.onCancel,
          ),
        ],
      ],
    );
  }
}

/// The States, as a sheet. Returns the chosen code, or null when dismissed.
Future<String?> showBillingStateSheet(
  BuildContext context, {
  String? selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => _StateSheet(selected: selected),
  );
}

class _StateSheet extends StatelessWidget {
  const _StateSheet({this.selected});

  final String? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.gutter,
                ZaveSpace.md,
                ZaveSpace.gutter,
                ZaveSpace.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: ZaveSpace.lg),
                  Text(
                    BillingStatePicker.fieldLabel.toUpperCase(),
                    style: ZaveType.kicker,
                  ),
                  SizedBox(height: ZaveSpace.sm),
                  Text(kBillingStateQuestion, style: ZaveType.h3),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: ZaveSpace.lg),
                itemCount: kBillingStateOptions.length,
                itemBuilder: (BuildContext context, int i) {
                  final BillingStateOption o = kBillingStateOptions[i];
                  final bool isSelected = o.code == selected;
                  return Semantics(
                    selected: isSelected,
                    button: true,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(o.code),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ZaveSpace.gutter,
                          vertical: ZaveSpace.md,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                o.name,
                                style: ZaveType.body.copyWith(
                                  color: ZaveColors.white,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                AppIcons.check,
                                color: ZaveColors.white,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [BillingStatePicker] that saves for itself, through [BillingStateSave] —
/// for Settings and the inline asks on Pricing and Settings' way back.
/// Onboarding's chat saves through its own controller instead, because its
/// State is one more answer in the conversation.
///
/// Pre-selected from `GET /user/billing-state`: the State on record, else
/// the server's region.
class BillingStateForm extends ConsumerWidget {
  const BillingStateForm({
    required this.source,
    required this.onSaved,
    this.onCancel,
    this.showQuestion = false,
    this.submitLabel = 'Save',
    this.submitKind = ZaveButtonKind.primary,
    super.key,
  });

  final BillingStateSource source;

  /// The State is on record. Before a payment, the caller runs that payment
  /// again; it now goes straight through.
  final ValueChanged<SavedBillingState> onSaved;

  final VoidCallback? onCancel;
  final bool showQuestion;
  final String submitLabel;
  final ZaveButtonKind submitKind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BillingState? onRecord = ref.watch(billingStateProvider).value;
    final AsyncValue<SavedBillingState?> save = ref.watch(
      billingStateSaveProvider(source),
    );
    return BillingStatePicker(
      preset: onRecord?.preset,
      busy: save.isLoading,
      error: save.hasError && !save.isLoading
          ? billingStateSaveError(save.error!)
          : null,
      submitLabel: submitLabel,
      submitKind: submitKind,
      showQuestion: showQuestion,
      onSubmit: (String code) async {
        final SavedBillingState? saved = await ref
            .read(billingStateSaveProvider(source).notifier)
            .save(code);
        // Left the screen meanwhile: the State is saved, and the payment it
        // was asked for is not run behind their back.
        if (saved == null || !context.mounted) return;
        onSaved(saved);
      },
      onCancel: onCancel == null
          ? null
          : () {
              ref.read(billingStateSaveProvider(source).notifier).reset();
              onCancel!();
            },
    );
  }
}
