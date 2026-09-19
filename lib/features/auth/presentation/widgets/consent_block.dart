import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/auth_repository.dart';

/// What the user decided on the notice.
class ConsentDecision {
  const ConsentDecision({
    required this.acceptedNotice,
    required this.consents,
  });

  /// The required, unticked-by-default acceptance. Without it there is no
  /// account — the server refuses, and so does the mock.
  final bool acceptedNotice;

  /// Optional purposes, keyed by the server's purpose string. An absent or
  /// false entry is a refusal, and is recorded as one.
  final Map<String, bool> consents;

  bool get isComplete => acceptedNotice;
}

/// The DPDP notice + consent block shown on create-account and on the Google
/// sign-up step.
///
/// Three rules this widget exists to enforce, all from s6:
///
///   1. **Nothing is pre-ticked.** A pre-ticked box, or an "by continuing you
///      agree" line, is not the clear affirmative act the Act asks for.
///   2. **The notice comes before collection.** On the Google path this is
///      shown BEFORE any row is written — the server deliberately returns
///      `consent_required` without touching the database.
///   3. **Only what is shown is recorded.** The optional purposes come from
///      the SERVER, so the app cannot record an answer to a question the
///      server never asked.
///
/// Copy is kept aligned with the web's `app/login/page.tsx` so one notice
/// version means one set of words on both platforms.
class ConsentBlock extends StatelessWidget {
  const ConsentBlock({
    required this.decision,
    required this.onChanged,
    this.purposes = const <ConsentPurposeOption>[],
    super.key,
  });

  final ConsentDecision decision;
  final ValueChanged<ConsentDecision> onChanged;

  /// The optional purposes to offer. Empty on the email path until the server
  /// advertises them; the required acceptance is always shown.
  final List<ConsentPurposeOption> purposes;

  void _setAccepted(bool value) => onChanged(
    ConsentDecision(acceptedNotice: value, consents: decision.consents),
  );

  void _setPurpose(String purpose, bool value) {
    final Map<String, bool> next = Map<String, bool>.of(decision.consents);
    next[purpose] = value;
    onChanged(
      ConsentDecision(acceptedNotice: decision.acceptedNotice, consents: next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ConsentRow(
          value: decision.acceptedNotice,
          onChanged: _setAccepted,
          required_: true,
          label:
              'I have read the Privacy Notice and agree to Plexaverse creating '
              'my account and processing my content to generate posts. This '
              'includes sending your content to AI providers outside India.',
        ),
        for (final ConsentPurposeOption p
            in purposes.where((ConsentPurposeOption p) => !p.required_)) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          _ConsentRow(
            value: decision.consents[p.purpose] ?? false,
            onChanged: (bool v) => _setPurpose(p.purpose, v),
            required_: false,
            label: p.label,
          ),
        ],
        SizedBox(height: ZaveSpace.md),
        Text(
          'You can change or withdraw any of these at any time in Settings.',
          style: ZaveType.caption,
        ),
      ],
    );
  }
}

/// One checkbox row.
///
/// A Zave switch would be wrong here: a switch reads as a setting you are
/// adjusting, and this is a statement you are making. Required rows carry an
/// amber dot — the Zave signal for "this one needs you" — rather than a
/// red asterisk, since this palette has no red.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.value,
    required this.onChanged,
    required this.required_,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool required_;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: label,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: ZaveMotion.fast,
              curve: ZaveMotion.curve,
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: value ? ZaveColors.white : ZaveGlass.controlFill,
                border: Border.all(
                  color: value ? ZaveColors.white : ZaveColors.rule,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: value
                  ? const Icon(Icons.check, size: 16, color: ZaveColors.ink)
                  : null,
            ),
            SizedBox(width: ZaveSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (required_) ...<Widget>[
                    Row(
                      children: <Widget>[
                        const ZaveDot(ZaveColors.amber, size: 6),
                        SizedBox(width: ZaveSpace.sm),
                        Text(
                          'REQUIRED',
                          style: ZaveType.kicker.copyWith(
                            color: ZaveColors.amber,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ZaveSpace.xs),
                  ],
                  Text(label, style: ZaveType.caption.copyWith(
                    color: ZaveColors.ink85,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
