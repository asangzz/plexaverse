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

  Future<void> disconnect() async {
    await ref.read(settingsRepositoryProvider).disconnectSlack();
    state = const AsyncData<SlackConnection>(SlackConnection());
  }
}

/// Google Calendar connection status + disconnect.
@riverpod
class CalendarController extends _$CalendarController {
  @override
  Future<CalendarConnection> build() =>
      ref.watch(settingsRepositoryProvider).fetchCalendar();

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
