// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wonder_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WonderMarker {

 WonderType get type; String get title; int get startYr; int get endYr; String get thumbnailUrl;
/// Create a copy of WonderMarker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WonderMarkerCopyWith<WonderMarker> get copyWith => _$WonderMarkerCopyWithImpl<WonderMarker>(this as WonderMarker, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WonderMarker&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startYr, startYr) || other.startYr == startYr)&&(identical(other.endYr, endYr) || other.endYr == endYr)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,startYr,endYr,thumbnailUrl);

@override
String toString() {
  return 'WonderMarker(type: $type, title: $title, startYr: $startYr, endYr: $endYr, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $WonderMarkerCopyWith<$Res>  {
  factory $WonderMarkerCopyWith(WonderMarker value, $Res Function(WonderMarker) _then) = _$WonderMarkerCopyWithImpl;
@useResult
$Res call({
 WonderType type, String title, int startYr, int endYr, String thumbnailUrl
});




}
/// @nodoc
class _$WonderMarkerCopyWithImpl<$Res>
    implements $WonderMarkerCopyWith<$Res> {
  _$WonderMarkerCopyWithImpl(this._self, this._then);

  final WonderMarker _self;
  final $Res Function(WonderMarker) _then;

/// Create a copy of WonderMarker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? startYr = null,Object? endYr = null,Object? thumbnailUrl = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WonderType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startYr: null == startYr ? _self.startYr : startYr // ignore: cast_nullable_to_non_nullable
as int,endYr: null == endYr ? _self.endYr : endYr // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WonderMarker].
extension WonderMarkerPatterns on WonderMarker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WonderMarker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WonderMarker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WonderMarker value)  $default,){
final _that = this;
switch (_that) {
case _WonderMarker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WonderMarker value)?  $default,){
final _that = this;
switch (_that) {
case _WonderMarker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WonderType type,  String title,  int startYr,  int endYr,  String thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WonderMarker() when $default != null:
return $default(_that.type,_that.title,_that.startYr,_that.endYr,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WonderType type,  String title,  int startYr,  int endYr,  String thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _WonderMarker():
return $default(_that.type,_that.title,_that.startYr,_that.endYr,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WonderType type,  String title,  int startYr,  int endYr,  String thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _WonderMarker() when $default != null:
return $default(_that.type,_that.title,_that.startYr,_that.endYr,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc


class _WonderMarker implements WonderMarker {
  const _WonderMarker({required this.type, required this.title, required this.startYr, required this.endYr, required this.thumbnailUrl});
  

@override final  WonderType type;
@override final  String title;
@override final  int startYr;
@override final  int endYr;
@override final  String thumbnailUrl;

/// Create a copy of WonderMarker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WonderMarkerCopyWith<_WonderMarker> get copyWith => __$WonderMarkerCopyWithImpl<_WonderMarker>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WonderMarker&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startYr, startYr) || other.startYr == startYr)&&(identical(other.endYr, endYr) || other.endYr == endYr)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,startYr,endYr,thumbnailUrl);

@override
String toString() {
  return 'WonderMarker(type: $type, title: $title, startYr: $startYr, endYr: $endYr, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$WonderMarkerCopyWith<$Res> implements $WonderMarkerCopyWith<$Res> {
  factory _$WonderMarkerCopyWith(_WonderMarker value, $Res Function(_WonderMarker) _then) = __$WonderMarkerCopyWithImpl;
@override @useResult
$Res call({
 WonderType type, String title, int startYr, int endYr, String thumbnailUrl
});




}
/// @nodoc
class __$WonderMarkerCopyWithImpl<$Res>
    implements _$WonderMarkerCopyWith<$Res> {
  __$WonderMarkerCopyWithImpl(this._self, this._then);

  final _WonderMarker _self;
  final $Res Function(_WonderMarker) _then;

/// Create a copy of WonderMarker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? startYr = null,Object? endYr = null,Object? thumbnailUrl = null,}) {
  return _then(_WonderMarker(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WonderType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startYr: null == startYr ? _self.startYr : startYr // ignore: cast_nullable_to_non_nullable
as int,endYr: null == endYr ? _self.endYr : endYr // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
