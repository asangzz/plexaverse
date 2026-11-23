import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_controllers.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/shoutout_words.dart';
import '../contest_kit.dart';
import 'person_tile.dart';

/// "Learners of the week" — on the contest page, AFTER today's lesson. The
/// web's `LearnersOfTheWeek`.
///
/// The server decides everything: the people only come back once the
/// learner's lesson for today is finished, and they are only learners who
/// agreed to be featured. So this draws nothing until the answer is `ready`
/// with someone in it — no teaser before the lesson, because the card must
/// never read as a step the lesson leads to or a level to unlock. It is never
/// a level and never inside one.
///
/// ## No rank, no XP, no order
///
/// The people in the day's shuffle, with nothing numbered: the board stays
/// hidden until the contest's last days, and this card must not become it.
class LearnersOfTheWeek extends ConsumerWidget {
  const LearnersOfTheWeek({this.padding = EdgeInsets.zero, super.key});

  /// Around the card when it draws — and nothing when it does not, so the
  /// page keeps no gap for a card that is not there.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LearnersOfWeek? week = ref.watch(contestFeaturedProvider).value?.week;
    if (week == null || !week.shows) return const SizedBox.shrink();
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text(
              'Learners of the week',
              style: ContestType.sectionTitle,
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(
            '$kLearnersOfTheWeekLine Week of ${dayKeyShort(week.weekStart)} – '
            '${dayKeyShort(week.weekEnd)}.',
            style: ContestType.meta,
          ),
          SizedBox(height: ZaveSpace.lg),
          for (final (int i, FeaturedPerson p)
              in week.learners.indexed) ...<Widget>[
            if (i > 0) SizedBox(height: ZaveSpace.md),
            PersonTile(key: ValueKey<String>('week-${p.key}'), person: p),
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
