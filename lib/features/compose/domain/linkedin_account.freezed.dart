// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'linkedin_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkedinAccount {

 String get id; String get profileId; String get profileName; String? get profileHeadline; String? get profileImage; String? get profileSlug; String get appType;/// True when the access token has expired AND cannot be refreshed. The
/// account is listed but cannot publish until the user re-authorises.
 bool get needsReconnect;
/// Create a copy of LinkedinAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkedinAccountCopyWith<LinkedinAccount> get copyWith => _$LinkedinAccountCopyWithImpl<LinkedinAccount>(this as LinkedinAccount, _$identity);

  /// Serializes this LinkedinAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkedinAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileHeadline, profileHeadline) || other.profileHeadline == profileHeadline)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,profileHeadline,profileImage,profileSlug,appType,needsReconnect);

@override
String toString() {
  return 'LinkedinAccount(id: $id, profileId: $profileId, profileName: $profileName, profileHeadline: $profileHeadline, profileImage: $profileImage, profileSlug: $profileSlug, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class $LinkedinAccountCopyWith<$Res>  {
  factory $LinkedinAccountCopyWith(LinkedinAccount value, $Res Function(LinkedinAccount) _then) = _$LinkedinAccountCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String profileName, String? profileHeadline, String? profileImage, String? profileSlug, String appType, bool needsReconnect
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? profileHeadline = freezed,Object? profileImage = freezed,Object? profileSlug = freezed,Object? appType = null,Object? needsReconnect = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileHeadline: freezed == profileHeadline ? _self.profileHeadline : profileHeadline // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: null == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  String appType,  bool needsReconnect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  String appType,  bool needsReconnect)  $default,) {final _that = this;
switch (_that) {
case _LinkedinAccount():
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String profileName,  String? profileHeadline,  String? profileImage,  String? profileSlug,  String appType,  bool needsReconnect)?  $default,) {final _that = this;
switch (_that) {
case _LinkedinAccount() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.profileHeadline,_that.profileImage,_that.profileSlug,_that.appType,_that.needsReconnect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkedinAccount extends LinkedinAccount {
  const _LinkedinAccount({required this.id, this.profileId = '', this.profileName = '', this.profileHeadline, this.profileImage, this.profileSlug, this.appType = 'personal', this.needsReconnect = false}): super._();
  factory _LinkedinAccount.fromJson(Map<String, dynamic> json) => _$LinkedinAccountFromJson(json);

@override final  String id;
@override@JsonKey() final  String profileId;
@override@JsonKey() final  String profileName;
@override final  String? profileHeadline;
@override final  String? profileImage;
@override final  String? profileSlug;
@override@JsonKey() final  String appType;
/// True when the access token has expired AND cannot be refreshed. The
/// account is listed but cannot publish until the user re-authorises.
@override@JsonKey() final  bool needsReconnect;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkedinAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileHeadline, profileHeadline) || other.profileHeadline == profileHeadline)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,profileHeadline,profileImage,profileSlug,appType,needsReconnect);

@override
String toString() {
  return 'LinkedinAccount(id: $id, profileId: $profileId, profileName: $profileName, profileHeadline: $profileHeadline, profileImage: $profileImage, profileSlug: $profileSlug, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class _$LinkedinAccountCopyWith<$Res> implements $LinkedinAccountCopyWith<$Res> {
  factory _$LinkedinAccountCopyWith(_LinkedinAccount value, $Res Function(_LinkedinAccount) _then) = __$LinkedinAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String profileName, String? profileHeadline, String? profileImage, String? profileSlug, String appType, bool needsReconnect
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? profileHeadline = freezed,Object? profileImage = freezed,Object? profileSlug = freezed,Object? appType = null,Object? needsReconnect = null,}) {
  return _then(_LinkedinAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileHeadline: freezed == profileHeadline ? _self.profileHeadline : profileHeadline // ignore: cast_nullable_to_non_nullable
as String?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: null == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
