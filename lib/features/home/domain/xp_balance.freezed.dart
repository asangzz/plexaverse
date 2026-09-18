// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xp_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$XpBalance {

 int get balance;
/// Create a copy of XpBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpBalanceCopyWith<XpBalance> get copyWith => _$XpBalanceCopyWithImpl<XpBalance>(this as XpBalance, _$identity);

  /// Serializes this XpBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpBalance&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'XpBalance(balance: $balance)';
}


}

/// @nodoc
abstract mixin class $XpBalanceCopyWith<$Res>  {
  factory $XpBalanceCopyWith(XpBalance value, $Res Function(XpBalance) _then) = _$XpBalanceCopyWithImpl;
@useResult
$Res call({
 int balance
});




}
/// @nodoc
class _$XpBalanceCopyWithImpl<$Res>
    implements $XpBalanceCopyWith<$Res> {
  _$XpBalanceCopyWithImpl(this._self, this._then);

  final XpBalance _self;
  final $Res Function(XpBalance) _then;

/// Create a copy of XpBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XpBalance].
extension XpBalancePatterns on XpBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpBalance value)  $default,){
final _that = this;
switch (_that) {
case _XpBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpBalance value)?  $default,){
final _that = this;
switch (_that) {
case _XpBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XpBalance() when $default != null:
return $default(_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int balance)  $default,) {final _that = this;
switch (_that) {
case _XpBalance():
return $default(_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int balance)?  $default,) {final _that = this;
switch (_that) {
case _XpBalance() when $default != null:
return $default(_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XpBalance extends XpBalance {
  const _XpBalance({this.balance = 0}): super._();
  factory _XpBalance.fromJson(Map<String, dynamic> json) => _$XpBalanceFromJson(json);

@override@JsonKey() final  int balance;

/// Create a copy of XpBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpBalanceCopyWith<_XpBalance> get copyWith => __$XpBalanceCopyWithImpl<_XpBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XpBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpBalance&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'XpBalance(balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$XpBalanceCopyWith<$Res> implements $XpBalanceCopyWith<$Res> {
  factory _$XpBalanceCopyWith(_XpBalance value, $Res Function(_XpBalance) _then) = __$XpBalanceCopyWithImpl;
@override @useResult
$Res call({
 int balance
});




}
/// @nodoc
class __$XpBalanceCopyWithImpl<$Res>
    implements _$XpBalanceCopyWith<$Res> {
  __$XpBalanceCopyWithImpl(this._self, this._then);

  final _XpBalance _self;
  final $Res Function(_XpBalance) _then;

/// Create a copy of XpBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,}) {
  return _then(_XpBalance(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
