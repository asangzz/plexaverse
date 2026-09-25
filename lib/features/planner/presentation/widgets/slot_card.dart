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
          // The reference opens every list row with a circle, and it is what
          // makes a column of these scan as a week rather than as stacked
          // paragraphs. The day's initial goes inside it, so the row is
          // identifiable before any of its text is read.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _DayCircle(
                day: slot.day,
                tone: slot.status == SlotStatus.published
                    ? ZaveRowTone.done
                    : isToday
                    ? ZaveRowTone.now
                    : ZaveRowTone.rest,
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
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
                            style: ZaveType.kicker.copyWith(
                              color: ZaveColors.lavenderLo,
                            ),
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
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      slot.restDay ? 'No post scheduled' : slot.title,
                      style: ZaveType.h3.copyWith(
                        color: slot.restDay
                            ? ZaveColors.ink45
                            : ZaveColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!slot.restDay) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            // Wrap, not Row: the leading circle took 56pt off this line and a
            // third tag no longer fits beside the other two. Wrapping keeps
            // every tag visible — a horizontal scroller would hide the third
            // one behind an edge nobody would think to drag.
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                _FormatChip(format: slot.format),
                if (slot.posterTag != null)
                  _FormatChip(format: slot.posterTag!),
                if (slot.artifact != null) _FormatChip(format: slot.artifact!),
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

/// The day's initial, in the reference's list-row circle.
///
/// A letter rather than an icon: seven rows all carrying the same calendar
/// glyph would be decoration, where `M` `T` `W` is the one thing that tells
/// the rows apart at a glance.
class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.day, required this.tone});

  final String day;
  final ZaveRowTone tone;

  @override
  Widget build(BuildContext context) {
    final (Color fill, Color border, Color fg) = switch (tone) {
      ZaveRowTone.done => (ZaveColors.green, ZaveColors.green, ZaveColors.ink),
      ZaveRowTone.now => (
        ZaveColors.violet,
        ZaveColors.violet,
        ZaveColors.white,
      ),
      ZaveRowTone.rest => (
        ZaveGlass.controlFill,
        ZaveColors.rule,
        ZaveColors.ink62,
      ),
    };

    return Container(
      height: ZaveRowCircle.size,
      width: ZaveRowCircle.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        day.isEmpty ? '?' : day.substring(0, 1).toUpperCase(),
        style: ZaveType.label.copyWith(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}
