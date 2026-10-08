import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
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
///    targets generate and work regardless; only the claim-your-XP action is
///    withheld, with a line saying why.
/// 2. **No LinkedIn drawer.** The web opens a people search beside the list;
///    a phone opens it in the LinkedIn app instead, through
///    [ConnectionTarget.searchUrl]. Same destination, the user's own session,
///    no drawer to fit on a 402-point screen.
///
/// The progress denominator is the batch length, not the roadmap step's number.
/// That asymmetry with `/comments` is the web's own — see
/// [ConnectionBatch.targetCount].
class ConnectionsPage extends ConsumerWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        icon: const Icon(Icons.arrow_back),
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
                knownXpCost: null,
                onRetry: () => ref.invalidate(connectionsControllerProvider),
                onGetXp: () => context.push(ZaveRoutes.pricing),
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
        NewSetUnavailable(xpCost: batch.xpCost),
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
    _say(context, '+${mission.xpReward} XP — step complete.');
    _leave(context);
  }

  static void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ZaveRoutes.dashboard);
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
          Text('No targets came back', style: ZaveType.h3),
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
