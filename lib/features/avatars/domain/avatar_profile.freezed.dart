// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvatarProfile {

 String get name; int get lookCount; String get voiceName;/// Circle profile photo in the header pill (fixtures use picsum seeds).
 String get avatarUrl;
/// Create a copy of AvatarProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarProfileCopyWith<AvatarProfile> get copyWith => _$AvatarProfileCopyWithImpl<AvatarProfile>(this as AvatarProfile, _$identity);

  /// Serializes this AvatarProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.lookCount, lookCount) || other.lookCount == lookCount)&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,lookCount,voiceName,avatarUrl);

@override
String toString() {
  return 'AvatarProfile(name: $name, lookCount: $lookCount, voiceName: $voiceName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $AvatarProfileCopyWith<$Res>  {
  factory $AvatarProfileCopyWith(AvatarProfile value, $Res Function(AvatarProfile) _then) = _$AvatarProfileCopyWithImpl;
@useResult
$Res call({
 String name, int lookCount, String voiceName, String avatarUrl
});




}
/// @nodoc
class _$AvatarProfileCopyWithImpl<$Res>
    implements $AvatarProfileCopyWith<$Res> {
  _$AvatarProfileCopyWithImpl(this._self, this._then);

  final AvatarProfile _self;
  final $Res Function(AvatarProfile) _then;

/// Create a copy of AvatarProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? lookCount = null,Object? voiceName = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lookCount: null == lookCount ? _self.lookCount : lookCount // ignore: cast_nullable_to_non_nullable
as int,voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarProfile].
extension AvatarProfilePatterns on AvatarProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarProfile value)  $default,){
final _that = this;
switch (_that) {
case _AvatarProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int lookCount,  String voiceName,  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarProfile() when $default != null:
return $default(_that.name,_that.lookCount,_that.voiceName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int lookCount,  String voiceName,  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _AvatarProfile():
return $default(_that.name,_that.lookCount,_that.voiceName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int lookCount,  String voiceName,  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _AvatarProfile() when $default != null:
return $default(_that.name,_that.lookCount,_that.voiceName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvatarProfile extends AvatarProfile {
  const _AvatarProfile({required this.name, required this.lookCount, required this.voiceName, required this.avatarUrl}): super._();
  factory _AvatarProfile.fromJson(Map<String, dynamic> json) => _$AvatarProfileFromJson(json);

@override final  String name;
@override final  int lookCount;
@override final  String voiceName;
/// Circle profile photo in the header pill (fixtures use picsum seeds).
@override final  String avatarUrl;

/// Create a copy of AvatarProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarProfileCopyWith<_AvatarProfile> get copyWith => __$AvatarProfileCopyWithImpl<_AvatarProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.lookCount, lookCount) || other.lookCount == lookCount)&&(identical(other.voiceName, voiceName) || other.voiceName == voiceName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,lookCount,voiceName,avatarUrl);

@override
String toString() {
  return 'AvatarProfile(name: $name, lookCount: $lookCount, voiceName: $voiceName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$AvatarProfileCopyWith<$Res> implements $AvatarProfileCopyWith<$Res> {
  factory _$AvatarProfileCopyWith(_AvatarProfile value, $Res Function(_AvatarProfile) _then) = __$AvatarProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, int lookCount, String voiceName, String avatarUrl
});




}
/// @nodoc
class __$AvatarProfileCopyWithImpl<$Res>
    implements _$AvatarProfileCopyWith<$Res> {
  __$AvatarProfileCopyWithImpl(this._self, this._then);

  final _AvatarProfile _self;
  final $Res Function(_AvatarProfile) _then;

/// Create a copy of AvatarProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? lookCount = null,Object? voiceName = null,Object? avatarUrl = null,}) {
  return _then(_AvatarProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lookCount: null == lookCount ? _self.lookCount : lookCount // ignore: cast_nullable_to_non_nullable
as int,voiceName: null == voiceName ? _self.voiceName : voiceName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
