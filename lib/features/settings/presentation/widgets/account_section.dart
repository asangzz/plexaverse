import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../auth/application/google_link_controller.dart';
import '../../../auth/application/sign_out_controller.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../application/privacy_controller.dart';
import '../../application/settings_controllers.dart';
import '../../domain/settings_repository.dart';
import 'settings_section.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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

/// Stateful only for `mounted`: every one of these flows crosses a dialog the
/// user can sit in indefinitely, and the request state they used to carry now
/// lives on [PrivacyController] with the use cases themselves.
class _DataPrivacySectionState extends ConsumerState<DataPrivacySection> {
  void _say(String message) {
    if (!mounted) return;
    showSettingsMessage(context, message);
  }

  /// DPDP s14 — who may act for the user if they cannot act for themselves.
  Future<void> _nominate() async {
    final PrivacyController privacy = ref.read(
      privacyControllerProvider.notifier,
    );
    // Null covers both "none on file" and "the read failed" — see the
    // controller: a read that cannot be reached must not block the naming.
    final Nominee? existing = await privacy.nomination();
    if (!mounted) return;

    final Nominee? next = await showDialog<Nominee>(
      context: context,
      builder: (BuildContext ctx) => _NominationDialog(existing: existing),
    );
    if (next == null || !mounted) return;

    final String? failure = await privacy.saveNomination(next);
    _say(failure ?? 'Saved. ${next.name} can act for you.');
  }

  /// DPDP s13 — raise a concern, and report the deadline it carries.
  Future<void> _raiseGrievance() async {
    final ({String category, String message})? entry =
        await showDialog<({String category, String message})>(
      context: context,
      builder: (BuildContext ctx) => const _GrievanceDialog(),
    );
    if (entry == null || !mounted) return;

    final int? days = await ref
        .read(privacyControllerProvider.notifier)
        .raiseGrievance(category: entry.category, message: entry.message);
    // The deadline comes from the server — it is stamped on the row, and
    // quoting a constant here could promise a date the record disagrees with.
    _say(
      days == null
          ? "We couldn't submit that. Try again."
          : 'Raised. We will respond within $days days.',
    );
  }

  Future<void> _export() async {
    final Map<String, dynamic>? data = await ref
        .read(privacyControllerProvider.notifier)
        .export();
    if (!mounted) return;
    if (data == null) {
      _say("We couldn't build your export. Try again.");
      return;
    }
    // Shown, not downloaded: the app has no file-save path wired up, and a
    // body the user can read and share beats a file they cannot open.
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => _ExportSheet(json: data),
    );
  }

  Future<void> _confirmDelete() async {
    final PrivacyController privacy = ref.read(
      privacyControllerProvider.notifier,
    );
    // The server bcrypt-compares a password only when the row HAS one, and
    // refuses the whole call with PASSWORD_REQUIRED when it has one and none
    // arrives. A Google-only account has nothing to compare, and demanding a
    // password there would block exactly the people who cannot produce one
    // from exercising an s12 right. Null is "we don't know yet" — the status
    // read failed, and it answers null rather than throwing — so we ask
    // without insisting: a status endpoint being down must never be the thing
    // that stops an erasure. Read once here and used twice below, so the
    // dialog and the failure sentence cannot describe different accounts.
    final bool? hasPassword = privacy.hasPassword;

    final String? password = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) =>
          _DeleteAccountDialog(hasPassword: hasPassword),
    );
    // Null is "backed out". An EMPTY string is a deliberate confirmation from
    // an account that has no password — the repository drops the key for it,
    // which is what the server expects from a Google-only row.
    if (password == null || !mounted) return;

    // The sign-out that follows a successful erasure is the controller's now,
    // not a line after this await: it must happen whether or not this screen
    // is still here to watch it.
    final ErasureOutcome outcome = await privacy.erase(password: password);
    _say(switch (outcome) {
      ErasureSucceeded(:final List<String> retained) => retained.isEmpty
          ? 'Your account and data have been deleted.'
          : 'Account deleted. Kept for legal reasons: ${retained.join(', ')}.',
      // This route's rejections are not translated into a typed result yet, so
      // a wrong password and an unreachable server land here identically. Name
      // both where a password was in play rather than sending the user off to
      // retype one that was never the problem.
      ErasureFailed() => hasPassword == false
          ? "We couldn't delete your account. Nothing was changed."
          : "We couldn't delete your account — the password may be wrong, "
                "or we couldn't reach the server. Nothing was changed.",
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ConsentLedger> consents =
        ref.watch(consentControllerProvider);
    // Watched, not read: this is the export's and the erasure's in-flight
    // state, and watching it is also what holds the autoDispose controller
    // open for the length of a request this screen started.
    final bool busy = ref.watch(privacyControllerProvider);

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
              busy: busy,
              onPressed: busy ? null : _export,
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Delete my account',
              icon: const Icon(Icons.person_remove_outlined),
              busy: busy,
              onPressed: busy ? null : _confirmDelete,
            ),
          ),
          const SettingsDivider(),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Name someone to act for me',
              icon: const Icon(Icons.person_add_alt_outlined),
              onPressed: busy ? null : _nominate,
            ),
          ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Raise a concern',
              icon: const Icon(Icons.flag_outlined),
              onPressed: busy ? null : _raiseGrievance,
            ),
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

/// The typed confirmation, plus the password when the account signs in with
/// one. Pops the password on confirm (`''` when there is none) and null when
/// the user backs out.
///
/// Erasure is irreversible and a phone is easy to mis-tap, so the first gate is
/// a phrase the user has to mean. The password is the SERVER's gate, not
/// decoration: `DELETE /user/account` bcrypt-compares it whenever the row has
/// one and rejects the call outright when it does not arrive. Collecting it
/// here is what makes the button work at all for a password account — sending
/// an empty string, as this once did, failed every time and reported it as a
/// generic "couldn't delete".
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.hasPassword});

  /// Whether this account has a password. **Null is unknown**, not false — the
  /// status read answers null on any failure, and treating that as "no
  /// password" would quietly restore the bug this field exists to fix.
  final bool? hasPassword;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  static const String _phrase = 'DELETE MY ACCOUNT';
  final TextEditingController _typed = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Offered whenever a password might exist; demanded only when we KNOW one
    // does. Demanding it on an unknown would strand a Google-only user behind
    // a field they can never fill.
    final bool offerPassword = widget.hasPassword != false;
    // Mirrors the server's own rule so a password account is told while typing
    // rather than after a round trip that erased nothing. Not trimmed: a space
    // can be part of a password.
    final bool ready = _typed.text.trim() == _phrase &&
        (widget.hasPassword != true || _password.text.isNotEmpty);
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
          if (offerPassword) ...<Widget>[
            SizedBox(height: ZaveSpace.lg),
            Text(
              widget.hasPassword == true
                  ? 'Enter your password'
                  : 'Enter your password, if you sign in with one',
              style: ZaveType.caption,
            ),
            SizedBox(height: ZaveSpace.sm),
            ZaveField(
              controller: _password,
              hint: '••••••••',
              obscure: true,
              // A password the user may never have typed on this device — let
              // the password manager offer it rather than making a forgotten
              // one the reason an erasure cannot proceed.
              autofillHints: const <String>[AutofillHints.password],
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          // No value: null is how the caller tells backing out apart from a
          // confirmed deletion that carries an empty password.
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Keep my account',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: ready
              ? () => Navigator.of(context).pop(_password.text)
              : null,
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


/// Naming a nominee. Email is validated server-side too; the check here is
/// so the user is told before a round trip, not instead of one.
class _NominationDialog extends StatefulWidget {
  const _NominationDialog({required this.existing});

  final Nominee? existing;

  @override
  State<_NominationDialog> createState() => _NominationDialogState();
}

class _NominationDialogState extends State<_NominationDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _email =
      TextEditingController(text: widget.existing?.email ?? '');
  late final TextEditingController _relationship =
      TextEditingController(text: widget.existing?.relationship ?? '');

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _relationship.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool ready = _name.text.trim().isNotEmpty &&
        _emailPattern.hasMatch(_email.text.trim());

    return AlertDialog(
      title: const Text('Name someone to act for you'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'If you die or cannot act for yourself, this person may exercise '
            'your rights over your data on your behalf.',
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _name,
            hint: 'Their name',
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _email,
            hint: 'Their email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveField(
            controller: _relationship,
            hint: 'Relationship (optional)',
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: ready
              ? () => Navigator.of(context).pop(
                    Nominee(
                      name: _name.text.trim(),
                      email: _email.text.trim(),
                      relationship: _relationship.text.trim().isEmpty
                          ? null
                          : _relationship.text.trim(),
                    ),
                  )
              : null,
          child: Text(
            'Save',
            style: ZaveType.button.copyWith(
              color: ready ? ZaveColors.white : ZaveColors.ink35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Raising a concern. The 10-character floor mirrors the server's, so the
/// user is told while typing rather than after submitting.
class _GrievanceDialog extends StatefulWidget {
  const _GrievanceDialog();

  @override
  State<_GrievanceDialog> createState() => _GrievanceDialogState();
}

class _GrievanceDialogState extends State<_GrievanceDialog> {
  /// Mirrors the server's list. An unrecognised value becomes `other` there
  /// rather than being refused, so this list going stale degrades gently.
  static const Map<String, String> _categories = <String, String>{
    'data_access': 'Getting my data',
    'data_correction': 'Correcting my data',
    'data_erasure': 'Deleting my data',
    'consent': 'Consent',
    'other': 'Something else',
  };

  String _category = 'other';
  final TextEditingController _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool ready = _message.text.trim().length >= 10;

    return AlertDialog(
      title: const Text('Raise a concern'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              for (final MapEntry<String, String> e in _categories.entries)
                ZaveChip(
                  label: e.value,
                  selected: _category == e.key,
                  onTap: () => setState(() => _category = e.key),
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveField(
            controller: _message,
            hint: 'What happened?',
            maxLines: 4,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: ready
              ? () => Navigator.of(context)
                  .pop((category: _category, message: _message.text.trim()))
              : null,
          child: Text(
            'Send',
            style: ZaveType.button.copyWith(
              color: ready ? ZaveColors.white : ZaveColors.ink35,
            ),
          ),
        ),
      ],
    );
  }
}
