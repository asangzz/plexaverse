import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plexaverse/features/pricing/application/pricing_controller.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';

/// Pins the wallet-XP retirement on the Pricing side: plans are described by
/// their allowances, read live from `GET /user/allowances`, with the web's
/// defaults standing in when that read fails.
void main() {
  group('Allowance.fromJson', () {
    test('parses a full wire row', () {
      final Allowance? a = Allowance.fromJson(<String, dynamic>{
        'key': 'ai_generate_post',
        'limit': 3,
        'period': 'day',
        'label': 'Posts',
        'enabled': true,
        'used': 1,
        'remaining': 2,
        'periodKey': '2026-11-10',
        'resetsAt': '2026-11-10T18:30:00.000Z',
      });
      expect(a, isNotNull);
      expect(a!.amountLabel, '3 a day');
      expect(a.remainingLabel, '2 left today');
      expect(a.resetsAt, DateTime.utc(2026, 11, 10, 18, 30));
    });

    test('a monthly row says "this month"', () {
      final Allowance a = Allowance.fromJson(<String, dynamic>{
        'key': 'ai_generate_carousel',
        'label': 'Carousels',
        'limit': 4,
        'period': 'month',
        'remaining': 4,
      })!;
      expect(a.amountLabel, '4 a month');
      expect(a.remainingLabel, '4 left this month');
    });

    test('a disabled row is Unlimited and shows no count', () {
      final Allowance a = Allowance.fromJson(<String, dynamic>{
        'key': 'ai_generate_poll',
        'label': 'Polls',
        'limit': 3,
        'period': 'day',
        'enabled': false,
        'remaining': 0,
      })!;
      expect(a.amountLabel, 'Unlimited');
      expect(a.remainingLabel, isNull);
    });

    test('a row without a key or label is dropped', () {
      expect(Allowance.fromJson(<String, dynamic>{'limit': 3}), isNull);
      final List<Allowance> rows = Allowance.listFromJson(<String, dynamic>{
        'allowances': <Object?>[
          <String, dynamic>{'key': 'ai_generate_post', 'label': 'Posts'},
          <String, dynamic>{'key': ''},
          'junk',
        ],
      });
      expect(rows.map((Allowance a) => a.key), <String>['ai_generate_post']);
    });
  });

  test('the static defaults mirror the web table', () {
    final Map<String, String> byKey = <String, String>{
      for (final Allowance a in Allowance.defaults) a.key: a.amountLabel,
    };
    expect(byKey['ai_generate_post'], '3 a day');
    expect(byKey['ai_generate_image'], '3 a day');
    expect(byKey['ai_generate_comment'], '15 a day');
    expect(byKey['ai_generate_headshot'], '3 a month');
    expect(byKey['ai_generate_carousel'], '4 a month');
    expect(Allowance.defaults, hasLength(19));
    // The fallback knows nothing about this user.
    expect(
      Allowance.defaults.every((Allowance a) => a.remainingLabel == null),
      isTrue,
    );
  });

  group('planAllowancesProvider', () {
    ProviderContainer containerWith(PricingRepository repo) {
      final ProviderContainer c = ProviderContainer(
        overrides: [pricingRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('a live answer is used as-is', () async {
      final AllowanceTable table = await containerWith(
        _Repo(
          rows: const <Allowance>[
            Allowance(
              key: 'ai_generate_post',
              label: 'Posts',
              limit: 5,
              period: AllowancePeriod.day,
              remaining: 5,
            ),
          ],
        ),
      ).read(planAllowancesProvider.future);
      expect(table.live, isTrue);
      expect(table.rows.single.limit, 5);
    });

    test('a failed read falls back to the defaults', () async {
      final AllowanceTable table = await containerWith(
        _Repo(fail: true),
      ).read(planAllowancesProvider.future);
      expect(table.live, isFalse);
      expect(table.rows, same(Allowance.defaults));
    });

    test('an empty answer falls back too', () async {
      final AllowanceTable table = await containerWith(
        _Repo(rows: const <Allowance>[]),
      ).read(planAllowancesProvider.future);
      expect(table.live, isFalse);
    });
  });

  test('ReferralSummary ignores the retired XP counter', () {
    final ReferralSummary s = ReferralSummary.fromWire(<String, dynamic>{
      'code': 'ABC',
      'stats': <String, dynamic>{'totalReferrals': 2, 'totalXPEarned': 5000},
    });
    expect(s.totalReferrals, 2);
    expect(s.hasCode, isTrue);
  });

  test('no plan feature line mentions XP', () {
    for (final PricingPlan plan in PricingPlan.all) {
      for (final String line in <String>[
        ...plan.features,
        ...plan.lockedFeatures,
      ]) {
        expect(line.contains('XP'), isFalse, reason: line);
      }
    }
  });
}

class _Repo extends FakePricingRepository {
  _Repo({this.rows = const <Allowance>[], this.fail = false});

  final List<Allowance> rows;
  final bool fail;

  @override
  Future<List<Allowance>> fetchAllowances() async {
    if (fail) throw const PricingUnavailable();
    return rows;
  }
}
