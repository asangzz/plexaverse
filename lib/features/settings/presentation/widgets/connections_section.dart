import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/settings_controllers.dart';
import '../../application/settings_write_controller.dart';
import '../../domain/phone_number.dart';
import '../../domain/settings_repository.dart';
import 'settings_section.dart';

/// **Connected Accounts** — LinkedIn (personal and company), Slack, Google
/// Calendar.
///
/// This is the whole of the web's `/accounts` page and the third section of its
/// `/settings` page. They duplicate each other on the web in two different
/// visual languages; there is one of them here, in Zave, and both routes render
/// it (see `accounts_page.dart`).
class ConnectionsSection extends ConsumerWidget {
  const ConnectionsSection({required this.brandType, super.key});

  /// `'personal'` | `'company'` | null while preferences load.
  ///
  /// The LinkedIn rows follow the web's rule exactly: a row shows when it
  /// matches the brand **or when the brand is still unknown**, so a user
  /// mid-onboarding sees both, each with its own badge.
  final String? brandType;

  bool get _showPersonal => brandType != 'company';
  bool get _showCompany => brandType != 'personal';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LinkedinAccount>> accounts = ref.watch(
      linkedinAccountsControllerProvider,
    );

    return SettingsSection(
      title: 'Connected Accounts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          switch (accounts) {
            AsyncData<List<LinkedinAccount>>() => _LinkedinRows(
              personal: ref.watch(personalLinkedinAccountProvider),
              company: ref.watch(companyLinkedinAccountProvider),
              showPersonal: _showPersonal,
              showCompany: _showCompany,
            ),
            AsyncError<List<LinkedinAccount>>() => SectionError(
              message: "We couldn't load your LinkedIn connection.",
              onRetry: () => ref.invalidate(linkedinAccountsControllerProvider),
            ),
            _ => const SectionSkeleton(),
          },
          const SettingsDivider(),
          const _SlackRow(),
          const SettingsDivider(),
          const _CalendarRow(),
          const SettingsDivider(),
          const _WhatsAppRow(),
        ],
      ),
    );
  }
}

class _LinkedinRows extends ConsumerWidget {
  const _LinkedinRows({
    required this.personal,
    required this.company,
    required this.showPersonal,
    required this.showCompany,
  });

  final LinkedinAccount? personal;
  final LinkedinAccount? company;
  final bool showPersonal;
  final bool showCompany;

  Future<void> _connect(
    BuildContext context,
    WidgetRef ref,
    String type,
  ) async {
    final ConnectOutcome outcome = await ref
        .read(settingsWriteControllerProvider.notifier)
        .connectLinkedin(type);
    if (!context.mounted) return;
    final String? note = switch (outcome) {
      ConnectSucceeded() => 'LinkedIn connected.',
      // Silent. The user closed the browser; they know they did, and a
      // banner blaming the app for their own decision is noise.
      ConnectCancelled() => null,
      ConnectFailed(:final String? message) =>
        message ?? 'Failed to connect LinkedIn account',
    };
    if (note != null) showSettingsMessage(context, note);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keyed per row, so a hand-off on one account leaves the other's button
    // alone — a single flag here would grey out a row that is not working.
    final bool connectingPersonal = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.linkedin('personal')),
      ),
    );
    final bool connectingCompany = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.linkedin('company')),
      ),
    );
    final bool connectingAny = connectingPersonal || connectingCompany;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showPersonal)
          _LinkedinRow(
            account: personal,
            type: 'personal',
            badge: 'Personal',
            absentDetail: 'Post personal content to LinkedIn',
            liveDetail: personal == null
                ? ''
                : 'Connected as ${personal!.profileName}',
            busy: connectingPersonal,
            onConnect: connectingAny
                ? null
                : () => _connect(context, ref, 'personal'),
          ),
        if (showPersonal && showCompany) const SettingsDivider(),
        if (showCompany)
          _LinkedinRow(
            account: company,
            type: 'company',
            badge: 'Company',
            absentDetail: 'Publish to your LinkedIn Company Page',
            liveDetail: 'Company token connected — admin access granted',
            busy: connectingCompany,
            onConnect: connectingAny
                ? null
                : () => _connect(context, ref, 'company'),
          ),
      ],
    );
  }
}

class _LinkedinRow extends ConsumerWidget {
  const _LinkedinRow({
    required this.account,
    required this.type,
    required this.badge,
    required this.absentDetail,
    required this.liveDetail,
    required this.busy,
    required this.onConnect,
  });

  final LinkedinAccount? account;
  final String type;
  final String badge;
  final String absentDetail;
  final String liveDetail;
  final bool busy;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LinkedinAccount? acct = account;

    final ConnectionStatus status = acct == null
        ? ConnectionStatus.absent
        : (acct.isHealthy ? ConnectionStatus.live : ConnectionStatus.attention);

    final String detail = switch (status) {
      ConnectionStatus.absent => absentDetail,
      ConnectionStatus.live => liveDetail,
      // The web prefixes this with a ⚠ glyph. The amber dot at the head of the
      // row already says "attention", and two warning signs on one line read
      // as two problems.
      ConnectionStatus.attention =>
        'Connection expired — reconnect to keep publishing',
    };

    final Widget control = switch (status) {
      ConnectionStatus.live => const ZavePill(
        label: 'Connected',
        color: ZaveColors.mint,
        leading: ZaveDot(ZaveColors.green),
      ),
      ConnectionStatus.attention => ZaveButton(
        label: 'Reconnect',
        busy: busy,
        onPressed: onConnect,
      ),
      ConnectionStatus.absent => ZaveButton(
        label: 'Connect',
        busy: busy,
        onPressed: onConnect,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConnectionRow(
          name: 'LinkedIn',
          badge: badge,
          status: status,
          detail: detail,
          icon: AppIcons.linkedInIn,
          iconColor: ZaveBrandMark.colorOf(ZaveBrand.linkedIn),
          trailing: control,
        ),
        if (acct != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: 'Disconnect',
              onPressed: () => _confirmDisconnectLinkedin(context, ref, acct),
            ),
          ),
        ],
        if (acct != null && acct.isCompany && acct.profileSlug == null) ...[
          SizedBox(height: ZaveSpace.md),
          const CompanyPagePicker(),
        ],
      ],
    );
  }
}

/// The Slack row — status and disconnect.
///
/// There is no Connect button. `POST /slack/auth-url` exists, but the URL it
/// returns carries the WEB callback, which an in-app browser genuinely loads
/// and never hands back to the app; LinkedIn only works because it has a
/// dedicated `/api/linkedin/mobile-callback` bridge that forwards to
/// `plexaverse://`. A button that opens a browser the app can never return
/// from is worse than a sentence saying so.
class _SlackRow extends ConsumerWidget {
  const _SlackRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SlackConnection> slack = ref.watch(
      slackControllerProvider,
    );

    return switch (slack) {
      AsyncError<SlackConnection>() => SectionError(
        message: "We couldn't load your Slack connection.",
        onRetry: () => ref.invalidate(slackControllerProvider),
      ),
      AsyncData<SlackConnection>(:final SlackConnection value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConnectionRow(
            name: 'Slack',
            status: value.isConnected
                ? ConnectionStatus.live
                : ConnectionStatus.absent,
            detail: value.isConnected
                ? 'Connected to ${value.teamName ?? 'your workspace'}'
                : 'Receive approval requests',
            icon: AppIcons.slack,
            iconColor: ZaveBrandMark.colorOf(ZaveBrand.slack),
            trailing: value.isConnected
                ? ZaveButton(
                    label: 'Disconnect',
                    onPressed: () => _confirmDisconnect(context, ref),
                  )
                : ZaveButton(
                    label: 'Connect',
                    onPressed: () => _connect(
                      context,
                      () =>
                          ref.read(slackControllerProvider.notifier).connect(),
                      'Slack connected.',
                    ),
                  ),
          ),
        ],
      ),
      _ => const SectionSkeleton(lines: 1),
    };
  }

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Disconnect Slack?'),
        content: const Text(
          'Approval requests will stop arriving in your workspace. Your posts '
          'and schedules are kept.',
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
              'Disconnect',
              // Amber, not red — Zave has no red, including for a
              // destructive confirm.
              style: ZaveType.button.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(slackControllerProvider.notifier).disconnect();
      if (context.mounted) showSettingsMessage(context, 'Slack disconnected.');
    } on Object {
      if (context.mounted) {
        showSettingsMessage(context, 'Failed to disconnect Slack.');
      }
    }
  }
}

/// The Google Calendar row. Same shape, and the same missing-bridge story as
/// [_SlackRow].
class _CalendarRow extends ConsumerWidget {
  const _CalendarRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CalendarConnection> calendar = ref.watch(
      calendarControllerProvider,
    );

    return switch (calendar) {
      AsyncError<CalendarConnection>() => SectionError(
        message: "We couldn't load your Google Calendar connection.",
        onRetry: () => ref.invalidate(calendarControllerProvider),
      ),
      AsyncData<CalendarConnection>(:final CalendarConnection value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConnectionRow(
            name: 'Google Calendar',
            status: value.needsAttention
                ? ConnectionStatus.attention
                : (value.isConnected
                      ? ConnectionStatus.live
                      : ConnectionStatus.absent),
            detail: value.needsAttention
                ? 'Access expired — reconnect to keep syncing'
                : (value.isConnected
                      ? 'Calendar synced'
                      : 'Sync published posts'),
            icon: AppIcons.google,
            iconColor: ZaveBrandMark.colorOf(ZaveBrand.google),
            trailing: value.isConnected
                ? ZaveButton(
                    label: 'Disconnect',
                    onPressed: () => _confirmDisconnect(context, ref),
                  )
                : ZaveButton(
                    label: 'Connect',
                    onPressed: () => _connect(
                      context,
                      () => ref
                          .read(calendarControllerProvider.notifier)
                          .connect(),
                      'Google Calendar connected.',
                    ),
                  ),
          ),
        ],
      ),
      _ => const SectionSkeleton(lines: 1),
    };
  }

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Disconnect Google Calendar?'),
        content: const Text(
          'Published posts will stop appearing on your calendar. Events we '
          'already created are left where they are.',
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
              'Disconnect',
              style: ZaveType.button.copyWith(color: ZaveColors.amber),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(calendarControllerProvider.notifier).disconnect();
      if (context.mounted) {
        showSettingsMessage(context, 'Google Calendar disconnected.');
      }
    } on Object {
      if (context.mounted) {
        showSettingsMessage(context, 'Failed to disconnect Google Calendar.');
      }
    }
  }
}

/// **Pick the company page** — shown when a company token is connected but no
/// page is chosen, which is a state in which nothing can publish: company
/// posts have nowhere to go.
///
/// This used to be an "open the web app" note. Both verbs already existed on
/// the mobile API (`GET`/`PATCH /linkedin/organizations`, delegating to the
/// same service the web route uses), so the only thing missing was this.
///
/// Three server answers, all reachable, all handled here:
///  * a list of administered pages, fetched live from LinkedIn;
///  * one page already saved;
///  * nothing, with `needsManualInput` — which happens when
///    `rw_organization_admin` was not granted. For those accounts the text
///    field is not a fallback, it is the only way through, so it is always
///    offered rather than revealed after a failure.
class CompanyPagePicker extends ConsumerStatefulWidget {
  const CompanyPagePicker({super.key});

  @override
  ConsumerState<CompanyPagePicker> createState() => _CompanyPagePickerState();
}

class _CompanyPagePickerState extends ConsumerState<CompanyPagePicker> {
  final TextEditingController _manual = TextEditingController();

  @override
  void dispose() {
    _manual.dispose();
    super.dispose();
  }

  Future<void> _choose(String orgId) async {
    final String? failure = await ref
        .read(settingsWriteControllerProvider.notifier)
        .chooseCompanyPage(orgId);
    if (!mounted) return;
    showSettingsMessage(
      context,
      failure ?? 'Company page linked. Company posts will publish there.',
    );
  }

  Future<void> _lookup() async {
    final String value = _manual.text.trim();
    if (value.isEmpty) return;
    await ref
        .read(settingsWriteControllerProvider.notifier)
        .lookupCompanyPage(value);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CompanyPageOptions> pages = ref.watch(
      companyPagesControllerProvider,
    );
    // One key for the whole picker, as before: choosing a page and looking one
    // up both replace the same list, so a second tap while either is open has
    // nothing coherent to land on.
    final bool busy = ref.watch(
      settingsWriteControllerProvider.select(
        (Set<String> open) => open.contains(SettingsWrite.companyPage),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'No company page linked yet, so company posts have nowhere to go. '
          'Pick the page you want to grow.',
          style: ZaveType.caption,
        ),
        SizedBox(height: ZaveSpace.md),
        switch (pages) {
          AsyncError<CompanyPageOptions>() => SectionError(
            message: "We couldn't reach LinkedIn for your pages.",
            onRetry: () => ref.invalidate(companyPagesControllerProvider),
          ),
          AsyncData<CompanyPageOptions>(:final CompanyPageOptions value) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final CompanyPage page in value.pages)
                  Padding(
                    padding: EdgeInsets.only(bottom: ZaveSpace.sm),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            page.name,
                            style: ZaveType.label.copyWith(
                              color: ZaveColors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: ZaveSpace.md),
                        ZaveButton(
                          label: 'Use this page',
                          busy: busy,
                          onPressed: busy ? null : () => _choose(page.id),
                        ),
                      ],
                    ),
                  ),
                // The server's own words when it has some — it explains
                // exactly what to paste, which a generic hint cannot.
                if (value.message != null &&
                    value.message!.isNotEmpty) ...<Widget>[
                  SizedBox(height: ZaveSpace.sm),
                  Text(value.message!, style: ZaveType.caption),
                ],
              ],
            ),
          _ => const SectionSkeleton(lines: 2),
        },
        SizedBox(height: ZaveSpace.lg),
        Text(
          'Or paste your company page URL or its numeric ID',
          style: ZaveType.caption,
        ),
        SizedBox(height: ZaveSpace.sm),
        ZaveField(
          controller: _manual,
          hint: 'linkedin.com/company/… or 1234567',
          onSubmitted: (_) => _lookup(),
        ),
        SizedBox(height: ZaveSpace.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: ZaveButton(
            label: 'Find page',
            busy: busy,
            onPressed: busy ? null : _lookup,
          ),
        ),
      ],
    );
  }
}

/// Confirms a LinkedIn disconnect, naming what survives and what does not.
///
/// "Disconnect" alone does not tell a user which of their things are about
/// to stop. Posts survive detached — the server nulls their FK first,
/// because `Post.account` cascades — but recurring schedules are cascaded
/// away, because one pointing at no account cannot fire. Both facts belong
/// in front of the decision, not after it.
Future<void> _confirmDisconnectLinkedin(
  BuildContext context,
  WidgetRef ref,
  LinkedinAccount account,
) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text('Disconnect ${account.profileName}?'),
      content: const Text(
        'Your posts stay — they just stop being attached to this account. '
        'Any recurring schedules on it are removed, and nothing will publish '
        'until you connect an account again.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'Keep it',
            style: ZaveType.button.copyWith(color: ZaveColors.ink62),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'Disconnect',
            // Amber, not red. Zave has no red, including here.
            style: ZaveType.button.copyWith(color: ZaveColors.amber),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final String? failure = await ref
      .read(linkedinAccountsControllerProvider.notifier)
      .disconnect(account.id);
  if (!context.mounted) return;
  showSettingsMessage(
    context,
    failure ?? '${account.profileName} disconnected.',
  );
}

/// Runs a browser connect hand-off and says only what is worth saying.
///
/// Shared by Slack and Calendar because the rule is the same for both, and
/// it is the rule most easily got wrong: a CANCELLED hand-off is silent.
/// The user closed the sheet or declined at the provider's own consent
/// screen; a banner there blames the app for their decision.
Future<void> _connect(
  BuildContext context,
  Future<ConnectOutcome> Function() run,
  String success,
) async {
  final ConnectOutcome outcome = await run();
  if (!context.mounted) return;
  final String? note = switch (outcome) {
    ConnectSucceeded() => success,
    ConnectCancelled() => null,
    ConnectFailed(:final String? message) =>
      message ?? "That didn't connect. Try again.",
  };
  if (note == null) return;
  showSettingsMessage(context, note);
}


/// WhatsApp — the one connection that is typed rather than handed off.
///
/// Slack and Calendar bounce to OAuth and come back done. A phone number has
/// to be typed and then PROVED, so this row expands in place rather than
/// opening a dialog: its state stays visible beside the other accounts, and
/// there is no modal to lose your place in halfway through a six-digit code.
///
/// Four states live on the row's own line — unavailable, opted out, connected,
/// and not yet connected — so the list reads consistently whichever you are in.
class _WhatsAppRow extends ConsumerStatefulWidget {
  const _WhatsAppRow();

  @override
  ConsumerState<_WhatsAppRow> createState() => _WhatsAppRowState();
}

class _WhatsAppRowState extends ConsumerState<_WhatsAppRow> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _code = TextEditingController();

  /// The form is open. Separate from `awaitingCode`, which is the SERVER
  /// saying a code is outstanding — a user can open the form and change their
  /// mind without a code ever being sent.
  ///
  /// This is the only flag left here: it is neither in-flight nor failure
  /// state, just which of two layouts this row is drawing. Busy and error
  /// live on [WhatsAppActions] — see the architecture test.
  bool _open = false;

  @override
  void initState() {
    super.initState();
    // Repaint the preview as they type, so the resolved number is live.
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<WhatsAppConnection> whatsApp = ref.watch(
      whatsAppControllerProvider,
    );

    return switch (whatsApp) {
      AsyncError<WhatsAppConnection>() => SectionError(
        message: "We couldn't load your WhatsApp connection.",
        onRetry: () => ref.invalidate(whatsAppControllerProvider),
      ),
      AsyncData<WhatsAppConnection>(:final WhatsAppConnection value) =>
        _row(value, ref.watch(whatsAppActionsProvider)),
      _ => const SectionSkeleton(lines: 1),
    };
  }

  Widget _row(WhatsAppConnection value, WhatsAppBusy busy) {
    final WhatsAppActions control = ref.read(whatsAppActionsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConnectionRow(
          name: 'WhatsApp',
          status: value.isLive
              ? ConnectionStatus.live
              // Opted out is not "broken" and not "absent": the number is
              // known and deliberately silenced. Amber is Zave's "this needs
              // you", which is exactly what it is.
              : value.optedOut
              ? ConnectionStatus.attention
              : ConnectionStatus.absent,
          detail: switch (value) {
            _ when value.isUnavailable => 'Not switched on yet',
            _ when value.optedOut =>
              'You replied STOP. Nothing is being sent.',
            _ when value.connected => 'Connected · ${value.phoneMasked ?? ''}',
            _ => 'Get the week plan on WhatsApp',
          },
          icon: AppIcons.whatsapp,
          trailing: _control(value, control, busy),
        ),
        if (_open && !value.connected && !value.optedOut)
          _form(control, value, busy),
        if (busy.error case final String message) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
        ],
      ],
    );
  }

  Widget? _control(
    WhatsAppConnection value,
    WhatsAppActions control,
    WhatsAppBusy busy,
  ) {
    if (value.isUnavailable) return null;
    if (value.optedOut) {
      return ZaveButton(
        label: 'Turn back on',
        busy: busy.busy,
        onPressed: busy.busy ? null : control.resume,
      );
    }
    if (value.connected) {
      return ZaveButton(
        label: 'Disconnect',
        busy: busy.busy,
        onPressed: busy.busy ? null : control.disconnect,
      );
    }
    return ZaveButton(
      label: _open ? 'Cancel' : 'Connect',
      onPressed: busy.busy
          ? null
          : () => setState(() => _open = !_open),
    );
  }

  /// The number, then the code. Which half shows is the SERVER's
  /// `awaitingCode`, not a local flag — a send that silently did nothing would
  /// otherwise leave the user typing a code that was never issued.
  Widget _form(
    WhatsAppActions control,
    WhatsAppConnection value,
    WhatsAppBusy busy,
  ) {
    if (value.awaitingCode) {
      return Padding(
        padding: EdgeInsets.only(top: ZaveSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ZaveField(
              controller: _code,
              label: 'SIX-DIGIT CODE',
              hint: '123456',
              keyboardType: TextInputType.number,
              enabled: !busy.busy,
            ),
            SizedBox(height: ZaveSpace.md),
            ZaveButton.primary(
              label: 'Verify',
              busy: busy.busy,
              onPressed: busy.busy
                  ? null
                  : () => control.confirmCode(_code.text.trim()),
            ),
          ],
        ),
      );
    }

    final PhoneResult parsed = normalisePhone(_phone.text);

    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZaveField(
            controller: _phone,
            label: 'WHATSAPP NUMBER',
            hint: '+91 98765 43210',
            keyboardType: TextInputType.phone,
            enabled: !busy.busy,
          ),
          SizedBox(height: ZaveSpace.sm),
          // The resolved number, shown BACK before anything is sent. A
          // mistyped country code is the one mistake here that texts a
          // stranger — someone who never signed up, cannot unsubscribe, and
          // whose only recourse is to report us to Meta.
          Text(
            _phone.text.trim().isEmpty
                ? 'Include your country code.'
                : parsed.isOk
                ? 'We will message ${parsed.e164}'
                : parsed.error!,
            style: ZaveType.caption.copyWith(
              color: parsed.isOk ? ZaveColors.ink45 : ZaveColors.amber,
            ),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveButton.primary(
            label: 'Send code',
            busy: busy.busy,
            // Dead until the number resolves. The server would refuse it
            // anyway; refusing here costs no round trip and no send.
            onPressed: busy.busy || !parsed.isOk
                ? null
                : () => control.sendCode(_phone.text.trim()),
          ),
        ],
      ),
    );
  }
}
