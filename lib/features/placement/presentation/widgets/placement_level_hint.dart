import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/placement_controllers.dart';
import '../../domain/placement_repository.dart';

/// "Set your level first" — the levels page's way into the placement test.
/// A port of the web's `SetLevelHint.tsx`, over the path since 24 Nov 2026,
/// when the join card it sat on was retired.
///
/// ## Why the contest points here
///
/// The band is the level an entrant's lessons are written at AND the
/// multiplier on their right answers. An entrant who never placed is scored
/// at B2 on B2 lessons — fair, but not theirs. The contest is where that
/// matters most, so it is where the nudge sits.
///
/// ## Quiet, and gone once it has done its job
///
/// A line and a ghost button: the page's one primary button is the path's,
/// and this must not compete with it. Nothing renders while the status loads,
/// if it fails, or once the learner has a placement — a hint that flashes in
/// and out, or nags someone already placed, is noise.
class PlacementLevelHint extends ConsumerWidget {
  const PlacementLevelHint({this.padding = EdgeInsets.zero, super.key});

  /// Around the hint when it shows — nothing at all when it does not.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PlacementStatus> status = ref.watch(
      placementStatusProvider,
    );
    final PlacementStatus? value = status.hasError ? null : status.value;
    if (value == null || value.hasPlacement) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: Semantics(
        label: 'Your level',
        container: true,
        child: ZaveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Set your level first. It decides how hard your lessons are.',
                style: ZaveType.body,
              ),
              SizedBox(height: ZaveSpace.lg),
              ZaveButton(
                label: 'Take the placement test',
                onPressed: () => context.push(ZaveRoutes.placement),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
