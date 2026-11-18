import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/plan/plan_limit_sheet.dart';
import '../../../../core/plan/plan_refusal.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../contest/application/connect_controllers.dart';
import '../../../contest/application/contest_controllers.dart';
import '../../../contest/domain/contest_repository.dart'
    show
        ContestPlanRefused,
        ContestProfileIncomplete,
        PathNodeKind,
        contestMessage;
import '../../../contest/presentation/widgets/contest_kit.dart'
    show LockedNotice;
import '../../../contest/presentation/widgets/sheet/contest_sheet.dart'
    show SheetAlert;
import '../../../contest/presentation/widgets/skip_level.dart'
    show ContestSkipLevel;
import '../../application/engagement_controllers.dart';
import '../../domain/engagement_repository.dart';
import '../widgets/connection_card.dart';
import '../widgets/engagement_states.dart';
import '../widgets/mission_header.dart';

/// **Send connection requests** — the web's `/connections`, the second daily
/// habit the Season 1 roadmap links to.
///
/// ## What this screen is
///
/// On open it asks the server for five networking targets, aimed at the user's
/// own profession: four connection requests with personalised notes, plus one
/// direct message. That split is not arbitrary — LinkedIn's free plan caps
/// personalised connection notes at roughly five a week, so four keeps the user
/// under the cap and the fifth slot spends an unlimited DM to an Open Profile
/// instead.
///
/// As on `/comments`, the batch is stored for the day and replayed for free, so
/// reopening the screen costs nothing.
///
/// **A target counts as sent the moment its note is copied.** The send itself
/// happens inside LinkedIn, where this app has no visibility; claiming
/// otherwise would be a lie the progress bar tells.
///
/// ## Two deliberate departures from the web
///
/// 1. **The screen does not block on the roadmap.** The web gates its entire
///    render on `!activeStepInfo` and therefore spins forever for any user
///    whose day has no `/connections` step — which is every company-brand user,
///    since a Company Page cannot send connection requests at all. Here the
///    targets generate and work regardless; only the complete-the-step action
///    is withheld, with a line saying why.
/// 2. **No LinkedIn drawer.** The web opens a people search beside the list;
///    a phone opens it in the LinkedIn app instead, through
///    [ConnectionTarget.searchUrl]. Same destination, the user's own session,
///    no drawer to fit on a 402-point screen.
///
/// The progress denominator is the batch length, not the roadmap step's number.
/// That asymmetry with `/comments` is the web's own — see
/// [ConnectionBatch.targetCount].
///
/// ## Contest mode
///
/// [fromContest] is the contest path's Monday and Thursday level, "Connect
/// with leaders" — the web's `/connections?from=contest`. The same cards and
/// notes, but the targets come from the contest's own route (free for an
/// entrant on those days, one set a day) and the finish pays the contest task
/// — never the roadmap step — then goes back to the path. It waits its turn
/// like every other level: while today's earlier levels are open the page
/// says which comes first instead of loading targets, or the learner could
/// send every request and only then be refused at the finish.
class ConnectionsPage extends ConsumerWidget {
  const ConnectionsPage({super.key, this.fromContest = false});

  /// Opened from the contest path. See the class doc.
  final bool fromContest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (fromContest) return const _ContestConnectGate();

    final AsyncValue<ConnectionBatch> batch = ref.watch(
      connectionsControllerProvider,
    );
    final AsyncValue<EngagementMission?> mission = ref.watch(
      engagementMissionProvider(ZaveRoutes.connections),
    );
    final AsyncValue<bool> completion = ref.watch(stepCompletionProvider);

    ref.listen<AsyncValue<bool>>(stepCompletionProvider, (
      AsyncValue<bool>? previous,
      AsyncValue<bool> next,
    ) {
      if (next.hasError) {
        _say(context, 'That step did not save. Try again.');
      }
    });

    final ConnectionBatch? data = batch.value;
    final EngagementMission? m = mission.value;
    final int sent = data?.sentCount ?? 0;
    final int target = data?.targetCount ?? 5;
    final bool claimable =
        m != null && !m.isCompleted && data != null && sent >= target;

    return ZaveScaffold(
      largeTitle: 'Connections',
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back to the roadmap',
        onPressed: () => _leave(context),
      ),
      bottomBar: data == null
          ? null
          : FinishStepBar(
              done: sent,
              total: target,
              unit: 'sent',
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
            ..invalidate(connectionsControllerProvider);
          await ref.read(connectionsControllerProvider.future);
        },
        child: batch.when(
          loading: () => const ZaveScrollView(
            children: <Widget>[EngagementSkeleton(rows: 4)],
          ),
          error: (Object error, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              _header(m),
              SizedBox(height: ZaveSpace.xl),
              EngagementBlocked(
                failure: _asFailure(error),
                onRetry: () => ref.invalidate(connectionsControllerProvider),
                onSeePlans: () => context.push(ZaveRoutes.pricing),
                // The web sends this one to /settings, and so does this: the
                // headline and profession live there, and they are exactly
                // what PROFILE_INCOMPLETE is complaining about.
                onCompleteProfile: () => context.push(ZaveRoutes.settings),
              ),
            ],
          ),
          data: (ConnectionBatch value) =>
              _body(context, ref, value, m, sent, target),
        ),
      ),
    );
  }

  Widget _header(EngagementMission? mission) => MissionHeader(
    mission: mission,
    fallbackDescription:
        'Reach out to people in your field with a note that says something, '
        'so the request reads as a person rather than a prompt.',
  );

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    ConnectionBatch batch,
    EngagementMission? mission,
    int sent,
    int target,
  ) {
    final ConnectionsController controller = ref.read(
      connectionsControllerProvider.notifier,
    );

    return ZaveScrollView(
      children: <Widget>[
        _header(mission),
        SizedBox(height: ZaveSpace.xl),

        if (batch.profession.isNotEmpty) ...<Widget>[
          Text('AIMED AT', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(batch.profession, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
        ],

        Text(
          '$sent / $target sent — send each request on LinkedIn.',
          style: ZaveType.bodyMuted,
        ),
        if (batch.cached) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          const CachedBatchNote(),
        ],

        SizedBox(height: ZaveSpace.lg),
        const NewSetUnavailable(),
        SizedBox(height: ZaveSpace.xl),

        if (batch.isEmpty)
          const _NothingGenerated()
        else
          for (int i = 0; i < batch.connections.length; i++) ...<Widget>[
            ConnectionCard(
              key: ValueKey<int>(i),
              index: i,
              target: batch.connections[i],
              // Copy AND open — the web's `copyNote` does both, opening
              // `connection.linkedinSearchUrl` straight after the copy.
              onCopyNote: () async {
                await Clipboard.setData(
                  ClipboardData(text: batch.connections[i].note),
                );
                controller.markSent(i);
                if (!context.mounted) return;
                await _openSearch(
                  context,
                  ref,
                  batch.connections[i],
                  clipboardHoldsTheNote: true,
                );
              },
              // No `markSent`: looking at who is out there is not the same as
              // having written to them, and the target counts sends.
              onOpenSearch: () =>
                  _openSearch(context, ref, batch.connections[i]),
            ),
            SizedBox(height: ZaveSpace.md),
          ],

        SizedBox(height: ZaveSpace.lg),
        const FreePlanRuleCard(),
        SizedBox(height: ZaveSpace.md),
        const HowItWorksCard(
          steps: <String>[
            'Copy & open LinkedIn — the note goes to your clipboard and '
                'LinkedIn opens on a search for that role.',
            'Find a Premium account in the results — the gold badge.',
            'Connect, add a note, paste, send.',
          ],
          handoff:
              'Find people opens the same search without copying, so you can '
              'look around before a request counts as sent.',
        ),
      ],
    );
  }

  String? _barNote({
    required EngagementMission? mission,
    required int sent,
    required int target,
  }) {
    if (mission == null) {
      return 'No step on today’s roadmap to claim — a Company Page cannot send '
          'connection requests.';
    }
    if (mission.isCompleted) return 'Already claimed today.';
    if (sent >= target) return null;
    final int left = target - sent;
    return left == 1
        ? 'Send one more request to finish.'
        : 'Send $left more requests to finish.';
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
    _say(context, 'Step complete.');
    _leave(context);
  }

  /// Back where the step came from: the roadmap, as the web's finish and
  /// back button both go (`/roadmap`).
  static void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ZaveRoutes.roadmap);
    }
  }

  /// Opens LinkedIn's people search for [target].
  ///
  /// Uses [ConnectionTarget.searchUrl], which prefers the server's own
  /// `linkedinSearchUrl` and only builds one when that arrived empty.
  static Future<void> _openSearch(
    BuildContext context,
    WidgetRef ref,
    ConnectionTarget target, {
    bool clipboardHoldsTheNote = false,
  }) async {
    final String? url = target.searchUrl;
    if (url == null) return;

    // See the comments screen: after a copy the clipboard holds the note,
    // and the copy fallback would overwrite it with this URL.
    if (clipboardHoldsTheNote) {
      final bool opened = await openLinkKeepingClipboard(ref, url);
      if (!opened && context.mounted) {
        _say(context, 'Note copied. Open LinkedIn and search for them.');
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

  static EngagementFailure _asFailure(Object error) =>
      error is EngagementFailure
      ? error
      : const EngagementFailure(EngagementBlock.unavailable);
}

/// The batch came back empty. Nothing failed and nothing was charged.
class _NothingGenerated extends StatelessWidget {
  const _NothingGenerated();

  @override
  Widget build(BuildContext context) => const ZaveEmptyState(
    title: 'No targets came back',
    body: 'Pull down to ask again. Nothing was charged.',
  );
}

// ── Contest mode ────────────────────────────────────────────────────────────

/// What the contest's description says under the title. The web's own words.
const String _contestLead =
    'Send each request with its note, then finish to collect your contest XP.';

/// Back to the contest — where the level was opened, and where Finish goes.
Widget _backToContest(BuildContext context) => ZaveIconButton(
  icon: const Icon(AppIcons.back),
  tooltip: 'Back to the contest',
  onPressed: () => context.go(ZaveRoutes.contest),
);

/// The level's gate, read off the path before anything else.
///
/// Today's targets are not asked for until the path says the level is open:
/// the GET may spend the day's model call, and a learner who sent every
/// request while the level was locked would only learn it at the finish
/// (409 LOCKED). A path that FAILED to load is not a reason to wait — the
/// page opens and the server's own gate still holds.
class _ContestConnectGate extends ConsumerWidget {
  const _ContestConnectGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TodayLock lock = ref.watch(
      todayLockProvider(PathNodeKind.connectLeaders),
    );
    final String? locked = lock.locked;
    if (!lock.pending && locked == null) return const _ContestConnections();
    return ZaveScaffold(
      title: 'Connect with leaders',
      leading: _backToContest(context),
      body: ZaveScrollView(
        children: <Widget>[
          if (locked != null)
            LockedNotice(detail: locked)
          else
            const EngagementSkeleton(rows: 4),
        ],
      ),
    );
  }
}

/// The open level: today's leaders, the notes, and "Finish and collect XP".
class _ContestConnections extends ConsumerWidget {
  const _ContestConnections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ConnectionBatch> batch = ref.watch(
      contestConnectTargetsProvider,
    );
    final ContestConnectBusy finish = ref.watch(contestConnectActionsProvider);

    // Off a contest Monday or Thursday the plan gate applies, and its refusal
    // opens the plan sheet once, as it lands — the card below has no way to
    // the limit's reset time.
    ref.listen<AsyncValue<ConnectionBatch>>(contestConnectTargetsProvider, (
      AsyncValue<ConnectionBatch>? previous,
      AsyncValue<ConnectionBatch> next,
    ) {
      final Object? error = next.error;
      if (error is ContestPlanRefused &&
          previous?.error is! ContestPlanRefused) {
        PlanLimitSheet.show(context, error.refusal);
      }
    });

    final ConnectionBatch? data = batch.value;
    final int sent = data?.sentCount ?? 0;
    final int target = data?.targetCount ?? 5;
    final bool ready = data != null && !data.isEmpty && sent >= target;

    return ZaveScaffold(
      title: 'Connect with leaders',
      leading: _backToContest(context),
      bottomBar: data == null
          ? null
          : _ContestFinishBar(
              done: sent,
              total: target,
              busy: finish.busy,
              note: ready ? null : _sendMore(target - sent),
              error: finish.error,
              locked: finish.locked,
              onFinish: ready ? () => _finish(context, ref) : null,
            ),
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          // The day's set is replayed, never replaced: there is no new set
          // to ask for in the contest.
          ref.invalidate(contestConnectTargetsProvider);
          try {
            await ref.read(contestConnectTargetsProvider.future);
          } on Object {
            // The page shows the failure itself.
          }
        },
        child: batch.when(
          loading: () => const ZaveScrollView(
            children: <Widget>[EngagementSkeleton(rows: 4)],
          ),
          error: (Object error, StackTrace _) => ZaveScrollView(
            children: <Widget>[
              Text(_contestLead, style: ZaveType.lead),
              SizedBox(height: ZaveSpace.xl),
              EngagementBlocked(
                failure: _asFailure(error),
                onRetry: () => ref.invalidate(contestConnectTargetsProvider),
                onSeePlans: () => context.push(ZaveRoutes.pricing),
                onCompleteProfile: () => context.push(ZaveRoutes.settings),
              ),
              // The current level can be skipped (17 Nov 2026); it stays
              // open today.
              const ContestSkipLevel(kind: PathNodeKind.connectLeaders),
            ],
          ),
          data: (ConnectionBatch value) => _body(context, ref, value, sent),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    ConnectionBatch batch,
    int sent,
  ) {
    final ContestConnectTargets targets = ref.read(
      contestConnectTargetsProvider.notifier,
    );
    return ZaveScrollView(
      children: <Widget>[
        Text(_contestLead, style: ZaveType.lead),
        SizedBox(height: ZaveSpace.xl),
        if (batch.profession.isNotEmpty) ...<Widget>[
          Text('AIMED AT', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(batch.profession, style: ZaveType.h3),
          SizedBox(height: ZaveSpace.lg),
        ],
        Text(
          '$sent / ${batch.targetCount} sent — send each request on LinkedIn.',
          style: ZaveType.bodyMuted,
        ),
        // No "new set" control: the contest's set is one a day.
        if (batch.cached) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          const CachedBatchNote(),
        ],
        SizedBox(height: ZaveSpace.xl),
        if (batch.isEmpty)
          const _NothingGenerated()
        else
          for (int i = 0; i < batch.connections.length; i++) ...<Widget>[
            ConnectionCard(
              key: ValueKey<int>(i),
              index: i,
              target: batch.connections[i],
              onCopyNote: () async {
                await Clipboard.setData(
                  ClipboardData(text: batch.connections[i].note),
                );
                targets.markSent(i);
                if (!context.mounted) return;
                await ConnectionsPage._openSearch(
                  context,
                  ref,
                  batch.connections[i],
                  clipboardHoldsTheNote: true,
                );
              },
              onOpenSearch: () => ConnectionsPage._openSearch(
                context,
                ref,
                batch.connections[i],
              ),
            ),
            SizedBox(height: ZaveSpace.md),
          ],
        SizedBox(height: ZaveSpace.lg),
        const FreePlanRuleCard(),
        SizedBox(height: ZaveSpace.md),
        const HowItWorksCard(
          steps: <String>[
            'Copy & open LinkedIn — the note goes to your clipboard and '
                'LinkedIn opens on a search for that role.',
            'Find a Premium account in the results — the gold badge.',
            'Connect, add a note, paste, send.',
          ],
          handoff:
              'Find people opens the same search without copying, so you can '
              'look around before a request counts as sent.',
        ),
        // The current level can be skipped (17 Nov 2026); it stays open
        // today. Only here, in the contest's list — never on the plain
        // Connections habit screen, which has nothing to do with the contest.
        const ContestSkipLevel(kind: PathNodeKind.connectLeaders),
      ],
    );
  }

  /// Pays the contest task — a repeat is harmless — and goes back to the
  /// path, which must now show the level done.
  Future<void> _finish(BuildContext context, WidgetRef ref) async {
    final bool ok = await ref
        .read(contestConnectActionsProvider.notifier)
        .complete();
    if (!ok || !context.mounted) return;
    context.go(ZaveRoutes.contest);
  }

  static String _sendMore(int left) => left == 1
      ? 'Send one more request to finish.'
      : 'Send $left more requests to finish.';

  /// The contest's refusals of the targets, as the card both habit screens
  /// already draw: the plan, an empty profile, or anything else.
  static EngagementFailure _asFailure(Object error) => switch (error) {
    ContestPlanRefused(:final PlanRefusal refusal) => EngagementFailure(
      refusal.needsPlan
          ? EngagementBlock.needsPlan
          : EngagementBlock.limitReached,
      message: refusal.message,
      refusal: refusal,
    ),
    ContestProfileIncomplete(:final String message) => EngagementFailure(
      EngagementBlock.profileIncomplete,
      message: message,
    ),
    _ => EngagementFailure(
      EngagementBlock.unavailable,
      message: contestMessage(error),
    ),
  };
}

/// The sticky bar with the level's one action, "Finish and collect XP".
///
/// [FinishStepBar]'s layout — the count, the dots, the line under them —
/// with the contest's button and the contest's refusal under it. Its own
/// widget rather than a label on that one because a refused finish here has
/// a cure the roadmap step never has: the way back to the path.
class _ContestFinishBar extends StatelessWidget {
  const _ContestFinishBar({
    required this.done,
    required this.total,
    required this.busy,
    required this.onFinish,
    this.note,
    this.error,
    this.locked = false,
  });

  final int done;
  final int total;
  final bool busy;

  /// Null disables the button: not every note is copied yet.
  final VoidCallback? onFinish;
  final String? note;

  /// The server's refusal of the last finish, in its own words.
  final String? error;

  /// That refusal was the gate: an earlier level of today is still open.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final String? refused = error;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ZaveSurface.headerBlurSigma,
          sigmaY: ZaveSurface.headerBlurSigma,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: ZaveGlass.headerFill,
            border: Border(
              top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ZaveSpace.gutter,
                ZaveSpace.lg,
                ZaveSpace.gutter,
                ZaveSpace.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$done / $total sent',
                        style: ZaveType.label.copyWith(
                          color: done >= total
                              ? ZaveColors.mint
                              : ZaveColors.ink62,
                        ),
                      ),
                      SizedBox(width: ZaveSpace.md),
                      Expanded(
                        child: Wrap(
                          spacing: ZaveSpace.sm,
                          runSpacing: ZaveSpace.sm,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            for (int i = 0; i < total; i++)
                              ZaveDot(
                                i < done ? ZaveColors.green : ZaveColors.ink35,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (note != null) ...<Widget>[
                    SizedBox(height: ZaveSpace.sm),
                    Text(note!, style: ZaveType.caption),
                  ],
                  if (refused != null) ...<Widget>[
                    SizedBox(height: ZaveSpace.sm),
                    SheetAlert(message: refused, backToPath: locked),
                  ],
                  SizedBox(height: ZaveSpace.md),
                  ZaveButton.primary(
                    label: 'Finish and collect XP',
                    expand: true,
                    busy: busy,
                    onPressed: onFinish,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
