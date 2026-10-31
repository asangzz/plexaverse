import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform/dictation_controller.dart';
import '../../theme/zave/zave.dart';
import '../app_icons.dart';
import 'zave_press.dart';

/// Speak instead of typing.
///
/// Two looks, one behaviour. Without [label] it is a bare microphone for a
/// [ZaveField]'s `suffix` — the composer, where filling the box IS the job and
/// the field is the only thing on screen. With [label] it is a pill that sits
/// under the field and says what it does, for the quiz, where the box is one
/// of several things being asked of the learner and a mic in the corner reads
/// as decoration. Mirrors the web's `SayItInstead`.
///
/// ## It appends, and it replaces the tail
///
/// Both platforms re-send the WHOLE utterance as their guess firms up, not a
/// delta. So the text already in the box when dictation started is kept as a
/// base and the utterance is rewritten after it on every update. Appending
/// each callback instead would stutter the sentence out three times over as
/// the recognizer changed its mind.
///
/// ## It hides itself rather than failing
///
/// A simulator with no recognizer, a device where the permission was
/// refused, an OS too old — the control is simply absent. Offering a
/// microphone that cannot work and explaining afterwards is worse than not
/// offering one, and the user still has a keyboard either way.
class ZaveDictateButton extends ConsumerStatefulWidget {
  const ZaveDictateButton({
    required this.controller,
    required this.fieldId,
    this.onChanged,
    this.label,
    this.focusNode,
    super.key,
  });

  /// The field this speaks into.
  final TextEditingController controller;

  /// Stable, and unique on the screen. Two fields cannot listen at once —
  /// there is one microphone — so this is how the live one is named.
  final String fieldId;

  /// Called with the full text after each update, for callers that mirror
  /// the field into their own state (the Learn player does).
  final ValueChanged<String>? onChanged;

  /// Null draws the bare microphone; a string draws a labelled pill.
  final String? label;

  /// The field's own node. Given one, starting a dictation puts the caret in
  /// the box — so the words land somewhere the user is already looking, and
  /// editing them afterwards is one tap rather than two.
  final FocusNode? focusNode;

  @override
  ConsumerState<ZaveDictateButton> createState() => _ZaveDictateButtonState();
}

class _ZaveDictateButtonState extends ConsumerState<ZaveDictateButton> {
  /// What was in the box when this dictation started.
  String _base = '';

  /// Held, not read from `ref` in dispose.
  ///
  /// Riverpod refuses `ref` once a widget is unmounting — it is backed by
  /// the BuildContext — and this is the one place that has to act AFTER
  /// that point. Without the saved handle, leaving the screen mid-sentence
  /// threw and the recognizer carried on into the next screen with the
  /// microphone still live.
  late final Dictation _dictation = ref.read(dictationProvider.notifier);

  @override
  void initState() {
    super.initState();
    // After the frame: this asks the OS, which on first use raises the
    // permission prompt, and neither belongs in a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _dictation.checkAvailability();
    });
  }

  @override
  void dispose() {
    // The box these words were going into is gone. Discard rather than
    // keep: the recognizer would otherwise run on into the next screen.
    _dictation.abandon(widget.fieldId);
    super.dispose();
  }

  void _write(String heard) {
    final String joined = _base.isEmpty
        ? heard
        : _base.endsWith(' ') || _base.endsWith('\n')
        ? '$_base$heard'
        : '$_base $heard';
    widget.controller.value = TextEditingValue(
      text: joined,
      selection: TextSelection.collapsed(offset: joined.length),
    );
    widget.onChanged?.call(joined);
  }

  Future<void> _toggle(bool listening) async {
    if (listening) {
      await _dictation.stop();
      return;
    }
    _base = widget.controller.text;
    // Before starting, not after: the OS may take a moment over the
    // permission, and a caret that arrives late looks like a dropped tap.
    if (widget.focusNode != null) {
      widget.focusNode!.requestFocus();
      unawaited(_keepVisible());
    }
    await _dictation.start(widget.fieldId);
  }

  /// Scroll this back into view after the keyboard has taken its space.
  ///
  /// Focusing the field raises the keyboard AND scrolls the field into view,
  /// and the labelled form sits UNDER the field — so the one control that
  /// stops the dictation ends up behind the keyboard, a frame after the user
  /// asked for it. The delay covers the keyboard's own inset animation;
  /// running it on the next frame alone lands before the insets exist.
  Future<void> _keepVisible() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    final BuildContext ctx = context;
    if (!ctx.mounted || Scrollable.maybeOf(ctx) == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      // Near the bottom of the viewport: this is the last thing under the
      // field, and pulling it to the middle would push the question off.
      alignment: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DictationState state = ref.watch(dictationProvider);

    // Words arrive on the controller, not in build — writing to a
    // TextEditingController during a build would rebuild mid-frame.
    ref.listen<DictationState>(dictationProvider, (
      DictationState? before,
      DictationState after,
    ) {
      if (after.listeningFor(widget.fieldId) && after.heard != before?.heard) {
        _write(after.heard);
      }
      final String? error = after.error;
      if (error != null && error != before?.error && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        _dictation.clearError();
      }
    });

    if (state.available != true) return const SizedBox.shrink();

    final bool listening = state.listeningFor(widget.fieldId);
    // Another field has the microphone. Shown, but inert — a mic that looks
    // live on two fields at once is a lie about the hardware.
    final bool blocked = state.isListening && !listening;

    final String? label = widget.label;

    return ZavePress(
      child: GestureDetector(
        onTap: blocked ? null : () => _toggle(listening),
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          button: true,
          label: listening ? 'Stop dictating' : 'Dictate',
          child: label == null
              ? _Mic(listening: listening, dimmed: blocked)
              : _Pill(
                  label: listening ? 'Stop' : label,
                  listening: listening,
                  dimmed: blocked,
                ),
        ),
      ),
    );
  }
}

class _Mic extends StatefulWidget {
  const _Mic({
    required this.listening,
    required this.dimmed,
    this.onViolet = false,
  });

  final bool listening;
  final bool dimmed;

  /// Drawn on the filled pill, where the usual violet glyph disappears.
  final bool onViolet;

  @override
  State<_Mic> createState() => _MicState();
}

class _MicState extends State<_Mic> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
    lowerBound: 0.45,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_Mic old) {
    super.didUpdateWidget(old);
    if (old.listening != widget.listening) _sync();
  }

  /// A live microphone has to LOOK live, or a user who has stopped talking
  /// cannot tell whether it is still on. Reduce Motion gets the colour and
  /// the second glyph instead of the pulse — both of which already say it.
  void _sync() {
    final bool still = MediaQuery.disableAnimationsOf(context);
    if (widget.listening && !still) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget icon = Icon(
      widget.listening ? AppIcons.micOn : AppIcons.mic,
      size: widget.onViolet ? 16 : 20,
      color: widget.onViolet
          ? ZaveColors.white
          : widget.listening
          ? ZaveColors.violetLift
          : widget.dimmed
          ? ZaveColors.ink35
          : ZaveColors.ink45,
    );

    if (!widget.listening) return icon;
    return FadeTransition(opacity: _pulse, child: icon);
  }
}

/// The labelled form: a microphone and what it does.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.listening,
    required this.dimmed,
  });

  final String label;
  final bool listening;
  final bool dimmed;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: dimmed ? 0.5 : 1,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: listening ? ZaveColors.violet : ZaveGlass.controlFill,
        border: Border.all(
          color: listening ? ZaveColors.violet : ZaveGlass.controlBorder,
        ),
        borderRadius: ZaveRadius.pillBr,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Mic(listening: listening, dimmed: dimmed, onViolet: listening),
          const SizedBox(width: 7),
          Text(
            label,
            style: ZaveType.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: listening ? ZaveColors.white : ZaveColors.ink85,
            ),
          ),
        ],
      ),
    ),
  );
}
