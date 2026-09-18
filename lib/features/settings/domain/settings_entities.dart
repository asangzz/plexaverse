import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entities.freezed.dart';
part 'settings_entities.g.dart';

/// The signed-in account, as `GET /auth/me` returns its `user` object.
///
/// The web reads the same fields off the NextAuth session (`session.user`),
/// which is why Settings' Account section can show a name, an email and an
/// avatar without a second fetch. On mobile there is no session cookie, so
/// `/auth/me` is that fetch — and it is deliberately a live read rather than a
/// token decode: `role`, `xpBalance` and the subscription state all change
/// without the access token being re-issued.
@freezed
abstract class AccountIdentity with _$AccountIdentity {
  const AccountIdentity._();

  const factory AccountIdentity({
    required String id,
    @Default('') String name,
    @Default('') String email,

    /// The server sends the avatar under `image`; the app calls it what it is.
    @JsonKey(name: 'image') String? avatarUrl,
    @Default('user') String role,
    @Default(0) int xpBalance,
  }) = _AccountIdentity;

  factory AccountIdentity.fromJson(Map<String, dynamic> json) =>
      _$AccountIdentityFromJson(json);

  /// The letter in the avatar fallback. The web uses the same rule —
  /// `name?.[0]` — and falls back to the email when the name is blank.
  String get initial {
    final String source = name.trim().isNotEmpty ? name.trim() : email.trim();
    return source.isEmpty ? '?' : source[0].toUpperCase();
  }

  bool get isAdmin => role == 'admin';
}

/// Billing state, as `GET /auth/me` returns its `subscription` object.
///
/// `status` and `paymentMode` are denormalised onto the User row by the
/// Razorpay webhook, so they are current the moment the webhook lands; only
/// `currentPeriodEnd` comes from the joined Subscription row.
@freezed
abstract class SubscriptionState with _$SubscriptionState {
  const SubscriptionState._();

  const factory SubscriptionState({
    /// `'active'` while the plan is paid up. Anything else — including null for
    /// an account that has never paid — is treated as inactive.
    String? status,

    /// `'subscription'` (autopay mandate) or `'onetime'` (a single XP top-up).
    String? paymentMode,
    DateTime? currentPeriodEnd,
  }) = _SubscriptionState;

  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  bool get isActive => status == 'active';

  /// True when the plan renews on its own. The web shows "cancel anytime"
  /// copy only on this branch.
  bool get isRecurring => paymentMode == 'subscription';
}

/// The whole `/auth/me` payload.
@freezed
abstract class AccountSnapshot with _$AccountSnapshot {
  const AccountSnapshot._();

  const factory AccountSnapshot({
    required AccountIdentity user,
    @Default(SubscriptionState()) SubscriptionState subscription,
  }) = _AccountSnapshot;

  factory AccountSnapshot.fromJson(Map<String, dynamic> json) =>
      _$AccountSnapshotFromJson(json);
}

/// One connected LinkedIn profile, as `GET /linkedin/accounts` returns it.
///
/// Tokens are never on the wire — only the read-safe profile fields the
/// connected-accounts rows render.
@freezed
abstract class LinkedinAccount with _$LinkedinAccount {
  const LinkedinAccount._();

  const factory LinkedinAccount({
    required String id,
    @Default('') String profileId,
    @Default('') String profileName,
    String? profileHeadline,
    String? profileImage,

    /// The company page's vanity slug. Null on a company account means the
    /// user has connected the company app but not yet chosen which page to
    /// post to — the web opens its page-picker on exactly that condition.
    String? profileSlug,
    DateTime? expiresAt,
    @Default('personal') String appType,

    /// The server's own verdict on whether this account can still publish.
    /// Nullable on purpose: the web's `isLinkedinAccountHealthy` PREFERS this
    /// boolean and only falls back to the expiry when the field is absent, and
    /// defaulting it to `false` here would silently turn a missing field into
    /// "healthy" for an expired token.
    bool? needsReconnect,
  }) = _LinkedinAccount;

  factory LinkedinAccount.fromJson(Map<String, dynamic> json) =>
      _$LinkedinAccountFromJson(json);

  bool get isCompany => appType == 'company';

  /// Mirrors `isLinkedinAccountHealthy()` in
  /// `hooks/queries/useLinkedinAccounts.ts`, including its precedence.
  ///
  /// A row existing is NOT the same as the connection working: a token can be
  /// dead while the row is still there, which is the "shows Connected but
  /// can't publish" bug this helper exists to prevent.
  bool get isHealthy {
    if (needsReconnect != null) return !needsReconnect!;
    final DateTime? expiry = expiresAt;
    return expiry == null || expiry.isAfter(DateTime.now());
  }

  /// A connected row whose token has died — the "reconnect" state.
  bool get needsAttention => !isHealthy;
}

/// Slack connection status, as `GET /slack/status` returns it.
///
/// The endpoint never 404s a disconnected user; it answers
/// `isConnected: false` with null fields, so this model has no "absent" case.
@freezed
abstract class SlackConnection with _$SlackConnection {
  const SlackConnection._();

  const factory SlackConnection({
    @Default(false) bool isConnected,
    String? teamName,
    String? teamId,
    String? channelId,
    DateTime? connectedAt,
  }) = _SlackConnection;

  factory SlackConnection.fromJson(Map<String, dynamic> json) =>
      _$SlackConnectionFromJson(json);
}

/// The token half of `GET /google-calendar/status`.
@freezed
abstract class CalendarTokenStatus with _$CalendarTokenStatus {
  const CalendarTokenStatus._();

  const factory CalendarTokenStatus({
    @Default(false) bool expired,
    DateTime? expiresAt,
    @Default(0) int expiresInMinutes,
  }) = _CalendarTokenStatus;

  factory CalendarTokenStatus.fromJson(Map<String, dynamic> json) =>
      _$CalendarTokenStatusFromJson(json);
}

/// Google Calendar connection status, as `GET /google-calendar/status`
/// returns it.
@freezed
abstract class CalendarConnection with _$CalendarConnection {
  const CalendarConnection._();

  const factory CalendarConnection({
    @Default(false) bool isConnected,
    String? calendarId,
    DateTime? connectedAt,
    @Default(CalendarTokenStatus()) CalendarTokenStatus tokenStatus,
  }) = _CalendarConnection;

  factory CalendarConnection.fromJson(Map<String, dynamic> json) =>
      _$CalendarConnectionFromJson(json);

  /// Connected, but the stored Google token has lapsed — the calendar will
  /// stop syncing until the user re-authorises. Rendered amber, not green.
  bool get needsAttention => isConnected && tokenStatus.expired;
}

/// Localised plan pricing, as `GET /geo/pricing` returns it.
///
/// India is billed inclusive of 18% GST; everywhere else the price is the INR
/// base converted and then doubled (`INTERNATIONAL_PRICE_MULTIPLIER = 2`) and
/// rounded — the server owns that arithmetic and the app must not redo it.
@freezed
abstract class GeoPricing with _$GeoPricing {
  const GeoPricing._();

  const factory GeoPricing({
    @Default('IN') String countryCode,
    @Default('India') String countryName,
    @Default('INR') String currency,
    @Default('₹') String symbol,
    @Default(0) int personalPrice,
    @Default(0) int companyPrice,
    @Default(true) bool isIndia,
    @Default(100) int subunitMultiplier,
  }) = _GeoPricing;

  factory GeoPricing.fromJson(Map<String, dynamic> json) =>
      _$GeoPricingFromJson(json);

  /// The price for the brand the user actually runs. The web filters its plan
  /// list by `brandType` for the same reason: most users have exactly one plan.
  int priceFor({required bool isCompany}) =>
      isCompany ? companyPrice : personalPrice;

  /// The tax line under the price. India's figure is inclusive; every other
  /// country's is not, and saying so is the difference between a correct
  /// price and a surprise at checkout.
  String get taxNote => isIndia ? 'incl. 18% GST' : '18% GST excluded';
}

/// The XP balance from `GET /user/xp`.
///
/// The endpoint also returns the last twenty transactions and the XP config
/// map; Settings needs neither, so they are not modelled here. The ledger
/// belongs to whichever screen actually renders it.
@freezed
abstract class XpSummary with _$XpSummary {
  const XpSummary._();

  const factory XpSummary({@Default(0) int balance}) = _XpSummary;

  factory XpSummary.fromJson(Map<String, dynamic> json) =>
      _$XpSummaryFromJson(json);
}

/// The outcome of a browser hand-off started from Settings (LinkedIn, Slack,
/// Google Calendar).
///
/// Three cases, not a `bool`, because "the user backed out of the browser" and
/// "the exchange failed" must not look the same: the first is silent, the
/// second needs an explanation.
sealed class ConnectOutcome {
  const ConnectOutcome();
}

class ConnectSucceeded extends ConnectOutcome {
  const ConnectSucceeded();
}

/// The user dismissed the in-app browser. No banner — they know what they did.
class ConnectCancelled extends ConnectOutcome {
  const ConnectCancelled();
}

class ConnectFailed extends ConnectOutcome {
  const ConnectFailed([this.message]);

  final String? message;
}
