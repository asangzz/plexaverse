import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_write_controller.dart';
import 'settings_section.dart';

/// **Approval Channel** — where the daily post goes for your sign-off.
///
/// The web renders two big radio cards (Slack 💬 / WhatsApp 📱) and a separate
/// "Save Preference" button. Zave's selection language is the inverting chip,
/// so these are chips — and since a chip tap IS the choice, it saves on tap
/// rather than parking the decision behind a second button.
///
/// WhatsApp is UI-only on the web too: the column accepts
/// `slack | whatsapp | email` and nothing delivers to WhatsApp yet. It is kept
/// because removing it would silently change a stored value users have already
/// chosen.
class ApprovalChannelSection extends ConsumerWidget {
  const ApprovalChannelSection({required this.preferences, super.key});

  final UserPreferences preferences;

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    String channel,
  ) async {
    final SettingsWriteController writes = ref.read(
      settingsWriteControllerProvider.notifier,
    );
    // Same second belt the original carried: a chip tap IS the save, so a
    // double tap must not become two writes.
    if (writes.isBusy(SettingsWrite.approvalChannel)) return;
    if (channel == preferences.approvalChannel) return;
    final String? failure = await writes.saveApprovalChannel(channel);
    if (!context.mounted) return;
    showSettingsMessage(context, failure ?? 'Profile updated successfully!');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String current = preferences.approvalChannel;
    final bool saving = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.approvalChannel),
      ),
    );

    return SettingsSection(
      title: 'Approval Channel',
      lead: 'Where Plexaverse asks you to approve tomorrow’s post.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              ZaveChip(
                label: 'Slack',
                icon: const Icon(Icons.tag),
                selected: current == 'slack',
                onTap: saving ? null : () => _select(context, ref, 'slack'),
              ),
              ZaveChip(
                label: 'WhatsApp',
                icon: const Icon(Icons.chat_bubble_outline),
                selected: current == 'whatsapp',
                onTap: saving ? null : () => _select(context, ref, 'whatsapp'),
              ),
              ZaveChip(
                label: 'Email',
                icon: const Icon(Icons.mail_outline),
                selected: current == 'email',
                onTap: saving ? null : () => _select(context, ref, 'email'),
              ),
            ],
          ),
          if (current == 'whatsapp') ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            const UnavailableNote(
              message:
                  'WhatsApp delivery is not built yet — the preference is '
                  'stored, but approvals will not arrive there. Slack and '
                  'email are the two that deliver today.',
            ),
          ],
        ],
      ),
    );
  }
}
