import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'link_opening.g.dart';

/// Handing a URL to whatever app owns it.
///
/// ## What this exists for
///
/// The web renders "View on LinkedIn" as a plain `<a target="_blank">`. On a
/// phone that is not a browser tab: LinkedIn has registered `linkedin.com` as
/// an Android App Link and an iOS Universal Link, so the OS intercepts the
/// navigation and opens the post inside the LinkedIn app. The app's job is to
/// reproduce that hand-off, not to invent a different one.
///
/// Until now it could not. Three screens — the post card, the post detail
/// page, and the mission hand-off card — each carried a comment saying the app
/// had no `url_launcher` dependency and offered "Copy link" instead. The
/// dependency has been in `pubspec.yaml` all along, added with a comment naming
/// this exact use, and nothing ever called it.
///
/// ## Why [LaunchMode.externalApplication] and not the default
///
/// This is the whole mechanism, so it is worth stating plainly.
///
/// `LaunchMode.platformDefault` opens an in-app browser — a Chrome Custom Tab
/// on Android, an `SFSafariViewController` on iOS. Neither of those resolves
/// App Links or Universal Links: they are browser surfaces we host, so the URL
/// loads as a web page and the user lands on LinkedIn's mobile site, logged
/// out as often as not. That is the failure this seam is here to avoid.
///
/// `externalApplication` issues a bare `ACTION_VIEW` intent on Android
/// (`UrlLauncher.launchUrl` → `activity.startActivity`) and
/// `UIApplication.open` on iOS. Both go through the OS link resolution that
/// the browser's `target="_blank"` goes through, so an installed LinkedIn app
/// claims the link and a browser gets it only when LinkedIn is absent. Same
/// mechanism as the web, same outcome.
///
/// ## Why this needs no manifest change
///
/// url_launcher's README asks for a `<queries>` block on Android 11+, and one
/// was written for this before the plugin source was read. It earns nothing
/// here: package visibility filters `resolveActivity`, not an implicit
/// `startActivity`, and `launchUrl` never resolves — it dispatches and returns
/// false only on `ActivityNotFoundException`. The `<queries>` requirement is
/// `canLaunchUrl`'s, and nothing here calls it. Adding config for a code path
/// we do not take would just be a comment claiming a mechanism that is not
/// running.
///
/// ## Why there is no `linkedin://` probe
///
/// The obvious-looking alternative is to try a custom scheme first and fall
/// back to https. It would be worse. `linkedin://` is undocumented, its paths
/// have changed between app versions, and a wrong one opens the app on the
/// wrong screen — which reads as a broken link rather than a missing one. The
/// https URL already reaches the app through the mechanism LinkedIn actually
/// supports, and it is the only form the server ever gives us.
///
/// It also keeps iOS honest: probing a custom scheme would need
/// `LSApplicationQueriesSchemes` in `Info.plist`, declaring an app we query
/// for. Universal Links need no such declaration, so `Info.plist` is
/// untouched too.
///
/// A seam like `web_auth.dart` and `image_sharing.dart`, so a screen can be
/// tested without a platform channel.
sealed class LinkOpenResult {
  const LinkOpenResult();
}

/// Another app took the URL. Nothing more to say to the user — they are
/// looking at LinkedIn.
class LinkOpened extends LinkOpenResult {
  const LinkOpened();
}

/// Nothing could open it: no browser, no handler, a malformed URL, or the
/// platform channel refused.
///
/// There is deliberately no `Cancelled` variant, unlike `ShareResult` and
/// `WebAuthResult`. Those hand control back to us and can report a dismissal;
/// this one hands control *away*. Once the intent is dispatched we are
/// backgrounded and never learn what the user did next, so "opened" here means
/// the hand-off succeeded and nothing more.
class LinkOpenFailed extends LinkOpenResult {
  const LinkOpenFailed();
}

abstract class LinkOpeningService {
  /// Opens [url] in whatever app owns it, preferring a native app over a
  /// browser. Never throws — a URL that cannot be opened is
  /// [LinkOpenFailed], because every caller's response to a thrown
  /// `PlatformException` and to `false` is the same one.
  Future<LinkOpenResult> open(String url);
}

class PlatformLinkOpening implements LinkOpeningService {
  const PlatformLinkOpening();

  @override
  Future<LinkOpenResult> open(String url) async {
    final Uri? uri = Uri.tryParse(url);
    // A scheme-less string would be launched as a relative URI and fail
    // somewhere less legible than here.
    if (uri == null || !uri.hasScheme) return const LinkOpenFailed();

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched ? const LinkOpened() : const LinkOpenFailed();
    } on Object {
      return const LinkOpenFailed();
    }
  }
}

@Riverpod(keepAlive: true)
LinkOpeningService linkOpening(Ref ref) => const PlatformLinkOpening();
