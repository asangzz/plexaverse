import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_write_controller.dart';
import 'settings_section.dart';

/// **Company Brand Details** — company-brand users only.
///
/// These five fields are what every company post is written *from*: without
/// them the generator has a page name and nothing else, and the output reads
/// like it. The web says so in its own sub-copy, reproduced here verbatim.
///
/// The web's sibling controls in this block — Brand Logo, Poster Style and
/// Poster Template — are not ported. The logo needs an image picker, the poster
/// style needs a colour picker, and neither package is in this app's pubspec;
/// the template picker needs the Studio designs list. All three are reported
/// rather than faked.
class CompanyBrandSection extends ConsumerStatefulWidget {
  const CompanyBrandSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  ConsumerState<CompanyBrandSection> createState() =>
      _CompanyBrandSectionState();
}

class _CompanyBrandSectionState extends ConsumerState<CompanyBrandSection> {
  late final TextEditingController _industry = TextEditingController(
    text: widget.preferences.companyIndustry ?? '',
  );
  late final TextEditingController _website = TextEditingController(
    text: widget.preferences.companyWebsite ?? '',
  );
  late final TextEditingController _tagline = TextEditingController(
    text: widget.preferences.companyTagline ?? '',
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.preferences.companyDescription ?? '',
  );

  /// One feature per line — the same shape the web's textarea uses, and the
  /// same shape the generator reads.
  late final TextEditingController _features = TextEditingController(
    text: widget.preferences.companyFeatures.join('\n'),
  );

  @override
  void dispose() {
    _industry.dispose();
    _website.dispose();
    _tagline.dispose();
    _description.dispose();
    _features.dispose();
    _primary.dispose();
    _secondary.dispose();
    super.dispose();
  }

  /// Seeded from what is saved, like every other field here — a style
  /// editor that opens blank reads as "nothing is set" rather than showing
  /// the user what their posters currently use.
  late String _posterTheme = widget.preferences.posterTheme;
  late final TextEditingController _primary = TextEditingController(
    text: widget.preferences.posterPrimaryColor ?? '',
  );
  late final TextEditingController _secondary = TextEditingController(
    text: widget.preferences.posterSecondaryColor ?? '',
  );

  /// `#RRGGBB`, upper-cased, `#` restored — or null for "leave it to the
  /// product default". Anything that is not six hex digits is treated as
  /// unset rather than sent, because the server composites with it and a
  /// malformed value would produce a poster nobody chose.
  static String? _hex(String raw) {
    final String v = raw.trim().replaceAll('#', '').toUpperCase();
    if (v.isEmpty) return null;
    return RegExp(r'^[0-9A-F]{6}$').hasMatch(v) ? '#$v' : null;
  }

  /// Picks a logo, uploads it, and saves the URL immediately.
  ///
  /// Saved on pick rather than folded into the Save button: the upload has
  /// already happened by then, and leaving the URL unsaved would mean a file
  /// sitting in storage that nothing references if the user backs out.
  ///
  /// The whole pick-upload-save sits on the controller. Half of it here was
  /// what let the saved URL exist in two places at once — the preferences row
  /// and a widget field — and the widget's copy is the one that can be stale.
  Future<void> _pickLogo() async {
    final String? note = await ref
        .read(settingsWriteControllerProvider.notifier)
        .pickAndSaveCompanyLogo();
    if (note == null || !mounted) return;
    showSettingsMessage(context, note);
  }

  Future<void> _save() async {
    final String? failure = await ref
        .read(settingsWriteControllerProvider.notifier)
        .saveCompanyBrand(
          companyIndustry: _industry.text.trim(),
          companyWebsite: _website.text.trim(),
          companyTagline: _tagline.text.trim(),
          companyDescription: _description.text.trim(),
          companyFeatures: _features.text
              .split('\n')
              .map((String line) => line.trim())
              .where((String line) => line.isNotEmpty)
              .toList(growable: false),
          posterTheme: _posterTheme,
          posterPrimaryColor: _hex(_primary.text),
          posterSecondaryColor: _hex(_secondary.text),
        );
    if (!mounted) return;
    showSettingsMessage(
      context,
      failure ?? 'Company brand details saved — your posts will use them.',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read from the preferences row rather than mirrored onto this State: the
    // upload saves it, which republishes the row the whole section renders
    // from, so there is only ever one answer to "is there a logo".
    final String? logoUrl = widget.preferences.companyLogoUrl;
    final bool saving = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.companyBrand),
      ),
    );
    final bool uploadingLogo = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.companyLogo),
      ),
    );

    return SettingsSection(
      title: 'Company Brand Details',
      lead:
          'Used to write your company posts in the right voice. The more '
          'specific, the better your content.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZaveField(
            controller: _industry,
            label: 'Industry',
            hint: 'e.g. DevOps tooling, B2B SaaS, FinTech',
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _website,
            label: 'Website',
            hint: 'Shown on posters, e.g. www.yourcompany.com',
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _tagline,
            label: 'Tagline (optional)',
            hint: 'e.g. Ship reliable infrastructure faster',
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _description,
            label: 'What does your company do?',
            hint:
                'Who do you serve, and what makes you different? '
                '(2–4 sentences)',
            minLines: 3,
            maxLines: 6,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _features,
            label: 'Products & services (one per line)',
            hint: 'PGP in Applied AI\n1:1 mentorship\nJob placement support',
            minLines: 3,
            maxLines: 8,
          ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerRight,
            child: ZaveButton(
              label: saving ? 'Saving...' : 'Save brand details',
              busy: saving,
              onPressed: saving ? null : _save,
            ),
          ),
          const SettingsDivider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  logoUrl == null
                      ? 'No brand logo yet — posters generate without one.'
                      : 'Brand logo set. Posters will use it.',
                  style: ZaveType.caption,
                ),
              ),
              SizedBox(width: ZaveSpace.md),
              ZaveButton(
                label: logoUrl == null ? 'Add logo' : 'Replace',
                busy: uploadingLogo,
                onPressed: uploadingLogo ? null : _pickLogo,
              ),
            ],
          ),
          const SettingsDivider(),
          Text('POSTER STYLE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Dark posters',
                  style: ZaveType.body,
                ),
              ),
              ZaveSwitch(
                value: _posterTheme == 'dark',
                onChanged: (bool dark) =>
                    setState(() => _posterTheme = dark ? 'dark' : 'light'),
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _primary,
            label: 'Primary colour',
            hint: '#7000FF',
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _secondary,
            label: 'Secondary colour',
            hint: '#0F172A',
          ),
          SizedBox(height: ZaveSpace.md),
          // Hex rather than a colour wheel, deliberately: a brand colour is
          // a value the user already has written down somewhere, and typing
          // it is more accurate than finding it on a gradient.
          Text(
            'Six hex digits, with or without the #. Left blank, posters use '
            'the product default.',
            style: ZaveType.caption,
          ),
          SizedBox(height: ZaveSpace.lg),
          // The TEMPLATE picker stays absent, and for a reason worth
          // stating: it needs the Studio designs list, and Studio is
          // admin-gated in v1 — there is nothing for an end user to choose.
          const UnavailableNote(
            title: 'Poster template',
            message:
                'Choosing a saved Plexa Studio design as your poster template '
                'is web-only while Studio itself is admin-only in the app.',
          ),
        ],
      ),
    );
  }
}
