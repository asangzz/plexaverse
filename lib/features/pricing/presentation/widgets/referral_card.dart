import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/pricing.dart';

/// "Refer & Earn" — the code, its counters, and the one action.
///
/// ## Why this copies a CODE and not a LINK
///
/// The web copies `{window.location.host}/login?ref={code}`. A phone has no
/// `window.location`, and the app knows only its **API** base URL
/// (`…/api/mobile/v1`), which is not the sign-up origin — deriving a public URL
/// from it would produce a link that either 404s or points at the wrong
/// environment. Rather than guess a hostname into a user's WhatsApp message,
/// this copies the code itself and says what to do with it. The dependency the
/// link form needs is reported in the summary.
class ReferralCard extends StatelessWidget {
  const ReferralCard({
    required this.summary,
    required this.onGenerate,
    super.key,
  });

  final ReferralSummary summary;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('REFER & EARN', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'Both of you get +${groupedNumber(kReferralXp)} XP — a full week of '
            'automation',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.xl),

          if (!summary.hasCode)
            ZaveButton(
              label: 'Generate referral code',
              kind: ZaveButtonKind.primarySmall,
              onPressed: onGenerate,
              expand: true,
            )
          else ...<Widget>[
            Text('YOUR REFERRAL CODE', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.sm),
            Container(
              width: double.infinity,
              decoration: ZaveSurface.codeBlock,
              padding: ZaveSpace.inputPad,
              child: SelectableText(
                summary.code!,
                style: ZaveType.mono.copyWith(color: ZaveColors.white),
              ),
            ),
            SizedBox(height: ZaveSpace.md),
            _CopyButton(code: summary.code!),
            SizedBox(height: ZaveSpace.md),
            Text(
              'Share it with a friend. They enter it when they sign up on '
              'plexaverse.com, and you both get the XP.',
              style: ZaveType.caption,
            ),

            if (summary.totalReferrals > 0) ...<Widget>[
              SizedBox(height: ZaveSpace.xl),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _Counter(
                      value: '${summary.totalReferrals}',
                      label: 'Friends referred',
                      color: ZaveColors.white,
                    ),
                  ),
                  SizedBox(width: ZaveSpace.md),
                  Expanded(
                    child: _Counter(
                      // Amber: XP is points.
                      value: '+${groupedNumber(summary.totalXpEarned)}',
                      label: 'XP earned',
                      color: ZaveColors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Copy-to-clipboard, with the "Copied" acknowledgement the web shows for two
/// seconds. Stateful because that acknowledgement is the only feedback a copy
/// ever gives.
class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});

  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return ZaveButton(
      label: _copied ? 'Copied' : 'Copy code',
      icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded),
      onPressed: _copy,
      expand: true,
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ZaveSurface.row,
      padding: ZaveSpace.rowPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(value, style: ZaveType.h3.copyWith(color: color)),
          SizedBox(height: ZaveSpace.xs),
          Text(label.toUpperCase(), style: ZaveType.kicker),
        ],
      ),
    );
  }
}
