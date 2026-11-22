import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/contest_controllers.dart';
import '../../domain/contest_dates.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import 'contest_kit.dart';
import 'contest_skeletons.dart';
import 'labelled_rule.dart';

/// How many places the full board asks for.
const int kFullBoardLimit = 50;

/// The full board: rank, name, streak, XP. The web's `ContestBoard`.
///
/// ## Its own widget, so the read only runs where it is shown
///
/// The server ranks every entry in memory to answer it. Mounting it only for
/// someone who has joined keeps the join card from paying for a ranking it
/// never draws.
///
/// ## Hidden until the last days
///
/// Before the reveal the server sends no rows and no rank — not even the
/// viewer's — and this says when it opens: a quiet panel, not an empty
/// table. An admin's token gets the rows early, with a line saying entrants
/// do not see them yet.
///
/// ## The viewer is pinned below, never spliced in
///
/// The server returns the top rows and, separately, the viewer's own. Out of
/// the top fifty, their row follows a gap rather than being spliced into the
/// list, which would draw a rank sequence that skips. The "now" fill is the
/// viewer's, and only theirs.
///
/// ## Names
///
/// Null unless that entrant agreed to be shown (the join card's consent):
/// "Participant", in the muted ink, so an anonymous entrant reads apart from
/// someone whose name happens to be that word.
class ContestBoardView extends ConsumerWidget {
  const ContestBoardView({
    required this.entrants,
    required this.rewardTopN,
    required this.rewardMonths,
    super.key,
  });

  final int entrants;
  final int rewardTopN;
  final int rewardMonths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BoardResult> board = ref.watch(
      contestBoardProvider(kFullBoardLimit),
    );
    final BoardResult? data = board.value;

    final Widget body;
    if (data != null && data.isLocked) {
      body = ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ContestDot(
              tone: ContestTone.idle,
              label: 'Leaderboard hidden for now',
            ),
            SizedBox(height: ZaveSpace.sm),
            Text(
              boardLockedLine(data.revealsOn),
              style: ZaveType.body.copyWith(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      );
    } else {
      body = ContestPanel(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (data != null &&
                !data.revealed &&
                data.rows.isNotEmpty &&
                data.revealsOn.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  'Admin view. Entrants see the board from '
                  '${dayKeyLong(data.revealsOn)}.',
                  style: ContestType.meta,
                ),
              ),
            const _Header(),
            ..._rows(board, data),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text('Leaderboard', style: ContestType.sectionTitle),
              ),
            ),
            Text(
              plural(entrants, 'entrant', 'entrants'),
              style: ContestType.meta,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        body,
        SizedBox(height: ZaveSpace.lg),
        Text(
          'Names appear only for people who chose to show them. Ties go to '
          'first-try accuracy on the questions written for you, then to '
          'whoever reached the score first.',
          style: ZaveType.caption.copyWith(fontSize: 13, height: 1.6),
        ),
      ],
    );
  }

  List<Widget> _rows(AsyncValue<BoardResult> board, BoardResult? data) {
    if (data == null && board.hasError) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const ContestDot(
                tone: ContestTone.idle,
                label: 'Could not load the board',
              ),
              SizedBox(height: ZaveSpace.sm),
              Text(contestMessage(board.error!), style: ContestType.meta),
            ],
          ),
        ),
      ];
    }
    if (data == null) {
      return const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: BoardRowsSkeleton(rows: 5, label: 'Loading the leaderboard'),
        ),
      ];
    }
    if (data.rows.isEmpty) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Nobody is on the board yet.', style: ContestType.meta),
        ),
      ];
    }
    final BoardRow? viewer = data.viewer;
    return <Widget>[
      for (int i = 0; i < data.rows.length; i++) ...<Widget>[
        _Row(data.rows[i]),
        // A hairline under the last rewarded place, labelled, so "the top
        // 10 get 3 months free" is a line to see yourself above or below.
        if (rewardTopN > 0 &&
            data.rows[i].rank == rewardTopN &&
            i < data.rows.length - 1)
          _RewardRule(topN: rewardTopN, months: rewardMonths),
      ],
      if (viewer != null && data.viewerOutsideRows) ...<Widget>[
        const ExcludeSemantics(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '···',
              textAlign: TextAlign.center,
              style: TextStyle(color: ZaveColors.ink35, fontSize: 13),
            ),
          ),
        ),
        Semantics(
          container: true,
          label: 'Your place',
          explicitChildNodes: true,
          child: _Row(viewer),
        ),
      ],
    ];
  }
}

/// Rank · name · streak · XP — the one set of widths the header and every
/// row share, so the columns line up.
class _Columns extends StatelessWidget {
  const _Columns({
    required this.rank,
    required this.name,
    required this.streak,
    required this.xp,
  });

  final Widget rank;
  final Widget name;
  final Widget streak;
  final Widget xp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 36, child: rank),
        const SizedBox(width: 12),
        Expanded(child: name),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          child: Align(alignment: Alignment.centerRight, child: streak),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Align(alignment: Alignment.centerRight, child: xp),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final TextStyle style = ContestType.meta.copyWith(fontSize: 13);
    // Each row says what its cells are; a header row would be read as an
    // entrant of its own.
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: _Columns(
          rank: Text('Rank', style: style),
          name: Text('Name', style: style),
          streak: Text('Streak', style: style),
          xp: Text('XP', style: style),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.row);

  final BoardRow row;

  @override
  Widget build(BuildContext context) {
    final String? name = row.name;
    final String spokenName = name ?? 'Participant';
    return Semantics(
      container: true,
      label:
          'Rank ${formatCount(row.rank)}, $spokenName'
          '${row.isViewer ? ', you' : ''}, '
          '${row.streak > 0 ? '${formatCount(row.streak)}-day streak' : 'no streak'}, '
          '${formatCount(row.total)} XP',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: row.isViewer ? ZaveGlass.now : null,
          border: Border.all(
            color: row.isViewer ? ZaveGlass.nowBorder : Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: _Columns(
          rank: Text(
            formatCount(row.rank),
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: row.isViewer ? ZaveColors.white : ZaveColors.ink50,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
          name: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Flexible(
                child: Text(
                  spokenName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZaveType.body.copyWith(
                    fontSize: 16,
                    fontWeight: name != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: row.isViewer
                        ? ZaveColors.white
                        : (name != null ? ZaveColors.ink85 : ZaveColors.ink50),
                  ),
                ),
              ),
              if (row.isViewer) ...<Widget>[
                const SizedBox(width: 8),
                Text(
                  'You',
                  style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                ),
              ],
            ],
          ),
          streak: Text(
            row.streak > 0 ? formatCount(row.streak) : '–',
            style: ZaveType.body.copyWith(
              fontSize: 15,
              color: ZaveColors.ink62,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
          xp: Text(
            formatCount(row.total),
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: ContestColors.amber,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Top 10 get 3 months free", on a hairline under the last rewarded place.
class _RewardRule extends StatelessWidget {
  const _RewardRule({required this.topN, required this.months});

  final int topN;
  final int months;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LabelledRule(
          colour: ZaveColors.rule,
          label: Text(
            'Top ${formatCount(topN)} get featured',
            textAlign: TextAlign.center,
            style: ContestType.meta.copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
