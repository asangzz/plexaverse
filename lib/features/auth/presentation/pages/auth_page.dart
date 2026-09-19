import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/router/auth_gate.dart';
import '../../../../core/storage/session_store.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../data/auth_repository_providers.dart';
import '../../domain/auth_repository.dart';
import '../widgets/auth_divider.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/referral_code_field.dart';
import '../widgets/social_auth_button.dart';
import '../../../../core/consent/notice.dart';
import '../widgets/consent_block.dart';
import '../widgets/consent_sheet.dart';

enum _AuthMode { signIn, createAccount }

/// `/login` — sign in and create account on one screen.
///
/// The web counterpart is `app/login/page.tsx`: one page with an `isLogin`
/// flag, a heading that swaps between **Sign in** and **Create an account**, a
/// Google button above a hairline rule, the email form, one filled CTA, and a
/// footer line that flips the mode. Every string on this screen is that page's
/// string. The web's desktop split-screen (a photo panel on `lg:`) has no
/// mobile branch at all — the phone renders the right-hand column alone, which
/// is what this is.
///
/// ## What changed, and what deliberately did not
///
/// **Skin only.** The previous version of this file was the pre-alignment
/// skin — `#6C63FF` violet pills on `#121212`, a Material [SegmentedButton]
/// mode toggle, a light/dark fork with a hand-painted grid-paper backdrop, and
/// its own hex literals throughout. All of that is gone and every value now
/// comes from a Zave token. The state, the validators, the sealed-result
/// switches and the `SessionStore` → `authGateProvider` success tail are
/// untouched: the auth data and application layers are correct and this pass
/// was presentation only.
///
/// Three Zave rules drive the layout:
///
///  * **One solid-white button per screen.** That is the email CTA. The social
///    buttons are therefore `ghost`, which also matches the web's hierarchy.
///  * **Selected inverts to solid white.** The mode toggle is a [ZaveChip]
///    pair, not a `SegmentedButton` — a segmented control would bring Material's
///    own selection language (a tinted fill and a check glyph) onto a surface
///    whose whole selection grammar is the inversion.
///  * **Dark only.** Zave has one appearance, so the `isDark` fork every child
///    widget used to carry is removed rather than defaulted.
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  _AuthMode _mode = _AuthMode.signIn;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _referralCtrl = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _formError;

  // Submission flags. `_submitting` drives the primary CTA spinner; the two
  // social flags drive theirs. Guarded so only one runs at a time.
  bool _submitting = false;
  bool _googleLoading = false;

  /// What the user has ticked on the create-account notice. Reset when the
  /// mode toggles, so switching to sign-in and back cannot leave a stale
  /// acceptance behind.
  ConsentDecision _consent = const ConsentDecision(
    acceptedNotice: false,
    consents: <String, bool>{},
  );

  late final AnimationController _shakeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  /// The rejected-form shake.
  ///
  /// Zave's motion rule is "short and physical. Nothing bounces", which bans
  /// springs with overshoot — not this. A shake is a single eased ±4px pass
  /// that ends exactly where it started; there is no release overshoot and no
  /// elastic curve, and it is the one thing on the screen that tells a user
  /// who tapped a disabled-looking button that the tap WAS received. It uses
  /// [ZaveMotion.curve] like everything else.
  late final Animation<double> _shakeAnim =
      TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: -4),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -4, end: 4),
          weight: 2,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 4, end: -4),
          weight: 2,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -4, end: 0),
          weight: 1,
        ),
      ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: ZaveMotion.curve));

  /// Owned here rather than built inline so they are disposed. A recognizer
  /// created in `build` leaks one per rebuild.
  late final TapGestureRecognizer _switchModeTap = TapGestureRecognizer()
    ..onTap = _toggleMode;
  late final TapGestureRecognizer _termsTap = TapGestureRecognizer();
  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _referralCtrl.dispose();
    _shakeCtrl.dispose();
    _switchModeTap.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  bool get _isSignIn => _mode == _AuthMode.signIn;

  bool get _busy => _submitting || _googleLoading;

  void _clearErrors() {
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _formError = null;
  }

  void _triggerShake() => _shakeCtrl.forward(from: 0);

  Future<void> _submitSignIn() async {
    setState(_clearErrors);
    bool valid = true;
    if (_emailCtrl.text.trim().isEmpty) {
      _emailError = 'Email address is required';
      valid = false;
    } else if (!_emailCtrl.text.isValidEmail) {
      _emailError = 'Please enter a valid email address';
      valid = false;
    }
    if (_passwordCtrl.text.isEmpty) {
      _passwordError = 'Password is required';
      valid = false;
    }
    if (!valid) {
      setState(_triggerShake);
      return;
    }

    setState(() => _submitting = true);
    final SignInResult result = await ref
        .read(authRepositoryProvider)
        .signIn(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
    if (!mounted) return;

    switch (result) {
      case SignInSuccess(:final AuthTokens tokens):
        await _onAuthenticated(tokens);
      case SignInInvalidCredentials():
        setState(() {
          _submitting = false;
          _formError = 'Incorrect email or password';
          _triggerShake();
        });
      case SignInNetworkFailure():
        setState(() {
          _submitting = false;
          _formError = 'Something went wrong. Please try again.';
        });
    }
  }

  Future<void> _submitRegister() async {
    setState(_clearErrors);
    bool valid = true;
    if (_nameCtrl.text.trim().isEmpty) {
      _nameError = 'Please enter your full name';
      valid = false;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _emailError = 'Email address is required';
      valid = false;
    } else if (!_emailCtrl.text.isValidEmail) {
      _emailError = 'Please enter a valid email address';
      valid = false;
    }
    if (!_passwordCtrl.text.isValidPassword) {
      _passwordError = 'Password must be at least 8 characters';
      valid = false;
    }
    if (!valid) {
      setState(_triggerShake);
      return;
    }

    setState(() => _submitting = true);
    final String referral = _referralCtrl.text.trim();
    final RegisterResult result = await ref
        .read(authRepositoryProvider)
        .register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          acceptedNotice: _consent.acceptedNotice,
          noticeVersion: kNoticeVersion,
          consents: _consent.consents,
          referralCode: referral.isEmpty ? null : referral,
        );
    if (!mounted) return;

    switch (result) {
      case RegisterSuccess(:final AuthTokens tokens):
        await _onAuthenticated(tokens);
      case RegisterInvalid(
        :final String? message,
        :final Map<String, String> fieldErrors,
      ):
        setState(() {
          _submitting = false;
          _nameError = fieldErrors['name'];
          _emailError = fieldErrors['email'];
          _passwordError = fieldErrors['password'];
          _formError = message ?? 'Please check your details and try again.';
          _triggerShake();
        });
      case RegisterNetworkFailure():
        setState(() {
          _submitting = false;
          _formError = 'Something went wrong. Please try again.';
        });
    }
  }

  Future<void> _startGoogle() async {
    setState(() {
      _formError = null;
      _googleLoading = true;
    });

    final GoogleResult result = await ref
        .read(authRepositoryProvider)
        .signInWithGoogle();
    if (!mounted) return;

    switch (result) {
      case GoogleSignedIn(:final AuthTokens tokens):
        await _onAuthenticated(tokens);

      case GoogleConsentRequired():
        // A brand-new data principal. Nothing has been stored about them yet,
        // and nothing will be until they accept the notice.
        setState(() => _googleLoading = false);
        await _completeGoogleSignUp(result);

      case GoogleCancelled():
        // Backing out is a decision, not an error — no banner.
        setState(() => _googleLoading = false);

      case GoogleAccountExistsWithPassword(:final String message):
        setState(() {
          _googleLoading = false;
          _formError = message;
        });

      case GoogleFailure(:final String? message):
        setState(() {
          _googleLoading = false;
          _formError = message ?? 'Google sign-in failed. Please try again.';
        });
    }
  }

  /// Shows the notice, then creates the account.
  Future<void> _completeGoogleSignUp(GoogleConsentRequired step) async {
    final ConsentDecision? decision = await ConsentSheet.show(
      context,
      profile: step.profile,
      purposes: step.purposes,
    );
    if (!mounted || decision == null) return; // dismissed — nothing written

    setState(() => _googleLoading = true);
    final GoogleResult result = await ref
        .read(authRepositoryProvider)
        .completeGoogleSignUp(
          signupTicket: step.signupTicket,
          noticeVersion: step.noticeVersion,
          acceptedNotice: decision.acceptedNotice,
          consents: decision.consents,
        );
    if (!mounted) return;

    switch (result) {
      case GoogleSignedIn(:final AuthTokens tokens):
        await _onAuthenticated(tokens);
      case GoogleFailure(:final String? message):
        setState(() {
          _googleLoading = false;
          _formError = message ?? 'Could not create your account.';
        });
      case GoogleResult():
        setState(() => _googleLoading = false);
    }
  }

  /// Shared success tail: persist the session, then drive the auth gate so the
  /// router's redirect fires. `SessionStore` is the single session source of
  /// truth — no navigation call here; the router owns the redirect.
  Future<void> _onAuthenticated(AuthTokens tokens) async {
    await ref
        .read(sessionStoreProvider)
        .writeTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
    if (!mounted) return;
    ref.invalidate(authGateProvider);
    try {
      await ref.read(authGateProvider.future);
    } on Object {
      // A gate error is treated as signed-out by the router; the redirect
      // still resolves to a sensible destination.
    }
  }

  void _setMode(_AuthMode next) {
    if (_mode == next) return;
    setState(() {
      _clearErrors();
      _mode = next;
    });
  }

  void _toggleMode() =>
      _setMode(_isSignIn ? _AuthMode.createAccount : _AuthMode.signIn);

  @override
  Widget build(BuildContext context) {
    final bool isSignIn = _isSignIn;

    return ZaveScaffold(
      // No title: the screen carries its own `.h2` heading inside the scroll
      // view, and ZaveScaffold's doc is explicit that a screen never has both.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ZaveScrollView(
          children: <Widget>[
            const _PlexaLockup(),
            SizedBox(height: ZaveSpace.xl),

            Text(
              isSignIn ? 'Sign in' : 'Create an account',
              style: ZaveType.h2,
            ),
            SizedBox(height: ZaveSpace.md),
            Text(
              isSignIn
                  ? 'Continue to your LinkedIn automation dashboard'
                  : 'Start automating your LinkedIn presence with AI',
              style: ZaveType.lead,
            ),
            SizedBox(height: ZaveSpace.xl),

            _ModeToggle(mode: _mode, onChanged: _setMode),
            SizedBox(height: ZaveSpace.xl),

            // Form-level error. Sized-in rather than faded so the buttons below
            // move once, not twice.
            AnimatedSwitcher(
              duration: ZaveMotion.fast,
              switchInCurve: ZaveMotion.curve,
              switchOutCurve: ZaveMotion.curve,
              transitionBuilder: (Widget child, Animation<double> anim) =>
                  SizeTransition(
                    sizeFactor: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
              child: _formError == null
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      key: ValueKey<String>(_formError!),
                      padding: EdgeInsets.only(bottom: ZaveSpace.lg),
                      child: Semantics(
                        liveRegion: true,
                        child: FormErrorBanner(message: _formError!),
                      ),
                    ),
            ),

            // Google only. The web offers exactly two providers — Google and
            // credentials — and LinkedIn is never a sign-in there, only an
            // account you CONNECT once signed in. The LinkedIn button that
            // used to sit here had no web counterpart and no working backend
            // path: /linkedin/auth-url requires a bearer token, so a
            // signed-out tap could only ever 401.
            SocialAuthButton(
              provider: SocialButtonProvider.google,
              isSignIn: isSignIn,
              isLoading: _googleLoading,
              onPressed: _busy ? null : _startGoogle,
            ),

            SizedBox(height: ZaveSpace.xl),
            const AuthDivider(),
            SizedBox(height: ZaveSpace.xl),

            // Mode switch — a short horizontal slide in the direction of
            // travel. No spring: Zave does not overshoot.
            AnimatedSwitcher(
              duration: ZaveMotion.page,
              switchInCurve: ZaveMotion.curve,
              switchOutCurve: ZaveMotion.curve,
              transitionBuilder: (Widget child, Animation<double> anim) {
                final bool entering =
                    child.key ==
                    ValueKey<_AuthMode>(
                      isSignIn ? _AuthMode.signIn : _AuthMode.createAccount,
                    );
                final double dx = entering
                    ? (isSignIn ? 0.12 : -0.12)
                    : (isSignIn ? -0.12 : 0.12);
                return ClipRect(
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(dx, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                );
              },
              layoutBuilder:
                  (Widget? currentChild, List<Widget> previousChildren) =>
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[...previousChildren, ?currentChild],
                      ),
              child: isSignIn
                  ? _SignInFields(
                      key: const ValueKey<_AuthMode>(_AuthMode.signIn),
                      emailCtrl: _emailCtrl,
                      passwordCtrl: _passwordCtrl,
                      emailError: _emailError,
                      passwordError: _passwordError,
                      shake: _shakeAnim,
                      onEmailChanged: (_) => setState(() => _emailError = null),
                      onPasswordChanged: (_) =>
                          setState(() => _passwordError = null),
                    )
                  : _RegisterFields(
                      key: const ValueKey<_AuthMode>(_AuthMode.createAccount),
                      nameCtrl: _nameCtrl,
                      emailCtrl: _emailCtrl,
                      passwordCtrl: _passwordCtrl,
                      referralCtrl: _referralCtrl,
                      nameError: _nameError,
                      emailError: _emailError,
                      passwordError: _passwordError,
                      shake: _shakeAnim,
                      onNameChanged: (_) => setState(() => _nameError = null),
                      onEmailChanged: (_) => setState(() => _emailError = null),
                      onPasswordChanged: (_) =>
                          setState(() => _passwordError = null),
                    ),
            ),

            SizedBox(height: ZaveSpace.xl),

            // The notice goes ABOVE the button, not below it as fine print.
            // DPDP s5 wants it before collection, and a line under the CTA is
            // read after the decision, if at all.
            if (!isSignIn) ...<Widget>[
              ConsentBlock(
                decision: _consent,
                onChanged: (ConsentDecision d) => setState(() => _consent = d),
              ),
              SizedBox(height: ZaveSpace.xl),
            ],

            // The one solid-white button on this screen.
            ZaveButton.primary(
              label: isSignIn ? 'Continue' : 'Create account',
              expand: true,
              busy: _submitting,
              // Create-account stays disabled until the notice is accepted —
              // matching the web's submit gate, and the server's.
              onPressed: _busy || (!isSignIn && !_consent.isComplete)
                  ? null
                  : (isSignIn ? _submitSignIn : _submitRegister),
            ),

            if (!isSignIn) ...<Widget>[
              SizedBox(height: ZaveSpace.lg),
              _TermsLine(termsTap: _termsTap, privacyTap: _privacyTap),
            ],
          ],
        ),
      ),
      // Thumb-reachable, and outside the scroll view so it never scrolls away.
      bottomBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ZaveSpace.gutter,
            vertical: ZaveSpace.lg,
          ),
          child: Text.rich(
            TextSpan(
              text: isSignIn
                  ? "Don't have an account? "
                  : 'Already have an account? ',
              style: ZaveType.bodyMuted,
              children: <InlineSpan>[
                TextSpan(
                  text: isSignIn ? 'Create one' : 'Sign in',
                  // `--zv-peri` is Zave's link colour. This is the one place a
                  // tinted word is correct: it is a link, not a control.
                  style: ZaveType.body.copyWith(color: ZaveColors.peri),
                  recognizer: _switchModeTap,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// The lockup
// ════════════════════════════════════════════════════════════════════════════

/// The Plexaverse mark and wordmark.
///
/// The pre-alignment lockup was a violet→purple gradient tile under a coloured
/// drop shadow. Zave has neither decorative gradients nor shadows — depth is a
/// fill step — so the mark is the [ZaveGlass.now] step (the "this is the one"
/// surface) with the letter in white.
class _PlexaLockup extends StatelessWidget {
  const _PlexaLockup();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: ZaveSpace.iconBtn,
          width: ZaveSpace.iconBtn,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ZaveGlass.now,
            border: Border.all(color: ZaveGlass.nowBorder, width: 1),
            shape: BoxShape.circle,
          ),
          child: Text('P', style: ZaveType.h3),
        ),
        SizedBox(width: ZaveSpace.md),
        Text('Plexaverse', style: ZaveType.h3),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Mode toggle — a chip pair, never a SegmentedButton
// ════════════════════════════════════════════════════════════════════════════

/// Sign in / Create account.
///
/// Two [ZaveChip]s. The selected one inverts to solid white with ink letters,
/// which is the entire selection language of this system — a tinted pill or an
/// underline would read as a different product.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ZaveChip(
          label: 'Sign in',
          selected: mode == _AuthMode.signIn,
          onTap: () => onChanged(_AuthMode.signIn),
        ),
        SizedBox(width: ZaveSpace.sm),
        ZaveChip(
          label: 'Create account',
          selected: mode == _AuthMode.createAccount,
          onTap: () => onChanged(_AuthMode.createAccount),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Field sets
// ════════════════════════════════════════════════════════════════════════════

class _SignInFields extends StatelessWidget {
  const _SignInFields({
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.shake,
    this.emailError,
    this.passwordError,
    this.onEmailChanged,
    this.onPasswordChanged,
    super.key,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final String? emailError;
  final String? passwordError;
  final Animation<double> shake;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return _Shake(
      shake: shake,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ZaveField(
            controller: emailCtrl,
            label: 'Email address',
            hint: 'you@example.com',
            error: emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            prefix: const Icon(Icons.mail_outline),
            onChanged: onEmailChanged,
          ),
          SizedBox(height: ZaveSpace.lg),
          _PasswordField(
            controller: passwordCtrl,
            autofillHint: AutofillHints.password,
            error: passwordError,
            onChanged: onPasswordChanged,
          ),
        ],
      ),
    );
  }
}

class _RegisterFields extends StatefulWidget {
  const _RegisterFields({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.referralCtrl,
    required this.shake,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.onNameChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
    super.key,
  });

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController referralCtrl;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final Animation<double> shake;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  @override
  State<_RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<_RegisterFields> {
  // Mirrors the password controller so the strength bar rebuilds live.
  late String _passwordText = widget.passwordCtrl.text;

  @override
  void initState() {
    super.initState();
    widget.passwordCtrl.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.passwordCtrl.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    if (_passwordText != widget.passwordCtrl.text) {
      setState(() => _passwordText = widget.passwordCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Shake(
      shake: widget.shake,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ZaveField(
            controller: widget.nameCtrl,
            label: 'Full name',
            hint: 'John Doe',
            error: widget.nameError,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.name],
            prefix: const Icon(Icons.person_outline),
            onChanged: widget.onNameChanged,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: widget.emailCtrl,
            label: 'Email address',
            hint: 'you@example.com',
            error: widget.emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            prefix: const Icon(Icons.mail_outline),
            onChanged: widget.onEmailChanged,
          ),
          SizedBox(height: ZaveSpace.lg),
          _PasswordField(
            controller: widget.passwordCtrl,
            autofillHint: AutofillHints.newPassword,
            error: widget.passwordError,
            onChanged: (String v) {
              widget.onPasswordChanged?.call(v);
              setState(() => _passwordText = v);
            },
          ),
          PasswordStrengthBar(password: _passwordText),
          SizedBox(height: ZaveSpace.lg),
          ReferralCodeField(controller: widget.referralCtrl),
        ],
      ),
    );
  }
}

/// A [ZaveField] with an eye toggle. Split out because the obscure flag is
/// local state and both field sets need it.
class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.controller,
    required this.autofillHint,
    this.error,
    this.onChanged,
  });

  final TextEditingController controller;
  final String autofillHint;
  final String? error;
  final ValueChanged<String>? onChanged;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return ZaveField(
      controller: widget.controller,
      label: 'Password',
      // The web renders a dot placeholder rather than prose.
      hint: '••••••••',
      error: widget.error,
      obscure: _obscure,
      textInputAction: TextInputAction.done,
      autofillHints: <String>[widget.autofillHint],
      prefix: const Icon(Icons.lock_outline),
      suffix: Semantics(
        button: true,
        label: _obscure ? 'Show password' : 'Hide password',
        child: GestureDetector(
          onTap: () => setState(() => _obscure = !_obscure),
          behavior: HitTestBehavior.opaque,
          child: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

/// Wraps a field set in the rejected-form shake. See [_AuthPageState._shakeAnim]
/// for why this is inside Zave's motion rule rather than outside it.
class _Shake extends StatelessWidget {
  const _Shake({required this.shake, required this.child});

  final Animation<double> shake;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shake,
      builder: (BuildContext context, Widget? built) =>
          Transform.translate(offset: Offset(shake.value, 0), child: built),
      child: child,
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Terms — create-account only
// ════════════════════════════════════════════════════════════════════════════

/// The terms / privacy line.
///
/// The web's create-account form carries a DPDP s6 consent CHECKBOX that is
/// unticked by default and required to submit — a passive "by signing up you
/// agree" line is explicitly not the clear affirmative act the Act asks for
/// (see `app/login/page.tsx`). This screen still shows the passive line
/// because the mobile register endpoint takes no `acceptedNotice` field, so a
/// checkbox here would collect a consent nothing records. That gap is reported
/// rather than papered over.
class _TermsLine extends StatelessWidget {
  const _TermsLine({required this.termsTap, required this.privacyTap});

  final TapGestureRecognizer termsTap;
  final TapGestureRecognizer privacyTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle link = ZaveType.caption.copyWith(color: ZaveColors.peri);

    return Text.rich(
      TextSpan(
        text: 'By creating an account, you agree to our ',
        style: ZaveType.caption,
        children: <InlineSpan>[
          TextSpan(text: 'Terms of Service', style: link, recognizer: termsTap),
          TextSpan(text: ' and ', style: ZaveType.caption),
          TextSpan(text: 'Privacy Policy', style: link, recognizer: privacyTap),
          TextSpan(text: '.', style: ZaveType.caption),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
