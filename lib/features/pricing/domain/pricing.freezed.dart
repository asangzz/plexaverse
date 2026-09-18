// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pricing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanPricing {

 String get countryCode; String get countryName; String get currency; String get symbol; int get personalPrice; int get companyPrice; bool get isIndia;/// How many minor units make one major unit. Razorpay charges in paise /
/// cents, so the checkout amount is `price * subunitMultiplier`.
 int get subunitMultiplier;
/// Create a copy of PlanPricing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanPricingCopyWith<PlanPricing> get copyWith => _$PlanPricingCopyWithImpl<PlanPricing>(this as PlanPricing, _$identity);

  /// Serializes this PlanPricing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanPricing&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.personalPrice, personalPrice) || other.personalPrice == personalPrice)&&(identical(other.companyPrice, companyPrice) || other.companyPrice == companyPrice)&&(identical(other.isIndia, isIndia) || other.isIndia == isIndia)&&(identical(other.subunitMultiplier, subunitMultiplier) || other.subunitMultiplier == subunitMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,currency,symbol,personalPrice,companyPrice,isIndia,subunitMultiplier);

@override
String toString() {
  return 'PlanPricing(countryCode: $countryCode, countryName: $countryName, currency: $currency, symbol: $symbol, personalPrice: $personalPrice, companyPrice: $companyPrice, isIndia: $isIndia, subunitMultiplier: $subunitMultiplier)';
}


}

/// @nodoc
abstract mixin class $PlanPricingCopyWith<$Res>  {
  factory $PlanPricingCopyWith(PlanPricing value, $Res Function(PlanPricing) _then) = _$PlanPricingCopyWithImpl;
@useResult
$Res call({
 String countryCode, String countryName, String currency, String symbol, int personalPrice, int companyPrice, bool isIndia, int subunitMultiplier
});




}
/// @nodoc
class _$PlanPricingCopyWithImpl<$Res>
    implements $PlanPricingCopyWith<$Res> {
  _$PlanPricingCopyWithImpl(this._self, this._then);

  final PlanPricing _self;
  final $Res Function(PlanPricing) _then;

/// Create a copy of PlanPricing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? countryName = null,Object? currency = null,Object? symbol = null,Object? personalPrice = null,Object? companyPrice = null,Object? isIndia = null,Object? subunitMultiplier = null,}) {
  return _then(_self.copyWith(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,personalPrice: null == personalPrice ? _self.personalPrice : personalPrice // ignore: cast_nullable_to_non_nullable
as int,companyPrice: null == companyPrice ? _self.companyPrice : companyPrice // ignore: cast_nullable_to_non_nullable
as int,isIndia: null == isIndia ? _self.isIndia : isIndia // ignore: cast_nullable_to_non_nullable
as bool,subunitMultiplier: null == subunitMultiplier ? _self.subunitMultiplier : subunitMultiplier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanPricing].
extension PlanPricingPatterns on PlanPricing {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanPricing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanPricing() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanPricing value)  $default,){
final _that = this;
switch (_that) {
case _PlanPricing():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanPricing value)?  $default,){
final _that = this;
switch (_that) {
case _PlanPricing() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  String countryName,  String currency,  String symbol,  int personalPrice,  int companyPrice,  bool isIndia,  int subunitMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanPricing() when $default != null:
return $default(_that.countryCode,_that.countryName,_that.currency,_that.symbol,_that.personalPrice,_that.companyPrice,_that.isIndia,_that.subunitMultiplier);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  String countryName,  String currency,  String symbol,  int personalPrice,  int companyPrice,  bool isIndia,  int subunitMultiplier)  $default,) {final _that = this;
switch (_that) {
case _PlanPricing():
return $default(_that.countryCode,_that.countryName,_that.currency,_that.symbol,_that.personalPrice,_that.companyPrice,_that.isIndia,_that.subunitMultiplier);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  String countryName,  String currency,  String symbol,  int personalPrice,  int companyPrice,  bool isIndia,  int subunitMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _PlanPricing() when $default != null:
return $default(_that.countryCode,_that.countryName,_that.currency,_that.symbol,_that.personalPrice,_that.companyPrice,_that.isIndia,_that.subunitMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanPricing extends PlanPricing {
  const _PlanPricing({this.countryCode = 'IN', this.countryName = 'India', this.currency = 'INR', this.symbol = '₹', this.personalPrice = 0, this.companyPrice = 0, this.isIndia = true, this.subunitMultiplier = 100}): super._();
  factory _PlanPricing.fromJson(Map<String, dynamic> json) => _$PlanPricingFromJson(json);

@override@JsonKey() final  String countryCode;
@override@JsonKey() final  String countryName;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String symbol;
@override@JsonKey() final  int personalPrice;
@override@JsonKey() final  int companyPrice;
@override@JsonKey() final  bool isIndia;
/// How many minor units make one major unit. Razorpay charges in paise /
/// cents, so the checkout amount is `price * subunitMultiplier`.
@override@JsonKey() final  int subunitMultiplier;

/// Create a copy of PlanPricing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanPricingCopyWith<_PlanPricing> get copyWith => __$PlanPricingCopyWithImpl<_PlanPricing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanPricingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanPricing&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.personalPrice, personalPrice) || other.personalPrice == personalPrice)&&(identical(other.companyPrice, companyPrice) || other.companyPrice == companyPrice)&&(identical(other.isIndia, isIndia) || other.isIndia == isIndia)&&(identical(other.subunitMultiplier, subunitMultiplier) || other.subunitMultiplier == subunitMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,currency,symbol,personalPrice,companyPrice,isIndia,subunitMultiplier);

@override
String toString() {
  return 'PlanPricing(countryCode: $countryCode, countryName: $countryName, currency: $currency, symbol: $symbol, personalPrice: $personalPrice, companyPrice: $companyPrice, isIndia: $isIndia, subunitMultiplier: $subunitMultiplier)';
}


}

/// @nodoc
abstract mixin class _$PlanPricingCopyWith<$Res> implements $PlanPricingCopyWith<$Res> {
  factory _$PlanPricingCopyWith(_PlanPricing value, $Res Function(_PlanPricing) _then) = __$PlanPricingCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, String countryName, String currency, String symbol, int personalPrice, int companyPrice, bool isIndia, int subunitMultiplier
});




}
/// @nodoc
class __$PlanPricingCopyWithImpl<$Res>
    implements _$PlanPricingCopyWith<$Res> {
  __$PlanPricingCopyWithImpl(this._self, this._then);

  final _PlanPricing _self;
  final $Res Function(_PlanPricing) _then;

/// Create a copy of PlanPricing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? countryName = null,Object? currency = null,Object? symbol = null,Object? personalPrice = null,Object? companyPrice = null,Object? isIndia = null,Object? subunitMultiplier = null,}) {
  return _then(_PlanPricing(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,personalPrice: null == personalPrice ? _self.personalPrice : personalPrice // ignore: cast_nullable_to_non_nullable
as int,companyPrice: null == companyPrice ? _self.companyPrice : companyPrice // ignore: cast_nullable_to_non_nullable
as int,isIndia: null == isIndia ? _self.isIndia : isIndia // ignore: cast_nullable_to_non_nullable
as bool,subunitMultiplier: null == subunitMultiplier ? _self.subunitMultiplier : subunitMultiplier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReferralSummary {

/// Null until the user generates one. That is the empty state, not an
/// error.
 String? get code; int get totalReferrals; int get totalXpEarned;
/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralSummaryCopyWith<ReferralSummary> get copyWith => _$ReferralSummaryCopyWithImpl<ReferralSummary>(this as ReferralSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.totalReferrals, totalReferrals) || other.totalReferrals == totalReferrals)&&(identical(other.totalXpEarned, totalXpEarned) || other.totalXpEarned == totalXpEarned));
}


@override
int get hashCode => Object.hash(runtimeType,code,totalReferrals,totalXpEarned);

@override
String toString() {
  return 'ReferralSummary(code: $code, totalReferrals: $totalReferrals, totalXpEarned: $totalXpEarned)';
}


}

/// @nodoc
abstract mixin class $ReferralSummaryCopyWith<$Res>  {
  factory $ReferralSummaryCopyWith(ReferralSummary value, $Res Function(ReferralSummary) _then) = _$ReferralSummaryCopyWithImpl;
@useResult
$Res call({
 String? code, int totalReferrals, int totalXpEarned
});




}
/// @nodoc
class _$ReferralSummaryCopyWithImpl<$Res>
    implements $ReferralSummaryCopyWith<$Res> {
  _$ReferralSummaryCopyWithImpl(this._self, this._then);

  final ReferralSummary _self;
  final $Res Function(ReferralSummary) _then;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? totalReferrals = null,Object? totalXpEarned = null,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,totalReferrals: null == totalReferrals ? _self.totalReferrals : totalReferrals // ignore: cast_nullable_to_non_nullable
as int,totalXpEarned: null == totalXpEarned ? _self.totalXpEarned : totalXpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralSummary].
extension ReferralSummaryPatterns on ReferralSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReferralSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? code,  int totalReferrals,  int totalXpEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that.code,_that.totalReferrals,_that.totalXpEarned);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? code,  int totalReferrals,  int totalXpEarned)  $default,) {final _that = this;
switch (_that) {
case _ReferralSummary():
return $default(_that.code,_that.totalReferrals,_that.totalXpEarned);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? code,  int totalReferrals,  int totalXpEarned)?  $default,) {final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that.code,_that.totalReferrals,_that.totalXpEarned);case _:
  return null;

}
}

}

/// @nodoc


class _ReferralSummary extends ReferralSummary {
  const _ReferralSummary({this.code, this.totalReferrals = 0, this.totalXpEarned = 0}): super._();
  

/// Null until the user generates one. That is the empty state, not an
/// error.
@override final  String? code;
@override@JsonKey() final  int totalReferrals;
@override@JsonKey() final  int totalXpEarned;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralSummaryCopyWith<_ReferralSummary> get copyWith => __$ReferralSummaryCopyWithImpl<_ReferralSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.totalReferrals, totalReferrals) || other.totalReferrals == totalReferrals)&&(identical(other.totalXpEarned, totalXpEarned) || other.totalXpEarned == totalXpEarned));
}


@override
int get hashCode => Object.hash(runtimeType,code,totalReferrals,totalXpEarned);

@override
String toString() {
  return 'ReferralSummary(code: $code, totalReferrals: $totalReferrals, totalXpEarned: $totalXpEarned)';
}


}

/// @nodoc
abstract mixin class _$ReferralSummaryCopyWith<$Res> implements $ReferralSummaryCopyWith<$Res> {
  factory _$ReferralSummaryCopyWith(_ReferralSummary value, $Res Function(_ReferralSummary) _then) = __$ReferralSummaryCopyWithImpl;
@override @useResult
$Res call({
 String? code, int totalReferrals, int totalXpEarned
});




}
/// @nodoc
class __$ReferralSummaryCopyWithImpl<$Res>
    implements _$ReferralSummaryCopyWith<$Res> {
  __$ReferralSummaryCopyWithImpl(this._self, this._then);

  final _ReferralSummary _self;
  final $Res Function(_ReferralSummary) _then;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? totalReferrals = null,Object? totalXpEarned = null,}) {
  return _then(_ReferralSummary(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,totalReferrals: null == totalReferrals ? _self.totalReferrals : totalReferrals // ignore: cast_nullable_to_non_nullable
as int,totalXpEarned: null == totalXpEarned ? _self.totalXpEarned : totalXpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
