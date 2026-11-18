import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/contest_controllers.dart';
import '../../application/skip_controllers.dart';
import '../../domain/contest_repository.dart';
import '../../domain/contest_words.dart';
import 'contest_kit.dart';

/// Skip on a level's own page (owner, 17 Nov 2026: "every level gets a skip
/// button"). The web's `tasks/SkipLevel.tsx`.
///
/// Shown only when today's node of [kind] (and, for a claim, of
/// [occurrence]) is the one the server marks `canSkip` — the gate's open
/// level — so it never sits beside a [LockedNotice]: a locked node is never
/// `canSkip`. A ghost pill, never the white one: the page's one primary
/// action is doing the level. After the skip it goes to the next open level,
/// else back to the path.
class ContestSkipLevel extends ConsumerWidget {
  const ContestSkipLevel({required this.kind, this.occurrence, super.key});

  final PathNodeKind kind;

  /// A claim's piece, as the path gave it. Null for every other kind.
  final String? occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PathNode? node = ref
        .watch(contestPathProvider)
        .value
        ?.todayNodeFor(kind, occurrence: occurrence);
    final bool cooling = ref.watch(skipCooldownProvider);
    final SkipBusy busy = ref.watch(contestSkipActionsProvider);
    if (node == null || !node.canSkip || cooling) {
      return const SizedBox.shrink();
    }
    final bool skipping = busy.busyNodeId == node.id;
    final String? error = busy.errorFor(node.id);

    Future<void> skip() async {
      final SkipOutcome? outcome = await ref
          .read(contestSkipActionsProvider.notifier)
          .skip(node.id);
      if (outcome == null || !context.mounted) return;
      final PathNode? next = outcome.next;
      context.go(
        next == null
            ? ZaveRoutes.contest
            : (contestLevelRoute(next) ?? ZaveRoutes.contest),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IntrinsicWidth(
              child: ContestGhostPill(
                label: skipping ? 'Skipping…' : kSkipLabel,
                busy: skipping,
                onPressed: busy.isBusy ? null : skip,
              ),
            ),
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(kSkipNote, style: ContestType.meta),
          if (error != null) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                error,
                style: ContestType.meta.copyWith(
                  color: ContestColors.wrongText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
