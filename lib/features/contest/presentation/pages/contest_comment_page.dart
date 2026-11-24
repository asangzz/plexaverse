import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/quiz_plexa.dart';
import '../../application/comment_level_controllers.dart';
import '../../application/contest_controllers.dart';
import '../../domain/contest_repository.dart';
import '../widgets/comment/blank_comment.dart';
import '../widgets/comment/comment_chrome.dart';
import '../widgets/comment/comment_words.dart';
import '../widgets/comment/task_sheet.dart';
import '../widgets/comment/word_bank.dart';
import '../widgets/contest_kit.dart';
import '../widgets/skip_level.dart';

/// **The daily comment level** — the web's `/contest/comment`.
///
/// A real post by a top voice in the learner's field, and a comment on it
/// with three to five words missing. The words wait in a bank below, with
/// three that fit nowhere. Check grades the whole sequence: right first time
/// pays the level; a miss shows the right words and loses the day's XP, but
/// the learner can still finish — the comment is theirs to post either way.
/// Once it is right, "Comment on LinkedIn" copies it and opens the post. We
/// never post it for them.
///
/// ## The path first
///
/// The level's read writes the day's row and may spend a model call, and the
/// server does not gate it, so nothing is read until the path says the level
/// is open — `CommentLevelController`. Until the path answers, this shows
/// the skeleton; a level the path shows locked shows "Not open yet" without
/// a request.
///
/// ## The answers are the server's
///
/// No file here compares a pick with a right word. The bank arrives without
/// its key, and the right words reach the phone only in a submission's
/// answer, blank by blank.
class ContestCommentPage extends ConsumerWidget {
  const ContestCommentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Back from LinkedIn, the gate and the standing are read again.
    ref.watch(contestResumeRefreshProvider);
    final AsyncValue<CommentLevelState> read = ref.watch(
      commentLevelControllerProvider,
    );

    if (read.hasError && !read.isLoading) {
      return TaskSheet(
        children: <Widget>[
          const BackToPath(),
          TaskLoadError(
            title: 'Could not load the comment level',
            message: contestMessage(read.error!),
            onRetry: () => ref.invalidate(commentLevelControllerProvider),
          ),
        ],
      );
    }

    return switch (read.value) {
      null || CommentLevelWaiting() => const _CommentSkeleton(),
      CommentLevelLocked(:final String detail) => TaskSheet(
        children: <Widget>[
          const BackToPath(),
          const TaskSheetHeader(
            eyebrow: kCommentEyebrow,
            title: 'Comment on a top voice',
          ),
          LockedNotice(detail: detail),
        ],
      ),
      CommentLevelReady(:final CommentLevelView level) =>
        level.status == CommentLevelStatus.done && level.comment != null
            ? _Done(level: level)
            : _playable(level)
            ? _Player(level: level)
            : _Unavailable(level: level),
    };
  }

  static bool _playable(CommentLevelView level) =>
      level.status == CommentLevelStatus.open &&
      (level.template?.isNotEmpty ?? false) &&
      (level.blankCount ?? 0) > 0 &&
      level.bank.isNotEmpty;
}

/// No level to play today, and why — in the web's words.
class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.level});

  final CommentLevelView level;

  @override
  Widget build(BuildContext context) {
    final CommentUnavailableWords words = commentUnavailableWords(level.reason);
    return TaskSheet(
      children: <Widget>[
        const BackToPath(),
        TaskSheetHeader(
          eyebrow: kCommentEyebrow,
          title: words.title,
          lead: words.line,
        ),
        if (level.reason == CommentLevelReason.notJoined)
          Align(
            alignment: Alignment.centerLeft,
            child: ContestGhostPill(
              label: 'Open your levels',
              onPressed: () => context.go(ZaveRoutes.contest),
            ),
          ),
      ],
    );
  }
}

/// The word-bank player, full screen.
class _Player extends ConsumerWidget {
  const _Player({required this.level});

  final CommentLevelView level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommentPlay play = ref.watch(commentLevelActionsProvider);
    final CommentLevelActions actions = ref.read(
      commentLevelActionsProvider.notifier,
    );
    final int blankCount = level.blankCount ?? 0;
    final CommentSubmitResult? graded = play.graded;
    // Gone if the day's first try already missed, or this one was it.
    final bool firstTryGone =
        level.firstTry == CommentFirstTry.wrong || (graded?.firstTry ?? false);
    final String? error = play.error;

    return Scaffold(
      backgroundColor: kCommentPlayerGround,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            CommentPlayerHeader(
              progress: blankCount == 0 ? 0 : play.filled / blankCount,
              onQuit: () => context.go(ZaveRoutes.contest),
            ),
            Expanded(
              // A column, not a lazy list: the picks live in the
              // controller, but the bank must never be torn down mid-tap.
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Expanded(child: _PlayerTitle()),
                        SizedBox(width: ZaveSpace.lg),
                        QuizPlexa(
                          take: graded != null ? 'comment-wrong' : 'comment',
                          mood: graded != null
                              ? QuizMood.wrong
                              : QuizMood.inspect,
                        ),
                      ],
                    ),
                    SizedBox(height: ZaveSpace.xl),
                    if (level.post case final CommentPost post) ...<Widget>[
                      CommentPostCard(
                        author: post.author,
                        firstLine: post.firstLine,
                      ),
                      SizedBox(height: ZaveSpace.xl),
                    ],
                    if (level.firstTry == CommentFirstTry.wrong &&
                        graded == null) ...<Widget>[
                      Text(kFirstTryMissedNote, style: ContestType.meta),
                      SizedBox(height: ZaveSpace.xl),
                    ],
                    BlankComment(
                      parts: splitTemplate(level.template ?? '', blankCount),
                      words: <String?>[
                        for (final int? i in play.slots)
                          i == null ? null : level.bank[i],
                      ],
                      verdicts: graded?.blanks,
                      onTakeBack: play.frozen ? null : actions.takeBack,
                    ),
                    SizedBox(height: ZaveSpace.xl),
                    WordBank(
                      bank: level.bank,
                      used: play.used,
                      onPick: play.frozen ? null : actions.place,
                    ),
                    // The current level can be skipped (17 Nov 2026); it
                    // stays open today.
                    const ContestSkipLevel(kind: PathNodeKind.comment),
                    if (error != null) ...<Widget>[
                      SizedBox(height: ZaveSpace.xl),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          error,
                          style: ContestType.meta.copyWith(
                            fontSize: 13.sp,
                            color: ContestColors.wrongText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            CommentResultBar(
              missLine: graded == null
                  ? null
                  : (firstTryGone ? kWrongLine : kFixLine),
              busy: play.busy,
              canCheck: play.full && !play.busy,
              onCheck: actions.check,
              onTryAgain: actions.tryAgain,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerTitle extends StatelessWidget {
  const _PlayerTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          kCommentEyebrow.toUpperCase(),
          style: ContestType.kicker.copyWith(
            fontSize: 11.sp,
            letterSpacing: 0.14 * 11.sp,
            color: ZaveColors.ink35,
          ),
        ),
        SizedBox(height: ZaveSpace.xs),
        Semantics(
          header: true,
          child: Text(
            'Complete the comment',
            style: ContestType.sectionTitle.copyWith(fontSize: 22.sp),
          ),
        ),
        SizedBox(height: ZaveSpace.xs),
        Text(
          'Tap the words in order to fill the blanks.',
          style: ContestType.meta,
        ),
      ],
    );
  }
}

/// The finished comment: copy it, open the post, back to the path.
class _Done extends ConsumerWidget {
  const _Done({required this.level});

  final CommentLevelView level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommentPlay play = ref.watch(commentLevelActionsProvider);
    final CommentLevelActions actions = ref.read(
      commentLevelActionsProvider.notifier,
    );
    final String comment = level.comment ?? '';
    final String? url = commentPostUrl(level);
    final CommentHandOff handOff = play.handOff;
    final bool refused = handOff == CommentHandOff.refused;
    final int? paid = level.pointsApplied;

    /// Copied and on its way to LinkedIn: the level is finished, so the app
    /// goes back to the path (the owner's call, 11 Nov 2026). Not when the
    /// copy was refused — the comment is still needed on screen.
    Future<void> act() async {
      final CommentHandOff outcome = await actions.handOff();
      if (outcome == CommentHandOff.copied && context.mounted) {
        context.go(ZaveRoutes.contest);
      }
    }

    /// After a failed open the comment is already on the clipboard, so the
    /// post opening now finishes the level as the pill would have. After a
    /// refused copy it only opens the post.
    Future<void> openPost() async {
      final bool opened = await actions.openPost();
      if (opened && handOff == CommentHandOff.notOpened && context.mounted) {
        context.go(ZaveRoutes.contest);
      }
    }

    return TaskSheet(
      gap: 32,
      children: <Widget>[
        const TaskSheetHeader(
          eyebrow: '$kCommentEyebrow · done',
          title: 'Your comment is ready',
          lead: 'Post it under the original, in your own name.',
          beside: QuizPlexa(
            take: 'comment-done',
            mood: QuizMood.correct,
            react: true,
            height: 112,
          ),
        ),
        if (level.post case final CommentPost post)
          CommentPostCard(author: post.author, firstLine: post.firstLine),
        ContestPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Your comment', style: ContestType.meta),
              SizedBox(height: ZaveSpace.md),
              // Once a copy is refused the plain sentence is shown, ready to
              // select and copy by hand.
              if (!refused &&
                  level.template != null &&
                  level.answers.isNotEmpty)
                FinishedComment(
                  parts: splitTemplate(level.template!, level.answers.length),
                  answers: level.answers,
                  comment: comment,
                )
              else
                SelectableText(
                  comment,
                  style: ZaveType.body.copyWith(
                    fontSize: 16.sp,
                    height: 1.7,
                    color: ZaveColors.white,
                  ),
                ),
              if (paid != null && paid != 0) ...<Widget>[
                SizedBox(height: ZaveSpace.md),
                XpTag(points: paid),
              ],
              if (level.firstTry == CommentFirstTry.wrong) ...<Widget>[
                SizedBox(height: ZaveSpace.md),
                Text(kNoXpTodayLine, style: ContestType.meta),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContestPrimaryPill(
              label: 'Comment on LinkedIn',
              // It copies, then opens: the web's pill shows both.
              leading: AppIcons.copy,
              trailing: AppIcons.openExternal,
              busy: play.busy,
              onPressed: act,
            ),
            if (_statusLine(handOff) case final String line) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Semantics(
                liveRegion: true,
                child: Text(line, style: ContestType.meta),
              ),
            ],
            if ((refused || handOff == CommentHandOff.notOpened) &&
                url != null) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              ContestGhostPill(
                label: 'Open post',
                trailing: AppIcons.openExternal,
                onPressed: openPost,
              ),
            ],
            if (url == null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Text(
                'The post’s link is not available, so open it from your LinkedIn feed.',
                style: ContestType.meta,
              ),
            ],
          ],
        ),
        const BackToPath(),
      ],
    );
  }

  static String? _statusLine(CommentHandOff handOff) => switch (handOff) {
    CommentHandOff.idle => null,
    CommentHandOff.copied => kCopiedLine,
    CommentHandOff.refused =>
      'Your phone did not let us copy it. The comment is above — select it and copy it yourself, then open the post.',
    CommentHandOff.notOpened =>
      '$kCopiedLine. LinkedIn did not open — open the post below.',
  };
}

/// The player's shape while the level is read — and while the path decides
/// whether it may be. The ✕ is the real one: a slow open must never leave
/// someone without a way back. The web's `CommentSkeleton`.
class _CommentSkeleton extends StatelessWidget {
  const _CommentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCommentPlayerGround,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CommentPlayerHeader(
              progress: 0,
              onQuit: () => context.go(ZaveRoutes.contest),
            ),
            Expanded(
              child: Semantics(
                label: 'Getting today’s post ready',
                liveRegion: true,
                child: ZaveShimmer(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ZaveSkeleton.bar(width: 160.w),
                                SizedBox(height: ZaveSpace.sm),
                                ZaveSkeleton.bar(
                                  height: 22.h,
                                  widthFactor: 0.7,
                                ),
                                SizedBox(height: ZaveSpace.sm),
                                const ZaveSkeleton.bar(widthFactor: 0.55),
                              ],
                            ),
                          ),
                          SizedBox(width: ZaveSpace.lg),
                          ZaveSkeleton.block(width: 86.r, height: 96.r),
                        ],
                      ),
                      SizedBox(height: ZaveSpace.xl),
                      ZaveSkeleton.block(height: 96.h),
                      SizedBox(height: ZaveSpace.xl),
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: <Widget>[
                          for (int i = 0; i < 7; i++)
                            ZaveSkeleton.block(
                              width: (70 + (i * 37) % 50).w,
                              height: 44.h,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
