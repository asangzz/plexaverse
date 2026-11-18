import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../application/contest_controllers.dart';
import '../../application/feed_comments_controllers.dart';
import '../../domain/contest_repository.dart';
import '../widgets/comment/task_sheet.dart';
import '../widgets/contest_kit.dart';
import '../widgets/skip_level.dart';
import '../widgets/feed/feed_comment_form.dart';
import '../widgets/feed/feed_panels.dart';
import '../widgets/feed/feed_words.dart';

/// **Post 5 valuable comments** — the web's `/contest/feed-comments`.
///
/// Every day: five comments on posts in the learner's own LinkedIn feed, the
/// link to each pasted here AS THEY GO — one at a time (owner, 11 Nov 2026).
/// Each pays its share of the day's total the moment it is sent.
///
/// ## What is trusted, and what is checked
///
/// LinkedIn tells us nothing back, so each link is paid on trust and an admin
/// audits the day after. A link that is not the learner's own comment, or a
/// comment that is not genuine, is revoked: the XP taken back and the
/// penalty deducted on top. The page says so plainly, with the real numbers,
/// BEFORE the send button.
///
/// ## The path first
///
/// The task's read is pure, so it goes out at once — but the form waits for
/// the path too: a locked level must not open sendable, then jump to "Not
/// open yet".
class ContestFeedCommentsPage extends ConsumerWidget {
  const ContestFeedCommentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(contestResumeRefreshProvider);
    final AsyncValue<FeedCommentsView> read = ref.watch(feedCommentsProvider);
    final TodayLock lock = ref.watch(
      todayLockProvider(PathNodeKind.feedComments),
    );
    final FeedCommentsView? view = read.value;

    if (read.hasError && !read.isLoading && view == null) {
      return TaskSheet(
        children: <Widget>[
          const BackToPath(),
          TaskLoadError(
            title: 'Could not load today’s task',
            message: contestMessage(read.error!),
            onRetry: () => ref.invalidate(feedCommentsProvider),
          ),
        ],
      );
    }
    if (view == null || lock.pending) return const _FeedSkeleton();

    final FeedCommentsNow now = effectiveFeed(
      view,
      ref.watch(
        feedCommentsActionsProvider.select((FeedCommentsSend s) => s.last),
      ),
    );
    final String? locked = lock.locked;
    final bool open = now.status == FeedCommentsStatus.open && locked == null;

    final Widget body = switch (view.status) {
      FeedCommentsStatus.unavailable => Text(
        feedUnavailableLine(view.reason),
        style: ContestType.meta,
      ),
      _ when now.status == FeedCommentsStatus.done => FeedCommentsDone(
        view: view,
        links: now.links,
        linkPoints: now.linkPoints,
        paid: now.pointsApplied ?? 0,
      ),
      FeedCommentsStatus.revoked => FeedCommentsRevoked(view: view),
      _ when locked != null => LockedNotice(detail: locked),
      _ => FeedCommentForm(
        view: view,
        sent: now.links,
        linkPoints: now.linkPoints,
      ),
    };

    return TaskSheet(
      gap: 32,
      children: <Widget>[
        const BackToPath(),
        TaskSheetHeader(
          eyebrow: kFeedEyebrow,
          title: 'Post 5 valuable comments',
          points: view.status == FeedCommentsStatus.revoked ? 0 : view.points,
          lead:
              'Open your LinkedIn feed and leave ${view.perDay} comments that add something to the posts there. Paste the link to each one here as you go, one at a time.',
          beside: open
              ? const QuizPlexa(take: 'feed-comments', mood: QuizMood.inspect)
              : null,
        ),
        if (open)
          Align(
            alignment: Alignment.centerLeft,
            child: ContestGhostPill(
              label: 'Open your LinkedIn feed',
              trailing: AppIcons.openExternal,
              onPressed: () => openLinkAndReport(context, ref, kFeedUrl),
            ),
          ),
        body,
        if (open) const ContestSkipLevel(kind: PathNodeKind.feedComments),
        // The form first, so the field is in reach; the why and the bar
        // for "valuable" follow it.
        if (open) ...const <Widget>[FeedWhyPanel(), FeedCountsPanel()],
      ],
    );
  }
}

/// The sheet's shape while the task and the path are read. The way back is
/// the real one. The web's `SheetSkeleton variant="feed"`.
class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return TaskSheet(
      gap: 32,
      children: <Widget>[
        const BackToPath(),
        Semantics(
          label: 'Loading today’s task',
          liveRegion: true,
          child: ZaveShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ZaveSkeleton.bar(height: 14.h, width: 180.w),
                          SizedBox(height: ZaveSpace.md),
                          ZaveSkeleton.block(height: 34.h, widthFactor: 0.8),
                          SizedBox(height: ZaveSpace.md),
                          ZaveSkeleton.bar(height: 16.h),
                          SizedBox(height: ZaveSpace.sm),
                          ZaveSkeleton.bar(height: 16.h, widthFactor: 0.7),
                        ],
                      ),
                    ),
                    SizedBox(width: ZaveSpace.lg),
                    ZaveSkeleton.block(width: 86.r, height: 96.r),
                  ],
                ),
                SizedBox(height: 32.h),
                ZaveSkeleton.block(height: 44.h, width: 240.w),
                SizedBox(height: 32.h),
                ZaveSkeleton.block(height: 180.h),
                SizedBox(height: 32.h),
                ZaveSkeleton.block(height: 150.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
