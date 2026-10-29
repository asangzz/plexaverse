import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'speech_input.dart';

part 'dictation_controller.g.dart';

/// Which field is being dictated into, and what has been heard so far.
///
/// ## Why one controller for the whole app
///
/// There is one microphone. Two fields listening at once is not a state the
/// hardware can be in, so it is not a state this can represent: [fieldId]
/// names the single field that holds it, and starting a second dictation
/// stops the first. A per-widget flag could not do that — the other field
/// would keep drawing itself as live while the OS had already taken the
/// microphone away.
///
/// It also keeps the in-flight flag and the failure OFF the widgets, which
/// `test/architecture/no_async_state_in_widgets_test.dart` requires and
/// which matters here for the usual reason: a user can leave the screen
/// mid-sentence and the recognizer keeps going until something stops it.
class DictationState {
  const DictationState({
    this.fieldId,
    this.heard = '',
    this.error,
    this.available,
  });

  /// The field currently listening. Null when nothing is.
  final String? fieldId;

  /// The WHOLE utterance so far, not a delta — both platforms re-send their
  /// best guess as it firms up, so a caller replaces rather than appends.
  final String heard;

  /// A sentence to show. Cleared when the next dictation starts.
  final String? error;

  /// Whether this device can dictate. Null until asked; the control stays
  /// hidden until it is known, rather than appearing and then failing.
  final bool? available;

  bool get isListening => fieldId != null;

  bool listeningFor(String id) => fieldId == id;

  DictationState copyWith({
    String? fieldId,
    String? heard,
    String? error,
    bool? available,
    bool clearField = false,
    bool clearError = false,
  }) => DictationState(
    fieldId: clearField ? null : (fieldId ?? this.fieldId),
    heard: heard ?? this.heard,
    error: clearError ? null : (error ?? this.error),
    available: available ?? this.available,
  );
}

@Riverpod(keepAlive: true)
class Dictation extends _$Dictation {
  @override
  DictationState build() => const DictationState();

  SpeechInputService get _speech => ref.read(speechInputProvider);

  /// Ask the OS once whether this is possible at all.
  ///
  /// Called by the button when it first builds, so a device that cannot
  /// dictate never shows a microphone. The answer is cached in state —
  /// `initialize()` is what triggers the permission prompt on both
  /// platforms, and asking per keystroke would re-prompt.
  Future<void> checkAvailability() async {
    if (state.available != null) return;
    final bool ok = await _speech.isAvailable();
    if (!ref.mounted) return;
    state = state.copyWith(available: ok);
  }

  /// Start listening for [fieldId], stopping whatever else was.
  Future<void> start(String fieldId) async {
    if (state.isListening) await stop();
    if (!ref.mounted) return;
    state = DictationState(
      fieldId: fieldId,
      available: state.available,
    );

    await _speech.start(
      onEvent: (SpeechEvent event) {
        if (!ref.mounted) return;
        // A late event from the PREVIOUS dictation must not write into the
        // one that replaced it.
        if (state.fieldId != fieldId) return;
        switch (event) {
          case SpeechHeard(:final String text):
            state = state.copyWith(heard: text);
          case SpeechStopped():
            state = state.copyWith(clearField: true);
          case SpeechFailed(:final String reason):
            state = state.copyWith(clearField: true, error: reason);
        }
      },
    );
  }

  /// Stop listening and keep what was heard.
  Future<void> stop() async {
    await _speech.stop();
    if (!ref.mounted) return;
    state = state.copyWith(clearField: true);
  }

  /// Stop because the field went away. Discards rather than keeping — the
  /// box the words were going into no longer exists.
  Future<void> abandon(String fieldId) async {
    if (!state.listeningFor(fieldId)) return;
    await _speech.cancel();
    if (!ref.mounted) return;
    state = state.copyWith(clearField: true, heard: '');
  }

  void clearError() => state = state.copyWith(clearError: true);
}
