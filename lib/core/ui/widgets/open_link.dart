import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform/link_opening.dart';
import '../zave/zave_kit.dart';

/// What every screen should do with a link, in one place.
///
/// Opens [url] in the app that owns it — the LinkedIn app for a
/// `linkedin.com` URL, exactly as the web's `target="_blank"` does. If nothing
/// can open it, the URL goes on the clipboard instead, which is what these
/// screens did before they could open anything at all.
///
/// ## Why the clipboard is still here
///
/// It is tempting to delete the copy path now that opening works, but the
/// fallback is not dead code: a device with no browser and no LinkedIn app is
/// rare, and `launchUrl` returning false is rarer still, but the user in front
/// of one is a user whose "View on LinkedIn" does nothing. Keeping the copy
/// means the worst case degrades to what the app did last week rather than to
/// silence.
///
/// ## Why it returns a message instead of showing one
///
/// The three callers report differently: the posts list and the post detail
/// page both have a `_notify` snackbar, while the mission hand-off card shows
/// an inline acknowledgement on the button itself. A helper that reached for
/// `ScaffoldMessenger` would work for two of them and be wrong for the third,
/// so it returns the sentence and lets each screen say it its own way.
///
/// Returns null on success. There is nothing to tell a user who is now looking
/// at LinkedIn, and a snackbar would land on top of the app we just left.
Future<String?> openLinkOrCopy(WidgetRef ref, String url) async {
  final LinkOpenResult result = await ref.read(linkOpeningProvider).open(url);

  return switch (result) {
    LinkOpened() => null,
    LinkOpenFailed() => await _copy(url),
  };
}

Future<String> _copy(String url) async {
  await Clipboard.setData(ClipboardData(text: url));
  return 'Could not open LinkedIn — link copied instead.';
}

/// Opens [url] and reports whether it worked — with NO clipboard fallback.
///
/// For the copy-then-open hand-offs: the engagement cards copy a comment or a
/// note, the planner copies 1,200 words of article, and only then open
/// LinkedIn. For those callers [openLinkOrCopy] is actively wrong. Its
/// fallback writes the URL to the clipboard, which on that path overwrites
/// the very thing the user is switching apps to paste — they would arrive at
/// LinkedIn's editor holding a link to LinkedIn's editor.
///
/// So these callers take the failure and say something useful instead. The
/// text they were given is still on the clipboard, which is the part that
/// cannot be reconstructed; the destination can be reached by hand.
Future<bool> openLinkKeepingClipboard(WidgetRef ref, String url) async =>
    await ref.read(linkOpeningProvider).open(url) is LinkOpened;

/// [openLinkOrCopy], reporting the fallback on this context's snackbar.
///
/// Most screens have no notifier of their own and would each hand-roll the
/// same four lines. The screens that DO have one — the posts list, the post
/// detail page, the engagement pages — keep using [openLinkOrCopy] directly
/// so their message goes through the same channel as their other messages.
Future<void> openLinkAndReport(
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
