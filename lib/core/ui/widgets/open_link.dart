import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform/link_opening.dart';

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
