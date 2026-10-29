import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform/dictation_controller.dart';
import '../../theme/zave/zave.dart';
import '../app_icons.dart';
import 'zave_press.dart';

/// Speak instead of typing. Goes in a [ZaveField]'s `suffix`.
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
    await _dictation.start(widget.fieldId);
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

    return ZavePress(
      child: GestureDetector(
        onTap: blocked ? null : () => _toggle(listening),
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          button: true,
          label: listening ? 'Stop dictating' : 'Dictate',
          child: _Mic(listening: listening, dimmed: blocked),
        ),
      ),
    );
  }
}

class _Mic extends StatefulWidget {
  const _Mic({required this.listening, required this.dimmed});

  final bool listening;
  final bool dimmed;

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
      size: 20,
      color: widget.listening
          ? ZaveColors.violetLift
          : widget.dimmed
          ? ZaveColors.ink35
          : ZaveColors.ink45,
    );

    if (!widget.listening) return icon;
    return FadeTransition(opacity: _pulse, child: icon);
  }
}
