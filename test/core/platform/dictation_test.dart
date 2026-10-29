import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/platform/dictation_controller.dart';
import 'package:plexaverse/core/platform/speech_input.dart';
import 'package:plexaverse/core/ui/zave/zave_dictate_button.dart';

/// Dictation: speaking a post instead of typing it.
///
/// There is ONE microphone, and most of what is pinned here follows from
/// that — two fields cannot listen at once, a late event from a dictation
/// that has been replaced must not write into the one that replaced it, and
/// leaving the screen has to stop the recognizer rather than let it run on.
class _Speech implements SpeechInputService {
  _Speech({this.available = true});

  bool available;
  int availabilityChecks = 0;
  int starts = 0;
  int stops = 0;
  int cancels = 0;

  void Function(SpeechEvent)? _listener;

  /// Pretend the OS heard something.
  void hear(String text, {bool isFinal = false}) =>
      _listener?.call(SpeechHeard(text, isFinal: isFinal));

  void fail(String why) => _listener?.call(SpeechFailed(why));

  @override
  Future<bool> isAvailable() async {
    availabilityChecks++;
    return available;
  }

  @override
  Future<void> start({
    required void Function(SpeechEvent) onEvent,
    String? localeId,
  }) async {
    starts++;
    _listener = onEvent;
  }

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> cancel() async => cancels++;
}

ProviderContainer _container(_Speech speech) {
  final ProviderContainer c = ProviderContainer(
    overrides: <Override>[speechInputProvider.overrideWithValue(speech)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('the controller', () {
    test('availability is asked once, not per keystroke', () async {
      // `initialize()` is what raises the permission prompt on both
      // platforms, so asking repeatedly re-prompts.
      final _Speech speech = _Speech();
      final ProviderContainer c = _container(speech);
      final Dictation d = c.read(dictationProvider.notifier);

      await d.checkAvailability();
      await d.checkAvailability();
      await d.checkAvailability();

      expect(speech.availabilityChecks, 1);
      expect(c.read(dictationProvider).available, isTrue);
    });

    test('starting a second field stops the first', () async {
      final _Speech speech = _Speech();
      final ProviderContainer c = _container(speech);
      final Dictation d = c.read(dictationProvider.notifier);

      await d.start('a');
      expect(c.read(dictationProvider).listeningFor('a'), isTrue);

      await d.start('b');
      expect(speech.stops, 1);
      expect(c.read(dictationProvider).listeningFor('a'), isFalse);
      expect(c.read(dictationProvider).listeningFor('b'), isTrue);
    });

    test('a late event from the replaced dictation is ignored', () async {
      // The OS does not stop mid-callback. Without the guard the first
      // field's trailing words land in the second field's box.
      final _Speech speech = _Speech();
      final ProviderContainer c = _container(speech);
      final Dictation d = c.read(dictationProvider.notifier);

      await d.start('a');
      final void Function(SpeechEvent) stale = speech._listener!;
      await d.start('b');

      stale(const SpeechHeard('words from the old field', isFinal: true));

      expect(c.read(dictationProvider).heard, isEmpty);
      expect(c.read(dictationProvider).listeningFor('b'), isTrue);
    });

    test('a failure stops listening and says why', () async {
      final _Speech speech = _Speech();
      final ProviderContainer c = _container(speech);
      final Dictation d = c.read(dictationProvider.notifier);

      await d.start('a');
      speech.fail('The microphone is busy in another app.');

      final DictationState state = c.read(dictationProvider);
      expect(state.isListening, isFalse);
      expect(state.error, 'The microphone is busy in another app.');
    });

    test('abandon only acts for the field that holds the microphone', () async {
      final _Speech speech = _Speech();
      final ProviderContainer c = _container(speech);
      final Dictation d = c.read(dictationProvider.notifier);

      await d.start('a');
      await d.abandon('b');
      expect(speech.cancels, 0);
      expect(c.read(dictationProvider).listeningFor('a'), isTrue);

      await d.abandon('a');
      expect(speech.cancels, 1);
      expect(c.read(dictationProvider).isListening, isFalse);
    });
  });

  group('the button', () {
    Future<TextEditingController> pump(
      WidgetTester tester,
      _Speech speech, {
      String initial = '',
    }) async {
      final TextEditingController controller = TextEditingController(
        text: initial,
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[speechInputProvider.overrideWithValue(speech)],
          child: MaterialApp(
            home: Scaffold(
              body: ZaveDictateButton(
                controller: controller,
                fieldId: 'field',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return controller;
    }

    testWidgets('a device that cannot dictate shows no microphone', (
      WidgetTester tester,
    ) async {
      // Offering a control that cannot work and explaining afterwards is
      // worse than not offering one — the keyboard is still there.
      await pump(tester, _Speech(available: false));
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('words append to what is already typed', (
      WidgetTester tester,
    ) async {
      final _Speech speech = _Speech();
      final TextEditingController controller = await pump(
        tester,
        speech,
        initial: 'Nobody had read the runbook.',
      );

      await tester.tap(find.byType(Icon));
      await tester.pump();
      speech.hear('We found out at 2am');
      await tester.pump();

      expect(
        controller.text,
        'Nobody had read the runbook. We found out at 2am',
      );
    });

    testWidgets('a firming guess replaces the tail, it does not stutter', (
      WidgetTester tester,
    ) async {
      // Both platforms re-send the WHOLE utterance as it firms up. Appending
      // each callback would write the sentence out three times over.
      final _Speech speech = _Speech();
      final TextEditingController controller = await pump(
        tester,
        speech,
        initial: 'Start.',
      );

      await tester.tap(find.byType(Icon));
      await tester.pump();
      speech.hear('we deleted');
      await tester.pump();
      speech.hear('we deleted six');
      await tester.pump();
      speech.hear('we deleted six screens', isFinal: true);
      await tester.pump();

      expect(controller.text, 'Start. we deleted six screens');
    });

    testWidgets('leaving the screen cancels rather than keeps', (
      WidgetTester tester,
    ) async {
      final _Speech speech = _Speech();
      await pump(tester, speech);

      await tester.tap(find.byType(Icon));
      await tester.pump();
      expect(speech.starts, 1);

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      // Cancel, not stop: the box those words were going into is gone.
      expect(speech.cancels, 1);
    });
  });
}
