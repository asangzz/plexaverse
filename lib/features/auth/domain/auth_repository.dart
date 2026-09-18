import 'auth_tokens.dart';
import 'auth_user.dart';

export 'auth_tokens.dart';
export 'auth_user.dart';
export 'email_mask.dart';

/// Result of a sign-in attempt (WF-02, AUTH-01). Consumers switch
/// exhaustively, so adding a case is a compile error at every call site.
sealed class SignInResult {
  const SignInResult();
}

class SignInSuccess extends SignInResult {
  const SignInSuccess({required this.tokens, required this.user});
  final AuthTokens tokens;
  final AuthUser user;
}

/// The email/password pair was rejected (bad credentials or a validation
/// error the backend returned). The UI surfaces "Incorrect email or password"
/// and shakes the form.
class SignInInvalidCredentials extends SignInResult {
  const SignInInvalidCredentials({this.message});

  /// Optional backend-supplied copy; the UI falls back to a localised default.
  final String? message;
}

/// Transport / server / anything-else failure — retryable. The UI shows the
/// offline or generic network message depending on connectivity.
class SignInNetworkFailure extends SignInResult {
  const SignInNetworkFailure({this.message});
  final String? message;
}

/// Result of a create-account attempt (AUTH-03). Shares the sign-in success
/// shape — registration signs the user straight in.
sealed class RegisterResult {
  const RegisterResult();
}

class RegisterSuccess extends RegisterResult {
  const RegisterSuccess({required this.tokens, required this.user});
  final AuthTokens tokens;
  final AuthUser user;
}

/// The backend rejected the registration payload (email already taken, weak
/// password, invalid referral code…). Carries the human-readable reason and
/// any per-field errors so the form can highlight the offending input.
class RegisterInvalid extends RegisterResult {
  const RegisterInvalid({this.message, this.fieldErrors = const <String, String>{}});
  final String? message;
  final Map<String, String> fieldErrors;
}

class RegisterNetworkFailure extends RegisterResult {
  const RegisterNetworkFailure({this.message});
  final String? message;
}

/// Result of the LinkedIn OAuth hand-off (product-identity item). The real
/// flow fetches an authorize URL, launches the browser via the core web-auth
/// seam, then exchanges the returned `code`; the mock simulates a success.
sealed class LinkedInResult {
  const LinkedInResult();
}

class LinkedInSuccess extends LinkedInResult {
  const LinkedInSuccess({required this.tokens, required this.user});
  final AuthTokens tokens;
  final AuthUser user;
}

/// The user dismissed the browser hand-off — distinct from a failure so the
/// UI returns to the form silently, without an error banner.
class LinkedInCancelled extends LinkedInResult {
  const LinkedInCancelled();
}

class LinkedInFailure extends LinkedInResult {
  const LinkedInFailure({this.message});
  final String? message;
}

/// Seam between the UI and the auth backend. The UI depends only on this
/// interface; `authRepositoryProvider` (see `data/`) resolves the mock or the
/// real Dio-backed implementation from `useFakeBackend`, so going live is
/// config — no UI change. Implementations NEVER throw: every wire-level error
/// is translated into one of the sealed result variants above.
abstract class AuthRepository {
  Future<SignInResult> signIn({
    required String email,
    required String password,
  });

  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  });

  /// Runs the whole LinkedIn hand-off: fetch authorize URL → launch browser →
  /// exchange the returned authorization code → resolve the session.
  Future<LinkedInResult> signInWithLinkedIn();

  /// Best-effort server-side session teardown. Local token clearing is owned
  /// by `SignOutController` via `SessionStore.clear()`; this only tells the
  /// backend to invalidate the refresh token. Never throws.
  Future<void> signOut();
}
