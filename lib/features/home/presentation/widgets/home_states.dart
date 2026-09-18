import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The home screen's loading shape.
///
/// **Deliberately not the web's.** The web shows a bare teal spinner on a blank
/// 400px box, and before that a generic two-card skeleton that looks nothing
/// like the roadmap it is replaced by — the recon calls that out as worth
/// fixing. This one is shape-matched: a tall block where the timeline lands and
/// a panel-sized card where the missions land, so the page does not visibly
/// re-flow the moment data arrives.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({required this.topInset, super.key});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.gutter,
        topInset + ZaveSpace.xl,
        ZaveSpace.gutter,
        ZaveSpace.section,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: DecoratedBox(decoration: ZaveSurface.card)),
          SizedBox(height: ZaveSpace.lg),
          SizedBox(
            // The collapsed mission sheet is 40% of the screen; the skeleton
            // stands in at the same height so nothing jumps when data lands.
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: DecoratedBox(decoration: ZaveSurface.listRow),
          ),
        ],
      ),
    );
  }
}

/// The home screen could not load.
///
/// Amber, not red: Zave has no red, and a fetch that did not land is "needs
/// attention", not a destructive state. The roadmap itself has no empty state —
/// all 66 days always exist — so this is the only thing that ever stands in for
/// it.
class HomeError extends StatelessWidget {
  const HomeError({required this.onRetry, required this.topInset, super.key});

  final VoidCallback onRetry;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        ZaveSpace.gutter,
        topInset + ZaveSpace.xl,
        ZaveSpace.gutter,
        ZaveSpace.section,
      ),
      children: <Widget>[
        ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const ZaveDot(ZaveColors.amber),
                  SizedBox(width: ZaveSpace.sm),
                  Text('COULD NOT LOAD', style: ZaveType.kicker),
                ],
              ),
              SizedBox(height: ZaveSpace.md),
              Text("Today's plan didn't load.", style: ZaveType.h3),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'Your streak is safe — this is only the screen.',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.lg),
              ZaveButton(label: 'Try again', onPressed: onRetry),
            ],
          ),
        ),
      ],
    );
  }
}
