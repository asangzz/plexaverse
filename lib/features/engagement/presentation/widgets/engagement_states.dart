import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/engagement_repository.dart';

/// The loading list for either habit screen.
///
/// Deliberately NOT a shimmer. Zave's motion rule is "short and physical;
/// nothing bounces", and a looping gradient sweep is neither: the cards occupy
/// the space their content will, at the rest fill step, so nothing jumps when
/// the batch lands.
class EngagementSkeleton extends StatelessWidget {
  const EngagementSkeleton({this.rows = 3, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _Bar(width: 120),
        SizedBox(height: ZaveSpace.md),
        const _Bar(widthFactor: 0.8, height: 30),
        SizedBox(height: ZaveSpace.xl),
        for (int i = 0; i < rows; i++) ...<Widget>[
          const _CardSkeleton(),
          SizedBox(height: ZaveSpace.md),
        ],
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _Bar(widthFactor: 0.55),
          SizedBox(height: ZaveSpace.md),
          const _Bar(widthFactor: 1),
          SizedBox(height: ZaveSpace.sm),
          const _Bar(widthFactor: 0.9),
          SizedBox(height: ZaveSpace.sm),
          const _Bar(widthFactor: 0.4),
        ],
      ),
    );
  }
}

/// One placeholder bar, one fill step above the card it sits on — which is how
/// depth is expressed in this system. There is no shadow and no shimmer.
class _Bar extends StatelessWidget {
  const _Bar({this.width, this.widthFactor, this.height = 12});

  final double? width;
  final double? widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final Widget bar = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: ZaveGlass.hover,
        borderRadius: ZaveRadius.pillBr,
      ),
    );
    return widthFactor == null
        ? bar
        : FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: widthFactor,
            child: bar,
          );
  }
}

/// The card both habit screens show when a generation is refused.
///
/// One widget with three branches rather than three call sites, because the
/// branch is the whole point: an out-of-XP user and a user with an empty
/// profile need different sentences and different buttons, and collapsing them
/// into one "something went wrong" is how a user ends up on the pricing page
/// to fix a missing job title.
///
/// Amber throughout. **Zave has no red**, and none of these is destructive —
/// each is a state the user can walk out of.
class EngagementBlocked extends StatelessWidget {
  const EngagementBlocked({
    required this.failure,
    required this.onRetry,
    required this.onGetXp,
    required this.onCompleteProfile,
    this.knownXpCost,
    super.key,
  });

  final EngagementFailure failure;
  final VoidCallback onRetry;
  final VoidCallback onGetXp;
  final VoidCallback onCompleteProfile;

  /// The last price the server quoted, if this screen has ever seen one.
  ///
  /// The service throws `INSUFFICIENT_XP` with `details.requiredXP`, but the
  /// mobile envelope's error mapper drops the details block, so the number
  /// never arrives with the refusal. Rather than invent one, the copy names a
  /// figure only when a previous successful batch quoted it.
  final int? knownXpCost;

  @override
  Widget build(BuildContext context) {
    final (
      String kicker,
      String title,
      String body,
      Widget action,
    ) = switch (failure.kind) {
      EngagementBlock.insufficientXp => (
        'NOT ENOUGH XP',
        'This one costs XP',
        knownXpCost == null
            ? 'Your balance will not cover a new batch. Top up and come back — '
                  "today's batch stays free once it exists."
            : 'A batch costs $knownXpCost XP and your balance will not cover '
                  "it. Top up and come back — today's batch stays free once it "
                  'exists.',
        ZaveButton(label: 'Get more XP', onPressed: onGetXp),
      ),
      EngagementBlock.profileIncomplete => (
        'PROFILE INCOMPLETE',
        'We need to know what you do',
        'Add your headline or profession in settings, and this screen can find '
            'people worth reaching out to. Without it the list would be '
            'generic, so nothing was generated and nothing was charged.',
        ZaveButton(label: 'Complete profile', onPressed: onCompleteProfile),
      ),
      EngagementBlock.unavailable => (
        'COULD NOT LOAD',
        'That did not come back',
        failure.message ??
            'The connection dropped, or the model refused. Nothing was '
                'charged — try again.',
        ZaveButton(label: 'Try again', onPressed: onRetry),
      ),
    };

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text(kicker, style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(title, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(body, style: ZaveType.bodyMuted),
          SizedBox(height: ZaveSpace.lg),
          action,
        ],
      ),
    );
  }
}

/// "Today's set — come back any time, it's free until tomorrow."
///
/// The web's cached-batch notice, and worth keeping: the screen auto-generates
/// on open, so a user who does not know about the daily cache reasonably
/// assumes every visit is costing them XP.
class CachedBatchNote extends StatelessWidget {
  const CachedBatchNote({super.key});

  @override
  Widget build(BuildContext context) => Text(
    "Today's set — come back any time, it's free until tomorrow.",
    style: ZaveType.caption,
  );
}

/// The "new set" control, disabled, with the reason said out loud.
///
/// The web prices a regenerate ("↺ New set · 50 XP") behind a confirm. The
/// mobile route at `app/api/mobile/v1/ai/{comments,connections}/route.ts` never
/// forwards a `force` flag to the service, so the request would be accepted,
/// ignored, and answered with today's cached batch. A button that spends
/// nothing and changes nothing is worse than no button, and a silently
/// swallowed no-op is the exact failure mode this codebase's API layer was
/// rebuilt to stop — so the control renders, disabled, saying why.
class NewSetUnavailable extends StatelessWidget {
  const NewSetUnavailable({required this.xpCost, super.key});

  /// The server's quoted price, when the batch carried one.
  final int? xpCost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ZaveSpace.rowPad,
      decoration: ZaveSurface.row,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  xpCost == null ? 'New set' : 'New set · $xpCost XP',
                  style: ZaveType.label.copyWith(color: ZaveColors.ink45),
                ),
                SizedBox(height: ZaveSpace.xs),
                Text(
                  'Asking for a different set is not available on mobile yet. '
                  "Today's set is here whenever you come back.",
                  style: ZaveType.caption,
                ),
              ],
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          // Disabled on purpose — see the class doc. `null` is what dims it.
          const ZaveIconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'New set (unavailable on mobile)',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

/// "How it works", plus the one thing this app cannot do.
///
/// The web's four numbered steps assume its `LinkedInWebviewPanel`: a drawer
/// that opens LinkedIn's own search beside the list. **This build has no URL
/// launcher and no webview**, so that drawer cannot be ported and step two of
/// the web's list would be a lie. The steps are restated for what actually
/// happens on a phone — copy here, switch to LinkedIn — and the missing
/// capability is named rather than papered over.
class HowItWorksCard extends StatelessWidget {
  const HowItWorksCard({required this.steps, required this.handoff, super.key});

  final List<String> steps;

  /// The one-line version of what the user does after copying.
  final String handoff;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('HOW IT WORKS', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.lg),
          for (int i = 0; i < steps.length; i++) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: ZaveSpace.xl,
                  child: Text('${i + 1}', style: ZaveType.num),
                ),
                Expanded(
                  child: Text(
                    steps[i],
                    style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1) SizedBox(height: ZaveSpace.md),
          ],
          SizedBox(height: ZaveSpace.lg),
          Container(
            padding: ZaveSpace.rowPad,
            decoration: ZaveSurface.row,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ZaveDot(ZaveColors.amber),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Text(
                    handoff,
                    style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The amber rule box on `/connections`.
///
/// Kept verbatim in substance because it is the single most expensive thing a
/// user can get wrong here: LinkedIn's free plan caps personalised connection
/// notes at roughly five a week, and spending them on accounts that cannot
/// receive them wastes the whole week's allowance.
class FreePlanRuleCard extends StatelessWidget {
  const FreePlanRuleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Text(
                'LINKEDIN FREE PLAN RULE',
                style: ZaveType.kicker.copyWith(color: ZaveColors.amber),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Send these personalised notes only to Premium accounts — the ones '
            'with the gold badge. For ordinary accounts, send the request with '
            'no note at all.',
            style: ZaveType.bodyMuted,
          ),
        ],
      ),
    );
  }
}
