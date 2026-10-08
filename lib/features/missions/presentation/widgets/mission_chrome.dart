import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The header every `/roadmap/*` mission shares.
///
/// The web writes its title as `The `+ a gradient-filled word +` Hook`, and
/// puts the level / step / reward in two pills on the right. Zave has no
/// decorative gradients — colour only ever names a status — so the title is
/// plain white Manrope and the accent survives as emphasis of PLACEMENT (its
/// own line, the largest type on the screen) rather than of hue.
///
/// The reward pill keeps its colour, because there it means something: amber
/// is points, everywhere in this app.
class MissionHeader extends StatelessWidget {
  const MissionHeader({
    required this.subtitle,
    required this.level,
    required this.step,
    required this.totalSteps,
    required this.rewardXp,
    this.title,
    super.key,
  });

  /// The mission's name, or null when the screen's [ZaveScaffold] already
  /// carries it as a `largeTitle`.
  ///
  /// Null is the normal case now. These screens used to wear the name twice —
  /// a compact bar reading "Headline Hook" over a body h2 reading "The
  /// Headline Hook", and on Banner Blueprint the two were the same string
  /// exactly. The name belongs in the header, where it collapses out of the
  /// way once you start reading; repeating it here would put the screen back
  /// to two names, which is the thing the expanded header was added to fix.
  ///
  /// The kicker and the reward pill stay regardless: "LEVEL 1 · STEP 3 OF 7"
  /// and the XP are facts about the step, not a second title.
  final String? title;

  final String subtitle;
  final int level;
  final int step;
  final int totalSteps;
  final int rewardXp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'LEVEL $level · STEP $step OF $totalSteps',
          style: ZaveType.kicker,
        ),
        SizedBox(height: ZaveSpace.md),
        if (title != null) ...<Widget>[
          Text(title!, style: ZaveType.h2),
          SizedBox(height: ZaveSpace.md),
        ],
        Text(subtitle, style: ZaveType.lead),
        SizedBox(height: ZaveSpace.lg),
        Align(
          alignment: Alignment.centerLeft,
          child: ZavePill(
            label: 'Reward: $rewardXp XP',
            color: ZaveColors.amber,
            leading: const ZaveDot(ZaveColors.amber),
          ),
        ),
      ],
    );
  }
}

/// Which way a [MissionMessage] reads.
enum MissionTone {
  /// Something landed. Green is "done" in this system.
  success,

  /// Something needs attention, or did not go through.
  ///
  /// **Amber, not red.** Zave has no red at all, and none of the things this
  /// screen reports — an empty checklist, a short About section, a generation
  /// that failed — is destructive.
  warning,
}

/// The inline banner the mission pages use instead of a snack bar.
///
/// The web renders it in the card footer, immediately above the action it
/// relates to, which is where the user is already looking. A floating snack
/// bar would appear over the bottom bar, away from the control that caused it.
class MissionMessage extends StatelessWidget {
  const MissionMessage({required this.text, required this.tone, super.key});

  final String text;
  final MissionTone tone;

  @override
  Widget build(BuildContext context) {
    final Color color = tone == MissionTone.success
        ? ZaveColors.green
        : ZaveColors.amber;

    return Container(
      width: double.infinity,
      decoration: ZaveSurface.row,
      padding: ZaveSpace.rowPad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
            child: ZaveDot(color),
          ),
          SizedBox(width: ZaveSpace.sm),
          Expanded(
            child: Text(text, style: ZaveType.caption.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

/// A live counter badge — "2/3 Paragraphs", "412 Characters", "180 / 220".
///
/// Turns green once its threshold is met, which is the one piece of colour the
/// web puts on these and the one that genuinely names a status: this
/// requirement is DONE.
class MissionBadge extends StatelessWidget {
  const MissionBadge({required this.label, required this.met, super.key});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) => ZavePill(
    label: label,
    color: met ? ZaveColors.green : ZaveColors.ink50,
    leading: ZaveDot(met ? ZaveColors.green : ZaveColors.ink35),
  );
}

/// The retryable failure card shared by all four screens in this slice.
class MissionErrorCard extends StatelessWidget {
  const MissionErrorCard({
    required this.title,
    required this.detail,
    required this.onRetry,
    super.key,
  });

  final String title;
  final String detail;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber, not red: Zave has no red, and a failed fetch is "needs
              // attention", not a destructive state.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text('COULD NOT LOAD', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(title, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(detail, style: ZaveType.bodyMuted),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

/// A resting glass block, used while a section loads.
///
/// No shimmer: depth in Zave is the fill step, and a sweeping highlight is a
/// second visual language on top of it.
class MissionSkeleton extends StatelessWidget {
  const MissionSkeleton({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: ZaveSurface.card);
}
