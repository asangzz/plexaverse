import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/features/pricing/presentation/pages/pricing_page.dart';

/// The Pricing screen on the mock backend, read for what it SAYS: a plan is
/// described by what it includes, the referral promises the referrer a month,
/// and wallet XP appears nowhere.
void main() {
  Future<void> pump(WidgetTester tester, Widget page) async {
    // Tall enough that the lazily built scroll view builds every block — the
    // assertions read the whole screen, not the first fold.
    tester.view.physicalSize = const Size(402, 8000) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final GoRouter router = GoRouter(
      routes: <RouteBase>[GoRoute(path: '/', builder: (_, _) => page)],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [envProvider.overrideWithValue(Env.mock)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    // The fakes answer after a delay; step past it rather than settle, in
    // case anything on the page loops.
    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  /// Every string on screen, scrolled or not.
  List<String> allText(WidgetTester tester) => <String>[
    for (final Text t in tester.widgetList<Text>(
      find.byType(Text, skipOffstage: false),
    ))
      t.data ?? t.textSpan?.toPlainText() ?? '',
  ];

  testWidgets('Pricing lists what a plan includes and never says XP', (
    WidgetTester tester,
  ) async {
    await pump(tester, const PricingPage());

    final List<String> text = allText(tester);
    expect(text, contains('WHAT EVERY PLAN INCLUDES'));
    expect(text, contains('Posts'));
    expect(text, contains('Carousels'));
    expect(text, contains('4 a month'));
    // The mock has one post used today.
    expect(text, contains('2 left today'));
    expect(
      text,
      contains('Get a month free when a friend you refer subscribes'),
    );
    expect(text, contains('Roadmap, lessons and calendar'));

    for (final String line in text) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
      expect(line.toLowerCase().contains('top up'), isFalse, reason: line);
    }
  });
}
