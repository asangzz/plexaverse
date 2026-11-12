import 'package:flutter/material.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import 'rail_card.dart';

/// The prize: what first place wins, the day the result is announced, and
/// the top-N reward. The web's `PrizeCard`.
///
/// ## A date, not a countdown
///
/// "Results on 9 Feb 2027" — the owner's call (11 Nov 2026: "don't show the
/// days left, tell the date of result directly"), and the same date the join
/// card gives for "Winner announced". `endsAt` is the instant the contest
/// closes, formatted on the phone's clock as the web formats it on the
/// viewer's.
///
/// The top-N line names the condition the owner set — the months are free
/// FOR THE NEXT CONTEST — so nobody reads it as months off their plan.
class PrizeCard extends StatelessWidget {
  const PrizeCard({required this.contest, super.key});

  final ContestInfo contest;

  @override
  Widget build(BuildContext context) {
    final String? image = contest.prizeImageUrl;
    final String date = shortDate(contest.endsAt.toLocal());
    return RailCard(
      child: Row(
        children: <Widget>[
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: SizedBox.square(
                dimension: 58,
                child: image != null && image.isNotEmpty
                    ? ZaveImage(source: image, tone: ZaveImageTone.quiet)
                    : const _TrophyTile(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Semantics(
                  header: true,
                  child: Text(
                    'First place wins ${contest.prizeTitle}',
                    style: railTitle,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Results on $date · Top ${formatCount(contest.rewardTopN)} '
                  'get ${plural(contest.rewardMonths, 'month', 'months')} '
                  'free for the next contest',
                  style: railMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// No prize photo: a gold tile with a white trophy.
class _TrophyTile extends StatelessWidget {
  const _TrophyTile();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[ZaveColors.amber, Color(0xFFF5A623)],
        ),
      ),
      child: Center(
        child: Icon(AppIcons.trophy, size: 26, color: ZaveColors.white),
      ),
    );
  }
}
