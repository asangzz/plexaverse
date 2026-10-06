import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/engagement/top_voice_categories.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/engagement_controllers.dart';
import '../../domain/engagement_repository.dart';

/// Today's curated posts — one at a time.
///
/// ## Why one and not a list
///
/// The job here is not browsing, it is doing: read this post, take this
/// comment, go and post it. A list of five invites skimming and leaves the
/// person deciding which to start with, five times over. One card removes that
/// decision and makes the progress obvious. The web section this ports makes
/// the same argument.
///
/// ## Why the post looks like a LinkedIn post
///
/// The user is about to land on the real thing. Showing it in the shape they
/// will see it in means they recognise it on arrival instead of scanning a
/// feed for a summary they half-remember.
///
/// The whole day arrives in one request and is generated once, so stepping
/// back and forth through the five costs nothing.
class TopVoicesSection extends ConsumerStatefulWidget {
  const TopVoicesSection({super.key});

  @override
  ConsumerState<TopVoicesSection> createState() => _TopVoicesSectionState();
}

class _TopVoicesSectionState extends ConsumerState<TopVoicesSection> {
  int _index = 0;

  /// Seeded once, at the first post still outstanding.
  ///
  /// After that the arrows are the user's. Re-deriving on every rebuild would
  /// yank the card out from under someone who stepped back to re-read one they
  /// had already done.
  bool _seeded = false;

  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TopVoiceDay> day = ref.watch(topVoicesControllerProvider);

    return day.when(
      loading: () => const _CuratedSkeleton(),
      // Quiet, and deliberately not the blocking error the generated half
      // shows. This is one of two ways to make the day's ten; losing it should
      // cost the user this section, not the screen.
      error: (Object error, StackTrace _) => _CuratedUnavailable(
        failure: error,
        onRetry: () => ref.invalidate(topVoicesControllerProvider),
      ),
      data: (TopVoiceDay value) {
        if (value.isEmpty) {
          return _CuratedEmpty(hasCategories: value.hasCategories);
        }

        if (!_seeded) {
          _index = value.firstOutstanding;
          _seeded = true;
        }
        final int index = _index.clamp(0, value.posts.length - 1);
        final TopVoice post = value.posts[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Header(done: value.actedCount, total: value.posts.length),
            SizedBox(height: ZaveSpace.lg),
            _PostCard(post: post),
            SizedBox(height: ZaveSpace.lg),
            if (post.hasComment) ...<Widget>[
              _DraftBlock(comment: post.comment!),
              SizedBox(height: ZaveSpace.lg),
            ] else ...<Widget>[
              const _NoDraftNote(),
              SizedBox(height: ZaveSpace.lg),
            ],
            _Actions(post: post, copied: _copied, onAct: () => _act(post)),
            SizedBox(height: ZaveSpace.lg),
            _Pager(
              index: index,
              posts: value.posts,
              onPick: (int i) => setState(() {
                _index = i;
                _copied = false;
              }),
            ),
          ],
        );
      },
    );
  }

  /// Copy the draft, stamp the post, hand off to LinkedIn.
  ///
  /// Clipboard FIRST. The next thing the user does is paste, and a hand-off
  /// that failed to open must not also cost them the text they were about to
  /// paste — which is also why this uses [openLinkKeepingClipboard] rather
  /// than the copy-the-url fallback: that one would overwrite the comment with
  /// a link to the page they are already looking at.
  Future<void> _act(TopVoice post) async {
    if (post.hasComment) {
      await Clipboard.setData(ClipboardData(text: post.comment!));
      if (mounted) setState(() => _copied = true);
    }

    // Stamped on open, not on return. Opening the post to comment is the last
    // thing this app can observe before the user leaves for LinkedIn, and it
    // is what `TopVoiceShown.actedAt` is documented to mean.
    await ref
        .read(topVoicesControllerProvider.notifier)
        .markActed(post.shownId);

    if (post.postUrl.isNotEmpty) {
      await openLinkKeepingClipboard(ref, post.postUrl);
    }

    // Step forward to the next one still outstanding, so the user comes back
    // from LinkedIn to the next piece of work rather than to the one they
    // just finished.
    final TopVoiceDay? day = ref.read(topVoicesControllerProvider).value;
    if (day == null || !mounted) return;
    final int next = day.posts.indexWhere((TopVoice p) => !p.isActed);
    if (next != -1) setState(() => _index = next);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(child: Text('TODAY’S TOP VOICES', style: ZaveType.kicker)),
      ZavePill(
        label: '$done/$total${done == total ? ' ✓' : ''}',
        color: done == total ? ZaveColors.green : ZaveColors.amber,
      ),
    ],
  );
}

/// The post, in the shape the user will meet it in.
class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final TopVoice post;

  @override
  Widget build(BuildContext context) {
    final String age = post.age();

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40.r,
                width: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ZaveFill.rest,
                  border: Border.all(color: ZaveColors.rule),
                ),
                child: Text(post.initials, style: ZaveType.label),
              ),
              SizedBox(width: ZaveSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      post.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ZaveType.label,
                    ),
                    Text(
                      <String>[
                        if (post.authorHandle.isNotEmpty) post.authorHandle,
                        if (age.isNotEmpty) age,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ZaveType.caption,
                    ),
                  ],
                ),
              ),
              // Only the dot here. The category is a long free-text label —
              // "Corporate Social Responsibility" is thirty characters — and
              // it was overflowing this row against the author's name. It is
              // also not what the user is reading for: it explains why the
              // post was picked, which belongs under the post, not over it.
              if (post.isActed) const ZaveDot(ZaveColors.green),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          Text(post.postContent, style: ZaveType.body),
          if (post.category.isNotEmpty) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Text(
              'Picked for ${topVoiceCategoryLabel(post.category)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ZaveType.caption,
            ),
          ],
        ],
      ),
    );
  }
}

/// What Plexa wrote for this post.
class _DraftBlock extends StatelessWidget {
  const _DraftBlock({required this.comment});

  final String comment;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('YOUR COMMENT', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.sm),
      Container(
        width: double.infinity,
        padding: ZaveSpace.rowPad,
        decoration: BoxDecoration(
          gradient: ZaveFill.rest,
          border: ZaveEdgeBorder(
            gradient: ZaveEdge.rest,
            highlight: ZaveEdge.bevel,
          ),
          borderRadius: ZaveRadius.cardSmBr,
        ),
        child: Text(comment, style: ZaveType.body),
      ),
    ],
  );
}

/// The batch wrote this row and the model gave nothing back for it.
///
/// The pick is still the user's for today — dropping it would hand them the
/// same post tomorrow and charge for it twice — so the card renders, says why
/// there is no draft, and still lets them go and write their own.
class _NoDraftNote extends StatelessWidget {
  const _NoDraftNote();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Icon(AppIcons.info, size: 14.sp, color: ZaveColors.ink45),
      SizedBox(width: ZaveSpace.sm),
      Expanded(
        child: Text(
          'No draft came back for this one — it is still yours for today, so '
          'open it and write your own.',
          style: ZaveType.caption,
        ),
      ),
    ],
  );
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.post,
    required this.copied,
    required this.onAct,
  });

  final TopVoice post;
  final bool copied;
  final VoidCallback onAct;

  @override
  Widget build(BuildContext context) => ZaveButton.primary(
    // The label names BOTH halves of what the tap does, because the clipboard
    // write is invisible and a user who does not know it happened will type
    // the comment out again on the other side.
    label: post.hasComment
        ? (copied ? 'Copied — open the post' : 'Copy and open')
        : 'Open the post',
    icon: Icon(copied ? AppIcons.check : AppIcons.linkedin),
    expand: true,
    onPressed: onAct,
  );
}

/// Five dots and two arrows. Position, and what is left.
class _Pager extends StatelessWidget {
  const _Pager({
    required this.index,
    required this.posts,
    required this.onPick,
  });

  final int index;
  final List<TopVoice> posts;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      ZaveIconButton(
        icon: const Icon(AppIcons.chevronLeft),
        tooltip: 'Previous post',
        onPressed: index > 0 ? () => onPick(index - 1) : null,
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < posts.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: ZaveSpace.sm),
              GestureDetector(
                onTap: () => onPick(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  // The dot is 8pt; the tap target around it is not.
                  padding: EdgeInsets.symmetric(vertical: ZaveSpace.md),
                  child: Container(
                    height: 8.r,
                    width: i == index ? 20.r : 8.r,
                    decoration: BoxDecoration(
                      color: posts[i].isActed
                          ? ZaveColors.green
                          : (i == index ? ZaveColors.white : ZaveColors.rule),
                      borderRadius: ZaveRadius.pillBr,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      ZaveIconButton(
        icon: const Icon(AppIcons.chevronRight),
        tooltip: 'Next post',
        onPressed: index < posts.length - 1 ? () => onPick(index + 1) : null,
      ),
    ],
  );
}

/// Nothing picked today — and the two reasons need different answers.
class _CuratedEmpty extends StatelessWidget {
  const _CuratedEmpty({required this.hasCategories});

  /// False only when the user has never opened the subject picker.
  final bool hasCategories;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('TODAY’S TOP VOICES', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        Text(
          hasCategories
              // Not fixable from here, so it does not pretend to be. The
              // niche drafts below still make the day.
              ? 'Nothing new in your subjects today. The comments below still '
                    'count toward the day.'
              : 'Pick the subjects you work in and five curated posts land '
                    'here every morning, each with a comment already written.',
          style: ZaveType.bodyMuted,
        ),
        if (!hasCategories) ...<Widget>[
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Choose subjects',
              trailing: const Icon(AppIcons.chevronRight),
              onPressed: () => context.push(ZaveRoutes.settings),
            ),
          ),
        ],
      ],
    ),
  );
}

class _CuratedUnavailable extends StatelessWidget {
  const _CuratedUnavailable({required this.failure, required this.onRetry});

  final Object failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Object f = failure;
    final bool noXp =
        f is EngagementFailure && f.kind == EngagementBlock.insufficientXp;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('TODAY’S TOP VOICES', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(
            noXp
                ? 'Today’s curated posts need more XP than you have. The '
                      'comments below are already written and still count.'
                : 'Could not load today’s curated posts. The comments below '
                      'still count toward the day.',
            style: ZaveType.bodyMuted,
          ),
          if (!noXp) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: ZaveButton(
                label: 'Try again',
                icon: const Icon(AppIcons.refresh),
                onPressed: onRetry,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CuratedSkeleton extends StatelessWidget {
  const _CuratedSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('TODAY’S TOP VOICES', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.lg),
      ZaveCard(
        child: SizedBox(
          height: 150.h,
          child: Center(
            child: SizedBox(
              height: 18.r,
              width: 18.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    ],
  );
}
