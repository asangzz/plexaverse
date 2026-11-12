import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../application/contest_controllers.dart';
import '../../../domain/contest_dates.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import '../contest_skeletons.dart';
import 'rail_card.dart';

/// The kinds offered every day, each drawn as ONE "Daily" row.
const List<PathNodeKind> _dailyKinds = <PathNodeKind>[
  PathNodeKind.comment,
  PathNodeKind.feedComments,
];

/// "This week on LinkedIn": every task on the path this week, then the
/// week's claims, each with where it stands. The web's `WeekTasksCard`.
///
/// ## Each daily task is one row
///
/// The comment level and the five feed comments are on every day. Seven
/// identical rows each would bury the weekday tasks, so each daily kind is
/// one row — "Daily", with how many are done of how many — and the header's
/// total still counts every day's points.
///
/// ## The claims are listed from the claims
///
/// What pays for the planner's pieces is each going out — the article and
/// the videos — claimed by its link on the day it is posted. That level is
/// on the path too, but the claims are listed here from `path.claims`, so a
/// late one (a past day's, or last week's still unpaid) stays one tap away;
/// the claim NODES are left out of the task rows, so nothing counts twice.
/// "Share link" opens the claim by its kind and occurrence, never a URL.
class WeekTasksCard extends StatelessWidget {
  const WeekTasksCard({
    required this.days,
    required this.claims,
    this.emptyNote,
    this.loading = false,
    super.key,
  });

  final List<PathDay> days;
  final List<PostClaim> claims;

  /// Replaces "no tasks" when the week is unknown rather than empty.
  final String? emptyNote;

  /// The week is on its way: the rows are drawn in outline.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final List<(PathDay, PathNode)> all = <(PathDay, PathNode)>[
      for (final PathDay d in days)
        for (final PathNode n in d.nodes)
          if (n.kind != PathNodeKind.lesson && !n.kind.isClaim) (d, n),
    ];
    final List<List<(PathDay, PathNode)>> daily = <List<(PathDay, PathNode)>>[
      for (final PathNodeKind kind in _dailyKinds)
        all.where(((PathDay, PathNode) t) => t.$2.kind == kind).toList(),
    ].where((List<(PathDay, PathNode)> g) => g.isNotEmpty).toList();
    final List<(PathDay, PathNode)> tasks = all
        .where(((PathDay, PathNode) t) => !_dailyKinds.contains(t.$2.kind))
        .toList();
    // Today's claim levels still waiting their turn: the card must not offer
    // a link the path shows locked and the server refuses.
    final Set<String> lockedClaims = <String>{
      for (final PathDay d in days)
        if (d.isToday)
          for (final PathNode n in d.nodes)
            if (n.state == PathNodeState.locked)
              if (n.claim case final NodeClaim c)
                '${c.kind.wire}:${c.occurrence}',
    };
    int total = 0;
    for (final (PathDay, PathNode) t in all) {
      if (t.$2.points > 0) total += t.$2.points;
    }
    for (final PostClaim c in claims) {
      if (c.points > 0) total += c.points;
    }

    final Widget body;
    if (loading) {
      body = const RailRowsSkeleton(label: 'Loading this week’s tasks');
    } else if (all.isEmpty && claims.isEmpty) {
      body = Text(
        emptyNote ?? 'No LinkedIn tasks this week.',
        style: railMuted,
      );
    } else {
      body = Column(
        children: <Widget>[
          for (final List<(PathDay, PathNode)> group in daily) _dailyRow(group),
          for (final (PathDay day, PathNode node) in tasks) _taskRow(day, node),
          for (final PostClaim c in claims)
            _claimRow(
              context,
              c,
              locked: lockedClaims.contains('${c.kind.wire}:${c.occurrence}'),
            ),
        ],
      );
    }

    return RailCard(
      title: 'This week on LinkedIn',
      aside: total > 0 ? RailAside('+${formatCount(total)} XP') : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          body,
          const SizedBox(height: 8),
          Text(
            'Article and video XP land when you share the post link — from '
            'the day it goes out — and our team checks it.',
            style: railMuted,
          ),
        ],
      ),
    );
  }

  Widget _dailyRow(List<(PathDay, PathNode)> group) {
    final int done = group
        .where(((PathDay, PathNode) t) => isFinished(t.$2.state))
        .length;
    return _TaskRow(
      chip: 'Daily',
      now: group.any(((PathDay, PathNode) t) => t.$1.isToday),
      title: group.first.$2.title,
      status: Semantics(
        label: '$done of ${group.length} done',
        excludeSemantics: true,
        child: Text(
          '$done/${group.length}',
          style: _statusStyle(done > 0 ? ContestColors.mint : ZaveColors.ink45),
        ),
      ),
    );
  }

  Widget _taskRow(PathDay day, PathNode node) {
    final (String word, Color colour) = switch (node.state) {
      PathNodeState.done ||
      PathNodeState.approved => ('Done', ContestColors.mint),
      PathNodeState.pending => ('Pending', ContestColors.amber),
      PathNodeState.rejected => ('Rejected', ContestColors.wrongText),
      PathNodeState.revoked => ('Removed', ContestColors.wrongText),
      PathNodeState.missed => ('Missed', ZaveColors.ink45),
      PathNodeState.unavailable => ('None today', ZaveColors.ink45),
      _ => (
        node.points > 0 ? '+${formatCount(node.points)}' : '',
        ZaveColors.ink45,
      ),
    };
    return _TaskRow(
      chip: day.weekday >= 0 && day.weekday < 7
          ? kWeekdayShort[day.weekday]
          : '',
      now: day.isToday,
      title: node.title,
      reason: node.state == PathNodeState.rejected ? node.detail : null,
      status: Text(word.toUpperCase(), style: _statusStyle(colour)),
    );
  }

  Widget _claimRow(BuildContext context, PostClaim c, {required bool locked}) {
    final int? weekday = weekdayOfKey(c.postingDayKey);
    final String chip = weekday != null
        ? kWeekdayShort[weekday]
        : (c.kind == ClaimKind.article ? 'Art' : 'Vid');
    final Color colour = switch (c.status) {
      ClaimStatus.approved => ContestColors.mint,
      ClaimStatus.pending => ContestColors.amber,
      ClaimStatus.rejected => ContestColors.wrongText,
      ClaimStatus.open => ContestColors.peri,
      ClaimStatus.notReady => ZaveColors.ink45,
    };
    final String? route = contestClaimRoute(c.kind, c.occurrence);
    final Widget status;
    if (locked) {
      status = Text('LOCKED', style: _statusStyle(ZaveColors.ink45));
    } else if (route != null &&
        (c.status == ClaimStatus.open || c.status == ClaimStatus.rejected)) {
      final String word = c.status == ClaimStatus.rejected
          ? 'Send again'
          : claimWord(c);
      status = Semantics(
        link: true,
        label: '$word: ${c.title}',
        excludeSemantics: true,
        child: InkWell(
          onTap: () => unawaited(context.push(route)),
          borderRadius: ZaveRadius.pillBr,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: ZaveSpace.minTapTarget,
            ),
            child: Center(
              widthFactor: 1,
              child: Text(word.toUpperCase(), style: _statusStyle(colour)),
            ),
          ),
        ),
      );
    } else {
      status = Text(claimWord(c).toUpperCase(), style: _statusStyle(colour));
    }
    return _TaskRow(
      chip: chip,
      title: c.title,
      reason: c.status == ClaimStatus.rejected ? c.rejectReason : null,
      status: status,
    );
  }

  static TextStyle _statusStyle(Color colour) => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: colour,
    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
  );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.chip,
    required this.title,
    required this.status,
    this.now = false,
    this.reason,
  });

  final String chip;
  final String title;
  final Widget status;

  /// One of today's: the chip lights up.
  final bool now;

  /// Why it was sent back, in red under the title.
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: now ? ContestColors.peri : const Color(0x12FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              chip.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.88,
                color: now ? ContestColors.ink : ZaveColors.ink62,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: ZaveType.label.copyWith(
                    fontSize: 14,
                    color: ZaveColors.ink85,
                  ),
                ),
                if (reason case final String why when why.isNotEmpty)
                  Text(
                    why,
                    style: ZaveType.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ContestColors.wrongText,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          status,
        ],
      ),
    );
  }
}
