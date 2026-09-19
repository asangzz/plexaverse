import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/settings_controllers.dart';
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
              onRetry: () =>
                  ref.invalidate(linkedinAccountsControllerProvider),
            ),
            _ => const SectionSkeleton(),
          },
          const SettingsDivider(),
          const _SlackRow(),
          const SettingsDivider(),
          const _CalendarRow(),
        ],
      ),
    );
  }
}

class _LinkedinRows extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<_LinkedinRows> createState() => _LinkedinRowsState();
}

class _LinkedinRowsState extends ConsumerState<_LinkedinRows> {
  /// Which row is mid-hand-off, so only that row's button goes busy.
  String? _connecting;

  Future<void> _connect(String type) async {
    setState(() => _connecting = type);
    try {
      final ConnectOutcome outcome = await ref
          .read(linkedinAccountsControllerProvider.notifier)
          .connect(type);
      if (!mounted) return;
      final String? note = switch (outcome) {
        ConnectSucceeded() => 'LinkedIn connected.',
        // Silent. The user closed the browser; they know they did, and a
        // banner blaming the app for their own decision is noise.
        ConnectCancelled() => null,
        ConnectFailed(:final String? message) =>
          message ?? 'Failed to connect LinkedIn account',
      };
      if (note != null) showSettingsMessage(context, note);
    } finally {
      if (mounted) setState(() => _connecting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.showPersonal)
          _LinkedinRow(
            account: widget.personal,
            type: 'personal',
            badge: 'Personal',
            absentDetail: 'Post personal content to LinkedIn',
            liveDetail: widget.personal == null
                ? ''
                : 'Connected as ${widget.personal!.profileName}',
            busy: _connecting == 'personal',
            onConnect: _connecting == null
                ? () => _connect('personal')
                : null,
          ),
        if (widget.showPersonal && widget.showCompany)
          const SettingsDivider(),
        if (widget.showCompany)
          _LinkedinRow(
            account: widget.company,
            type: 'company',
            badge: 'Company',
            absentDetail: 'Publish to your LinkedIn Company Page',
            liveDetail: 'Company token connected — admin access granted',
            busy: _connecting == 'company',
            onConnect: _connecting == null ? () => _connect('company') : null,
          ),
      ],
    );
  }
}

class _LinkedinRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final LinkedinAccount? acct = account;

    final ConnectionStatus status = acct == null
        ? ConnectionStatus.absent
        : (acct.isHealthy
              ? ConnectionStatus.live
              : ConnectionStatus.attention);

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
          icon: Icons.work_outline,
          trailing: control,
        ),
        if (acct != null) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          const UnavailableNote(
            message:
                'Disconnecting a LinkedIn account is not available in the app '
                'yet — the mobile API has no delete route for it. Use the web '
                'app if you linked the wrong account.',
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
    final AsyncValue<SlackConnection> slack = ref.watch(slackControllerProvider);

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
            icon: Icons.tag,
            trailing: value.isConnected
                ? ZaveButton(
                    label: 'Disconnect',
                    onPressed: () => _confirmDisconnect(context, ref),
                  )
                : null,
          ),
          if (!value.isConnected) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            const UnavailableNote(
              message:
                  'Connecting Slack is not available in the app yet — the '
                  'OAuth hand-off has no mobile callback to return through. '
                  'Connect it in the web app and it will show here.',
            ),
          ],
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
            icon: Icons.calendar_today_outlined,
            trailing: value.isConnected
                ? ZaveButton(
                    label: 'Disconnect',
                    onPressed: () => _confirmDisconnect(context, ref),
                  )
                : null,
          ),
          if (!value.isConnected) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            const UnavailableNote(
              message:
                  'Connecting Google Calendar is not available in the app yet '
                  '— the OAuth hand-off has no mobile callback to return '
                  'through. Connect it in the web app and it will show here.',
            ),
          ],
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
  bool _busy = false;

  @override
  void dispose() {
    _manual.dispose();
    super.dispose();
  }

  Future<void> _choose(String orgId) async {
    setState(() => _busy = true);
    try {
      final String? failure = await ref
          .read(companyPagesControllerProvider.notifier)
          .choose(orgId);
      if (!mounted) return;
      showSettingsMessage(
        context,
        failure ?? 'Company page linked. Company posts will publish there.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _lookup() async {
    final String value = _manual.text.trim();
    if (value.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(companyPagesControllerProvider.notifier).lookup(value);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CompanyPageOptions> pages = ref.watch(
      companyPagesControllerProvider,
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
                          busy: _busy,
                          onPressed: _busy ? null : () => _choose(page.id),
                        ),
                      ],
                    ),
                  ),
                // The server's own words when it has some — it explains
                // exactly what to paste, which a generic hint cannot.
                if (value.message != null && value.message!.isNotEmpty) ...<Widget>[
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
            busy: _busy,
            onPressed: _busy ? null : _lookup,
          ),
        ),
      ],
    );
  }
}
