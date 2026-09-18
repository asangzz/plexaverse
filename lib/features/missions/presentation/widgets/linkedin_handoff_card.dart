import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The hand-off to LinkedIn's own editor.
///
/// ## Why this is a card of instructions and not a button
///
/// On the web this is `LinkedInWebviewPanel`: a 520px drawer that slides in
/// with LinkedIn's edit form loaded inside it, so the user pastes without ever
/// leaving the page. Reproducing that needs an embedded browser
/// (`webview_flutter`) or at minimum the ability to open a URL
/// (`url_launcher`), and the app ships **neither** — and this slice may not add
/// a dependency.
///
/// So the card does the two things it actually can: it copies the text to the
/// clipboard, and it hands over the exact URL plus the same step list the web
/// panel shows. A button that opened nothing would be worse than a sentence
/// that explains itself. The dependency is reported in the summary.
class LinkedInHandoffCard extends StatelessWidget {
  const LinkedInHandoffCard({
    required this.title,
    required this.payload,
    required this.copyLabel,
    required this.slug,
    required this.editPath,
    required this.steps,
    super.key,
  });

  /// The card heading, e.g. "Update it on LinkedIn".
  final String title;

  /// The text the copy button puts on the clipboard. Empty disables it.
  final String payload;

  /// e.g. "Copy headline".
  final String copyLabel;

  /// The user's LinkedIn vanity slug. Null when no account is connected, which
  /// is the one case where no URL can be built.
  final String? slug;

  /// The path under `linkedin.com/in/{slug}/`, e.g.
  /// `edit/forms/intro/new/`.
  final String editPath;

  /// The same numbered instructions the web panel lists.
  final List<String> steps;

  String? get _url =>
      slug == null ? null : 'https://www.linkedin.com/in/$slug/$editPath';

  @override
  Widget build(BuildContext context) {
    final String? url = _url;

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),

          _CopyButton(label: copyLabel, payload: payload),

          SizedBox(height: ZaveSpace.lg),

          if (url == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Amber: waiting on something, not an error.
                Padding(
                  padding: EdgeInsets.only(top: ZaveSpace.xs + 2),
                  child: const ZaveDot(ZaveColors.amber),
                ),
                SizedBox(width: ZaveSpace.sm),
                Expanded(
                  child: Text(
                    'Connect a LinkedIn account in Settings and the direct '
                    'edit link will appear here.',
                    style: ZaveType.caption,
                  ),
                ),
              ],
            )
          else ...<Widget>[
            Text('OPEN THIS IN YOUR BROWSER', style: ZaveType.kicker),
            SizedBox(height: ZaveSpace.sm),
            Container(
              width: double.infinity,
              decoration: ZaveSurface.codeBlock,
              padding: ZaveSpace.inputPad,
              child: SelectableText(url, style: ZaveType.mono),
            ),
            SizedBox(height: ZaveSpace.md),
            _CopyButton(label: 'Copy link', payload: url),
            SizedBox(height: ZaveSpace.lg),
            for (int i = 0; i < steps.length; i++) ...<Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 24,
                    child: Text('${i + 1}', style: ZaveType.num),
                  ),
                  Expanded(child: Text(steps[i], style: ZaveType.bodyMuted)),
                ],
              ),
              if (i < steps.length - 1) SizedBox(height: ZaveSpace.sm),
            ],
          ],
        ],
      ),
    );
  }
}

/// Copy-to-clipboard with the two-second acknowledgement the web shows.
/// Stateful because that acknowledgement is the only feedback a copy gives.
class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.label, required this.payload});

  final String label;
  final String payload;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.payload));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) => ZaveButton(
    label: _copied ? 'Copied' : widget.label,
    icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded),
    onPressed: widget.payload.isEmpty ? null : _copy,
    expand: true,
  );
}
