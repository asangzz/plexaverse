import '../../preferences/domain/user_preferences.dart';
import 'settings_entities.dart';

export '../../preferences/domain/user_preferences.dart';
export 'settings_entities.dart';

/// Thrown when a Settings read or write can't be satisfied.
///
/// One const sentinel for the whole feature, per the slice convention — the UI
/// never branches on a typed error taxonomy, only on "this section couldn't
/// load", and each section renders its own retry.
class SettingsUnavailable implements Exception {
  const SettingsUnavailable();
}

/// Seam between the Settings / Accounts screens and the mobile API.
///
/// This replaces the previous local-only repository, which read a bundled
/// fixture (`assets/mock/settings/profile.json`) and a "Digital Twin" quota
/// object that has no counterpart anywhere in Plexaverse — it was inherited
/// wholesale from the skin this app was cloned from. Every method below
/// corresponds to a route that actually exists in
/// `core/network/api_paths.dart`.
///
/// ## What is deliberately absent
///
/// The web's Settings page also edits the avatar, the display name, the Studio
/// API token, the privacy/consent ledger and the account-deletion flow. None of
/// those have a mobile route (`/user/profile`, `/user/avatar`, `/studio/token`,
/// `/user/data-export`, the DPDP consent endpoints), so there is nothing to put
/// behind a method here. The screens surface an explicit unavailable state
/// instead of a button that would 404 — the failure mode this whole file exists
/// to avoid.
///
/// ## Why there is no `connectSlack` / `connectCalendar`
///
/// `POST /slack/auth-url` and `POST /google-calendar/auth-url` both exist, and
/// both bake in the **web** callback (`/api/slack/callback`,
/// `/api/google/callback`). An https redirect is not interceptable by
/// `flutter_web_auth_2` without verified App/Universal Links, so the browser
/// genuinely loads it and the hand-off dead-ends — precisely the bug the
/// LinkedIn work fixed by adding `/api/linkedin/mobile-callback`, a bridge that
/// forwards `code`/`state` on to `plexaverse://`. Slack and Google have no such
/// bridge. A Connect button that opens a browser the app can never be handed
/// back from is worse than saying so, so those rows read status and disconnect
/// only.
abstract class SettingsRepository {
  /// The preferences row. The server answers `{exists: false}` for a user who
  /// has never completed onboarding; that is a value, not an error.
  Future<UserPreferences> fetchPreferences();

  /// Partial upsert. **Send only what changed** — the server strips undefined
  /// fields so a small write cannot null out an unrelated column, and its zod
  /// schema is `.strict()`, so an unknown key rejects the WHOLE payload with a
  /// 400 rather than being ignored.
  Future<UserPreferences> updatePreferences(Map<String, dynamic> patch);

  /// Identity + billing state. See [AccountSnapshot].
  Future<AccountSnapshot> fetchAccount();

  /// The XP balance shown beside the plan.
  Future<XpSummary> fetchXp();

  /// Every connected LinkedIn profile, personal and company.
  Future<List<LinkedinAccount>> fetchLinkedinAccounts();

  /// Runs the whole LinkedIn hand-off for [type] (`personal` | `company`):
  /// fetch the authorize URL, open the system browser, exchange the returned
  /// code. Never throws — the failure is the returned [ConnectOutcome].
  ///
  /// There is no popup branch. The web keeps one for desktop and falls back to
  /// a same-tab redirect on a coarse pointer; a phone only ever had the second
  /// branch, and this is it.
  Future<ConnectOutcome> connectLinkedin({required String type});

  Future<SlackConnection> fetchSlack();

  /// Disconnects Slack. `DELETE /slack`.
  Future<void> disconnectSlack();

  Future<CalendarConnection> fetchCalendar();

  /// Disconnects Google Calendar. `DELETE /google-calendar`.
  Future<void> disconnectCalendar();

  /// Localised plan pricing. [countryCode] is the device's region; the server
  /// defaults to `IN` when it is absent or unrecognised.
  Future<GeoPricing> fetchPricing({String? countryCode});
}
