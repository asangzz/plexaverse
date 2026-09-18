// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerTemplate {

 String get id; String get name; String? get description; String? get thumbnail;/// The authored size, as the row records it. The design's own canvas wins
/// when there is one — these are only the fallback for a row whose blob
/// did not come back.
 int get width; int get height; StudioDesignData? get data;
/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerTemplateCopyWith<BannerTemplate> get copyWith => _$BannerTemplateCopyWithImpl<BannerTemplate>(this as BannerTemplate, _$identity);

  /// Serializes this BannerTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,data);

@override
String toString() {
  return 'BannerTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class $BannerTemplateCopyWith<$Res>  {
  factory $BannerTemplateCopyWith(BannerTemplate value, $Res Function(BannerTemplate) _then) = _$BannerTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, StudioDesignData? data
});


$StudioDesignDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$BannerTemplateCopyWithImpl<$Res>
    implements $BannerTemplateCopyWith<$Res> {
  _$BannerTemplateCopyWithImpl(this._self, this._then);

  final BannerTemplate _self;
  final $Res Function(BannerTemplate) _then;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,
  ));
}
/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BannerTemplate].
extension BannerTemplatePatterns on BannerTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerTemplate value)  $default,){
final _that = this;
switch (_that) {
case _BannerTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  StudioDesignData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  StudioDesignData? data)  $default,) {final _that = this;
switch (_that) {
case _BannerTemplate():
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  StudioDesignData? data)?  $default,) {final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerTemplate extends BannerTemplate {
  const _BannerTemplate({required this.id, this.name = '', this.description, this.thumbnail, this.width = 1584, this.height = 396, this.data}): super._();
  factory _BannerTemplate.fromJson(Map<String, dynamic> json) => _$BannerTemplateFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override final  String? description;
@override final  String? thumbnail;
/// The authored size, as the row records it. The design's own canvas wins
/// when there is one — these are only the fallback for a row whose blob
/// did not come back.
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
@override final  StudioDesignData? data;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerTemplateCopyWith<_BannerTemplate> get copyWith => __$BannerTemplateCopyWithImpl<_BannerTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,data);

@override
String toString() {
  return 'BannerTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BannerTemplateCopyWith<$Res> implements $BannerTemplateCopyWith<$Res> {
  factory _$BannerTemplateCopyWith(_BannerTemplate value, $Res Function(_BannerTemplate) _then) = __$BannerTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, StudioDesignData? data
});


@override $StudioDesignDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$BannerTemplateCopyWithImpl<$Res>
    implements _$BannerTemplateCopyWith<$Res> {
  __$BannerTemplateCopyWithImpl(this._self, this._then);

  final _BannerTemplate _self;
  final $Res Function(_BannerTemplate) _then;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? data = freezed,}) {
  return _then(_BannerTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,
  ));
}

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
