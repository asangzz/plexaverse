import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/platform/web_auth.dart';
// Re-exports `UserPreferences` alongside the Settings entities.
import '../domain/settings_repository.dart';

/// Dio-backed [SettingsRepository].
///
/// [DioClient] unwraps the mobile API's `{data, error, meta}` envelope at its
/// parse seam, so on success `response.data` is already the inner object.
class ApiSettingsRepository implements SettingsRepository {
  const ApiSettingsRepository(this._client, this._webAuth);

  final DioClient _client;
  final WebAuthService _webAuth;

  /// The custom scheme the LinkedIn hand-off returns on.
  ///
  /// The server's `redirect_uri` is the https bridge
  /// (`/api/linkedin/mobile-callback`), which forwards `code`/`state` to
  /// `plexaverse://oauth/linkedin`. That scheme is registered natively, so the
  /// OS hands control back to the app even when LinkedIn's 2FA has bounced the
  /// user into the LinkedIn app mid-flow.
  static const String _callbackScheme = 'plexaverse';

  @override
  Future<UserPreferences> fetchPreferences() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.userPreferences,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const SettingsUnavailable();
      return UserPreferences.fromJson(data);
    } on SettingsUnavailable {
      rethrow;
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<UserPreferences> updatePreferences(Map<String, dynamic> patch) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        ApiPaths.userPreferences,
        data: patch,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const SettingsUnavailable();
      // PATCH answers with the preferences row but without the `exists`
      // sentinel the GET adds, so re-assert it: a row we just wrote exists by
      // definition, and letting it default to false would bounce the user
      // back into onboarding on the next read of this object.
      return UserPreferences.fromJson(<String, dynamic>{
        'exists': true,
        ...data,
      });
    } on SettingsUnavailable {
      rethrow;
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<bool> setAutoPostEnabled(bool enabled) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiPaths.userAutoPostToggle,
      data: <String, dynamic>{'enabled': enabled},
    );
    return (response.data?['autoPostEnabled'] as bool?) ?? enabled;
  }

  @override
  Future<AccountSnapshot> fetchAccount() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.me);
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const SettingsUnavailable();
      return AccountSnapshot.fromJson(data);
    } on SettingsUnavailable {
      rethrow;
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<XpSummary> fetchXp() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiPaths.userXp);
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const SettingsUnavailable();
      return XpSummary.fromJson(data);
    } on SettingsUnavailable {
      rethrow;
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<List<LinkedinAccount>> fetchLinkedinAccounts() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.linkedInAccounts,
      );
      final List<dynamic>? raw = response.data?['accounts'] as List<dynamic>?;
      if (raw == null) return const <LinkedinAccount>[];
      return raw
          .cast<Map<String, dynamic>>()
          .map(LinkedinAccount.fromJson)
          .toList(growable: false);
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<ConnectOutcome> connectLinkedin({required String type}) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiPaths.linkedInAuthUrl,
        data: <String, dynamic>{'type': type},
      );
      final String? authUrl = response.data?['authUrl'] as String?;
      if (authUrl == null || authUrl.isEmpty) return const ConnectFailed();

      final WebAuthResult result = await _webAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: _callbackScheme,
      );

      switch (result) {
        case WebAuthCancelled():
          return const ConnectCancelled();
        case WebAuthFailure():
          return const ConnectFailed();
        case WebAuthSuccess(:final String callbackUrl):
          final String? code = Uri.parse(callbackUrl).queryParameters['code'];
          // No code on an otherwise-successful redirect means the user backed
          // out at LinkedIn's own consent screen, which is a cancel, not a
          // failure — an error banner there would blame the app for the user's
          // decision.
          if (code == null || code.isEmpty) return const ConnectCancelled();
          await _client.post<Map<String, dynamic>>(
            ApiPaths.linkedInExchange,
            data: <String, dynamic>{'code': code, 'type': type},
          );
          return const ConnectSucceeded();
      }
    } on Object {
      return const ConnectFailed();
    }
  }

  @override
  Future<SlackConnection> fetchSlack() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.slackStatus,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const SlackConnection();
      return SlackConnection.fromJson(data);
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<void> disconnectSlack() async {
    try {
      await _client.delete<Map<String, dynamic>>(ApiPaths.slack);
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<CalendarConnection> fetchCalendar() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.googleCalendarStatus,
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) return const CalendarConnection();
      return CalendarConnection.fromJson(data);
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<void> disconnectCalendar() async {
    try {
      await _client.delete<Map<String, dynamic>>(ApiPaths.googleCalendar);
    } on Object {
      throw const SettingsUnavailable();
    }
  }

  @override
  Future<GeoPricing> fetchPricing({String? countryCode}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiPaths.geoPricing,
        queryParameters: countryCode == null
            ? null
            : <String, dynamic>{'country': countryCode},
      );
      final Map<String, dynamic>? data = response.data;
      if (data == null) throw const SettingsUnavailable();
      return GeoPricing.fromJson(data);
    } on SettingsUnavailable {
      rethrow;
    } on Object {
      throw const SettingsUnavailable();
    }
  }
}

/// In-memory [SettingsRepository] for the `mock` flavor.
///
/// Shaped so every state the screens can render is reachable without a
/// backend: a healthy personal LinkedIn account, a company account whose token
/// has expired (the amber "reconnect" row), Slack connected, Calendar not.
///
/// It holds its preferences in a field rather than re-reading a fixture, so a
/// save in the mock flavor actually sticks for the session — a settings screen
/// whose writes silently revert is not testable.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository();

  UserPreferences _preferences = const UserPreferences(
    exists: true,
    onboardingCompleted: true,
    brandType: 'personal',
    postsPerWeek: 7,
    preferredDays: <int>[1, 3, 5],
    preferredTime: '09:00',
    timezone: 'Asia/Kolkata',
    profession: 'Mobile Application Developer',
    headline: 'Building next-gen apps 🚀',
    industry: 'Software',
    approvalChannel: 'slack',
    skills: <String>['Flutter', 'Dart', 'Design systems'],
    postCategories: <String>['Engineering', 'Career'],
  );

  SlackConnection _slack = SlackConnection(
    isConnected: true,
    teamName: 'Plexaverse HQ',
    teamId: 'T0FAKE',
    connectedAt: DateTime(2026, 5, 2),
  );

  CalendarConnection _calendar = const CalendarConnection();

  static const Duration _latency = Duration(milliseconds: 220);

  @override
  Future<UserPreferences> fetchPreferences() async {
    await Future<void>.delayed(_latency);
    return _preferences;
  }

  @override
  Future<UserPreferences> updatePreferences(Map<String, dynamic> patch) async {
    await Future<void>.delayed(_latency);
    // Round-trip through JSON so the fake applies a patch exactly the way the
    // server does — by key, onto the existing row — instead of hand-copying
    // fields and quietly drifting from the real merge.
    _preferences = UserPreferences.fromJson(<String, dynamic>{
      ..._preferences.toJson(),
      ...patch,
      'exists': true,
    });
    return _preferences;
  }

  @override
  Future<bool> setAutoPostEnabled(bool enabled) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _preferences = _preferences.copyWith(autoPostEnabled: enabled);
    return enabled;
  }

  @override
  Future<AccountSnapshot> fetchAccount() async {
    await Future<void>.delayed(_latency);
    return AccountSnapshot(
      user: const AccountIdentity(
        id: 'user_fake',
        name: 'Asang Borkar',
        email: 'asang@example.com',
        xpBalance: 8450,
      ),
      subscription: SubscriptionState(
        status: 'active',
        paymentMode: 'subscription',
        currentPeriodEnd: DateTime.now().add(const Duration(days: 19)),
      ),
    );
  }

  @override
  Future<XpSummary> fetchXp() async {
    await Future<void>.delayed(_latency);
    return const XpSummary(balance: 8450);
  }

  @override
  Future<List<LinkedinAccount>> fetchLinkedinAccounts() async {
    await Future<void>.delayed(_latency);
    return <LinkedinAccount>[
      LinkedinAccount(
        id: 'li_personal',
        profileId: 'abc123',
        profileName: 'Asang Borkar',
        profileHeadline: 'Building next-gen apps',
        expiresAt: DateTime.now().add(const Duration(days: 40)),
        needsReconnect: false,
      ),
      LinkedinAccount(
        id: 'li_company',
        profileId: 'company_user_fake',
        profileName: 'Plexaverse',
        appType: 'company',
        expiresAt: DateTime.now().subtract(const Duration(days: 2)),
        needsReconnect: true,
      ),
    ];
  }

  @override
  Future<ConnectOutcome> connectLinkedin({required String type}) async {
    await Future<void>.delayed(_latency);
    return const ConnectSucceeded();
  }

  @override
  Future<SlackConnection> fetchSlack() async {
    await Future<void>.delayed(_latency);
    return _slack;
  }

  @override
  Future<void> disconnectSlack() async {
    await Future<void>.delayed(_latency);
    _slack = const SlackConnection();
  }

  @override
  Future<CalendarConnection> fetchCalendar() async {
    await Future<void>.delayed(_latency);
    return _calendar;
  }

  @override
  Future<void> disconnectCalendar() async {
    await Future<void>.delayed(_latency);
    _calendar = const CalendarConnection();
  }

  @override
  Future<GeoPricing> fetchPricing({String? countryCode}) async {
    await Future<void>.delayed(_latency);
    return const GeoPricing(personalPrice: 299, companyPrice: 1199);
  }
}

/// Mock ↔ real switch on `useFakeBackend`. A release build can never resolve
/// the fake — the assert mirrors every other slice.
final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>((Ref ref) {
      final bool useFake = ref.watch(useFakeBackendProvider);
      assert(
        !(kReleaseMode && useFake),
        'useFakeBackend must be false in release builds.',
      );
      if (useFake && !kReleaseMode) return FakeSettingsRepository();
      return ApiSettingsRepository(
        ref.watch(dioClientProvider),
        ref.watch(webAuthServiceProvider),
      );
    });
