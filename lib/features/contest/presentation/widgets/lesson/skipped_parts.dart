import 'package:flutter/material.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../domain/contest_repository.dart';
import '../contest_kit.dart';

/// Today's lesson, parked: every part still to do was skipped (17 Nov 2026),
/// and the learner came in without asking for one. The web's
/// `player/SkippedParts.tsx`, its words verbatim.
///
/// Says what is still open and offers each skipped part, with the next level
/// as the one white pill. The day credit and the streak still need every
/// question, so it says so.
class SkippedPartsView extends StatelessWidget {
  const SkippedPartsView({required this.parts, required this.onDo, super.key});

  /// The skipped parts, 1-based, in order.
  final List<int> parts;

  /// Open part k (1-based) at its next question to answer.
  final ValueChanged<int> onDo;

  /// "part 2", "parts 1 and 3", "parts 1, 2 and 3".
  static String listOf(List<int> parts) {
    if (parts.length == 1) return 'part ${parts.first}';
    final List<int> head = parts.sublist(0, parts.length - 1);
    return 'parts ${head.join(', ')} and ${parts.last}';
  }

  @override
  Widget build(BuildContext context) {
    final String line =
        'You skipped ${listOf(parts)}. '
        '${parts.length == 1 ? 'It’s' : 'They’re'} open until the day ends, '
        'and your streak needs every question.';
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text(
              'Today’s lesson isn’t finished',
              style: ContestType.cardTitle,
            ),
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            line,
            style: ZaveType.body.copyWith(
              fontSize: 15.sp,
              height: 1.6,
              color: ZaveColors.ink85,
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
          const NextLevelPill(from: PathNodeKind.lesson),
          SizedBox(height: ZaveSpace.md),
          for (final int k in parts)
            Align(
              alignment: Alignment.centerLeft,
              child: ContestTextLink(
                label: 'Do part $k now',
                fontSize: 15,
                onTap: () => onDo(k),
              ),
            ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Each part pays as usual once you finish it today.',
            style: ContestType.meta,
          ),
        ],
      ),
    );
  }
}
