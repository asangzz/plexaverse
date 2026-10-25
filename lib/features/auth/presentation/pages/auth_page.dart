import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/links/plexaverse.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/widgets/open_link.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/auth_controller.dart';
import '../../domain/auth_repository.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_welcome.dart';
import '../widgets/consent_block.dart';
import '../widgets/consent_sheet.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/referral_code_field.dart';
import '../widgets/social_auth_button.dart';

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
/// comes from a Zave token. The validators and the sealed-result switches are
/// untouched by that pass.
///
/// **The three use cases are not here any more.** Sign in, create account and
/// the Google hand-off — along with their in-flight flags and the
/// `SessionStore` → `authGateProvider` success tail — live on
/// [AuthController]. This file once read `authRepositoryProvider` straight out
/// of `data/`, which was the slice's only outward-pointing import and the
/// reason a disposed widget could strand a signed-in user on the login form.
/// What remains below is a form: controllers, validation, the shake, the
/// consent decision, and the copy for every outcome.
///
/// Three Zave rules drive the layout:
///
///  * **One solid-white button per screen.** That is the email CTA. The social
///    buttons are therefore `ghost`, which also matches the web's hierarchy.
///  * **Selected inverts to solid white.** The mode toggle is a hand-built
///    segmented control, never Material's `SegmentedButton` — that would bring
///    its own selection language (a tinted fill and a check glyph) onto a
///    surface whose whole selection grammar is the inversion. See
///    [_ModeToggle] for why it is not a ZaveChip pair either.
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

  /// The signed-out screen has two stages: the welcome, and the email form
  /// behind it. Google signs in straight from the welcome; `Sign in with
  /// Email` is what opens the form.
  ///
  /// A stage rather than a route: the form's controllers, validators, consent
  /// state and in-flight flags all live on this State, and pushing a second
  /// page would mean either lifting all of that out or losing what the user
  /// had typed every time they went back.
  ///
  /// `setState` is right here for the same reason [_mode] keeps it — the two
  /// stages are two different screens, so the rebuild is not wasted work.
  bool _emailStage = false;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _referralCtrl = TextEditingController();

  /// The four error strings, as notifiers rather than plain fields.
  ///
  /// Each one is read in exactly ONE place — three of them inside a single
  /// [ZaveField], the fourth inside the banner above the form — while the
  /// build they sat in is the whole screen. Worse, `onChanged` clears a field
  /// error on EVERY keystroke, so typing an email address used to rebuild the
  /// heading, the mode toggle, the Google button, the divider, the consent
  /// block and the CTA once per character. A [ValueNotifier] only notifies
  /// when the value actually changes, so clearing an already-null error is now
  /// free, and a real error repaints one field.
  final ValueNotifier<String?> _nameError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _emailError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _formError = ValueNotifier<String?>(null);

  /// Where the form-level error renders — at the top, while the button that
  /// produced it is at the bottom of a form taller than the screen. Without
  /// scrolling it into view, a refused sign-up looked like nothing happened.
  final GlobalKey _formErrorAnchor = GlobalKey();

  /// What the user has ticked on the create-account notice. Reset when the
  /// mode toggles, so switching to sign-in and back cannot leave a stale
  /// acceptance behind.
  ///
  /// Stays `setState` rather than becoming a notifier: it is read in two
  /// places that are not adjacent — the [ConsentBlock] and the CTA's
  /// `onPressed` gate, with a gap between them in the same `children` list —
  /// so scoping it would mean either two builders over one value or a wrapper
  /// that swallows everything in between. It also changes a handful of times
  /// per account, not once per keystroke.
  ConsentDecision _consent = const ConsentDecision(
    acceptedNotice: false,
    consents: <String, bool>{},
  );

  /// Built in [initState], NOT lazily.
  ///
  /// It was `late final … = AnimationController(vsync: this)`, which defers
  /// construction to first use — and the first use on a screen nobody shook
  /// was `dispose()`. Constructing a controller there calls `createTicker`,
  /// which looks up `TickerMode` on an element that is already deactivated:
  /// "Looking up a deactivated widget's ancestor is unsafe."
  ///
  /// So opening the sign-in screen and leaving WITHOUT a failed submit threw
  /// on the way out — the common path, and the one nothing exercised, since
  /// every test that touched this screen submitted something.
  late final AnimationController _shakeCtrl;

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
  ///
  /// These were bare `TapGestureRecognizer()`s with no `onTap` — two spans
  /// painted in link colour that did nothing when tapped. Worse than plain
  /// text, which at least does not promise anything. They open the same two
  /// pages the web's login footer links to.
  late final TapGestureRecognizer _termsTap = TapGestureRecognizer()
    ..onTap = () => openLinkAndReport(context, ref, plexaverseTermsUrl);
  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer()
    ..onTap = () => openLinkAndReport(context, ref, plexaversePrivacyUrl);

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _formError.addListener(_revealFormError);
  }

  void _revealFormError() {
    if (_formError.value == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? anchor = _formErrorAnchor.currentContext;
      if (!mounted || anchor == null) return;
      Scrollable.ensureVisible(
        anchor,
        duration: ZaveMotion.fast,
        curve: ZaveMotion.curve,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _referralCtrl.dispose();
    _shakeCtrl.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    _nameError.dispose();
    _emailError.dispose();
    _passwordError.dispose();
    _formError.dispose();
    super.dispose();
  }

  bool get _isSignIn => _mode == _AuthMode.signIn;

  /// The one handle onto the three use cases. Read, never watched, from the
  /// callbacks — [build] does the watching, which is also what keeps the
  /// autoDispose controller alive for as long as this screen is on it.
  AuthController get _auth => ref.read(authControllerProvider.notifier);

  void _clearErrors() {
    _nameError.value = null;
    _emailError.value = null;
    _passwordError.value = null;
    _formError.value = null;
  }

  /// No `setState`: [_Shake] listens to the controller through an
  /// [AnimatedBuilder], so driving the animation is already the repaint. The
  /// wrapping `setState` these calls used to carry rebuilt the whole screen to
  /// produce a frame the ticker was about to produce anyway.
  void _triggerShake() => _shakeCtrl.forward(from: 0);

  Future<void> _submitSignIn() async {
    _clearErrors();
    bool valid = true;
    if (_emailCtrl.text.trim().isEmpty) {
      _emailError.value = 'Email address is required';
      valid = false;
    } else if (!_emailCtrl.text.isValidEmail) {
      _emailError.value = 'Please enter a valid email address';
      valid = false;
    }
    if (_passwordCtrl.text.isEmpty) {
      _passwordError.value = 'Password is required';
      valid = false;
    }
    if (!valid) {
      _triggerShake();
      return;
    }

    final SignInResult result = await _auth.signIn(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    if (!mounted) return;

    switch (result) {
      case SignInSuccess():
        // Tokens are written and the gate re-resolved before this returns;
        // the router owns what happens next and the spinner stays up until
        // it does. Nothing for the form to say.
        break;
      case SignInInvalidCredentials():
        _formError.value = 'Incorrect email or password';
        _triggerShake();
      case SignInNetworkFailure():
        _formError.value = 'Something went wrong. Please try again.';
    }
  }

  Future<void> _submitRegister() async {
    _clearErrors();
    bool valid = true;
    if (_nameCtrl.text.trim().isEmpty) {
      _nameError.value = 'Please enter your full name';
      valid = false;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _emailError.value = 'Email address is required';
      valid = false;
    } else if (!_emailCtrl.text.isValidEmail) {
      _emailError.value = 'Please enter a valid email address';
      valid = false;
    }
    if (!_passwordCtrl.text.isValidPassword) {
      _passwordError.value = 'Password must be at least 8 characters';
      valid = false;
    }
    if (!valid) {
      _triggerShake();
      return;
    }

    final String referral = _referralCtrl.text.trim();
    final RegisterResult result = await _auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      acceptedNotice: _consent.acceptedNotice,
      consents: _consent.consents,
      referralCode: referral.isEmpty ? null : referral,
    );
    if (!mounted) return;

    switch (result) {
      case RegisterSuccess():
        break; // see [_submitSignIn]
      case RegisterInvalid(
        :final String? message,
        :final Map<String, String> fieldErrors,
      ):
        _nameError.value = fieldErrors['name'];
        _emailError.value = fieldErrors['email'];
        _passwordError.value = fieldErrors['password'];
        _formError.value =
            message ?? 'Please check your details and try again.';
        _triggerShake();
      case RegisterNetworkFailure(:final String? message):
        // The server's own words when it sent any — "New sign-ups are
        // temporarily paused" is not something to retry.
        _formError.value =
            message ?? 'Something went wrong. Please try again.';
    }
  }

  Future<void> _startGoogle() async {
    _formError.value = null;

    final GoogleResult result = await _auth.startGoogle();
    if (!mounted) return;

    switch (result) {
      case GoogleSignedIn():
        break; // see [_submitSignIn]

      case GoogleConsentRequired():
        // A brand-new data principal. Nothing has been stored about them yet,
        // and nothing will be until they accept the notice.
        await _completeGoogleSignUp(result);

      case GoogleCancelled():
        // Backing out is a decision, not an error — no banner.
        break;

      case GoogleAccountExistsWithPassword(:final String message):
        _formError.value = message;

      case GoogleFailure(:final String? message):
        _formError.value =
            message ?? 'Google sign-in failed. Please try again.';
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

    final GoogleResult result = await _auth.completeGoogleSignUp(
      step: step,
      acceptedNotice: decision.acceptedNotice,
      consents: decision.consents,
    );
    if (!mounted) return;

    switch (result) {
      case GoogleSignedIn():
        break; // see [_submitSignIn]
      case GoogleFailure(:final String? message):
        _formError.value = message ?? 'Could not create your account.';
      case GoogleResult():
        break;
    }
  }

  /// Still `setState`: the mode swaps the entire form — fields, CTA label,
  /// heading, consent block — so the rebuild IS the screen. A notifier here
  /// would be one builder around the whole build method.
  void _setMode(_AuthMode next) {
    if (_mode == next) return;
    _clearErrors();
    setState(() => _mode = next);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSignIn = _isSignIn;

    // Both spinners and every disabled-while-working gate come from the one
    // controller value. They used to be two widget booleans, which meant the
    // welcome stage and the form stage could only agree about what was in
    // flight for as long as this State survived the request.
    final AuthBusy busy = ref.watch(authControllerProvider);
    final bool googleLoading = busy == AuthBusy.google;
    final bool submitting = busy == AuthBusy.credentials;
    final bool anyBusy = busy != AuthBusy.idle;

    if (!_emailStage) {
      return ZaveScaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ZaveSpace.gutter),
            child: AuthWelcome(
              googleBusy: googleLoading,
              onGoogle: anyBusy ? null : _startGoogle,
              onEmail: () => setState(() => _emailStage = true),
            ),
          ),
        ),
      );
    }

    return ZaveScaffold(
      // No title: the screen carries its own `.h2` heading inside the scroll
      // view, and ZaveScaffold's doc is explicit that a screen never has both.
      leading: ZaveIconButton(
        icon: const Icon(AppIcons.back),
        tooltip: 'Back',
        onPressed: () {
          _clearErrors();
          setState(() => _emailStage = false);
        },
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ZaveScrollView(
          children: <Widget>[
            // Two lines' worth of room, always.
            //
            // The watermark is one line as 'Sign in' and two as 'Create an
            // account', so flipping the toggle moved it, the toggle, and
            // every field below it down by a full hero line — a jolt on the
            // control that caused it, which is the worst place for one.
            // `height: 1.0` on ZaveType.hero means two lines are exactly
            // twice the font size — read off the style so a change there
            // cannot leave this reserving the wrong amount.
            SizedBox(
              height: (ZaveType.hero.fontSize ?? 52) * 2,
              width: double.infinity,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Opacity(
                  opacity: 0.3,
                  child: Text(
                    isSignIn ? 'Sign in' : 'Create an account',
                    textAlign: TextAlign.right,
                    style: ZaveType.hero,
                  ),
                ),
              ),
            ),
            SizedBox(height: ZaveSpace.xl),
            _ModeToggle(mode: _mode, onChanged: _setMode),
            SizedBox(height: ZaveSpace.xl),

            // Form-level error. Sized-in rather than faded so the buttons below
            // move once, not twice.
            //
            // The banner is the only reader of [_formError], so it is the only
            // thing that rebuilds when one arrives — a failed sign-in no longer
            // repaints the heading, the toggle and the fields to show a line of
            // text above them.
            // Zero-height marker the banner is scrolled to — see
            // [_formErrorAnchor].
            SizedBox(key: _formErrorAnchor, width: double.infinity),
            ValueListenableBuilder<String?>(
              valueListenable: _formError,
              builder: (BuildContext context, String? formError, Widget? _) =>
                  AnimatedSwitcher(
                    duration: ZaveMotion.fast,
                    switchInCurve: ZaveMotion.curve,
                    switchOutCurve: ZaveMotion.curve,
                    transitionBuilder: (Widget child, Animation<double> anim) =>
                        SizeTransition(
                          sizeFactor: anim,
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                    child: formError == null
                        ? const SizedBox(width: double.infinity)
                        : Padding(
                            key: ValueKey<String>(formError),
                            padding: EdgeInsets.only(bottom: ZaveSpace.lg),
                            child: Semantics(
                              liveRegion: true,
                              child: FormErrorBanner(message: formError),
                            ),
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
              isLoading: googleLoading,
              onPressed: anyBusy ? null : _startGoogle,
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
                      onEmailChanged: (_) => _emailError.value = null,
                      onPasswordChanged: (_) => _passwordError.value = null,
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
                      onNameChanged: (_) => _nameError.value = null,
                      onEmailChanged: (_) => _emailError.value = null,
                      onPasswordChanged: (_) => _passwordError.value = null,
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
              busy: submitting,
              // Create-account stays disabled until the notice is accepted —
              // matching the web's submit gate, and the server's.
              onPressed: anyBusy || (!isSignIn && !_consent.isComplete)
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
      // No footer. It offered the same choice as the mode toggle a few
      // hundred pixels above it, in a second grammar — a tinted link rather
      // than a control — so the screen asked twice and answered in two
      // different languages. The toggle is the one that survives: it is a
      // control, it says which side you are on, and it is where a user who
      // has read the heading is already looking.
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Mode toggle — a chip pair, never a SegmentedButton
// ════════════════════════════════════════════════════════════════════════════

/// Sign in / Create account, as one segmented control.
///
/// The selected half inverts to solid white with ink letters, which is the
/// entire selection language of this system — a tinted pill or an underline
/// would read as a different product.
///
/// **Why this is not a [ZaveChip] pair.** It was, and two chips are two
/// objects: each drew its own fill and hairline, so the unselected one sat
/// beside the selected one as a second thing you could also have, rather than
/// the other half of one switch. Inside a track that reading gets worse, not
/// better — a hairline pill inside a hairline pill. Here the track owns the
/// border and the unselected half is drawn with nothing at all, so what you
/// see is one control with a lit side.
///
/// The halves are [Expanded] rather than sized to their labels: equal halves
/// are what makes a track read as a track, and 'Sign in' and 'Create account'
/// are nowhere near the same width.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ZaveSpace.xs),
      decoration: BoxDecoration(
        border: Border.all(color: ZaveColors.rule, width: 1),
        borderRadius: BorderRadius.circular(ZaveRadius.pill),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _ModeHalf(
              label: 'Sign in',
              selected: mode == _AuthMode.signIn,
              onTap: () => onChanged(_AuthMode.signIn),
            ),
          ),
          Expanded(
            child: _ModeHalf(
              label: 'Create account',
              selected: mode == _AuthMode.createAccount,
              onTap: () => onChanged(_AuthMode.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}

/// One half of [_ModeToggle]. Transparent until selected.
class _ModeHalf extends StatelessWidget {
  const _ModeHalf({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ZavePress(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: ZaveMotion.fast,
            curve: ZaveMotion.curve,
            alignment: Alignment.center,
            constraints: BoxConstraints(minHeight: ZaveSpace.minTapTarget),
            decoration: selected
                ? ZaveSurface.chipSelected
                : const BoxDecoration(),
            child: Text(
              label,
              style: ZaveType.label.copyWith(
                color: selected ? ZaveColors.ink : ZaveColors.ink85,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Field sets
// ════════════════════════════════════════════════════════════════════════════

/// The errors arrive as [ValueListenable]s rather than strings so that each
/// field subscribes to its own: a rejected password repaints the password
/// field and leaves the email field, the shake wrapper and everything above
/// them alone.
class _SignInFields extends StatelessWidget {
  const _SignInFields({
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.emailError,
    required this.passwordError,
    required this.shake,
    this.onEmailChanged,
    this.onPasswordChanged,
    super.key,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final ValueListenable<String?> emailError;
  final ValueListenable<String?> passwordError;
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
          ValueListenableBuilder<String?>(
            valueListenable: emailError,
            builder: (BuildContext context, String? error, Widget? _) =>
                ZaveField(
                  controller: emailCtrl,
                  label: 'Email address',
                  hint: 'you@example.com',
                  error: error,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.email],
                  prefix: const Icon(AppIcons.email),
                  onChanged: onEmailChanged,
                ),
          ),
          SizedBox(height: ZaveSpace.lg),
          ValueListenableBuilder<String?>(
            valueListenable: passwordError,
            builder: (BuildContext context, String? error, Widget? _) =>
                _PasswordField(
                  controller: passwordCtrl,
                  autofillHint: AutofillHints.password,
                  error: error,
                  onChanged: onPasswordChanged,
                ),
          ),
        ],
      ),
    );
  }
}

/// See [_SignInFields] for why the errors are listenables.
class _RegisterFields extends StatefulWidget {
  const _RegisterFields({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.referralCtrl,
    required this.nameError,
    required this.emailError,
    required this.passwordError,
    required this.shake,
    this.onNameChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
    super.key,
  });

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController referralCtrl;
  final ValueListenable<String?> nameError;
  final ValueListenable<String?> emailError;
  final ValueListenable<String?> passwordError;
  final Animation<double> shake;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  @override
  State<_RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<_RegisterFields> {
  /// Mirrors the password controller so the strength bar rebuilds live.
  ///
  /// A notifier, not a field: this changes on every keystroke of the longest
  /// field on the screen, and the only thing that reads it is the one-line
  /// [PasswordStrengthBar] directly below. As `setState` it rebuilt all four
  /// fields and the referral row per character — including the password field
  /// the user is typing into.
  ///
  /// The old "did it actually change?" guard is gone because [ValueNotifier]
  /// already drops a write of an equal value, which is why the controller
  /// listener and the field's own `onChanged` can both set it.
  late final ValueNotifier<String> _passwordText;

  @override
  void initState() {
    super.initState();
    _passwordText = ValueNotifier<String>(widget.passwordCtrl.text);
    widget.passwordCtrl.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.passwordCtrl.removeListener(_onPasswordChanged);
    _passwordText.dispose();
    super.dispose();
  }

  void _onPasswordChanged() => _passwordText.value = widget.passwordCtrl.text;

  @override
  Widget build(BuildContext context) {
    return _Shake(
      shake: widget.shake,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ValueListenableBuilder<String?>(
            valueListenable: widget.nameError,
            builder: (BuildContext context, String? error, Widget? _) =>
                ZaveField(
                  controller: widget.nameCtrl,
                  label: 'Full name',
                  hint: 'John Doe',
                  error: error,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.name],
                  prefix: const Icon(AppIcons.person),
                  onChanged: widget.onNameChanged,
                ),
          ),
          SizedBox(height: ZaveSpace.lg),
          ValueListenableBuilder<String?>(
            valueListenable: widget.emailError,
            builder: (BuildContext context, String? error, Widget? _) =>
                ZaveField(
                  controller: widget.emailCtrl,
                  label: 'Email address',
                  hint: 'you@example.com',
                  error: error,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.email],
                  prefix: const Icon(AppIcons.email),
                  onChanged: widget.onEmailChanged,
                ),
          ),
          SizedBox(height: ZaveSpace.lg),
          ValueListenableBuilder<String?>(
            valueListenable: widget.passwordError,
            builder: (BuildContext context, String? error, Widget? _) =>
                _PasswordField(
                  controller: widget.passwordCtrl,
                  autofillHint: AutofillHints.newPassword,
                  error: error,
                  onChanged: (String v) {
                    widget.onPasswordChanged?.call(v);
                    _passwordText.value = v;
                  },
                ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: _passwordText,
            builder: (BuildContext context, String password, Widget? _) =>
                PasswordStrengthBar(password: password),
          ),
          SizedBox(height: ZaveSpace.lg),
          ReferralCodeField(controller: widget.referralCtrl),
        ],
      ),
    );
  }
}

/// A [ZaveField] with an eye toggle. Split out because the obscure flag is
/// local state and both field sets need it.
///
/// **The obscure flag stays `setState`.** Splitting it out already did the job
/// a notifier would do: the tap rebuilds this widget and nothing above it. The
/// flag is then read in three places inside a build that is one field — the
/// `obscure` argument, the Semantics label and the icon — so a
/// [ValueListenableBuilder] would have to wrap the whole build method to reach
/// them, which is `setState` with more ceremony and no narrower a repaint.
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
      prefix: const Icon(AppIcons.lock),
      suffix: Semantics(
        button: true,
        label: _obscure ? 'Show password' : 'Hide password',
        child: GestureDetector(
          onTap: () => setState(() => _obscure = !_obscure),
          behavior: HitTestBehavior.opaque,
          child: Icon(_obscure ? AppIcons.eyeSlash : AppIcons.eye),
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
