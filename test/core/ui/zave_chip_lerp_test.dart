import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';

/// Switching a chip must not throw mid-animation.
///
/// ## The bug
///
/// `ZaveChip` was one `AnimatedContainer` whose `decoration` swapped between
/// `ZaveSurface.chip` — which carries a [ZaveEdgeBorder] — and
/// `ZaveSurface.chipSelected`, which has no border at all. Animating that
/// calls `BoxBorder.lerp(ZaveEdgeBorder(), null)`, and `BoxBorder.lerp` is a
/// STATIC with hardcoded `is Border?` / `is BorderDirectional?` checks. It
/// cannot interpolate a custom `BoxBorder` subclass, so it threw:
///
///   BoxBorder.lerp can only interpolate Border and BorderDirectional classes.
///   BoxBorder.lerp() was called with two objects of type Null and
///   ZaveEdgeBorder
///
/// Every tap on a chip therefore rendered Flutter's red error box where the
/// chip should be, for the length of the transition. On the Persona screen,
/// where the two chips ARE the tab control, switching tabs flashed red every
/// single time. It was reported as "a render issue for a fraction of a
/// second", which is exactly what it looked like.
///
/// ## Why a test and not just a fix
///
/// The exception is thrown during a FRAME IN BETWEEN the two settled states.
/// Pumping to completion — which is what a widget test does by default —
/// steps clean over it: both end states render perfectly, and did throughout.
/// Only a pump that lands mid-transition sees it, which is why this sat in a
/// kit widget used on a dozen screens without a single test noticing.
///
/// The same trap is set for anything in this kit that animates between a
/// bordered and an unbordered Zave surface.
void main() {
  Widget host({required bool selected}) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: ZaveChip(label: 'Your Persona', selected: selected),
      ),
    ),
  );

  testWidgets('selecting does not throw part-way through the transition', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(host(selected: false));
    await tester.pumpAndSettle();

    await tester.pumpWidget(host(selected: true));

    // Land INSIDE the animation, repeatedly. The old implementation threw on
    // the first of these; pumping straight to settled would have missed it.
    for (int ms = 10; ms < ZaveMotion.fast.inMilliseconds + 20; ms += 10) {
      await tester.pump(const Duration(milliseconds: 10));
      expect(
        tester.takeException(),
        isNull,
        reason: 'threw ${ms}ms into the selection transition',
      );
    }

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('deselecting does not throw either', (WidgetTester tester) async {
    // The reverse lerp — null → ZaveEdgeBorder — is the other half of the same
    // fault, and the Persona tabs do both on every switch.
    await tester.pumpWidget(host(selected: true));
    await tester.pumpAndSettle();

    await tester.pumpWidget(host(selected: false));
    for (int i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 10));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('both settled states still render the chip', (
    WidgetTester tester,
  ) async {
    // Guards the fix rather than the bug: a cross-fade that renders nothing,
    // or renders only one layer, would pass the tests above trivially.
    for (final bool selected in <bool>[false, true]) {
      await tester.pumpWidget(host(selected: selected));
      await tester.pumpAndSettle();

      expect(find.text('Your Persona'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // Both surfaces are present at all times; only their opacity moves.
      expect(find.byType(DecoratedBox), findsAtLeast(2));
    }
  });

  testWidgets('a rapid double switch does not throw', (
    WidgetTester tester,
  ) async {
    // What a user actually does to a tab control: taps the other one before
    // the first transition has finished.
    await tester.pumpWidget(host(selected: false));
    await tester.pumpAndSettle();

    await tester.pumpWidget(host(selected: true));
    await tester.pump(const Duration(milliseconds: 40));
    await tester.pumpWidget(host(selected: false));
    await tester.pump(const Duration(milliseconds: 40));
    await tester.pumpWidget(host(selected: true));

    for (int i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 10));
      expect(tester.takeException(), isNull);
    }
  });

  group('ZaveCard survives a press', () {
    // The chip was not the only one. `ZaveCard` built `border:
    // ZaveEdgeBorder(...)` straight into an AnimatedContainer, so pressing any
    // tappable card lerped a ZaveEdgeBorder into another ZaveEdgeBorder — and
    // `BoxBorder.lerp` rejects that exactly as hard as it rejects null, since
    // neither operand is a `Border`. Measured: it threw 15ms into the press,
    // on every tappable card in the app.
    testWidgets('pressing does not throw', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ZaveCard(onTap: () {}, child: const Text('tap me')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final TestGesture press = await tester.startGesture(
        tester.getCenter(find.text('tap me')),
      );
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 15));
        expect(
          tester.takeException(),
          isNull,
          reason: 'threw ${i * 15}ms into the press',
        );
      }

      await press.up();
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 15));
        expect(
          tester.takeException(),
          isNull,
          reason: 'threw ${i * 15}ms into the release',
        );
      }
    });

    testWidgets('a `now` card renders and does not throw', (
      WidgetTester tester,
    ) async {
      // `isNow` short-circuits the lerp to its own tokens. Guards that the
      // branch still builds rather than being quietly unreachable.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ZaveCard(isNow: true, child: Text('today'))),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('today'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a card with no onTap still renders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ZaveCard(child: Text('static'))),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('static'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
