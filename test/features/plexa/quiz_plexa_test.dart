import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/quiz_plexa.dart';
import 'package:video_player/video_player.dart';

/// QuizPlexa plays the lesson as one take. The rules live on [QuizTake] so
/// they can be held to here, where there is no video plugin; the widget
/// tests below cover the stills, which is all a test can show.
void main() {
  group('QuizTake', () {
    QuizCue? ask(
      QuizTake take,
      String id,
      QuizMood mood, {
      bool react = false,
      bool stillsOnly = false,
    }) => take.request(
      take: id,
      mood: mood,
      react: react,
      stillsOnly: stillsOnly,
    );

    test('a question opens with inspect', () {
      final QuizTake take = QuizTake();
      expect(
        ask(take, 'q1', QuizMood.inspect),
        const PlayCue(QuizMood.inspect),
      );
      expect(take.wanted, QuizMood.inspect);
    });

    test('the same request again (a rebuild) restarts nothing', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      expect(ask(take, 'q1', QuizMood.inspect), isNull);
    });

    test('an answer during the zoom waits for it: never cut short', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);

      expect(ask(take, 'q1', QuizMood.correct), isNull);
      expect(take.queued, <QuizMood>[QuizMood.correct]);
      expect(take.wanted, QuizMood.inspect);

      expect(take.ended(QuizMood.inspect), const PlayCue(QuizMood.correct));
      expect(take.wanted, QuizMood.correct);
      expect(take.queued, isEmpty);
    });

    test('an answer after the zoom ended plays at once', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      expect(take.ended(QuizMood.inspect), isNull);

      expect(ask(take, 'q1', QuizMood.wrong), const PlayCue(QuizMood.wrong));
    });

    test('the next question waits for the reaction, then inspects', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      take.ended(QuizMood.inspect);
      ask(take, 'q1', QuizMood.correct);

      expect(ask(take, 'q2', QuizMood.inspect), isNull);
      expect(take.queued, <QuizMood>[QuizMood.inspect]);
      expect(take.ended(QuizMood.correct), const PlayCue(QuizMood.inspect));
    });

    test(
      'at most [inspect, reaction] waits, and only the current question',
      () {
        final QuizTake take = QuizTake();
        ask(take, 'q1', QuizMood.inspect);
        take.ended(QuizMood.inspect);
        ask(take, 'q1', QuizMood.correct); // plays: 8 s of thumbs-up

        // A learner racing ahead: q2 opened and answered, then q3 opened.
        ask(take, 'q2', QuizMood.inspect);
        ask(take, 'q2', QuizMood.wrong);
        expect(take.queued, <QuizMood>[QuizMood.inspect, QuizMood.wrong]);
        ask(take, 'q3', QuizMood.inspect);
        expect(take.queued, <QuizMood>[QuizMood.inspect]);

        // q3 answered: its reaction joins q3's inspect.
        ask(take, 'q3', QuizMood.correct);
        expect(take.queued, <QuizMood>[QuizMood.inspect, QuizMood.correct]);
      },
    );

    test('a later reaction replaces the one waiting', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      ask(take, 'q1', QuizMood.wrong);
      ask(take, 'q1', QuizMood.correct);
      expect(take.queued, <QuizMood>[QuizMood.correct]);
    });

    test('a take that arrives answered shows the still, not the reaction', () {
      final QuizTake take = QuizTake();
      // Reopened from the score: she never looked this one over.
      expect(
        ask(take, 'q4', QuizMood.correct),
        const StillCue(QuizMood.correct),
      );
      expect(take.wanted, isNull);
    });

    test('react plays the reaction anyway (the score screen)', () {
      final QuizTake take = QuizTake();
      expect(
        ask(take, 'score', QuizMood.correct, react: true),
        const PlayCue(QuizMood.correct),
      );
    });

    test('reduced motion shows stills and drops what waited', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      ask(take, 'q1', QuizMood.correct);

      expect(
        ask(take, 'q1', QuizMood.correct, stillsOnly: true),
        const StillCue(QuizMood.correct),
      );
      expect(take.queued, isEmpty);
      expect(take.wanted, isNull);
    });

    test('a clip that cannot play stands in with its still', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      ask(take, 'q1', QuizMood.correct);

      expect(take.failed(QuizMood.inspect), const StillCue(QuizMood.inspect));
      expect(take.queued, isEmpty);
      // One that was not asked for changes nothing.
      expect(take.failed(QuizMood.wrong), isNull);
    });

    test('the end of a clip no longer asked for changes nothing', () {
      final QuizTake take = QuizTake();
      ask(take, 'q1', QuizMood.inspect);
      take.ended(QuizMood.inspect);
      ask(take, 'q1', QuizMood.correct);

      expect(take.ended(QuizMood.inspect), isNull);
      expect(take.wanted, QuizMood.correct);
    });
  });

  group('the widget', () {
    Future<void> pump(
      WidgetTester tester,
      Widget child, {
      bool reduceMotion = true,
    }) => tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: const Size(375, 667),
          disableAnimations: reduceMotion,
        ),
        child: MaterialApp(
          home: Scaffold(body: Center(child: child)),
        ),
      ),
    );

    Finder still(QuizMood mood) => find.byWidgetPredicate(
      (Widget w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == mood.still,
    );

    testWidgets('reduced motion shows the mood\'s still, no player', (
      WidgetTester tester,
    ) async {
      await pump(tester, const QuizPlexa(take: 'q1', mood: QuizMood.inspect));
      await tester.pump();
      expect(still(QuizMood.inspect), findsOneWidget);
      expect(find.byType(VideoPlayer), findsNothing);

      await pump(tester, const QuizPlexa(take: 'q1', mood: QuizMood.correct));
      await tester.pump();
      expect(still(QuizMood.correct), findsOneWidget);
    });

    testWidgets('clips that cannot play fall back to the mood\'s still', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        const QuizPlexa(take: 'q1', mood: QuizMood.inspect),
        reduceMotion: false,
      );
      await tester.pump();
      await tester.pump();
      expect(still(QuizMood.inspect), findsOneWidget);
    });

    testWidgets('the box follows the 520×432 frame from its height', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        const QuizPlexa(take: 'q1', mood: QuizMood.inspect, height: 112),
      );
      await tester.pump();
      final Size size = tester.getSize(find.byType(QuizPlexa));
      expect(size.height, 112);
      expect(size.width, closeTo(112 * 520 / 432, 0.01));
    });

    testWidgets('QuizPlexaStill is the inspect picture, never a player', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        const QuizPlexaStill(QuizMood.inspect),
        reduceMotion: false,
      );
      await tester.pump();
      expect(still(QuizMood.inspect), findsOneWidget);
      expect(find.byType(VideoPlayer), findsNothing);
      expect(tester.getSize(find.byType(QuizPlexaStill)).height, 118);
    });
  });
}
