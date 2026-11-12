import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/presentation/widgets/plexa_moment.dart';
import 'package:video_player/video_player.dart';

/// PlexaMoment: the still wherever the clip will not play, and a box that
/// keeps the frame's shape at every size a screen asks for.
///
/// A test has no video plugin, so a moment with animations on goes through
/// the same path as a clip that fails to load on a phone — which is the path
/// that must never leave an empty box.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    bool reduceMotion = true,
    double screenWidth = 375,
  }) {
    tester.view.physicalSize = Size(screenWidth, 667) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: Size(screenWidth, 667),
          disableAnimations: reduceMotion,
        ),
        child: MaterialApp(
          home: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  Finder still(PlexaMomentClip clip) => find.byWidgetPredicate(
    (Widget w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == clip.still,
  );

  testWidgets('reduced motion shows the still and starts no player', (
    WidgetTester tester,
  ) async {
    await pump(tester, const PlexaMoment(PlexaMomentClip.quizScore));
    await tester.pump();

    expect(still(PlexaMomentClip.quizScore), findsOneWidget);
    expect(find.byType(VideoPlayer), findsNothing);
  });

  testWidgets('a looping wait shows its still under reduced motion too', (
    WidgetTester tester,
  ) async {
    await pump(tester, const PlexaMoment(PlexaMomentClip.thinking, width: 160));
    await tester.pump();

    expect(still(PlexaMomentClip.thinking), findsOneWidget);
  });

  testWidgets('a clip that cannot play falls back to its still', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const PlexaMoment(PlexaMomentClip.oopsWrench, width: 120),
      reduceMotion: false,
    );
    await tester.pump();
    await tester.pump();

    expect(still(PlexaMomentClip.oopsWrench), findsOneWidget);
    expect(find.byType(VideoPlayer), findsNothing);
  });

  testWidgets('a new moment in the same spot shows the new one', (
    WidgetTester tester,
  ) async {
    await pump(tester, const PlexaMoment(PlexaMomentClip.contestJoined));
    await tester.pump();
    expect(still(PlexaMomentClip.contestJoined), findsOneWidget);

    await pump(tester, const PlexaMoment(PlexaMomentClip.streakFlame));
    await tester.pump();
    expect(still(PlexaMomentClip.contestJoined), findsNothing);
    expect(still(PlexaMomentClip.streakFlame), findsOneWidget);
  });

  for (final double width in <double>[120, 140, 160, 180, 200, 220]) {
    testWidgets('at $width px: the 568×432 box, and no overflow', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PlexaMoment(PlexaMomentClip.waitingRoom, width: width),
            // Beside copy, as on the contest screens: the words wrap, the
            // moment keeps its size.
            const Flexible(child: Text('No contest right now')),
          ],
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      final Size size = tester.getSize(find.byType(PlexaMoment));
      expect(size.width, width);
      expect(size.height, closeTo(width * 432 / 568, 0.01));
    });
  }

  testWidgets(
    'a parent narrower than the width shrinks it, keeping the shape',
    (WidgetTester tester) async {
      await pump(
        tester,
        const SizedBox(
          width: 100,
          child: PlexaMoment(PlexaMomentClip.placementResult, width: 160),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      final Size size = tester.getSize(find.byType(PlexaMoment));
      expect(size.width, 100);
      expect(size.height, closeTo(100 * 432 / 568, 0.01));
    },
  );

  testWidgets('it is decoration: nothing for a screen reader', (
    WidgetTester tester,
  ) async {
    await pump(tester, const PlexaMoment(PlexaMomentClip.contestFinale));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(PlexaMoment),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
  });
}
