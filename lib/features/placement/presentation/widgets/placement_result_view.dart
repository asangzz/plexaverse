import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../plexa/presentation/widgets/plexa_moment.dart';
import '../../domain/placement_repository.dart';
import '../../domain/placement_words.dart';
import 'placement_parts.dart';

/// The result: the band, how it was reached, and what it changes. A port of
/// the web's `PlacementResultView.tsx`.
///
/// ## The band was set before this screen, not by it
///
/// It applied the moment the third part finished — before the optional
/// writing, and whether or not the learner pressed anything after that. So
/// nothing here says "now" about it, and the retake date counts from when the
/// result was set, which for writing added later is not today.
///
/// ## A test that closed early says so, part by part
///
/// Its band is shown as given — it is the level that applies — but a part it
/// never reached says "Not tested" rather than the value it was credited, and
/// one line under the tiles says what an unfinished test does to a level.
///
/// ## The disclaimer is on every result
///
/// A big "B2" on a dark card looks like a certificate, and nothing in this
/// product may present it as one.
class PlacementResultView extends StatelessWidget {
  const PlacementResultView({
    required this.result,
    required this.onLesson,
    super.key,
  });

  final PlacementResult result;

  /// Today's contest lesson — new lessons are written at this band.
  final VoidCallback onLesson;

  @override
  Widget build(BuildContext context) {
    final CefrBand? band = result.band;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const PlacementHeading(
          kicker: 'Placement test',
          title: 'Your result',
          beside: PlexaMoment(PlexaMomentClip.placementResult, width: 128),
        ),
        if (band != null) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          PlacementResultCard(
            band: band,
            skills: result.skillBands,
            measured: result.measured,
            closedEarly: result.closedEarly,
          ),
        ],
        WritingPanel(
          writingBand: result.writingBand,
          feedback: result.writingFeedback,
          submitted: result.writingSubmitted,
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: 'Start today’s lesson',
          trailing: const Icon(AppIcons.forward),
          expand: true,
          onPressed: onLesson,
        ),
        if (band != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(newLessonsLine(band), style: _meta),
        ],
        SizedBox(height: ZaveSpace.xl),
        Text(retakeLine(result.completedAt, now: DateTime.now()), style: _meta),
        const PlacementDisclaimer(),
      ],
    );
  }
}

TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);
