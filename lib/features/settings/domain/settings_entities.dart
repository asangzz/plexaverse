import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entities.freezed.dart';
part 'settings_entities.g.dart';

/// The signed-in account, as `GET /auth/me` returns its `user` object.
///
/// The web reads the same fields off the NextAuth session (`session.user`),
/// which is why Settings' Account section can show a name, an email and an
/// avatar without a second fetch. On mobile there is no session cookie, so
/// `/auth/me` is that fetch — and it is deliberately a live read rather than a
/// token decode: `role` and the subscription state both change
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
/// Razorpay subscription webhook; only `currentPeriodEnd` comes from the joined
/// Subscription row.
///
/// **`status` is not the whole answer to "does this user have a plan".** The
/// server decides that in `resolveEntitlement()` (web `lib/entitlements.ts`),
/// which also counts a 30-day pass and given plan time (the referral month,
/// an admin grant). Neither of those ever writes `status`, so a pass holder
/// reads `status: 'inactive'` here while every AI feature works for them.
/// `entitled`, `entitlementReason` and `accessEndsAt` carry the server's real
/// answer; they are optional because `/auth/me` does not send them yet, and
/// until it does the UI must not assert "no plan" from `status` alone.
@freezed
abstract class SubscriptionState with _$SubscriptionState {
  const SubscriptionState._();

  const factory SubscriptionState({
    /// `'active'` while a recurring subscription is paid up. Null for an
    /// account that never subscribed, `'inactive'` / `'cancelled'` otherwise.
    String? status,

    /// `'subscription'` (autopay mandate) or `'onetime'` (the 30-day pass:
    /// paid once, 30 days of the plan, no renewal).
    String? paymentMode,
    DateTime? currentPeriodEnd,

    /// The server's entitlement verdict. Null when the server did not say
    /// (every build of `/auth/me` before it exposes `resolveEntitlement`).
    bool? entitled,

    /// `subscription_active` | `recent_purchase` | `granted` |
    /// `never_subscribed` | `lapsed`, as `EntitlementReason` on the server.
    String? entitlementReason,

    /// When the current access ends, for a pass or given plan time.
    DateTime? accessEndsAt,
  }) = _SubscriptionState;

  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  /// The server's verdict when it sent one; otherwise the recurring status,
  /// which is the only kind of plan the old payload can show.
  bool get isActive => entitled ?? status == 'active';

  /// True when we cannot tell whether the user has a plan: the server sent no
  /// verdict and the recurring status is not active. A pass or a given month
  /// looks exactly like this, so the UI must hedge rather than say "no plan".
  bool get isUnknown => entitled == null && status != 'active';

  /// The plan is a pass or given time rather than a recurring subscription.
  bool get isGranted => entitlementReason == 'granted';

  /// True when the plan renews on its own. The web shows "cancel anytime"
  /// copy only on this branch. A known non-subscription reason wins over a
  /// stale `paymentMode`: a lapsed subscriber holding a pass is not renewing.
  bool get isRecurring {
    if (entitlementReason != null) {
      return entitlementReason == 'subscription_active';
    }
    return paymentMode == 'subscription';
  }

  /// When access ends, for anything that does not renew.
  DateTime? get endsAt => accessEndsAt ?? currentPeriodEnd;
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

/// WhatsApp connection status, as `GET /user/whatsapp` returns it.
///
/// Like Slack's, the endpoint never 404s a user who has not connected — it
/// answers with `connected: false` — so there is no "absent" case here.
///
/// ## connected, optedOut and available are three different facts
///
/// [available] is the ENVIRONMENT: no credentials on the server and the app
/// must say so rather than offer a form that cannot work. [connected] is a
/// verified number. [optedOut] is the user having replied STOP on WhatsApp
/// itself, which outlives a disconnect on purpose — a deleted row can be
/// recreated by typing the number in again, and that must not silently undo a
/// STOP. So a user can be disconnected AND opted out, and the only way back is
/// the explicit resume.
@freezed
abstract class WhatsAppConnection with _$WhatsAppConnection {
  const WhatsAppConnection._();

  const factory WhatsAppConnection({
    /// False when the server has no WhatsApp credentials at all.
    @Default(false) bool available,
    @Default(false) bool connected,

    /// Masked, always — the full number never leaves the server, not even to
    /// the owner, who knows it already.
    String? phoneMasked,

    /// A code is outstanding and the app should show the code box.
    @Default(false) bool awaitingCode,
    @Default(false) bool optedOut,
  }) = _WhatsAppConnection;

  factory WhatsAppConnection.fromJson(Map<String, dynamic> json) =>
      _$WhatsAppConnectionFromJson(json);

  /// Nothing to offer: the channel is off in this environment.
  bool get isUnavailable => !available;

  /// Connected and not silenced — messages will actually arrive.
  bool get isLive => connected && !optedOut;
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
