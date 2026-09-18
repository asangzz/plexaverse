import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_auth.g.dart';

/// Outcome of a browser-based OAuth hand-off, mapped off `flutter_web_auth_2`
/// so feature code (the auth repository) never imports the plugin or its
/// `PlatformException`s directly (RULINGS "LinkedIn OAuth wrapped as a
/// core/platform web-auth adapter seam"; ProHealth §2.4 DIP).
///
/// The three shapes mirror what the AuthRepository needs to switch on:
///   - [WebAuthSuccess] — the provider redirected back to the app; [callbackUrl]
///     is the full redirect URI (contains `?code=…&state=…`), which the
///     repository parses and POSTs to `/auth/linkedin/exchange`.
///   - [WebAuthCancelled] — the user dismissed the browser (distinct so the
///     UI can return to the login form without an error banner).
///   - [WebAuthFailure] — anything else (no browser, plugin missing, timeout).
sealed class WebAuthResult {
  const WebAuthResult();
}

class WebAuthSuccess extends WebAuthResult {
  const WebAuthSuccess(this.callbackUrl);

  /// The full redirect URI the provider sent back (e.g.
  /// `plexaverse://oauth/linkedin?code=…&state=…`).
  final String callbackUrl;
}

class WebAuthCancelled extends WebAuthResult {
  const WebAuthCancelled();
}

class WebAuthFailure extends WebAuthResult {
  const WebAuthFailure(this.error);

  final Object error;
}

/// Adapter around `flutter_web_auth_2`. Opens [url] in a system browser
/// (ASWebAuthenticationSession / Chrome Custom Tab) and resolves when the
/// provider redirects back to [callbackUrlScheme].
///
/// LinkedIn OAuth (RULINGS product-identity item): the backend owns the flow
/// — the app fetches an authorize URL from the API, launches it here, and
/// hands the returned callback URL back to the repository for the code
/// exchange. Kept behind a `@Riverpod(keepAlive: true)` provider so
/// `ApiAuthRepository` can be tested with an overridden fake.
class WebAuthService {
  const WebAuthService();

  /// [url] is the provider authorize URL. [callbackUrlScheme] is the custom
  /// scheme registered natively (Android intent-filter + iOS
  /// CFBundleURLSchemes) that the redirect URI uses, e.g. `plexaverse`.
  Future<WebAuthResult> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) async {
    try {
      final callbackUrl = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
      return WebAuthSuccess(callbackUrl);
    } on PlatformException catch (e) {
      // The plugin signals a user-dismissed browser with code 'CANCELED'.
      if (e.code == 'CANCELED') return const WebAuthCancelled();
      return WebAuthFailure(e);
    } on Object catch (e) {
      return WebAuthFailure(e);
    }
  }
}

@Riverpod(keepAlive: true)
WebAuthService webAuthService(Ref ref) => const WebAuthService();
