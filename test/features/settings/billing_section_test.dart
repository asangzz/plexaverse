import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';
import 'package:plexaverse/features/settings/presentation/widgets/billing_section.dart';

/// The Settings plan section: plan status only. Wallet XP was retired on
/// 10 Nov 2026, so there is no balance, no "top up", and no "XP" anywhere.
void main() {
  Future<List<String>> pump(
    WidgetTester tester,
    SubscriptionState subscription,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountSnapshotProvider.overrideWith(
            (Ref ref) async => AccountSnapshot(
              user: const AccountIdentity(id: 'u1', name: 'A', email: 'a@b.c'),
              subscription: subscription,
            ),
          ),
          geoPricingProvider.overrideWith(
            (Ref ref) async =>
                const GeoPricing(personalPrice: 299, companyPrice: 1199),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BillingSection(preferences: UserPreferences()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return <String>[
      for (final Text t in tester.widgetList<Text>(find.byType(Text)))
        t.data ?? t.textSpan?.toPlainText() ?? '',
    ];
  }

  void expectNoXp(List<String> text) {
    for (final String line in text) {
      expect(RegExp(r'\bXP\b').hasMatch(line), isFalse, reason: line);
      expect(line.toLowerCase().contains('top up'), isFalse, reason: line);
      expect(line.toLowerCase().contains('top-up'), isFalse, reason: line);
    }
  }

  testWidgets('a recurring plan reads Active and renews', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'active',
        paymentMode: 'subscription',
        currentPeriodEnd: DateTime(2026, 12, 1),
      ),
    );
    expect(text, contains('Plan'));
    expect(text, contains('Active'));
    expect(text.any((String l) => l.startsWith('Renews on')), isTrue);
    // The product offers no cancellation, so nothing promises one.
    expect(
      text.any((String l) => l.toLowerCase().contains('cancel any')),
      isFalse,
    );
    expect(text, contains('What your plan includes'));
    expectNoXp(text);
  });

  testWidgets('a one-time purchase reads as a 30-day pass', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'active',
        paymentMode: 'onetime',
        currentPeriodEnd: DateTime(2026, 12, 1),
      ),
    );
    expect(text, contains('30-day pass'));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    expectNoXp(text);
  });

  testWidgets('the free first month reads as itself, never as a pass', (
    WidgetTester tester,
  ) async {
    // What onboarding's plan step leaves behind: a mandate, no charge yet,
    // so Razorpay's status is `authenticated` and there is no period end.
    final List<String> text = await pump(
      tester,
      const SubscriptionState(
        status: 'authenticated',
        paymentMode: 'subscription',
        entitled: true,
        entitlementReason: 'subscription_trial',
      ),
    );
    expect(text, contains('Free month'));
    expect(text, isNot(contains('30-day pass')));
    // No cancel option is offered; what cancelling at the bank costs is said.
    expect(
      text,
      contains('Cancelling the autopay ends your free month straight away.'),
    );
    expect(text, contains('What your plan includes'));
    expectNoXp(text);
  });

  testWidgets('no plan says what is free and offers plans', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(tester, const SubscriptionState());
    expect(text, contains('No plan'));
    expect(text, contains('See plans'));
    // Without a server verdict a pass holder looks exactly like this, so the
    // caption must not claim AI features are unavailable.
    expect(text.any((String l) => l.contains('need a plan')), isFalse);
    expect(text.any((String l) => l.contains('may not show here yet')), isTrue);
    expectNoXp(text);
  });

  testWidgets('a cancelled subscriber is not told they have no plan', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      const SubscriptionState(status: 'cancelled', paymentMode: 'subscription'),
    );
    expect(text, contains('Not renewing'));
    expect(text, isNot(contains('No plan')));
    expectNoXp(text);
  });

  testWidgets('a pass holder the server calls entitled reads as active', (
    WidgetTester tester,
  ) async {
    // status stays 'inactive': a pass never writes it. The verdict decides.
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        status: 'inactive',
        entitled: true,
        entitlementReason: 'recent_purchase',
        accessEndsAt: DateTime(2026, 12, 5),
      ),
    );
    expect(text, contains('30-day pass'));
    expect(text, isNot(contains('No plan')));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    expect(text, contains('What your plan includes'));
    expectNoXp(text);
  });

  testWidgets('given plan time reads as given, with its end date', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      SubscriptionState(
        entitled: true,
        entitlementReason: 'granted',
        accessEndsAt: DateTime(2026, 12, 10),
      ),
    );
    expect(text, contains('Plan time given'));
    expect(text.any((String l) => l.startsWith('Active until')), isTrue);
    expectNoXp(text);
  });

  testWidgets('a server "not entitled" says no plan plainly', (
    WidgetTester tester,
  ) async {
    final List<String> text = await pump(
      tester,
      const SubscriptionState(
        status: 'cancelled',
        entitled: false,
        entitlementReason: 'lapsed',
      ),
    );
    expect(text, contains('No plan'));
    expect(
      text.any((String l) => l.contains('may not show here yet')),
      isFalse,
    );
    expect(text, contains('See plans'));
    expectNoXp(text);
  });
}
