import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/consistency_reward_controller.dart';
import '../../domain/consistency_reward.dart';

/// The consistency reward, where a UPI AutoPay learner sees it — the web's
/// `ConsistencyRewardSection` (owner, 25 Nov 2026; CONSISTENCY_BILLING.md):
///
///   1. the headline;
///   2. the coming debit: "Next debit: ₹80 on 25 Dec" once its price is fixed
///      (72h before it) with the breakdown under it; before that, with the
///      switch on, "Next debit: about ₹80 on 25 Dec (estimate)" and when it
///      becomes the price; while the server is still fixing it, no figure;
///   3. the switch, "Use my consistency to set my monthly price" — never
///      pre-ticked, drawn from the server's answer — with its why and the
///      conditions while it is off.
///
/// The parent shows this only while the reward applies to the account
/// (`live`). The words come from `GET /billing/consistency-reward` and are
/// shown verbatim; until they arrive — or if they cannot be read, a 404 from
/// a server older than the route included — nothing is drawn, and the
/// billing screen around it (Stop autopay above all) is never held up.
///
/// Billing copy, not game copy: no XP, level, streak, points, score, game,
/// play, win or prize anywhere here.
class ConsistencyRewardSection extends ConsumerWidget {
  const ConsistencyRewardSection({
    required this.nextDebitAt,
    this.fixed,
    this.estimate,
    this.fixesAt,
    this.fixing = false,
    this.minDays = 0,
    this.estimateConsented,
    this.surface = RewardSurface.billing,
    super.key,
  });

  /// The coming debit's date.
  final DateTime? nextDebitAt;

  /// Its price, once fixed.
  final FixedDebitPrice? fixed;

  /// Before the fix: the estimate from the window so far.
  final EstimatedDebitPrice? estimate;

  /// When its price is (or was) fixed.
  final DateTime? fixesAt;

  /// Past the fix instant and not fixed yet: no figure.
  final bool fixing;

  /// The fewest counted days a month needs, for the estimate's note.
  final int minDays;

  /// The consent the estimate was computed under (the meter's own
  /// `price.consented`), or null when unknown.
  final bool? estimateConsented;

  /// Settings → Billing, or the consistency card.
  final RewardSurface surface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ConsistencyRewardConsent> read = ref.watch(
      consistencyRewardConsentControllerProvider,
    );
    // Any error hides the section — a failed re-read keeps the previous value
    // in Riverpod, and those may be words the server now refuses.
    final ConsistencyRewardConsent? consent = read.hasError ? null : read.value;
    if (consent == null) return const SizedBox.shrink();
    final RewardSave save = ref.watch(consistencyRewardSaveControllerProvider);
    final ConsistencyRewardWords words = consent.words;
    final bool on = consent.consented;
    // Not while saving, nor while the words are being re-read (after a 409
    // the ones on screen are the refused ones).
    final bool busy = save.saving || read.isLoading;
    final String? error = save.surface == surface ? save.error : null;

    final RewardDebit? debit = RewardDebit.of(
      nextDebitAt: nextDebitAt,
      fixed: fixed,
      estimate: estimate,
      consented: on,
      fixing: fixing,
      minDays: minDays,
      estimateConsented: estimateConsented,
    );

    final TextStyle strong = surface == RewardSurface.card
        ? ZaveType.label.copyWith(color: ZaveColors.white)
        : ZaveType.body.copyWith(color: ZaveColors.white);
    final TextStyle muted = ZaveType.caption;

    void flip(bool value) => ref
        .read(consistencyRewardSaveControllerProvider.notifier)
        .set(value, surface: surface);

    return Container(
      key: const Key('consistency-reward'),
      width: double.infinity,
      padding: EdgeInsets.all(ZaveSpace.lg),
      decoration: BoxDecoration(
        color: ZaveGlass.rest,
        border: Border.all(color: ZaveGlass.restBorder),
        borderRadius: ZaveRadius.cardSmBr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(words.headline, style: strong),

          if (debit != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              container: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(debit.line, style: strong),
                  if (debit.note case final String note) ...<Widget>[
                    SizedBox(height: ZaveSpace.xs),
                    Text(note, style: muted),
                  ],
                ],
              ),
            ),
          ],

          SizedBox(height: ZaveSpace.md),
          if (!on && consent.staleConsent) ...<Widget>[
            Text(kStaleConsentLine, style: muted),
            SizedBox(height: ZaveSpace.sm),
          ],
          // The switch, never pre-ticked: drawn from the server's answer. One
          // node for a screen reader — the label read once, with the state.
          MergeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text(words.label, style: strong)),
                SizedBox(width: ZaveSpace.md),
                ZaveSwitch(value: on, onChanged: busy ? null : flip),
              ],
            ),
          ),

          if (!on) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(words.why, style: muted),
            // The rule the yes is given to, in full, beside the switch.
            if (words.conditions.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              for (final String line in words.conditions)
                Padding(
                  padding: EdgeInsets.only(bottom: ZaveSpace.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('•  ', style: muted),
                      Expanded(child: Text(line, style: muted)),
                    ],
                  ),
                ),
            ],
            if (fixed != null && words.appliesFromNextLine.isNotEmpty) ...<
              Widget
            >[
              SizedBox(height: ZaveSpace.xs),
              Text(words.appliesFromNextLine, style: muted),
            ] else if (fixed == null && !fixing && fixesAt != null) ...<Widget>[
              SizedBox(height: ZaveSpace.xs),
              Text(switchOnBeforeLine(fixesAt!), style: muted),
            ],
          ],

          if (error != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                error,
                style: muted.copyWith(color: ZaveColors.amber),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
