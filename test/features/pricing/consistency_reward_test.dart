import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/checkout.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart' show ZaveSwitch;
import 'package:plexaverse/features/contest/application/contest_controllers.dart';
import 'package:plexaverse/features/contest/domain/contest_consistency.dart';
import 'package:plexaverse/features/pricing/application/consistency_reward_controller.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/consistency_reward.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';
import 'package:plexaverse/features/pricing/presentation/widgets/consistency_reward_section.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';
import 'package:plexaverse/features/settings/presentation/widgets/billing_section.dart';

/// The consistency reward in the app (owner, 25 Nov 2026): shown only while
/// it applies to the account, the server's words verbatim, a yes sent with
/// the words' version and refused (then re-read) when they changed, no
/// figure while the price is being fixed, and billing copy — no game words.

// 25 Dec 2026, 10:00 IST, and the fix 72h before it.
final DateTime _dec25 = DateTime.utc(2026, 12, 25, 4, 30);
final DateTime _dec22 = DateTime.utc(2026, 12, 22, 4, 30);

Map<String, dynamic> _words({
  String headline =
      'Consistency reward — the more consistently you build your brand, the less you pay.',
}) => <String, dynamic>{
  'headline': headline,
  'label': 'Use my consistency to set my monthly price',
  'consentText': 'Use my consistency to set my monthly price: …',
  'why': 'We look only at your own record.',
  'conditions': <String>[
    'At least 20 days of your consistency counted in the month.',
    'At 75% consistency or more, your discount is your consistency — and every 10 days in a row adds 1%.',
  ],
  'appliesFromNextLine':
      'Switching it on now applies from the debit after this one.',
};

Map<String, dynamic> _consentBody({
  bool consented = false,
  bool stale = false,
  String version = '2026-11-25',
  Map<String, dynamic>? words,
}) => <String, dynamic>{
  'consented': consented,
  'staleConsent': stale,
  'wordsVersion': version,
  'words': words ?? _words(),
};

// ── The wire ────────────────────────────────────────────────────────────────

class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final String body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromBytes(
      utf8.encode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiPricingRepository, _Canned) _repo(int status, String body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiPricingRepository(DioClient(dio)), adapter);
}

String _ok(Object data) =>
    jsonEncode(<String, dynamic>{'data': data, 'error': null});

String _failed(String code, String message) => jsonEncode(<String, dynamic>{
  'data': null,
  'error': <String, dynamic>{'code': code, 'message': message},
});

// ── A fake server for the controller and the screen ─────────────────────────

class _Reward extends FakePricingRepository {
  _Reward({this.status = const AutopayStatus()});

  AutopayStatus status;
  ConsistencyRewardConsent consent = ConsistencyRewardConsent.fromJson(
    _consentBody(),
  );

  /// The next yes is refused: the words moved to this version.
  String? wordsMovedTo;

  /// The GET fails, as a server older than the route does (404).
  bool unreadable = false;
  int reads = 0;
  final List<Map<String, Object?>> puts = <Map<String, Object?>>[];

  @override
  Future<AutopayStatus> fetchAutopayStatus() async => status;

  @override
  Future<ConsistencyRewardConsent> fetchConsistencyReward() async {
    reads++;
    if (unreadable) throw const PricingUnavailable();
    return consent;
  }

  @override
  Future<ConsistencyRewardConsent> setConsistencyReward({
    required bool consented,
    String? wordsVersion,
  }) async {
    puts.add(<String, Object?>{
      'consented': consented,
      'wordsVersion': wordsVersion,
    });
    final String? moved = wordsMovedTo;
    if (consented && moved != null) {
      consent = ConsistencyRewardConsent.fromJson(
        _consentBody(
          version: moved,
          words: _words(headline: 'New words for the reward.'),
        ),
      );
      wordsMovedTo = null;
      throw const ConsistencyRewardUpdateRequired(
        'The words have changed — read them again below, then switch it on.',
      );
    }
    consent = ConsistencyRewardConsent.fromJson(
      _consentBody(consented: consented, version: consent.wordsVersion),
    );
    return consent;
  }
}

/// The server records the yes, but the answer is lost on the way back.
class _Failing extends _Reward {
  _Failing({super.status});

  @override
  Future<ConsistencyRewardConsent> setConsistencyReward({
    required bool consented,
    String? wordsVersion,
  }) async {
    await super.setConsistencyReward(
      consented: consented,
      wordsVersion: wordsVersion,
    );
    throw const ConsistencyRewardFailure();
  }
}

AutopayStatus _live({
  bool live = true,
  bool fixed = false,
  int amount = 39900,
  String? breakdown,
}) => AutopayStatus(
  rail: 'token',
  tokenStatus: 'confirmed',
  canStop: true,
  nextChargeAt: _dec25,
  nextChargeAmountPaise: amount,
  monthlyPaise: 39900,
  accessUntil: _dec25,
  nextChargePriceFixed: fixed,
  nextChargeBasePaise: 39900,
  consistencyReward: ConsistencyRewardStatus(
    live: live,
    minDays: 20,
    thresholdPct: 75,
    pricing: fixed ? 'consistency' : null,
    breakdown: breakdown,
  ),
);

List<String> _texts(WidgetTester tester) => <String>[
  for (final Text t in tester.widgetList<Text>(find.byType(Text)))
    t.data ?? t.textSpan?.toPlainText() ?? '',
];

/// Billing copy, not game copy: none of these near a price.
final RegExp _gameWords = RegExp(
  r'\b(xp|levels?|streaks?|points?|scores?|games?|play|plays|win|wins|prizes?)\b',
  caseSensitive: false,
);

void main() {
  group('the debit line', () {
    test('fixed: "Next debit: ₹80 on 25 Dec" with its breakdown', () {
      final RewardDebit d = RewardDebit.of(
        nextDebitAt: _dec25,
        fixed: const FixedDebitPrice(amountPaise: 8000, breakdown: '80% → ₹80'),
        estimate: null,
        consented: true,
        fixing: false,
        minDays: 20,
      )!;
      expect(d.line, 'Next debit: ₹80 on 25 Dec');
      expect(d.note, '80% → ₹80');
    });

    test('the date is India time, whatever the phone says', () {
      // 22:00 UTC on 24 Dec is already 25 Dec in India.
      final RewardDebit d = RewardDebit.of(
        nextDebitAt: DateTime.utc(2026, 12, 24, 22),
        fixed: const FixedDebitPrice(amountPaise: 123456),
        estimate: null,
        consented: false,
        fixing: false,
        minDays: 20,
      )!;
      expect(d.line, 'Next debit: ₹1,234.56 on 25 Dec');
    });

    test('an estimate only with the switch on, labelled, with its note', () {
      const EstimatedDebitPrice e = EstimatedDebitPrice(
        amountPaise: 8000,
        reason: 'priced',
      );
      expect(
        RewardDebit.of(
          nextDebitAt: _dec25,
          fixed: null,
          estimate: e,
          consented: false,
          fixing: false,
          minDays: 20,
        ),
        isNull,
      );
      final RewardDebit d = RewardDebit.of(
        nextDebitAt: _dec25,
        fixed: null,
        estimate: e,
        consented: true,
        fixing: false,
        minDays: 20,
      )!;
      expect(d.line, 'Next debit: about ₹80 on 25 Dec (estimate)');
      expect(
        d.note,
        'An estimate from your consistency so far. The price is fixed 3 days '
        'before the debit.',
      );
    });

    test('too few days counted says how many', () {
      final RewardDebit d = RewardDebit.of(
        nextDebitAt: _dec25,
        fixed: null,
        estimate: const EstimatedDebitPrice(
          amountPaise: 39900,
          reason: 'min_days',
          countedDays: 12,
        ),
        consented: true,
        fixing: false,
        minDays: 20,
      )!;
      expect(
        d.note,
        endsWith('So far 12 of the 20 days a reward needs are counted.'),
      );
    });

    test('while the price is being fixed: no figure', () {
      final RewardDebit d = RewardDebit.of(
        nextDebitAt: _dec25,
        fixed: null,
        estimate: const EstimatedDebitPrice(amountPaise: 8000),
        consented: true,
        fixing: true,
        minDays: 20,
      )!;
      expect(d.line, 'Next debit on 25 Dec — its price is being fixed.');
      expect(d.line, isNot(contains('₹')));
    });
  });

  group('reading the server', () {
    test('autopay status and the card\'s price parse; garbage is absent', () {
      final AutopayStatus s = AutopayStatus.fromJson(<String, dynamic>{
        'rail': 'token',
        'canStop': true,
        'nextChargeAt': '2026-12-25T04:30:00.000Z',
        'nextChargeAmountPaise': 8000,
        'nextChargePriceFixed': true,
        'nextChargeBasePaise': 39900,
        'consistencyReward': <String, dynamic>{
          'live': true,
          'consented': true,
          'staleConsent': false,
          'minDays': 20,
          'thresholdPct': 75,
          'pricing': 'consistency',
          'breakdown': 'b',
        },
      });
      expect(s.nextChargePriceFixed, isTrue);
      expect(s.consistencyReward?.live, isTrue);
      expect(s.consistencyReward?.breakdown, 'b');
      expect(
        AutopayStatus.fromJson(<String, dynamic>{
          'consistencyReward': 'nope',
        }).consistencyReward,
        isNull,
      );

      final ConsistencyView v = ConsistencyView.fromJson(<String, dynamic>{
        'state': 'measuring',
        'price': <String, dynamic>{
          'live': true,
          'consented': true,
          'minDays': 20,
          'nextDebitAt': '2026-12-25T04:30:00.000Z',
          'fixesAt': '2026-12-22T04:30:00.000Z',
          'fixed': null,
          'estimate': <String, dynamic>{
            'amountPaise': 8000,
            'basePaise': 39900,
            'reason': 'priced',
            'countedDays': 21,
          },
          'fixing': false,
        },
      });
      expect(v.price?.live, isTrue);
      expect(v.price?.estimate?.amountPaise, 8000);
      expect(v.price?.fixesAt, _dec22);
      expect(
        ConsistencyView.fromJson(<String, dynamic>{'price': 7}).price,
        isNull,
      );
    });

    test('a body missing the words cannot be drawn', () {
      expect(
        () => ConsistencyRewardConsent.fromJson(<String, dynamic>{
          'consented': false,
          'wordsVersion': '2026-11-25',
        }),
        throwsFormatException,
      );
    });
  });

  group('the wire', () {
    test(
      'a yes carries the words\' version; a no carries nothing else',
      () async {
        final (ApiPricingRepository repo, _Canned wire) = _repo(
          200,
          _ok(_consentBody(consented: true)),
        );
        await repo.setConsistencyReward(
          consented: true,
          wordsVersion: '2026-11-25',
        );
        await repo.setConsistencyReward(
          consented: false,
          wordsVersion: 'ignored',
        );
        expect(wire.seen[0].method, 'PUT');
        expect(wire.seen[0].path, endsWith('/billing/consistency-reward'));
        expect(wire.seen[0].data, <String, dynamic>{
          'consented': true,
          'wordsVersion': '2026-11-25',
        });
        expect(wire.seen[1].data, <String, dynamic>{'consented': false});
      },
    );

    test('409 UPDATE_REQUIRED carries the server\'s sentence', () async {
      final (ApiPricingRepository repo, _) = _repo(
        409,
        _failed('UPDATE_REQUIRED', 'The words have changed.'),
      );
      await expectLater(
        repo.setConsistencyReward(consented: true, wordsVersion: 'old'),
        throwsA(
          isA<ConsistencyRewardUpdateRequired>().having(
            (ConsistencyRewardUpdateRequired e) => e.message,
            'message',
            'The words have changed.',
          ),
        ),
      );
    });

    test('a 404 (a server older than the route) is unavailable', () async {
      final (ApiPricingRepository repo, _) = _repo(
        404,
        _failed('NOT_FOUND', 'Not found'),
      );
      await expectLater(
        repo.fetchConsistencyReward(),
        throwsA(isA<PricingUnavailable>()),
      );
    });
  });

  group('the switch', () {
    late _Reward server;
    late ProviderContainer c;

    setUp(() async {
      server = _Reward(status: _live());
      c = ProviderContainer(
        overrides: [pricingRepositoryProvider.overrideWithValue(server)],
      );
      c.listen(consistencyRewardConsentControllerProvider, (_, _) {});
      await c.read(consistencyRewardConsentControllerProvider.future);
    });
    tearDown(() => c.dispose());

    test('on sends the version of the words shown; off sends none', () async {
      final ConsistencyRewardSaveController save = c.read(
        consistencyRewardSaveControllerProvider.notifier,
      );
      await save.set(true, surface: RewardSurface.billing);
      expect(server.puts.last, <String, Object?>{
        'consented': true,
        'wordsVersion': '2026-11-25',
      });
      expect(
        c.read(consistencyRewardConsentControllerProvider).value?.consented,
        isTrue,
      );
      await save.set(false, surface: RewardSurface.billing);
      expect(server.puts.last, <String, Object?>{
        'consented': false,
        'wordsVersion': null,
      });
      expect(c.read(consistencyRewardSaveControllerProvider).error, isNull);
    });

    test('409: says why, reads the new words, records nothing', () async {
      server.wordsMovedTo = '2026-12-01';
      final int before = server.reads;
      await c
          .read(consistencyRewardSaveControllerProvider.notifier)
          .set(true, surface: RewardSurface.billing);
      expect(
        c.read(consistencyRewardSaveControllerProvider).error,
        startsWith('The words have changed'),
      );
      final ConsistencyRewardConsent again = await c.read(
        consistencyRewardConsentControllerProvider.future,
      );
      expect(server.reads, greaterThan(before));
      expect(again.wordsVersion, '2026-12-01');
      expect(again.words.headline, 'New words for the reward.');
      expect(again.consented, isFalse);
      // The next yes goes with the new words.
      await c
          .read(consistencyRewardSaveControllerProvider.notifier)
          .set(true, surface: RewardSurface.billing);
      expect(server.puts.last['wordsVersion'], '2026-12-01');
    });
  });

  group('the switch, when things go wrong', () {
    late _Reward server;
    late ProviderContainer c;

    setUp(() async {
      server = _Reward(status: _live());
      c = ProviderContainer(
        overrides: [pricingRepositoryProvider.overrideWithValue(server)],
      );
      c.listen(consistencyRewardConsentControllerProvider, (_, _) {});
      await c.read(consistencyRewardConsentControllerProvider.future);
    });
    tearDown(() => c.dispose());

    test('no yes while the words are being re-read', () async {
      c.invalidate(consistencyRewardConsentControllerProvider);
      // The re-read is in flight: the words on screen may be refused ones.
      expect(
        c.read(consistencyRewardConsentControllerProvider).isLoading,
        isTrue,
      );
      await c
          .read(consistencyRewardSaveControllerProvider.notifier)
          .set(true, surface: RewardSurface.card);
      expect(server.puts, isEmpty);
      expect(c.read(consistencyRewardSaveControllerProvider).error, isNotNull);
    });

    test('an uncertain failure re-reads the switch from the server', () async {
      final _Failing failing = _Failing(status: _live());
      final ProviderContainer f = ProviderContainer(
        overrides: [pricingRepositoryProvider.overrideWithValue(failing)],
      );
      addTearDown(f.dispose);
      f.listen(consistencyRewardConsentControllerProvider, (_, _) {});
      await f.read(consistencyRewardConsentControllerProvider.future);
      final int before = failing.reads;
      await f
          .read(consistencyRewardSaveControllerProvider.notifier)
          .set(true, surface: RewardSurface.billing);
      await f.read(consistencyRewardConsentControllerProvider.future);
      expect(failing.reads, greaterThan(before));
      // The server DID record it: the re-read shows it on.
      expect(
        f.read(consistencyRewardConsentControllerProvider).value?.consented,
        isTrue,
      );
    });

    test('an error belongs to the surface it happened on', () async {
      server.wordsMovedTo = '2026-12-01';
      await c
          .read(consistencyRewardSaveControllerProvider.notifier)
          .set(true, surface: RewardSurface.card);
      final RewardSave save = c.read(consistencyRewardSaveControllerProvider);
      expect(save.surface, RewardSurface.card);
      expect(save.error, isNotNull);
    });
  });

  group('the estimate follows the consent it was made under', () {
    test('an estimate made with the switch off is no estimate', () {
      expect(
        RewardDebit.of(
          nextDebitAt: _dec25,
          fixed: null,
          estimate: const EstimatedDebitPrice(amountPaise: 39900),
          consented: true,
          fixing: false,
          minDays: 20,
          estimateConsented: false,
        ),
        isNull,
      );
      expect(
        RewardDebit.of(
          nextDebitAt: _dec25,
          fixed: null,
          estimate: const EstimatedDebitPrice(
            amountPaise: 39900,
            reason: 'no_consent',
          ),
          consented: true,
          fixing: false,
          minDays: 20,
        ),
        isNull,
      );
    });
  });

  group('in Settings → Billing', () {
    Future<_Reward> pump(
      WidgetTester tester,
      _Reward server, {
      ConsistencyView? meter,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          retry: (int _, Object _) => null,
          overrides: [
            pricingRepositoryProvider.overrideWithValue(server),
            upiAppProbeProvider.overrideWithValue(const AssumeUpiApp()),
            checkoutProvider.overrideWithValue(const MockCheckout()),
            accountSnapshotProvider.overrideWith(
              (Ref ref) async => const AccountSnapshot(
                user: AccountIdentity(id: 'u1', name: 'A', email: 'a@b.c'),
                subscription: SubscriptionState(
                  status: 'active',
                  entitled: true,
                  entitlementReason: 'subscription_active',
                ),
              ),
            ),
            geoPricingProvider.overrideWith(
              (Ref ref) async =>
                  const GeoPricing(personalPrice: 399, companyPrice: 1199),
            ),
            contestConsistencyProvider.overrideWith(
              (Ref ref) async => meter ?? const ConsistencyView(),
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
      // The status, then the words, then the meter: a few frames apart.
      for (int i = 0; i < 12; i++) {
        await tester.pump();
      }
      return server;
    }

    testWidgets('shown while live: the server\'s words, switch off', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Reward(status: _live()));
      expect(find.byKey(const Key('consistency-reward')), findsOneWidget);
      final List<String> text = _texts(tester);
      expect(text, contains(_words()['headline']));
      expect(text, contains('Use my consistency to set my monthly price'));
      expect(text, contains('We look only at your own record.'));
      expect(
        text,
        contains('At least 20 days of your consistency counted in the month.'),
      );
      // Never pre-ticked.
      final ZaveSwitch sw = tester.widget<ZaveSwitch>(find.byType(ZaveSwitch));
      expect(sw.value, isFalse);
      // Before the fix with the switch off: no figure, but when to switch on.
      expect(text.where((String t) => t.startsWith('Next debit')), isEmpty);
      for (final String line in text) {
        if (!line.contains('₹') && !line.contains('consistency')) continue;
        expect(_gameWords.hasMatch(line), isFalse, reason: line);
      }
    });

    testWidgets('live and not fixed: the summary says "at most"', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Reward(status: _live()));
      expect(
        find.text('Next payment on 25 Dec, at most ₹399.'),
        findsOneWidget,
      );
      expect(find.text('Next payment of ₹399 on 25 Dec.'), findsNothing);
    });

    testWidgets('a failed re-read of the words hides the section', (
      WidgetTester tester,
    ) async {
      final _Reward server = await pump(tester, _Reward(status: _live()));
      expect(find.byKey(const Key('consistency-reward')), findsOneWidget);
      server.unreadable = true;
      ProviderScope.containerOf(
        tester.element(find.byType(BillingSection)),
      ).invalidate(consistencyRewardConsentControllerProvider);
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.byKey(const Key('consistency-reward')), findsNothing);
      expect(find.text('Stop autopay'), findsOneWidget);
    });

    testWidgets('not live: nothing about a discount', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Reward(status: _live(live: false)));
      expect(find.byKey(const Key('consistency-reward')), findsNothing);
      expect(find.textContaining('Consistency reward'), findsNothing);
      expect(find.text('Stop autopay'), findsOneWidget);
    });

    testWidgets('the words unreadable (404): hidden, billing still works', (
      WidgetTester tester,
    ) async {
      await pump(tester, _Reward(status: _live())..unreadable = true);
      expect(find.byKey(const Key('consistency-reward')), findsNothing);
      expect(find.text('Stop autopay'), findsOneWidget);
    });

    testWidgets('fixed: the price, the breakdown, and when a yes applies', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        _Reward(
          status: _live(
            fixed: true,
            amount: 8000,
            breakdown: '80% consistency → ₹80',
          ),
        ),
      );
      final List<String> text = _texts(tester);
      expect(text, contains('Next debit: ₹80 on 25 Dec'));
      expect(text, contains('80% consistency → ₹80'));
      expect(
        text,
        contains('Switching it on now applies from the debit after this one.'),
      );
    });

    testWidgets('switch on: an estimate before the fix, labelled one', (
      WidgetTester tester,
    ) async {
      final _Reward server = _Reward(status: _live());
      server.consent = ConsistencyRewardConsent.fromJson(
        _consentBody(consented: true),
      );
      await pump(
        tester,
        server,
        meter: ConsistencyView.fromJson(<String, dynamic>{
          'price': <String, dynamic>{
            'live': true,
            'consented': true,
            'minDays': 20,
            'nextDebitAt': _dec25.toIso8601String(),
            'fixesAt': _dec22.toIso8601String(),
            'estimate': <String, dynamic>{
              'amountPaise': 8000,
              'reason': 'priced',
              'countedDays': 21,
            },
            'fixing': false,
          },
        }),
      );
      final List<String> text = _texts(tester);
      expect(text, contains('Next debit: about ₹80 on 25 Dec (estimate)'));
      expect(tester.widget<ZaveSwitch>(find.byType(ZaveSwitch)).value, isTrue);
      // On: the why and the conditions give way to the switch itself.
      expect(text, isNot(contains('We look only at your own record.')));
    });

    testWidgets('while the price is being fixed: no figure at all', (
      WidgetTester tester,
    ) async {
      final _Reward server = _Reward(status: _live());
      server.consent = ConsistencyRewardConsent.fromJson(
        _consentBody(consented: true),
      );
      await pump(
        tester,
        server,
        meter: ConsistencyView.fromJson(<String, dynamic>{
          'price': <String, dynamic>{
            'live': true,
            'consented': true,
            'nextDebitAt': _dec25.toIso8601String(),
            'fixesAt': _dec22.toIso8601String(),
            'estimate': null,
            'fixing': true,
          },
        }),
      );
      final List<String> text = _texts(tester);
      expect(
        text,
        contains('Next debit on 25 Dec — its price is being fixed.'),
      );
      expect(
        text.where((String t) => t.startsWith('Next debit') && t.contains('₹')),
        isEmpty,
      );
    });

    testWidgets('a stale yes is shown off and offered again', (
      WidgetTester tester,
    ) async {
      final _Reward server = _Reward(status: _live());
      server.consent = ConsistencyRewardConsent.fromJson(
        _consentBody(stale: true),
      );
      await pump(tester, server);
      expect(tester.widget<ZaveSwitch>(find.byType(ZaveSwitch)).value, isFalse);
      expect(find.text(kStaleConsentLine), findsOneWidget);
    });

    testWidgets('flipping the switch sends the yes with the words shown', (
      WidgetTester tester,
    ) async {
      final _Reward server = await pump(tester, _Reward(status: _live()));
      await tester.ensureVisible(find.byType(ZaveSwitch));
      await tester.tap(find.byType(ZaveSwitch));
      for (int i = 0; i < 12; i++) {
        await tester.pump();
      }
      expect(server.puts.single, <String, Object?>{
        'consented': true,
        'wordsVersion': '2026-11-25',
      });
      expect(tester.widget<ZaveSwitch>(find.byType(ZaveSwitch)).value, isTrue);
    });
  });

  test('the section\'s own lines carry no game words', () {
    for (final String line in <String>[
      nextDebitLine(8000, _dec25),
      estimateLine(8000, _dec25),
      kEstimateNote,
      kStaleConsentLine,
      switchOnBeforeLine(_dec22),
      kRewardSaveFailed,
    ]) {
      expect(_gameWords.hasMatch(line), isFalse, reason: line);
    }
    // The widget's type is still here so a refactor keeps this file honest.
    expect(ConsistencyRewardSection, isNotNull);
  });
}
