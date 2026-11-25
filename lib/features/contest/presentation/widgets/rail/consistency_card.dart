import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../../pricing/domain/consistency_reward.dart'
    show ConsistencyPrice, RewardSurface;
import '../../../../pricing/presentation/widgets/consistency_reward_section.dart';
import '../../../application/contest_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../contest_kit.dart';
import 'rail_card.dart';

/// The meter as every surface reads it: null while loading AND on any error,
/// even one that still carries the last good meter. In Riverpod 3 a failed
/// re-read (after a task's `refreshContestStanding`, or on resume) keeps the
/// old value, which would show a figure missing the XP just earned; the web
/// hides the card whenever `isError` is true, and so do we.
///
/// Deliberate deviation for the stats bar: both of its call sites read the
/// figure through here too, so a failed re-read hides the stats-bar percent
/// along with the card. The web's StatsBar (`consistencyFigure(
/// useConsistency().data)`) keeps React Query's last good `data` and goes on
/// showing the stale percent, which then links to a `#consistency` card that
/// is no longer there. Here the figure scrolls to the card as well, so a
/// figure without its card would be a dead link to a stale number; the two
/// hide together instead.
ConsistencyView? watchConsistency(WidgetRef ref) {
  final AsyncValue<ConsistencyView> meter = ref.watch(
    contestConsistencyProvider,
  );
  return meter.hasError ? null : meter.value;
}

/// The consistency meter's card: how much of the contest XP on offer the
/// learner earned this billing month (`GET /contest/consistency`). A large
/// percent, a bar with a tick at the line, the sum it came from, today's
/// share and any notes. The web's `ConsistencyCard`.
///
/// Renders NOTHING while loading, on an error (even a failed re-read that
/// still holds an older meter — see [watchConsistency]), and in the states off,
/// no_contest and not_joined — the meter is a quiet addition, never a wall.
///
/// The meter's own lines name no rupee. A price appears only in the
/// consistency reward under them (ConsistencyRewardSection), and only while
/// `price.live` — for a UPI AutoPay learner the reward applies to.
class ConsistencyCard extends ConsumerWidget {
  const ConsistencyCard({this.path, super.key});

  /// Today's path, for the notes its own levels call for (a skipped level,
  /// a comment with no topics). Null where there is no week to read.
  final ContestPath? path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ConsistencyView? view = watchConsistency(ref);
    if (view == null || view.state.isHidden) return const SizedBox.shrink();

    final ConsistencyFigure? figure = view.figure;
    final List<String> lines = consistencyLines(view, path);
    return RailCard(
      title: 'Consistency',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (figure != null) ...<Widget>[
            Semantics(
              label: '${figure.percent.clamp(0, 100)}% consistency this month',
              excludeSemantics: true,
              child: Text(
                '${figure.percent.clamp(0, 100)}%',
                style: GoogleFonts.manrope(
                  fontSize: 40,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.4,
                  color: figure.atOrAbove
                      ? ContestColors.peri
                      : ZaveColors.white,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ExcludeSemantics(
              child: _MeterBar(
                percent: figure.percent,
                threshold: view.threshold,
              ),
            ),
            const SizedBox(height: 24),
          ],
          for (int i = 0; i < lines.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: 6),
            Text(lines[i], style: railMuted),
          ],
          // The consistency reward (25 Nov 2026): only for a UPI AutoPay
          // learner with a debit coming, and only while the reward applies
          // to them — nobody else is shown a price.
          if (view.price case final ConsistencyPrice price
              when price.live) ...<Widget>[
            const SizedBox(height: 16),
            ConsistencyRewardSection(
              surface: RewardSurface.card,
              estimateConsented: price.consented,
              nextDebitAt: price.nextDebitAt,
              fixed: price.fixed,
              estimate: price.estimate,
              fixesAt: price.fixesAt,
              fixing: price.fixing,
              minDays: price.minDays,
            ),
          ],
        ],
      ),
    );
  }
}

/// The bar, filled to the percent, with a tick and its label at the line.
class _MeterBar extends StatelessWidget {
  const _MeterBar({required this.percent, required this.threshold});

  final int percent;
  final int threshold;

  @override
  Widget build(BuildContext context) {
    final double fill = percent.clamp(0, 100) / 100;
    final int line = threshold.clamp(0, 100);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final double width = box.maxWidth;
        final double at = width * line / 100;
        return SizedBox(
          height: 16,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 4,
                child: ClipRRect(
                  borderRadius: ZaveRadius.pillBr,
                  child: Container(
                    height: 8,
                    color: ZaveGlass.rowBorder,
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: fill,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: ContestColors.peri,
                          borderRadius: ZaveRadius.pillBr,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: at - 1,
                top: 0,
                child: Container(width: 2, height: 16, color: ZaveColors.ink85),
              ),
              Positioned(
                top: 18,
                left: 0,
                right: 0,
                child: Align(
                  // The label centred on the tick, kept inside the card.
                  alignment: Alignment(
                    width == 0 ? -1 : (2 * at / width - 1).clamp(-1.0, 1.0),
                    0,
                  ),
                  child: Text(
                    '$line%',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ZaveColors.ink62,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
