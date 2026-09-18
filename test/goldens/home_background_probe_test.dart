import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/skin/home_background.dart';

/// Regression golden for [HomeBackgroundPainter] (fitted against reference
/// screenshot 2353: mean |ΔRGB| ≈ 10.9 over 38 sampled points). Pure
/// gradient math — platform-stable. If the painter constants are ever
/// re-fitted intentionally, refresh with --update-goldens.
void main() {
  testWidgets('render home background golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 916));
    tester.view.physicalSize = const Size(412, 916);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 412,
          height: 916,
          child: CustomPaint(
            painter: HomeBackgroundPainter(),
            size: Size(412, 916),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(CustomPaint).first,
      matchesGoldenFile('home_background.png'),
    );
  });
}
