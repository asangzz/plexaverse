import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/settings/domain/subscription_info.dart';

/// Verifies the bundled subscription fixture under `assets/mock/settings/`
/// deserialises through the real [SubscriptionInfo.fromJson].
///
/// The fixture is read exactly as `PrefsSettingsRepository.fetchSubscription`
/// reads it: a single top-level object parsed straight through the model
/// (camelCase keys, `field_rename: none`). It feeds the HeyGen-style Account
/// page (2374) and Subscription sheet (2375), so the plan numbers asserted
/// here are the ones those screens render.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const path = 'assets/mock/settings/subscription.json';

  Future<Map<String, dynamic>> load(String p) async =>
      jsonDecode(await rootBundle.loadString(p)) as Map<String, dynamic>;

  test('$path parses through SubscriptionInfo', () async {
    final json = await load(path);

    final info = SubscriptionInfo.fromJson(json);
    expect(info.planName, isNotEmpty);
    expect(info.source, isNotEmpty);
    expect(info.creditsRemaining, lessThanOrEqualTo(info.creditsTotal));
    expect(info.avatarSlotsRemaining, lessThanOrEqualTo(info.avatarSlotsTotal));
    expect(info.recentActivity, isNotEmpty);
    for (final item in info.recentActivity) {
      expect(item.title, isNotEmpty);
      expect(item.timeAgo, isNotEmpty);
      expect(item.kind, isNotEmpty);
    }
  });

  test('subscription fixture carries the Creator plan snapshot', () async {
    final json = await load(path);
    final info = SubscriptionInfo.fromJson(json);

    // Values pixel-matched to screenshots 2374/2375.
    expect(info.planName, 'Creator');
    expect(info.source, 'From Plexaverse web app');
    expect(info.creditsRemaining, 453);
    expect(info.creditsTotal, 600);
    expect(info.avatarSlotsRemaining, 4);
    expect(info.avatarSlotsTotal, 5);

    // Derived getters drive the progress bars and labels.
    expect(info.creditsUsed, 147);
    expect(info.usedFraction, closeTo(0.245, 0.001));
    expect(info.avatarSlotsUsed, 1);
    expect(info.creditsRemainingLabel, '453 remaining');
    expect(info.creditsTotalLabel, '600 credits');
    expect(info.avatarSlotsLabel, '4 avatar slots remaining');

    // Recent activity rows (2375): duration chip only on video items.
    expect(info.recentActivity, hasLength(3));
    final first = info.recentActivity.first;
    expect(first.title, 'Quick Avatar Video');
    expect(first.durationLabel, '0:08');
    expect(first.metaLine, '3h ago · Video');
    expect(first.creditsLabel, '-3 credits');
    expect(info.recentActivity[1].durationLabel, isNull);
    expect(info.recentActivity[2].creditsDelta, -12);
  });
}
