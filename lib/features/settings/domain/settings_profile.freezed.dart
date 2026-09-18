// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsProfile {

 String get id; String get displayName; String get handle; String get email;// Absent (not null) in the wire/fixture JSON when no avatar is set —
// matches the "omitted = initials avatar" convention.
@JsonKey(includeIfNull: false) String? get avatarUrl;// ISO-8601 date the account was created; drives the "Member since" line.
@JsonKey(includeIfNull: false) DateTime? get memberSince;
/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsProfileCopyWith<SettingsProfile> get copyWith => _$SettingsProfileCopyWithImpl<SettingsProfile>(this as SettingsProfile, _$identity);

  /// Serializes this SettingsProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,handle,email,avatarUrl,memberSince);

@override
String toString() {
  return 'SettingsProfile(id: $id, displayName: $displayName, handle: $handle, email: $email, avatarUrl: $avatarUrl, memberSince: $memberSince)';
}


}

/// @nodoc
abstract mixin class $SettingsProfileCopyWith<$Res>  {
  factory $SettingsProfileCopyWith(SettingsProfile value, $Res Function(SettingsProfile) _then) = _$SettingsProfileCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String handle, String email,@JsonKey(includeIfNull: false) String? avatarUrl,@JsonKey(includeIfNull: false) DateTime? memberSince
});




}
/// @nodoc
class _$SettingsProfileCopyWithImpl<$Res>
    implements $SettingsProfileCopyWith<$Res> {
  _$SettingsProfileCopyWithImpl(this._self, this._then);

  final SettingsProfile _self;
  final $Res Function(SettingsProfile) _then;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? handle = null,Object? email = null,Object? avatarUrl = freezed,Object? memberSince = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsProfile].
extension SettingsProfilePatterns on SettingsProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsProfile value)  $default,){
final _that = this;
switch (_that) {
case _SettingsProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String handle,  String email, @JsonKey(includeIfNull: false)  String? avatarUrl, @JsonKey(includeIfNull: false)  DateTime? memberSince)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.handle,_that.email,_that.avatarUrl,_that.memberSince);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String handle,  String email, @JsonKey(includeIfNull: false)  String? avatarUrl, @JsonKey(includeIfNull: false)  DateTime? memberSince)  $default,) {final _that = this;
switch (_that) {
case _SettingsProfile():
return $default(_that.id,_that.displayName,_that.handle,_that.email,_that.avatarUrl,_that.memberSince);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String handle,  String email, @JsonKey(includeIfNull: false)  String? avatarUrl, @JsonKey(includeIfNull: false)  DateTime? memberSince)?  $default,) {final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.handle,_that.email,_that.avatarUrl,_that.memberSince);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsProfile extends SettingsProfile {
  const _SettingsProfile({required this.id, required this.displayName, required this.handle, required this.email, @JsonKey(includeIfNull: false) this.avatarUrl, @JsonKey(includeIfNull: false) this.memberSince}): super._();
  factory _SettingsProfile.fromJson(Map<String, dynamic> json) => _$SettingsProfileFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String handle;
@override final  String email;
// Absent (not null) in the wire/fixture JSON when no avatar is set —
// matches the "omitted = initials avatar" convention.
@override@JsonKey(includeIfNull: false) final  String? avatarUrl;
// ISO-8601 date the account was created; drives the "Member since" line.
@override@JsonKey(includeIfNull: false) final  DateTime? memberSince;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsProfileCopyWith<_SettingsProfile> get copyWith => __$SettingsProfileCopyWithImpl<_SettingsProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,handle,email,avatarUrl,memberSince);

@override
String toString() {
  return 'SettingsProfile(id: $id, displayName: $displayName, handle: $handle, email: $email, avatarUrl: $avatarUrl, memberSince: $memberSince)';
}


}

/// @nodoc
abstract mixin class _$SettingsProfileCopyWith<$Res> implements $SettingsProfileCopyWith<$Res> {
  factory _$SettingsProfileCopyWith(_SettingsProfile value, $Res Function(_SettingsProfile) _then) = __$SettingsProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String handle, String email,@JsonKey(includeIfNull: false) String? avatarUrl,@JsonKey(includeIfNull: false) DateTime? memberSince
});




}
/// @nodoc
class __$SettingsProfileCopyWithImpl<$Res>
    implements _$SettingsProfileCopyWith<$Res> {
  __$SettingsProfileCopyWithImpl(this._self, this._then);

  final _SettingsProfile _self;
  final $Res Function(_SettingsProfile) _then;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? handle = null,Object? email = null,Object? avatarUrl = freezed,Object? memberSince = freezed,}) {
  return _then(_SettingsProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
