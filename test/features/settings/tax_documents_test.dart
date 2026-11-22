import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plexaverse/core/network/api_paths.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/image_sharing.dart';
import 'package:plexaverse/features/pricing/data/pricing_repositories.dart';
import 'package:plexaverse/features/pricing/domain/pricing_repository.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';
import 'package:plexaverse/features/settings/presentation/widgets/billing_section.dart';

/// Settings → Billing → Tax invoices (TOKEN_AUTOPAY_SPEC.md §5.9): the list
/// `GET /api/mobile/v1/billing/invoices` sends, and one document's printable
/// page from `GET /api/mobile/v1/billing/invoices/[id]` — fetched with the
/// app's own client (the route needs the bearer token) and shown in the app.

// ── The wire ────────────────────────────────────────────────────────────────

/// One canned answer: a status, a body and its content type.
class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body, {this.contentType = Headers.jsonContentType});

  final int status;
  final String body;
  final String contentType;
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
        Headers.contentTypeHeader: <String>[contentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiPricingRepository, _Canned) _repo(
  int status,
  String body, {
  String contentType = Headers.jsonContentType,
}) {
  final _Canned adapter = _Canned(status, body, contentType: contentType);
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

Map<String, dynamic> _row({
  String? id = 'inv_1',
  String kind = 'invoice',
  String? number = 'PX/2627/000001',
  String? issuedAt = '2026-11-21T06:30:00.000Z',
  Object? totalPaise = 39900,
  String? periodFrom = '2026-12-16T04:30:00.000Z',
  String? periodTo = '2027-01-16T04:30:00.000Z',
}) => <String, dynamic>{
  'id': ?id,
  'kind': kind,
  'number': ?number,
  'issuedAt': ?issuedAt,
  'totalPaise': ?totalPaise,
  'periodFrom': periodFrom,
  'periodTo': periodTo,
};

/// The page `renderTaxDocumentHtml(doc, { billedTo, printable: true })`
/// writes on the server, for an inter-State tax invoice.
const String _page = '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Tax Invoice PX/2627/000001</title>
<style>
  @media print { .no-print { display: none !important; } body { background: #fff !important; } }
  table.lines td { padding: 8px 0; border-bottom: 1px solid #e2e8f0; }
</style>
</head>
<body style="margin:0;padding:16px;background:#f1f5f9;color:#0f172a;line-height:1.5">
<div style="max-width:640px;margin:0 auto;background:#fff;border-radius:12px;padding:28px">
  <div class="no-print" style="text-align:right;margin-bottom:12px"><button type="button" onclick="window.print()" style="font:inherit">Print or save as PDF</button></div>
  <h1 style="font-size:22px;margin:0">Tax Invoice</h1>
  <div style="font-size:15px;margin-top:4px"><strong>No. PX/2627/000001</strong> · Date 21 Nov 2026</div>

  <div style="margin-top:20px;font-size:14px">
    <div style="font-weight:700">Plexaverse Technologies &amp; Co.</div>
    <div>12 MG Road, Pune</div>
    <div>GSTIN 27AAAAA0000A1Z5 · State 27-Maharashtra</div>
  </div>

  <div style="margin-top:16px;font-size:14px">
    <div>Billed to: o&#39;neil@example.com (unregistered)</div>
    <div>Place of supply: 29-Karnataka</div>
    <div>Tax payable on reverse charge: No</div>
  </div>

  <table class="lines" style="width:100%;border-collapse:collapse;margin-top:20px;font-size:14px">
    <tr><td><strong>Plexaverse Personal plan, 1 month</strong><div style="color:#475569;font-size:13px">SAC 998314</div><div style="color:#475569;font-size:13px">Plan period: 16 Dec 2026 – 15 Jan 2027</div></td><td></td></tr>
    <tr><td>Taxable value</td><td style="text-align:right">₹338.14</td></tr>
    <tr><td>IGST @ 18%</td><td style="text-align:right">₹60.86</td></tr>
    <tr><td><strong>Total (incl. GST)</strong></td><td style="text-align:right"><strong>₹399.00</strong></td></tr>
  </table>
  <div style="color:#475569;font-size:13px;margin-top:12px">Paid by UPI AutoPay on 21 Nov 2026 · Payment pay_123</div>

  <div style="color:#64748b;font-size:12px;margin-top:24px">Amounts in Indian rupees. This is a computer-generated document and needs no signature.</div>

</div>
</body>
</html>''';

// ── The section ─────────────────────────────────────────────────────────────

/// The pricing backend for these tests: no mandate, and the documents and
/// pages as scripted. Every read answers at once, so no test waits on the
/// fake's latency timer.
class _Invoices extends FakePricingRepository {
  _Invoices({
    this.documents = const <TaxDocument>[],
    this.listFails = 0,
    this.pageFails = 0,
  });

  final List<TaxDocument> documents;

  /// How many list reads fail before one succeeds.
  int listFails;

  /// How many page reads fail before one succeeds.
  int pageFails;

  int listReads = 0;
  final List<String> pageReads = <String>[];

  @override
  Future<AutopayStatus> fetchAutopayStatus() async => const AutopayStatus();

  @override
  Future<PlanPricing> fetchPricing({String? countryCode}) async =>
      const PlanPricing(personalPrice: 399, companyPrice: 1199);

  @override
  Future<PaymentConfig> fetchPaymentConfig() async => const PaymentConfig();

  @override
  Future<List<TaxDocument>> fetchTaxDocuments() async {
    listReads++;
    if (listFails > 0) {
      listFails--;
      throw const PricingUnavailable();
    }
    return documents;
  }

  @override
  Future<String> fetchTaxDocumentHtml(String id) async {
    pageReads.add(id);
    if (pageFails > 0) {
      pageFails--;
      throw const PricingUnavailable();
    }
    return _page;
  }
}

/// The share sheet, as a record of what it was handed.
class _Sharing implements ImageSharingService {
  final List<(String fileName, String contents)> files = <(String, String)>[];

  @override
  Future<ShareResult> shareTextFile({
    required String contents,
    required String fileName,
    String? text,
  }) async {
    files.add((fileName, contents));
    return const ShareSucceeded();
  }

  @override
  Future<ShareResult> shareImageUrl({
    required String url,
    required String fileName,
    String? text,
  }) => throw UnimplementedError();

  @override
  Future<ShareResult> shareWidgetPng({
    required GlobalKey boundaryKey,
    required String fileName,
    required double targetWidth,
    String? text,
  }) => throw UnimplementedError();
}

final TaxDocument _invoice = TaxDocument(
  id: 'inv_1',
  kind: TaxDocumentKind.invoice,
  number: 'PX/2627/000001',
  issuedAt: DateTime.utc(2026, 11, 21, 6, 30),
  totalPaise: 39900,
);

final TaxDocument _creditNote = TaxDocument(
  id: 'inv_2',
  kind: TaxDocumentKind.creditNote,
  number: 'PXC/2627/000001',
  issuedAt: DateTime.utc(2026, 11, 22, 6, 30),
  totalPaise: 39900,
);

final TaxDocument _voucher = TaxDocument(
  id: 'inv_3',
  kind: TaxDocumentKind.refundVoucher,
  number: 'PXR/2627/000001',
  issuedAt: DateTime.utc(2026, 11, 20, 6, 30),
  totalPaise: 100,
);

List<String> texts(WidgetTester tester) => <String>[
  for (final Text t in tester.widgetList<Text>(find.byType(Text)))
    t.data ?? t.textSpan?.toPlainText() ?? '',
];

Future<void> _pumpSection(
  WidgetTester tester,
  _Invoices repo, {
  _Sharing? sharing,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (int _, Object _) => null,
      overrides: [
        pricingRepositoryProvider.overrideWithValue(repo),
        imageSharingProvider.overrideWithValue(sharing ?? _Sharing()),
        accountSnapshotProvider.overrideWith(
          (Ref ref) async => const AccountSnapshot(
            user: AccountIdentity(id: 'u1', name: 'A', email: 'a@b.c'),
            subscription: SubscriptionState(),
          ),
        ),
        geoPricingProvider.overrideWith(
          (Ref ref) async =>
              const GeoPricing(personalPrice: 399, companyPrice: 1199),
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
  await tester.pump();
}

/// Taps a document row and lets the sheet open and its page load.
Future<void> _open(WidgetTester tester, String number) async {
  await tester.ensureVisible(find.text(number));
  await tester.tap(find.text(number));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  group('the wire', () {
    test('the list parses: kinds, numbers, dates and totals, in the '
        "server's order", () async {
      final (ApiPricingRepository repo, _Canned wire) = _repo(
        200,
        _ok(<String, dynamic>{
          'invoices': <Map<String, dynamic>>[
            _row(),
            _row(
              id: 'inv_2',
              kind: 'credit_note',
              number: 'PXC/2627/000001',
              totalPaise: 33814,
              periodFrom: null,
              periodTo: null,
            ),
            _row(id: 'inv_3', kind: 'refund_voucher', totalPaise: 100),
            // A kind this build does not know is still the user's document.
            _row(id: 'inv_4', kind: 'purchase_invoice'),
          ],
        }),
      );
      final List<TaxDocument> list = await repo.fetchTaxDocuments();
      expect(wire.seen.single.path, ApiPaths.billingInvoices);
      expect(wire.seen.single.method, 'GET');
      expect(list.map((TaxDocument d) => d.id), <String>[
        'inv_1',
        'inv_2',
        'inv_3',
        'inv_4',
      ]);
      expect(list.map((TaxDocument d) => d.kind), <TaxDocumentKind>[
        TaxDocumentKind.invoice,
        TaxDocumentKind.creditNote,
        TaxDocumentKind.refundVoucher,
        TaxDocumentKind.other,
      ]);
      expect(list.map((TaxDocument d) => d.kind.label), <String>[
        'Tax invoice',
        'Credit note',
        'Refund voucher',
        'Tax document',
      ]);
      expect(list.first.number, 'PX/2627/000001');
      expect(list.first.issuedAt, DateTime.utc(2026, 11, 21, 6, 30));
      expect(list.first.totalPaise, 39900);
      expect(list.first.periodFrom, DateTime.utc(2026, 12, 16, 4, 30));
      expect(list.first.periodTo, DateTime.utc(2027, 1, 16, 4, 30));
      expect(list[1].totalPaise, 33814);
      expect(list[1].periodFrom, isNull);
      expect(list.first.fileName, 'PX-2627-000001.html');
    });

    test('a row it cannot show and open is left out, never filled in', () {
      final List<TaxDocument> list = TaxDocument.listFromJson(<String, dynamic>{
        'invoices': <Object?>[
          _row(id: null),
          _row(id: ''),
          _row(number: null),
          _row(issuedAt: null),
          _row(issuedAt: 'not a date'),
          _row(totalPaise: null),
          _row(totalPaise: '399'),
          'not a row',
          null,
          _row(id: 'inv_ok'),
        ],
      });
      expect(list.map((TaxDocument d) => d.id), <String>['inv_ok']);
    });

    test('no documents is an empty list', () async {
      final (ApiPricingRepository repo, _) = _repo(
        200,
        _ok(<String, dynamic>{'invoices': <Object>[]}),
      );
      expect(await repo.fetchTaxDocuments(), isEmpty);
    });

    test('a server older than the route (404) reads as no documents', () async {
      final (ApiPricingRepository repo, _) = _repo(
        404,
        _failed('NOT_FOUND', 'Not found'),
      );
      expect(await repo.fetchTaxDocuments(), isEmpty);
    });

    test(
      'a failed or empty read throws — it never looks like "none"',
      () async {
        for (final (int status, String body) in <(int, String)>[
          (500, _failed('INTERNAL', 'Could not load your invoices')),
          (200, _ok(<String, dynamic>{})),
          (200, _ok(<String, dynamic>{'invoices': 'nope'})),
        ]) {
          final (ApiPricingRepository repo, _) = _repo(status, body);
          await expectLater(
            repo.fetchTaxDocuments(),
            throwsA(isA<PricingUnavailable>()),
            reason: body,
          );
        }
      },
    );

    test(
      'a document is fetched through the app client as the page itself',
      () async {
        final (ApiPricingRepository repo, _Canned wire) = _repo(
          200,
          _page,
          contentType: 'text/html; charset=utf-8',
        );
        final String html = await repo.fetchTaxDocumentHtml('inv_1');
        expect(html, _page);
        expect(wire.seen.single.path, '/billing/invoices/inv_1');
        expect(wire.seen.single.path, ApiPaths.billingInvoice('inv_1'));
        expect(wire.seen.single.responseType, ResponseType.plain);
      },
    );

    test('the document id is escaped into the path', () {
      expect(ApiPaths.billingInvoice('a/b c'), '/billing/invoices/a%2Fb%20c');
    });

    test('a document that cannot be fetched throws', () async {
      for (final (int status, String body, String type)
          in <(int, String, String)>[
            (
              404,
              _failed('NOT_FOUND', 'Document not found'),
              Headers.jsonContentType,
            ),
            (
              500,
              _failed('INTERNAL', 'Could not load this document'),
              Headers.jsonContentType,
            ),
            // A 200 that is not markup is not the document.
            (200, _ok(<String, dynamic>{'ok': true}), Headers.jsonContentType),
            (200, '', 'text/html'),
          ]) {
        final (ApiPricingRepository repo, _) = _repo(
          status,
          body,
          contentType: type,
        );
        await expectLater(
          repo.fetchTaxDocumentHtml('inv_1'),
          throwsA(isA<PricingUnavailable>()),
          reason: '$status $body',
        );
      }
    });
  });

  group('the page as text', () {
    test('keeps every word and figure, in order, and drops the rest', () {
      final List<String> lines = <String>[
        for (final TaxDocumentLine l in taxDocumentLines(_page)) '$l',
      ];
      expect(lines, <String>[
        'Tax Invoice',
        'No. PX/2627/000001 · Date 21 Nov 2026',
        'Plexaverse Technologies & Co.',
        '12 MG Road, Pune',
        'GSTIN 27AAAAA0000A1Z5 · State 27-Maharashtra',
        "Billed to: o'neil@example.com (unregistered)",
        'Place of supply: 29-Karnataka',
        'Tax payable on reverse charge: No',
        'Plexaverse Personal plan, 1 month',
        'SAC 998314',
        'Plan period: 16 Dec 2026 – 15 Jan 2027',
        'Taxable value\t₹338.14',
        'IGST @ 18%\t₹60.86',
        'Total (incl. GST)\t₹399.00',
        'Paid by UPI AutoPay on 21 Nov 2026 · Payment pay_123',
        'Amounts in Indian rupees. This is a computer-generated document '
            'and needs no signature.',
      ]);
      expect(taxDocumentLines(_page).first.heading, isTrue);
      // The page's own print button, its title and its CSS are not content.
      final String all = lines.join('\n');
      expect(all, isNot(contains('Print or save as PDF')));
      expect(all, isNot(contains('window.print')));
      expect(all, isNot(contains('@media')));
    });

    test('entities decode once — escaped text stays text', () {
      expect(
        taxDocumentLines(
          '<div>&amp;lt;b&amp;gt; &lt;i&gt; &#8377;1 &#x20B9;2</div>',
        ).single.text,
        '&lt;b&gt; <i> ₹1 ₹2',
      );
    });

    test('a document amount always has two places, Indian grouping', () {
      expect(documentRupees(39900), '₹399.00');
      expect(documentRupees(33814), '₹338.14');
      expect(documentRupees(100), '₹1.00');
      expect(documentRupees(5), '₹0.05');
      expect(documentRupees(12345678), '₹1,23,456.78');
    });
  });

  group('Settings → Billing', () {
    testWidgets('no documents: the list is not there at all', (
      WidgetTester tester,
    ) async {
      final _Invoices repo = _Invoices();
      await _pumpSection(tester, repo);
      final List<String> text = texts(tester);
      expect(repo.listReads, 1);
      expect(text, isNot(contains('TAX INVOICES')));
      expect(text, isNot(contains('Tax invoice')));
      expect(text, isNot(contains('We could not load your invoices.')));
      // The section itself is unchanged.
      expect(text, contains('Billing'));
    });

    testWidgets('each document: its kind, number, date and amount', (
      WidgetTester tester,
    ) async {
      await _pumpSection(
        tester,
        _Invoices(documents: <TaxDocument>[_creditNote, _invoice, _voucher]),
      );
      final List<String> text = texts(tester);
      expect(text, contains('TAX INVOICES'));
      for (final String s in <String>[
        'Tax invoice',
        'PX/2627/000001',
        '21 Nov',
        'Credit note',
        'PXC/2627/000001',
        '22 Nov',
        'Refund voucher',
        'PXR/2627/000001',
        '20 Nov',
        '₹1.00',
      ]) {
        expect(text, contains(s));
      }
      expect(text.where((String l) => l == '₹399.00'), hasLength(2));
      // Newest first, as the server sent them — never re-sorted here.
      expect(
        text.indexOf('Credit note'),
        lessThan(text.indexOf('Tax invoice')),
      );
      expect(
        text.indexOf('Tax invoice'),
        lessThan(text.indexOf('Refund voucher')),
      );
    });

    testWidgets('an unreadable list says so and tries again', (
      WidgetTester tester,
    ) async {
      final _Invoices repo = _Invoices(
        documents: <TaxDocument>[_invoice],
        listFails: 1,
      );
      await _pumpSection(tester, repo);
      expect(texts(tester), contains('We could not load your invoices.'));
      expect(texts(tester), isNot(contains('TAX INVOICES')));

      // The section's only retry: the mandate read did not fail.
      final Finder retry = find.text('Try again');
      expect(retry, findsOneWidget);
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pump();
      await tester.pump();
      expect(repo.listReads, 2);
      expect(texts(tester), contains('TAX INVOICES'));
      expect(texts(tester), contains('PX/2627/000001'));
    });

    testWidgets('a document opens in the app, read with the app client, and '
        'its page goes to the share sheet', (WidgetTester tester) async {
      final _Invoices repo = _Invoices(documents: <TaxDocument>[_invoice]);
      final _Sharing sharing = _Sharing();
      await _pumpSection(tester, repo, sharing: sharing);
      await _open(tester, 'PX/2627/000001');

      expect(repo.pageReads, <String>['inv_1']);
      final List<String> text = texts(tester);
      expect(text, contains('TAX INVOICE'));
      expect(text, contains('Taxable value'));
      expect(text, contains('₹338.14'));
      expect(text, contains('IGST @ 18%'));
      expect(text, contains('Total (incl. GST)'));
      expect(text, contains('Save or share'));
      expect(text, isNot(contains('Print or save as PDF')));

      await tester.tap(find.text('Save or share'));
      await tester.pump();
      await tester.pump();
      expect(sharing.files.single.$1, 'PX-2627-000001.html');
      // The real page, not the text read from it.
      expect(sharing.files.single.$2, _page);
    });

    testWidgets('a document that will not load shows an error and a retry, '
        'and nothing to share', (WidgetTester tester) async {
      final _Invoices repo = _Invoices(
        documents: <TaxDocument>[_invoice],
        pageFails: 1,
      );
      final _Sharing sharing = _Sharing();
      await _pumpSection(tester, repo, sharing: sharing);
      await _open(tester, 'PX/2627/000001');

      List<String> text = texts(tester);
      expect(text, contains('We could not load this document.'));
      expect(text, isNot(contains('Save or share')));
      expect(text, isNot(contains('Taxable value')));

      final Finder retry = find.descendant(
        of: find.byType(DraggableScrollableSheet),
        matching: find.text('Try again'),
      );
      await tester.tap(retry);
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(repo.pageReads, <String>['inv_1', 'inv_1']);
      text = texts(tester);
      expect(text, isNot(contains('We could not load this document.')));
      expect(text, contains('Taxable value'));
      expect(text, contains('Save or share'));
      expect(sharing.files, isEmpty);
    });
  });
}
