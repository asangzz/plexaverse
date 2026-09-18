// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountIdentity {

 String get id; String get name; String get email;/// The server sends the avatar under `image`; the app calls it what it is.
@JsonKey(name: 'image') String? get avatarUrl; String get role; int get xpBalance;
/// Create a copy of AccountIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountIdentityCopyWith<AccountIdentity> get copyWith => _$AccountIdentityCopyWithImpl<AccountIdentity>(this as AccountIdentity, _$identity);

  /// Serializes this AccountIdentity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountIdentity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.xpBalance, xpBalance) || other.xpBalance == xpBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,role,xpBalance);

@override
String toString() {
  return 'AccountIdentity(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, role: $role, xpBalance: $xpBalance)';
}


}

/// @nodoc
abstract mixin class $AccountIdentityCopyWith<$Res>  {
  factory $AccountIdentityCopyWith(AccountIdentity value, $Res Function(AccountIdentity) _then) = _$AccountIdentityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email,@JsonKey(name: 'image') String? avatarUrl, String role, int xpBalance
});




}
/// @nodoc
class _$AccountIdentityCopyWithImpl<$Res>
    implements $AccountIdentityCopyWith<$Res> {
  _$AccountIdentityCopyWithImpl(this._self, this._then);

  final AccountIdentity _self;
  final $Res Function(AccountIdentity) _then;

/// Create a copy of AccountIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? role = null,Object? xpBalance = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,xpBalance: null == xpBalance ? _self.xpBalance : xpBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountIdentity].
extension AccountIdentityPatterns on AccountIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountIdentity value)  $default,){
final _that = this;
switch (_that) {
case _AccountIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email, @JsonKey(name: 'image')  String? avatarUrl,  String role,  int xpBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountIdentity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.role,_that.xpBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email, @JsonKey(name: 'image')  String? avatarUrl,  String role,  int xpBalance)  $default,) {final _that = this;
switch (_that) {
case _AccountIdentity():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.role,_that.xpBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email, @JsonKey(name: 'image')  String? avatarUrl,  String role,  int xpBalance)?  $default,) {final _that = this;
switch (_that) {
case _AccountIdentity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.role,_that.xpBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountIdentity extends AccountIdentity {
  const _AccountIdentity({required this.id, this.name = '', this.email = '', @JsonKey(name: 'image') this.avatarUrl, this.role = 'user', this.xpBalance = 0}): super._();
  factory _AccountIdentity.fromJson(Map<String, dynamic> json) => _$AccountIdentityFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
/// The server sends the avatar under `image`; the app calls it what it is.
@override@JsonKey(name: 'image') final  String? avatarUrl;
@override@JsonKey() final  String role;
@override@JsonKey() final  int xpBalance;

/// Create a copy of AccountIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountIdentityCopyWith<_AccountIdentity> get copyWith => __$AccountIdentityCopyWithImpl<_AccountIdentity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountIdentityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountIdentity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.xpBalance, xpBalance) || other.xpBalance == xpBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,role,xpBalance);

@override
String toString() {
  return 'AccountIdentity(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, role: $role, xpBalance: $xpBalance)';
}


}

/// @nodoc
abstract mixin class _$AccountIdentityCopyWith<$Res> implements $AccountIdentityCopyWith<$Res> {
  factory _$AccountIdentityCopyWith(_AccountIdentity value, $Res Function(_AccountIdentity) _then) = __$AccountIdentityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email,@JsonKey(name: 'image') String? avatarUrl, String role, int xpBalance
});




}
/// @nodoc
class __$AccountIdentityCopyWithImpl<$Res>
    implements _$AccountIdentityCopyWith<$Res> {
  __$AccountIdentityCopyWithImpl(this._self, this._then);

  final _AccountIdentity _self;
  final $Res Function(_AccountIdentity) _then;

/// Create a copy of AccountIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? role = null,Object? xpBalance = null,}) {
  return _then(_AccountIdentity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,xpBalance: null == xpBalance ? _self.xpBalance : xpBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SubscriptionState {

/// `'active'` while the plan is paid up. Anything else — including null for
/// an account that has never paid — is treated as inactive.
 String? get status;/// `'subscription'` (autopay mandate) or `'onetime'` (a single XP top-up).
 String? get paymentMode; DateTime? get currentPeriodEnd;
/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<SubscriptionState> get copyWith => _$SubscriptionStateCopyWithImpl<SubscriptionState>(this as SubscriptionState, _$identity);

  /// Serializes this SubscriptionState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.currentPeriodEnd, currentPeriodEnd) || other.currentPeriodEnd == currentPeriodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,paymentMode,currentPeriodEnd);

@override
String toString() {
  return 'SubscriptionState(status: $status, paymentMode: $paymentMode, currentPeriodEnd: $currentPeriodEnd)';
}


}

/// @nodoc
abstract mixin class $SubscriptionStateCopyWith<$Res>  {
  factory $SubscriptionStateCopyWith(SubscriptionState value, $Res Function(SubscriptionState) _then) = _$SubscriptionStateCopyWithImpl;
@useResult
$Res call({
 String? status, String? paymentMode, DateTime? currentPeriodEnd
});




}
/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._self, this._then);

  final SubscriptionState _self;
  final $Res Function(SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? paymentMode = freezed,Object? currentPeriodEnd = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,currentPeriodEnd: freezed == currentPeriodEnd ? _self.currentPeriodEnd : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionState value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionState value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? status,  String? paymentMode,  DateTime? currentPeriodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.status,_that.paymentMode,_that.currentPeriodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? status,  String? paymentMode,  DateTime? currentPeriodEnd)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState():
return $default(_that.status,_that.paymentMode,_that.currentPeriodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? status,  String? paymentMode,  DateTime? currentPeriodEnd)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.status,_that.paymentMode,_that.currentPeriodEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionState extends SubscriptionState {
  const _SubscriptionState({this.status, this.paymentMode, this.currentPeriodEnd}): super._();
  factory _SubscriptionState.fromJson(Map<String, dynamic> json) => _$SubscriptionStateFromJson(json);

/// `'active'` while the plan is paid up. Anything else — including null for
/// an account that has never paid — is treated as inactive.
@override final  String? status;
/// `'subscription'` (autopay mandate) or `'onetime'` (a single XP top-up).
@override final  String? paymentMode;
@override final  DateTime? currentPeriodEnd;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionStateCopyWith<_SubscriptionState> get copyWith => __$SubscriptionStateCopyWithImpl<_SubscriptionState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionState&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.currentPeriodEnd, currentPeriodEnd) || other.currentPeriodEnd == currentPeriodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,paymentMode,currentPeriodEnd);

@override
String toString() {
  return 'SubscriptionState(status: $status, paymentMode: $paymentMode, currentPeriodEnd: $currentPeriodEnd)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionStateCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$SubscriptionStateCopyWith(_SubscriptionState value, $Res Function(_SubscriptionState) _then) = __$SubscriptionStateCopyWithImpl;
@override @useResult
$Res call({
 String? status, String? paymentMode, DateTime? currentPeriodEnd
});




}
/// @nodoc
class __$SubscriptionStateCopyWithImpl<$Res>
    implements _$SubscriptionStateCopyWith<$Res> {
  __$SubscriptionStateCopyWithImpl(this._self, this._then);

  final _SubscriptionState _self;
  final $Res Function(_SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? paymentMode = freezed,Object? currentPeriodEnd = freezed,}) {
  return _then(_SubscriptionState(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,currentPeriodEnd: freezed == currentPeriodEnd ? _self.currentPeriodEnd : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AccountSnapshot {

 AccountIdentity get user; SubscriptionState get subscription;
/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSnapshotCopyWith<AccountSnapshot> get copyWith => _$AccountSnapshotCopyWithImpl<AccountSnapshot>(this as AccountSnapshot, _$identity);

  /// Serializes this AccountSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSnapshot&&(identical(other.user, user) || other.user == user)&&(identical(other.subscription, subscription) || other.subscription == subscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subscription);

@override
String toString() {
  return 'AccountSnapshot(user: $user, subscription: $subscription)';
}


}

/// @nodoc
abstract mixin class $AccountSnapshotCopyWith<$Res>  {
  factory $AccountSnapshotCopyWith(AccountSnapshot value, $Res Function(AccountSnapshot) _then) = _$AccountSnapshotCopyWithImpl;
@useResult
$Res call({
 AccountIdentity user, SubscriptionState subscription
});


$AccountIdentityCopyWith<$Res> get user;$SubscriptionStateCopyWith<$Res> get subscription;

}
/// @nodoc
class _$AccountSnapshotCopyWithImpl<$Res>
    implements $AccountSnapshotCopyWith<$Res> {
  _$AccountSnapshotCopyWithImpl(this._self, this._then);

  final AccountSnapshot _self;
  final $Res Function(AccountSnapshot) _then;

/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? subscription = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AccountIdentity,subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionState,
  ));
}
/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountIdentityCopyWith<$Res> get user {
  
  return $AccountIdentityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<$Res> get subscription {
  
  return $SubscriptionStateCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountSnapshot].
extension AccountSnapshotPatterns on AccountSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _AccountSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountIdentity user,  SubscriptionState subscription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSnapshot() when $default != null:
return $default(_that.user,_that.subscription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountIdentity user,  SubscriptionState subscription)  $default,) {final _that = this;
switch (_that) {
case _AccountSnapshot():
return $default(_that.user,_that.subscription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountIdentity user,  SubscriptionState subscription)?  $default,) {final _that = this;
switch (_that) {
case _AccountSnapshot() when $default != null:
return $default(_that.user,_that.subscription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountSnapshot extends AccountSnapshot {
  const _AccountSnapshot({required this.user, this.subscription = const SubscriptionState()}): super._();
  factory _AccountSnapshot.fromJson(Map<String, dynamic> json) => _$AccountSnapshotFromJson(json);

@override final  AccountIdentity user;
@override@JsonKey() final  SubscriptionState subscription;

/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSnapshotCopyWith<_AccountSnapshot> get copyWith => __$AccountSnapshotCopyWithImpl<_AccountSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSnapshot&&(identical(other.user, user) || other.user == user)&&(identical(other.subscription, subscription) || other.subscription == subscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subscription);

@override
String toString() {
  return 'AccountSnapshot(user: $user, subscription: $subscription)';
}


}

/// @nodoc
abstract mixin class _$AccountSnapshotCopyWith<$Res> implements $AccountSnapshotCopyWith<$Res> {
  factory _$AccountSnapshotCopyWith(_AccountSnapshot value, $Res Function(_AccountSnapshot) _then) = __$AccountSnapshotCopyWithImpl;
@override @useResult
$Res call({
 AccountIdentity user, SubscriptionState subscription
});


@override $AccountIdentityCopyWith<$Res> get user;@override $SubscriptionStateCopyWith<$Res> get subscription;

}
/// @nodoc
class __$AccountSnapshotCopyWithImpl<$Res>
    implements _$AccountSnapshotCopyWith<$Res> {
  __$AccountSnapshotCopyWithImpl(this._self, this._then);

  final _AccountSnapshot _self;
  final $Res Function(_AccountSnapshot) _then;

/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? subscription = null,}) {
  return _then(_AccountSnapshot(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AccountIdentity,subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionState,
  ));
}

/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountIdentityCopyWith<$Res> get user {
  
  return $AccountIdentityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<$Res> get subscription {
  
  return $SubscriptionStateCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}


/// @nodoc
mixin _$LinkedinAccount {

 String get id; String get profileId; String get profileName; String? get profileHeadline; String? get profileImage;/// The company page's vanity slug. Null on a company account means the
/// user has connected the company app but not yet chosen which page to
/// post to — the web opens its page-picker on exactly that condition.
 String? get profileSlug; DateTime? get expiresAt; String get appType;/// The server's own verdict on whether this account can still publish.
/// Nullable on purpose: the web's `isLinkedinAccountHealthy` PREFERS this
/// boolean and only falls back to the expiry when the field is absent, and
/// defaulting it to `false` here would silently turn a missing field into
/// "healthy" for an expired token.
 bool? get needsReconnect;
/// Create a copy of LinkedinAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkedinAccountCopyWith<LinkedinAccount> get copyWith => _$LinkedinAccountCopyWithImpl<LinkedinAccount>(this as LinkedinAccount, _$identity);

  /// Serializes this LinkedinAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkedinAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileHeadline, profileHeadline) || other.profileHeadline == profileHeadline)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,profileHeadline,profileImage,profileSlug,expiresAt,appType,needsReconnect);

@override
String toString() {
  return 'LinkedinAccount(id: $id, profileId: $profileId, profileName: $profileName, profileHeadline: $profileHeadline, profileImage: $profileImage, profileSlug: $profileSlug, expiresAt: $expiresAt, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class $LinkedinAccountCopyWith<$Res>  {
  factory $LinkedinAccountCopyWith(LinkedinAccount value, $Res Function(LinkedinAccount) _then) = _$LinkedinAccountCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String profileName, String? profileHeadline, String? profileImage, String? profileSlug, DateTime? expiresAt, String appType, bool? needsReconnect
});




}
/// @nodoc
class _$LinkedinAccountCopyWithImpl<$Res>
    implements $LinkedinAccountCopyWith<$Res> {
  _$LinkedinAccountCopyWithImpl(this._self, this._then);

  final LinkedinAccount _self;
  final $Res Function(LinkedinAccount) _then;

/// Create a copy of LinkedinAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? profileHeadline = freezed,Object? profileImage = freezed,Object? profileSlug = freezed,Object? expiresAt = freezed,Object? appType = null,Object? needsReconnect = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileHeadline: freezed == profileHeadline ? _self.profileHeadline : profileHeadline // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: freezed == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkedinAccount].
extension LinkedinAccountPatterns on LinkedinAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkedinAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkedinAccount value)  $default,){
final _that = this;
switch (_that) {
case _LinkedinAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkedinAccount value)?  $default,){
final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  DateTime? expiresAt,  String appType,  bool? needsReconnect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.expiresAt,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  DateTime? expiresAt,  String appType,  bool? needsReconnect)  $default,) {final _that = this;
switch (_that) {
case _LinkedinAccount():
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.expiresAt,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  DateTime? expiresAt,  String appType,  bool? needsReconnect)?  $default,) {final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.expiresAt,_that.appType,_that.needsReconnect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkedinAccount extends LinkedinAccount {
  const _LinkedinAccount({required this.id, this.profileId = '', this.profileName = '', this.profileHeadline, this.profileImage, this.profileSlug, this.expiresAt, this.appType = 'personal', this.needsReconnect}): super._();
  factory _LinkedinAccount.fromJson(Map<String, dynamic> json) => _$LinkedinAccountFromJson(json);

@override final  String id;
@override@JsonKey() final  String profileId;
@override@JsonKey() final  String profileName;
@override final  String? profileHeadline;
@override final  String? profileImage;
/// The company page's vanity slug. Null on a company account means the
/// user has connected the company app but not yet chosen which page to
/// post to — the web opens its page-picker on exactly that condition.
@override final  String? profileSlug;
@override final  DateTime? expiresAt;
@override@JsonKey() final  String appType;
/// The server's own verdict on whether this account can still publish.
/// Nullable on purpose: the web's `isLinkedinAccountHealthy` PREFERS this
/// boolean and only falls back to the expiry when the field is absent, and
/// defaulting it to `false` here would silently turn a missing field into
/// "healthy" for an expired token.
@override final  bool? needsReconnect;

/// Create a copy of LinkedinAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkedinAccountCopyWith<_LinkedinAccount> get copyWith => __$LinkedinAccountCopyWithImpl<_LinkedinAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkedinAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkedinAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileHeadline, profileHeadline) || other.profileHeadline == profileHeadline)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,profileHeadline,profileImage,profileSlug,expiresAt,appType,needsReconnect);

@override
String toString() {
  return 'LinkedinAccount(id: $id, profileId: $profileId, profileName: $profileName, profileHeadline: $profileHeadline, profileImage: $profileImage, profileSlug: $profileSlug, expiresAt: $expiresAt, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class _$LinkedinAccountCopyWith<$Res> implements $LinkedinAccountCopyWith<$Res> {
  factory _$LinkedinAccountCopyWith(_LinkedinAccount value, $Res Function(_LinkedinAccount) _then) = __$LinkedinAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String profileName, String? profileHeadline, String? profileImage, String? profileSlug, DateTime? expiresAt, String appType, bool? needsReconnect
});




}
/// @nodoc
class __$LinkedinAccountCopyWithImpl<$Res>
    implements _$LinkedinAccountCopyWith<$Res> {
  __$LinkedinAccountCopyWithImpl(this._self, this._then);

  final _LinkedinAccount _self;
  final $Res Function(_LinkedinAccount) _then;

/// Create a copy of LinkedinAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? profileHeadline = freezed,Object? profileImage = freezed,Object? profileSlug = freezed,Object? expiresAt = freezed,Object? appType = null,Object? needsReconnect = freezed,}) {
  return _then(_LinkedinAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileHeadline: freezed == profileHeadline ? _self.profileHeadline : profileHeadline // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: freezed == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$SlackConnection {

 bool get isConnected; String? get teamName; String? get teamId; String? get channelId; DateTime? get connectedAt;
/// Create a copy of SlackConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlackConnectionCopyWith<SlackConnection> get copyWith => _$SlackConnectionCopyWithImpl<SlackConnection>(this as SlackConnection, _$identity);

  /// Serializes this SlackConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlackConnection&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isConnected,teamName,teamId,channelId,connectedAt);

@override
String toString() {
  return 'SlackConnection(isConnected: $isConnected, teamName: $teamName, teamId: $teamId, channelId: $channelId, connectedAt: $connectedAt)';
}


}

/// @nodoc
abstract mixin class $SlackConnectionCopyWith<$Res>  {
  factory $SlackConnectionCopyWith(SlackConnection value, $Res Function(SlackConnection) _then) = _$SlackConnectionCopyWithImpl;
@useResult
$Res call({
 bool isConnected, String? teamName, String? teamId, String? channelId, DateTime? connectedAt
});




}
/// @nodoc
class _$SlackConnectionCopyWithImpl<$Res>
    implements $SlackConnectionCopyWith<$Res> {
  _$SlackConnectionCopyWithImpl(this._self, this._then);

  final SlackConnection _self;
  final $Res Function(SlackConnection) _then;

/// Create a copy of SlackConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? teamName = freezed,Object? teamId = freezed,Object? channelId = freezed,Object? connectedAt = freezed,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,teamName: freezed == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String?,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String?,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SlackConnection].
extension SlackConnectionPatterns on SlackConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlackConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlackConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlackConnection value)  $default,){
final _that = this;
switch (_that) {
case _SlackConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlackConnection value)?  $default,){
final _that = this;
switch (_that) {
case _SlackConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  String? teamName,  String? teamId,  String? channelId,  DateTime? connectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlackConnection() when $default != null:
return $default(_that.isConnected,_that.teamName,_that.teamId,_that.channelId,_that.connectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  String? teamName,  String? teamId,  String? channelId,  DateTime? connectedAt)  $default,) {final _that = this;
switch (_that) {
case _SlackConnection():
return $default(_that.isConnected,_that.teamName,_that.teamId,_that.channelId,_that.connectedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  String? teamName,  String? teamId,  String? channelId,  DateTime? connectedAt)?  $default,) {final _that = this;
switch (_that) {
case _SlackConnection() when $default != null:
return $default(_that.isConnected,_that.teamName,_that.teamId,_that.channelId,_that.connectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlackConnection extends SlackConnection {
  const _SlackConnection({this.isConnected = false, this.teamName, this.teamId, this.channelId, this.connectedAt}): super._();
  factory _SlackConnection.fromJson(Map<String, dynamic> json) => _$SlackConnectionFromJson(json);

@override@JsonKey() final  bool isConnected;
@override final  String? teamName;
@override final  String? teamId;
@override final  String? channelId;
@override final  DateTime? connectedAt;

/// Create a copy of SlackConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlackConnectionCopyWith<_SlackConnection> get copyWith => __$SlackConnectionCopyWithImpl<_SlackConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlackConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlackConnection&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isConnected,teamName,teamId,channelId,connectedAt);

@override
String toString() {
  return 'SlackConnection(isConnected: $isConnected, teamName: $teamName, teamId: $teamId, channelId: $channelId, connectedAt: $connectedAt)';
}


}

/// @nodoc
abstract mixin class _$SlackConnectionCopyWith<$Res> implements $SlackConnectionCopyWith<$Res> {
  factory _$SlackConnectionCopyWith(_SlackConnection value, $Res Function(_SlackConnection) _then) = __$SlackConnectionCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, String? teamName, String? teamId, String? channelId, DateTime? connectedAt
});




}
/// @nodoc
class __$SlackConnectionCopyWithImpl<$Res>
    implements _$SlackConnectionCopyWith<$Res> {
  __$SlackConnectionCopyWithImpl(this._self, this._then);

  final _SlackConnection _self;
  final $Res Function(_SlackConnection) _then;

/// Create a copy of SlackConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? teamName = freezed,Object? teamId = freezed,Object? channelId = freezed,Object? connectedAt = freezed,}) {
  return _then(_SlackConnection(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,teamName: freezed == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String?,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String?,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CalendarTokenStatus {

 bool get expired; DateTime? get expiresAt; int get expiresInMinutes;
/// Create a copy of CalendarTokenStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarTokenStatusCopyWith<CalendarTokenStatus> get copyWith => _$CalendarTokenStatusCopyWithImpl<CalendarTokenStatus>(this as CalendarTokenStatus, _$identity);

  /// Serializes this CalendarTokenStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarTokenStatus&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiresInMinutes, expiresInMinutes) || other.expiresInMinutes == expiresInMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expired,expiresAt,expiresInMinutes);

@override
String toString() {
  return 'CalendarTokenStatus(expired: $expired, expiresAt: $expiresAt, expiresInMinutes: $expiresInMinutes)';
}


}

/// @nodoc
abstract mixin class $CalendarTokenStatusCopyWith<$Res>  {
  factory $CalendarTokenStatusCopyWith(CalendarTokenStatus value, $Res Function(CalendarTokenStatus) _then) = _$CalendarTokenStatusCopyWithImpl;
@useResult
$Res call({
 bool expired, DateTime? expiresAt, int expiresInMinutes
});




}
/// @nodoc
class _$CalendarTokenStatusCopyWithImpl<$Res>
    implements $CalendarTokenStatusCopyWith<$Res> {
  _$CalendarTokenStatusCopyWithImpl(this._self, this._then);

  final CalendarTokenStatus _self;
  final $Res Function(CalendarTokenStatus) _then;

/// Create a copy of CalendarTokenStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expired = null,Object? expiresAt = freezed,Object? expiresInMinutes = null,}) {
  return _then(_self.copyWith(
expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresInMinutes: null == expiresInMinutes ? _self.expiresInMinutes : expiresInMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarTokenStatus].
extension CalendarTokenStatusPatterns on CalendarTokenStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarTokenStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarTokenStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarTokenStatus value)  $default,){
final _that = this;
switch (_that) {
case _CalendarTokenStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarTokenStatus value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarTokenStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool expired,  DateTime? expiresAt,  int expiresInMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarTokenStatus() when $default != null:
return $default(_that.expired,_that.expiresAt,_that.expiresInMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool expired,  DateTime? expiresAt,  int expiresInMinutes)  $default,) {final _that = this;
switch (_that) {
case _CalendarTokenStatus():
return $default(_that.expired,_that.expiresAt,_that.expiresInMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool expired,  DateTime? expiresAt,  int expiresInMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CalendarTokenStatus() when $default != null:
return $default(_that.expired,_that.expiresAt,_that.expiresInMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarTokenStatus extends CalendarTokenStatus {
  const _CalendarTokenStatus({this.expired = false, this.expiresAt, this.expiresInMinutes = 0}): super._();
  factory _CalendarTokenStatus.fromJson(Map<String, dynamic> json) => _$CalendarTokenStatusFromJson(json);

@override@JsonKey() final  bool expired;
@override final  DateTime? expiresAt;
@override@JsonKey() final  int expiresInMinutes;

/// Create a copy of CalendarTokenStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarTokenStatusCopyWith<_CalendarTokenStatus> get copyWith => __$CalendarTokenStatusCopyWithImpl<_CalendarTokenStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarTokenStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarTokenStatus&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiresInMinutes, expiresInMinutes) || other.expiresInMinutes == expiresInMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expired,expiresAt,expiresInMinutes);

@override
String toString() {
  return 'CalendarTokenStatus(expired: $expired, expiresAt: $expiresAt, expiresInMinutes: $expiresInMinutes)';
}


}

/// @nodoc
abstract mixin class _$CalendarTokenStatusCopyWith<$Res> implements $CalendarTokenStatusCopyWith<$Res> {
  factory _$CalendarTokenStatusCopyWith(_CalendarTokenStatus value, $Res Function(_CalendarTokenStatus) _then) = __$CalendarTokenStatusCopyWithImpl;
@override @useResult
$Res call({
 bool expired, DateTime? expiresAt, int expiresInMinutes
});




}
/// @nodoc
class __$CalendarTokenStatusCopyWithImpl<$Res>
    implements _$CalendarTokenStatusCopyWith<$Res> {
  __$CalendarTokenStatusCopyWithImpl(this._self, this._then);

  final _CalendarTokenStatus _self;
  final $Res Function(_CalendarTokenStatus) _then;

/// Create a copy of CalendarTokenStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expired = null,Object? expiresAt = freezed,Object? expiresInMinutes = null,}) {
  return _then(_CalendarTokenStatus(
expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresInMinutes: null == expiresInMinutes ? _self.expiresInMinutes : expiresInMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CalendarConnection {

 bool get isConnected; String? get calendarId; DateTime? get connectedAt; CalendarTokenStatus get tokenStatus;
/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarConnectionCopyWith<CalendarConnection> get copyWith => _$CalendarConnectionCopyWithImpl<CalendarConnection>(this as CalendarConnection, _$identity);

  /// Serializes this CalendarConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConnection&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt)&&(identical(other.tokenStatus, tokenStatus) || other.tokenStatus == tokenStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isConnected,calendarId,connectedAt,tokenStatus);

@override
String toString() {
  return 'CalendarConnection(isConnected: $isConnected, calendarId: $calendarId, connectedAt: $connectedAt, tokenStatus: $tokenStatus)';
}


}

/// @nodoc
abstract mixin class $CalendarConnectionCopyWith<$Res>  {
  factory $CalendarConnectionCopyWith(CalendarConnection value, $Res Function(CalendarConnection) _then) = _$CalendarConnectionCopyWithImpl;
@useResult
$Res call({
 bool isConnected, String? calendarId, DateTime? connectedAt, CalendarTokenStatus tokenStatus
});


$CalendarTokenStatusCopyWith<$Res> get tokenStatus;

}
/// @nodoc
class _$CalendarConnectionCopyWithImpl<$Res>
    implements $CalendarConnectionCopyWith<$Res> {
  _$CalendarConnectionCopyWithImpl(this._self, this._then);

  final CalendarConnection _self;
  final $Res Function(CalendarConnection) _then;

/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? calendarId = freezed,Object? connectedAt = freezed,Object? tokenStatus = null,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,calendarId: freezed == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String?,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tokenStatus: null == tokenStatus ? _self.tokenStatus : tokenStatus // ignore: cast_nullable_to_non_nullable
as CalendarTokenStatus,
  ));
}
/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarTokenStatusCopyWith<$Res> get tokenStatus {
  
  return $CalendarTokenStatusCopyWith<$Res>(_self.tokenStatus, (value) {
    return _then(_self.copyWith(tokenStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarConnection].
extension CalendarConnectionPatterns on CalendarConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarConnection value)  $default,){
final _that = this;
switch (_that) {
case _CalendarConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarConnection value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  String? calendarId,  DateTime? connectedAt,  CalendarTokenStatus tokenStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarConnection() when $default != null:
return $default(_that.isConnected,_that.calendarId,_that.connectedAt,_that.tokenStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  String? calendarId,  DateTime? connectedAt,  CalendarTokenStatus tokenStatus)  $default,) {final _that = this;
switch (_that) {
case _CalendarConnection():
return $default(_that.isConnected,_that.calendarId,_that.connectedAt,_that.tokenStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  String? calendarId,  DateTime? connectedAt,  CalendarTokenStatus tokenStatus)?  $default,) {final _that = this;
switch (_that) {
case _CalendarConnection() when $default != null:
return $default(_that.isConnected,_that.calendarId,_that.connectedAt,_that.tokenStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarConnection extends CalendarConnection {
  const _CalendarConnection({this.isConnected = false, this.calendarId, this.connectedAt, this.tokenStatus = const CalendarTokenStatus()}): super._();
  factory _CalendarConnection.fromJson(Map<String, dynamic> json) => _$CalendarConnectionFromJson(json);

@override@JsonKey() final  bool isConnected;
@override final  String? calendarId;
@override final  DateTime? connectedAt;
@override@JsonKey() final  CalendarTokenStatus tokenStatus;

/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarConnectionCopyWith<_CalendarConnection> get copyWith => __$CalendarConnectionCopyWithImpl<_CalendarConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarConnection&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt)&&(identical(other.tokenStatus, tokenStatus) || other.tokenStatus == tokenStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isConnected,calendarId,connectedAt,tokenStatus);

@override
String toString() {
  return 'CalendarConnection(isConnected: $isConnected, calendarId: $calendarId, connectedAt: $connectedAt, tokenStatus: $tokenStatus)';
}


}

/// @nodoc
abstract mixin class _$CalendarConnectionCopyWith<$Res> implements $CalendarConnectionCopyWith<$Res> {
  factory _$CalendarConnectionCopyWith(_CalendarConnection value, $Res Function(_CalendarConnection) _then) = __$CalendarConnectionCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, String? calendarId, DateTime? connectedAt, CalendarTokenStatus tokenStatus
});


@override $CalendarTokenStatusCopyWith<$Res> get tokenStatus;

}
/// @nodoc
class __$CalendarConnectionCopyWithImpl<$Res>
    implements _$CalendarConnectionCopyWith<$Res> {
  __$CalendarConnectionCopyWithImpl(this._self, this._then);

  final _CalendarConnection _self;
  final $Res Function(_CalendarConnection) _then;

/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? calendarId = freezed,Object? connectedAt = freezed,Object? tokenStatus = null,}) {
  return _then(_CalendarConnection(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,calendarId: freezed == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String?,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tokenStatus: null == tokenStatus ? _self.tokenStatus : tokenStatus // ignore: cast_nullable_to_non_nullable
as CalendarTokenStatus,
  ));
}

/// Create a copy of CalendarConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarTokenStatusCopyWith<$Res> get tokenStatus {
  
  return $CalendarTokenStatusCopyWith<$Res>(_self.tokenStatus, (value) {
    return _then(_self.copyWith(tokenStatus: value));
  });
}
}


/// @nodoc
mixin _$GeoPricing {

 String get countryCode; String get countryName; String get currency; String get symbol; int get personalPrice; int get companyPrice; bool get isIndia; int get subunitMultiplier;
/// Create a copy of GeoPricing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoPricingCopyWith<GeoPricing> get copyWith => _$GeoPricingCopyWithImpl<GeoPricing>(this as GeoPricing, _$identity);

  /// Serializes this GeoPricing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoPricing&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.personalPrice, personalPrice) || other.personalPrice == personalPrice)&&(identical(other.companyPrice, companyPrice) || other.companyPrice == companyPrice)&&(identical(other.isIndia, isIndia) || other.isIndia == isIndia)&&(identical(other.subunitMultiplier, subunitMultiplier) || other.subunitMultiplier == subunitMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,currency,symbol,personalPrice,companyPrice,isIndia,subunitMultiplier);

@override
String toString() {
  return 'GeoPricing(countryCode: $countryCode, countryName: $countryName, currency: $currency, symbol: $symbol, personalPrice: $personalPrice, companyPrice: $companyPrice, isIndia: $isIndia, subunitMultiplier: $subunitMultiplier)';
}


}

/// @nodoc
abstract mixin class $GeoPricingCopyWith<$Res>  {
  factory $GeoPricingCopyWith(GeoPricing value, $Res Function(GeoPricing) _then) = _$GeoPricingCopyWithImpl;
@useResult
$Res call({
 String countryCode, String countryName, String currency, String symbol, int personalPrice, int companyPrice, bool isIndia, int subunitMultiplier
});




}
/// @nodoc
class _$GeoPricingCopyWithImpl<$Res>
    implements $GeoPricingCopyWith<$Res> {
  _$GeoPricingCopyWithImpl(this._self, this._then);

  final GeoPricing _self;
  final $Res Function(GeoPricing) _then;

/// Create a copy of GeoPricing
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


/// Adds pattern-matching-related methods to [GeoPricing].
extension GeoPricingPatterns on GeoPricing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoPricing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoPricing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoPricing value)  $default,){
final _that = this;
switch (_that) {
case _GeoPricing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoPricing value)?  $default,){
final _that = this;
switch (_that) {
case _GeoPricing() when $default != null:
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
case _GeoPricing() when $default != null:
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
case _GeoPricing():
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
case _GeoPricing() when $default != null:
return $default(_that.countryCode,_that.countryName,_that.currency,_that.symbol,_that.personalPrice,_that.companyPrice,_that.isIndia,_that.subunitMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoPricing extends GeoPricing {
  const _GeoPricing({this.countryCode = 'IN', this.countryName = 'India', this.currency = 'INR', this.symbol = '₹', this.personalPrice = 0, this.companyPrice = 0, this.isIndia = true, this.subunitMultiplier = 100}): super._();
  factory _GeoPricing.fromJson(Map<String, dynamic> json) => _$GeoPricingFromJson(json);

@override@JsonKey() final  String countryCode;
@override@JsonKey() final  String countryName;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String symbol;
@override@JsonKey() final  int personalPrice;
@override@JsonKey() final  int companyPrice;
@override@JsonKey() final  bool isIndia;
@override@JsonKey() final  int subunitMultiplier;

/// Create a copy of GeoPricing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoPricingCopyWith<_GeoPricing> get copyWith => __$GeoPricingCopyWithImpl<_GeoPricing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoPricingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoPricing&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.personalPrice, personalPrice) || other.personalPrice == personalPrice)&&(identical(other.companyPrice, companyPrice) || other.companyPrice == companyPrice)&&(identical(other.isIndia, isIndia) || other.isIndia == isIndia)&&(identical(other.subunitMultiplier, subunitMultiplier) || other.subunitMultiplier == subunitMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,countryName,currency,symbol,personalPrice,companyPrice,isIndia,subunitMultiplier);

@override
String toString() {
  return 'GeoPricing(countryCode: $countryCode, countryName: $countryName, currency: $currency, symbol: $symbol, personalPrice: $personalPrice, companyPrice: $companyPrice, isIndia: $isIndia, subunitMultiplier: $subunitMultiplier)';
}


}

/// @nodoc
abstract mixin class _$GeoPricingCopyWith<$Res> implements $GeoPricingCopyWith<$Res> {
  factory _$GeoPricingCopyWith(_GeoPricing value, $Res Function(_GeoPricing) _then) = __$GeoPricingCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, String countryName, String currency, String symbol, int personalPrice, int companyPrice, bool isIndia, int subunitMultiplier
});




}
/// @nodoc
class __$GeoPricingCopyWithImpl<$Res>
    implements _$GeoPricingCopyWith<$Res> {
  __$GeoPricingCopyWithImpl(this._self, this._then);

  final _GeoPricing _self;
  final $Res Function(_GeoPricing) _then;

/// Create a copy of GeoPricing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? countryName = null,Object? currency = null,Object? symbol = null,Object? personalPrice = null,Object? companyPrice = null,Object? isIndia = null,Object? subunitMultiplier = null,}) {
  return _then(_GeoPricing(
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
mixin _$XpSummary {

 int get balance;
/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpSummaryCopyWith<XpSummary> get copyWith => _$XpSummaryCopyWithImpl<XpSummary>(this as XpSummary, _$identity);

  /// Serializes this XpSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpSummary&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'XpSummary(balance: $balance)';
}


}

/// @nodoc
abstract mixin class $XpSummaryCopyWith<$Res>  {
  factory $XpSummaryCopyWith(XpSummary value, $Res Function(XpSummary) _then) = _$XpSummaryCopyWithImpl;
@useResult
$Res call({
 int balance
});




}
/// @nodoc
class _$XpSummaryCopyWithImpl<$Res>
    implements $XpSummaryCopyWith<$Res> {
  _$XpSummaryCopyWithImpl(this._self, this._then);

  final XpSummary _self;
  final $Res Function(XpSummary) _then;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XpSummary].
extension XpSummaryPatterns on XpSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpSummary value)  $default,){
final _that = this;
switch (_that) {
case _XpSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpSummary value)?  $default,){
final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
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
case _XpSummary() when $default != null:
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
case _XpSummary():
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
case _XpSummary() when $default != null:
return $default(_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XpSummary extends XpSummary {
  const _XpSummary({this.balance = 0}): super._();
  factory _XpSummary.fromJson(Map<String, dynamic> json) => _$XpSummaryFromJson(json);

@override@JsonKey() final  int balance;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpSummaryCopyWith<_XpSummary> get copyWith => __$XpSummaryCopyWithImpl<_XpSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XpSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpSummary&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance);

@override
String toString() {
  return 'XpSummary(balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$XpSummaryCopyWith<$Res> implements $XpSummaryCopyWith<$Res> {
  factory _$XpSummaryCopyWith(_XpSummary value, $Res Function(_XpSummary) _then) = __$XpSummaryCopyWithImpl;
@override @useResult
$Res call({
 int balance
});




}
/// @nodoc
class __$XpSummaryCopyWithImpl<$Res>
    implements _$XpSummaryCopyWith<$Res> {
  __$XpSummaryCopyWithImpl(this._self, this._then);

  final _XpSummary _self;
  final $Res Function(_XpSummary) _then;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,}) {
  return _then(_XpSummary(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
