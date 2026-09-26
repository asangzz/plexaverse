import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/calendar_month.dart';
import '../../domain/calendar_post.dart';
import '../calendar_status_ui.dart';

/// The pending backlog — drafts and missed approvals.
///
/// ## Departure: a horizontal strip, not a fixed column
///
/// The web renders this as `PendingRail`, a 320–384px column pinned to the left
/// of the grid and hidden below `lg`. A phone has no room for a second column,
/// and the web's own phone fallback is a floating "N pending" button that opens
/// a modal list — a surface the user has to go and find.
///
/// This is a horizontally-scrolling strip above the grid instead: the backlog
/// stays visible next to the calendar it is meant to be moved into, which is
/// the whole point of the rail, without stealing width from the grid.
///
/// The web's two groups are kept (missed approvals first, then drafts) because
/// they mean different things — one is a deadline that slipped, the other is
/// work that was never queued.
class CalendarPendingStrip extends StatelessWidget {
  const CalendarPendingStrip({
    required this.pending,
    required this.onPick,
    super.key,
  });

  final List<CalendarPost> pending;

  /// The user wants to put this post on a day. The page takes it from here.
  final ValueChanged<CalendarPost> onPick;

  @override
  Widget build(BuildContext context) {
    final List<CalendarPost> missed = pending
        .where(
          (CalendarPost p) => p.status == CalendarPostStatus.pendingApproval,
        )
        .toList(growable: false);
    final List<CalendarPost> drafts = pending
        .where((CalendarPost p) => p.status == CalendarPostStatus.draft)
        .toList(growable: false);

    if (missed.isEmpty && drafts.isEmpty) {
      return const _PendingEmpty();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (missed.isNotEmpty)
          _PendingGroup(
            title: 'Missed approvals',
            // The web says "Drag onto a date to reschedule". There is no drag
            // here, so the hint names the gesture that does exist.
            hint: 'Tap to pick a day',
            tone: ZaveColors.amber,
            posts: missed,
            onPick: onPick,
          ),
        if (missed.isNotEmpty && drafts.isNotEmpty)
          SizedBox(height: ZaveSpace.xl),
        if (drafts.isNotEmpty)
          _PendingGroup(
            title: 'Drafts',
            hint: 'Tap to pick a day',
            tone: ZaveColors.ink35,
            posts: drafts,
            onPick: onPick,
          ),
      ],
    );
  }
}

class _PendingGroup extends StatelessWidget {
  const _PendingGroup({
    required this.title,
    required this.hint,
    required this.tone,
    required this.posts,
    required this.onPick,
  });

  final String title;
  final String hint;
  final Color tone;
  final List<CalendarPost> posts;
  final ValueChanged<CalendarPost> onPick;

  @override
  Widget build(BuildContext context) {
    // A card wide enough to read two lines of a post at a glance, and narrow
    // enough that the next one peeks in — which is what tells the user the
    // strip scrolls at all.
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.62;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ZaveDot(tone),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text(title.toUpperCase(), style: ZaveType.kicker)),
            Text(hint, style: ZaveType.caption),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < posts.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: ZaveSpace.md),
                  SizedBox(
                    width: cardWidth,
                    child: _PendingCard(
                      post: posts[i],
                      onTap: () => onPick(posts[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.post, required this.onTap});

  final CalendarPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ({Color color, String label, String description}) signal =
        calendarSignal(post.status);

    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZaveDot(signal.color),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  signal.label,
                  style: ZaveType.caption.copyWith(color: signal.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            truncate(post.displayText, 110),
            style: ZaveType.bodyMuted,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// "All caught up" — the web's own empty state for the rail.
class _PendingEmpty extends StatelessWidget {
  const _PendingEmpty();

  @override
  Widget build(BuildContext context) => ZaveCard(
    size: ZaveCardSize.small,
    padding: ZaveSpace.rowPad,
    child: Row(
      children: <Widget>[
        const ZaveDot(ZaveColors.green),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('All caught up', style: ZaveType.label),
              SizedBox(height: ZaveSpace.xs),
              Text('No drafts or missed approvals.', style: ZaveType.caption),
            ],
          ),
        ),
      ],
    ),
  );
}
