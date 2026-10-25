import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../onboarding/application/welcome_bonus.dart';
import '../../../onboarding/presentation/pages/onboarding_chat_page.dart';
import '../widgets/plexa_clips.dart';
import '../widgets/plexa_mascot.dart';
import '../widgets/welcome_bonus_overlay.dart';

/// **Plexa's journey** — the app's onboarding, and the web's: Plexa's intro,
/// then the chat with her in the top row. A port of
/// `components/plexa/PlexaJourney.tsx`, which the web mounts at `/onboarding`.
///
/// Two phases. The intro: Plexa says hello, gets excited, and gets her notepad
/// out, one Continue at a time. Then onboarding: the bird flies up into the
/// chat's top row, shrinking as she goes, and the real onboarding chat — the
/// same questions, the same saves ([OnboardingChatBody]) — runs underneath her
/// without its own Plexa avatar.
///
/// Mounted twice: at `/onboarding`, where every new account starts, and at
/// `/plexa`, Settings' way back in for an account that has already finished
/// ([exitToDashboard]). The web keeps `/plexa` only as a redirect to
/// `/onboarding`; the app cannot, because its onboarding gate sends a finished
/// account away from `/onboarding`.
///
/// ## The welcome bonus
///
/// The web's `OnboardingClient` celebrates the one-time "+2,500 XP" when it
/// has just landed, and holds Plexa while it does (see [PlexaMascot.hold]).
/// The bonus is credited on the first LinkedIn connect — for a company brand,
/// when its page is saved — so the celebration usually arrives mid-chat.
///
/// ## The flying bird
///
/// Plexa is one widget for the whole journey, positioned over an empty
/// placeholder: a box in the intro's row, then a box at the start of the
/// chat's progress row. Switching placeholders and animating the position and
/// height is the flight. One widget, because remounting it mid-flight would
/// reload and restart the clips.
///
/// ## Off the Zave palette, on purpose
///
/// The intro is the new design, not a Zave surface — black ground, an indigo
/// card, a white button — so its colours are its own constants rather than
/// tokens borrowed for something they were not chosen for. The chat is the
/// existing Zave one, unchanged.
///
/// ## Every intro size is a multiple of the bird
///
/// `u` is the mascot's height. The line, the gaps and the button are all drawn
/// as fractions of it, on the phone frame and the wide one, because that is how
/// the design is drawn; the card alone is placed against the screen. The
/// fractions are the web's, so the two stay one design. The line uses even
/// leading, which is CSS's model — with Flutter's default the same numbers
/// would set the text a few pixels low.
class PlexaJourneyPage extends ConsumerStatefulWidget {
  const PlexaJourneyPage({this.exitToDashboard = false, super.key});

  /// Leave for the dashboard when the chat finishes. Off at `/onboarding`,
  /// where releasing the onboarding gate is what moves the user on; on at
  /// `/plexa`, which no gate watches.
  final bool exitToDashboard;

  /// The web's `md` breakpoint, where the layout turns side by side.
  static const double wideFrom = 768;

  @override
  ConsumerState<PlexaJourneyPage> createState() => _PlexaJourneyPageState();
}

/// One beat of the introduction: what Plexa does, and what she says.
class _Step {
  const _Step(this.clip, this.line);

  final PlexaClip clip;

  /// Null for the greeting, which is drawn with the brand mark (see
  /// [_Greeting]).
  final String? line;
}

const List<_Step> _steps = <_Step>[
  _Step(PlexaClip.hello, null),
  _Step(PlexaClip.excited, 'Glad you like it, we are excited to move ahead…'),
  // Placeholder, as on the web — no copy has been written for this screen yet.
  _Step(PlexaClip.notes, 'Let me note down a few things about you…'),
];

final List<PlexaClip> _clips = <PlexaClip>[
  for (final _Step step in _steps) step.clip,
];

/// Plexa stays on the notepad clip's last frame through the questions.
const PlexaClip _onboardingClip = PlexaClip.notes;

const Color _cardTop = Color(0xFF000000);
const Color _card33 = Color(0xFF0E0A2F);
const Color _card65 = Color(0xFF1A135E);
const Color _cardBase = Color(0xFF251A82);
const Color _cardRim = Color(0xFF6057D4);
const Color _buttonFill = Color(0xFFF4F4F8);
const Color _buttonInk = Color(0xFF0A0621);

/// The line fades out, then the next fades in — the web's
/// `AnimatePresence mode="wait"` at 180 ms a side. The interval curves hold the
/// incoming line at zero for the first half and finish the outgoing one in it.
const Duration _lineFade = Duration(milliseconds: 360);
const Curve _secondHalf = Interval(0.5, 1);

/// The web's flight: 700 ms on `cubic-bezier(0.22, 1, 0.36, 1)`.
const Duration _flight = Duration(milliseconds: 700);
const Curve _flightCurve = Cubic(0.22, 1, 0.36, 1);

/// The intro fades out over the chat (web: 350 ms); the chat fades in under it
/// (web: 450 ms after a 150 ms delay).
const Duration _introFade = Duration(milliseconds: 350);
const Duration _chatFade = Duration(milliseconds: 600);
const Curve _chatFadeCurve = Interval(0.25, 1);

enum _Phase { intro, onboarding }

class _PlexaJourneyPageState extends ConsumerState<PlexaJourneyPage> {
  int _step = 0;
  _Phase _phase = _Phase.intro;

  /// The intro is gone from the tree once it has faded out.
  bool _introGone = false;

  /// True only for the flight. Left on, every relayout would drag the bird
  /// after her placeholder for 700 ms.
  bool _flying = false;

  final GlobalKey _root = GlobalKey();
  final GlobalKey _introAnchor = GlobalKey();
  final GlobalKey _chatAnchor = GlobalKey();

  /// Where the bird is, relative to [_root]. Null until first measured.
  Rect? _bird;

  /// The welcome bonus has been celebrated (or tapped away) on this visit.
  bool _welcomeDismissed = false;

  bool get _isLastStep => _step == _steps.length - 1;

  void _continue() {
    if (!_isLastStep) {
      setState(() => _step++);
      return;
    }
    setState(() {
      _phase = _Phase.onboarding;
      _flying = !MediaQuery.disableAnimationsOf(context);
    });
  }

  /// Puts the bird over whichever placeholder the phase uses.
  ///
  /// After every build, because the placeholder is laid out by a subtree this
  /// page does not own (the chat's top row) and can only be read once it has
  /// been. A no-op unless it actually moved, so it settles in one extra frame.
  void _measure() {
    if (!mounted) return;
    final GlobalKey anchor = _phase == _Phase.intro
        ? _introAnchor
        : _chatAnchor;
    final RenderObject? a = anchor.currentContext?.findRenderObject();
    final RenderObject? r = _root.currentContext?.findRenderObject();
    if (a is! RenderBox || r is! RenderBox || !a.hasSize || !a.attached) {
      return;
    }
    final Rect next = a.localToGlobal(Offset.zero, ancestor: r) & a.size;
    final Rect? now = _bird;
    if (now == null ||
        (next.topLeft - now.topLeft).distance > 0.5 ||
        (next.height - now.height).abs() > 0.5) {
      setState(() => _bird = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    final bool chatOpen = _phase == _Phase.onboarding;

    // The web's `freshRegistration` and its `hold`. Plexa waits for the answer
    // too — the overlay can only be ruled out once it is in — but only for the
    // FIRST answer: a re-read after the connect must not take her off stage.
    final AsyncValue<bool> bonus = ref.watch(welcomeBonusProvider);
    final bool bonusPending = !bonus.hasValue && !bonus.hasError;
    final bool celebrate =
        !_welcomeDismissed &&
        (bonus.whenOrNull(data: (bool fresh) => fresh) ?? false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wide = constraints.maxWidth >= PlexaJourneyPage.wideFrom;
            final Rect? bird = _bird;
            return Stack(
              key: _root,
              children: <Widget>[
                if (chatOpen)
                  KeyedSubtree(
                    key: const ValueKey<String>('chat'),
                    child: _Chat(
                      anchor: _chatAnchor,
                      wide: wide,
                      exitToDashboard: widget.exitToDashboard,
                    ),
                  ),
                if (!_introGone)
                  Positioned.fill(
                    key: const ValueKey<String>('intro'),
                    child: IgnorePointer(
                      ignoring: chatOpen,
                      child: AnimatedOpacity(
                        opacity: chatOpen ? 0 : 1,
                        duration: _introFade,
                        onEnd: () {
                          if (chatOpen) setState(() => _introGone = true);
                        },
                        child: _intro(constraints.biggest, wide: wide),
                      ),
                    ),
                  ),
                // Last, so she is over the chat's header as well as the intro.
                AnimatedPositioned(
                  key: const ValueKey<String>('bird'),
                  left: bird?.left ?? 0,
                  top: bird?.top ?? 0,
                  width: bird?.width ?? 0,
                  height: bird?.height ?? 0,
                  duration: _flying ? _flight : Duration.zero,
                  curve: _flightCurve,
                  onEnd: () {
                    if (_flying) setState(() => _flying = false);
                  },
                  child: IgnorePointer(
                    child: PlexaMascot(
                      clip: chatOpen ? _onboardingClip : _steps[_step].clip,
                      clips: _clips,
                      hold: bonusPending || celebrate,
                    ),
                  ),
                ),
                if (celebrate)
                  Positioned.fill(
                    key: const ValueKey<String>('welcome-bonus'),
                    child: WelcomeBonusOverlay(
                      onDismiss: () => setState(() => _welcomeDismissed = true),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _intro(Size screen, {required bool wide}) {
    final double w = screen.width;
    final double h = screen.height;

    final double u = wide
        ? math.min(0.105 * w, 0.201 * h).clamp(112, 240).toDouble()
        : math.min(0.286 * w, 0.14 * h);

    final EdgeInsets card = wide
        ? EdgeInsets.fromLTRB(0.0425 * w, 0.43 * h, 0.0425 * w, 0.12 * h)
        : EdgeInsets.fromLTRB(16, 0.435 * h, 16, 0.0625 * h);
    final double cardHeight = h - card.top - card.bottom;
    // The bright rim is a fixed share of the bird, not of the card.
    final double rimStart = (1 - 0.26 * u / cardHeight).clamp(0.66, 1.0);

    // Where the bird stands during the intro.
    final Widget mascot = SizedBox(
      key: _introAnchor,
      width: u * PlexaMascot.boxAspect,
      height: u,
    );
    final Widget line = _LineSwitcher(step: _step, u: u, wide: wide);

    return Stack(
      children: <Widget>[
        Positioned(
          left: card.left,
          top: card.top,
          right: card.right,
          bottom: card.bottom,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.4 * u),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const <Color>[
                  _cardTop,
                  _card33,
                  _card65,
                  _cardBase,
                  _cardRim,
                ],
                stops: <double>[0, 0.33, 0.65, rimStart, 1],
              ),
            ),
          ),
        ),
        if (wide)
          Positioned(
            left: 0,
            right: 0,
            top: 0.436 * h - 0.5 * u,
            // The gap clears the excited pose's wing tip, which reaches 0.33u
            // past the footprint. The line's column has a fixed width so a
            // longer line wraps instead of widening the row — a wider row
            // would re-centre and slide the bird sideways mid-clip.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                mascot,
                SizedBox(width: 0.5 * u),
                // The line's middle sits two-thirds down the bird, however
                // many lines it wraps to.
                SizedBox(
                  width: 2.2 * u,
                  height: u,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.325 * u),
                    child: line,
                  ),
                ),
              ],
            ),
          )
        else
          Positioned(
            left: 0,
            right: 0,
            top: 0.4275 * h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                mascot,
                SizedBox(height: 0.207 * u),
                SizedBox(width: 2.2 * u, child: line),
              ],
            ),
          ),
        Positioned(
          left: card.left,
          right: wide ? card.right + 0.0525 * w : card.right,
          bottom: card.bottom,
          child: Align(
            alignment: wide ? Alignment.centerRight : Alignment.center,
            // Straddles the card's bottom edge.
            child: FractionalTranslation(
              translation: Offset(0, wide ? 0.5 : 0.28),
              child: _ContinueButton(u: u, onTap: _continue),
            ),
          ),
        ),
      ],
    );
  }
}

/// The onboarding chat, faded in under the departing intro, with an empty box
/// at the start of its progress row for the bird to land in.
class _Chat extends StatelessWidget {
  const _Chat({
    required this.anchor,
    required this.wide,
    required this.exitToDashboard,
  });

  final GlobalKey anchor;
  final bool wide;
  final bool exitToDashboard;

  @override
  Widget build(BuildContext context) {
    // The web's h-14 / md:h-[72px].
    final double height = wide ? 72 : 56;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: _chatFade,
      curve: _chatFadeCurve,
      builder: (BuildContext context, double t, Widget? child) =>
          Opacity(opacity: t, child: child),
      child: ZaveScaffold(
        title: 'Plexa setup',
        body: OnboardingChatBody(
          lead: SizedBox(
            key: anchor,
            width: height * PlexaMascot.boxAspect,
            height: height,
          ),
          // Plexa is the mascot now — no mark beside every message.
          showBotAvatar: false,
          // /onboarding is moved on by the onboarding gate; /plexa is not
          // gated, so it leaves by itself — to the dashboard, as on the web.
          onCompleted: exitToDashboard
              ? () => context.go(ZaveRoutes.dashboard)
              : null,
        ),
      ),
    );
  }
}

/// The current step's line, faded out and the next one in on a change.
class _LineSwitcher extends StatelessWidget {
  const _LineSwitcher({
    required this.step,
    required this.u,
    required this.wide,
  });

  final int step;
  final double u;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    // The line is drawn to the bird's scale; past a little growth it pushes
    // the composition apart without being easier to read.
    final TextScaler scaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 1.2);
    final TextStyle style = GoogleFonts.urbanist(
      fontSize: 0.245 * u,
      fontWeight: FontWeight.w400,
      height: 1.19,
      color: Colors.white,
    ).copyWith(leadingDistribution: TextLeadingDistribution.even);
    final Alignment align = wide ? Alignment.centerLeft : Alignment.topCenter;

    final String? text = _steps[step].line;
    final Widget content = text == null
        ? _Greeting(style: style, scaler: scaler)
        : Text(
            text,
            textAlign: wide ? TextAlign.left : TextAlign.center,
            textScaler: scaler,
            style: style,
          );

    return Semantics(
      liveRegion: true,
      header: true,
      child: AnimatedSwitcher(
        duration: _lineFade,
        switchInCurve: _secondHalf,
        switchOutCurve: _secondHalf,
        // Every line is placed on its own against the same box, so a shorter
        // line does not jump when the longer one it replaced is removed.
        layoutBuilder: (Widget? current, List<Widget> previous) => Stack(
          fit: wide ? StackFit.expand : StackFit.loose,
          alignment: align,
          clipBehavior: Clip.none,
          children: <Widget>[...previous, ?current],
        ),
        child: KeyedSubtree(
          key: ValueKey<int>(step),
          // Wide: centred on the box whatever its height, spilling above and
          // below when it wraps further — as the web's flex centring does.
          // A line wraps at the column; the greeting never wraps, and centres
          // on the column even where it is a little wider than it.
          child: OverflowBox(
            minWidth: 0,
            maxWidth: text == null ? double.infinity : 2.2 * u,
            minHeight: 0,
            maxHeight: double.infinity,
            fit: OverflowBoxFit.deferToChild,
            alignment: align,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// "Hi there, I am Plexa", with the brand mark raised after the name.
///
/// The mark is positioned off the text rather than laid out beside it, so the
/// greeting centres on its words alone — as it does in the design. One line
/// always: it is a touch narrower than the column, and a wrapped greeting would
/// strand the mark.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.style, required this.scaler});

  final TextStyle style;
  final TextScaler scaler;

  @override
  Widget build(BuildContext context) {
    // The mark is placed in ems of the text as actually drawn.
    final double em = scaler.scale(style.fontSize!);
    // Urbanist's cap height is 0.70em under a 0.95em ascent; with even leading
    // the glyphs sit (height − 1.2) / 2 em below the line box's top.
    final double capTop = ((style.height! - 1.2) / 2 + 0.95 - 0.70) * em;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Text(
          'Hi there, I am Plexa',
          maxLines: 1,
          softWrap: false,
          textScaler: scaler,
          style: style,
        ),
        Positioned(
          right: -(0.288 + 0.525) * em,
          top: capTop - 0.585 * em,
          width: 0.525 * em,
          height: 0.761 * em,
          child: const ExcludeSemantics(
            child: Image(
              image: AssetImage('assets/branding/logo_mark.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.u, required this.onTap});

  final double u;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ZavePress(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: 1.41 * u,
            height: 0.38 * u,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _buttonFill,
              borderRadius: BorderRadius.circular(0.14 * u),
            ),
            child: Text(
              'Continue',
              maxLines: 1,
              textScaler: MediaQuery.textScalerOf(
                context,
              ).clamp(maxScaleFactor: 1.2),
              style: GoogleFonts.urbanist(
                fontSize: 0.167 * u,
                fontWeight: FontWeight.w700,
                color: _buttonInk,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
