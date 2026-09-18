// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountIdentity _$AccountIdentityFromJson(Map<String, dynamic> json) =>
    _AccountIdentity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['image'] as String?,
      role: json['role'] as String? ?? 'user',
      xpBalance: (json['xpBalance'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AccountIdentityToJson(_AccountIdentity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.avatarUrl,
      'role': instance.role,
      'xpBalance': instance.xpBalance,
    };

_SubscriptionState _$SubscriptionStateFromJson(Map<String, dynamic> json) =>
    _SubscriptionState(
      status: json['status'] as String?,
      paymentMode: json['paymentMode'] as String?,
      currentPeriodEnd: json['currentPeriodEnd'] == null
          ? null
          : DateTime.parse(json['currentPeriodEnd'] as String),
    );

Map<String, dynamic> _$SubscriptionStateToJson(_SubscriptionState instance) =>
    <String, dynamic>{
      'status': instance.status,
      'paymentMode': instance.paymentMode,
      'currentPeriodEnd': instance.currentPeriodEnd?.toIso8601String(),
    };

_AccountSnapshot _$AccountSnapshotFromJson(Map<String, dynamic> json) =>
    _AccountSnapshot(
      user: AccountIdentity.fromJson(json['user'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? const SubscriptionState()
          : SubscriptionState.fromJson(
              json['subscription'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AccountSnapshotToJson(_AccountSnapshot instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'subscription': instance.subscription.toJson(),
    };

_LinkedinAccount _$LinkedinAccountFromJson(Map<String, dynamic> json) =>
    _LinkedinAccount(
      id: json['id'] as String,
      profileId: json['profileId'] as String? ?? '',
      profileName: json['profileName'] as String? ?? '',
      profileHeadline: json['profileHeadline'] as String?,
      profileImage: json['profileImage'] as String?,
      profileSlug: json['profileSlug'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      appType: json['appType'] as String? ?? 'personal',
      needsReconnect: json['needsReconnect'] as bool?,
    );

Map<String, dynamic> _$LinkedinAccountToJson(_LinkedinAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'profileName': instance.profileName,
      'profileHeadline': instance.profileHeadline,
      'profileImage': instance.profileImage,
      'profileSlug': instance.profileSlug,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'appType': instance.appType,
      'needsReconnect': instance.needsReconnect,
    };

_SlackConnection _$SlackConnectionFromJson(Map<String, dynamic> json) =>
    _SlackConnection(
      isConnected: json['isConnected'] as bool? ?? false,
      teamName: json['teamName'] as String?,
      teamId: json['teamId'] as String?,
      channelId: json['channelId'] as String?,
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
    );

Map<String, dynamic> _$SlackConnectionToJson(_SlackConnection instance) =>
    <String, dynamic>{
      'isConnected': instance.isConnected,
      'teamName': instance.teamName,
      'teamId': instance.teamId,
      'channelId': instance.channelId,
      'connectedAt': instance.connectedAt?.toIso8601String(),
    };

_CalendarTokenStatus _$CalendarTokenStatusFromJson(Map<String, dynamic> json) =>
    _CalendarTokenStatus(
      expired: json['expired'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      expiresInMinutes: (json['expiresInMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CalendarTokenStatusToJson(
  _CalendarTokenStatus instance,
) => <String, dynamic>{
  'expired': instance.expired,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'expiresInMinutes': instance.expiresInMinutes,
};

_CalendarConnection _$CalendarConnectionFromJson(Map<String, dynamic> json) =>
    _CalendarConnection(
      isConnected: json['isConnected'] as bool? ?? false,
      calendarId: json['calendarId'] as String?,
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
      tokenStatus: json['tokenStatus'] == null
          ? const CalendarTokenStatus()
          : CalendarTokenStatus.fromJson(
              json['tokenStatus'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CalendarConnectionToJson(_CalendarConnection instance) =>
    <String, dynamic>{
      'isConnected': instance.isConnected,
      'calendarId': instance.calendarId,
      'connectedAt': instance.connectedAt?.toIso8601String(),
      'tokenStatus': instance.tokenStatus.toJson(),
    };

_GeoPricing _$GeoPricingFromJson(Map<String, dynamic> json) => _GeoPricing(
  countryCode: json['countryCode'] as String? ?? 'IN',
  countryName: json['countryName'] as String? ?? 'India',
  currency: json['currency'] as String? ?? 'INR',
  symbol: json['symbol'] as String? ?? '₹',
  personalPrice: (json['personalPrice'] as num?)?.toInt() ?? 0,
  companyPrice: (json['companyPrice'] as num?)?.toInt() ?? 0,
  isIndia: json['isIndia'] as bool? ?? true,
  subunitMultiplier: (json['subunitMultiplier'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$GeoPricingToJson(_GeoPricing instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'currency': instance.currency,
      'symbol': instance.symbol,
      'personalPrice': instance.personalPrice,
      'companyPrice': instance.companyPrice,
      'isIndia': instance.isIndia,
      'subunitMultiplier': instance.subunitMultiplier,
    };

_XpSummary _$XpSummaryFromJson(Map<String, dynamic> json) =>
    _XpSummary(balance: (json['balance'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$XpSummaryToJson(_XpSummary instance) =>
    <String, dynamic>{'balance': instance.balance};
