import '../../../../core/ui/zave/zave_kit.dart';
import 'package:flutter/material.dart';

import '../../domain/persona_repository.dart';
import 'persona_chrome.dart';

/// **Who you are** — the read-only mirror of everything Plexa writes from.
///
/// The field list differs by brand, exactly as the web's does: a company brand
/// gets four fields about the company, a personal brand gets seven about the
/// person. Both then get "Voice".
///
/// Voice is the one row that cannot be filled. The web reads a style-sample
/// count off `getPersona()`; the mobile API has `POST /ai/style-memory` (write
/// a sample) but nothing that counts them, so the row states that instead of
/// printing a zero — "learned from 0 samples" and "we cannot see how many
/// samples you have" are different claims, and only the second is true.
class IdentitySection extends StatelessWidget {
  const IdentitySection({
    required this.identity,
    required this.voiceSampleCount,
    super.key,
  });

  final PersonaIdentity identity;

  /// How many writing samples the style memory holds.
  final int voiceSampleCount;

  @override
  Widget build(BuildContext context) {
    return PersonaSection(
      title: 'Who you are',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...(identity.isCompany ? _companyFields() : _personalFields()),
          const PersonaDivider(),
          PersonaField(
            label: 'Voice',
            child: Text(
              voiceSampleCount == 0
                  ? 'No writing samples yet — Plexa is writing in a general '
                        'voice until you give it one.'
                  : 'Learned from $voiceSampleCount of your own '
                        '${voiceSampleCount == 1 ? 'sample' : 'samples'}.',
              style: ZaveType.body,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _companyFields() => <Widget>[
    PersonaField(label: 'Company', value: identity.companyName),
    const PersonaDivider(),
    PersonaField(label: 'Industry', value: identity.companyIndustry),
    const PersonaDivider(),
    PersonaField(label: 'What you do', value: identity.companyDescription),
    const PersonaDivider(),
    PersonaField(
      label: 'Products',
      child: PersonaChips(items: identity.companyFeatures),
    ),
  ];

  List<Widget> _personalFields() => <Widget>[
    PersonaField(label: 'Name', value: identity.name),
    const PersonaDivider(),
    PersonaField(label: 'Role', value: identity.profession),
    const PersonaDivider(),
    PersonaField(label: 'Headline', value: identity.headline),
    const PersonaDivider(),
    PersonaField(label: 'Industry', value: identity.industry),
    const PersonaDivider(),
    PersonaField(
      label: 'Expertise',
      // The web caps this at ten. Beyond that the run stops being a summary
      // and starts being a list.
      child: PersonaChips(items: identity.skills.take(10).toList()),
    ),
    const PersonaDivider(),
    PersonaField(label: 'Working toward', value: identity.workingToward),
    const PersonaDivider(),
    PersonaField(
      label: 'Topics',
      child: PersonaChips(items: identity.topics),
    ),
  ];
}
