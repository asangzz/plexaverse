import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../auth/application/google_link_controller.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../application/settings_controllers.dart';
import '../../domain/settings_repository.dart';
import 'settings_section.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/settings_repositories.dart';

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
        const _GoogleSignInRow(),
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

/// **Sign in with Google** — the escape hatch from the sign-in refusal.
///
/// Signing in with Google is refused for an account that has a password,
/// because both register routes mark an address verified without ever mailing
/// it: anyone can pre-register someone else's email, and auto-linking would
/// hand that person's Google sign-in into a row whose password the attacker
/// still knows. The refusal tells the user to "sign in with your password,
/// then link Google from Settings" — this row is the thing that sentence
/// promises, and without it that message points nowhere.
///
/// Linking is safe here in a way it is not at sign-in: the user has already
/// entered the password, which is the proof of ownership that was missing.
class _GoogleSignInRow extends ConsumerStatefulWidget {
  const _GoogleSignInRow();

  @override
  ConsumerState<_GoogleSignInRow> createState() => _GoogleSignInRowState();
}

class _GoogleSignInRowState extends ConsumerState<_GoogleSignInRow> {
  bool _busy = false;

  Future<void> _act(
    Future<GoogleLinkResult> Function() action,
    String succeeded,
  ) async {
    setState(() => _busy = true);
    try {
      final GoogleLinkResult result = await action();
      if (!mounted) return;
      final String? note = switch (result) {
        GoogleLinkSucceeded(alreadyLinked: true) =>
          'That Google account was already linked.',
        GoogleLinkSucceeded() => succeeded,
        // Silent. The user closed the browser; they know they did.
        GoogleLinkCancelled() => null,
        // The server's own copy where it sent some — its refusals name the one
        // thing the user has to do next, which a generic message would lose.
        GoogleLinkFailed(:final String? message) =>
          message ?? "We couldn't change your Google sign-in.",
      };
      if (note != null) showSettingsMessage(context, note);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmUnlink() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Unlink Google?'),
        content: const Text(
          'You will sign in with your email and password from then on. '
          'Nothing else about your account changes.',
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
              'Unlink',
              // Amber, not red. Zave has no red, including here.
              style: ZaveType.button.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _act(
      () => ref.read(googleLinkControllerProvider.notifier).unlink(),
      'Google unlinked.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GoogleLinkStatus?> status = ref.watch(
      googleLinkControllerProvider,
    );

    return switch (status) {
      // A null value is "unknown", not "not linked" — see the controller.
      // Offering "Link Google" to someone who already linked it would send
      // them through the browser to a refusal.
      AsyncError<GoogleLinkStatus?>() ||
      AsyncData<GoogleLinkStatus?>(value: null) => SectionError(
        message: "We couldn't check your Google sign-in.",
        onRetry: () => ref.invalidate(googleLinkControllerProvider),
      ),
      AsyncData<GoogleLinkStatus?>(value: final GoogleLinkStatus value) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConnectionRow(
              name: 'Google',
              status: value.linked
                  ? ConnectionStatus.live
                  : ConnectionStatus.absent,
              detail: value.linked
                  ? 'You can sign in with Google'
                  : 'Sign in with Google instead of your password',
              icon: Icons.account_circle_outlined,
              trailing: value.linked
                  ? (value.canUnlink
                        ? ZaveButton(
                            label: 'Unlink',
                            busy: _busy,
                            onPressed: _busy ? null : _confirmUnlink,
                          )
                        : null)
                  : ZaveButton(
                      label: 'Link',
                      busy: _busy,
                      onPressed: _busy
                          ? null
                          : () => _act(
                              () => ref
                                  .read(googleLinkControllerProvider.notifier)
                                  .link(),
                              'Google linked.',
                            ),
                    ),
            ),
            // Unlinking the only sign-in method would strand the account for
            // good — there is no password-reset path onto a row that never had
            // a password. The server refuses it; saying so here is better than
            // offering a button that always fails.
            if (value.linked && !value.canUnlink) ...<Widget>[
              SizedBox(height: ZaveSpace.md),
              const UnavailableNote(
                message:
                    'Google is the only way into this account, so it cannot '
                    'be unlinked. Set a password in the web app first.',
              ),
            ],
          ],
        ),
      _ => const SectionSkeleton(lines: 1),
    };
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
class DataPrivacySection extends ConsumerStatefulWidget {
  const DataPrivacySection({super.key});

  @override
  ConsumerState<DataPrivacySection> createState() => _DataPrivacySectionState();
}

class _DataPrivacySectionState extends ConsumerState<DataPrivacySection> {
  bool _busy = false;

  void _say(String message) {
    if (!mounted) return;
    showSettingsMessage(context, message);
  }

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final Map<String, dynamic> data =
          await ref.read(settingsRepositoryProvider).fetchDataExport();
      if (!mounted) return;
      // Shown, not downloaded: the app has no file-save path wired up, and a
      // body the user can read and share beats a file they cannot open.
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) => _ExportSheet(json: data),
      );
    } on Object {
      _say("We couldn't build your export. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => const _DeleteAccountDialog(),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final List<String> retained = await ref
          .read(settingsRepositoryProvider)
          .deleteAccount(password: _password);
      if (!mounted) return;
      _say(
        retained.isEmpty
            ? 'Your account and data have been deleted.'
            : 'Account deleted. Kept for legal reasons: ${retained.join(', ')}.',
      );
      // The account is gone; the session has nothing left to point at.
      await ref.read(signOutControllerProvider.notifier).signOut();
    } on Object {
      _say("We couldn't delete your account. Nothing was changed.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  final String _password = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ConsentLedger> consents =
        ref.watch(consentControllerProvider);

    return SettingsSection(
      title: 'Your data',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'What you have agreed to, everything we hold about you, and the '
            'way out.',
            style: ZaveType.caption,
          ),
          SizedBox(height: ZaveSpace.lg),
          switch (consents) {
            AsyncError<ConsentLedger>() => SectionError(
              message: "We couldn't load your consent settings.",
              onRetry: () => ref.invalidate(consentControllerProvider),
            ),
            AsyncData<ConsentLedger>(:final ConsentLedger value) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final ConsentPurposeState p in value.purposes)
                  _ConsentRow(
                    purpose: p,
                    onChanged: p.required_
                        ? null
                        : (bool next) async {
                            final String? failure = await ref
                                .read(consentControllerProvider.notifier)
                                .set(p.purpose, next);
                            if (failure != null) _say(failure);
                          },
                  ),
              ],
            ),
            _ => const SectionSkeleton(lines: 3),
          },
          const SettingsDivider(),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Download my data',
              icon: const Icon(Icons.download_outlined),
              busy: _busy,
              onPressed: _busy ? null : _export,
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Delete my account',
              icon: const Icon(Icons.person_remove_outlined),
              busy: _busy,
              onPressed: _busy ? null : _confirmDelete,
            ),
          ),
          SizedBox(height: ZaveSpace.md),
          const UnavailableNote(
            message:
                'Naming someone to act for you, and raising a concern with '
                'our grievance officer, are still web-only.',
          ),
        ],
      ),
    );
  }
}

/// One purpose and its switch.
///
/// A REQUIRED purpose renders disabled with the reason, rather than being
/// hidden: the user is entitled to see everything being done with their data,
/// including the part they cannot switch off.
///
/// `stale` means a decision exists but predates the current notice, so it is
/// not a current yes — the row says so rather than showing it as granted.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({required this.purpose, required this.onChanged});

  final ConsentPurposeState purpose;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ZaveSpace.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(purpose.label, style: ZaveType.body),
                if (purpose.required_) ...<Widget>[
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    'Required to run your account. To stop this, delete the '
                    'account.',
                    style: ZaveType.caption,
                  ),
                ] else if (purpose.stale) ...<Widget>[
                  SizedBox(height: ZaveSpace.xs),
                  Text(
                    'Our notice changed since you answered — please choose '
                    'again.',
                    style: ZaveType.caption.copyWith(color: ZaveColors.amber),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: ZaveSpace.lg),
          ZaveSwitch(
            value: purpose.granted,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// The typed confirmation. Erasure is irreversible and a phone is easy to
/// mis-tap, so the gate is a phrase the user has to mean.
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  static const String _phrase = 'DELETE MY ACCOUNT';
  final TextEditingController _typed = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool ready = _typed.text.trim() == _phrase;
    return AlertDialog(
      title: const Text('Delete your account?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'This erases your posts, schedules, connections and plans. It '
            'cannot be undone. Some records are kept where the law requires '
            'it, and we will tell you which.',
          ),
          SizedBox(height: ZaveSpace.lg),
          Text('Type $_phrase to confirm', style: ZaveType.caption),
          SizedBox(height: ZaveSpace.sm),
          ZaveField(
            controller: _typed,
            hint: _phrase,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Keep my account',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: ready ? () => Navigator.of(context).pop(true) : null,
          child: Text(
            'Delete',
            // Amber, not red. Zave has no red, including here.
            style: ZaveType.button.copyWith(
              color: ready ? ZaveColors.amber : ZaveColors.ink35,
            ),
          ),
        ),
      ],
    );
  }
}

/// The s11 export, rendered rather than downloaded.
class _ExportSheet extends StatelessWidget {
  const _ExportSheet({required this.json});

  final Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    final String pretty = const JsonEncoder.withIndent('  ').convert(json);
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      expand: false,
      builder: (BuildContext ctx, ScrollController scroll) => Container(
        decoration: ZaveSurface.cardLg,
        padding: EdgeInsets.all(ZaveSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('YOUR DATA', style: ZaveType.kicker),
                const Spacer(),
                ZaveButton(
                  label: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: pretty));
                    ScaffoldMessenger.of(ctx)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Copied.', style: ZaveType.body),
                        ),
                      );
                  },
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.lg),
            Expanded(
              child: SingleChildScrollView(
                controller: scroll,
                child: SelectableText(pretty, style: ZaveType.caption),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
