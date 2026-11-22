// The user's GST documents — tax invoices, credit notes and refund vouchers
// for UPI AutoPay payments (TOKEN_AUTOPAY_SPEC.md §5.9) — as the app sees
// them: the rows of `GET /billing/invoices`, and the printable page of one
// (`GET /billing/invoices/[id]`) read as text.
//
// The server is the only author of every figure here. A document is issued
// inside the ledger's own transaction, numbered from a gapless counter and
// GST-split to the paisa; the app shows those numbers and never computes one.

/// Which document a row is. The web's `TaxDocumentKind`, plus [other] for a
/// kind this build does not know yet: a user's tax document must never
/// vanish from their list because the app is older than the server.
enum TaxDocumentKind {
  invoice,
  creditNote,
  refundVoucher,
  other;

  static TaxDocumentKind parse(Object? v) => switch (v) {
    'invoice' => TaxDocumentKind.invoice,
    'credit_note' => TaxDocumentKind.creditNote,
    'refund_voucher' => TaxDocumentKind.refundVoucher,
    _ => TaxDocumentKind.other,
  };

  /// The web's `InvoiceList` labels, word for word.
  String get label => switch (this) {
    TaxDocumentKind.invoice => 'Tax invoice',
    TaxDocumentKind.creditNote => 'Credit note',
    TaxDocumentKind.refundVoucher => 'Refund voucher',
    TaxDocumentKind.other => 'Tax document',
  };
}

/// One line of Settings → Billing → Tax invoices: the web's
/// `BillingInvoiceSummary`.
class TaxDocument {
  const TaxDocument({
    required this.id,
    required this.kind,
    required this.number,
    required this.issuedAt,
    required this.totalPaise,
    this.periodFrom,
    this.periodTo,
  });

  /// A row, or null when it lacks what the list needs to show it AND open
  /// it: an id, a number, an issue date and a total. Showing a document
  /// with a made-up amount, or one that cannot be opened, is worse than
  /// leaving out a row the server sent malformed.
  static TaxDocument? fromJson(Object? json) {
    if (json is! Map) return null;
    final Object? id = json['id'];
    final Object? number = json['number'];
    final Object? issued = json['issuedAt'];
    final Object? total = json['totalPaise'];
    if (id is! String || id.isEmpty) return null;
    if (number is! String || number.isEmpty) return null;
    final DateTime? issuedAt = issued is String
        ? DateTime.tryParse(issued)
        : null;
    if (issuedAt == null) return null;
    if (total is! num || !total.isFinite) return null;
    return TaxDocument(
      id: id,
      kind: TaxDocumentKind.parse(json['kind']),
      number: number,
      issuedAt: issuedAt,
      totalPaise: total.toInt(),
      periodFrom: _instant(json['periodFrom']),
      periodTo: _instant(json['periodTo']),
    );
  }

  /// The body of `GET /billing/invoices` — `{ invoices: [...] }`, newest
  /// first, in the server's order.
  ///
  /// THROWS [FormatException] when `invoices` is not a list: "the read said
  /// nothing" must not look like "you have no documents".
  static List<TaxDocument> listFromJson(Map<String, dynamic> data) {
    final Object? rows = data['invoices'];
    if (rows is! List) {
      throw const FormatException('billing/invoices sent no list');
    }
    return <TaxDocument>[
      for (final Object? row in rows) ?TaxDocument.fromJson(row),
    ];
  }

  final String id;
  final TaxDocumentKind kind;

  /// `PX/2627/000123` — the document's own number, from the server.
  final String number;
  final DateTime issuedAt;

  /// GST-inclusive, in paise, as issued.
  final int totalPaise;
  final DateTime? periodFrom;
  final DateTime? periodTo;

  /// The file the share sheet hands over: the web's download name
  /// (`PX-2627-000123.html`) — a slash cannot be in a file name.
  String get fileName => '${number.replaceAll('/', '-')}.html';
}

DateTime? _instant(Object? v) => v is String ? DateTime.tryParse(v) : null;

/// `₹399.00`, `₹1,199.00`, `₹338.14` — a document amount as the web's
/// `InvoiceList` writes it: Indian grouping and always two places, because
/// on a tax document ₹338.14 and ₹338.1 are not the same kind of figure.
String documentRupees(int paise) {
  final bool negative = paise < 0;
  final int abs = paise.abs();
  final String fraction = (abs % 100).toString().padLeft(2, '0');
  return '${negative ? '-' : ''}₹${_indianGrouping((abs ~/ 100).toString())}'
      '.$fraction';
}

String _indianGrouping(String digits) {
  if (digits.length <= 3) return digits;
  final String last3 = digits.substring(digits.length - 3);
  String rest = digits.substring(0, digits.length - 3);
  final List<String> pairs = <String>[];
  while (rest.length > 2) {
    pairs.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) pairs.insert(0, rest);
  return '${pairs.join(',')},$last3';
}

/// One line of a document read as text: a heading, a sentence, or a label
/// with its amount (a table row of the printable page).
class TaxDocumentLine {
  const TaxDocumentLine(this.text, {this.value, this.heading = false});

  final String text;

  /// The right-hand cell of a table row — an amount — when there is one.
  final String? value;
  final bool heading;

  @override
  String toString() => value == null ? text : '$text\t$value';
}

/// The printable page (`renderTaxDocumentHtml` on the server) as lines of
/// text.
///
/// **This is a fallback, and it is here because the app has no HTML view.**
/// It depends on no web view or HTML package, so it cannot lay the page out:
/// it keeps every word and figure the page carries, in order, and drops the
/// styling, the `<head>` and the page's own "Print or save as PDF" button
/// (which only a browser can press). The real page is what the share sheet
/// hands over.
///
/// Everything the server puts in the page is escaped there, so entity
/// decoding here only restores text; nothing in it is ever run.
List<TaxDocumentLine> taxDocumentLines(String html) {
  String s = html;
  final RegExp dropBlocks = RegExp(
    r'<!--.*?-->|<head\b.*?</head>|<style\b.*?</style>|<script\b.*?</script>'
    r'|<button\b.*?</button>|<title\b.*?</title>',
    caseSensitive: false,
    dotAll: true,
  );
  s = s.replaceAll(dropBlocks, '');
  // A table row's cells: label, then amount.
  s = s.replaceAll(
    RegExp(r'</t[dh]>\s*<t[dh]\b[^>]*>', caseSensitive: false),
    _cell,
  );
  // Headings are marked so the reader can set them apart.
  s = s.replaceAll(
    RegExp(r'<h[1-3]\b[^>]*>', caseSensitive: false),
    '\n$_head',
  );
  s = s.replaceAll(
    RegExp(
      r'<br\s*/?>|</?(?:div|p|h[1-6]|tr|table|tbody|thead|li|ul|ol|section'
      r'|header|footer|body|html)\b[^>]*>',
      caseSensitive: false,
    ),
    '\n',
  );
  s = s.replaceAll(RegExp(r'<[^>]*>'), '');
  s = _decodeEntities(s);

  final List<TaxDocumentLine> lines = <TaxDocumentLine>[];
  for (final String raw in s.split('\n')) {
    final bool heading = raw.contains(_head);
    final List<String> cells = <String>[
      for (final String c in raw.replaceAll(_head, '').split(_cell))
        if (_squash(c).isNotEmpty) _squash(c),
    ];
    if (cells.isEmpty) continue;
    lines.add(
      cells.length == 1
          ? TaxDocumentLine(cells.single, heading: heading)
          : TaxDocumentLine(
              cells.sublist(0, cells.length - 1).join(' '),
              value: cells.last,
              heading: heading,
            ),
    );
  }
  return lines;
}

/// Private-use characters: they cannot occur in the server's page, whose
/// text is plain escaped prose and figures.
const String _cell = '';
const String _head = '';

String _squash(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

String _decodeEntities(String s) => s
    .replaceAllMapped(RegExp(r'&#(\d+);'), (Match m) {
      final int? code = int.tryParse(m[1]!);
      return code == null || code > 0x10FFFF
          ? m[0]!
          : String.fromCharCode(code);
    })
    .replaceAllMapped(RegExp(r'&#[xX]([0-9a-fA-F]+);'), (Match m) {
      final int? code = int.tryParse(m[1]!, radix: 16);
      return code == null || code > 0x10FFFF
          ? m[0]!
          : String.fromCharCode(code);
    })
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    // Last, so `&amp;lt;` reads as the text `&lt;`, not as `<`.
    .replaceAll('&amp;', '&');
