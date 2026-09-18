import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
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
class ApprovalChannelSection extends ConsumerStatefulWidget {
  const ApprovalChannelSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  ConsumerState<ApprovalChannelSection> createState() =>
      _ApprovalChannelSectionState();
}

class _ApprovalChannelSectionState
    extends ConsumerState<ApprovalChannelSection> {
  bool _saving = false;

  Future<void> _select(String channel) async {
    if (_saving || channel == widget.preferences.approvalChannel) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(preferencesControllerProvider.notifier)
          .saveApprovalChannel(channel);
      if (mounted) showSettingsMessage(context, 'Profile updated successfully!');
    } on Object {
      if (mounted) showSettingsMessage(context, 'Failed to update profile.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String current = widget.preferences.approvalChannel;

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
                onTap: _saving ? null : () => _select('slack'),
              ),
              ZaveChip(
                label: 'WhatsApp',
                icon: const Icon(Icons.chat_bubble_outline),
                selected: current == 'whatsapp',
                onTap: _saving ? null : () => _select('whatsapp'),
              ),
              ZaveChip(
                label: 'Email',
                icon: const Icon(Icons.mail_outline),
                selected: current == 'email',
                onTap: _saving ? null : () => _select('email'),
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
