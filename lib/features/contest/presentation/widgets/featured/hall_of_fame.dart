import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_controllers.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../../../domain/levels_words.dart';
import '../../../domain/shoutout_words.dart';
import '../contest_kit.dart';
import 'person_tile.dart';

/// The Hall of Fame — each finalised round's top learners who agreed to be
/// featured, for 30 days after the result was fixed. The web's `HallOfFame`.
/// A round is named by its dates, never by its admin title (owner, 24 Nov
/// 2026); with rounds back to back, this card is where the last round's
/// result lives.
///
/// A place is drawn only where the server sends one: for a winner who also
/// agreed to be named on the leaderboard. The others follow, unnumbered, in
/// the order the server shuffled them — their place must not be readable.
///
/// Shown in every state of the levels page: the round it names is over, its
/// final standings are public, and everyone in it agreed to be shown to
/// every learner. Links only, never a button.
class HallOfFame extends ConsumerWidget {
  const HallOfFame({this.padding = EdgeInsets.zero, super.key});

  /// Around the section when it draws — and nothing when there is no
  /// finalised contest to show.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<HallOfFameEntry> entries =
        ref.watch(contestFeaturedProvider).value?.hallOfFame ??
        const <HallOfFameEntry>[];
    final List<HallOfFameEntry> shown = <HallOfFameEntry>[
      for (final HallOfFameEntry e in entries)
        if (e.winners.isNotEmpty) e,
    ];
    if (shown.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text('Hall of Fame', style: ContestType.sectionTitle),
          ),
          for (final HallOfFameEntry e in shown) ...<Widget>[
            SizedBox(height: ZaveSpace.xl),
            // A round is named by its dates, never by its admin title.
            Semantics(
              header: true,
              child: Text(_heading(e), style: ContestType.cardTitle),
            ),
            SizedBox(height: ZaveSpace.xs),
            Text(
              'The top ${formatCount(e.rewardTopN)} learners won ${e.prizeTitle}. '
              'Featured until ${shortDate(e.featuredUntil.toLocal())}.',
              style: ContestType.meta,
            ),
            SizedBox(height: ZaveSpace.md),
            // The placed first, in place order; then the unplaced, as sent.
            for (final (int i, HallOfFameWinner w) in <HallOfFameWinner>[
              ...e.winners.where((HallOfFameWinner w) => w.rank != null),
              ...e.winners.where((HallOfFameWinner w) => w.rank == null),
            ].indexed) ...<Widget>[
              if (i > 0) SizedBox(height: ZaveSpace.md),
              PersonTile(
                key: ValueKey<String>('fame-${e.contestId}-${w.key}'),
                person: w.person,
                rank: w.rank,
              ),
            ],
          ],
          SizedBox(height: ZaveSpace.lg),
          Text(
            kFollowOptionalLine,
            style: ContestType.meta.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

/// "The round that ended 23 February 2027" — the round by its dates, as the
/// web's Hall of Fame heads it. An older server sends no last day: "The last
/// round".
String _heading(HallOfFameEntry e) {
  final String round = roundEndedPhrase(e.lastDayKey);
  return '${round[0].toUpperCase()}${round.substring(1)}';
}
