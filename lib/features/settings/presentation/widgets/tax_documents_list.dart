import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/image_sharing.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../pricing/application/pricing_controller.dart';
import '../../../pricing/domain/pricing_repository.dart';
import 'settings_section.dart';

/// Settings → Billing → **Tax invoices**: the user's GST tax invoices, credit
/// notes and refund vouchers (TOKEN_AUTOPAY_SPEC.md §5.9) — the web's
/// `InvoiceList`.
///
/// Renders nothing until there is something to list, so while the rail is
/// dark (no UPI AutoPay payments, no documents) the section looks exactly as
/// it did. Every figure is the server's: the number, the date it was issued,
/// and the GST-inclusive total.
///
/// **A document is opened in the app, never in a browser.** Its route needs
/// the bearer token, so a URL handed to a browser could only 401. The page is
/// fetched through the app's client and shown on [showTaxDocumentSheet].
class TaxDocumentsList extends ConsumerWidget {
  const TaxDocumentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TaxDocument>> documents = ref.watch(
      taxDocumentsProvider,
    );

    if (documents.hasError && !documents.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ..._rule(),
          const UnavailableNote(message: 'We could not load your invoices.'),
          SizedBox(height: ZaveSpace.sm),
          ZaveButton(
            label: 'Try again',
            onPressed: () => ref.invalidate(taxDocumentsProvider),
          ),
        ],
      );
    }

    final List<TaxDocument> list = documents.value ?? const <TaxDocument>[];
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ..._rule(),
        Text('TAX INVOICES', style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.xs),
        for (int i = 0; i < list.length; i++) ...<Widget>[
          if (i > 0) Container(height: 1, color: ZaveColors.rule),
          _DocumentRow(document: list[i]),
        ],
      ],
    );
  }

  /// The divider the mandate panel above uses.
  static List<Widget> _rule() => <Widget>[
    SizedBox(height: ZaveSpace.lg),
    Container(height: 1, color: ZaveColors.rule),
    SizedBox(height: ZaveSpace.lg),
  ];
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final TaxDocument document;

  @override
  Widget build(BuildContext context) {
    final String label = document.kind.label;
    final String amount = documentRupees(document.totalPaise);
    final String issued = istDay(document.issuedAt);

    return Semantics(
      button: true,
      label: '$label ${document.number}, $issued, $amount. Open',
      excludeSemantics: true,
      child: ZavePress(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showTaxDocumentSheet(context, document),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ZaveSpace.md),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: ZaveType.label.copyWith(color: ZaveColors.white),
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text(document.number, style: ZaveType.caption),
                    ],
                  ),
                ),
                SizedBox(width: ZaveSpace.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      amount,
                      style: ZaveType.label.copyWith(color: ZaveColors.white),
                    ),
                    SizedBox(height: ZaveSpace.xs),
                    Text(issued, style: ZaveType.caption),
                  ],
                ),
                SizedBox(width: ZaveSpace.sm),
                const Icon(
                  AppIcons.chevronRight,
                  color: ZaveColors.ink50,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens [document] on a sheet: fetched with the user's token, read as text,
/// and offered whole to the share sheet.
Future<void> showTaxDocumentSheet(BuildContext context, TaxDocument document) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => TaxDocumentSheet(document: document),
    );

/// One tax document, in the app.
///
/// **Text, because the app has no HTML view.** It depends on no web view and
/// no HTML renderer, and none was added for this, so the printable page is
/// read as its words and figures ([taxDocumentLines]). The page itself —
/// the one that prints or saves as PDF — leaves through **Save or share**, as
/// the `.html` file the web's Download link gives.
class TaxDocumentSheet extends ConsumerStatefulWidget {
  const TaxDocumentSheet({required this.document, super.key});

  final TaxDocument document;

  @override
  ConsumerState<TaxDocumentSheet> createState() => _TaxDocumentSheetState();
}

class _TaxDocumentSheetState extends ConsumerState<TaxDocumentSheet> {
  bool _sharing = false;
  String? _shareError;

  Future<void> _share(String html) async {
    setState(() {
      _sharing = true;
      _shareError = null;
    });
    final ShareResult result = await ref
        .read(imageSharingProvider)
        .shareTextFile(
          contents: html,
          fileName: widget.document.fileName,
          text: '${widget.document.kind.label} ${widget.document.number}',
        );
    if (!mounted) return;
    setState(() {
      _sharing = false;
      _shareError = result is ShareFailed
          ? 'We could not open the share sheet. Try again.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TaxDocument document = widget.document;
    final AsyncValue<String> page = ref.watch(
      taxDocumentHtmlProvider(document.id),
    );
    final String? html = page.hasValue && !page.hasError ? page.value : null;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      expand: false,
      builder: (BuildContext ctx, ScrollController scroll) => Container(
        decoration: BoxDecoration(
          gradient: ZaveGround.base,
          border: const Border(
            top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ZaveRadius.cardLg),
          ),
        ),
        padding: EdgeInsets.all(ZaveSpace.gutter),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      document.kind.label.toUpperCase(),
                      style: ZaveType.kicker,
                    ),
                  ),
                  if (html != null)
                    ZaveButton(
                      label: 'Save or share',
                      icon: const Icon(AppIcons.share),
                      busy: _sharing,
                      onPressed: _sharing ? null : () => _share(html),
                    ),
                ],
              ),
              if (_shareError != null) ...<Widget>[
                SizedBox(height: ZaveSpace.sm),
                Semantics(
                  liveRegion: true,
                  child: Text(_shareError!, style: ZaveType.caption),
                ),
              ],
              SizedBox(height: ZaveSpace.lg),
              Expanded(child: _body(page, html, scroll)),
            ],
          ),
        ),
      ),
    );
  }

  /// Always a scroll view on the sheet's own controller, so dragging the
  /// body drags the sheet in every state. A column, not a lazy list: a
  /// document is a page of a few dozen lines, and all of it is the content.
  Widget _body(AsyncValue<String> page, String? html, ScrollController scroll) {
    final List<Widget> children;
    if (page.hasError && !page.isLoading) {
      children = <Widget>[
        const UnavailableNote(message: 'We could not load this document.'),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: 'Try again',
          onPressed: () =>
              ref.invalidate(taxDocumentHtmlProvider(widget.document.id)),
        ),
      ];
    } else if (html == null) {
      children = const <Widget>[SectionSkeleton(lines: 6)];
    } else {
      children = <Widget>[
        Text(
          'Save or share it to print it or keep a PDF.',
          style: ZaveType.caption,
        ),
        SizedBox(height: ZaveSpace.lg),
        for (final TaxDocumentLine line in taxDocumentLines(html))
          Padding(
            padding: EdgeInsets.only(bottom: ZaveSpace.sm),
            child: _Line(line: line),
          ),
      ];
    }
    final Widget body = SingleChildScrollView(
      controller: scroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
    return html == null ? body : SelectionArea(child: body);
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.line});

  final TaxDocumentLine line;

  @override
  Widget build(BuildContext context) {
    final String? value = line.value;
    if (value == null) {
      return Text(line.text, style: line.heading ? ZaveType.h3 : ZaveType.body);
    }
    // A table row of the page: the label, and its amount on the right.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(line.text, style: ZaveType.body)),
        SizedBox(width: ZaveSpace.md),
        Text(value, style: ZaveType.label.copyWith(color: ZaveColors.white)),
      ],
    );
  }
}
