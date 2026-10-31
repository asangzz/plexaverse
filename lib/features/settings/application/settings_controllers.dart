import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repositories.dart';
import '../domain/settings_repository.dart';

part 'settings_controllers.g.dart';

// Settings is ONE SCREEN MADE OF INDEPENDENT SECTIONS, so it is modelled as a
// handful of small providers rather than one god-object snapshot.
//
// The web reaches the same shape with one React Query hook per resource
// (useUserPreferences, useLinkedinAccounts, useSlackConnection,
// useGoogleCalendar, useXP), and the reason is worth repeating here: a single
// combined fetch makes Slack being down take the whole page with it. Each
// provider below owns one section's loading, error and retry.

@riverpod
Future<AccountSnapshot> accountSnapshot(Ref ref) =>
    ref.watch(settingsRepositoryProvider).fetchAccount();

/// The XP balance shown beside the plan.
@riverpod
Future<XpSummary> xpSummary(Ref ref) =>
    ref.watch(settingsRepositoryProvider).fetchXp();

/// Connected LinkedIn profiles, plus the connect hand-off.
@riverpod
class LinkedinAccountsController extends _$LinkedinAccountsController {
  @override
  Future<List<LinkedinAccount>> build() =>
      ref.watch(settingsRepositoryProvider).fetchLinkedinAccounts();

  /// Disconnects [accountId]. Returns the failure message, or null.
  ///
  /// Posts survive, detached. Schedules do not — the confirm dialog says
  /// both, because "disconnect" on its own does not tell the user which of
  /// their things are about to stop.
  Future<String?> disconnect(String accountId) async {
    try {
      await ref.read(settingsRepositoryProvider).disconnectLinkedin(accountId);
    } on Object {
      return "We couldn't disconnect that account. Nothing changed.";
    }
    ref.invalidateSelf();
    return null;
  }

  /// Runs the browser hand-off for [type] (`personal` | `company`) and
  /// refreshes the list on success.
  ///
  /// Returns the outcome rather than throwing so the caller can stay silent on
  /// a cancel and speak only on a real failure.
  Future<ConnectOutcome> connect(String type) async {
    final ConnectOutcome outcome = await ref
        .read(settingsRepositoryProvider)
        .connectLinkedin(type: type);
    if (outcome is ConnectSucceeded) {
      state = const AsyncLoading<List<LinkedinAccount>>();
      state = await AsyncValue.guard(
        () => ref.read(settingsRepositoryProvider).fetchLinkedinAccounts(),
      );
    }
    return outcome;
  }
}

/// The personal LinkedIn account, or null.
///
/// The web treats a row with no `appType` as personal — older rows predate the
/// column — and this must match, or a long-standing user's only account
/// silently disappears from the page.
@riverpod
LinkedinAccount? personalLinkedinAccount(Ref ref) {
  final List<LinkedinAccount>? accounts = ref
      .watch(linkedinAccountsControllerProvider)
      .value;
  if (accounts == null) return null;
  for (final LinkedinAccount account in accounts) {
    if (!account.isCompany) return account;
  }
  return null;
}

/// The company LinkedIn account, or null.
@riverpod
LinkedinAccount? companyLinkedinAccount(Ref ref) {
  final List<LinkedinAccount>? accounts = ref
      .watch(linkedinAccountsControllerProvider)
      .value;
  if (accounts == null) return null;
  for (final LinkedinAccount account in accounts) {
    if (account.isCompany) return account;
  }
  return null;
}

/// Slack connection status + disconnect.
@riverpod
class SlackController extends _$SlackController {
  @override
  Future<SlackConnection> build() =>
      ref.watch(settingsRepositoryProvider).fetchSlack();

  /// Runs the browser hand-off and refreshes on success.
  ///
  /// Returns the outcome rather than throwing so the caller can stay silent
  /// on a cancel — the same contract the LinkedIn connect uses.
  Future<ConnectOutcome> connect() async {
    final ConnectOutcome outcome =
        await ref.read(settingsRepositoryProvider).connectSlack();
    if (outcome is ConnectSucceeded) {
      state = const AsyncLoading<SlackConnection>();
      state = await AsyncValue.guard(
        () => ref.read(settingsRepositoryProvider).fetchSlack(),
      );
    }
    return outcome;
  }

  Future<void> disconnect() async {
    await ref.read(settingsRepositoryProvider).disconnectSlack();
    state = const AsyncData<SlackConnection>(SlackConnection());
  }
}

/// WhatsApp status. The read half.
///
/// Unlike Slack and Calendar there is NO browser hand-off: the user types a
/// number here and proves it with a code, so the flow has two steps and an
/// in-flight state. That state lives in [WhatsAppActions], not here and not
/// on the row — see `test/architecture/no_async_state_in_widgets_test.dart`,
/// which exists because a `bool _busy` on a widget has shipped as a
/// user-visible defect five times in this codebase.
@riverpod
class WhatsAppController extends _$WhatsAppController {
  @override
  Future<WhatsAppConnection> build() =>
      ref.watch(settingsRepositoryProvider).fetchWhatsApp();
}

/// What is in flight, and what last failed.
///
/// Mirrors [LearnBusy]'s shape for the same reason: the row has to disable
/// four different controls while any one of them is running, and show one
/// sentence when one of them refuses.
class WhatsAppBusy {
  const WhatsAppBusy({this.busy = false, this.error});

  final bool busy;

  /// The sentence to show. Null when nothing has failed since the last action.
  final String? error;
}

/// Connect, verify, disconnect, resume.
///
/// Every failure the user can act on arrives here as its own type and is
/// turned into its sentence: each of the four is an ANSWER — wait, agree,
/// retype, fix the number — and folding them into "something went wrong"
/// throws away the only part the user can do anything with.
@riverpod
class WhatsAppActions extends _$WhatsAppActions {
  @override
  WhatsAppBusy build() => const WhatsAppBusy();

  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  /// Send a code to a typed number.
  Future<void> sendCode(String phone, {String? defaultCountryCode}) =>
      _run(
        () => _repo.sendWhatsAppCode(
          phone: phone,
          defaultCountryCode: defaultCountryCode,
        ),
      );

  /// Check the code. The number is verified only if this succeeds.
  Future<void> confirmCode(String code) =>
      _run(() => _repo.confirmWhatsAppCode(code));

  Future<void> disconnect() => _run(_repo.disconnectWhatsApp);

  /// Turn messages back on after a STOP.
  Future<void> resume() => _run(_repo.resumeWhatsApp);

  Future<void> _run(Future<void> Function() action) async {
    state = const WhatsAppBusy(busy: true);
    try {
      await action();
      if (!ref.mounted) return;
      state = const WhatsAppBusy();
      // Re-read rather than patch locally. Three of these four writes have
      // server-side consequences the client cannot derive — a disconnect
      // keeps the row when the user has opted out, and a send starts a clock.
      // Guessing the new state here is how the row and the server drift.
      ref.invalidate(whatsAppControllerProvider);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = WhatsAppBusy(error: _say(e));
    }
  }

  /// The server's own sentence where there is one.
  static String _say(Object error) => switch (error) {
    WhatsAppCooldown(:final String message) => message,
    WhatsAppConsentRequired(:final String message) => message,
    WhatsAppWrongCode(:final String message) => message,
    WhatsAppRejected(:final String message) => message,
    _ => 'That did not go through. Try again.',
  };
}

/// Google Calendar connection status + disconnect.
@riverpod
class CalendarController extends _$CalendarController {
  @override
  Future<CalendarConnection> build() =>
      ref.watch(settingsRepositoryProvider).fetchCalendar();

  Future<ConnectOutcome> connect() async {
    final ConnectOutcome outcome =
        await ref.read(settingsRepositoryProvider).connectCalendar();
    if (outcome is ConnectSucceeded) {
      state = const AsyncLoading<CalendarConnection>();
      state = await AsyncValue.guard(
        () => ref.read(settingsRepositoryProvider).fetchCalendar(),
      );
    }
    return outcome;
  }

  Future<void> disconnect() async {
    await ref.read(settingsRepositoryProvider).disconnectCalendar();
    state = const AsyncData<CalendarConnection>(CalendarConnection());
  }
}

/// Localised plan pricing.
///
/// The country comes from the device's locale rather than an IP lookup: the
/// mobile pricing route takes `?country=` precisely so the client can answer
/// that question itself, and an IP guess on a phone is wrong as often as it is
/// right (roaming, VPN, carrier egress in another country).
@riverpod
Future<GeoPricing> geoPricing(Ref ref) {
  final String? country = PlatformDispatcher.instance.locale.countryCode;
  return ref.watch(settingsRepositoryProvider).fetchPricing(
    countryCode: country,
  );
}

/// The LinkedIn company pages this account can publish to.
///
/// Its own provider rather than part of [accountSnapshot] for the reason
/// stated at the top of this file: one combined fetch makes a slow or failing
/// LinkedIn call take the whole Settings screen with it. This one calls
/// LinkedIn's `organizationAcls` live, so it is the slowest thing here.
@riverpod
class CompanyPagesController extends _$CompanyPagesController {
  @override
  Future<CompanyPageOptions> build() =>
      ref.watch(settingsRepositoryProvider).fetchCompanyPages();

  /// Resolves a pasted company URL or numeric id into a page.
  ///
  /// Kept separate from [build] so a bad paste replaces only the list, and a
  /// user who mistypes can try again without losing the screen.
  Future<void> lookup(String vanityNameOrId) async {
    state = const AsyncLoading<CompanyPageOptions>();
    state = await AsyncValue.guard(
      () => ref
          .read(settingsRepositoryProvider)
          .fetchCompanyPages(vanityName: vanityNameOrId),
    );
  }

  /// Saves the page, then refreshes the accounts list so the row stops
  /// reporting "no page chosen".
  ///
  /// Returns the failure message, or null on success — the caller decides
  /// whether to speak, the same contract [LinkedinAccountsController.connect]
  /// uses.
  Future<String?> choose(String orgId) async {
    try {
      await ref.read(settingsRepositoryProvider).setCompanyPage(orgId);
    } on Object {
      return "We couldn't save that page. Try again.";
    }
    ref.invalidate(linkedinAccountsControllerProvider);
    ref.invalidateSelf();
    return null;
  }
}

/// The DPDP s6 consent ledger.
///
/// Its own provider because consent is the one thing on this screen a user
/// may come specifically to change, often in a hurry — it should load and
/// fail independently of whether LinkedIn or Razorpay are reachable.
@riverpod
class ConsentController extends _$ConsentController {
  @override
  Future<ConsentLedger> build() =>
      ref.watch(settingsRepositoryProvider).fetchConsents();

  /// Records a decision. Returns the failure message, or null on success.
  ///
  /// The server answers with the whole ledger, and that answer replaces local
  /// state rather than a locally-toggled guess: it is the only thing that
  /// knows whether a withdrawal was accepted, and a switch that flips before
  /// the server agrees is a switch that can lie about consent.
  Future<String?> set(String purpose, bool granted) async {
    try {
      final ConsentLedger updated = await ref
          .read(settingsRepositoryProvider)
          .setConsent(purpose: purpose, granted: granted);
      state = AsyncData<ConsentLedger>(updated);
      return null;
    } on Object {
      // Re-read rather than assume: a refused withdrawal has to show as
      // still-granted, not as whatever the user tapped.
      ref.invalidateSelf();
      return "We couldn't record that. Your previous choice still stands.";
    }
  }
}
