import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/plan/plan_refusal.dart';
import 'package:plexaverse/features/engagement/domain/engagement_repository.dart';
import 'package:plexaverse/features/engagement/presentation/widgets/engagement_states.dart';

/// The habit screens' refusal card. A missing plan and a used-up limit want
/// different remedies, and wallet XP — the old remedy for both — is gone.
void main() {
  Future<void> pump(WidgetTester tester, EngagementFailure failure) async {
    tester.view.physicalSize = const Size(402, 874) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EngagementBlocked(
            failure: failure,
            onRetry: () {},
            onSeePlans: () {},
            onCompleteProfile: () {},
          ),
        ),
      ),
    );
  }

  List<String> allText(WidgetTester tester) => <String>[
    for (final Text t in tester.widgetList<Text>(find.byType(Text)))
      t.data ?? t.textSpan?.toPlainText() ?? '',
  ];

  testWidgets('no plan offers the plans, never XP', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const EngagementFailure(
        EngagementBlock.needsPlan,
        refusal: PlanRefusal(
          kind: PlanRefusalKind.needsPlan,
          message: 'Daily comments need a Plexaverse plan.',
        ),
      ),
    );
    expect(find.text('NEEDS A PLAN'), findsOneWidget);
    expect(find.text('Daily comments need a Plexaverse plan.'), findsOneWidget);
    expect(find.text('See plans'), findsOneWidget);
    for (final String line in allText(tester)) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
    }
  });

  testWidgets('a limit says when it is back and offers no retry', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      EngagementFailure(
        EngagementBlock.limitReached,
        refusal: PlanRefusal(
          kind: PlanRefusalKind.limitReached,
          message: "You've used today's comments.",
          resetsAt: DateTime.now().add(const Duration(days: 3)).toUtc(),
        ),
      ),
    );
    expect(find.text('LIMIT REACHED'), findsOneWidget);
    expect(find.textContaining('Back on'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
    expect(find.text('See plans'), findsNothing);
  });
}
