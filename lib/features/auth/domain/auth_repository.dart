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

/// One optional consent purpose the server asked us to present.
class ConsentPurposeOption {
  const ConsentPurposeOption({
    required this.purpose,
    required this.label,
    required this.required_,
  });

  /// The server's key, e.g. `style_learning`. Echoed back verbatim.
  final String purpose;
  final String label;
  final bool required_;
}

/// The Google profile the server resolved, shown on the consent step so the
/// user can see which account they are about to create.
class GoogleProfile {
  const GoogleProfile({required this.email, this.name, this.image});
  final String email;
  final String? name;
  final String? image;
}

/// Outcome of the Google hand-off.
///
/// Note that "needs to sign up" is a SUCCESS variant, not a failure: the
/// server answers it as a 200 with a discriminator, because the Dio error
/// interceptor flattens every non-2xx into a message-only `Failure` and the
/// signup ticket would be unreachable.
sealed class GoogleResult {
  const GoogleResult();
}

class GoogleSignedIn extends GoogleResult {
  const GoogleSignedIn({required this.tokens, required this.user});
  final AuthTokens tokens;
  final AuthUser user;
}

/// A brand-new data principal. NOTHING has been written about them yet — the
/// notice has to be shown before anything is (DPDP s5/s6). Completing the
/// sign-up means calling [AuthRepository.completeGoogleSignUp] with the
/// ticket and the user's decisions.
class GoogleConsentRequired extends GoogleResult {
  const GoogleConsentRequired({
    required this.signupTicket,
    required this.noticeVersion,
    required this.profile,
    required this.purposes,
  });

  final String signupTicket;

  /// Echoed back on completion so the server can refuse a store binary that
  /// is showing a superseded notice.
  final String noticeVersion;
  final GoogleProfile profile;
  final List<ConsentPurposeOption> purposes;
}

/// The user dismissed the browser sheet — distinct from a failure so the UI
/// returns to the form silently, with no error banner. Backing out is a
/// decision, not an error.
class GoogleCancelled extends GoogleResult {
  const GoogleCancelled();
}

/// This email already belongs to a PASSWORD account.
///
/// Deliberately not auto-linked: both register routes mark an address
/// verified without ever mailing it, so anyone can pre-register someone
/// else's email, and linking would hand their Google sign-in into a row whose
/// password the attacker still knows.
class GoogleAccountExistsWithPassword extends GoogleResult {
  const GoogleAccountExistsWithPassword({required this.message});
  final String message;
}

class GoogleFailure extends GoogleResult {
  const GoogleFailure({this.message});
  final String? message;
}

/// Whether this account can sign in with Google, and whether that can be
/// undone.
///
/// [canUnlink] is a server-side fact the app cannot derive: unlinking is
/// refused when Google is the only way in, and only the server knows whether
/// a password exists. Sending it means Settings can disable the control rather
/// than offer it and then refuse.
class GoogleLinkStatus {
  const GoogleLinkStatus({
    required this.linked,
    required this.canUnlink,
    required this.hasPassword,
  });

  final bool linked;
  final bool canUnlink;
  final bool hasPassword;
}

/// Outcome of linking or unlinking Google from a SIGNED-IN account.
///
/// Separate from [GoogleResult] because nothing here produces a session: the
/// user is already authenticated, and the browser trip proves who they are to
/// Google, not to us.
sealed class GoogleLinkResult {
  const GoogleLinkResult();
}

/// Linked. [alreadyLinked] is true when this exact Google account was already
/// on the row — a double-tap, which is success, not an error.
class GoogleLinkSucceeded extends GoogleLinkResult {
  const GoogleLinkSucceeded({this.alreadyLinked = false});
  final bool alreadyLinked;
}

/// Backed out of the browser sheet. Silence, not an error banner.
class GoogleLinkCancelled extends GoogleLinkResult {
  const GoogleLinkCancelled();
}

/// Refused or failed. [message] is the server's own copy where it sent some —
/// these refusals ("that Google account is already linked to a different
/// Plexaverse account", "Google is the only way to sign in") are written to be
/// shown, and a generic message would lose the only thing that tells the user
/// what to do next.
class GoogleLinkFailed extends GoogleLinkResult {
  const GoogleLinkFailed({this.message});
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

  /// Creates an account.
  ///
  /// [acceptedNotice] and [noticeVersion] are REQUIRED, not optional: the
  /// server refuses a sign-up without an affirmative acceptance, because
  /// consent under DPDP s6 cannot be inferred from silence. [consents] carries
  /// the optional purposes, keyed by the server's purpose strings; an absent
  /// key is a refusal.
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    required bool acceptedNotice,
    required String noticeVersion,
    Map<String, bool> consents = const <String, bool>{},
    String? referralCode,
  });

  /// Runs the whole Google hand-off: fetch an authorize URL bound to a PKCE
  /// challenge → open the system browser → exchange the returned code.
  ///
  /// The PKCE verifier stays in a local variable for the duration and is
  /// never persisted.
  Future<GoogleResult> signInWithGoogle();

  /// Finishes a Google SIGN-UP after the user has accepted the notice.
  ///
  /// Only valid against a [GoogleConsentRequired.signupTicket], and only once:
  /// the server route only ever creates, so a replay is refused.
  Future<GoogleResult> completeGoogleSignUp({
    required String signupTicket,
    required String noticeVersion,
    required bool acceptedNotice,
    Map<String, bool> consents = const <String, bool>{},
    String? referralCode,
  });

  /// Current Google-link state for the signed-in user, or null when it could
  /// not be read (offline, server error). Null is "unknown", NOT "not linked"
  /// — rendering an unlinked row on a failed read would invite the user to
  /// link an account that is already linked.
  Future<GoogleLinkStatus?> googleLinkStatus();

  /// Runs the same browser hand-off as [signInWithGoogle] and attaches the
  /// resulting identity to the account that is already signed in.
  ///
  /// This is the way out of [GoogleAccountExistsWithPassword]: sign-in refuses
  /// to link a Google identity onto a password account on its own, because it
  /// cannot tell the owner from someone who pre-registered the address. Once
  /// the password has been entered, it can.
  Future<GoogleLinkResult> linkGoogle();

  /// Removes Google as a sign-in method. Refused by the server when it is the
  /// only one left.
  Future<GoogleLinkResult> unlinkGoogle();

  /// Best-effort server-side session teardown. Local token clearing is owned
  /// by `SignOutController` via `SessionStore.clear()`; this only tells the
  /// backend to invalidate the refresh token. Never throws.
  Future<void> signOut();
}
