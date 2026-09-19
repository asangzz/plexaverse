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
  /// Partial upsert. **Send only what changed** — the server strips undefined
  /// fields so a small write cannot null out an unrelated column, and its zod
  /// schema is `.strict()`, so an unknown key rejects the WHOLE payload with a
  /// Flips the auto-post kill switch. Returns the new value.
  ///
  /// Its own call rather than a field on [updatePreferences], because it is not
  /// a preference: enabling stamps a resume time (giving the server's
  /// auto-pause engine a clean slate), re-arms the next generation task, and
  /// clears stale "Auto-post paused" notifications. `autoPostEnabled` is
  /// deliberately absent from the preferences PATCH schema for that reason —
  /// it is a state machine, not a column you set.
  Future<bool> setAutoPostEnabled(bool enabled);

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

  /// Connects Slack through the system browser.
  ///
  /// Same shape as [connectLinkedin], and for the same reason it took a
  /// server-side bridge to become possible: Slack accepts only https
  /// redirect URLs, so the hand-off returns to
  /// `/api/slack/mobile-callback`, which hops to `plexaverse://`.
  Future<ConnectOutcome> connectSlack();

  /// Disconnects Slack. `DELETE /slack`.
  Future<void> disconnectSlack();

  Future<CalendarConnection> fetchCalendar();

  /// Connects Google Calendar through the system browser. Uses its OWN
  /// bridge, not the sign-in one — different scopes, different landing.
  Future<ConnectOutcome> connectCalendar();

  /// Disconnects Google Calendar. `DELETE /google-calendar`.
  Future<void> disconnectCalendar();

  /// The LinkedIn company pages this account administers.
  ///
  /// The server answers three different ways from one route, and the UI has to
  /// handle all three: the pages fetched live from LinkedIn; a single saved
  /// page when one is already chosen; or an empty list with
  /// [CompanyPageOptions.needsManualInput] set, which happens when the
  /// `rw_organization_admin` scope was not granted or LinkedIn returned
  /// nothing. That last case is why the manual entry field is not optional
  /// polish — for some accounts it is the only way through.
  ///
  /// [vanityName] accepts a full company URL or a numeric page id, mirroring
  /// what the web's field takes.
  Future<CompanyPageOptions> fetchCompanyPages({String? orgId, String? vanityName});

  /// Saves the chosen page onto the connected company account. `PATCH
  /// /linkedin/organizations`.
  Future<void> setCompanyPage(String orgId);

  /// Disconnects a LinkedIn account. `DELETE /linkedin/accounts`.
  ///
  /// Posts authored by it SURVIVE, detached — the server nulls their FK
  /// before deleting, because `Post.account` cascades. Recurring schedules
  /// do not survive: one pointing at no account cannot fire.
  Future<void> disconnectLinkedin(String accountId);

  /// Uploads an image and returns its URL. Used for the company logo.
  Future<String> uploadImage(String dataUri);

  /// The DPDP s6 consent ledger — every purpose with its current decision.
  Future<ConsentLedger> fetchConsents();

  /// Records one consent decision. Returns the updated ledger.
  ///
  /// The server refuses to withdraw a REQUIRED purpose while the account
  /// exists, because there would be no lawful basis to keep serving it — the
  /// honest answer is deletion, not a withdrawal nobody honours.
  Future<ConsentLedger> setConsent({
    required String purpose,
    required bool granted,
  });

  /// DPDP s11 — everything held about the user, as a JSON map the app can
  /// render and share.
  Future<Map<String, dynamic>> fetchDataExport();

  /// DPDP s12 erasure. Irreversible.
  ///
  /// Returns what SURVIVED — some records are kept under a statutory
  /// carve-out, and reporting a clean deletion when that is untrue misleads
  /// the person exercising the right.
  Future<List<String>> deleteAccount({required String password});

  /// Localised plan pricing. [countryCode] is the device's region; the server
  /// defaults to `IN` when it is absent or unrecognised.
  Future<GeoPricing> fetchPricing({String? countryCode});
}


/// One LinkedIn company page the connected account administers.
class CompanyPage {
  const CompanyPage({
    required this.id,
    required this.name,
    this.saved = false,
  });

  factory CompanyPage.fromJson(Map<String, dynamic> json) => CompanyPage(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] as String?) ?? '',
    saved: json['saved'] == true,
  );

  final String id;
  final String name;

  /// True for the page already stored on the account.
  final bool saved;
}

/// What `GET /linkedin/organizations` answered.
class CompanyPageOptions {
  const CompanyPageOptions({
    this.pages = const <CompanyPage>[],
    this.needsManualInput = false,
    this.message,
  });

  final List<CompanyPage> pages;

  /// True when the server could not list pages and the user must type the
  /// numeric page id themselves. Not an error — see [fetchCompanyPages].
  final bool needsManualInput;

  /// The server's own explanation, written to be shown.
  final String? message;
}


/// One thing the user can agree to, independently.
class ConsentPurposeState {
  const ConsentPurposeState({
    required this.purpose,
    required this.label,
    required this.granted,
    required this.required_,
    required this.stale,
  });

  factory ConsentPurposeState.fromJson(Map<String, dynamic> json) =>
      ConsentPurposeState(
        purpose: (json['purpose'] as String?) ?? '',
        label: (json['label'] as String?) ?? '',
        granted: json['granted'] == true,
        required_: json['required'] == true,
        stale: json['stale'] == true,
      );

  final String purpose;
  final String label;
  final bool granted;

  /// Cannot be withdrawn while the account exists.
  final bool required_;

  /// A decision exists but predates the current notice, so it is not a
  /// current yes. The UI asks again rather than showing it as granted.
  final bool stale;
}

class ConsentLedger {
  const ConsentLedger({required this.noticeVersion, required this.purposes});

  final String noticeVersion;
  final List<ConsentPurposeState> purposes;
}
