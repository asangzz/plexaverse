import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plexaverse/core/extensions/string_extensions.dart';
import 'package:plexaverse/core/router/auth_gate.dart';
import 'package:plexaverse/core/storage/session_store.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

import '../../data/auth_repository_providers.dart';
import '../../domain/auth_repository.dart';
import '../widgets/auth_divider.dart';
import '../widgets/form_error_banner.dart';
import '../widgets/password_strength_bar.dart';
import '../widgets/referral_code_field.dart';
import '../widgets/social_auth_button.dart';

enum _AuthMode { signIn, createAccount }

/// Combined Sign In + Create Account screen (WF-02, AUTH-01).
///
/// **Light mode** → Clean grid-paper aesthetic:
///   • Warm parchment (#F5F4EF) + 24 px grid overlay.
///   • Rounded fields (12 px), labels always float above, thin grey borders.
///   • Purple (#6C63FF) accent: tab selection, CTA, focus rings, links.
///   • Standard pill (stadium) CTA button.
///
/// **Dark mode** → Glassmorphism:
///   • #121212 background, purple gradient glow, glass fields.
///
/// Migration note: this is the pre-migration `AuthPage`, converted verbatim
/// from `HookConsumerWidget` to `ConsumerStatefulWidget` (RULINGS ruling 18 —
/// flutter_hooks is removed). The visual tree is unchanged; only the state
/// plumbing (hooks → controllers/setState) and the backend seam (the old
/// `authProvider`/`ApiEndpoints`/`dioClient` flow → `authRepositoryProvider`
/// sealed results + `SessionStore` + `authGateProvider`) were rewritten.
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  _AuthMode _mode = _AuthMode.signIn;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _formError;

  // Submission flags. `_submitting` is the primary CTA spinner; the two social
  // flags drive the social-button spinners. Guarded so only one runs at a time.
  bool _submitting = false;
  // Google sign-in is a "coming soon" placeholder (see the button's onPressed);
  // the flow is not wired yet, so this stays constant until it lands.
  final bool _googleLoading = false;
  bool _linkedInLoading = false;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: -4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _referralCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  bool get _isSignIn => _mode == _AuthMode.signIn;

  bool get _busy => _submitting || _googleLoading || _linkedInLoading;

  void _clearErrors() {
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _formError = null;
  }

  void _triggerShake() => _shakeCtrl.forward(from: 0);

  Future<void> _submitSignIn() async {
    setState(_clearErrors);
    var valid = true;
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
    final result = await ref.read(authRepositoryProvider).signIn(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
    if (!mounted) return;

    switch (result) {
      case SignInSuccess(:final tokens):
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
    var valid = true;
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
    final referral = _referralCtrl.text.trim();
    final result = await ref.read(authRepositoryProvider).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          referralCode: referral.isEmpty ? null : referral,
        );
    if (!mounted) return;

    switch (result) {
      case RegisterSuccess(:final tokens):
        await _onAuthenticated(tokens);
      case RegisterInvalid(:final message, :final fieldErrors):
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

  Future<void> _startLinkedIn() async {
    setState(() {
      _formError = null;
      _linkedInLoading = true;
    });
    final result = await ref.read(authRepositoryProvider).signInWithLinkedIn();
    if (!mounted) return;

    switch (result) {
      case LinkedInSuccess(:final tokens):
        await _onAuthenticated(tokens);
      case LinkedInCancelled():
        setState(() => _linkedInLoading = false);
      case LinkedInFailure():
        setState(() {
          _linkedInLoading = false;
          _formError = 'LinkedIn sign-in failed. Please try again.';
        });
    }
  }

  /// Shared success tail: persist the session, then drive the auth gate so the
  /// router's redirect to `/home` fires. `SessionStore` is the single session
  /// source of truth (RULINGS ruling 8) — no navigation call here; the router
  /// owns the redirect (feature-auth.md invalidate + read(.future) pattern).
  Future<void> _onAuthenticated(AuthTokens tokens) async {
    await ref.read(sessionStoreProvider).writeTokens(
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

  void _onSwitchMode(_AuthMode newMode) {
    if (_mode == newMode) return;
    setState(() {
      _clearErrors();
      _mode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSignIn = _isSignIn;

    return Scaffold(
      backgroundColor:
          isDark ? PlexaversePalette.backgroundDark : PlexaversePalette.brutalistBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          // Light mode: CustomPaint draws 24 px grid behind content.
          // Dark mode: painter is null → no-op.
          child: CustomPaint(
            painter: isDark ? null : _GridPainter(),
            child: Column(
              children: [
                // ── Scrollable form area ──────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 72),
                        _LogoLockup(isDark: isDark),
                        const SizedBox(height: 24),

                        _AuthTabToggle(
                          mode: _mode,
                          isDark: isDark,
                          onChanged: _onSwitchMode,
                        ),
                        const SizedBox(height: 32),

                        // Form-level error banner
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) => SizeTransition(
                            sizeFactor: anim,
                            child:
                                FadeTransition(opacity: anim, child: child),
                          ),
                          child: _formError != null
                              ? Padding(
                                  key: ValueKey(_formError),
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Semantics(
                                    liveRegion: true,
                                    child: FormErrorBanner(
                                      message: _formError!,
                                      isDark: isDark,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Social auth buttons
                        SocialAuthButton(
                          provider: SocialButtonProvider.google,
                          isDark: isDark,
                          isSignIn: isSignIn,
                          isLoading: _googleLoading,
                          onPressed: _busy
                              ? null
                              : () => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Google sign-in coming soon'),
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 12),
                        SocialAuthButton(
                          provider: SocialButtonProvider.linkedIn,
                          isDark: isDark,
                          isSignIn: isSignIn,
                          isLoading: _linkedInLoading,
                          onPressed: _busy ? null : _startLinkedIn,
                        ),

                        const SizedBox(height: 20),
                        AuthDivider(isDark: isDark),
                        const SizedBox(height: 20),

                        // Tab switch — M3 shared-axis horizontal slide, 300 ms
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, anim) {
                            final entering = child.key ==
                                ValueKey(isSignIn
                                    ? _AuthMode.signIn
                                    : _AuthMode.createAccount);
                            final dx = entering
                                ? (isSignIn ? 0.12 : -0.12)
                                : (isSignIn ? -0.12 : 0.12);
                            return ClipRect(
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(dx, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child:
                                    FadeTransition(opacity: anim, child: child),
                              ),
                            );
                          },
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ...previousChildren,
                                ?currentChild,
                              ],
                            );
                          },
                          child: isSignIn
                              ? _SignInFields(
                                  key: const ValueKey(_AuthMode.signIn),
                                  emailCtrl: _emailCtrl,
                                  passwordCtrl: _passwordCtrl,
                                  emailError: _emailError,
                                  passwordError: _passwordError,
                                  shakeOffset: _shakeAnim,
                                  isDark: isDark,
                                  onEmailChanged: (_) =>
                                      setState(() => _emailError = null),
                                  onPasswordChanged: (_) =>
                                      setState(() => _passwordError = null),
                                )
                              : _RegisterFields(
                                  key: const ValueKey(_AuthMode.createAccount),
                                  nameCtrl: _nameCtrl,
                                  emailCtrl: _emailCtrl,
                                  passwordCtrl: _passwordCtrl,
                                  referralCtrl: _referralCtrl,
                                  nameError: _nameError,
                                  emailError: _emailError,
                                  passwordError: _passwordError,
                                  shakeOffset: _shakeAnim,
                                  isDark: isDark,
                                  onNameChanged: (_) =>
                                      setState(() => _nameError = null),
                                  onEmailChanged: (_) =>
                                      setState(() => _emailError = null),
                                  onPasswordChanged: (_) =>
                                      setState(() => _passwordError = null),
                                ),
                        ),

                        const SizedBox(height: 24),

                        _AuthCtaButton(
                          mode: _mode,
                          isLoading: _submitting,
                          onPressed: _busy
                              ? null
                              : isSignIn
                                  ? _submitSignIn
                                  : _submitRegister,
                        ),

                        // Terms line — register mode only
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSignIn
                              ? const SizedBox.shrink()
                              : Padding(
                                  key: const ValueKey('terms'),
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _TermsLine(isDark: isDark),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sticky switch-mode link — always thumb-reachable
                _SwitchModeRow(
                  mode: _mode,
                  isDark: isDark,
                  onSwitch: () => _onSwitchMode(
                    isSignIn ? _AuthMode.createAccount : _AuthMode.signIn,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Grid backdrop — light mode only
// ════════════════════════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0A000000) // rgba(0,0,0,0.04) — subtle grid
      ..strokeWidth = 1.0;
    const step = 24.0;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════════════════════════════════
// Logo lockup
// ════════════════════════════════════════════════════════════════════════════

class _LogoLockup extends StatelessWidget {
  final bool isDark;
  const _LogoLockup({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PlexaversePalette.primary, Color(0xFF9C27B0)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: PlexaversePalette.primary.withValues(alpha: 0.40),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: PlexaversePalette.primary.withValues(alpha: 0.20),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'P',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Plexaverse',
          style: AppTextTheme.headlineSmall.copyWith(
            color: isDark ? PlexaversePalette.grey50 : PlexaversePalette.grey900,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Tab toggle — M3 SegmentedButton, purple selection, mode-aware colours
// ════════════════════════════════════════════════════════════════════════════

class _AuthTabToggle extends StatelessWidget {
  final _AuthMode mode;
  final bool isDark;
  final ValueChanged<_AuthMode> onChanged;

  const _AuthTabToggle({
    required this.mode,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: SegmentedButton<_AuthMode>(
        segments: const [
          ButtonSegment(value: _AuthMode.signIn, label: Text('Sign In')),
          ButtonSegment(
            value: _AuthMode.createAccount,
            label: Text('Create Account'),
          ),
        ],
        selected: {mode},
        showSelectedIcon: false,
        onSelectionChanged: (s) => onChanged(s.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: WidgetStateProperty.all(
            AppTextTheme.labelLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return PlexaversePalette.primary;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return isDark ? PlexaversePalette.grey400 : PlexaversePalette.grey600;
          }),
          side: WidgetStateProperty.all(
            BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFD0D0D0),
            ),
          ),
          shape: WidgetStateProperty.all(const StadiumBorder()),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Sign In fields
// ════════════════════════════════════════════════════════════════════════════

class _SignInFields extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final String? emailError;
  final String? passwordError;
  final Animation<double> shakeOffset;
  final bool isDark;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  const _SignInFields({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    this.emailError,
    this.passwordError,
    required this.shakeOffset,
    required this.isDark,
    this.onEmailChanged,
    this.onPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shakeOffset,
      builder: (context, child) => Transform.translate(
        offset: Offset(shakeOffset.value, 0),
        child: child,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuthField(
            controller: emailCtrl,
            label: 'Email address',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            errorText: emailError,
            isDark: isDark,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 16),
          _AuthPasswordField(
            controller: passwordCtrl,
            label: 'Password',
            autofillHint: AutofillHints.password,
            errorText: passwordError,
            isDark: isDark,
            onChanged: onPasswordChanged,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: PlexaversePalette.primary,
                textStyle: AppTextTheme.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Forgot password?'),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Register fields
// ════════════════════════════════════════════════════════════════════════════

class _RegisterFields extends StatefulWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController referralCtrl;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final Animation<double> shakeOffset;
  final bool isDark;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  const _RegisterFields({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.referralCtrl,
    this.nameError,
    this.emailError,
    this.passwordError,
    required this.shakeOffset,
    required this.isDark,
    this.onNameChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
  });

  @override
  State<_RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<_RegisterFields> {
  // Mirrors the password controller so the strength bar rebuilds live — the
  // hooks version used a HookBuilder + useEffect listener for the same effect.
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
    return AnimatedBuilder(
      animation: widget.shakeOffset,
      builder: (context, child) => Transform.translate(
        offset: Offset(widget.shakeOffset.value, 0),
        child: child,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuthField(
            controller: widget.nameCtrl,
            label: 'Full name',
            hintText: 'John Doe',
            prefixIcon: Icons.person_outline,
            autofillHints: const [AutofillHints.name],
            errorText: widget.nameError,
            isDark: widget.isDark,
            onChanged: widget.onNameChanged,
          ),
          const SizedBox(height: 16),
          _AuthField(
            controller: widget.emailCtrl,
            label: 'Email address',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            errorText: widget.emailError,
            isDark: widget.isDark,
            onChanged: widget.onEmailChanged,
          ),
          const SizedBox(height: 16),
          _AuthPasswordField(
            controller: widget.passwordCtrl,
            label: 'Password',
            autofillHint: AutofillHints.newPassword,
            errorText: widget.passwordError,
            isDark: widget.isDark,
            onChanged: (v) {
              widget.onPasswordChanged?.call(v);
              setState(() => _passwordText = v);
            },
          ),
          PasswordStrengthBar(
            password: _passwordText,
            isDark: widget.isDark,
          ),
          const SizedBox(height: 16),
          ReferralCodeField(
            controller: widget.referralCtrl,
            isDark: widget.isDark,
          ),
        ],
      ),
    );
  }
}
// end register fields

// ════════════════════════════════════════════════════════════════════════════
// Shared field widgets
// ════════════════════════════════════════════════════════════════════════════

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final String? errorText;
  final bool isDark;
  final ValueChanged<String>? onChanged;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.prefixIcon,
    required this.isDark,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      onChanged: onChanged,
      style: AppTextTheme.bodyLarge.copyWith(
        color: isDark ? PlexaversePalette.grey50 : PlexaversePalette.grey900,
      ),
      decoration:
          _fieldDecoration(label, prefixIcon, errorText, isDark, hintText: hintText),
    );
  }
}

class _AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String autofillHint;
  final String? errorText;
  final bool isDark;
  final ValueChanged<String>? onChanged;

  const _AuthPasswordField({
    required this.controller,
    required this.label,
    required this.autofillHint,
    required this.isDark,
    this.errorText,
    this.onChanged,
  });

  @override
  State<_AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<_AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      autofillHints: [widget.autofillHint],
      onChanged: widget.onChanged,
      style: AppTextTheme.bodyLarge.copyWith(
        color: widget.isDark ? PlexaversePalette.grey50 : PlexaversePalette.grey900,
      ),
      decoration: _fieldDecoration(
        widget.label,
        Icons.lock_outline,
        widget.errorText,
        widget.isDark,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: widget.isDark ? PlexaversePalette.grey400 : PlexaversePalette.grey400,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(
  String label,
  IconData icon,
  String? errorText,
  bool isDark, {
  Widget? suffixIcon,
  String? hintText,
}) {
  if (isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextTheme.bodySmall.copyWith(color: PlexaversePalette.grey400),
      floatingLabelStyle:
          AppTextTheme.bodySmall.copyWith(color: PlexaversePalette.primary),
      prefixIcon: Icon(icon, color: PlexaversePalette.grey400, size: 20),
      prefixIconConstraints:
          const BoxConstraints(minWidth: 48, minHeight: 56),
      suffixIcon: suffixIcon,
      errorText: errorText,
      errorStyle: AppTextTheme.labelSmall.copyWith(color: PlexaversePalette.error),
      isDense: true,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      border: _border(Colors.white.withValues(alpha: 0.20)),
      enabledBorder: _border(Colors.white.withValues(alpha: 0.20)),
      focusedBorder: _border(PlexaversePalette.primary, width: 2),
      errorBorder: _border(PlexaversePalette.error, width: 2),
      focusedErrorBorder: _border(PlexaversePalette.error, width: 2),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  // Light mode — white fill, rounded 12 px, thin grey border, label always above
  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: AppTextTheme.bodySmall.copyWith(color: PlexaversePalette.grey600),
    floatingLabelStyle:
        AppTextTheme.bodySmall.copyWith(color: PlexaversePalette.grey600),
    hintText: hintText,
    hintStyle: AppTextTheme.bodyLarge.copyWith(color: PlexaversePalette.grey400),
    prefixIcon: Icon(icon, color: PlexaversePalette.grey400, size: 20),
    prefixIconConstraints:
        const BoxConstraints(minWidth: 48, minHeight: 56),
    suffixIcon: suffixIcon,
    errorText: errorText,
    errorStyle: AppTextTheme.labelSmall.copyWith(color: PlexaversePalette.error),
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    border: _border(const Color(0x1F000000)),
    enabledBorder: _border(const Color(0x1F000000)),
    focusedBorder: _border(PlexaversePalette.primary, width: 2),
    errorBorder: _border(PlexaversePalette.error, width: 2),
    focusedErrorBorder: _border(PlexaversePalette.error, width: 2),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  );
}

OutlineInputBorder _border(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

// ════════════════════════════════════════════════════════════════════════════
// Primary CTA — purple pill, same shape in both modes
// ════════════════════════════════════════════════════════════════════════════

class _AuthCtaButton extends StatelessWidget {
  final _AuthMode mode;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _AuthCtaButton({
    required this.mode,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final label = mode == _AuthMode.signIn ? 'Sign In' : 'Create Account';

    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: PlexaversePalette.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: PlexaversePalette.primary.withValues(alpha: 0.55),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 52),
          textStyle:
              AppTextTheme.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Sticky switch-mode row
// ════════════════════════════════════════════════════════════════════════════

class _SwitchModeRow extends StatelessWidget {
  final _AuthMode mode;
  final bool isDark;
  final VoidCallback onSwitch;

  const _SwitchModeRow({
    required this.mode,
    required this.isDark,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final isSignIn = mode == _AuthMode.signIn;
    final prefixText =
        isSignIn ? "Don't have an account? " : 'Already have an account? ';
    final linkText = isSignIn ? 'Create one' : 'Sign in';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: prefixText,
          style: AppTextTheme.bodyMedium.copyWith(
            color: isDark ? PlexaversePalette.grey400 : PlexaversePalette.grey600,
          ),
          children: [
            TextSpan(
              text: linkText,
              style: AppTextTheme.bodyMedium.copyWith(
                color: PlexaversePalette.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = onSwitch,
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Terms line — register mode only
// ════════════════════════════════════════════════════════════════════════════

class _TermsLine extends StatelessWidget {
  final bool isDark;
  const _TermsLine({required this.isDark});

  @override
  Widget build(BuildContext context) {
    const baseColor = PlexaversePalette.grey600;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By creating an account, you agree to our ',
        style: AppTextTheme.bodySmall.copyWith(color: baseColor),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: AppTextTheme.bodySmall.copyWith(
              color: PlexaversePalette.primary,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: ' and ',
            style: AppTextTheme.bodySmall.copyWith(color: baseColor),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTextTheme.bodySmall.copyWith(
              color: PlexaversePalette.primary,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: '.',
            style: AppTextTheme.bodySmall.copyWith(color: baseColor),
          ),
        ],
      ),
    );
  }
}
