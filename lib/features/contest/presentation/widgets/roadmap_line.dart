import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/contest_dates.dart';
import 'contest_kit.dart';

/// The quiet line at the foot of the contest page: the contest ends, the
/// roadmap does not. The web's `RoadmapLine`.
///
/// The contest is an overlay on the 1000-day roadmap, not a replacement for
/// it, so the page says so once and links back — quietly, because this page
/// should not argue with the roadmap.
class RoadmapLine extends StatelessWidget {
  const RoadmapLine({this.lastDayKey, super.key});

  /// The contest's last day, `YYYY-MM-DD`; the sentence about it is left
  /// out when there is no contest to end.
  final String? lastDayKey;

  @override
  Widget build(BuildContext context) {
    final String last = dayKeyShort(lastDayKey);
    final TextStyle style = ContestType.meta.copyWith(height: 1.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${last.isEmpty ? '' : 'The contest’s last day is $last. '}'
          'Your 1000-day roadmap is the bigger goal, and it keeps going after.',
          style: style,
        ),
        Semantics(
          link: true,
          label: 'Back to your roadmap',
          excludeSemantics: true,
          child: InkWell(
            onTap: () => context.go(ZaveRoutes.roadmap),
            borderRadius: ZaveRadius.pillBr,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: ZaveSpace.minTapTarget,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Back to your roadmap',
                    style: style.copyWith(color: ContestColors.peri),
                  ),
                  SizedBox(width: ZaveSpace.xs),
                  const Icon(
                    AppIcons.forward,
                    size: 13,
                    color: ContestColors.peri,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
