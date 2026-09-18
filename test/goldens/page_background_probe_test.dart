import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/ui/skin/page_background.dart';

/// Regression golden for [SkinPageBackground] (diagonal navy→black gradient
/// shared by the Videos / Avatars / Account screens, fitted against
/// reference screenshots 2354 / 2374). Pure gradient math — platform-stable.
/// Refresh with --update-goldens only after an intentional re-fit.
void main() {
  testWidgets('render page background golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(412, 916));
    tester.view.physicalSize = const Size(412, 916);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 412,
          height: 916,
          child: SkinPageBackground(),
        ),
      ),
    );

    await expectLater(
      find.byType(SkinPageBackground),
      matchesGoldenFile('page_background.png'),
    );
  });
}
