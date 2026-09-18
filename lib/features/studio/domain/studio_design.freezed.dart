// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_design.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudioAccess {

 bool get hasAccess;@JsonKey(name: 'currentXP') int get currentXp;@JsonKey(name: 'requiredXP') int get requiredXp;
/// Create a copy of StudioAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioAccessCopyWith<StudioAccess> get copyWith => _$StudioAccessCopyWithImpl<StudioAccess>(this as StudioAccess, _$identity);

  /// Serializes this StudioAccess to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioAccess&&(identical(other.hasAccess, hasAccess) || other.hasAccess == hasAccess)&&(identical(other.currentXp, currentXp) || other.currentXp == currentXp)&&(identical(other.requiredXp, requiredXp) || other.requiredXp == requiredXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasAccess,currentXp,requiredXp);

@override
String toString() {
  return 'StudioAccess(hasAccess: $hasAccess, currentXp: $currentXp, requiredXp: $requiredXp)';
}


}

/// @nodoc
abstract mixin class $StudioAccessCopyWith<$Res>  {
  factory $StudioAccessCopyWith(StudioAccess value, $Res Function(StudioAccess) _then) = _$StudioAccessCopyWithImpl;
@useResult
$Res call({
 bool hasAccess,@JsonKey(name: 'currentXP') int currentXp,@JsonKey(name: 'requiredXP') int requiredXp
});




}
/// @nodoc
class _$StudioAccessCopyWithImpl<$Res>
    implements $StudioAccessCopyWith<$Res> {
  _$StudioAccessCopyWithImpl(this._self, this._then);

  final StudioAccess _self;
  final $Res Function(StudioAccess) _then;

/// Create a copy of StudioAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasAccess = null,Object? currentXp = null,Object? requiredXp = null,}) {
  return _then(_self.copyWith(
hasAccess: null == hasAccess ? _self.hasAccess : hasAccess // ignore: cast_nullable_to_non_nullable
as bool,currentXp: null == currentXp ? _self.currentXp : currentXp // ignore: cast_nullable_to_non_nullable
as int,requiredXp: null == requiredXp ? _self.requiredXp : requiredXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioAccess].
extension StudioAccessPatterns on StudioAccess {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioAccess value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioAccess() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioAccess value)  $default,){
final _that = this;
switch (_that) {
case _StudioAccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioAccess value)?  $default,){
final _that = this;
switch (_that) {
case _StudioAccess() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasAccess, @JsonKey(name: 'currentXP')  int currentXp, @JsonKey(name: 'requiredXP')  int requiredXp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioAccess() when $default != null:
return $default(_that.hasAccess,_that.currentXp,_that.requiredXp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasAccess, @JsonKey(name: 'currentXP')  int currentXp, @JsonKey(name: 'requiredXP')  int requiredXp)  $default,) {final _that = this;
switch (_that) {
case _StudioAccess():
return $default(_that.hasAccess,_that.currentXp,_that.requiredXp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasAccess, @JsonKey(name: 'currentXP')  int currentXp, @JsonKey(name: 'requiredXP')  int requiredXp)?  $default,) {final _that = this;
switch (_that) {
case _StudioAccess() when $default != null:
return $default(_that.hasAccess,_that.currentXp,_that.requiredXp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioAccess extends StudioAccess {
  const _StudioAccess({this.hasAccess = false, @JsonKey(name: 'currentXP') this.currentXp = 0, @JsonKey(name: 'requiredXP') this.requiredXp = 0}): super._();
  factory _StudioAccess.fromJson(Map<String, dynamic> json) => _$StudioAccessFromJson(json);

@override@JsonKey() final  bool hasAccess;
@override@JsonKey(name: 'currentXP') final  int currentXp;
@override@JsonKey(name: 'requiredXP') final  int requiredXp;

/// Create a copy of StudioAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioAccessCopyWith<_StudioAccess> get copyWith => __$StudioAccessCopyWithImpl<_StudioAccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioAccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioAccess&&(identical(other.hasAccess, hasAccess) || other.hasAccess == hasAccess)&&(identical(other.currentXp, currentXp) || other.currentXp == currentXp)&&(identical(other.requiredXp, requiredXp) || other.requiredXp == requiredXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasAccess,currentXp,requiredXp);

@override
String toString() {
  return 'StudioAccess(hasAccess: $hasAccess, currentXp: $currentXp, requiredXp: $requiredXp)';
}


}

/// @nodoc
abstract mixin class _$StudioAccessCopyWith<$Res> implements $StudioAccessCopyWith<$Res> {
  factory _$StudioAccessCopyWith(_StudioAccess value, $Res Function(_StudioAccess) _then) = __$StudioAccessCopyWithImpl;
@override @useResult
$Res call({
 bool hasAccess,@JsonKey(name: 'currentXP') int currentXp,@JsonKey(name: 'requiredXP') int requiredXp
});




}
/// @nodoc
class __$StudioAccessCopyWithImpl<$Res>
    implements _$StudioAccessCopyWith<$Res> {
  __$StudioAccessCopyWithImpl(this._self, this._then);

  final _StudioAccess _self;
  final $Res Function(_StudioAccess) _then;

/// Create a copy of StudioAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasAccess = null,Object? currentXp = null,Object? requiredXp = null,}) {
  return _then(_StudioAccess(
hasAccess: null == hasAccess ? _self.hasAccess : hasAccess // ignore: cast_nullable_to_non_nullable
as bool,currentXp: null == currentXp ? _self.currentXp : currentXp // ignore: cast_nullable_to_non_nullable
as int,requiredXp: null == requiredXp ? _self.requiredXp : requiredXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StudioUnlockResult {

 bool get success; bool get alreadyUnlocked; int? get newBalance;
/// Create a copy of StudioUnlockResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioUnlockResultCopyWith<StudioUnlockResult> get copyWith => _$StudioUnlockResultCopyWithImpl<StudioUnlockResult>(this as StudioUnlockResult, _$identity);

  /// Serializes this StudioUnlockResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioUnlockResult&&(identical(other.success, success) || other.success == success)&&(identical(other.alreadyUnlocked, alreadyUnlocked) || other.alreadyUnlocked == alreadyUnlocked)&&(identical(other.newBalance, newBalance) || other.newBalance == newBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,alreadyUnlocked,newBalance);

@override
String toString() {
  return 'StudioUnlockResult(success: $success, alreadyUnlocked: $alreadyUnlocked, newBalance: $newBalance)';
}


}

/// @nodoc
abstract mixin class $StudioUnlockResultCopyWith<$Res>  {
  factory $StudioUnlockResultCopyWith(StudioUnlockResult value, $Res Function(StudioUnlockResult) _then) = _$StudioUnlockResultCopyWithImpl;
@useResult
$Res call({
 bool success, bool alreadyUnlocked, int? newBalance
});




}
/// @nodoc
class _$StudioUnlockResultCopyWithImpl<$Res>
    implements $StudioUnlockResultCopyWith<$Res> {
  _$StudioUnlockResultCopyWithImpl(this._self, this._then);

  final StudioUnlockResult _self;
  final $Res Function(StudioUnlockResult) _then;

/// Create a copy of StudioUnlockResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? alreadyUnlocked = null,Object? newBalance = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,alreadyUnlocked: null == alreadyUnlocked ? _self.alreadyUnlocked : alreadyUnlocked // ignore: cast_nullable_to_non_nullable
as bool,newBalance: freezed == newBalance ? _self.newBalance : newBalance // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioUnlockResult].
extension StudioUnlockResultPatterns on StudioUnlockResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioUnlockResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioUnlockResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioUnlockResult value)  $default,){
final _that = this;
switch (_that) {
case _StudioUnlockResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioUnlockResult value)?  $default,){
final _that = this;
switch (_that) {
case _StudioUnlockResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  bool alreadyUnlocked,  int? newBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioUnlockResult() when $default != null:
return $default(_that.success,_that.alreadyUnlocked,_that.newBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  bool alreadyUnlocked,  int? newBalance)  $default,) {final _that = this;
switch (_that) {
case _StudioUnlockResult():
return $default(_that.success,_that.alreadyUnlocked,_that.newBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  bool alreadyUnlocked,  int? newBalance)?  $default,) {final _that = this;
switch (_that) {
case _StudioUnlockResult() when $default != null:
return $default(_that.success,_that.alreadyUnlocked,_that.newBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioUnlockResult implements StudioUnlockResult {
  const _StudioUnlockResult({this.success = false, this.alreadyUnlocked = false, this.newBalance});
  factory _StudioUnlockResult.fromJson(Map<String, dynamic> json) => _$StudioUnlockResultFromJson(json);

@override@JsonKey() final  bool success;
@override@JsonKey() final  bool alreadyUnlocked;
@override final  int? newBalance;

/// Create a copy of StudioUnlockResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioUnlockResultCopyWith<_StudioUnlockResult> get copyWith => __$StudioUnlockResultCopyWithImpl<_StudioUnlockResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioUnlockResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioUnlockResult&&(identical(other.success, success) || other.success == success)&&(identical(other.alreadyUnlocked, alreadyUnlocked) || other.alreadyUnlocked == alreadyUnlocked)&&(identical(other.newBalance, newBalance) || other.newBalance == newBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,alreadyUnlocked,newBalance);

@override
String toString() {
  return 'StudioUnlockResult(success: $success, alreadyUnlocked: $alreadyUnlocked, newBalance: $newBalance)';
}


}

/// @nodoc
abstract mixin class _$StudioUnlockResultCopyWith<$Res> implements $StudioUnlockResultCopyWith<$Res> {
  factory _$StudioUnlockResultCopyWith(_StudioUnlockResult value, $Res Function(_StudioUnlockResult) _then) = __$StudioUnlockResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, bool alreadyUnlocked, int? newBalance
});




}
/// @nodoc
class __$StudioUnlockResultCopyWithImpl<$Res>
    implements _$StudioUnlockResultCopyWith<$Res> {
  __$StudioUnlockResultCopyWithImpl(this._self, this._then);

  final _StudioUnlockResult _self;
  final $Res Function(_StudioUnlockResult) _then;

/// Create a copy of StudioUnlockResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? alreadyUnlocked = null,Object? newBalance = freezed,}) {
  return _then(_StudioUnlockResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,alreadyUnlocked: null == alreadyUnlocked ? _self.alreadyUnlocked : alreadyUnlocked // ignore: cast_nullable_to_non_nullable
as bool,newBalance: freezed == newBalance ? _self.newBalance : newBalance // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$StudioCanvas {

 double get width; double get height; String get background;
/// Create a copy of StudioCanvas
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioCanvasCopyWith<StudioCanvas> get copyWith => _$StudioCanvasCopyWithImpl<StudioCanvas>(this as StudioCanvas, _$identity);

  /// Serializes this StudioCanvas to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioCanvas&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,background);

@override
String toString() {
  return 'StudioCanvas(width: $width, height: $height, background: $background)';
}


}

/// @nodoc
abstract mixin class $StudioCanvasCopyWith<$Res>  {
  factory $StudioCanvasCopyWith(StudioCanvas value, $Res Function(StudioCanvas) _then) = _$StudioCanvasCopyWithImpl;
@useResult
$Res call({
 double width, double height, String background
});




}
/// @nodoc
class _$StudioCanvasCopyWithImpl<$Res>
    implements $StudioCanvasCopyWith<$Res> {
  _$StudioCanvasCopyWithImpl(this._self, this._then);

  final StudioCanvas _self;
  final $Res Function(StudioCanvas) _then;

/// Create a copy of StudioCanvas
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? background = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioCanvas].
extension StudioCanvasPatterns on StudioCanvas {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioCanvas value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioCanvas() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioCanvas value)  $default,){
final _that = this;
switch (_that) {
case _StudioCanvas():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioCanvas value)?  $default,){
final _that = this;
switch (_that) {
case _StudioCanvas() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height,  String background)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioCanvas() when $default != null:
return $default(_that.width,_that.height,_that.background);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height,  String background)  $default,) {final _that = this;
switch (_that) {
case _StudioCanvas():
return $default(_that.width,_that.height,_that.background);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height,  String background)?  $default,) {final _that = this;
switch (_that) {
case _StudioCanvas() when $default != null:
return $default(_that.width,_that.height,_that.background);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioCanvas extends StudioCanvas {
  const _StudioCanvas({this.width = 1080.0, this.height = 1080.0, this.background = '#0a0a0a'}): super._();
  factory _StudioCanvas.fromJson(Map<String, dynamic> json) => _$StudioCanvasFromJson(json);

@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
@override@JsonKey() final  String background;

/// Create a copy of StudioCanvas
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioCanvasCopyWith<_StudioCanvas> get copyWith => __$StudioCanvasCopyWithImpl<_StudioCanvas>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioCanvasToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioCanvas&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,background);

@override
String toString() {
  return 'StudioCanvas(width: $width, height: $height, background: $background)';
}


}

/// @nodoc
abstract mixin class _$StudioCanvasCopyWith<$Res> implements $StudioCanvasCopyWith<$Res> {
  factory _$StudioCanvasCopyWith(_StudioCanvas value, $Res Function(_StudioCanvas) _then) = __$StudioCanvasCopyWithImpl;
@override @useResult
$Res call({
 double width, double height, String background
});




}
/// @nodoc
class __$StudioCanvasCopyWithImpl<$Res>
    implements _$StudioCanvasCopyWith<$Res> {
  __$StudioCanvasCopyWithImpl(this._self, this._then);

  final _StudioCanvas _self;
  final $Res Function(_StudioCanvas) _then;

/// Create a copy of StudioCanvas
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? background = null,}) {
  return _then(_StudioCanvas(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StudioElement {

 String get id;/// 'rectangle' | 'ellipse' | 'text' | 'image' | 'line' | 'group' | 'frame'.
 String get type; String get name; double get x; double get y; double get width; double get height;/// Degrees, clockwise, about the element's centre — the web applies
/// `transform: rotate(Ndeg)` with the default (centre) origin.
 double get rotation;/// A CSS colour string. For a text node this is the TEXT colour, not a
/// background — the web sets `color: element.fill` there.
 String get fill; String get stroke; double get strokeWidth; double get opacity; bool get visible; bool get locked; double? get borderRadius;// ── Text ───────────────────────────────────────────────────────────────
 String? get text; double? get fontSize; String? get fontFamily; int? get fontWeight;/// 'normal' | 'italic'.
 String? get fontStyle;/// 'left' | 'center' | 'right'.
 String? get textAlign; double? get lineHeight; double? get letterSpacing; bool get underline; bool get linethrough;/// 'none' | 'uppercase' | 'lowercase' | 'capitalize'.
 String? get textTransform;// ── Image ──────────────────────────────────────────────────────────────
/// An `https://` URL or a `data:image/…;base64,…` URI. The AI Designer
/// returns the latter inline, so both must render.
 String? get imageUrl;/// 'rectangle' | 'ellipse' | 'custom'.
 String? get maskShape; double? get maskBorderRadius;// ── Frame / group ──────────────────────────────────────────────────────
/// The web clips whenever this is not explicitly `false`, hence the
/// default of true rather than false.
 bool get clipContent;/// 'none' | 'horizontal' | 'vertical'.
 String? get layoutMode; double? get layoutGap; double? get layoutPadding;/// Children of a group or frame. Their x/y are **relative to this
/// element**, because the web nests their absolutely-positioned boxes
/// inside this one.
 List<StudioElement> get children;
/// Create a copy of StudioElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioElementCopyWith<StudioElement> get copyWith => _$StudioElementCopyWithImpl<StudioElement>(this as StudioElement, _$identity);

  /// Serializes this StudioElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioElement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.stroke, stroke) || other.stroke == stroke)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.text, text) || other.text == text)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.fontStyle, fontStyle) || other.fontStyle == fontStyle)&&(identical(other.textAlign, textAlign) || other.textAlign == textAlign)&&(identical(other.lineHeight, lineHeight) || other.lineHeight == lineHeight)&&(identical(other.letterSpacing, letterSpacing) || other.letterSpacing == letterSpacing)&&(identical(other.underline, underline) || other.underline == underline)&&(identical(other.linethrough, linethrough) || other.linethrough == linethrough)&&(identical(other.textTransform, textTransform) || other.textTransform == textTransform)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.maskShape, maskShape) || other.maskShape == maskShape)&&(identical(other.maskBorderRadius, maskBorderRadius) || other.maskBorderRadius == maskBorderRadius)&&(identical(other.clipContent, clipContent) || other.clipContent == clipContent)&&(identical(other.layoutMode, layoutMode) || other.layoutMode == layoutMode)&&(identical(other.layoutGap, layoutGap) || other.layoutGap == layoutGap)&&(identical(other.layoutPadding, layoutPadding) || other.layoutPadding == layoutPadding)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,name,x,y,width,height,rotation,fill,stroke,strokeWidth,opacity,visible,locked,borderRadius,text,fontSize,fontFamily,fontWeight,fontStyle,textAlign,lineHeight,letterSpacing,underline,linethrough,textTransform,imageUrl,maskShape,maskBorderRadius,clipContent,layoutMode,layoutGap,layoutPadding,const DeepCollectionEquality().hash(children)]);

@override
String toString() {
  return 'StudioElement(id: $id, type: $type, name: $name, x: $x, y: $y, width: $width, height: $height, rotation: $rotation, fill: $fill, stroke: $stroke, strokeWidth: $strokeWidth, opacity: $opacity, visible: $visible, locked: $locked, borderRadius: $borderRadius, text: $text, fontSize: $fontSize, fontFamily: $fontFamily, fontWeight: $fontWeight, fontStyle: $fontStyle, textAlign: $textAlign, lineHeight: $lineHeight, letterSpacing: $letterSpacing, underline: $underline, linethrough: $linethrough, textTransform: $textTransform, imageUrl: $imageUrl, maskShape: $maskShape, maskBorderRadius: $maskBorderRadius, clipContent: $clipContent, layoutMode: $layoutMode, layoutGap: $layoutGap, layoutPadding: $layoutPadding, children: $children)';
}


}

/// @nodoc
abstract mixin class $StudioElementCopyWith<$Res>  {
  factory $StudioElementCopyWith(StudioElement value, $Res Function(StudioElement) _then) = _$StudioElementCopyWithImpl;
@useResult
$Res call({
 String id, String type, String name, double x, double y, double width, double height, double rotation, String fill, String stroke, double strokeWidth, double opacity, bool visible, bool locked, double? borderRadius, String? text, double? fontSize, String? fontFamily, int? fontWeight, String? fontStyle, String? textAlign, double? lineHeight, double? letterSpacing, bool underline, bool linethrough, String? textTransform, String? imageUrl, String? maskShape, double? maskBorderRadius, bool clipContent, String? layoutMode, double? layoutGap, double? layoutPadding, List<StudioElement> children
});




}
/// @nodoc
class _$StudioElementCopyWithImpl<$Res>
    implements $StudioElementCopyWith<$Res> {
  _$StudioElementCopyWithImpl(this._self, this._then);

  final StudioElement _self;
  final $Res Function(StudioElement) _then;

/// Create a copy of StudioElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? rotation = null,Object? fill = null,Object? stroke = null,Object? strokeWidth = null,Object? opacity = null,Object? visible = null,Object? locked = null,Object? borderRadius = freezed,Object? text = freezed,Object? fontSize = freezed,Object? fontFamily = freezed,Object? fontWeight = freezed,Object? fontStyle = freezed,Object? textAlign = freezed,Object? lineHeight = freezed,Object? letterSpacing = freezed,Object? underline = null,Object? linethrough = null,Object? textTransform = freezed,Object? imageUrl = freezed,Object? maskShape = freezed,Object? maskBorderRadius = freezed,Object? clipContent = null,Object? layoutMode = freezed,Object? layoutGap = freezed,Object? layoutPadding = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,fill: null == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as String,stroke: null == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as String,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,fontSize: freezed == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,fontWeight: freezed == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int?,fontStyle: freezed == fontStyle ? _self.fontStyle : fontStyle // ignore: cast_nullable_to_non_nullable
as String?,textAlign: freezed == textAlign ? _self.textAlign : textAlign // ignore: cast_nullable_to_non_nullable
as String?,lineHeight: freezed == lineHeight ? _self.lineHeight : lineHeight // ignore: cast_nullable_to_non_nullable
as double?,letterSpacing: freezed == letterSpacing ? _self.letterSpacing : letterSpacing // ignore: cast_nullable_to_non_nullable
as double?,underline: null == underline ? _self.underline : underline // ignore: cast_nullable_to_non_nullable
as bool,linethrough: null == linethrough ? _self.linethrough : linethrough // ignore: cast_nullable_to_non_nullable
as bool,textTransform: freezed == textTransform ? _self.textTransform : textTransform // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,maskShape: freezed == maskShape ? _self.maskShape : maskShape // ignore: cast_nullable_to_non_nullable
as String?,maskBorderRadius: freezed == maskBorderRadius ? _self.maskBorderRadius : maskBorderRadius // ignore: cast_nullable_to_non_nullable
as double?,clipContent: null == clipContent ? _self.clipContent : clipContent // ignore: cast_nullable_to_non_nullable
as bool,layoutMode: freezed == layoutMode ? _self.layoutMode : layoutMode // ignore: cast_nullable_to_non_nullable
as String?,layoutGap: freezed == layoutGap ? _self.layoutGap : layoutGap // ignore: cast_nullable_to_non_nullable
as double?,layoutPadding: freezed == layoutPadding ? _self.layoutPadding : layoutPadding // ignore: cast_nullable_to_non_nullable
as double?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<StudioElement>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioElement].
extension StudioElementPatterns on StudioElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioElement value)  $default,){
final _that = this;
switch (_that) {
case _StudioElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioElement value)?  $default,){
final _that = this;
switch (_that) {
case _StudioElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  double rotation,  String fill,  String stroke,  double strokeWidth,  double opacity,  bool visible,  bool locked,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? fontStyle,  String? textAlign,  double? lineHeight,  double? letterSpacing,  bool underline,  bool linethrough,  String? textTransform,  String? imageUrl,  String? maskShape,  double? maskBorderRadius,  bool clipContent,  String? layoutMode,  double? layoutGap,  double? layoutPadding,  List<StudioElement> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioElement() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.fill,_that.stroke,_that.strokeWidth,_that.opacity,_that.visible,_that.locked,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.fontStyle,_that.textAlign,_that.lineHeight,_that.letterSpacing,_that.underline,_that.linethrough,_that.textTransform,_that.imageUrl,_that.maskShape,_that.maskBorderRadius,_that.clipContent,_that.layoutMode,_that.layoutGap,_that.layoutPadding,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  double rotation,  String fill,  String stroke,  double strokeWidth,  double opacity,  bool visible,  bool locked,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? fontStyle,  String? textAlign,  double? lineHeight,  double? letterSpacing,  bool underline,  bool linethrough,  String? textTransform,  String? imageUrl,  String? maskShape,  double? maskBorderRadius,  bool clipContent,  String? layoutMode,  double? layoutGap,  double? layoutPadding,  List<StudioElement> children)  $default,) {final _that = this;
switch (_that) {
case _StudioElement():
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.fill,_that.stroke,_that.strokeWidth,_that.opacity,_that.visible,_that.locked,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.fontStyle,_that.textAlign,_that.lineHeight,_that.letterSpacing,_that.underline,_that.linethrough,_that.textTransform,_that.imageUrl,_that.maskShape,_that.maskBorderRadius,_that.clipContent,_that.layoutMode,_that.layoutGap,_that.layoutPadding,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  double rotation,  String fill,  String stroke,  double strokeWidth,  double opacity,  bool visible,  bool locked,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? fontStyle,  String? textAlign,  double? lineHeight,  double? letterSpacing,  bool underline,  bool linethrough,  String? textTransform,  String? imageUrl,  String? maskShape,  double? maskBorderRadius,  bool clipContent,  String? layoutMode,  double? layoutGap,  double? layoutPadding,  List<StudioElement> children)?  $default,) {final _that = this;
switch (_that) {
case _StudioElement() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.fill,_that.stroke,_that.strokeWidth,_that.opacity,_that.visible,_that.locked,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.fontStyle,_that.textAlign,_that.lineHeight,_that.letterSpacing,_that.underline,_that.linethrough,_that.textTransform,_that.imageUrl,_that.maskShape,_that.maskBorderRadius,_that.clipContent,_that.layoutMode,_that.layoutGap,_that.layoutPadding,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioElement extends StudioElement {
  const _StudioElement({required this.id, this.type = 'rectangle', this.name = '', this.x = 0.0, this.y = 0.0, this.width = 0.0, this.height = 0.0, this.rotation = 0.0, this.fill = 'transparent', this.stroke = 'transparent', this.strokeWidth = 0.0, this.opacity = 1.0, this.visible = true, this.locked = false, this.borderRadius, this.text, this.fontSize, this.fontFamily, this.fontWeight, this.fontStyle, this.textAlign, this.lineHeight, this.letterSpacing, this.underline = false, this.linethrough = false, this.textTransform, this.imageUrl, this.maskShape, this.maskBorderRadius, this.clipContent = true, this.layoutMode, this.layoutGap, this.layoutPadding, final  List<StudioElement> children = const <StudioElement>[]}): _children = children,super._();
  factory _StudioElement.fromJson(Map<String, dynamic> json) => _$StudioElementFromJson(json);

@override final  String id;
/// 'rectangle' | 'ellipse' | 'text' | 'image' | 'line' | 'group' | 'frame'.
@override@JsonKey() final  String type;
@override@JsonKey() final  String name;
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
/// Degrees, clockwise, about the element's centre — the web applies
/// `transform: rotate(Ndeg)` with the default (centre) origin.
@override@JsonKey() final  double rotation;
/// A CSS colour string. For a text node this is the TEXT colour, not a
/// background — the web sets `color: element.fill` there.
@override@JsonKey() final  String fill;
@override@JsonKey() final  String stroke;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  double opacity;
@override@JsonKey() final  bool visible;
@override@JsonKey() final  bool locked;
@override final  double? borderRadius;
// ── Text ───────────────────────────────────────────────────────────────
@override final  String? text;
@override final  double? fontSize;
@override final  String? fontFamily;
@override final  int? fontWeight;
/// 'normal' | 'italic'.
@override final  String? fontStyle;
/// 'left' | 'center' | 'right'.
@override final  String? textAlign;
@override final  double? lineHeight;
@override final  double? letterSpacing;
@override@JsonKey() final  bool underline;
@override@JsonKey() final  bool linethrough;
/// 'none' | 'uppercase' | 'lowercase' | 'capitalize'.
@override final  String? textTransform;
// ── Image ──────────────────────────────────────────────────────────────
/// An `https://` URL or a `data:image/…;base64,…` URI. The AI Designer
/// returns the latter inline, so both must render.
@override final  String? imageUrl;
/// 'rectangle' | 'ellipse' | 'custom'.
@override final  String? maskShape;
@override final  double? maskBorderRadius;
// ── Frame / group ──────────────────────────────────────────────────────
/// The web clips whenever this is not explicitly `false`, hence the
/// default of true rather than false.
@override@JsonKey() final  bool clipContent;
/// 'none' | 'horizontal' | 'vertical'.
@override final  String? layoutMode;
@override final  double? layoutGap;
@override final  double? layoutPadding;
/// Children of a group or frame. Their x/y are **relative to this
/// element**, because the web nests their absolutely-positioned boxes
/// inside this one.
 final  List<StudioElement> _children;
/// Children of a group or frame. Their x/y are **relative to this
/// element**, because the web nests their absolutely-positioned boxes
/// inside this one.
@override@JsonKey() List<StudioElement> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of StudioElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioElementCopyWith<_StudioElement> get copyWith => __$StudioElementCopyWithImpl<_StudioElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioElement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.stroke, stroke) || other.stroke == stroke)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.text, text) || other.text == text)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.fontStyle, fontStyle) || other.fontStyle == fontStyle)&&(identical(other.textAlign, textAlign) || other.textAlign == textAlign)&&(identical(other.lineHeight, lineHeight) || other.lineHeight == lineHeight)&&(identical(other.letterSpacing, letterSpacing) || other.letterSpacing == letterSpacing)&&(identical(other.underline, underline) || other.underline == underline)&&(identical(other.linethrough, linethrough) || other.linethrough == linethrough)&&(identical(other.textTransform, textTransform) || other.textTransform == textTransform)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.maskShape, maskShape) || other.maskShape == maskShape)&&(identical(other.maskBorderRadius, maskBorderRadius) || other.maskBorderRadius == maskBorderRadius)&&(identical(other.clipContent, clipContent) || other.clipContent == clipContent)&&(identical(other.layoutMode, layoutMode) || other.layoutMode == layoutMode)&&(identical(other.layoutGap, layoutGap) || other.layoutGap == layoutGap)&&(identical(other.layoutPadding, layoutPadding) || other.layoutPadding == layoutPadding)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,name,x,y,width,height,rotation,fill,stroke,strokeWidth,opacity,visible,locked,borderRadius,text,fontSize,fontFamily,fontWeight,fontStyle,textAlign,lineHeight,letterSpacing,underline,linethrough,textTransform,imageUrl,maskShape,maskBorderRadius,clipContent,layoutMode,layoutGap,layoutPadding,const DeepCollectionEquality().hash(_children)]);

@override
String toString() {
  return 'StudioElement(id: $id, type: $type, name: $name, x: $x, y: $y, width: $width, height: $height, rotation: $rotation, fill: $fill, stroke: $stroke, strokeWidth: $strokeWidth, opacity: $opacity, visible: $visible, locked: $locked, borderRadius: $borderRadius, text: $text, fontSize: $fontSize, fontFamily: $fontFamily, fontWeight: $fontWeight, fontStyle: $fontStyle, textAlign: $textAlign, lineHeight: $lineHeight, letterSpacing: $letterSpacing, underline: $underline, linethrough: $linethrough, textTransform: $textTransform, imageUrl: $imageUrl, maskShape: $maskShape, maskBorderRadius: $maskBorderRadius, clipContent: $clipContent, layoutMode: $layoutMode, layoutGap: $layoutGap, layoutPadding: $layoutPadding, children: $children)';
}


}

/// @nodoc
abstract mixin class _$StudioElementCopyWith<$Res> implements $StudioElementCopyWith<$Res> {
  factory _$StudioElementCopyWith(_StudioElement value, $Res Function(_StudioElement) _then) = __$StudioElementCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String name, double x, double y, double width, double height, double rotation, String fill, String stroke, double strokeWidth, double opacity, bool visible, bool locked, double? borderRadius, String? text, double? fontSize, String? fontFamily, int? fontWeight, String? fontStyle, String? textAlign, double? lineHeight, double? letterSpacing, bool underline, bool linethrough, String? textTransform, String? imageUrl, String? maskShape, double? maskBorderRadius, bool clipContent, String? layoutMode, double? layoutGap, double? layoutPadding, List<StudioElement> children
});




}
/// @nodoc
class __$StudioElementCopyWithImpl<$Res>
    implements _$StudioElementCopyWith<$Res> {
  __$StudioElementCopyWithImpl(this._self, this._then);

  final _StudioElement _self;
  final $Res Function(_StudioElement) _then;

/// Create a copy of StudioElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? rotation = null,Object? fill = null,Object? stroke = null,Object? strokeWidth = null,Object? opacity = null,Object? visible = null,Object? locked = null,Object? borderRadius = freezed,Object? text = freezed,Object? fontSize = freezed,Object? fontFamily = freezed,Object? fontWeight = freezed,Object? fontStyle = freezed,Object? textAlign = freezed,Object? lineHeight = freezed,Object? letterSpacing = freezed,Object? underline = null,Object? linethrough = null,Object? textTransform = freezed,Object? imageUrl = freezed,Object? maskShape = freezed,Object? maskBorderRadius = freezed,Object? clipContent = null,Object? layoutMode = freezed,Object? layoutGap = freezed,Object? layoutPadding = freezed,Object? children = null,}) {
  return _then(_StudioElement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,fill: null == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as String,stroke: null == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as String,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,fontSize: freezed == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,fontWeight: freezed == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int?,fontStyle: freezed == fontStyle ? _self.fontStyle : fontStyle // ignore: cast_nullable_to_non_nullable
as String?,textAlign: freezed == textAlign ? _self.textAlign : textAlign // ignore: cast_nullable_to_non_nullable
as String?,lineHeight: freezed == lineHeight ? _self.lineHeight : lineHeight // ignore: cast_nullable_to_non_nullable
as double?,letterSpacing: freezed == letterSpacing ? _self.letterSpacing : letterSpacing // ignore: cast_nullable_to_non_nullable
as double?,underline: null == underline ? _self.underline : underline // ignore: cast_nullable_to_non_nullable
as bool,linethrough: null == linethrough ? _self.linethrough : linethrough // ignore: cast_nullable_to_non_nullable
as bool,textTransform: freezed == textTransform ? _self.textTransform : textTransform // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,maskShape: freezed == maskShape ? _self.maskShape : maskShape // ignore: cast_nullable_to_non_nullable
as String?,maskBorderRadius: freezed == maskBorderRadius ? _self.maskBorderRadius : maskBorderRadius // ignore: cast_nullable_to_non_nullable
as double?,clipContent: null == clipContent ? _self.clipContent : clipContent // ignore: cast_nullable_to_non_nullable
as bool,layoutMode: freezed == layoutMode ? _self.layoutMode : layoutMode // ignore: cast_nullable_to_non_nullable
as String?,layoutGap: freezed == layoutGap ? _self.layoutGap : layoutGap // ignore: cast_nullable_to_non_nullable
as double?,layoutPadding: freezed == layoutPadding ? _self.layoutPadding : layoutPadding // ignore: cast_nullable_to_non_nullable
as double?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<StudioElement>,
  ));
}


}

/// @nodoc
mixin _$StudioDesignData {

 int get version; StudioCanvas get canvas; List<StudioElement> get elements; List<String> get selectedIds;/// The verbatim `elements` array as the server sent it. Never rendered;
/// used only to rebuild the wire payload without losing unknown fields.
/// Excluded from JSON in both directions — it IS the JSON.
@JsonKey(includeFromJson: false, includeToJson: false) List<Map<String, dynamic>> get rawElements;
/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<StudioDesignData> get copyWith => _$StudioDesignDataCopyWithImpl<StudioDesignData>(this as StudioDesignData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioDesignData&&(identical(other.version, version) || other.version == version)&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other.elements, elements)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds)&&const DeepCollectionEquality().equals(other.rawElements, rawElements));
}


@override
int get hashCode => Object.hash(runtimeType,version,canvas,const DeepCollectionEquality().hash(elements),const DeepCollectionEquality().hash(selectedIds),const DeepCollectionEquality().hash(rawElements));

@override
String toString() {
  return 'StudioDesignData(version: $version, canvas: $canvas, elements: $elements, selectedIds: $selectedIds, rawElements: $rawElements)';
}


}

/// @nodoc
abstract mixin class $StudioDesignDataCopyWith<$Res>  {
  factory $StudioDesignDataCopyWith(StudioDesignData value, $Res Function(StudioDesignData) _then) = _$StudioDesignDataCopyWithImpl;
@useResult
$Res call({
 int version, StudioCanvas canvas, List<StudioElement> elements, List<String> selectedIds,@JsonKey(includeFromJson: false, includeToJson: false) List<Map<String, dynamic>> rawElements
});


$StudioCanvasCopyWith<$Res> get canvas;

}
/// @nodoc
class _$StudioDesignDataCopyWithImpl<$Res>
    implements $StudioDesignDataCopyWith<$Res> {
  _$StudioDesignDataCopyWithImpl(this._self, this._then);

  final StudioDesignData _self;
  final $Res Function(StudioDesignData) _then;

/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? canvas = null,Object? elements = null,Object? selectedIds = null,Object? rawElements = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,canvas: null == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as StudioCanvas,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<StudioElement>,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,rawElements: null == rawElements ? _self.rawElements : rawElements // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}
/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioCanvasCopyWith<$Res> get canvas {
  
  return $StudioCanvasCopyWith<$Res>(_self.canvas, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudioDesignData].
extension StudioDesignDataPatterns on StudioDesignData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioDesignData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioDesignData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioDesignData value)  $default,){
final _that = this;
switch (_that) {
case _StudioDesignData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioDesignData value)?  $default,){
final _that = this;
switch (_that) {
case _StudioDesignData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  StudioCanvas canvas,  List<StudioElement> elements,  List<String> selectedIds, @JsonKey(includeFromJson: false, includeToJson: false)  List<Map<String, dynamic>> rawElements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioDesignData() when $default != null:
return $default(_that.version,_that.canvas,_that.elements,_that.selectedIds,_that.rawElements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  StudioCanvas canvas,  List<StudioElement> elements,  List<String> selectedIds, @JsonKey(includeFromJson: false, includeToJson: false)  List<Map<String, dynamic>> rawElements)  $default,) {final _that = this;
switch (_that) {
case _StudioDesignData():
return $default(_that.version,_that.canvas,_that.elements,_that.selectedIds,_that.rawElements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  StudioCanvas canvas,  List<StudioElement> elements,  List<String> selectedIds, @JsonKey(includeFromJson: false, includeToJson: false)  List<Map<String, dynamic>> rawElements)?  $default,) {final _that = this;
switch (_that) {
case _StudioDesignData() when $default != null:
return $default(_that.version,_that.canvas,_that.elements,_that.selectedIds,_that.rawElements);case _:
  return null;

}
}

}

/// @nodoc


class _StudioDesignData extends StudioDesignData {
  const _StudioDesignData({this.version = 1, this.canvas = const StudioCanvas(), final  List<StudioElement> elements = const <StudioElement>[], final  List<String> selectedIds = const <String>[], @JsonKey(includeFromJson: false, includeToJson: false) final  List<Map<String, dynamic>> rawElements = const <Map<String, dynamic>>[]}): _elements = elements,_selectedIds = selectedIds,_rawElements = rawElements,super._();
  

@override@JsonKey() final  int version;
@override@JsonKey() final  StudioCanvas canvas;
 final  List<StudioElement> _elements;
@override@JsonKey() List<StudioElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}

 final  List<String> _selectedIds;
@override@JsonKey() List<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableListView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedIds);
}

/// The verbatim `elements` array as the server sent it. Never rendered;
/// used only to rebuild the wire payload without losing unknown fields.
/// Excluded from JSON in both directions — it IS the JSON.
 final  List<Map<String, dynamic>> _rawElements;
/// The verbatim `elements` array as the server sent it. Never rendered;
/// used only to rebuild the wire payload without losing unknown fields.
/// Excluded from JSON in both directions — it IS the JSON.
@override@JsonKey(includeFromJson: false, includeToJson: false) List<Map<String, dynamic>> get rawElements {
  if (_rawElements is EqualUnmodifiableListView) return _rawElements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rawElements);
}


/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioDesignDataCopyWith<_StudioDesignData> get copyWith => __$StudioDesignDataCopyWithImpl<_StudioDesignData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioDesignData&&(identical(other.version, version) || other.version == version)&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other._elements, _elements)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&const DeepCollectionEquality().equals(other._rawElements, _rawElements));
}


@override
int get hashCode => Object.hash(runtimeType,version,canvas,const DeepCollectionEquality().hash(_elements),const DeepCollectionEquality().hash(_selectedIds),const DeepCollectionEquality().hash(_rawElements));

@override
String toString() {
  return 'StudioDesignData(version: $version, canvas: $canvas, elements: $elements, selectedIds: $selectedIds, rawElements: $rawElements)';
}


}

/// @nodoc
abstract mixin class _$StudioDesignDataCopyWith<$Res> implements $StudioDesignDataCopyWith<$Res> {
  factory _$StudioDesignDataCopyWith(_StudioDesignData value, $Res Function(_StudioDesignData) _then) = __$StudioDesignDataCopyWithImpl;
@override @useResult
$Res call({
 int version, StudioCanvas canvas, List<StudioElement> elements, List<String> selectedIds,@JsonKey(includeFromJson: false, includeToJson: false) List<Map<String, dynamic>> rawElements
});


@override $StudioCanvasCopyWith<$Res> get canvas;

}
/// @nodoc
class __$StudioDesignDataCopyWithImpl<$Res>
    implements _$StudioDesignDataCopyWith<$Res> {
  __$StudioDesignDataCopyWithImpl(this._self, this._then);

  final _StudioDesignData _self;
  final $Res Function(_StudioDesignData) _then;

/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? canvas = null,Object? elements = null,Object? selectedIds = null,Object? rawElements = null,}) {
  return _then(_StudioDesignData(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,canvas: null == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as StudioCanvas,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<StudioElement>,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,rawElements: null == rawElements ? _self._rawElements : rawElements // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

/// Create a copy of StudioDesignData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioCanvasCopyWith<$Res> get canvas {
  
  return $StudioCanvasCopyWith<$Res>(_self.canvas, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}
}


/// @nodoc
mixin _$StudioDesign {

 String get id; String get name; String? get description;/// A data-URI or URL snapshot, saved by the web editor. Absent for
/// designs that have never been opened there.
 String? get thumbnail; int get width; int get height; bool get isPublic; bool get isTemplate; String? get category;/// ISO-8601, as Prisma serialises it. Kept as a string and parsed
/// leniently at the point of display — a date that fails to parse must
/// cost a caption, not the whole list.
 String? get createdAt; String? get updatedAt;/// Null on a list row; present after a single-design fetch.
 StudioDesignData? get data;
/// Create a copy of StudioDesign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioDesignCopyWith<StudioDesign> get copyWith => _$StudioDesignCopyWithImpl<StudioDesign>(this as StudioDesign, _$identity);

  /// Serializes this StudioDesign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioDesign&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,isPublic,isTemplate,category,createdAt,updatedAt,data);

@override
String toString() {
  return 'StudioDesign(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, isPublic: $isPublic, isTemplate: $isTemplate, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, data: $data)';
}


}

/// @nodoc
abstract mixin class $StudioDesignCopyWith<$Res>  {
  factory $StudioDesignCopyWith(StudioDesign value, $Res Function(StudioDesign) _then) = _$StudioDesignCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, bool isPublic, bool isTemplate, String? category, String? createdAt, String? updatedAt, StudioDesignData? data
});


$StudioDesignDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$StudioDesignCopyWithImpl<$Res>
    implements $StudioDesignCopyWith<$Res> {
  _$StudioDesignCopyWithImpl(this._self, this._then);

  final StudioDesign _self;
  final $Res Function(StudioDesign) _then;

/// Create a copy of StudioDesign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? isPublic = null,Object? isTemplate = null,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,
  ));
}
/// Create a copy of StudioDesign
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


/// Adds pattern-matching-related methods to [StudioDesign].
extension StudioDesignPatterns on StudioDesign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioDesign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioDesign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioDesign value)  $default,){
final _that = this;
switch (_that) {
case _StudioDesign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioDesign value)?  $default,){
final _that = this;
switch (_that) {
case _StudioDesign() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  bool isPublic,  bool isTemplate,  String? category,  String? createdAt,  String? updatedAt,  StudioDesignData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioDesign() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.isPublic,_that.isTemplate,_that.category,_that.createdAt,_that.updatedAt,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  bool isPublic,  bool isTemplate,  String? category,  String? createdAt,  String? updatedAt,  StudioDesignData? data)  $default,) {final _that = this;
switch (_that) {
case _StudioDesign():
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.isPublic,_that.isTemplate,_that.category,_that.createdAt,_that.updatedAt,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  bool isPublic,  bool isTemplate,  String? category,  String? createdAt,  String? updatedAt,  StudioDesignData? data)?  $default,) {final _that = this;
switch (_that) {
case _StudioDesign() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.isPublic,_that.isTemplate,_that.category,_that.createdAt,_that.updatedAt,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioDesign extends StudioDesign {
  const _StudioDesign({required this.id, this.name = 'Untitled', this.description, this.thumbnail, this.width = 1080, this.height = 1080, this.isPublic = false, this.isTemplate = false, this.category, this.createdAt, this.updatedAt, this.data}): super._();
  factory _StudioDesign.fromJson(Map<String, dynamic> json) => _$StudioDesignFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override final  String? description;
/// A data-URI or URL snapshot, saved by the web editor. Absent for
/// designs that have never been opened there.
@override final  String? thumbnail;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
@override@JsonKey() final  bool isPublic;
@override@JsonKey() final  bool isTemplate;
@override final  String? category;
/// ISO-8601, as Prisma serialises it. Kept as a string and parsed
/// leniently at the point of display — a date that fails to parse must
/// cost a caption, not the whole list.
@override final  String? createdAt;
@override final  String? updatedAt;
/// Null on a list row; present after a single-design fetch.
@override final  StudioDesignData? data;

/// Create a copy of StudioDesign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioDesignCopyWith<_StudioDesign> get copyWith => __$StudioDesignCopyWithImpl<_StudioDesign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioDesignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioDesign&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,isPublic,isTemplate,category,createdAt,updatedAt,data);

@override
String toString() {
  return 'StudioDesign(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, isPublic: $isPublic, isTemplate: $isTemplate, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, data: $data)';
}


}

/// @nodoc
abstract mixin class _$StudioDesignCopyWith<$Res> implements $StudioDesignCopyWith<$Res> {
  factory _$StudioDesignCopyWith(_StudioDesign value, $Res Function(_StudioDesign) _then) = __$StudioDesignCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, bool isPublic, bool isTemplate, String? category, String? createdAt, String? updatedAt, StudioDesignData? data
});


@override $StudioDesignDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$StudioDesignCopyWithImpl<$Res>
    implements _$StudioDesignCopyWith<$Res> {
  __$StudioDesignCopyWithImpl(this._self, this._then);

  final _StudioDesign _self;
  final $Res Function(_StudioDesign) _then;

/// Create a copy of StudioDesign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? isPublic = null,Object? isTemplate = null,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? data = freezed,}) {
  return _then(_StudioDesign(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,
  ));
}

/// Create a copy of StudioDesign
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
