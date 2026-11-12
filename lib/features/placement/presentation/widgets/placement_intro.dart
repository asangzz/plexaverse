import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/placement_repository.dart';
import '../../domain/placement_words.dart';
import 'placement_parts.dart';

/// Before the first question: what the test is, what it changes, and one
/// button. A port of the web's `PlacementIntro.tsx`.
///
/// ## Three variants, read off the status
///
/// - **In progress** — "Pick up where you left off". Continue is the same call
///   as Start (the server resumes the open attempt); only the words differ.
///   It says when the attempt closes and what closing does.
/// - **Cooling down** — the level they have and the date they can retake. The
///   one primary button goes to today's lesson: a disabled Start would be the
///   screen's accent pointing at nothing.
/// - **Can start** — the explainer. A learner who already has a level is told
///   it, and told the new result replaces it even if lower, because it applies
///   the moment the third part ends.
///
/// ## No request on arrival
///
/// Nothing is sent until the learner presses. Landing here from a stray link
/// must not start a test — a started test is what the 30-day cooldown counts
/// from once it finishes.
///
/// ## The card re-reads itself at the closing time
///
/// While it offers Continue, the attempt it offers closes at `closesAt` on the
/// server's next read. So when that moment passes (plus a little grace — the
/// close is on the server's clock), [onClosePassed] asks for a fresh status,
/// and the card turns into the result the attempt closed with instead of a
/// Continue the server would refuse. Once per `closesAt`: a server still
/// holding it open answers the same time, and nothing loops.
class PlacementIntro extends StatefulWidget {
  const PlacementIntro({
    required this.status,
    required this.starting,
    required this.busy,
    required this.onStart,
    required this.onWrite,
    required this.onLesson,
    required this.onClosePassed,
    this.startError,
    this.notice,
    super.key,
  });

  final PlacementStatus status;

  /// Start (or Continue) is in flight.
  final bool starting;

  /// Anything is in flight; every control waits.
  final bool busy;

  /// Why the last Start failed, in one sentence.
  final String? startError;

  /// Why the learner is back here, when the screen they were on stopped
  /// applying.
  final String? notice;

  final VoidCallback onStart;

  /// Open the optional writing step for `status.latest`.
  final ValueChanged<String> onWrite;

  /// Today's contest lesson — the cooling-down card's one primary action.
  final VoidCallback onLesson;

  /// The open attempt's closing time passed; re-read the status.
  final ValueChanged<String> onClosePassed;

  @override
  State<PlacementIntro> createState() => _PlacementIntroState();
}

class _PlacementIntroState extends State<PlacementIntro> {
  Timer? _closing;

  /// Past `closesAt`, wait this long before re-reading: a read a hair early
  /// would only find the attempt still open.
  static const Duration _grace = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _arm();
  }

  @override
  void didUpdateWidget(PlacementIntro old) {
    super.didUpdateWidget(old);
    final PlacementInProgress? before = old.status.inProgress;
    final PlacementInProgress? now = widget.status.inProgress;
    if (before?.attemptId != now?.attemptId ||
        before?.closesAt != now?.closesAt) {
      _arm();
    }
  }

  void _arm() {
    _closing?.cancel();
    _closing = null;
    final PlacementInProgress? open = widget.status.inProgress;
    final DateTime? closesAt = open?.closesAt;
    if (open == null || closesAt == null) return;
    Duration wait = closesAt.difference(DateTime.now());
    if (wait.isNegative) wait = Duration.zero;
    final String attemptId = open.attemptId;
    _closing = Timer(wait + _grace, () {
      if (mounted) widget.onClosePassed(attemptId);
    });
  }

  @override
  void dispose() {
    _closing?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlacementStatus status = widget.status;
    final PlacementInProgress? open = status.inProgress;
    final PlacementSummary? latest = status.latest;

    // ── In progress ──────────────────────────────────────────────────────
    if (open != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PlacementNotice(widget.notice),
          PlacementHeading(
            kicker: 'Placement test',
            title: 'Pick up where you left off',
            lead: answeredLine(open.answered),
          ),
          SizedBox(height: ZaveSpace.md),
          Text(
            closesLine(closesAt: open.closesAt, answered: open.answered),
            style: ZaveType.lead,
          ),
          SizedBox(height: ZaveSpace.xl),
          _StartButton(
            label: 'Continue the test',
            starting: widget.starting,
            busy: widget.busy,
            onStart: widget.onStart,
          ),
          PlacementErrorLine(
            title: 'Could not continue',
            message: widget.startError,
          ),
          const PlacementDisclaimer(),
        ],
      );
    }

    // ── Cooling down ─────────────────────────────────────────────────────
    if (!status.canStart) {
      final DateTime? retake = status.nextRetakeAt;
      final CefrBand? band = latest?.band;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PlacementNotice(widget.notice),
          PlacementHeading(
            kicker: 'Placement test',
            title: 'Your level is set',
            lead: retake == null
                ? null
                : 'You can retake the test on ${longDate(retake)}.',
          ),
          if (latest != null) ...<Widget>[
            _LatestResult(latest: latest),
            _LatestWriting(
              latest: latest,
              last: false,
              busy: widget.busy,
              onWrite: widget.onWrite,
            ),
          ],
          SizedBox(height: ZaveSpace.xl),
          ZaveButton.primary(
            label: 'Start today’s lesson',
            trailing: const Icon(AppIcons.forward),
            expand: true,
            onPressed: widget.busy ? null : widget.onLesson,
          ),
          if (band != null) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(newLessonsLine(band), style: _meta),
          ],
          const PlacementDisclaimer(),
        ],
      );
    }

    // ── Ready to start (or retake) ───────────────────────────────────────
    final bool retake = status.hasPlacement;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PlacementNotice(widget.notice),
        PlacementHeading(
          kicker: 'Placement test',
          title: retake ? 'Check your level' : 'Find your level',
          lead:
              'About 15 minutes. Three short parts and an optional writing '
              'task.',
        ),
        SizedBox(height: ZaveSpace.xl),
        Text(
          retake
              ? 'Your level is ${status.band.wire}. Your result replaces it, '
                    'even if it is lower, and sets the level new lessons are '
                    'written at.'
              : 'Your result sets the level new lessons are written at.',
          style: ZaveType.body,
        ),
        // A walk-away close is stamped at its closing time, so a learner back
        // 30+ days later lands here with the cooldown already over — and with
        // a level that dropped while they were away. This card is the only
        // place that says why.
        if (latest != null && latest.closedEarly) _LatestResult(latest: latest),
        SizedBox(height: ZaveSpace.xl),
        const _Parts(),
        SizedBox(height: ZaveSpace.xl),
        _StartButton(
          label: retake ? 'Retake the test' : 'Start the test',
          starting: widget.starting,
          busy: widget.busy,
          onStart: widget.onStart,
        ),
        SizedBox(height: ZaveSpace.md),
        Text(
          'Nothing is marked until the end. Pick the answer you think is '
          'right.',
          style: _meta,
        ),
        PlacementErrorLine(
          title: 'Could not start',
          message: widget.startError,
        ),
        if (retake && latest != null)
          _LatestWriting(
            latest: latest,
            last: true,
            busy: widget.busy,
            onWrite: widget.onWrite,
          ),
        const PlacementDisclaimer(),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.label,
    required this.starting,
    required this.busy,
    required this.onStart,
  });

  final String label;
  final bool starting;
  final bool busy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => ZaveButton.primary(
    label: label,
    trailing: const Icon(AppIcons.forward),
    expand: true,
    busy: starting,
    onPressed: busy ? null : onStart,
  );
}

/// The four parts, each a title and a line. The web's `PARTS`.
class _Parts extends StatelessWidget {
  const _Parts();

  static const List<(String, String)> _parts = <(String, String)>[
    ('Vocabulary', 'Words in context. Pick the one that fits.'),
    ('Grammar', 'Choose the form a sentence needs.'),
    ('Reading', 'Short passages, with a question on each.'),
    (
      'Writing, if you like',
      'One short piece, graded by AI. Feedback only. It never changes your '
          'level.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'The parts of the test',
    child: ZaveCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < _parts.length; i++) ...<Widget>[
            if (i > 0) const Divider(height: 1, color: ZaveColors.rule),
            Padding(
              padding: ZaveSpace.cardPad,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_parts[i].$1, style: ZaveType.h3),
                  SizedBox(height: ZaveSpace.xs),
                  Text(_parts[i].$2, style: ZaveType.bodyMuted),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// The latest result as a card — only when its band reads as one. A blank
/// card where a level should be reads as "nothing happened".
class _LatestResult extends StatelessWidget {
  const _LatestResult({required this.latest});

  final PlacementSummary latest;

  @override
  Widget build(BuildContext context) {
    final CefrBand? band = latest.band;
    if (band == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.xl),
      child: PlacementResultCard(
        band: band,
        skills: latest.skillBands,
        measured: latest.measured,
        closedEarly: latest.closedEarly,
      ),
    );
  }
}

/// The latest result's writing: its panel if any was sent, and the offer
/// while none has been. Shown in the cooldown AND once a retake is open — the
/// server takes writing for the latest result until a newer one replaces it,
/// so the offer must not vanish on day 31.
///
/// [last] words both for the retake explainer, where the result they belong
/// to is the one a new test would replace, not one on screen.
class _LatestWriting extends StatelessWidget {
  const _LatestWriting({
    required this.latest,
    required this.last,
    required this.busy,
    required this.onWrite,
  });

  final PlacementSummary latest;
  final bool last;
  final bool busy;
  final ValueChanged<String> onWrite;

  @override
  Widget build(BuildContext context) {
    final Widget panel = WritingPanel(
      writingBand: latest.writingBand,
      feedback: latest.writingFeedback,
      // A completed attempt is pending exactly until its text is in.
      submitted: !latest.writingPending,
      title: last ? 'Writing from your last test' : 'Writing',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (!latest.writingPending) panel,
        if (latest.writingPending) ...<Widget>[
          SizedBox(height: ZaveSpace.xl),
          ZaveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  last
                      ? 'Add writing to your last result'
                      : 'Writing, if you like',
                  style: ZaveType.h3,
                ),
                SizedBox(height: ZaveSpace.sm),
                Text(
                  'One short piece, graded by AI, added once to '
                  '${last ? 'your last' : 'this'} result. Feedback only. It '
                  'never changes your level.',
                  style: ZaveType.bodyMuted,
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveButton(
                  label: 'Add the writing',
                  onPressed: busy ? null : () => onWrite(latest.attemptId),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);
