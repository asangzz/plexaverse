import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/claim_controllers.dart';
import '../../application/contest_controllers.dart';
import '../../domain/contest_repository.dart';
import '../widgets/contest_kit.dart';
import '../widgets/sheet/contest_sheet.dart';
import '../widgets/skip_level.dart';

/// `/contest/claim?kind=&occurrence=` — one post-link claim, as a level of
/// its posting day. The web's `ClaimLevel`.
///
/// [kind] and [occurrence] are the route's query, as the path's node (or the
/// week card) built it, and they name the claim in `path.claims`. The
/// occurrence is opaque — sent back to the server exactly as it came.
class ContestClaimPage extends ConsumerWidget {
  const ContestClaimPage({
    required this.kind,
    required this.occurrence,
    super.key,
  });

  /// `article` or `video`, as the route spells it.
  final String kind;
  final String occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // An approval or a rejection reaches the learner only through the path,
    // so it is re-read whenever the app comes back to the foreground.
    ref.watch(contestResumeRefreshProvider);
    final ClaimKind claimKind = ClaimKind.parse(kind);
    final bool isVideo = claimKind == ClaimKind.video;
    final AsyncValue<ContestPath> path = ref.watch(contestPathProvider);

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContestSheetHeader(
              kicker: 'LinkedIn · post link',
              title: isVideo
                  ? 'Share your video’s link'
                  : 'Share your article’s link',
              lead: isVideo
                  ? 'Post the video you recorded on LinkedIn, then paste its '
                        'link here.'
                  : 'Paste the article into LinkedIn’s newsletter and publish '
                        'it, then paste its link here.',
            ),
            SizedBox(height: ZaveSpace.xl),
            Text(kClaimsLine, style: ContestType.meta),
          ],
        ),
        _body(path, claimKind),
      ],
    );
  }

  Widget _body(AsyncValue<ContestPath> path, ClaimKind claimKind) {
    final ContestPath? data = path.value;
    if (data == null) {
      if (path.hasError) {
        return Text(contestMessage(path.error!), style: ContestType.meta);
      }
      return const ContestSheetSkeleton();
    }
    if (data.status != ContestPathStatus.running) {
      return Text(
        'Links are claimed while the contest runs, by its entrants.',
        style: ContestType.meta,
      );
    }
    final ClaimLevel level = claimLevelOf(data, claimKind, occurrence);
    final PostClaim? claim = level.claim;
    if (claim == null) {
      return Text(
        'This piece is not open to claim. Check the week card on the path for '
        'what is.',
        style: ContestType.meta,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _ClaimRow(claim: claim, lockedDetail: level.lockedDetail),
        ContestSkipLevel(
          kind: claim.kind == ClaimKind.article
              ? PathNodeKind.article
              : PathNodeKind.video,
          occurrence: claim.occurrence,
        ),
      ],
    );
  }
}

/// One claim: its status, and a link field while it can be claimed — open,
/// or rejected and sent again. The web's `ClaimRow`.
class _ClaimRow extends ConsumerStatefulWidget {
  const _ClaimRow({required this.claim, required this.lockedDetail});

  final PostClaim claim;
  final String? lockedDetail;

  @override
  ConsumerState<_ClaimRow> createState() => _ClaimRowState();
}

class _ClaimRowState extends ConsumerState<_ClaimRow> {
  final TextEditingController _link = TextEditingController();

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  /// Sent and waiting, or approved: the link is shown, the form is not.
  static bool _handedIn(ClaimStatus status) =>
      status == ClaimStatus.pending || status == ClaimStatus.approved;

  static (ContestTone, String) _status(ClaimStatus status) => switch (status) {
    ClaimStatus.notReady => (ContestTone.idle, 'Not open yet'),
    ClaimStatus.open => (ContestTone.waiting, 'Share the link'),
    ClaimStatus.pending => (ContestTone.waiting, 'Waiting for our team'),
    ClaimStatus.approved => (ContestTone.live, 'Approved'),
    ClaimStatus.rejected => (ContestTone.wrong, 'Not approved'),
  };

  @override
  Widget build(BuildContext context) {
    final PostClaim listed = widget.claim;
    final ClaimActionsProvider provider = claimActionsProvider(
      listed.kind,
      listed.occurrence,
    );
    final ClaimSend send = ref.watch(provider);
    // Once sent, the server's answer — pending, with the link it normalised
    // — stands for the claim until the re-read path has caught up with it.
    final PostClaim? sent = send.sent;
    final PostClaim claim = sent != null && !_handedIn(listed.status)
        ? sent
        : listed;
    final String? locked = widget.lockedDetail;
    final (ContestTone tone, String word) = _status(claim.status);
    final String opens = weekdayDate(claim.opensOnKey);
    final String goesOut = weekdayDate(claim.postingDayKey);
    final bool isArticle = claim.kind == ClaimKind.article;
    final bool canClaim =
        locked == null &&
        sent == null &&
        (claim.status == ClaimStatus.open ||
            claim.status == ClaimStatus.rejected);
    final String? postUrl = claim.postUrl;
    final bool handedIn = _handedIn(claim.status);

    return Semantics(
      label: '${isArticle ? 'Article' : 'Video'}: ${claim.title}',
      container: true,
      child: ContestPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(isArticle ? 'Article' : 'Video', style: ContestType.meta),
            SizedBox(height: ZaveSpace.xs),
            Text(claim.title, style: ContestType.cardTitle),
            if (goesOut.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xs),
              Text('Goes out $goesOut', style: ContestType.meta),
            ],
            SizedBox(height: ZaveSpace.md),
            Wrap(
              spacing: ZaveSpace.lg,
              runSpacing: ZaveSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                ContestDot(tone: tone, label: word),
                if (claim.points > 0) XpTag(points: claim.points),
              ],
            ),
            if (locked != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Text(
                '$locked. Finish it on the path, then come back here.',
                style: ZaveType.body.copyWith(fontSize: 15.sp),
              ),
            ] else if (claim.status == ClaimStatus.notReady) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Text(
                opens.isNotEmpty
                    ? 'You can share its link from $opens, the day it goes out.'
                    : 'You can share its link from the day it goes out.',
                style: ContestType.meta,
              ),
            ],
            if (claim.status == ClaimStatus.rejected) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              Text(
                '${claim.rejectReason ?? 'Our team could not approve that link.'} '
                'Send the right link below.',
                style: ZaveType.body.copyWith(fontSize: 15.sp),
              ),
            ],
            if (handedIn && postUrl != null) ...<Widget>[
              SizedBox(height: ZaveSpace.sm),
              SheetLink(
                label: postUrl,
                size: 14,
                icon: AppIcons.openExternal,
                onTap: () => openLinkAndReport(context, ref, postUrl),
              ),
            ],
            if (handedIn) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              NextLevelPill(
                from: isArticle ? PathNodeKind.article : PathNodeKind.video,
              ),
            ],
            if (canClaim) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              ZaveField(
                controller: _link,
                pill: true,
                hint: 'https://www.linkedin.com/posts/…',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.send,
                autofillHints: const <String>[AutofillHints.url],
                onChanged: (_) => ref.read(provider.notifier).edited(),
                onSubmitted: (String raw) =>
                    ref.read(provider.notifier).submit(raw),
              ),
              SizedBox(height: ZaveSpace.md),
              ListenableBuilder(
                listenable: _link,
                builder: (BuildContext context, Widget? _) => ContestGhostPill(
                  label: 'Submit',
                  busy: send.busy,
                  onPressed: _link.text.trim().isEmpty
                      ? null
                      : () => ref.read(provider.notifier).submit(_link.text),
                ),
              ),
            ],
            if (send.problem != null || send.error != null) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              SheetAlert(
                message: send.problem ?? send.error!,
                backToPath: send.locked,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
