import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/onboarding/domain/chat_message.dart';
import 'package:plexaverse/features/onboarding/presentation/widgets/chat_lane.dart';

/// Plexa's avatar beside her messages is optional.
///
/// `/plexa` runs the onboarding chat under the mascot, who is already on
/// screen — a second Plexa beside every message is what it switches off.
/// `/onboarding` passes nothing and must keep the avatar, so the default is
/// pinned as hard as the option. The web pins the same pair in
/// `__tests__/components/chat-bot-avatar.test.tsx`.
void main() {
  const ChatMessage bot = ChatMessage(
    id: 'b1',
    role: ChatRole.bot,
    text: 'Personal brand, or a company page?',
  );

  Future<void> pump(WidgetTester tester, Widget row) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: row)),
    ),
  );

  testWidgets('is drawn by default on a message that starts a run', (
    WidgetTester tester,
  ) async {
    await pump(tester, const ChatMessageRow(message: bot, grouped: false));
    expect(find.byType(PlexaAvatar), findsOneWidget);
  });

  testWidgets('is drawn by default on the typing row', (
    WidgetTester tester,
  ) async {
    await pump(tester, const TypingRow(grouped: false));
    expect(find.byType(PlexaAvatar), findsOneWidget);
  });

  testWidgets('can be left off a message, along with its spacer', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      const ChatMessageRow(message: bot, grouped: true, showBotAvatar: false),
    );
    expect(find.byType(PlexaAvatar), findsNothing);
    expect(find.text(bot.text), findsOneWidget);
    // The bubble starts at the lane's edge: no avatar-wide gap in front of it.
    final double rowLeft = tester.getTopLeft(find.byType(Row).first).dx;
    final double bubbleLeft = tester.getTopLeft(find.text(bot.text)).dx;
    expect(bubbleLeft - rowLeft, lessThan(ChatLaneMetrics.avatar));
  });

  testWidgets('can be left off the typing row', (WidgetTester tester) async {
    await pump(tester, const TypingRow(grouped: false, showBotAvatar: false));
    expect(find.byType(PlexaAvatar), findsNothing);
  });
}
