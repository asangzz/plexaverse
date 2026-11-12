import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_controllers.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import '../contest_skeletons.dart';
import '../labelled_rule.dart';
import 'rail_card.dart';

/// Gold, silver, bronze — the podium's rank and avatar colours.
const List<Color> _medal = <Color>[
  ContestColors.amber,
  Color(0xFFD4D8EA),
  Color(0xFFE6A26B),
];

/// "AR" for Aarav Rao; "P" for a Participant.
String initialsOf(String? name) {
  final List<String> parts = (name ?? '')
      .trim()
      .split(RegExp(r'\s+'))
      .where((String p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return 'P';
  final String first = parts.first[0];
  final String last = parts.length > 1 ? parts.last[0] : '';
  return '$first$last'.toUpperCase();
}

/// The rail's leaderboard: the podium, you, and the line that matters. The
/// web's `MiniBoard`.
///
/// ## Why it asks for the top N to show four
///
/// The card shows the top three and the viewer, but its last line is a
/// distance — "46 XP to pass #3", or to reach the top ten — and that needs
/// the row just above the viewer, or the Nth. `max(rewardTopN, 3)` rows
/// cover both for anyone in reach of the finalists, who are who it is for.
///
/// ## Hidden until the last days
///
/// Like the full board: before the reveal the server sends no rows, and the
/// card says when it opens. Names follow the board's rule — null is someone
/// who did not agree to be shown, drawn as "Participant".
class MiniBoard extends ConsumerWidget {
  const MiniBoard({required this.rewardTopN, this.onViewAll, super.key});

  final int rewardTopN;

  /// Takes the learner to the full board below.
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BoardResult> board = ref.watch(
      contestBoardProvider(math.max(rewardTopN, 3)),
    );
    final BoardResult? data = board.value;
    final bool locked = data?.isLocked ?? false;

    final Widget body;
    if (data == null && board.hasError) {
      body = Text('Could not load the board.', style: railMuted);
    } else if (data == null) {
      body = const BoardRowsSkeleton(
        rows: 3,
        label: 'Loading the leaderboard preview',
      );
    } else if (locked) {
      body = Text(boardLockedLine(data.revealsOn), style: railMuted);
    } else if (data.rows.isEmpty) {
      body = Text('Nobody is on the board yet.', style: railMuted);
    } else {
      final List<BoardRow> podium = data.rows.take(3).toList();
      final BoardRow? viewer = data.viewer;
      final bool viewerOnPodium = podium.any((BoardRow r) => r.isViewer);
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final BoardRow r in podium) _Row(r),
          if (viewer != null && !viewerOnPodium) _Row(viewer),
          if (rewardTopN > 0) _FinalistsRule(rewardTopN),
          Text(gapLine(data.rows, viewer, rewardTopN), style: railMuted),
        ],
      );
    }

    return RailCard(
      title: 'Leaderboard',
      // Nothing to view all of while the board is hidden.
      aside: locked ? null : RailAside('View all', onTap: onViewAll),
      child: body,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.row);

  final BoardRow row;

  @override
  Widget build(BuildContext context) {
    final Color? medal = row.rank >= 1 && row.rank <= 3
        ? _medal[row.rank - 1]
        : null;
    final String name = row.isViewer ? 'You' : (row.name ?? 'Participant');
    return Semantics(
      container: true,
      label:
          'Rank ${formatCount(row.rank)}, $name, ${formatCount(row.total)} XP',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: row.isViewer
            ? BoxDecoration(
                color: const Color(0x2E2F3AF7),
                border: Border.all(color: const Color(0x807A84FF)),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              )
            : null,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 22,
              child: Text(
                formatCount(row.rank),
                textAlign: TextAlign.center,
                style: _figure(15, medal ?? ZaveColors.ink62),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: row.isViewer
                    ? ContestColors.lesson
                    : (medal ?? const Color(0x1FFFFFFF)),
              ),
              child: Text(
                row.isViewer ? 'YOU' : initialsOf(row.name),
                style: _figure(
                  12,
                  row.isViewer || medal == null
                      ? ZaveColors.white
                      : ContestColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ZaveType.label.copyWith(
                  fontWeight: FontWeight.w700,
                  color: row.name != null || row.isViewer
                      ? ZaveColors.white
                      : ZaveColors.ink50,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${formatCount(row.total)} XP',
              style: _figure(14, ContestColors.amber),
            ),
          ],
        ),
      ),
    );
  }

  static TextStyle _figure(double size, Color color) => GoogleFonts.manrope(
    fontSize: size,
    fontWeight: FontWeight.w800,
    color: color,
    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
  );
}

/// "TOP 10 FINALISTS" between two mint hairlines.
class _FinalistsRule extends StatelessWidget {
  const _FinalistsRule(this.topN);

  final int topN;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LabelledRule(
        colour: const Color(0x6600DC82),
        gap: 10,
        label: Text(
          'Top ${formatCount(topN)} finalists'.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.32,
            color: ContestColors.mint,
          ),
        ),
      ),
    );
  }
}
