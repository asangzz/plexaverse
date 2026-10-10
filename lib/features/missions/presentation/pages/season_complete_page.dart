import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/missions_controllers.dart';
import '../../domain/missions_repository.dart';
import '../widgets/mission_chrome.dart';
import '../../application/season_controller.dart';

/// **Season 1 Complete** — the web's `/season-complete`.
///
/// Shown once a user passes day 66. On the web this is a three-step flow:
/// a recap, a choice of three Season 2 paths, and — for the pivot path — an
/// AI-suggested career-direction picker.
///
/// ## The choice is offered here, and it is a real write
///
/// It is one call: `POST /season/advance`, which the mobile API now carries.
/// Until it did, this screen could only describe the three paths and point at
/// the web — advancing re-anchors the user's whole content plan, so posting to
/// a route that did not exist and swallowing the 404 would have left someone
/// believing they had started Season 2 while the server still had them on day
/// 67 of Season 1, generating the old arc.
///
/// The pivot path asks for the new direction in the user's own words rather
/// than suggesting one: `GET /api/ai/career-suggestions`, which feeds the
/// web's picker, has no mobile mirror. `targetRole` is optional on the route,
/// so the field is too — leaving it blank starts the arc unanchored rather
/// than blocking the choice.
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
        //
        // IntrinsicHeight, because `CrossAxisAlignment.stretch` needs a
        // BOUNDED cross axis and this Row sits in a ListView, where its height
        // is unbounded. Without it `RenderFlex._computeSizes` asserts and the
        // whole screen fails to lay out — not an overflow, a blank page. It
        // was the one page in the app that did not render at all.
        //
        // The cost is a second layout pass over three small cards, which is
        // what buys three equal-height columns whose labels wrap instead of
        // three cards of three different heights.
        IntrinsicHeight(
          child: Row(
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

        _PathCard(
          choice: 'transformation',
          title: 'New Transformation',
          description:
              "You're ready to pivot. Pick a new career direction and start a "
              'fresh 66-day arc anchored to that goal.',
        ),
        SizedBox(height: ZaveSpace.md),
        _PathCard(
          choice: 'deeper',
          title: 'Go Deeper',
          description:
              'Your audience is built. Season 2 phases are bolder — '
              'Perspective, Controversy, Community, Movement, Legacy 2.0.',
        ),
        SizedBox(height: ZaveSpace.md),
        _PathCard(
          choice: 'maintenance',
          title: 'Maintenance Mode',
          description:
              'Life is busy. Stay visible with 3 posts a week (Mon / Wed / '
              'Fri) while Plexaverse handles the planning.',
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
/// One Season 2 path, and the act of choosing it.
///
/// These were inert description cards under a note saying the choice
/// happened on the web, which made day 66 a dead end for anyone who had only
/// ever used the app: the recap showed their real numbers and then told them
/// their next season was somewhere else.
///
/// Choosing is confirmed because it is not reversible from here — it starts
/// the season, rebooks the auto-post chain and, on the transformation path,
/// resets the 66-day clock. The dialog is about intent, not about the request.
///
/// The in-flight guard is NOT per card. It is read off
/// [seasonAdvanceControllerProvider] so that starting any path closes all
/// three — see that controller for what tapping a second path mid-write did.
/// The spinner stays per card, because only one of them was actually tapped.
class _PathCard extends ConsumerStatefulWidget {
  const _PathCard({
    required this.choice,
    required this.title,
    required this.description,
  });

  final String choice;
  final String title;
  final String description;

  @override
  ConsumerState<_PathCard> createState() => _PathCardState();
}

class _PathCardState extends ConsumerState<_PathCard> {
  /// Spinner only. The guard that stops a second advance is the shared one on
  /// [seasonAdvanceControllerProvider]; this just says which card was tapped.
  bool _busy = false;

  /// The pivot path's new direction. Only the transformation card builds one.
  late final TextEditingController? _targetRole =
      widget.choice == 'transformation' ? TextEditingController() : null;

  @override
  void dispose() {
    _targetRole?.dispose();
    super.dispose();
  }

  Future<void> _choose() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('Start Season 2 — ${widget.title}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.choice == 'transformation'
                  ? 'This starts a fresh 66-day arc from today. Your Season 1 '
                        'posts and history stay exactly as they are.'
                  : widget.choice == 'maintenance'
                  ? 'Your plan drops to 3 posts a week — Monday, Wednesday '
                        'and Friday. You can change the pace later in '
                        'Settings.'
                  : 'Season 2 phases are bolder, and your plan refreshes '
                        'this Sunday. Your audience and clock carry over.',
            ),
            // The card promises a new direction, so this is where it is
            // given. Optional on the route and optional here: a blank field
            // starts the arc unanchored rather than blocking the choice.
            if (_targetRole != null) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              ZaveField(
                controller: _targetRole,
                label: 'New direction',
                hint: 'e.g. Head of Product',
                helper: 'Optional — it anchors the new arc.',
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => Navigator.of(ctx).pop(true),
              ),
            ],
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Not yet',
              style: ZaveType.button.copyWith(color: ZaveColors.ink62),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Start', style: ZaveType.button),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    // Re-check after the dialog, not just before it. The shared flag closes
    // the other cards the moment a write starts, but it cannot close a dialog
    // that was already open — a double-tap on THIS card stacks two of them,
    // and the second confirm would otherwise post a second advance. The first
    // one's snackbar reports the outcome, so there is nothing to say here.
    if (ref.read(seasonAdvanceControllerProvider)) return;

    setState(() => _busy = true);
    String message;
    try {
      final String role = _targetRole?.text.trim() ?? '';
      final bool already = await ref
          .read(seasonAdvanceControllerProvider.notifier)
          .advance(widget.choice, targetRole: role.isEmpty ? null : role);
      message = already
          ? 'You are already on Season 2.'
          : 'Season 2 started — ${widget.title}.';
    } on Object {
      message = "That didn't go through. Your plan is unchanged.";
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message, style: ZaveType.body)));
  }

  @override
  Widget build(BuildContext context) {
    // Watched, not read: an advance started from ANY of the three cards has
    // to disable this one too.
    final bool advancing = ref.watch(seasonAdvanceControllerProvider);

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.title, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.sm),
          Text(widget.description, style: ZaveType.bodyMuted),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton(
            label: 'Choose this path',
            expand: true,
            // Only the tapped card spins; all three go dead.
            busy: _busy,
            onPressed: (advancing || _busy) ? null : _choose,
          ),
        ],
      ),
    );
  }
}
