import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/placement_repository.dart';
import 'placement_parts.dart';

/// The optional writing task, and the consent it needs. A port of the web's
/// `PlacementWriting.tsx`.
///
/// ## Consent is asked here, on the button that uses it
///
/// `assessment_grading` covers one thing: this text going to an AI provider
/// to be graded. So the explanation sits directly above the one button that
/// sends it, and pressing "Grade my writing" under those words IS the
/// affirmative act — recorded first, as `in_context`, and only then is the
/// text sent.
///
/// ## Declining costs nothing, and the copy says so
///
/// The level is already set by the time this screen shows. "Skip writing"
/// only shows the result that is stored; writing never moves the band. A
/// learner who thinks skipping lowers their score will agree to a disclosure
/// under pressure, which is not consent — so nothing here may suggest the
/// level waits on this step.
///
/// ## The draft survives every failure that is not "this attempt moved on"
///
/// It lives in this widget, which the page keeps mounted while the writing
/// screen is up. A grading failure worth retrying stored nothing, and losing
/// a paragraph to someone else's outage is the one thing this screen must not
/// do. "Already in" keeps it too, until a fresh status says which way it went.
///
/// ## The limits are the server's
///
/// [WritingTask] carries the same minimum and maximum the server enforces,
/// counted after trimming, as the server counts — thirty spaces is not thirty
/// characters of writing.
class PlacementWriting extends StatefulWidget {
  const PlacementWriting({
    required this.task,
    required this.needsAgreement,
    required this.grading,
    required this.skipping,
    required this.checking,
    required this.onGrade,
    required this.onSkip,
    required this.onPrivacy,
    this.errorTitle = '',
    this.error,
    super.key,
  });

  final WritingTask task;

  /// No agreement on record, so pressing Grade records one. False when the
  /// learner agreed earlier — the card then says so instead of asking again.
  final bool needsAgreement;

  /// Recording consent or grading is in flight.
  final bool grading;

  /// Reading back the result without writing is in flight.
  final bool skipping;

  /// A refused send is being checked against a fresh status. The draft stays;
  /// nothing can be pressed.
  final bool checking;

  /// What failed, in a few words: "Not graded yet", "Could not show your
  /// result".
  final String errorTitle;
  final String? error;
  final ValueChanged<String> onGrade;
  final VoidCallback onSkip;

  /// Open the privacy notice — the notice must be reachable at the moment
  /// consent is taken.
  final VoidCallback onPrivacy;

  @override
  State<PlacementWriting> createState() => _PlacementWritingState();
}

class _PlacementWritingState extends State<PlacementWriting> {
  final TextEditingController _text = TextEditingController();

  @override
  void initState() {
    super.initState();
    _text.addListener(_onText);
  }

  /// The count and the button follow the text.
  void _onText() => setState(() {});

  @override
  void dispose() {
    _text
      ..removeListener(_onText)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WritingTask task = widget.task;
    final bool held = widget.grading || widget.skipping || widget.checking;
    final int length = _text.text.trim().length;
    final int shortBy = (task.minChars - length).clamp(0, task.minChars);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const PlacementHeading(
          kicker: 'Writing · optional',
          title: 'One short piece',
          lead:
              'Your level is already set. This is feedback on how you write, '
              'and it does not change your level.',
        ),
        SizedBox(height: ZaveSpace.xl),
        Text(task.prompt, style: ZaveType.body),
        SizedBox(height: ZaveSpace.sm),
        Text(task.hint, style: _meta),
        SizedBox(height: ZaveSpace.md),
        ZaveField(
          controller: _text,
          enabled: !held,
          maxLines: 10,
          minLines: 6,
          maxLength: task.maxChars,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          hint: 'Write in your own words.',
        ),
        SizedBox(height: ZaveSpace.sm),
        Semantics(
          liveRegion: true,
          child: Text(
            '${_count(length)} / ${_count(task.maxChars)} characters'
            '${shortBy > 0 && length > 0 ? ' · ${_count(shortBy)} more to go' : ''}',
            style: _meta,
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveCard(
          size: ZaveCardSize.small,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Grading sends your text to an AI provider',
                style: ZaveType.label,
              ),
              SizedBox(height: ZaveSpace.sm),
              Text(
                'It comes back with what works and what to improve. '
                '${widget.needsAgreement ? 'Pressing Grade my writing is your agreement.' : 'You agreed to this earlier. You can withdraw it in Settings.'} '
                'Skip it and your level stays exactly as it is.',
                style: ZaveType.bodyMuted,
              ),
              SizedBox(height: ZaveSpace.sm),
              Semantics(
                link: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onPrivacy,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: ZaveSpace.xs),
                    child: Text(
                      'How we handle your data',
                      style: ZaveType.label.copyWith(color: ZaveColors.peri),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.xl),
        ZaveButton.primary(
          label: widget.grading ? 'Grading…' : 'Grade my writing',
          expand: true,
          busy: widget.grading,
          onPressed: held || shortBy > 0
              ? null
              : () => widget.onGrade(_text.text),
        ),
        SizedBox(height: ZaveSpace.sm),
        ZaveButton(
          label: 'Skip writing',
          expand: true,
          busy: widget.skipping,
          onPressed: held ? null : widget.onSkip,
        ),
        if (widget.grading) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text('This takes a few seconds.', style: _meta),
        ] else if (widget.checking) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text('Checking your result…', style: _meta),
        ],
        // A refusal being checked: its words would only flash before the
        // answer replaced them.
        if (!widget.checking)
          PlacementErrorLine(title: widget.errorTitle, message: widget.error),
      ],
    );
  }
}

String _count(int n) => NumberFormat.decimalPattern().format(n);

TextStyle get _meta => ZaveType.caption.copyWith(height: 1.6);
