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
