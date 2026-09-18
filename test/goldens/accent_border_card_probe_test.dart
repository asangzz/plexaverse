import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/skin/accent_border_card.dart';

/// Regression coverage for [AccentBorderCard]: confirms the border/shadow
/// treatment matches the corrected spec — a hairline border (no outer
/// glow/halo bleeding past the card edge) plus a matching-color inner
/// shadow, for both the flat-color variant (Translate/Video-tools) and the
/// gradient variant (Make video).
///
/// Wrapped in an explicit [RepaintBoundary] + [Key], located via that key —
/// a bare sized widget passed as `MaterialApp.home` gets stretched to the
/// full route size (its constraints are enforced into the ambient
/// full-screen tight constraints), silently discarding the requested size.
void main() {
  const key = Key('accent-border-probe');

  Future<void> pumpCard(WidgetTester tester, Widget card) => tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox(width: 140, height: 122, child: card),
        ),
      ),
    ),
  );

  testWidgets('flat-color accent (Translate/Video-tools style)', (
    tester,
  ) async {
    await pumpCard(
      tester,
      const AccentBorderCard(
        color: Color(0xFF85E8A1),
        borderWidth: 0.6,
        child: ColoredBox(color: Color(0xFF181818)),
      ),
    );

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('accent_border_flat.png'),
    );
  });

  testWidgets('gradient accent (Make video style)', (tester) async {
    await pumpCard(
      tester,
      const AccentBorderCard(
        gradientColors: [Color(0xFF3FC0E7), Color(0xFF149CC5)],
        borderWidth: 1.0,
        child: ColoredBox(color: Color(0xFFDA9668)),
      ),
    );

    await expectLater(
      find.byKey(key),
      matchesGoldenFile('accent_border_gradient.png'),
    );
  });

  test('flat and gradient are mutually exclusive', () {
    expect(
      () => AccentBorderCard(
        color: const Color(0xFF85E8A1),
        gradientColors: const [Color(0xFF3FC0E7), Color(0xFF149CC5)],
        child: const SizedBox(),
      ),
      throwsAssertionError,
    );
    expect(
      () => AccentBorderCard(child: const SizedBox()),
      throwsAssertionError,
    );
  });
}
