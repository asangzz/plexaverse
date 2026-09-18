// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_look.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvatarLook {

 String get id;/// Portrait look photo (fixtures use picsum 300×400 seeds).
 String get thumbnailUrl;
/// Create a copy of AvatarLook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarLookCopyWith<AvatarLook> get copyWith => _$AvatarLookCopyWithImpl<AvatarLook>(this as AvatarLook, _$identity);

  /// Serializes this AvatarLook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarLook&&(identical(other.id, id) || other.id == id)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,thumbnailUrl);

@override
String toString() {
  return 'AvatarLook(id: $id, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $AvatarLookCopyWith<$Res>  {
  factory $AvatarLookCopyWith(AvatarLook value, $Res Function(AvatarLook) _then) = _$AvatarLookCopyWithImpl;
@useResult
$Res call({
 String id, String thumbnailUrl
});




}
/// @nodoc
class _$AvatarLookCopyWithImpl<$Res>
    implements $AvatarLookCopyWith<$Res> {
  _$AvatarLookCopyWithImpl(this._self, this._then);

  final AvatarLook _self;
  final $Res Function(AvatarLook) _then;

/// Create a copy of AvatarLook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? thumbnailUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarLook].
extension AvatarLookPatterns on AvatarLook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarLook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarLook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarLook value)  $default,){
final _that = this;
switch (_that) {
case _AvatarLook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarLook value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarLook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarLook() when $default != null:
return $default(_that.id,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _AvatarLook():
return $default(_that.id,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _AvatarLook() when $default != null:
return $default(_that.id,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvatarLook implements AvatarLook {
  const _AvatarLook({required this.id, required this.thumbnailUrl});
  factory _AvatarLook.fromJson(Map<String, dynamic> json) => _$AvatarLookFromJson(json);

@override final  String id;
/// Portrait look photo (fixtures use picsum 300×400 seeds).
@override final  String thumbnailUrl;

/// Create a copy of AvatarLook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarLookCopyWith<_AvatarLook> get copyWith => __$AvatarLookCopyWithImpl<_AvatarLook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarLookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarLook&&(identical(other.id, id) || other.id == id)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,thumbnailUrl);

@override
String toString() {
  return 'AvatarLook(id: $id, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$AvatarLookCopyWith<$Res> implements $AvatarLookCopyWith<$Res> {
  factory _$AvatarLookCopyWith(_AvatarLook value, $Res Function(_AvatarLook) _then) = __$AvatarLookCopyWithImpl;
@override @useResult
$Res call({
 String id, String thumbnailUrl
});




}
/// @nodoc
class __$AvatarLookCopyWithImpl<$Res>
    implements _$AvatarLookCopyWith<$Res> {
  __$AvatarLookCopyWithImpl(this._self, this._then);

  final _AvatarLook _self;
  final $Res Function(_AvatarLook) _then;

/// Create a copy of AvatarLook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? thumbnailUrl = null,}) {
  return _then(_AvatarLook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
