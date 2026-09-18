// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudioTemplate {

 String get id; String get name; String? get description;/// A rendered preview. Null for a design that has never been saved from
/// the canvas — the tile then falls back to the size badge, as the web's
/// no-thumbnail branch does.
 String? get thumbnail; int get width; int get height; String? get category; bool get isPublic; bool get isTemplate;/// ISO-8601 as the server sent it. Kept as a string because nothing on
/// this screen does date arithmetic — it is shown, at most, as-is.
 String? get createdAt; String? get updatedAt;
/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioTemplateCopyWith<StudioTemplate> get copyWith => _$StudioTemplateCopyWithImpl<StudioTemplate>(this as StudioTemplate, _$identity);

  /// Serializes this StudioTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.category, category) || other.category == category)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,category,isPublic,isTemplate,createdAt,updatedAt);

@override
String toString() {
  return 'StudioTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, category: $category, isPublic: $isPublic, isTemplate: $isTemplate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudioTemplateCopyWith<$Res>  {
  factory $StudioTemplateCopyWith(StudioTemplate value, $Res Function(StudioTemplate) _then) = _$StudioTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, String? category, bool isPublic, bool isTemplate, String? createdAt, String? updatedAt
});




}
/// @nodoc
class _$StudioTemplateCopyWithImpl<$Res>
    implements $StudioTemplateCopyWith<$Res> {
  _$StudioTemplateCopyWithImpl(this._self, this._then);

  final StudioTemplate _self;
  final $Res Function(StudioTemplate) _then;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? category = freezed,Object? isPublic = null,Object? isTemplate = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioTemplate].
extension StudioTemplatePatterns on StudioTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioTemplate value)  $default,){
final _that = this;
switch (_that) {
case _StudioTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  String? category,  bool isPublic,  bool isTemplate,  String? createdAt,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.category,_that.isPublic,_that.isTemplate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  String? category,  bool isPublic,  bool isTemplate,  String? createdAt,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudioTemplate():
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.category,_that.isPublic,_that.isTemplate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  String? category,  bool isPublic,  bool isTemplate,  String? createdAt,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.category,_that.isPublic,_that.isTemplate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioTemplate extends StudioTemplate {
  const _StudioTemplate({required this.id, required this.name, this.description, this.thumbnail, this.width = 0, this.height = 0, this.category, this.isPublic = false, this.isTemplate = false, this.createdAt, this.updatedAt}): super._();
  factory _StudioTemplate.fromJson(Map<String, dynamic> json) => _$StudioTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
/// A rendered preview. Null for a design that has never been saved from
/// the canvas — the tile then falls back to the size badge, as the web's
/// no-thumbnail branch does.
@override final  String? thumbnail;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
@override final  String? category;
@override@JsonKey() final  bool isPublic;
@override@JsonKey() final  bool isTemplate;
/// ISO-8601 as the server sent it. Kept as a string because nothing on
/// this screen does date arithmetic — it is shown, at most, as-is.
@override final  String? createdAt;
@override final  String? updatedAt;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioTemplateCopyWith<_StudioTemplate> get copyWith => __$StudioTemplateCopyWithImpl<_StudioTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.category, category) || other.category == category)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,category,isPublic,isTemplate,createdAt,updatedAt);

@override
String toString() {
  return 'StudioTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, category: $category, isPublic: $isPublic, isTemplate: $isTemplate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudioTemplateCopyWith<$Res> implements $StudioTemplateCopyWith<$Res> {
  factory _$StudioTemplateCopyWith(_StudioTemplate value, $Res Function(_StudioTemplate) _then) = __$StudioTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, String? category, bool isPublic, bool isTemplate, String? createdAt, String? updatedAt
});




}
/// @nodoc
class __$StudioTemplateCopyWithImpl<$Res>
    implements _$StudioTemplateCopyWith<$Res> {
  __$StudioTemplateCopyWithImpl(this._self, this._then);

  final _StudioTemplate _self;
  final $Res Function(_StudioTemplate) _then;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? category = freezed,Object? isPublic = null,Object? isTemplate = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_StudioTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TemplateCopyState {

/// The template id currently being copied, if any.
 String? get copyingId;/// The design the last successful copy produced.
 StudioTemplate? get copied;/// The id of the template [copied] was made FROM.
///
/// Needed because the copy gets a fresh id: without it, opening a second
/// template's sheet after a successful copy would find `copied != null`
/// and show that template as already copied.
 String? get copiedFromId;/// Amber, never red — Zave has no red, and a failed copy is "needs
/// attention", not a destructive state.
 String? get error;
/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCopyStateCopyWith<TemplateCopyState> get copyWith => _$TemplateCopyStateCopyWithImpl<TemplateCopyState>(this as TemplateCopyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateCopyState&&(identical(other.copyingId, copyingId) || other.copyingId == copyingId)&&(identical(other.copied, copied) || other.copied == copied)&&(identical(other.copiedFromId, copiedFromId) || other.copiedFromId == copiedFromId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,copyingId,copied,copiedFromId,error);

@override
String toString() {
  return 'TemplateCopyState(copyingId: $copyingId, copied: $copied, copiedFromId: $copiedFromId, error: $error)';
}


}

/// @nodoc
abstract mixin class $TemplateCopyStateCopyWith<$Res>  {
  factory $TemplateCopyStateCopyWith(TemplateCopyState value, $Res Function(TemplateCopyState) _then) = _$TemplateCopyStateCopyWithImpl;
@useResult
$Res call({
 String? copyingId, StudioTemplate? copied, String? copiedFromId, String? error
});


$StudioTemplateCopyWith<$Res>? get copied;

}
/// @nodoc
class _$TemplateCopyStateCopyWithImpl<$Res>
    implements $TemplateCopyStateCopyWith<$Res> {
  _$TemplateCopyStateCopyWithImpl(this._self, this._then);

  final TemplateCopyState _self;
  final $Res Function(TemplateCopyState) _then;

/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? copyingId = freezed,Object? copied = freezed,Object? copiedFromId = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
copyingId: freezed == copyingId ? _self.copyingId : copyingId // ignore: cast_nullable_to_non_nullable
as String?,copied: freezed == copied ? _self.copied : copied // ignore: cast_nullable_to_non_nullable
as StudioTemplate?,copiedFromId: freezed == copiedFromId ? _self.copiedFromId : copiedFromId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioTemplateCopyWith<$Res>? get copied {
    if (_self.copied == null) {
    return null;
  }

  return $StudioTemplateCopyWith<$Res>(_self.copied!, (value) {
    return _then(_self.copyWith(copied: value));
  });
}
}


/// Adds pattern-matching-related methods to [TemplateCopyState].
extension TemplateCopyStatePatterns on TemplateCopyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateCopyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateCopyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateCopyState value)  $default,){
final _that = this;
switch (_that) {
case _TemplateCopyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateCopyState value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateCopyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? copyingId,  StudioTemplate? copied,  String? copiedFromId,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateCopyState() when $default != null:
return $default(_that.copyingId,_that.copied,_that.copiedFromId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? copyingId,  StudioTemplate? copied,  String? copiedFromId,  String? error)  $default,) {final _that = this;
switch (_that) {
case _TemplateCopyState():
return $default(_that.copyingId,_that.copied,_that.copiedFromId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? copyingId,  StudioTemplate? copied,  String? copiedFromId,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _TemplateCopyState() when $default != null:
return $default(_that.copyingId,_that.copied,_that.copiedFromId,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _TemplateCopyState extends TemplateCopyState {
  const _TemplateCopyState({this.copyingId, this.copied, this.copiedFromId, this.error}): super._();
  

/// The template id currently being copied, if any.
@override final  String? copyingId;
/// The design the last successful copy produced.
@override final  StudioTemplate? copied;
/// The id of the template [copied] was made FROM.
///
/// Needed because the copy gets a fresh id: without it, opening a second
/// template's sheet after a successful copy would find `copied != null`
/// and show that template as already copied.
@override final  String? copiedFromId;
/// Amber, never red — Zave has no red, and a failed copy is "needs
/// attention", not a destructive state.
@override final  String? error;

/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCopyStateCopyWith<_TemplateCopyState> get copyWith => __$TemplateCopyStateCopyWithImpl<_TemplateCopyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateCopyState&&(identical(other.copyingId, copyingId) || other.copyingId == copyingId)&&(identical(other.copied, copied) || other.copied == copied)&&(identical(other.copiedFromId, copiedFromId) || other.copiedFromId == copiedFromId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,copyingId,copied,copiedFromId,error);

@override
String toString() {
  return 'TemplateCopyState(copyingId: $copyingId, copied: $copied, copiedFromId: $copiedFromId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$TemplateCopyStateCopyWith<$Res> implements $TemplateCopyStateCopyWith<$Res> {
  factory _$TemplateCopyStateCopyWith(_TemplateCopyState value, $Res Function(_TemplateCopyState) _then) = __$TemplateCopyStateCopyWithImpl;
@override @useResult
$Res call({
 String? copyingId, StudioTemplate? copied, String? copiedFromId, String? error
});


@override $StudioTemplateCopyWith<$Res>? get copied;

}
/// @nodoc
class __$TemplateCopyStateCopyWithImpl<$Res>
    implements _$TemplateCopyStateCopyWith<$Res> {
  __$TemplateCopyStateCopyWithImpl(this._self, this._then);

  final _TemplateCopyState _self;
  final $Res Function(_TemplateCopyState) _then;

/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? copyingId = freezed,Object? copied = freezed,Object? copiedFromId = freezed,Object? error = freezed,}) {
  return _then(_TemplateCopyState(
copyingId: freezed == copyingId ? _self.copyingId : copyingId // ignore: cast_nullable_to_non_nullable
as String?,copied: freezed == copied ? _self.copied : copied // ignore: cast_nullable_to_non_nullable
as StudioTemplate?,copiedFromId: freezed == copiedFromId ? _self.copiedFromId : copiedFromId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TemplateCopyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioTemplateCopyWith<$Res>? get copied {
    if (_self.copied == null) {
    return null;
  }

  return $StudioTemplateCopyWith<$Res>(_self.copied!, (value) {
    return _then(_self.copyWith(copied: value));
  });
}
}

// dart format on
