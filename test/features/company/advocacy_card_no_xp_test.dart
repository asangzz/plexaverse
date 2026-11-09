import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/company/domain/advocacy_post.dart';
import 'package:plexaverse/features/company/presentation/widgets/advocacy_card.dart';

/// Wallet XP is retired (10 Nov 2026): a reshare earns nothing, so the card
/// must not promise "Earn 50 XP". The web's `no-wallet-xp` test pins the same
/// rule server side; this pins the copy the app shows.
void main() {
  const AdvocacyPost post = AdvocacyPost(
    id: 'p1',
    content: 'We shipped the new planner.',
    linkedinPostId: 'urn:li:share:1',
  );

  Future<void> pump(WidgetTester tester, {required bool reshared}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AdvocacyCard(
                post: post,
                resharing: false,
                reshared: reshared,
                onReshare: () {},
              ),
            ),
          ),
        ),
      );

  testWidgets('the reshare button offers no XP', (WidgetTester tester) async {
    await pump(tester, reshared: false);
    expect(find.text('Reshare to my feed'), findsOneWidget);
    expect(find.textContaining('XP'), findsNothing);
  });

  testWidgets('a shared post says so, still without XP', (
    WidgetTester tester,
  ) async {
    await pump(tester, reshared: true);
    expect(find.text('Successfully Shared'), findsOneWidget);
    expect(find.textContaining('XP'), findsNothing);
  });
}
