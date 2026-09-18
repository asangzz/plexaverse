import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/plan_slot.dart';

/// Maps a slot's status onto a Zave signal colour.
///
/// Zave's first rule is that colour only ever names a status, so this is the
/// one place the planner decides what each state looks like.
///
/// The web planner paints these in its own palette (`#5761EB` indigo rails,
/// `#00DC82` green, an amber "waiting"). Restated in Zave: published is green
/// (done), approved is `scheduled` periwinkle (queued), generated is amber
/// (waiting on YOU — the only state that needs a tap), and everything not yet
/// written is ink at 35%.
///
/// Note there is deliberately no red anywhere: Zave has none, and none of these
/// states is an error.
({Color color, String label}) slotSignal(PlanSlot slot) {
  if (slot.restDay) {
    return (color: ZaveColors.ink35, label: 'Rest day');
  }
  return switch (slot.status) {
    SlotStatus.published => (color: ZaveColors.green, label: 'Published'),
    SlotStatus.approved => (color: ZaveColors.scheduled, label: 'Scheduled'),
    SlotStatus.generated => (color: ZaveColors.amber, label: 'Needs approval'),
    SlotStatus.generating => (color: ZaveColors.peri, label: 'Writing…'),
    SlotStatus.planned => (color: ZaveColors.ink35, label: 'Planned'),
  };
}

/// One day of the week.
///
/// The web renders these as a seven-column grid; a phone stacks them, which is
/// also what the web itself does below its `lg` breakpoint.
class SlotCard extends StatelessWidget {
  const SlotCard({
    required this.slot,
    required this.isToday,
    this.onTap,
    this.onApprove,
    super.key,
  });

  final PlanSlot slot;

  /// Raises the card to the `now` fill step. Exactly one card per week may set
  /// this — if several do, none of them reads as current.
  final bool isToday;

  final VoidCallback? onTap;

  /// Only non-null for a slot awaiting approval.
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label}) signal = slotSignal(slot);

    return ZaveCard(
      size: ZaveCardSize.medium,
      isNow: isToday,
      onTap: slot.restDay ? null : onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(slot.day.toUpperCase(), style: ZaveType.kicker),
              SizedBox(width: ZaveSpace.sm),
              if (isToday)
                Text(
                  '· TODAY',
                  style: ZaveType.kicker.copyWith(color: ZaveColors.peri),
                ),
              const Spacer(),
              ZaveDot(signal.color),
              SizedBox(width: ZaveSpace.sm),
              Text(
                signal.label,
                style: ZaveType.caption.copyWith(color: signal.color),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            slot.restDay ? 'No post scheduled' : slot.title,
            style: ZaveType.h3.copyWith(
              color: slot.restDay ? ZaveColors.ink45 : ZaveColors.white,
            ),
          ),
          if (!slot.restDay) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Row(
              children: <Widget>[
                _FormatChip(format: slot.format),
                if (slot.posterTag != null) ...<Widget>[
                  SizedBox(width: ZaveSpace.sm),
                  _FormatChip(format: slot.posterTag!),
                ],
                if (slot.artifact != null) ...<Widget>[
                  SizedBox(width: ZaveSpace.sm),
                  _FormatChip(format: slot.artifact!),
                ],
              ],
            ),
          ],
          if (onApprove != null) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            ZaveButton(
              label: 'Approve',
              kind: ZaveButtonKind.primarySmall,
              onPressed: onApprove,
              expand: true,
            ),
          ],
        ],
      ),
    );
  }
}

/// A small, static descriptor — the post format, poster style or artifact.
/// Static, so a pill rather than a chip: it is a label, not a control.
class _FormatChip extends StatelessWidget {
  const _FormatChip({required this.format});

  final String format;

  @override
  Widget build(BuildContext context) =>
      ZavePill(label: format, color: ZaveColors.ink62);
}
