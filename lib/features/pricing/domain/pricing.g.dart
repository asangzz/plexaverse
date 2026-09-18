// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanPricing _$PlanPricingFromJson(Map<String, dynamic> json) => _PlanPricing(
  countryCode: json['countryCode'] as String? ?? 'IN',
  countryName: json['countryName'] as String? ?? 'India',
  currency: json['currency'] as String? ?? 'INR',
  symbol: json['symbol'] as String? ?? '₹',
  personalPrice: (json['personalPrice'] as num?)?.toInt() ?? 0,
  companyPrice: (json['companyPrice'] as num?)?.toInt() ?? 0,
  isIndia: json['isIndia'] as bool? ?? true,
  subunitMultiplier: (json['subunitMultiplier'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$PlanPricingToJson(_PlanPricing instance) =>
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
