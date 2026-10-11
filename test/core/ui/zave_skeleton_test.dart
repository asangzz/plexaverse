import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

/// The shimmer runs, stops when the system says to stop, and cleans up.
///
/// ## Why Reduce Motion is a test and not a comment
///
/// Because the sweep is the app's third infinite animation and the only one
/// a user is guaranteed to meet — every screen has a loading state. An
/// accessibility setting that a component silently ignores is worse than one
/// it never offered: the user turned it on and was told it was honoured.
///
/// The other two long-running animations in the system (the 42s ambient spin
/// and the thinking dots) each honour it too.
void main() {
  Widget host({required bool reduceMotion, bool enabled = true}) => MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ZaveShimmer(
        enabled: enabled,
        child: const Column(
          children: <Widget>[
            ZaveSkeleton.bar(),
            ZaveSkeleton.bar(widthFactor: 0.6),
            ZaveSkeleton.circle(),
          ],
        ),
      ),
    ),
  );

  testWidgets('sweeps by default', (WidgetTester tester) async {
    await tester.pumpWidget(host(reduceMotion: false));

    // A ShaderMask is the sweep. Its absence is the whole bug this guards.
    expect(find.byType(ShaderMask), findsOneWidget);

    // One for the group, not one per shape — three skeletons, one mask.
    // Five independent sweeps at five phases read as five unrelated things.
    expect(find.byType(ZaveSkeleton), findsNWidgets(3));
    expect(find.byType(ShaderMask), findsOneWidget);
  });

  testWidgets('Reduce Motion removes the sweep, not the skeleton', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(reduceMotion: true));

    expect(
      find.byType(ShaderMask),
      findsNothing,
      reason: 'the sweep must stop entirely under Reduce Motion',
    );
    expect(
      find.byType(ZaveSkeleton),
      findsNWidgets(3),
      reason:
          'the shapes still have to render — a skeleton communicates '
          'without the sweep, so there is nothing to degrade to',
    );
  });

  testWidgets('enabled: false freezes it without unwrapping', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(reduceMotion: false, enabled: false));
    expect(find.byType(ShaderMask), findsNothing);
    expect(find.byType(ZaveSkeleton), findsNWidgets(3));
  });

  testWidgets('a skeleton with no shimmer above it still renders', (
    WidgetTester tester,
  ) async {
    // The honest fallback. A caller that forgets the wrapper gets the dim
    // fills this app used everywhere before the sweep existed, not a crash
    // and not an empty box.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: ZaveSkeleton.bar(),
      ),
    );
    expect(find.byType(ZaveSkeleton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the controller is disposed with the widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(reduceMotion: false));
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox.shrink(),
      ),
    );
    // A leaked AnimationController throws on the next frame once its State
    // is gone; an undisposed ticker fails the test binding outright.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('switching Reduce Motion on mid-flight stops the sweep', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(reduceMotion: false));
    expect(find.byType(ShaderMask), findsOneWidget);

    // The setting can change while a request is still in flight, and
    // didChangeDependencies is the only place that would notice.
    await tester.pumpWidget(host(reduceMotion: true));
    expect(find.byType(ShaderMask), findsNothing);
  });
}
