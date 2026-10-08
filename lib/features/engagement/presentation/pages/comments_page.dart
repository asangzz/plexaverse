import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/links/linkedin.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/week/comment_targets.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/engagement_controllers.dart';
import '../../domain/engagement_repository.dart';
import '../widgets/comment_card.dart';
import '../widgets/engagement_states.dart';
import '../widgets/mission_header.dart';
import '../widgets/top_voices_section.dart';

/// **Comment on posts** — the web's `/comments`, the first of the two daily
/// habits the Season 1 roadmap links to.
///
/// ## What this screen is
///
/// On open it asks the server for the day's comments. There is no topic field
/// and no generate button: the server picks a broad, high-volume topic from the
/// user's niche, writes three comments against it, and stores the batch for the
/// day. Reopening the screen replays that batch for free — which is why the
/// screen can auto-generate on mount without quietly billing a user who came
/// back to finish.
///
/// The user's job is to copy each comment onto a real post in LinkedIn. That
/// last step happens somewhere this app cannot see, so **a comment counts as
/// deployed the moment it is copied** — the same rule the web uses, and the
/// furthest either client can honestly go.
///
/// ## The hand-off, and how it differs from the web's
///
/// The web opens LinkedIn's content search in a side drawer
/// (`LinkedInWebviewPanel`) as soon as a comment is copied. A phone has no
/// room for a drawer and no reason for one: "Copy & open LinkedIn" copies the
/// comment, marks it sent and hands the search to the LinkedIn app, which is
/// the same two steps with the user's own signed-in session instead of ours.
///
/// This screen used to say the app could not do that, because it could not —
/// there was no URL launcher. There is now
/// (`core/platform/link_opening.dart`), and the search URLs are built in
/// `core/links/linkedin.dart`.
///
/// The web also prices a regenerate at 50 XP. The mobile route never forwards
/// the `force` flag that would buy one, so the control renders disabled with
/// the reason attached — see [NewSetUnavailable].
class CommentsPage extends ConsumerWidget {
  const CommentsPage({this.goldenHour = false, this.topic, super.key});

  /// Reached through `?context=golden_hour` — the 60 minutes after the user's
  /// own post went out, when commenting pulls the most reach back to it.
  final bool goldenHour;

  /// Reached through `?topic=` on the same deep link. Normally null, and the
  /// server picks the topic.
  final String? topic;

  /// The web's own default when the roadmap step's description carries no
  /// number, and also what the service generates.
  /// Ten: five curated Top Voices posts plus five from the user's own niche.
  /// Declared in `core/week/comment_targets.dart`, mirroring the web, rather
  /// than written here — it was 3 against a batch of 5, so the bar could not
  /// reach its own total.
  static const int _defaultTarget = dailyCommentTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CommentBatch> batch = ref.watch(
      commentsControllerProvider(topic),
    );
    final AsyncValue<EngagementMission?> mission = ref.watch(
      engagementMissionProvider(ZaveRoutes.comments),
    );
    final AsyncValue<bool> completion = ref.watch(stepCompletionProvider);
    final AsyncValue<TopVoiceDay> topVoices = ref.watch(
      topVoicesControllerProvider,
    );

    // A failed claim is the one thing on this screen the user must be told
    // about: their work is done and the XP did not land.
    ref.listen<AsyncValue<bool>>(stepCompletionProvider, (
      AsyncValue<bool>? previous,
      AsyncValue<bool> next,
    ) {
      if (next.hasError) {
        _say(context, 'That step did not save. Try again.');
      }
    });

    final CommentBatch? data = batch.value;
    final EngagementMission? m = mission.value;
    final TopVoiceDay? curated = topVoices.value;

    // The day is BOTH halves of this screen. Counting only the niche drafts
    // below left the step unfinishable the moment the target became ten: five
    // cards against a bar reading 10, and a Finish that could never enable.
    final int networkSent = data?.sentCount ?? 0;
    final int curatedDone = curated?.actedCount ?? 0;
    final int sent = networkSent + curatedDone;

    final int roadmapTarget = m?.targetCount ?? _defaultTarget;

    // What today can actually produce, which is not always what the roadmap
    // asks for. A user whose subjects are thinly stocked gets fewer than five
    // curated posts, and a target they cannot reach is a step they can never
    // finish — the same failure the old hardcoded 3 was hiding, one layer up.
    //
    // Narrowed only once the picks have landed, so the bar does not flash the
    // wrong number on the way in. Ported from the web's
    // `Math.min(roadmapTarget, topVoicesTotal + NETWORK_COMMENT_BATCH_SIZE)`.
    final int target = curated == null
        ? roadmapTarget
        : reachableCommentTarget(
            roadmapTarget: roadmapTarget,
            curatedTotal: curated.posts.length,
          );

    final bool claimable =
        m != null && !m.isCompleted && data != null && sent >= target;

    return ZaveScaffold(
      largeTitle: 'Comment on posts',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to the roadmap',
        onPressed: () => _leave(context),
      ),
      bottomBar: data == null
          ? null
          : FinishStepBar(
              done: sent,
              total: target,
              unit: 'deployed',
              busy: completion.isLoading,
              note: _barNote(mission: m, sent: sent, target: target),
              onFinish: claimable ? () => _finish(context, ref, m) : null,
            ),
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref
            ..invalidate(engagementProgressProvider)
            ..invalidate(topVoicesControllerProvider)
            ..invalidate(commentsControllerProvider(topic));
          await ref.read(commentsControllerProvider(topic).future);
        },
        child: batch.when(
          loading: () => ZaveScrollView(
            children: <Widget>[
              if (goldenHour) ...<Widget>[
                const GoldenHourBanner(),
                SizedBox(height: ZaveSpace.xl),
              ],
              const EngagementSkeleton(),
            ],
          ),
          error: (Object error, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              _header(m),
              SizedBox(height: ZaveSpace.xl),
              EngagementBlocked(
                failure: _asFailure(error),
                knownXpCost: null,
                onRetry: () =>
                    ref.invalidate(commentsControllerProvider(topic)),
                onGetXp: () => context.push(ZaveRoutes.pricing),
                onCompleteProfile: () => context.push(ZaveRoutes.settings),
              ),
            ],
          ),
          data: (CommentBatch value) =>
              _body(context, ref, value, m, sent, target, topVoices),
        ),
      ),
    );
  }

  Widget _header(EngagementMission? mission) => MissionHeader(
    mission: mission,
    fallbackDescription:
        'Leave helpful comments on recent posts so the right people see your '
        'name before they see your profile.',
  );

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    CommentBatch batch,
    EngagementMission? mission,
    int sent,
    int target,
    AsyncValue<TopVoiceDay> topVoices,
  ) {
    final CommentsController controller = ref.read(
      commentsControllerProvider(topic).notifier,
    );

    return ZaveScrollView(
      children: <Widget>[
        if (goldenHour) ...<Widget>[
          const GoldenHourBanner(),
          SizedBox(height: ZaveSpace.xl),
        ],

        _header(mission),
        SizedBox(height: ZaveSpace.xl),

        if (batch.topic.isNotEmpty) ...<Widget>[
          Text('TODAY’S TOPIC', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(batch.topic, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
        ],

        Text(
          '$sent / $target deployed — copy each comment and post it on '
          'relevant content.',
          style: ZaveType.bodyMuted,
        ),

        SizedBox(height: ZaveSpace.xl),
        // The curated half, ABOVE the generated one, because it is the better
        // work: a real post by a real person, with a comment written against
        // what they actually said. The drafts below are written against a KIND
        // of post, so the user has to go and find one that fits.
        const TopVoicesSection(),
        SizedBox(height: ZaveSpace.xl),
        // A rule, not a heading: the two halves are one habit and one count,
        // and a second heading would read as a second task.
        Container(height: 1, color: ZaveColors.rule),
        if (batch.cached) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          const CachedBatchNote(),
        ],

        SizedBox(height: ZaveSpace.lg),
        NewSetUnavailable(xpCost: batch.xpCost),
        SizedBox(height: ZaveSpace.xl),

        if (batch.isEmpty)
          const _NothingGenerated()
        else
          for (int i = 0; i < batch.comments.length; i++) ...<Widget>[
            CommentCard(
              // Keyed by position: the batch is a fixed-length day's set that
              // is never reordered, and a ValueKey on the text would rebuild
              // the field's controller on every keystroke.
              key: ValueKey<int>(i),
              index: i,
              draft: batch.comments[i],
              onChanged: (String value) => controller.edit(i, value),
              onEditFinished: () => controller.teachEdit(i),
              // Copy AND open, which is one action on the web too
              // (`copyComment` copies, marks sent, then opens the search).
              // The two steps are back to back with nothing between them —
              // the clipboard survives the app switch — so bundling them
              // spends one tap instead of two on a card the user may have
              // scrolled past by then.
              onCopyComment: () async {
                await Clipboard.setData(
                  ClipboardData(text: batch.comments[i].comment),
                );
                controller.markSent(i);
                // The clipboard write is an await, so the tree may be gone.
                if (!context.mounted) return;
                await _openSearch(
                  context,
                  ref,
                  batch,
                  i,
                  clipboardHoldsTheComment: true,
                );
              },
              // Deliberately does NOT mark sent. `markSent` counts toward the
              // mission's target, so scouting the results before committing
              // must not claim credit for a comment not yet left. This is the
              // web's separate `openSearch`, for the same reason.
              onOpenSearch: () => _openSearch(context, ref, batch, i),
            ),
            SizedBox(height: ZaveSpace.md),
          ],

        SizedBox(height: ZaveSpace.lg),
        const HowItWorksCard(
          steps: <String>[
            'Copy & open LinkedIn — the comment goes to your clipboard and '
                'LinkedIn opens on a search for posts about it.',
            'Pick a recent post from an active account.',
            'Paste your comment and post it.',
          ],
          handoff:
              'Find posts opens the same search without copying, so you can '
              'look around before a comment counts as sent.',
        ),
      ],
    );
  }

  /// Why "Finish step" is disabled, when the reason is not obvious.
  String? _barNote({
    required EngagementMission? mission,
    required int sent,
    required int target,
  }) {
    if (mission == null) return 'No step on today’s roadmap to claim.';
    if (mission.isCompleted) return 'Already claimed today.';
    if (sent >= target) return null;
    final int left = target - sent;
    return left == 1
        ? 'Copy one more comment to finish.'
        : 'Copy $left more comments to finish.';
  }

  Future<void> _finish(
    BuildContext context,
    WidgetRef ref,
    EngagementMission mission,
  ) async {
    final bool ok = await ref
        .read(stepCompletionProvider.notifier)
        .complete(mission);
    if (!ok || !context.mounted) return;
    _say(context, '+${mission.xpReward} XP — step complete.');
    _leave(context);
  }

  /// Back to wherever the user came from, which is the roadmap in every real
  /// path into this screen. A deep link straight to `/comments` has nothing to
  /// pop, so it lands on the dashboard — the web's own destination after a
  /// finished step.
  static void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ZaveRoutes.dashboard);
    }
  }

  /// Opens LinkedIn's post search for comment [i].
  ///
  /// Falls back to the batch topic when a draft carries no keywords — the
  /// same `searchKeywords || topic` the web guards with. The server already
  /// substitutes the topic itself, so this is belt and braces.
  static Future<void> _openSearch(
    BuildContext context,
    WidgetRef ref,
    CommentBatch batch,
    int i, {
    bool clipboardHoldsTheComment = false,
  }) async {
    final String keywords = batch.comments[i].searchKeywords.trim().isEmpty
        ? batch.topic
        : batch.comments[i].searchKeywords;
    if (keywords.trim().isEmpty) return;

    final String url = linkedInContentSearchUrl(keywords);

    // After a copy the clipboard holds the comment. `openLinkOrCopy` would
    // replace it with this URL on failure — handing the user a link instead
    // of the words they switched apps to paste.
    if (clipboardHoldsTheComment) {
      final bool opened = await openLinkKeepingClipboard(ref, url);
      if (!opened && context.mounted) {
        _say(context, 'Comment copied. Open LinkedIn and search for it.');
      }
      return;
    }

    final String? problem = await openLinkOrCopy(ref, url);
    if (problem != null && context.mounted) _say(context, problem);
  }

  static void _say(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Anything that is not already a typed refusal is a plain failure.
  static EngagementFailure _asFailure(Object error) =>
      error is EngagementFailure
      ? error
      : const EngagementFailure(EngagementBlock.unavailable);
}

/// The batch came back with nothing in it.
///
/// Rare but real: the model can return a well-formed empty list. Not an error
/// card, because nothing failed and nothing was charged.
class _NothingGenerated extends StatelessWidget {
  const _NothingGenerated();

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ZaveDot(ZaveColors.ink35),
              SizedBox(width: ZaveSpace.sm),
              Text('NOTHING HERE', style: ZaveType.kicker),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Text('No comments came back', style: ZaveType.h3),
          SizedBox(height: ZaveSpace.md),
          Text(
            'Pull down to ask again. Nothing was charged.',
            style: ZaveType.bodyMuted,
          ),
        ],
      ),
    );
  }
}
