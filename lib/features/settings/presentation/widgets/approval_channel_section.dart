import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
import '../../application/settings_write_controller.dart';
import '../../domain/settings_entities.dart';
import 'settings_section.dart';

/// **Approval Channel** — where the daily post goes for your sign-off.
///
/// The web renders two big radio cards (Slack 💬 / WhatsApp 📱) and a separate
/// "Save Preference" button. Zave's selection language is the inverting chip,
/// so these are chips — and since a chip tap IS the choice, it saves on tap
/// rather than parking the decision behind a second button.
///
/// WhatsApp DOES deliver now — a number is connected under Connected
/// Accounts and the Saturday planner notice goes to it. What this section no
/// longer does is ask for that number: "which way do you want to be told" and
/// "prove this phone is yours" are two different questions, and the web split
/// them for that reason. Choosing WhatsApp here with no number connected says
/// so in one amber line and points at the list above, rather than looking
/// like it worked.
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
                icon: const ZaveBrandMark(ZaveBrand.slack, onColor: true),
                selected: current == 'slack',
                onTap: saving ? null : () => _select(context, ref, 'slack'),
              ),
              ZaveChip(
                label: 'WhatsApp',
                icon: const Icon(AppIcons.comment),
                selected: current == 'whatsapp',
                onTap: saving ? null : () => _select(context, ref, 'whatsapp'),
              ),
              ZaveChip(
                label: 'Email',
                icon: const Icon(AppIcons.email),
                selected: current == 'email',
                onTap: saving ? null : () => _select(context, ref, 'email'),
              ),
            ],
          ),
          // Amber only when the choice cannot be honoured. A note that shows
          // whenever WhatsApp is picked would train people to ignore it, and
          // then it is not there when it matters.
          if (current == 'whatsapp')
            switch (ref.watch(whatsAppControllerProvider)) {
              AsyncData<WhatsAppConnection>(:final WhatsAppConnection value)
                  when !value.isLive =>
                Padding(
                  padding: EdgeInsets.only(top: ZaveSpace.lg),
                  child: UnavailableNote(
                    message: value.optedOut
                        ? 'You told WhatsApp to stop messaging you. Turn it '
                              'back on under Connected Accounts above.'
                        : 'No WhatsApp number is connected yet. Connect one '
                              'under Connected Accounts above and approvals '
                              'will arrive there.',
                  ),
                ),
              _ => const SizedBox.shrink(),
            },
        ],
      ),
    );
  }
}
