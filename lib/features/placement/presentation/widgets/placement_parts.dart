/// The pieces more than one placement screen draws — a port of the web's
/// `components/placement/shared.tsx`.
///
/// ## Nothing here knows right from wrong
///
/// These render bands and words. No widget takes an item and an answer, so
/// there is nowhere on the page a correctness check could be bolted on.
///
/// ## Neutral, never amber
///
/// Every placement message is "try again" or "come back later", never
/// something the learner did wrong — and amber on this page would be the one
/// colour that could be misread as a marked answer. So notices and errors
/// alike take the inert dot.
library;

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/placement_repository.dart';
import '../../domain/placement_words.dart';

/// A kicker, the screen's title and an optional lead, with a Plexa moment
/// beside them when the screen has one.
class PlacementHeading extends StatelessWidget {
  const PlacementHeading({
    required this.kicker,
    required this.title,
    this.lead,
    this.beside,
    super.key,
  });

  final String kicker;
  final String title;
  final String? lead;
  final Widget? beside;

  @override
  Widget build(BuildContext context) {
    final Widget words = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(kicker.toUpperCase(), style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.sm),
        Text(title, style: ZaveType.h2),
        if (lead case final String lead) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(lead, style: ZaveType.lead),
        ],
      ],
    );
    final Widget? moment = beside;
    if (moment == null) return words;
    return Row(
      children: <Widget>[
        Expanded(child: words),
        SizedBox(width: ZaveSpace.md),
        moment,
      ],
    );
  }
}

/// The inert dot and its word. The word is not optional: a bare dot says
/// nothing to anyone who cannot separate the hues.
class PlacementDotLine extends StatelessWidget {
  const PlacementDotLine(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Centred on the first line of the word, which may wrap.
      const Padding(
        padding: EdgeInsets.only(top: 5),
        child: ZaveDot(ZaveColors.ink35, size: 8),
      ),
      SizedBox(width: ZaveSpace.sm),
      Expanded(child: Text(text, style: _meta)),
    ],
  );
}

/// One neutral line saying why the screen changed under the learner.
class PlacementNotice extends StatelessWidget {
  const PlacementNotice(this.text, {super.key});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final String? line = text;
    if (line == null || line.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.xl),
      child: Semantics(liveRegion: true, child: PlacementDotLine(line)),
    );
  }
}

/// A failed request: what failed, then the server's words (or the page's own,
/// for the codes whose words are the page's — see `placementMessage`).
class PlacementErrorLine extends StatelessWidget {
  const PlacementErrorLine({required this.title, this.message, super.key});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final String? words = message;
    if (words == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.lg),
      child: Semantics(
        liveRegion: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PlacementDotLine(title),
            SizedBox(height: ZaveSpace.xs),
            Text(words, style: _meta),
          ],
        ),
      ),
    );
  }
}

/// The band as the hero: the code huge, the plain name under it.
///
/// White, not amber. Amber is points and "waiting on you"; a band is neither,
/// and the contest page already has an amber figure meaning contest XP.
class BandHero extends StatelessWidget {
  const BandHero({required this.band, required this.label, super.key});

  final CefrBand band;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(label, style: _meta),
      SizedBox(height: ZaveSpace.sm),
      Text(band.wire, style: ZaveType.hero),
      SizedBox(height: ZaveSpace.sm),
      Text(
        band.plainName,
        style: ZaveType.h3.copyWith(color: ZaveColors.ink85),
      ),
    ],
  );
}

/// The three parts, one tile each, stacked as the web stacks them on a phone.
///
/// A PART NOBODY TESTED SHOWS NO BAND. A test that closed on a walk-away
/// stores a value for every part, but one it never reached holds a CREDITED
/// value — printed as a band, it reads as a score the learner earned.
class SkillBands extends StatelessWidget {
  const SkillBands({required this.bands, required this.measured, super.key});

  final Map<ObjectiveSkill, CefrBand> bands;
  final PlacementMeasured measured;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (final ObjectiveSkill skill in ObjectiveSkill.values) ...<Widget>[
        if (skill.index > 0) SizedBox(height: ZaveSpace.sm),
        _SkillTile(
          skill: skill,
          band: bands[skill],
          tested: measured.of(skill),
        ),
      ],
    ],
  );
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({
    required this.skill,
    required this.band,
    required this.tested,
  });

  final ObjectiveSkill skill;
  final CefrBand? band;
  final bool tested;

  @override
  Widget build(BuildContext context) {
    final CefrBand? shown = tested ? band : null;
    return ZaveCard(
      size: ZaveCardSize.small,
      padding: ZaveSpace.rowPad,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(skill.label, style: _meta),
                if (shown != null) ...<Widget>[
                  SizedBox(height: ZaveSpace.xs),
                  Text(shown.plainName, style: _meta),
                ],
              ],
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          Text(
            shown?.wire ?? notTestedLabel,
            style: shown == null
                ? ZaveType.h3.copyWith(color: ZaveColors.ink62)
                : ZaveType.h2,
          ),
        ],
      ),
    );
  }
}

/// [closedEarlyLine] for a result that closed before it finished.
class ClosedEarlyNote extends StatelessWidget {
  const ClosedEarlyNote({required this.closedEarly, super.key});

  final bool closedEarly;

  @override
  Widget build(BuildContext context) {
    if (!closedEarly) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.lg),
      child: Text(closedEarlyLine, style: _meta),
    );
  }
}

/// A result as a card: the band, the three parts under it, and what an
/// unfinished test does to a level when this one closed early. The intro's
/// "your level is set" card and the result screen draw the same one.
class PlacementResultCard extends StatelessWidget {
  const PlacementResultCard({
    required this.band,
    required this.skills,
    required this.measured,
    required this.closedEarly,
    super.key,
  });

  final CefrBand band;
  final Map<ObjectiveSkill, CefrBand>? skills;
  final PlacementMeasured measured;
  final bool closedEarly;

  @override
  Widget build(BuildContext context) {
    final Map<ObjectiveSkill, CefrBand>? parts = skills;
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BandHero(band: band, label: 'Your level'),
          if (parts != null) ...<Widget>[
            SizedBox(height: ZaveSpace.xl),
            SkillBands(bands: parts, measured: measured),
          ],
          ClosedEarlyNote(closedEarly: closedEarly),
        ],
      ),
    );
  }
}

/// The writing result, apart from the three parts, saying it does not count.
///
/// A model graded it, and a model's grade can be neither reproduced nor
/// appealed, so it never reaches the band. In the same row as the three parts
/// it would look averaged in.
///
/// Graded: the band, its feedback, "feedback only". Not graded: the learner
/// wrote and the provider refused it for good — said, because a section that
/// silently vanishes reads as "your writing was thrown away". Not written:
/// nothing at all, because skipping costs nothing.
class WritingPanel extends StatelessWidget {
  const WritingPanel({
    required this.writingBand,
    required this.feedback,
    required this.submitted,
    this.title = 'Writing',
    super.key,
  });

  final CefrBand? writingBand;
  final WritingFeedback? feedback;

  /// Text was sent for grading, whether or not a grade came back.
  final bool submitted;
  final String title;

  @override
  Widget build(BuildContext context) {
    final CefrBand? band = writingBand;
    final List<String> strengths = feedback?.strengths ?? const <String>[];
    final List<String> improvements =
        feedback?.improvements ?? const <String>[];
    final bool hasFeedback = strengths.isNotEmpty || improvements.isNotEmpty;
    if (band == null && !submitted && !hasFeedback) {
      return const SizedBox.shrink();
    }

    // Spaced from whatever is above it by itself, so a panel that draws
    // nothing leaves no gap behind.
    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.xl),
      child: ZaveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Expanded(child: Text(title, style: ZaveType.h3)),
                if (band != null) Text(band.wire, style: ZaveType.h3),
              ],
            ),
            SizedBox(height: ZaveSpace.md),
            Text(
              band == null && submitted
                  ? 'We could not grade this writing. Your level is unaffected.'
                  : 'Feedback only. It does not change your level.',
              style: _meta,
            ),
            if (strengths.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xl),
              _FeedbackList(title: 'What works', items: strengths),
            ],
            if (improvements.isNotEmpty) ...<Widget>[
              SizedBox(height: ZaveSpace.xl),
              _FeedbackList(title: 'What to improve', items: improvements),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeedbackList extends StatelessWidget {
  const _FeedbackList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(title, style: ZaveType.h3),
      for (final String item in items) ...<Widget>[
        SizedBox(height: ZaveSpace.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: ZaveColors.ink35,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(child: Text(item, style: ZaveType.bodyMuted)),
          ],
        ),
      ],
    ],
  );
}

/// [placementDisclaimer], on every screen that shows a band.
class PlacementDisclaimer extends StatelessWidget {
  const PlacementDisclaimer({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: ZaveSpace.xl),
    child: Text(placementDisclaimer, style: _meta),
  );
}

/// The web's `meta`: small, quiet, and readable over two lines.
TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);
