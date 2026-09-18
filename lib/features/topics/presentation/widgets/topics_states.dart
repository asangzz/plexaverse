import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// Zave has no icon-size scale. [ZaveChip] sizes a leading icon at 16, and
/// this matches it so the two read as the same size class.
const double kTopicsPillIcon = 16;

/// The inline banner the web keeps at the top of the Topics page.
///
/// **Green for a success, amber for a failure.** The web uses green and red;
/// Zave has no red at all, and amber is its "this needs your attention"
/// signal. The colour is carried by the dot and the text — the card's own
/// glass never changes, because a surface is not a status.
///
/// It auto-dismisses after three seconds, which is the web's `setTimeout`. The
/// timer lives in the page, not here, so this widget stays a pure function of
/// its inputs.
class TopicsBanner extends StatelessWidget {
  const TopicsBanner({required this.message, required this.isError, super.key});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    // Zave has NO RED. A failure is amber.
    final Color signal = isError ? ZaveColors.amber : ZaveColors.green;

    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            // Nudge the dot onto the first line's optical centre.
            padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
            child: ZaveDot(signal),
          ),
          SizedBox(width: ZaveSpace.md),
          Expanded(
            child: Text(message, style: ZaveType.label.copyWith(color: signal)),
          ),
        ],
      ),
    );
  }
}

/// "Level 5 Goal: Define 3 Topics" — the roadmap nudge above the list.
///
/// The web paints this an indigo→green gradient panel with a gradient-text
/// counter. In Zave the colour has to mean something, so: the goal is not met
/// yet, which is the "waiting on you" state, which is amber; and the counter
/// takes [ZaveType.num], the periwinkle numeral role the system already uses
/// for exactly this kind of progress figure.
///
/// The card disappears at three topics, which is also when the roadmap step
/// fires — see `TopicsController`.
class TopicsGoalCard extends StatelessWidget {
  const TopicsGoalCard({required this.count, required this.target, super.key});

  final int count;
  final int target;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Amber: a goal not yet met is "waiting", not an error. Zave has
              // no red to misuse here in any case.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Expanded(child: Text('LEVEL 5 GOAL', style: ZaveType.kicker)),
              Text('$count/$target', style: ZaveType.num),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text('Define $target Topics', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Define at least $target topics to build your content foundations.',
            style: ZaveType.caption,
          ),
        ],
      ),
    );
  }
}

/// "No topics yet" — the web's empty state.
class TopicsEmpty extends StatelessWidget {
  const TopicsEmpty({required this.onCreate, super.key});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Text('NOTHING HERE', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text('No topics yet', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Create your first topic to start generating content',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          // Ghost, not white: the screen's one white button is "Add Topic" at
          // the top, and this is the same action. Two white pills for one
          // action would break the one-primary-per-screen rule to say nothing
          // new.
          ZaveButton(
            label: 'Create Topic',
            icon: const Icon(Icons.add),
            onPressed: onCreate,
          ),
        ],
      ),
    );
  }
}

/// The load-failed state.
///
/// Amber, not red: **Zave has no red at all**, and a fetch that failed is a
/// "needs attention" state rather than a destructive one.
class TopicsError extends StatelessWidget {
  const TopicsError({required this.onRetry, this.detail, super.key});

  final String? detail;
  final VoidCallback onRetry;

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
              Text('COULD NOT LOAD', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text('Your topics did not load.', style: ZaveType.h3),
          if (detail != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(detail!, style: ZaveType.bodyMuted),
          ],
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}

/// The loading list.
///
/// Deliberately not a shimmer. Zave's motion rule is "short and physical;
/// nothing bounces", and a looping sweep is neither — the cards simply occupy
/// the space their content will, so the layout does not jump.
class TopicsSkeleton extends StatelessWidget {
  const TopicsSkeleton({this.rows = 3, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < rows; i++) ...<Widget>[
          const _SkeletonCard(),
          SizedBox(height: ZaveSpace.md),
        ],
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _Bar(widthFactor: 0.55, height: 18),
          SizedBox(height: ZaveSpace.md),
          const _Bar(widthFactor: 0.9),
          SizedBox(height: ZaveSpace.sm),
          const _Bar(widthFactor: 0.7),
          SizedBox(height: ZaveSpace.lg),
          Row(
            children: <Widget>[
              const _Bar(width: 72, height: 22),
              SizedBox(width: ZaveSpace.sm),
              const _Bar(width: 56, height: 22),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({this.width, this.widthFactor, this.height = 12});

  final double? width;
  final double? widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    // One fill step above the card it sits on — which is how depth is
    // expressed in this system. There is no shadow anywhere.
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
