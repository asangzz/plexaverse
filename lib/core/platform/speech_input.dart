import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_input.g.dart';

/// Speaking instead of typing.
///
/// ## What this is, and what it is not
///
/// Dictation: the OS listens, the OS transcribes, and the words land in the
/// field the user was already looking at. It is NOT the web's Business
/// English practice — that is a live two-way call with Plexa over WebRTC,
/// with a model on the other end, XP charged per call and a five-minute cap.
/// This has no server, no model and no cost; the two are different features
/// that both happen to start at a microphone.
///
/// ## Why the OS does the recognition
///
/// `speech_to_text` is a thin wrapper over `SFSpeechRecognizer` on iOS and
/// `SpeechRecognizer` on Android. That means no audio passes through us, no
/// recipient is added under DPDP s11, and the transcript exists only on the
/// device until the user chooses to save the post. Streaming the audio to a
/// provider ourselves would be a cross-border transfer of someone's voice to
/// make a text box easier to fill.
///
/// That is a claim about US, not about the platform: both OSes may send the
/// audio to their own servers when the device cannot transcribe locally,
/// and we deliberately do not force `onDevice` because it fails outright on
/// the devices that cannot. So the honest statement is that dictation is
/// handled by the operating system under its own privacy terms, declared in
/// `NSSpeechRecognitionUsageDescription` — exactly what happens when the
/// user presses the dictation key on their keyboard. No audio and no
/// transcript reaches a Plexaverse server, which is the part that would
/// have made this a new recipient under DPDP s11.
///
/// ## Why a seam
///
/// Like `link_opening.dart` and `image_picking.dart`: a screen can be tested
/// without a platform channel, and the mock flavor gets something that works
/// on a simulator with no microphone.
sealed class SpeechEvent {
  const SpeechEvent();
}

/// Words so far. [text] is the WHOLE utterance each time, not a delta — both
/// platforms re-send the full best guess as it firms up.
class SpeechHeard extends SpeechEvent {
  const SpeechHeard(this.text, {required this.isFinal});

  final String text;

  /// The recognizer has committed to this. Anything before it can still
  /// change, which is why a caller must replace rather than append.
  final bool isFinal;
}

/// Listening stopped on its own — a pause, the time limit, or the user.
class SpeechStopped extends SpeechEvent {
  const SpeechStopped();
}

/// It could not run, or stopped because something went wrong.
class SpeechFailed extends SpeechEvent {
  const SpeechFailed(this.reason);

  /// Already a sentence for a human. See [SpeechInputService.start].
  final String reason;
}

abstract class SpeechInputService {
  /// Whether this device can dictate at all.
  ///
  /// False on a simulator with no recognizer, on a device where the user has
  /// refused the permission, and on anything older than the plugin supports.
  /// Callers hide the control rather than offering one that cannot work.
  Future<bool> isAvailable();

  /// Start listening, reporting through [onEvent] until it stops.
  ///
  /// Never throws: every failure arrives as [SpeechFailed] carrying a
  /// sentence, because every caller's response to a `PlatformException` and
  /// to "no microphone" is the same one — say so, and stay put.
  Future<void> start({
    required void Function(SpeechEvent) onEvent,
    String? localeId,
  });

  /// Stop listening and keep what was heard. Safe to call when idle.
  Future<void> stop();

  /// Stop listening and discard it.
  Future<void> cancel();
}

class PlatformSpeechInput implements SpeechInputService {
  PlatformSpeechInput();

  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  /// How long a single dictation runs before the OS stops on its own.
  ///
  /// Generous, because a post is several sentences and the default on
  /// Android is about half a minute. The pause window is what actually ends
  /// most dictations; this is the backstop.
  static const Duration _maxListen = Duration(minutes: 2);

  /// Silence that ends it. Long enough to think mid-sentence.
  static const Duration _pause = Duration(seconds: 4);

  Future<bool> _init(void Function(SpeechEvent)? onEvent) async {
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        // Both of these fire outside the result callback, so the only way a
        // caller learns the microphone died is through here.
        onError: (SpeechRecognitionError e) =>
            onEvent?.call(SpeechFailed(_say(e))),
        onStatus: (String status) {
          if (status == 'done' || status == 'notListening') {
            onEvent?.call(const SpeechStopped());
          }
        },
      );
    } on Object {
      _ready = false;
    }
    return _ready;
  }

  /// The plugin's error codes, in words a user can act on.
  static String _say(SpeechRecognitionError e) => switch (e.errorMsg) {
    'error_permission' ||
    'error_speech_timeout' when !e.permanent => 'I did not catch anything.',
    'error_permission' =>
      'Microphone access is off. Turn it on in Settings, then try again.',
    'error_no_match' => 'I did not catch that. Try again, a little closer.',
    'error_busy' => 'The microphone is busy in another app.',
    'error_network' ||
    'error_network_timeout' =>
      'Dictation needs a connection on this device.',
    _ => 'Dictation stopped. Try again.',
  };

  @override
  Future<bool> isAvailable() async => _init(null);

  @override
  Future<void> start({
    required void Function(SpeechEvent) onEvent,
    String? localeId,
  }) async {
    if (!await _init(onEvent)) {
      onEvent(
        const SpeechFailed('Dictation is not available on this device.'),
      );
      return;
    }
    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult r) =>
            onEvent(SpeechHeard(r.recognizedWords, isFinal: r.finalResult)),
        // Everything goes through `listenOptions`; the same names exist as
        // top-level arguments and are deprecated.
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: _maxListen,
          pauseFor: _pause,
          // The caller is filling a text field, so partials are the point:
          // the user watches it appear and knows it is working.
          partialResults: true,
          cancelOnError: true,
          // A post is prose. Without this the user dictates one long
          // run-on and has to go back in and punctuate it by hand, which
          // is most of the typing they were avoiding.
          autoPunctuation: true,
          // Dictation, not a command. `confirmation` would have the OS
          // decide when a phrase is complete and cut long sentences short.
          listenMode: ListenMode.dictation,
          // NOT `onDevice: true`. It forces strictly-local recognition and
          // FAILS outright where the device cannot do it, which is most
          // Android handsets and any iPhone without the language
          // downloaded — the control would be there and never work. The
          // trade is stated plainly in this file's header and in
          // NSSpeechRecognitionUsageDescription.
        ),
      );
    } on Object {
      onEvent(const SpeechFailed('Dictation stopped. Try again.'));
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _speech.stop();
    } on Object {
      // Already stopped, or the channel is gone. Either way: stopped.
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await _speech.cancel();
    } on Object {
      // As above.
    }
  }
}

@Riverpod(keepAlive: true)
SpeechInputService speechInput(Ref ref) => PlatformSpeechInput();
