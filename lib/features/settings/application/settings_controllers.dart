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

/// The preferences row — the keystone the whole screen branches on.
///
/// Writes are **partial**: every mutator sends only the keys it changed. The
/// server's schema is `.strict()`, so an unknown key rejects the entire
/// payload with a 400 rather than being dropped, and it strips undefined keys
/// so a small write can never null out an unrelated column.
@riverpod
class PreferencesController extends _$PreferencesController {
  @override
  Future<UserPreferences> build() =>
      ref.watch(settingsRepositoryProvider).fetchPreferences();

  /// Profile Details — the web's first section.
  Future<void> saveProfile({
    required String profession,
    required String headline,
  }) => _patch(<String, dynamic>{
    'profession': profession,
    'headline': headline,
  });

  /// Which brand the user runs. Changing it re-shapes navigation, the compose
  /// screen and half of this page, so it is deliberately its own save rather
  /// than a field inside a bigger form.
  Future<void> saveBrandType(String brandType) =>
      _patch(<String, dynamic>{'brandType': brandType});

  /// Cadence — how often and when the week publishes.
  ///
  /// `preferredDays` is a list of `DateTime.weekday`-style day numbers in the
  /// server's convention, which is **0 = Sunday** (the zod schema is
  /// `min(0).max(6)`), NOT Dart's 1 = Monday. The UI converts at the edge.
  Future<void> saveCadence({
    int? postsPerWeek,
    List<int>? preferredDays,
    String? preferredTime,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (postsPerWeek != null) patch['postsPerWeek'] = postsPerWeek;
    if (preferredDays != null) patch['preferredDays'] = preferredDays;
    if (preferredTime != null) patch['preferredTime'] = preferredTime;
    return _patch(patch);
  }

  /// Where approval requests are delivered. Wire values are
  /// `slack` | `whatsapp` | `email`; the web offers the first two.
  Future<void> saveApprovalChannel(String channel) =>
      _patch(<String, dynamic>{'approvalChannel': channel});

  /// Company-brand identity. Company users only — these anchor the voice every
  /// company post is written in.
  Future<void> saveCompanyBrand({
    String? companyIndustry,
    String? companyWebsite,
    String? companyTagline,
    String? companyDescription,
    List<String>? companyFeatures,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (companyIndustry != null) patch['companyIndustry'] = companyIndustry;
    if (companyWebsite != null) patch['companyWebsite'] = companyWebsite;
    if (companyTagline != null) patch['companyTagline'] = companyTagline;
    if (companyDescription != null) {
      patch['companyDescription'] = companyDescription;
    }
    if (companyFeatures != null) patch['companyFeatures'] = companyFeatures;
    return _patch(patch);
  }

  /// Who the user writes for. Lives on preferences, which is why the Persona
  /// screen's audience block is editable at all — see `features/persona`.
  Future<void> saveAudience({
    String? serveRole,
    String? serveIndustry,
    String? problemSolved,
  }) {
    final Map<String, dynamic> patch = <String, dynamic>{};
    if (serveRole != null) patch['serveRole'] = serveRole;
    if (serveIndustry != null) patch['serveIndustry'] = serveIndustry;
    if (problemSolved != null) patch['problemSolved'] = problemSolved;
    return _patch(patch);
  }

  /// Applies [patch] and publishes the server's row.
  ///
  /// Not optimistic. Every write here is a deliberate "Save" tap with a busy
  /// button attached, so there is no dead-feeling UI to paper over — and a
  /// setting that appears to save and then quietly reverts is worse than one
  /// that takes a beat.
  Future<void> _patch(Map<String, dynamic> patch) async {
    if (patch.isEmpty) return;
    final UserPreferences updated = await ref
        .read(settingsRepositoryProvider)
        .updatePreferences(patch);
    state = AsyncData<UserPreferences>(updated);
  }
}

/// Identity + billing state, from `GET /auth/me`.
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
