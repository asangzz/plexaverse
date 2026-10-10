import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/consent/notice.dart';
import '../../../core/router/auth_gate.dart';
import '../../../core/storage/session_store.dart';
import '../data/auth_repository_providers.dart';
import '../domain/auth_repository.dart';

part 'auth_controller.g.dart';

/// Which of the signed-out screen's two actions is in flight.
///
/// One enum rather than the pair of booleans the page used to carry. The pair
/// could represent "both at once", which was never meant to be reachable and
/// was kept unreachable only by a `_busy` guard at four call sites; an enum
/// says it in the type instead of in four places that each have to remember.
enum AuthBusy {
  idle,

  /// The email form's one solid CTA — sign in or create account.
  credentials,

  /// The Google button, from the browser hand-off through to the account
  /// write. Deliberately clear while the consent sheet is open: the user is
  /// reading, not waiting on us.
  google,
}

/// Sign in, create account, and Google sign-up — the signed-out screen's three
/// use cases and the session hand-off they all end in.
///
/// **Why this exists at all.** All three used to run inside `_AuthPageState`,
/// which made the login page the only widget in the slice that imported
/// `data/`: it reached past `application/` straight to `authRepositoryProvider`
/// and so pointed the dependency arrow outward, the one direction
/// ARCHITECTURE.md forbids. The in-flight flags sat on that same State object,
/// which is what made the rest fragile — every step after an `await` had to
/// prove the widget was still alive before it could run, including the steps
/// that have nothing to do with drawing.
///
/// **What the page keeps.** Field validation, the shake, the consent decision
/// and every error string. That is the form, and the form is the widget's
/// business. What moved here is the part that has to finish whether or not
/// anyone is still looking at the screen.
///
/// ## The keep-alive link is load-bearing
///
/// [_run] pins this notifier with `ref.keepAlive()` for the length of each use
/// case and releases it in a `finally`. Without that pin the provider is
/// autoDispose and the page is its only listener, so a back tap mid-request
/// tears the notifier down and every `ref` use after the await throws
/// `UnmountedRefException` — the widget's own disposal hazard, moved one layer
/// in and no better for the move. With it, [_onAuthenticated] cannot be
/// interrupted: tokens written implies gate invalidated, always.
///
/// Releasing the link rather than declaring `keepAlive: true` is what lets the
/// busy state reset. A success deliberately leaves the spinner running — the
/// router is mid-redirect and the CTA must not come back to life under the
/// user's thumb — so that state is cleared only by the provider disposing once
/// the page is gone, which is exactly when a fresh `/login` wants it clear.
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthBusy build() => AuthBusy.idle;

  /// Signs in with email and password.
  ///
  /// Returns the repository's sealed result verbatim. The copy for each
  /// failure is the page's: it is user-facing text, and that is the layer that
  /// owns user-facing text.
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) {
    return _run(AuthBusy.credentials, () async {
      final SignInResult result = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      switch (result) {
        case SignInSuccess(:final AuthTokens tokens):
          await _onAuthenticated(tokens);
        case SignInInvalidCredentials():
        case SignInNetworkFailure():
          state = AuthBusy.idle;
      }
      return result;
    });
  }

  /// Creates an account and signs straight in.
  ///
  /// [acceptedNotice] and [consents] are the user's own decisions, passed
  /// through untouched. [kNoticeVersion] is supplied here rather than by the
  /// caller because it is a wire detail, not a choice: the server refuses a
  /// sign-up taken under a superseded notice, and which notice this binary
  /// shows is not something a form should be able to get wrong.
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    required bool acceptedNotice,
    required Map<String, bool> consents,
    String? referralCode,
  }) {
    return _run(AuthBusy.credentials, () async {
      final RegisterResult result = await ref
          .read(authRepositoryProvider)
          .register(
            name: name,
            email: email,
            password: password,
            acceptedNotice: acceptedNotice,
            noticeVersion: kNoticeVersion,
            consents: consents,
            referralCode: referralCode,
          );
      switch (result) {
        case RegisterSuccess(:final AuthTokens tokens):
          await _onAuthenticated(tokens);
        case RegisterInvalid():
        case RegisterNetworkFailure():
          state = AuthBusy.idle;
      }
      return result;
    });
  }

  /// Runs the Google hand-off.
  ///
  /// [GoogleConsentRequired] clears the busy state on its way out, because
  /// what happens next is the notice sheet and it is the user who is being
  /// waited on. The caller shows it and comes back through
  /// [completeGoogleSignUp].
  Future<GoogleResult> startGoogle() {
    return _run(AuthBusy.google, () async {
      final GoogleResult result = await ref
          .read(authRepositoryProvider)
          .signInWithGoogle();
      switch (result) {
        case GoogleSignedIn(:final AuthTokens tokens):
          await _onAuthenticated(tokens);
        case GoogleConsentRequired():
        case GoogleCancelled():
        case GoogleAccountExistsWithPassword():
        case GoogleFailure():
          state = AuthBusy.idle;
      }
      return result;
    });
  }

  /// Finishes a Google sign-up once the notice has been accepted.
  ///
  /// Takes the decision as two plain values rather than the sheet's
  /// `ConsentDecision`: that type lives in `presentation/`, and an
  /// application-layer controller importing a widget file would reverse the
  /// very dependency this controller exists to straighten out.
  Future<GoogleResult> completeGoogleSignUp({
    required GoogleConsentRequired step,
    required bool acceptedNotice,
    required Map<String, bool> consents,
  }) {
    return _run(AuthBusy.google, () async {
      final GoogleResult result = await ref
          .read(authRepositoryProvider)
          .completeGoogleSignUp(
            signupTicket: step.signupTicket,
            noticeVersion: step.noticeVersion,
            acceptedNotice: acceptedNotice,
            consents: consents,
          );
      switch (result) {
        case GoogleSignedIn(:final AuthTokens tokens):
          await _onAuthenticated(tokens);
        case GoogleResult():
          state = AuthBusy.idle;
      }
      return result;
    });
  }

  /// Shows [what] as in flight and holds this notifier open for [action].
  Future<T> _run<T>(AuthBusy what, Future<T> Function() action) async {
    final link = ref.keepAlive();
    state = what;
    try {
      return await action();
    } finally {
      link.close();
    }
  }

  /// Shared success tail: persist the session, then drive the auth gate so the
  /// router's redirect fires. [SessionStore] is the single session source of
  /// truth — no navigation call here; the router owns the redirect.
  ///
  /// **Nothing in here is allowed to depend on a widget surviving.** The token
  /// write is the point of no return: once it lands the user IS signed in on
  /// disk, and the only thing that tells the router so is the gate
  /// invalidation below. On the page this had to be defended by hand — the
  /// invalidation once sat behind `if (!mounted) return;`, so a back tap
  /// mid-write left tokens in the keychain and the gate stale (signed in,
  /// still staring at the login form, recoverable only by relaunching), and
  /// the repair was to cache `ref.container` before the first await because a
  /// `WidgetRef` throws the instant its element is gone.
  ///
  /// Here the guarantee comes from where the code lives plus [_run]'s
  /// keep-alive link, so there is no captured container and no `mounted` check
  /// to forget: this notifier outlives the page by construction.
  Future<void> _onAuthenticated(AuthTokens tokens) async {
    await ref
        .read(sessionStoreProvider)
        .writeTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );

    ref.invalidate(authGateProvider);
    try {
      await ref.read(authGateProvider.future);
    } on Object {
      // A gate error is treated as signed-out by the router; the redirect
      // still resolves to a sensible destination.
    }
  }
}
