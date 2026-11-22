import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/network/api_paths.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/features/pricing/application/billing_state_controller.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';
import 'package:plexaverse/features/pricing/presentation/widgets/billing_state_picker.dart';

/// The buyer's GST State on the app (the web's `lib/billing-state.ts` and
/// `BillingStatePicker`): the list, the rule for who is asked, the wire to
/// `/user/billing-state` as the mobile route answers it, and a picker that
/// cannot submit an empty choice.

/// `app/api/mobile/v1/user/billing-state` as it answers: the body inside
/// `data`, a refusal as `{error: {code, message, fields}}`.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body);

  final int status;
  final Object body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiPricingRepository, _Canned) _repo(int status, Object body) {
  final _Canned adapter = _Canned(status, body);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiPricingRepository(DioClient(dio)), adapter);
}

Map<String, dynamic> _ok(Object data) => <String, dynamic>{
  'data': data,
  'error': null,
};

void main() {
  group('the list and the rule', () {
    test('every State and UT the web offers — 36, never 97, by name', () {
      expect(kBillingStateOptions, hasLength(36));
      expect(isBillingStateCode('97'), isFalse);
      expect(kGstStates.containsKey('97'), isFalse);
      // 25 and 28 were merged away; they are not States any more.
      expect(isBillingStateCode('25'), isFalse);
      expect(isBillingStateCode('28'), isFalse);
      final List<String> names = <String>[
        for (final BillingStateOption o in kBillingStateOptions) o.name,
      ];
      expect(names.first, 'Andaman and Nicobar Islands');
      expect(names.last, 'West Bengal');
      expect(
        names,
        orderedEquals(
          <String>[...names]..sort(
            (String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()),
          ),
        ),
      );
      expect(billingStateName('27'), 'Maharashtra');
      expect(billingStateName('29'), 'Karnataka');
      expect(billingStateName(null), isNull);
    });

    test('only a buyer in India with no State on record is asked', () {
      expect(billingStateNeeded(isIndia: true, stateCode: null), isTrue);
      expect(billingStateNeeded(isIndia: true, stateCode: '  '), isTrue);
      expect(billingStateNeeded(isIndia: true, stateCode: '29'), isFalse);
      expect(billingStateNeeded(isIndia: false, stateCode: null), isFalse);
      // A code a newer server knows and this build does not is still an
      // answer: re-asking on every payment would be the worse failure.
      expect(billingStateNeeded(isIndia: true, stateCode: '39'), isFalse);
    });

    test('the copy is the web\'s, word for word', () {
      expect(kBillingStateQuestion, 'Which State are you in?');
      expect(kBillingStateReason, 'It is printed on your GST invoices.');
    });
  });

  group('the wire', () {
    test('GET reads what is on record and the region\'s suggestion', () async {
      final (ApiPricingRepository repo, _Canned wire) = _repo(
        200,
        _ok(<String, dynamic>{
          'stateCode': null,
          'stateName': null,
          'declaredAt': null,
          'source': null,
          'isIndia': true,
          'required': true,
          'suggestedStateCode': '29',
        }),
      );
      final BillingState s = await repo.fetchBillingState();
      expect(wire.seen.single.method, 'GET');
      expect(wire.seen.single.path, ApiPaths.userBillingState);
      expect(s.stateCode, isNull);
      expect(s.declared, isFalse);
      expect(s.isIndia, isTrue);
      expect(s.suggestedStateCode, '29');
      // Pre-selects the suggestion; never saves it.
      expect(s.preset, '29');
    });

    test('GET of a declared State', () async {
      final (ApiPricingRepository repo, _) = _repo(
        200,
        _ok(<String, dynamic>{
          'stateCode': '27',
          'stateName': 'Maharashtra',
          'declaredAt': '2026-11-23T05:00:00.000Z',
          'source': 'onboarding',
          'isIndia': true,
          'required': false,
          'suggestedStateCode': '29',
        }),
      );
      final BillingState s = await repo.fetchBillingState();
      expect(s.declared, isTrue);
      expect(s.stateName, 'Maharashtra');
      expect(s.source, BillingStateSource.onboarding);
      expect(s.declaredAt, DateTime.utc(2026, 11, 23, 5));
      // What is on record wins over the region.
      expect(s.preset, '27');
    });

    test('a GET that fails — an older server included — is unavailable, '
        'never a guess', () async {
      for (final int status in <int>[404, 500]) {
        final (ApiPricingRepository repo, _) = _repo(status, <String, dynamic>{
          'data': null,
          'error': <String, dynamic>{'code': 'NOT_FOUND', 'message': 'x'},
        });
        await expectLater(
          repo.fetchBillingState(),
          throwsA(isA<PricingUnavailable>()),
          reason: '$status',
        );
      }
    });

    test('PUT sends the code and where it was declared', () async {
      final (ApiPricingRepository repo, _Canned wire) = _repo(
        200,
        _ok(<String, dynamic>{
          'stateCode': '29',
          'stateName': 'Karnataka',
          'declaredAt': '2026-11-23T05:00:00.000Z',
          'source': 'settings',
        }),
      );
      final SavedBillingState saved = await repo.saveBillingState(
        stateCode: '29',
        source: BillingStateSource.settings,
      );
      expect(wire.seen.single.method, 'PUT');
      expect(wire.seen.single.path, ApiPaths.userBillingState);
      expect(wire.seen.single.data, <String, dynamic>{
        'stateCode': '29',
        'source': 'settings',
      });
      expect(saved.stateCode, '29');
      expect(saved.stateName, 'Karnataka');
      expect(saved.source, BillingStateSource.settings);
    });

    test('a refused PUT shows the server\'s sentence', () async {
      final (ApiPricingRepository repo, _) = _repo(400, <String, dynamic>{
        'data': null,
        'error': <String, dynamic>{
          'code': 'VALIDATION_FAILED',
          'message': 'Choose your State or Union Territory from the list.',
          'fields': <String, dynamic>{
            'stateCode': <String>[
              'Choose your State or Union Territory from the list.',
            ],
          },
        },
      });
      Object? thrown;
      try {
        await repo.saveBillingState(
          stateCode: '29',
          source: BillingStateSource.checkout,
        );
      } on Object catch (e) {
        thrown = e;
      }
      expect(thrown, isNotNull);
      expect(
        billingStateSaveError(thrown!),
        'Choose your State or Union Territory from the list.',
      );
    });

    test('a PUT answered with no State is not a save', () async {
      final (ApiPricingRepository repo, _) = _repo(
        200,
        _ok(<String, dynamic>{'stateCode': ''}),
      );
      await expectLater(
        repo.saveBillingState(
          stateCode: '29',
          source: BillingStateSource.onboarding,
        ),
        throwsStateError,
      );
    });

    test('the mock refuses what the server refuses', () async {
      final FakePricingRepository fake = FakePricingRepository();
      await expectLater(
        fake.saveBillingState(
          stateCode: '97',
          source: BillingStateSource.settings,
        ),
        throwsA(isA<DioException>()),
      );
      expect((await fake.fetchBillingState()).stateCode, isNull);
    });
  });

  group('the picker', () {
    late List<String> submitted;

    Future<void> pump(
      WidgetTester tester, {
      String? preset,
      bool busy = false,
      String? error,
    }) async {
      submitted = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BillingStatePicker(
                preset: preset,
                busy: busy,
                error: error,
                submitLabel: 'Continue',
                onSubmit: submitted.add,
              ),
            ),
          ),
        ),
      );
    }

    Future<void> slide(WidgetTester tester) async {
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('cannot submit an empty choice', (WidgetTester tester) async {
      await pump(tester);
      expect(find.text(BillingStatePicker.placeholder), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(submitted, isEmpty);
    });

    testWidgets('a choice from the sheet is what is submitted', (
      WidgetTester tester,
    ) async {
      await pump(tester);
      await tester.tap(
        find.byKey(const ValueKey<String>('billing-state-field')),
      );
      await slide(tester);
      expect(find.text('Which State are you in?'), findsOneWidget);
      await tester.tap(find.text('Bihar'));
      await slide(tester);
      expect(find.text('Bihar'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(submitted, <String>['10']);
    });

    testWidgets('pre-selected from the region, submitted only on the tap', (
      WidgetTester tester,
    ) async {
      await pump(tester, preset: '27');
      expect(find.text('Maharashtra'), findsOneWidget);
      expect(submitted, isEmpty);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(submitted, <String>['27']);
    });

    testWidgets('holds still while saving, and says why a save failed', (
      WidgetTester tester,
    ) async {
      await pump(tester, preset: '27', busy: true);
      expect(find.text('Saving…'), findsOneWidget);
      // The label is held invisibly under the spinner; press the button.
      await tester.tap(
        find.ancestor(of: find.text('Saving…'), matching: find.byType(InkWell)),
      );
      await tester.pump();
      expect(submitted, isEmpty);

      await pump(tester, preset: '27', error: kBillingStateSaveFailed);
      expect(find.text(kBillingStateSaveFailed), findsOneWidget);
    });
  });
}
