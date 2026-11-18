import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import 'contest_kit.dart';

/// Streak, XP and rank — the three figures the design keeps above
/// everything. The web's `StatsBar`.
///
/// ## The rank only once the board opens
///
/// [rank] is null until the contest's last days, and then there is no
/// trophy at all — not a dash, not "#–": the server has not ranked anyone,
/// and a placeholder would read as a rank to come.
///
/// Plain values, no provider: the page reads the overview once and hands the
/// figures down, so this bar and the board can never show two totals. XP is
/// the amber bolt and the word "XP" — never a bare figure.
///
/// ## The consistency figure
///
/// [consistency] is set only while the meter is measuring
/// (`ConsistencyView.figure`): the gauge and the percent, which takes the
/// learner to the meter's card — the web's link to `#consistency`.
class StatsBar extends StatelessWidget {
  const StatsBar({
    required this.streak,
    required this.total,
    this.rank,
    this.dayNumber,
    this.consistency,
    this.onConsistencyTap,
    super.key,
  });

  final int streak;
  final int total;
  final int? rank;

  /// The "Day 11" chip, on the running page, where the banner is further
  /// away. The day only — never "of N".
  final int? dayNumber;

  /// The consistency meter, only while it is measuring.
  final ConsistencyFigure? consistency;

  /// Brings the meter's card into view. Null draws the figure alone.
  final VoidCallback? onConsistencyTap;

  @override
  Widget build(BuildContext context) {
    final int? day = dayNumber;
    final int? place = rank;
    final ConsistencyFigure? meter = consistency;
    return Semantics(
      container: true,
      label: 'Your standing',
      explicitChildNodes: true,
      child: Container(
        // Full width, so spaceBetween spreads the figures across it.
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        // A Wrap, not a Row: at the largest text size on the narrowest
        // phone the four do not fit on one line, and the rank is the one
        // that would be pushed off it.
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: <Widget>[
            if (day != null && day > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: const BoxDecoration(
                  color: ContestColors.peri,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  'Day ${formatCount(day)}'.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.88,
                    color: ContestColors.ink,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ),
            _Stat(
              icon: AppIcons.fire,
              iconColour: ContestColors.flame,
              text: formatCount(streak),
              colour: ContestColors.flame,
              spoken: '${formatCount(streak)}-day streak',
            ),
            _Stat(
              icon: AppIcons.bolt,
              iconColour: ContestColors.amber,
              text: '${formatCount(total)} XP',
              colour: ContestColors.amber,
              spoken: '${formatCount(total)} XP',
            ),
            if (meter != null)
              _ConsistencyStat(figure: meter, onTap: onConsistencyTap),
            if (place != null)
              _Stat(
                icon: AppIcons.trophy,
                iconColour: ContestColors.amber,
                text: '#${formatCount(place)}',
                colour: ContestColors.peri,
                spoken: 'Rank ${formatCount(place)}',
              ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.iconColour,
    required this.text,
    required this.colour,
    required this.spoken,
  });

  final IconData icon;
  final Color iconColour;
  final String text;
  final Color colour;
  final String spoken;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: spoken,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 17, color: iconColour),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colour,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// The meter's figure: the gauge and the percent, a link to its card.
class _ConsistencyStat extends StatelessWidget {
  const _ConsistencyStat({required this.figure, this.onTap});

  final ConsistencyFigure figure;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String percent = '${formatCount(figure.percent)}%';
    final Widget stat = _Stat(
      icon: AppIcons.gauge,
      iconColour: ContestColors.peri,
      text: percent,
      colour: ContestColors.peri,
      spoken: '$percent consistency this month',
    );
    final VoidCallback? tap = onTap;
    if (tap == null) return stat;
    return Semantics(
      link: true,
      child: InkWell(
        onTap: tap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Center(widthFactor: 1, child: stat),
        ),
      ),
    );
  }
}
