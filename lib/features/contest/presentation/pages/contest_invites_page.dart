import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/platform/image_picking.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/contest_controllers.dart';
import '../../application/invites_controllers.dart';
import '../../domain/contest_repository.dart';
import '../widgets/contest_kit.dart';
import '../widgets/sheet/contest_sheet.dart';

/// `/contest/invites` — Saturday's level: send the week's invitations, then
/// prove it with one screenshot. The web's `InvitesUpload`.
///
/// Every state is the path's `weekly_invites` node — there is no GET for
/// invites — plus what this page's own upload answered: once one lands, the
/// level stays "sent" whatever the re-read path then draws. On a Sunday
/// re-send of last week's legacy screenshot the path stops drawing that node
/// at all, and without this the page would jump to next Saturday's locked one
/// a moment after the XP appeared.
class ContestInvitesPage extends ConsumerWidget {
  const ContestInvitesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // An approval or an audit reaches the learner only through the path, so
    // it is re-read whenever the app comes back to the foreground.
    ref.watch(contestResumeRefreshProvider);
    final AsyncValue<ContestPath> path = ref.watch(contestPathProvider);
    final InvitesUpload upload = ref.watch(invitesActionsProvider);
    final InvitesLevel? found = invitesLevelOf(path.value);
    final bool lastWeek = upload.sent?.lastWeek ?? found?.lastWeek ?? false;
    final int points = found?.node.points ?? 0;

    return ContestSheet(
      onRefresh: () async {
        ref.invalidate(contestPathProvider);
        try {
          await ref.read(contestPathProvider.future);
        } on Object {
          // The sheet shows the failure itself.
        }
      },
      children: <Widget>[
        ContestSheetHeader(
          kicker: lastWeek
              ? 'Last week · weekly invites'
              : 'Saturday · weekly invites',
          title: lastWeek
              ? 'Last week’s invitations'
              : 'Send this week’s invitations',
          points: points,
          lead: lastWeek
              ? 'Last week’s screenshot is still open: it is waiting for our '
                    'team, or you can send a new one today. A new one pays its '
                    'XP as soon as you send it, and our team checks every '
                    'screenshot.'
              // No fixed number: invitations still pending use up part of
              // LinkedIn's weekly allowance, so what anyone CAN send differs.
              : 'Invite people in your field until LinkedIn will not let you '
                    'send more this week. Invitations still waiting for an '
                    'answer count against that limit, so withdrawing old ones '
                    'gives you room. Then send us a screenshot of LinkedIn’s '
                    'Sent page. The XP lands as soon as you send it; our team '
                    'checks every screenshot.',
        ),
        const _Links(),
        _body(path, upload, found, points),
      ],
    );
  }

  static Widget _body(
    AsyncValue<ContestPath> path,
    InvitesUpload upload,
    InvitesLevel? found,
    int points,
  ) {
    final ContestPath? data = path.value;
    if (data == null) {
      if (path.hasError) {
        return _Notice(
          dot: const ContestDot(
            tone: ContestTone.idle,
            label: 'Could not load this week',
          ),
          line: contestMessage(path.error!),
        );
      }
      return const ContestSheetSkeleton();
    }

    if (data.status != ContestPathStatus.running) {
      return _Meta(
        data.status == ContestPathStatus.notJoined
            ? 'This task is for contest entrants. Join on the contest page; it '
                  'is free.'
            : 'This task runs while the contest does.',
      );
    }
    final InvitesSent? sent = upload.sent;
    if (sent != null) return _Sent(points: sent.points);
    if (found == null) {
      return const _Meta(
        'There is no invites task in this week of the contest.',
      );
    }

    final PathNode node = found.node;
    final bool lastWeek = found.lastWeek;
    return switch (node.state) {
      PathNodeState.pending => const _Pending(),
      PathNodeState.done => _Sent(points: points),
      PathNodeState.approved => _Approved(points: points),
      // Found fake: final, with the reason and what it cost in `detail`.
      PathNodeState.revoked => _Notice(
        dot: const ContestDot(
          tone: ContestTone.wrong,
          label: 'Screenshot removed',
        ),
        line: node.detail ?? 'Our team found this screenshot was not genuine.',
        meta:
            'A fake screenshot loses its XP and the same again as a penalty. '
            'The next upload opens on Saturday.',
      ),
      PathNodeState.rejected => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Notice(
            dot: const ContestDot(
              tone: ContestTone.wrong,
              label: 'Not approved',
            ),
            line: node.detail ?? 'Our team could not approve that screenshot.',
          ),
          SizedBox(height: ZaveSpace.lg),
          _UploadPanel(resend: true, points: points, lastWeek: lastWeek),
        ],
      ),
      PathNodeState.today => _UploadPanel(
        resend: false,
        points: points,
        lastWeek: lastWeek,
      ),
      // Today's, behind an earlier level — or the coming Saturday's.
      PathNodeState.locked => const _LockedOrAhead(),
      PathNodeState.missed => const _Meta(
        'This week’s upload has closed. The next one opens on Saturday.',
      ),
      PathNodeState.unavailable => _Meta(
        node.detail ?? 'There is nothing to send today.',
      ),
    };
  }
}

/// "Find people to invite" and LinkedIn's own Sent page — the two places the
/// level's work happens.
class _Links extends ConsumerWidget {
  const _Links();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: ZaveSpace.md,
      runSpacing: ZaveSpace.md,
      children: <Widget>[
        // The ordinary Connection Sprint, not the contest's Monday level.
        ContestGhostPill(
          label: 'Find people to invite',
          leading: AppIcons.personAdd,
          onPressed: () => context.push(ZaveRoutes.connections),
        ),
        ContestGhostPill(
          label: 'Open your sent invitations',
          trailing: AppIcons.openExternal,
          onPressed: () => openLinkAndReport(context, ref, kSentInvitationsUrl),
        ),
      ],
    );
  }
}

/// A locked invites node: today's, waiting on the day's earlier levels
/// (the gate's own line), or a Saturday still ahead.
class _LockedOrAhead extends ConsumerWidget {
  const _LockedOrAhead();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? locked = ref
        .watch(todayLockProvider(PathNodeKind.weeklyInvites))
        .locked;
    if (locked != null) return LockedNotice(detail: locked);
    return const _Meta(
      'The upload opens on Saturday. You can send invites any day before '
      'then.',
    );
  }
}

/// Sent and paid — the XP is in; our team checks it after. The rule is said
/// again here, with what it would cost, now that the XP has landed.
class _Sent extends StatelessWidget {
  const _Sent({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContestDot(
              tone: ContestTone.live,
              label: points > 0 ? 'Screenshot sent · XP in' : 'Screenshot sent',
            ),
            if (points > 0) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              XpTag(points: points),
            ],
            SizedBox(height: ZaveSpace.md),
            Text(invitesFakeRule(points), style: ContestType.meta),
            SizedBox(height: ZaveSpace.lg),
            const NextLevelPill(from: PathNodeKind.weeklyInvites),
          ],
        ),
      ),
    );
  }
}

/// A screenshot sent under the old review flow, still waiting for an admin.
class _Pending extends StatelessWidget {
  const _Pending();

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ContestDot(
            tone: ContestTone.waiting,
            label: 'Waiting for our team',
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'We have your screenshot. The XP lands once it is approved.',
            style: ContestType.meta,
          ),
          SizedBox(height: ZaveSpace.lg),
          const NextLevelPill(from: PathNodeKind.weeklyInvites),
        ],
      ),
    );
  }
}

/// Approved under the old review flow.
class _Approved extends StatelessWidget {
  const _Approved({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return ContestPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ContestDot(tone: ContestTone.live, label: 'Approved'),
          if (points > 0) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            XpTag(points: points),
          ],
          SizedBox(height: ZaveSpace.lg),
          const NextLevelPill(from: PathNodeKind.weeklyInvites),
        ],
      ),
    );
  }
}

/// Choose the screenshot, see it, read the two rules, send it.
class _UploadPanel extends ConsumerWidget {
  const _UploadPanel({
    required this.resend,
    required this.points,
    required this.lastWeek,
  });

  /// A rejected screenshot is being replaced.
  final bool resend;
  final int points;
  final bool lastWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InvitesUpload upload = ref.watch(invitesActionsProvider);
    final InvitesActions actions = ref.read(invitesActionsProvider.notifier);
    final PickedImage? shot = upload.screenshot;

    return Semantics(
      label: 'Upload your screenshot',
      container: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              resend
                  ? 'Send a new screenshot'
                  : 'Upload a screenshot of your sent invitations',
              style: ZaveType.body.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: ZaveColors.white,
              ),
            ),
            SizedBox(height: ZaveSpace.lg),
            ContestGhostPill(
              label: shot == null ? 'Choose a screenshot' : 'Choose another',
              leading: AppIcons.photoLibrary,
              onPressed: upload.busy ? null : actions.choose,
            ),
            if (shot != null) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 320.h),
                child: ClipRRect(
                  borderRadius: ZaveRadius.cardSmBr,
                  child: Image.memory(
                    shot.bytes,
                    fit: BoxFit.contain,
                    semanticLabel: 'Your screenshot',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ],
            if (upload.problem != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              SheetAlert(message: upload.problem!),
            ],
            if (upload.error != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              SheetAlert(message: upload.error!),
            ],
            SizedBox(height: ZaveSpace.lg),
            Text(kInvitesPrivacyLine, style: ContestType.meta),
            SizedBox(height: ZaveSpace.md),
            // The rule, with the real numbers, where the decision to send is
            // made.
            Text(
              invitesFakeRule(points),
              style: ZaveType.body.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: ZaveColors.ink85,
              ),
            ),
            SizedBox(height: ZaveSpace.lg),
            ContestPrimaryPill(
              label: 'Send screenshot',
              busy: upload.busy,
              onPressed: shot == null
                  ? null
                  : () => actions.send(lastWeek: lastWeek),
            ),
          ],
        ),
      ),
    );
  }
}

/// A status, its line, and an optional quieter line under it.
class _Notice extends StatelessWidget {
  const _Notice({required this.dot, required this.line, this.meta});

  final ContestDot dot;
  final String line;
  final String? meta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            dot,
            SizedBox(height: ZaveSpace.sm),
            Text(line, style: ZaveType.body.copyWith(fontSize: 15.sp)),
            if (meta != null) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              Text(meta!, style: ContestType.meta),
            ],
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: ContestType.meta);
}
