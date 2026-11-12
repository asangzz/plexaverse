import 'package:flutter/material.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';
import '../../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../../domain/contest_repository.dart';
import '../../../domain/contest_words.dart';
import '../contest_kit.dart';
import 'feed_words.dart';
import 'sent_links.dart';

/// Today's five are in: what they paid, the links, and the rule they are
/// held to. The web's `Done`.
class FeedCommentsDone extends StatelessWidget {
  const FeedCommentsDone({
    required this.view,
    required this.links,
    required this.paid,
    this.linkPoints,
    super.key,
  });

  final FeedCommentsView view;
  final List<String> links;
  final List<int>? linkPoints;

  /// What the day paid, as far as this screen knows.
  final int paid;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Today’s comments are in',
      container: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const ContestDot(
                          tone: ContestTone.live,
                          label: 'Today’s comments are in',
                        ),
                        SizedBox(height: ZaveSpace.sm),
                        if (paid > 0)
                          XpTag(points: paid)
                        else
                          // Paid nothing: paused scoring only if the task is
                          // worth points at all.
                          Text(
                            view.points > 0
                                ? 'Recorded. Contest scoring is paused for you, so no XP was added.'
                                : 'Recorded.',
                            style: ContestType.meta,
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ZaveSpace.lg),
                const QuizPlexa(
                  take: 'feed-comments-done',
                  mood: QuizMood.correct,
                  react: true,
                  height: 88,
                ),
              ],
            ),
            if (links.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xl),
              SentLinks(links: links, points: linkPoints),
            ],
            SizedBox(height: ZaveSpace.xl),
            Text(feedWarningLine(view.penalty), style: ContestType.meta),
            SizedBox(height: 6.h),
            Text(
              'Five new comments count on each day the contest runs.',
              style: ContestType.meta,
            ),
            SizedBox(height: ZaveSpace.xl),
            const Divider(height: 1, thickness: 1, color: ZaveColors.rule),
            SizedBox(height: ZaveSpace.xl),
            const NextLevelPill(from: PathNodeKind.feedComments),
          ],
        ),
      ),
    );
  }
}

/// The day was audited and found false: what was taken, and why. Final — a
/// removed day takes no more links. The web's `Revoked`.
class FeedCommentsRevoked extends StatelessWidget {
  const FeedCommentsRevoked({required this.view, super.key});

  final FeedCommentsView view;

  @override
  Widget build(BuildContext context) {
    final int deducted = view.pointsDeducted ?? 0;
    final String? reason = view.revokeReason;
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            liveRegion: true,
            child: const ContestDot(
              tone: ContestTone.wrong,
              label: 'Removed after review',
            ),
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            '${reason != null && reason.isNotEmpty ? 'Removed: $reason' : 'Our team found these were not genuine comments.'}'
            '${deducted > 0 ? ' — ${contestXp(-deducted)}' : ''}',
            style: ZaveType.body.copyWith(
              fontSize: 15.sp,
              color: ZaveColors.ink85,
            ),
          ),
          if (view.links.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            SentLinks(links: view.links),
          ],
          SizedBox(height: ZaveSpace.md),
          Text(
            'Other days of the contest count as usual.',
            style: ContestType.meta,
          ),
        ],
      ),
    );
  }
}

/// "Why every day" — modest, true, and nothing promised.
class FeedWhyPanel extends StatelessWidget {
  const FeedWhyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text('Why every day', style: ContestType.cardTitle),
          ),
          SizedBox(height: ZaveSpace.md),
          const _Bullets(items: kFeedWhyPoints),
        ],
      ),
    );
  }
}

/// "What counts as valuable" — and what does not.
class FeedCountsPanel extends StatelessWidget {
  const FeedCountsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle body = ZaveType.body.copyWith(
      fontSize: 15.sp,
      color: ZaveColors.ink85,
    );
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            header: true,
            child: Text(
              'What counts as valuable',
              style: ContestType.cardTitle,
            ),
          ),
          SizedBox(height: ZaveSpace.md),
          Text('A valuable comment adds something to the post:', style: body),
          SizedBox(height: ZaveSpace.sm),
          const _Bullets(items: kFeedCountsPoints),
          SizedBox(height: ZaveSpace.md),
          Text(kFeedNotCountsLine, style: ContestType.meta),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = ZaveType.body.copyWith(
      fontSize: 15.sp,
      height: 1.55,
      color: ZaveColors.ink85,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ZaveSpace.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ExcludeSemantics(child: Text('•', style: style)),
              SizedBox(width: ZaveSpace.sm),
              Expanded(child: Text(items[i], style: style)),
            ],
          ),
        ],
      ],
    );
  }
}
