import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/plan_slot.dart';
import '../../domain/video_script.dart';

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
/// [handoff] is where a video script or the newsletter has actually got to,
/// and it has to be passed in because the slot cannot answer it. `slot.status`
/// is written only by the post-generation path, which a hand-off day never
/// reaches — `planner-generate.service` throws NOT_A_POST_DAY before it gets
/// there. So both rows read `planned` for ever, and Wednesday said "Script to
/// write" over a script that was written, filmed and posted. Null means the
/// answer has not arrived yet, and the row stays deliberately quiet rather
/// than guessing and then correcting itself a moment later.
({Color color, String label}) slotSignal(
  PlanSlot slot, {
  HandoffState? handoff,
}) {
  // Kind first, because three of the four kinds are not about a post's
  // progress at all. A video script and the newsletter are work WE prepare and
  // the USER posts, so the publish ladder below — scheduled, published —
  // describes something that will never happen to them. Reading `status` on a
  // hand-off day is how the planner came to promise that a video script would
  // go out on its own.
  switch (slot.kind) {
    case DayKind.rest:
      return (color: ZaveColors.ink35, label: 'Rest day');
    case DayKind.videoScript:
      return switch (handoff) {
        null => (color: ZaveColors.ink35, label: 'Video'),
        HandoffState.notWritten => (
          color: ZaveColors.ink35,
          label: 'Script to write',
        ),
        HandoffState.ready => (color: ZaveColors.amber, label: 'Ready to film'),
        HandoffState.posted => (color: ZaveColors.green, label: 'Posted'),
      };
    case DayKind.article:
      return switch (handoff) {
        null => (color: ZaveColors.ink35, label: 'Newsletter'),
        HandoffState.notWritten => (
          color: ZaveColors.ink35,
          label: 'Newsletter to write',
        ),
        // Amber, not periwinkle. Zave reserves amber for "waiting on YOU",
        // and that is exactly what a written hand-off is — the only state on
        // this screen that needs the user to go and do something.
        HandoffState.ready => (color: ZaveColors.amber, label: 'Ready to post'),
        HandoffState.posted => (color: ZaveColors.green, label: 'Posted'),
      };
    case DayKind.post:
      break;
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
    this.handoff,
    this.onTap,
    this.onApprove,
    super.key,
  });

  final PlanSlot slot;

  /// Where this day's hand-off has got to, on a video or newsletter day. Null
  /// on a post day, and while the answer is still loading.
  final HandoffState? handoff;

  /// Raises the card to the `now` fill step. Exactly one card per week may set
  /// this — if several do, none of them reads as current.
  final bool isToday;

  final VoidCallback? onTap;

  /// Only non-null for a slot awaiting approval.
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label}) signal = slotSignal(
      slot,
      handoff: handoff,
    );

    return ZaveCard(
      size: ZaveCardSize.medium,
      isNow: isToday,
      onTap: slot.kind == DayKind.rest ? null : onTap,
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
                tone:
                    slot.status == SlotStatus.published ||
                        handoff == HandoffState.posted
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
                      slot.kind == DayKind.rest ? 'Nothing today' : slot.title,
                      style: ZaveType.h3.copyWith(
                        color: slot.kind == DayKind.rest
                            ? ZaveColors.ink45
                            : ZaveColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // A hand-off day says who does what, because that is the only thing
          // about it the user needs and it is the opposite of a post day.
          if (slot.isHandoff) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              slot.kind == DayKind.videoScript
                  ? 'We write the script — you record and post it.'
                  : 'We write the newsletter — you paste it into LinkedIn.',
              style: ZaveType.caption,
            ),
          ],
          if (slot.kind != DayKind.rest) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            // Wrap, not Row: the leading circle took 56pt off this line and a
            // third tag no longer fits beside the other two. Wrapping keeps
            // every tag visible — a horizontal scroller would hide the third
            // one behind an edge nobody would think to drag.
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                // Only on a post day. `format` is populated on every day so
                // the server's XP pre-gate can index it before the plan is
                // fetched, but on a script or a newsletter it describes a
                // LinkedIn shape we never send — drawing it claims the day
                // produces a text post.
                if (slot.kind == DayKind.post) ...<Widget>[
                  _FormatChip(format: slot.format),
                  if (slot.posterTag != null)
                    _FormatChip(format: slot.posterTag!),
                  if (slot.artifact != null)
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
