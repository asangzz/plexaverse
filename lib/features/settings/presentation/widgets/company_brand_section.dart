import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
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

  bool _saving = false;

  @override
  void dispose() {
    _industry.dispose();
    _website.dispose();
    _tagline.dispose();
    _description.dispose();
    _features.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(preferencesControllerProvider.notifier)
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
          );
      if (mounted) {
        showSettingsMessage(
          context,
          'Company brand details saved — your posts will use them.',
        );
      }
    } on Object {
      if (mounted) {
        showSettingsMessage(context, 'Failed to save company brand details.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              label: _saving ? 'Saving...' : 'Save brand details',
              busy: _saving,
              onPressed: _saving ? null : _save,
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
          const UnavailableNote(
            title: 'Logo, poster style and template',
            message:
                'Editing your brand logo, poster colours and poster template '
                'is not in the app yet — each needs a picker this build does '
                'not ship. They stay editable in the web app, and generated '
                'posters keep using whatever is saved there.',
          ),
        ],
      ),
    );
  }
}
