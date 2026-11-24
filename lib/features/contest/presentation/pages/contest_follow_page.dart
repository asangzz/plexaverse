import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/links/plexaverse.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/contest_controllers.dart';
import '../../application/follow_winners_controllers.dart';
import '../../domain/contest_repository.dart';
import '../../domain/levels_words.dart';
import '../../domain/linkedin_profile_url.dart';
import '../widgets/contest_kit.dart';
import '../widgets/featured/person_tile.dart';
import '../widgets/sheet/contest_sheet.dart';
import '../widgets/web_link.dart';

/// `/contest/follow` — "Follow last round's top learners" (owner, 24 Nov
/// 2026). The web's `FollowWinners` (`/levels/follow`).
///
/// ## Two steps per top learner
///
///   1. Follow on LinkedIn — opens their public LinkedIn profile in the
///      learner's own LinkedIn app or browser, and the TAP is recorded.
///      LinkedIn tells no app who follows whom, so this step is the
///      learner's word, and the line under it says so. Nothing is fetched
///      from LinkedIn and nothing is done there for them.
///   2. Follow on Plexaverse — a real follow of their public profile, and
///      the level re-checks it against the follow itself.
///
/// Both done → the level's XP for that top learner, once this round.
///
/// ## Outside the order
///
/// This level never waits for another and never holds one back, so the page
/// has no lock and no Skip.
class ContestFollowPage extends ConsumerWidget {
  const ContestFollowPage({super.key});

  static const Map<FollowWinnersReason, String> _unavailable =
      <FollowWinnersReason, String>{
        FollowWinnersReason.notRunning:
            'No round of levels is running right now. The next one starts '
            'soon.',
        FollowWinnersReason.notJoined:
            'Open your levels page first: today’s levels open there.',
        FollowWinnersReason.noWinners:
            'There is nobody to follow in this level right now.',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // An approval or a payment elsewhere reaches this screen on resume too.
    ref.watch(contestResumeRefreshProvider);
    final AsyncValue<FollowWinnersView> level = ref.watch(
      followWinnersProvider,
    );
    final FollowWinnersView? view = level.value;

    return ContestSheet(
      onRefresh: () async {
        ref.invalidate(followWinnersProvider);
        try {
          await ref.read(followWinnersProvider.future);
        } on Object {
          // The sheet says what went wrong.
        }
      },
      children: <Widget>[
        ContestSheetHeader(
          kicker: 'Level',
          title: kFollowWinnersTitle,
          lead: followWinnersLead(view?.pointsEach ?? 0),
        ),
        if (view == null && level.hasError)
          Text(contestMessage(level.error!), style: ContestType.meta)
        else if (view == null)
          const ContestSheetSkeleton(label: 'Loading last round’s top learners')
        else if (view.status == FollowWinnersStatus.unavailable ||
            view.winners.isEmpty)
          ContestPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ContestDot(
                  tone: ContestTone.idle,
                  label: 'Nothing to follow',
                ),
                SizedBox(height: ZaveSpace.sm),
                Text(
                  _unavailable[view.reason] ??
                      _unavailable[FollowWinnersReason.noWinners]!,
                  style: ZaveType.body.copyWith(fontSize: 15.sp),
                ),
              ],
            ),
          )
        else
          _Winners(view: view),
        const ContestWebLink(
          label: 'How this level pays',
          url: '$plexaverseLevelsRulesUrl#xp',
        ),
      ],
    );
  }
}

/// The top learners, each with their two steps, and — once every one is
/// followed — the way on.
class _Winners extends StatelessWidget {
  const _Winners({required this.view});

  final FollowWinnersView view;

  @override
  Widget build(BuildContext context) {
    final String? from = view.fromRoundLastDayKey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (from != null) ...<Widget>[
          Text(
            'The top learners of ${roundEndedPhrase(from)} who agreed to be '
            'featured.',
            style: ContestType.meta,
          ),
          SizedBox(height: ZaveSpace.lg),
        ],
        for (final FollowWinnerView w in view.winners) ...<Widget>[
          FollowWinnerCard(winner: w, pointsEach: view.pointsEach),
          SizedBox(height: ZaveSpace.lg),
        ],
        if (view.status == FollowWinnersStatus.done) ...<Widget>[
          const ContestDot(
            tone: ContestTone.live,
            label: 'You follow every one of them',
          ),
          SizedBox(height: ZaveSpace.lg),
          const NextLevelPill(from: PathNodeKind.followWinners),
        ],
      ],
    );
  }
}

/// One top learner: who they are, and their two steps. The web's
/// `WinnerCard`.
class FollowWinnerCard extends ConsumerWidget {
  const FollowWinnerCard({
    required this.winner,
    required this.pointsEach,
    super.key,
  });

  final FollowWinnerView winner;
  final int pointsEach;

  Future<void> _followOnLinkedIn(
    BuildContext context,
    WidgetRef ref,
    String href,
  ) async {
    // The profile opens first: it is the point. The tap is recorded beside
    // it — once; a repeat only reopens the profile.
    final Future<void> opened = openLinkAndReport(context, ref, href);
    if (!winner.linkedinDone) {
      await ref
          .read(followWinnersActionsProvider.notifier)
          .tappedLinkedIn(winner.handle);
    }
    await opened;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FollowWinnerBusy busy = ref.watch(followWinnersActionsProvider);
    // Re-checked on the way out, as every profile link on someone else's
    // screen is. A link that fails the rule shows no Step 1 button.
    final String? linkedin = profileHref(winner.linkedinUrl);
    final bool mine = busy.handle == winner.handle;
    final String? problem = busy.errorFor == winner.handle ? busy.error : null;
    final String name = winner.name.trim().isEmpty
        ? 'A Plexaverse learner'
        : winner.name.trim();
    final String? headline = winner.headline?.trim();
    final int? paid = winner.paid;

    return Semantics(
      container: true,
      label: name,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PersonAvatar(name: name, image: winner.image, diameter: 56),
                SizedBox(width: ZaveSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Semantics(
                        header: true,
                        child: Text(name, style: ContestType.cardTitle),
                      ),
                      if (headline != null && headline.isNotEmpty) ...<Widget>[
                        SizedBox(height: 2.h),
                        Text(
                          headline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ZaveType.body.copyWith(
                            fontSize: 14.sp,
                            height: 1.5,
                            color: ZaveColors.ink62,
                          ),
                        ),
                      ],
                      ContestWebLink(
                        label: 'plexaverse.com/${winner.handle}',
                        url: plexaverseProfileUrl(winner.handle),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ZaveSpace.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ContestDot(
                      tone: winner.done
                          ? ContestTone.live
                          : ContestTone.waiting,
                      label: winner.done ? 'Done' : 'To do',
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    if (winner.done && paid != null && paid > 0)
                      XpTag(points: paid)
                    else if (!winner.done && pointsEach > 0)
                      XpTag(points: pointsEach),
                  ],
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
            _StepRow(
              step: 'Step 1',
              note: kLinkedInSelfReportedLine,
              child: Wrap(
                spacing: ZaveSpace.md,
                runSpacing: ZaveSpace.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  if (linkedin != null)
                    ContestGhostPill(
                      label: kFollowOnLinkedIn,
                      trailing: AppIcons.openExternal,
                      // Off while ANY step is in flight, on every card — as
                      // Step 2 is: the actions run one step at a time and
                      // drop a second, so a tap here would open LinkedIn and
                      // silently not record step 1 (review, 24 Nov 2026).
                      onPressed: busy.busy
                          ? null
                          : () => _followOnLinkedIn(context, ref, linkedin),
                    ),
                  if (winner.linkedinDone)
                    const ContestDot(tone: ContestTone.live, label: 'Tapped'),
                ],
              ),
            ),
            SizedBox(height: ZaveSpace.md),
            _StepRow(
              step: 'Step 2',
              child: winner.plexaverseDone
                  ? const ContestDot(
                      tone: ContestTone.live,
                      label: 'Following on Plexaverse',
                    )
                  : ContestGhostPill(
                      label: mine && busy.step == FollowWinnerStep.plexaverse
                          ? 'Following…'
                          : kFollowOnPlexaverse,
                      onPressed: busy.busy
                          ? null
                          : () => ref
                                .read(followWinnersActionsProvider.notifier)
                                .followOnPlexaverse(winner.handle),
                    ),
            ),
            if (problem != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Semantics(
                liveRegion: true,
                child: Text(
                  problem,
                  style: ContestType.meta.copyWith(
                    color: ContestColors.wrongText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Step 1" in the kicker's style, its control, and a line under it.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.child, this.note});

  final String step;
  final Widget child;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final String? n = note;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          step.toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: ContestColors.peri,
          ),
        ),
        SizedBox(height: ZaveSpace.xs),
        child,
        if (n != null) ...<Widget>[
          SizedBox(height: ZaveSpace.xs),
          Text(n, style: ContestType.meta),
        ],
      ],
    );
  }
}
