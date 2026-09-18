import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../application/settings_controllers.dart';
import '../../domain/settings_repository.dart';
import 'settings_section.dart';

/// **Account** — who you are signed in as, and the way out.
///
/// The web additionally edits the display name inline and uploads an avatar
/// (`PATCH /api/user/profile`, `POST /api/user/avatar`). Neither route exists
/// on the mobile API, so both are read-only here and the section says so rather
/// than offering a pencil that cannot write.
class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AccountSnapshot> account = ref.watch(
      accountSnapshotProvider,
    );

    return SettingsSection(
      title: 'Account',
      child: switch (account) {
        AsyncError<AccountSnapshot>() => SectionError(
          message: "We couldn't load your account.",
          onRetry: () => ref.invalidate(accountSnapshotProvider),
        ),
        AsyncData<AccountSnapshot>(:final AccountSnapshot value) =>
          _AccountBody(identity: value.user),
        _ => const SectionSkeleton(lines: 2),
      },
    );
  }
}

class _AccountBody extends ConsumerWidget {
  const _AccountBody({required this.identity});

  final AccountIdentity identity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _Avatar(identity: identity),
            SizedBox(width: ZaveSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    identity.name.isEmpty ? 'Your account' : identity.name,
                    style: ZaveType.label.copyWith(color: ZaveColors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    identity.email,
                    style: ZaveType.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (identity.isAdmin)
              const ZavePill(label: 'Admin', color: ZaveColors.peri),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        const UnavailableNote(
          message:
              'Your name and photo are read-only in the app — there is no '
              'mobile route to change them yet. Edit them in the web app and '
              'they update here.',
        ),
        const SettingsDivider(),
        Align(
          alignment: Alignment.centerLeft,
          child: ZaveButton(
            label: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your posts, schedules and connections stay exactly as they are. '
          'You will need to sign in again on this device.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: ZaveType.button.copyWith(color: ZaveColors.ink62),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Sign out',
              // Amber, not red. Zave has no red, including here.
              style: ZaveType.button.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // The shared sign-out path: server-side teardown (time-boxed), then the
    // local session clear, then the auth gate flips and the router redirects.
    // Never an imperative navigation from here.
    await ref.read(signOutControllerProvider.notifier).signOut();
  }
}

/// The 64px account avatar, or the name's initial on glass.
///
/// The web paints its fallback with an indigo→green gradient. Zave allows no
/// decorative colour, so the fallback is a glass disc with the initial in it.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.identity});

  final AccountIdentity identity;

  @override
  Widget build(BuildContext context) {
    final String? url = identity.avatarUrl;
    final double size = ZaveSpace.xxl * 2;

    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ZaveGlass.controlFill,
        border: Border.all(color: ZaveGlass.controlBorder, width: 1),
        shape: BoxShape.circle,
      ),
      child: url == null || url.isEmpty
          ? Center(
              child: Text(
                identity.initial,
                style: ZaveType.h3,
              ),
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              // A broken avatar URL must degrade to the initial, not to a
              // console-red error box in the middle of Settings.
              errorBuilder: (_, _, _) =>
                  Center(child: Text(identity.initial, style: ZaveType.h3)),
            ),
    );
  }
}

/// **Notifications** — the mobile counterpart of the web's push row.
///
/// The web subscribes the browser to Web Push. The app's equivalent is an FCM
/// device token, and there is **no route to register one**: `api_paths.dart`
/// records that the previous client POSTed to `/notifications/devices` on every
/// launch and 404ed silently every time. So this row states the position
/// instead of pretending to toggle something.
///
/// The web's other two rows in this block are dropped on purpose. "Replay
/// guides" has no mobile route, and "Download app" is an install prompt for a
/// PWA — meaningless inside the installed app.
class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSection(
      title: 'Notifications',
      child: UnavailableNote(
        title: 'Push is not wired up yet',
        message:
            'Post-approval and daily-mission alerts cannot reach this device '
            'until the API can register it. Your in-app notifications list '
            'still works, and approvals keep arriving on your approval '
            'channel.',
      ),
    );
  }
}

/// **Your data** — the DPDP rights surface.
///
/// The web's `PrivacyDataPanel` is the surface users actually reach for
/// consent, export, nomination, grievance and deletion (CLAUDE.md §12a). None
/// of it has a mobile route. That is worth stating plainly rather than omitting
/// the section: a data-protection right the user cannot find is, from their
/// side, a right they do not have.
class DataPrivacySection extends StatelessWidget {
  const DataPrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Your data',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'You can download everything we hold about you, change what you '
            'have consented to, name someone to act for you, raise a concern, '
            'or delete your account.',
            style: ZaveType.caption,
          ),
          SizedBox(height: ZaveSpace.lg),
          const UnavailableNote(
            title: 'Available in the web app',
            message:
                'These controls are not in the app yet — the mobile API has '
                'no route for consent, export, nomination, grievances or '
                'account deletion. Open Plexaverse on the web and go to '
                'Settings to use them.',
          ),
        ],
      ),
    );
  }
}
