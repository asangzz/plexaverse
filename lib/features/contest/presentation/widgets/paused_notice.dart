import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/contest_words.dart';
import 'contest_kit.dart';

/// Said above everything once scoring has stopped, because every figure
/// below has stopped with it. The web's `PausedNotice`.
///
/// It promises nothing about later: lessons stay open, XP has stopped, and a
/// plan starts it again — not "your answers will count once you subscribe",
/// which the ledger would not keep.
class PausedNotice extends StatelessWidget {
  const PausedNotice({required this.freeDays, super.key});

  /// The contest's free period, which is what is over.
  final int freeDays;

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ContestDot(tone: ContestTone.waiting, label: 'Scoring paused'),
          SizedBox(height: ZaveSpace.xs),
          Text(
            'Your ${freePeriod(freeDays)} is over. Lessons stay open, but XP '
            'has stopped until you have a plan.',
            style: ZaveType.body.copyWith(fontSize: 15, height: 1.6),
          ),
          SizedBox(height: ZaveSpace.lg),
          ContestGhostPill(
            label: 'See plans',
            onPressed: () => unawaited(context.push(ZaveRoutes.pricing)),
          ),
        ],
      ),
    );
  }
}
