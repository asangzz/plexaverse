import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/plan/plan_limit_sheet.dart';
import 'package:plexaverse/core/plan/plan_refusal.dart';

/// The sheet every AI feature opens when the plan says no. The two states
/// want opposite remedies, and neither may ever say "XP".
void main() {
  Future<GoRouter> pump(WidgetTester tester, PlanRefusal refusal) async {
    tester.view.physicalSize = const Size(402, 874) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: Builder(
              builder: (BuildContext context) => TextButton(
                onPressed: () => PlanLimitSheet.show(context, refusal),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/pricing',
          builder: (_, _) => const Scaffold(body: Text('PRICING')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return router;
  }

  List<String> allText(WidgetTester tester) => <String>[
    for (final Text t in tester.widgetList<Text>(find.byType(Text)))
      t.data ?? t.textSpan?.toPlainText() ?? '',
  ];

  testWidgets('needs a plan: the message and a way to pricing', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const PlanRefusal(
        kind: PlanRefusalKind.needsPlan,
        message: 'Posts need a Plexaverse plan.',
      ),
    );
    expect(find.text('Needs a plan'), findsOneWidget);
    expect(find.text('Posts need a Plexaverse plan.'), findsOneWidget);
    for (final String line in allText(tester)) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
    }

    await tester.tap(find.text('See plans'));
    await tester.pumpAndSettle();
    expect(find.text('PRICING'), findsOneWidget);
  });

  testWidgets('limit reached: when it comes back, and no sales pitch', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      PlanRefusal(
        kind: PlanRefusalKind.limitReached,
        message: "You've used today's posts.",
        period: 'day',
        resetsAt: DateTime.now().add(const Duration(days: 3)).toUtc(),
      ),
    );
    expect(find.text('Limit reached'), findsOneWidget);
    expect(find.text("You've used today's posts."), findsOneWidget);
    expect(find.textContaining('Back on'), findsOneWidget);
    expect(find.text('See plans'), findsNothing);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Limit reached'), findsNothing);
  });
}
