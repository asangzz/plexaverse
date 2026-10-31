import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/platform/speech_input.dart';
import 'package:plexaverse/core/ui/zave/zave_dictate_button.dart';

/// The labelled form of the dictate button, and the focus it takes.
///
/// The bare-icon form is covered by `test/core/platform/dictation_test.dart`;
/// what is pinned here is what the quiz needed on top of it — a label, and a
/// caret that lands in the box the words are going into. Mirrors the web's
/// `SayItInstead`, which focuses its textarea for the same reason.
class _Speech implements SpeechInputService {
  _Speech({this.available = true});

  bool available;
  int starts = 0;
  void Function(SpeechEvent)? _listener;

  void hear(String text) => _listener?.call(SpeechHeard(text, isFinal: true));

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> start({
    required void Function(SpeechEvent) onEvent,
    String? localeId,
  }) async {
    starts++;
    _listener = onEvent;
  }

  @override
  Future<void> stop() async => _listener?.call(const SpeechStopped());

  @override
  Future<void> cancel() async {}
}

void main() {
  late _Speech speech;
  late TextEditingController controller;
  late FocusNode node;

  Future<void> pump(
    WidgetTester tester, {
    String? label = 'Say it instead',
    bool canSpeak = true,
    String initial = '',
    bool withFocusNode = true,
  }) async {
    speech = _Speech(available: canSpeak);
    controller = TextEditingController(text: initial);
    node = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(node.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[speechInputProvider.overrideWithValue(speech)],
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                TextField(controller: controller, focusNode: node),
                ZaveDictateButton(
                  controller: controller,
                  fieldId: 'learn.compose',
                  label: label,
                  focusNode: withFocusNode ? node : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Taps the control and drains the keep-visible timer it arms. Without the
  /// second pump the test ends holding a pending timer, which is a failure.
  Future<void> tapSpeak(WidgetTester tester, {String label = 'Say it instead'}) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('the labelled form says what it does', (
    WidgetTester tester,
  ) async {
    // A bare microphone is enough in the composer, where the box is the whole
    // screen. In the quiz it is one of several things being asked, and an
    // unlabelled glyph reads as decoration.
    await pump(tester);
    expect(find.text('Say it instead'), findsOneWidget);
  });

  testWidgets('without a label it is still just the microphone', (
    WidgetTester tester,
  ) async {
    await pump(tester, label: null);
    expect(find.text('Say it instead'), findsNothing);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('tapping it puts the caret in the box', (
    WidgetTester tester,
  ) async {
    // So the words land where the user is already looking, and editing them
    // afterwards is one tap rather than two.
    await pump(tester);
    expect(node.hasFocus, isFalse);

    await tapSpeak(tester);

    expect(node.hasFocus, isTrue);
    expect(speech.starts, 1);
  });

  testWidgets('it still works for a caller that gives no node', (
    WidgetTester tester,
  ) async {
    // The composer passes none — its field is already focused by the time
    // anyone reaches for the microphone.
    await pump(tester, withFocusNode: false);
    await tapSpeak(tester);
    expect(speech.starts, 1);
  });

  testWidgets('it reads Stop while listening', (WidgetTester tester) async {
    await pump(tester);
    await tapSpeak(tester);

    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Say it instead'), findsNothing);
  });

  testWidgets('words append to what is already typed', (
    WidgetTester tester,
  ) async {
    await pump(tester, initial: 'Nobody had read the runbook.');
    await tapSpeak(tester);
    speech.hear('We found out at 2am');
    await tester.pump();

    expect(controller.text, 'Nobody had read the runbook. We found out at 2am');
  });

  testWidgets('a firming guess replaces the tail, it does not stutter', (
    WidgetTester tester,
  ) async {
    // Both platforms re-send the WHOLE utterance as it firms up. Appending
    // each callback would write the sentence out three times over.
    await pump(tester, initial: 'Start.');
    await tapSpeak(tester);
    speech.hear('we deleted');
    await tester.pump();
    speech.hear('we deleted six screens');
    await tester.pump();

    expect(controller.text, 'Start. we deleted six screens');
  });

  testWidgets('a device that cannot dictate shows nothing', (
    WidgetTester tester,
  ) async {
    await pump(tester, canSpeak: false);
    expect(find.text('Say it instead'), findsNothing);
  });
}
