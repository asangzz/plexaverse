import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_write_controller.dart';
import 'settings_section.dart';

/// **Profile Details** — the web's first Settings section.
///
/// Two fields that between them decide how every generated post introduces the
/// user: the profession the AI writes *as*, and the headline it writes *under*.
/// The web's labels, placeholders and result strings are reproduced verbatim.
class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  late final TextEditingController _profession = TextEditingController(
    text: widget.preferences.profession ?? '',
  );
  late final TextEditingController _headline = TextEditingController(
    text: widget.preferences.headline ?? '',
  );

  @override
  void dispose() {
    _profession.dispose();
    _headline.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String? failure = await ref
        .read(settingsWriteControllerProvider.notifier)
        .saveProfile(
          profession: _profession.text.trim(),
          headline: _headline.text.trim(),
        );
    if (!mounted) return;
    showSettingsMessage(context, failure ?? 'Profile updated successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final bool saving = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.profile),
      ),
    );

    return SettingsSection(
      title: 'Profile Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZaveField(
            controller: _profession,
            label: 'Profession / Title',
            hint: 'e.g. Mobile Application Developer',
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _headline,
            label: 'LinkedIn Headline',
            hint: 'e.g. Building next-gen apps 🚀',
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerRight,
            child: ZaveButton(
              label: saving ? 'Saving...' : 'Save Changes',
              busy: saving,
              onPressed: saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

/// **Brand** — personal or company.
///
/// A deliberate addition. The web sets `brandType` during onboarding and never
/// offers it again, so a user who picked wrong has to ask support. It is one
/// PATCH against a field the mobile API already accepts, and it decides which
/// navigation, which compose screen and which half of this page the user sees —
/// which makes hiding it the expensive choice, not the safe one.
class BrandTypeSection extends ConsumerWidget {
  const BrandTypeSection({required this.preferences, super.key});

  final UserPreferences preferences;

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    String brandType,
  ) async {
    final SettingsWriteController writes = ref.read(
      settingsWriteControllerProvider.notifier,
    );
    // The chips are already nulled while a save is open; this is the second
    // belt the original carried, kept because a chip tap is the save here.
    if (writes.isBusy(SettingsWrite.brandType)) return;
    if (brandType == preferences.brandType) return;
    final String? failure = await writes.saveBrandType(brandType);
    if (!context.mounted) return;
    showSettingsMessage(
      context,
      failure ??
          (brandType == 'company'
              ? 'Switched to your company brand.'
              : 'Switched to your personal brand.'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? current = preferences.brandType;
    final bool saving = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.brandType),
      ),
    );

    return SettingsSection(
      title: 'Brand',
      lead:
          'Who Plexaverse writes for. This decides your navigation, your '
          'compose screen, and which sections appear below.',
      child: Wrap(
        spacing: ZaveSpace.sm,
        runSpacing: ZaveSpace.sm,
        children: <Widget>[
          ZaveChip(
            label: 'Personal',
            selected: current == 'personal',
            onTap: saving ? null : () => _select(context, ref, 'personal'),
          ),
          ZaveChip(
            label: 'Company',
            selected: current == 'company',
            onTap: saving ? null : () => _select(context, ref, 'company'),
          ),
        ],
      ),
    );
  }
}
