import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../settings/domain/settings_repository.dart';
import '../../domain/onboarding_inputs.dart';
import 'onboarding_chrome.dart';
import 'reply_lane.dart';

/// The web's dropzones (`CVDropzone`, `SingleImageDropzone`, `ImageDropzone`),
/// for a phone: one tile that opens the picker, and a skip under it when the
/// step is optional.
///
/// The titles say "Choose" where the web says "Drop": nothing is dragged on a
/// phone, and a tile that invites a gesture the device cannot make reads as
/// broken. The hints — format, size, required — are the web's.
class UploadPanel extends StatelessWidget {
  const UploadPanel({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onPick,
    this.skipLabel,
    this.onSkip,
    super.key,
  });

  final IconData icon;
  final String title;
  final String hint;

  /// Null while the previous upload is still being read.
  final VoidCallback? onPick;

  /// No skip means the step is required (the company logo).
  final String? skipLabel;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(
          button: true,
          enabled: onPick != null,
          child: ZavePress(
            enabled: onPick != null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPick,
              child: Container(
                padding: EdgeInsets.all(ZaveSpace.lg),
                decoration: BoxDecoration(
                  color: ZaveGlass.controlFill,
                  border: Border.all(color: ZaveGlass.controlBorder),
                  borderRadius: ZaveRadius.inputBr,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(icon, color: ZaveColors.ink85, size: 22),
                    SizedBox(width: ZaveSpace.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: ZaveType.label.copyWith(
                              color: ZaveColors.white,
                            ),
                          ),
                          SizedBox(height: ZaveSpace.xs),
                          Text(hint, style: ZaveType.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (onSkip != null && skipLabel != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Align(
            alignment: Alignment.centerRight,
            child: ReplySkipChip(label: skipLabel!, onTap: onSkip),
          ),
        ],
      ],
    );
  }
}

/// The web's `CompanyPagePicker`: the pages the connected account manages.
///
/// A company brand must be grounded in a real page, so there is no "set it up
/// later" here. When no page can be used, the only ways forward are the web's
/// two: connect a different company account, or switch to a personal brand.
class CompanyPagePanel extends StatefulWidget {
  const CompanyPagePanel({
    required this.load,
    required this.onPick,
    required this.onReconnect,
    required this.onSwitchToPersonal,
    super.key,
  });

  final Future<CompanyPageOptions> Function() load;
  final void Function(String id, String name) onPick;
  final VoidCallback onReconnect;
  final VoidCallback onSwitchToPersonal;

  @override
  State<CompanyPagePanel> createState() => _CompanyPagePanelState();
}

class _CompanyPagePanelState extends State<CompanyPagePanel> {
  late final Future<CompanyPageOptions> _pages = widget.load();

  Widget _options() => Wrap(
    spacing: ZaveSpace.sm,
    runSpacing: ZaveSpace.sm,
    children: <Widget>[
      ReplyChip(label: 'Another company profile', onTap: widget.onReconnect),
      ReplyChip(
        label: 'Switch to personal brand',
        onTap: widget.onSwitchToPersonal,
      ),
    ],
  );

  Widget _note(String text, {bool warn = false}) => Text(
    text,
    style: ZaveType.caption.copyWith(
      color: warn ? ZaveColors.amber : ZaveColors.ink62,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanyPageOptions>(
      future: _pages,
      builder: (BuildContext context, AsyncSnapshot<CompanyPageOptions> snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const DockHint(
            text: 'Pulling your company pages from LinkedIn…',
          );
        }
        final CompanyPageOptions? options = snap.data;
        final String? error = snap.hasError
            ? 'Failed to fetch company pages.'
            : (options?.needsManualInput ?? false)
            ? (options?.message ??
                  'LinkedIn needs reconnecting with company permissions.')
            : null;
        if (error != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _note(error, warn: true),
              SizedBox(height: ZaveSpace.md),
              _options(),
            ],
          );
        }
        final List<CompanyPage> pages = options?.pages ?? const <CompanyPage>[];
        if (pages.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _note(
                "This LinkedIn account doesn't manage any Company Pages. "
                'Connect a different account that admins a Company Page, or '
                'switch to a Personal brand.',
              ),
              SizedBox(height: ZaveSpace.md),
              _options(),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final CompanyPage page in pages) ...<Widget>[
              _PageRow(
                page: page,
                onTap: () => widget.onPick(page.id, page.name),
              ),
              SizedBox(height: ZaveSpace.sm),
            ],
            SizedBox(height: ZaveSpace.sm),
            _note('Not the page you wanted?'),
            SizedBox(height: ZaveSpace.sm),
            _options(),
          ],
        );
      },
    );
  }
}

class _PageRow extends StatelessWidget {
  const _PageRow({required this.page, required this.onTap});

  final CompanyPage page;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ZavePress(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ZaveSpace.lg,
              vertical: ZaveSpace.md,
            ),
            decoration: BoxDecoration(
              color: ZaveGlass.controlFill,
              border: Border.all(color: ZaveGlass.controlBorder),
              borderRadius: ZaveRadius.inputBr,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        page.name,
                        style: ZaveType.label.copyWith(color: ZaveColors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ZaveSpace.xs),
                      Text('COMPANY PAGE', style: ZaveType.kicker),
                    ],
                  ),
                ),
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

/// The web's `CompanyDetailsForm` — everything a company document did not
/// say, prefilled with what it did.
///
/// The same four requirements as the web: a real description (40+
/// characters), an industry, at least one product or service, and a website.
/// The tagline is optional.
class CompanyDetailsPanel extends StatefulWidget {
  const CompanyDetailsPanel({
    required this.doc,
    required this.onSubmit,
    super.key,
  });

  final CompanyDoc? doc;
  final void Function({
    required String description,
    required String industry,
    required String tagline,
    required List<String> features,
    required String website,
  })
  onSubmit;

  @override
  State<CompanyDetailsPanel> createState() => _CompanyDetailsPanelState();
}

class _CompanyDetailsPanelState extends State<CompanyDetailsPanel> {
  late final TextEditingController _description = TextEditingController(
    text: widget.doc?.description ?? '',
  );
  late final TextEditingController _industry = TextEditingController(
    text:
        widget.doc != null &&
            !kGenericIndustry.contains(
              widget.doc!.industry.trim().toLowerCase(),
            )
        ? widget.doc!.industry
        : '',
  );
  late final TextEditingController _features = TextEditingController(
    text: (widget.doc?.features ?? const <String>[]).join('\n'),
  );
  late final TextEditingController _website = TextEditingController(
    text: widget.doc?.website ?? '',
  );
  late final TextEditingController _tagline = TextEditingController(
    text: widget.doc?.tagline ?? '',
  );

  @override
  void dispose() {
    _description.dispose();
    _industry.dispose();
    _features.dispose();
    _website.dispose();
    _tagline.dispose();
    super.dispose();
  }

  List<String> get _featureList => _features.text
      .split('\n')
      .map((String f) => f.trim())
      .where((String f) => f.isNotEmpty)
      .toList();

  bool get _canSubmit =>
      _description.text.trim().length >= 40 &&
      _industry.text.trim().length >= 2 &&
      _featureList.isNotEmpty &&
      _website.text.trim().length >= 3;

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: ZaveSpace.xs),
    child: Text(text.toUpperCase(), style: ZaveType.kicker),
  );

  @override
  Widget build(BuildContext context) {
    void changed(String _) => setState(() {});
    final int description = _description.text.trim().length;
    final int features = _featureList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _label('What your company does'),
        ZaveField(
          controller: _description,
          hint:
              "What you build, who it's for, and what makes you different "
              '(1-2 sentences)…',
          minLines: 2,
          maxLines: 4,
          onChanged: changed,
        ),
        if (description > 0 && description < 40) ...<Widget>[
          SizedBox(height: ZaveSpace.xs),
          Text(
            'A little more detail helps — aim for a full sentence.',
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
        ],
        SizedBox(height: ZaveSpace.md),
        _label('Industry'),
        ZaveField(
          controller: _industry,
          hint: 'e.g. AI software, B2B SaaS, FinTech, Healthcare',
          onChanged: changed,
        ),
        SizedBox(height: ZaveSpace.md),
        _label('Products & services (one per line)'),
        ZaveField(
          controller: _features,
          hint: 'The specific things you offer, one per line',
          minLines: 2,
          maxLines: 5,
          onChanged: changed,
        ),
        SizedBox(height: ZaveSpace.xs),
        Text(
          features > 0
              ? '$features feature${features > 1 ? 's' : ''} — these anchor '
                    'your posts & poster callouts.'
              : 'Add at least one product or service.',
          style: ZaveType.caption,
        ),
        SizedBox(height: ZaveSpace.md),
        _label('Website'),
        ZaveField(
          controller: _website,
          hint: 'e.g. www.yourcompany.com',
          onChanged: changed,
        ),
        SizedBox(height: ZaveSpace.md),
        _label('Tagline (optional)'),
        ZaveField(
          controller: _tagline,
          hint: 'Short positioning line (optional)',
          onChanged: changed,
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveButton.primary(
          label: 'Save & continue',
          expand: true,
          onPressed: _canSubmit
              ? () => widget.onSubmit(
                  description: _description.text,
                  industry: _industry.text,
                  tagline: _tagline.text,
                  features: _featureList,
                  website: _website.text,
                )
              : null,
        ),
      ],
    );
  }
}
