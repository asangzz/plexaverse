import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_info.freezed.dart';
part 'subscription_info.g.dart';

/// The signed-in user's plan + quota snapshot, rendered on the Account page
/// (screenshot 2374: blue gradient "Creator" card with the credit-usage
/// progress) and in the Subscription bottom sheet (screenshot 2375:
/// "Included in your plan" — credit usage, Digital Twin quota, photo
/// avatars, recent activity).
///
/// Sourced from the bundled fixture `assets/mock/settings/subscription.json`
/// through the real [fromJson] (feature-slice convention), so a future
/// billing API can swap in behind [SettingsRepository.fetchSubscription]
/// without touching the UI.
@freezed
abstract class SubscriptionInfo with _$SubscriptionInfo {
  const SubscriptionInfo._();

  const factory SubscriptionInfo({
    /// Plan display name — "Creator" on the gradient card.
    required String planName,

    /// Provenance line on the card's right ("From Plexaverse web app").
    required String source,

    /// Credits left this cycle — "453 remaining".
    required int creditsRemaining,

    /// Monthly plan allowance — "600 credits".
    required int creditsTotal,

    /// Unused Digital Twin slots — "4 avatar slots remaining".
    required int avatarSlotsRemaining,

    /// Fixed Digital Twin quota — the 5 segments of the quota bar.
    required int avatarSlotsTotal,

    /// "Recent Activity" rows in the Subscription sheet, newest first.
    @Default(<SubscriptionActivity>[])
    List<SubscriptionActivity> recentActivity,
  }) = _SubscriptionInfo;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionInfoFromJson(json);

  /// Credits spent this cycle (147 for 453/600) — the FILLED portion of
  /// both progress bars in 2374/2375.
  int get creditsUsed =>
      (creditsTotal - creditsRemaining).clamp(0, creditsTotal);

  /// [creditsUsed] as a 0–1 fraction for the progress fills (≈0.245).
  double get usedFraction => creditsTotal <= 0 ? 0 : creditsUsed / creditsTotal;

  /// Occupied Digital Twin slots — the leading filled segments of the
  /// [SegmentedQuotaBar] (1 for 4-of-5 remaining).
  int get avatarSlotsUsed =>
      (avatarSlotsTotal - avatarSlotsRemaining).clamp(0, avatarSlotsTotal);

  /// "453 remaining" — trailing label on the Credit Usage rows.
  String get creditsRemainingLabel => '$creditsRemaining remaining';

  /// "600 credits" — trailing label on the Monthly Plan Credits row.
  String get creditsTotalLabel => '$creditsTotal credits';

  /// "4 avatar slots remaining" — caption under the quota bar.
  String get avatarSlotsLabel => '$avatarSlotsRemaining avatar slots remaining';
}

/// One "Recent Activity" row in the Subscription sheet (2375): thumbnail
/// (with an optional duration chip), title, "3h ago · Video" meta line and
/// the signed credit delta on the right.
@freezed
abstract class SubscriptionActivity with _$SubscriptionActivity {
  const SubscriptionActivity._();

  const factory SubscriptionActivity({
    /// Row title — "Quick Avatar Video".
    required String title,

    /// Relative timestamp — "3h ago".
    required String timeAgo,

    /// Activity kind — "Video" / "AI asset" / "Video Agent".
    required String kind,

    /// Signed credit change; spends are negative ("-3 credits").
    required int creditsDelta,

    /// "0:08" duration chip on video thumbnails; absent (not null) in the
    /// JSON for non-video activity (e.g. an AI asset).
    @JsonKey(includeIfNull: false) String? durationLabel,
  }) = _SubscriptionActivity;

  factory SubscriptionActivity.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionActivityFromJson(json);

  /// "3h ago · Video" — the grey meta line under the title.
  String get metaLine => '$timeAgo · $kind';

  /// "-3 credits" — the trailing delta label (sign carried by the value).
  String get creditsLabel => '$creditsDelta credits';
}
