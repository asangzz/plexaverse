import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/mission_chrome.dart';

/// **Season 1 Complete** — the web's `/season-complete`.
///
/// Shown once a user passes day 66. On the web this is a three-step flow:
/// a recap, a choice of three Season 2 paths, and — for the pivot path — an
/// AI-suggested career-direction picker.
///
/// ## Why the choice is described here rather than offered
///
/// The choice is one call: `POST /api/season/advance`. **There is no
/// `season/` directory under `app/api/mobile/v1/`**, so that route does not
/// exist for this client, and `GET /api/ai/career-suggestions` (which feeds the
/// pivot path) has no mobile mirror either.
///
/// Advancing a season is not a read that can quietly degrade: it re-anchors the
/// user's whole content plan. Posting to an invented path and swallowing the
/// 404 would leave someone believing they had started Season 2 while the server
/// still had them on day 67 of Season 1, generating the old arc. So the recap
/// is real, the three paths are described in the web's own words, and the
/// choice itself points at the web.
///
/// Both missing routes are reported in the summary.
class SeasonCompletePage extends ConsumerWidget {
  const SeasonCompletePage({super.key});

  /// The milestone the web credits for finishing Season 1.
  static const int milestoneXp = 500;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SeasonRecap> recap = ref.watch(seasonRecapProvider);

    return ZaveScaffold(
      title: 'Season 1',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      body: recap.when(
        loading: () => ZaveScrollView(
          children: <Widget>[
            const MissionSkeleton(height: 160),
            SizedBox(height: ZaveSpace.xl),
            const MissionSkeleton(height: 110),
            SizedBox(height: ZaveSpace.lg),
            const MissionSkeleton(height: 300),
          ],
        ),
        error: (Object e, StackTrace _) => ZaveScrollView(
          children: <Widget>[
            MissionErrorCard(
              title: 'Your season did not load.',
              detail:
                  'The recap is built from your roadmap, your XP and your '
                  'published posts. One of those reads did not come back.',
              onRetry: () => ref.invalidate(seasonRecapProvider),
            ),
          ],
        ),
        data: (SeasonRecap data) => _Body(recap: data),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.recap});

  final SeasonRecap recap;

  @override
  Widget build(BuildContext context) {
    return ZaveScrollView(
      children: <Widget>[
        Text('SEASON 1 COMPLETE', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text('You finished the 66 days', style: ZaveType.h2),
        SizedBox(height: ZaveSpace.md),
        Text(
          "You've completed a full 66-day LinkedIn brand journey. That puts "
          'you in the top 1% of creators who actually follow through.',
          style: ZaveType.lead,
        ),

        SizedBox(height: ZaveSpace.xl),

        // ── Stats ──
        // The web keeps three across even on a phone. So does this, with the
        // labels wrapping rather than the columns stacking.
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _StatCard(
                value: '${recap.roadmapDay}',
                label: 'Day reached',
                color: ZaveColors.peri,
              ),
            ),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: _StatCard(
                // `100+` when the count hit its page limit — an honest
                // ceiling beats a number the app cannot stand behind.
                value: recap.postsAtLeast
                    ? '${recap.postsPublished}+'
                    : '${recap.postsPublished}',
                label: 'Posts published',
                // Green: these are done and on LinkedIn.
                color: ZaveColors.green,
              ),
            ),
            SizedBox(width: ZaveSpace.sm),
            Expanded(
              child: _StatCard(
                value: '${recap.xpBalance}',
                label: 'XP balance',
                // Amber: XP is points.
                color: ZaveColors.amber,
              ),
            ),
          ],
        ),

        SizedBox(height: ZaveSpace.lg),

        // ── Milestone ──
        ZaveCard(
          size: ZaveCardSize.small,
          padding: ZaveSpace.rowPad,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                child: const ZaveDot(ZaveColors.amber),
              ),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '+${SeasonCompletePage.milestoneXp} XP season milestone',
                      style: ZaveType.label.copyWith(color: ZaveColors.amber),
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    Text(
                      'Awarded for completing Season 1.',
                      style: ZaveType.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: ZaveSpace.xxl),

        // ── The three paths ──
        Text("WHAT'S NEXT", style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Choose the Season 2 path that matches where you are right now.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),

        const _PathCard(
          title: 'New Transformation',
          description:
              "You're ready to pivot. Pick a new career direction and start a "
              'fresh 66-day arc anchored to that goal.',
        ),
        SizedBox(height: ZaveSpace.md),
        const _PathCard(
          title: 'Go Deeper',
          description:
              'Your audience is built. Season 2 phases are bolder — '
              'Perspective, Controversy, Community, Movement, Legacy 2.0.',
        ),
        SizedBox(height: ZaveSpace.md),
        const _PathCard(
          title: 'Maintenance Mode',
          description:
              'Life is busy. Stay visible with 3 posts a week (Mon / Wed / '
              'Fri) while Plexaverse handles the planning.',
        ),

        SizedBox(height: ZaveSpace.lg),

        ZaveCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Amber: waiting on something elsewhere. Zave has no red, and
              // nothing here has failed.
              Padding(
                padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                child: const ZaveDot(ZaveColors.amber),
              ),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  'Starting Season 2 happens on plexaverse.com — the app '
                  "cannot make that change yet. Your plan keeps running "
                  'until you choose.',
                  style: ZaveType.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One recap number.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ZaveSurface.row,
      padding: EdgeInsets.symmetric(
        vertical: ZaveSpace.lg,
        horizontal: ZaveSpace.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: ZaveType.h3.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ZaveSpace.xs),
          Text(label.toUpperCase(), style: ZaveType.kicker),
        ],
      ),
    );
  }
}

/// One Season 2 path.
///
/// A card, not a button. The web's version is pressable because it can act;
/// this one describes, and a pressable surface that did nothing would be the
/// dead control this whole screen is written to avoid.
class _PathCard extends StatelessWidget {
  const _PathCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.sm),
        Text(description, style: ZaveType.bodyMuted),
      ],
    ),
  );
}
