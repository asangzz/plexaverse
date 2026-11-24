import 'package:flutter/material.dart';

import '../../../../../core/ui/app_icons.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import 'rail_card.dart';

/// The shoutout: what the top learners get, and the day the levels reset —
/// the round's end, when the top learners are decided. The web's
/// `PrizeCard`.
///
/// ## A date, not a countdown
///
/// "Levels reset 9 Feb 2027" — the owner's call (11 Nov 2026: "don't show
/// the days left, tell the date of result directly"). `endsAt` is the
/// instant the round closes, formatted on the phone's clock as the web
/// formats it on the viewer's. Recognition only, said on the card itself.
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
                    'Top ${formatCount(contest.rewardTopN)} win ${contest.prizeTitle}',
                    style: railTitle,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${date.isEmpty ? '' : 'Levels reset $date · '}Recognition only, no cash value',
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
