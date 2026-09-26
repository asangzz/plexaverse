import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';

/// The hand-off to LinkedIn's own editor.
///
/// ## Copy, then open
///
/// On the web this is `LinkedInWebviewPanel`: a 520px drawer that slides in
/// with LinkedIn's edit form loaded inside it, so the user pastes without ever
/// leaving the page. A phone cannot reproduce that without an embedded browser
/// (`webview_flutter`), which the app still does not ship — an edit form inside
/// our own WebView would also ask the user to sign in to LinkedIn there, which
/// is a worse thing to ask than switching apps.
///
/// What it does instead is the same two steps in the order the user performs
/// them: **copy the text**, then **open LinkedIn on the exact edit screen**.
/// The URL goes through the OS, so the LinkedIn app claims it and the user
/// lands already signed in — closer to the web drawer's actual effect than a
/// browser tab would be.
///
/// The card previously could only print the URL and say "open this in your
/// browser", because nothing here could open a link. That text is gone; the
/// URL itself stays visible and copyable for the case where the button's
/// hand-off fails.
class LinkedInHandoffCard extends ConsumerWidget {
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

  /// Opens the edit screen, falling back to the clipboard. The message is
  /// shown here rather than returned because this is a card inside somebody
  /// else's page, and it has no notifier of its own to hand it to.
  static Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    String url,
  ) async {
    final String? message = await openLinkOrCopy(ref, url);
    if (message == null || !context.mounted) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(message, style: ZaveType.body),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            // The action, not an instruction. This opens the LinkedIn app on
            // the exact edit screen named by `editPath`, so the two steps are
            // "copy" then "open" rather than "copy, then go and find it".
            ZaveButton(
              label: 'Open LinkedIn',
              icon: const Icon(Icons.open_in_new_rounded),
              onPressed: () => _open(context, ref, url),
            ),
            SizedBox(height: ZaveSpace.lg),

            // Kept below the button, not deleted with the old "open this in
            // your browser" heading. A user on a desktop-synced device, or
            // one whose hand-off fails, still needs the literal URL — and it
            // is the one thing this card cannot regenerate for them.
            Text('OR USE THIS LINK', style: ZaveType.kicker),
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
