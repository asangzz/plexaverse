// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_designer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiDesignerReply {

 String get message; StudioDesignData? get design; String get model;/// How many images the route actually generated. Non-zero means XP was
/// charged per image on top of the base cost, which the server states in
/// [message] when it had to strip them for affordability.
 int get imagesGenerated;
/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDesignerReplyCopyWith<AiDesignerReply> get copyWith => _$AiDesignerReplyCopyWithImpl<AiDesignerReply>(this as AiDesignerReply, _$identity);

  /// Serializes this AiDesignerReply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDesignerReply&&(identical(other.message, message) || other.message == message)&&(identical(other.design, design) || other.design == design)&&(identical(other.model, model) || other.model == model)&&(identical(other.imagesGenerated, imagesGenerated) || other.imagesGenerated == imagesGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,design,model,imagesGenerated);

@override
String toString() {
  return 'AiDesignerReply(message: $message, design: $design, model: $model, imagesGenerated: $imagesGenerated)';
}


}

/// @nodoc
abstract mixin class $AiDesignerReplyCopyWith<$Res>  {
  factory $AiDesignerReplyCopyWith(AiDesignerReply value, $Res Function(AiDesignerReply) _then) = _$AiDesignerReplyCopyWithImpl;
@useResult
$Res call({
 String message, StudioDesignData? design, String model, int imagesGenerated
});


$StudioDesignDataCopyWith<$Res>? get design;

}
/// @nodoc
class _$AiDesignerReplyCopyWithImpl<$Res>
    implements $AiDesignerReplyCopyWith<$Res> {
  _$AiDesignerReplyCopyWithImpl(this._self, this._then);

  final AiDesignerReply _self;
  final $Res Function(AiDesignerReply) _then;

/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? design = freezed,Object? model = null,Object? imagesGenerated = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,design: freezed == design ? _self.design : design // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,imagesGenerated: null == imagesGenerated ? _self.imagesGenerated : imagesGenerated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get design {
    if (_self.design == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.design!, (value) {
    return _then(_self.copyWith(design: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDesignerReply].
extension AiDesignerReplyPatterns on AiDesignerReply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDesignerReply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDesignerReply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDesignerReply value)  $default,){
final _that = this;
switch (_that) {
case _AiDesignerReply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDesignerReply value)?  $default,){
final _that = this;
switch (_that) {
case _AiDesignerReply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  StudioDesignData? design,  String model,  int imagesGenerated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDesignerReply() when $default != null:
return $default(_that.message,_that.design,_that.model,_that.imagesGenerated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  StudioDesignData? design,  String model,  int imagesGenerated)  $default,) {final _that = this;
switch (_that) {
case _AiDesignerReply():
return $default(_that.message,_that.design,_that.model,_that.imagesGenerated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  StudioDesignData? design,  String model,  int imagesGenerated)?  $default,) {final _that = this;
switch (_that) {
case _AiDesignerReply() when $default != null:
return $default(_that.message,_that.design,_that.model,_that.imagesGenerated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDesignerReply implements AiDesignerReply {
  const _AiDesignerReply({this.message = '', this.design, this.model = '', this.imagesGenerated = 0});
  factory _AiDesignerReply.fromJson(Map<String, dynamic> json) => _$AiDesignerReplyFromJson(json);

@override@JsonKey() final  String message;
@override final  StudioDesignData? design;
@override@JsonKey() final  String model;
/// How many images the route actually generated. Non-zero means XP was
/// charged per image on top of the base cost, which the server states in
/// [message] when it had to strip them for affordability.
@override@JsonKey() final  int imagesGenerated;

/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDesignerReplyCopyWith<_AiDesignerReply> get copyWith => __$AiDesignerReplyCopyWithImpl<_AiDesignerReply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDesignerReplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDesignerReply&&(identical(other.message, message) || other.message == message)&&(identical(other.design, design) || other.design == design)&&(identical(other.model, model) || other.model == model)&&(identical(other.imagesGenerated, imagesGenerated) || other.imagesGenerated == imagesGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,design,model,imagesGenerated);

@override
String toString() {
  return 'AiDesignerReply(message: $message, design: $design, model: $model, imagesGenerated: $imagesGenerated)';
}


}

/// @nodoc
abstract mixin class _$AiDesignerReplyCopyWith<$Res> implements $AiDesignerReplyCopyWith<$Res> {
  factory _$AiDesignerReplyCopyWith(_AiDesignerReply value, $Res Function(_AiDesignerReply) _then) = __$AiDesignerReplyCopyWithImpl;
@override @useResult
$Res call({
 String message, StudioDesignData? design, String model, int imagesGenerated
});


@override $StudioDesignDataCopyWith<$Res>? get design;

}
/// @nodoc
class __$AiDesignerReplyCopyWithImpl<$Res>
    implements _$AiDesignerReplyCopyWith<$Res> {
  __$AiDesignerReplyCopyWithImpl(this._self, this._then);

  final _AiDesignerReply _self;
  final $Res Function(_AiDesignerReply) _then;

/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? design = freezed,Object? model = null,Object? imagesGenerated = null,}) {
  return _then(_AiDesignerReply(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,design: freezed == design ? _self.design : design // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,imagesGenerated: null == imagesGenerated ? _self.imagesGenerated : imagesGenerated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AiDesignerReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get design {
    if (_self.design == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.design!, (value) {
    return _then(_self.copyWith(design: value));
  });
}
}

/// @nodoc
mixin _$AiDesignerTurn {

 String get id; AiDesignerRole get role; String get content;/// The design this assistant turn produced, if any.
 StudioDesignData? get design; bool get pending;/// Rendered in amber, not red — Zave has no red, and a failed turn is
/// "this needs your attention", not a destructive state.
 bool get failed;
/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDesignerTurnCopyWith<AiDesignerTurn> get copyWith => _$AiDesignerTurnCopyWithImpl<AiDesignerTurn>(this as AiDesignerTurn, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDesignerTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.design, design) || other.design == design)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,design,pending,failed);

@override
String toString() {
  return 'AiDesignerTurn(id: $id, role: $role, content: $content, design: $design, pending: $pending, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $AiDesignerTurnCopyWith<$Res>  {
  factory $AiDesignerTurnCopyWith(AiDesignerTurn value, $Res Function(AiDesignerTurn) _then) = _$AiDesignerTurnCopyWithImpl;
@useResult
$Res call({
 String id, AiDesignerRole role, String content, StudioDesignData? design, bool pending, bool failed
});


$StudioDesignDataCopyWith<$Res>? get design;

}
/// @nodoc
class _$AiDesignerTurnCopyWithImpl<$Res>
    implements $AiDesignerTurnCopyWith<$Res> {
  _$AiDesignerTurnCopyWithImpl(this._self, this._then);

  final AiDesignerTurn _self;
  final $Res Function(AiDesignerTurn) _then;

/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? design = freezed,Object? pending = null,Object? failed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiDesignerRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,design: freezed == design ? _self.design : design // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get design {
    if (_self.design == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.design!, (value) {
    return _then(_self.copyWith(design: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDesignerTurn].
extension AiDesignerTurnPatterns on AiDesignerTurn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDesignerTurn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDesignerTurn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDesignerTurn value)  $default,){
final _that = this;
switch (_that) {
case _AiDesignerTurn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDesignerTurn value)?  $default,){
final _that = this;
switch (_that) {
case _AiDesignerTurn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AiDesignerRole role,  String content,  StudioDesignData? design,  bool pending,  bool failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDesignerTurn() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.design,_that.pending,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AiDesignerRole role,  String content,  StudioDesignData? design,  bool pending,  bool failed)  $default,) {final _that = this;
switch (_that) {
case _AiDesignerTurn():
return $default(_that.id,_that.role,_that.content,_that.design,_that.pending,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AiDesignerRole role,  String content,  StudioDesignData? design,  bool pending,  bool failed)?  $default,) {final _that = this;
switch (_that) {
case _AiDesignerTurn() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.design,_that.pending,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _AiDesignerTurn extends AiDesignerTurn {
  const _AiDesignerTurn({required this.id, required this.role, this.content = '', this.design, this.pending = false, this.failed = false}): super._();
  

@override final  String id;
@override final  AiDesignerRole role;
@override@JsonKey() final  String content;
/// The design this assistant turn produced, if any.
@override final  StudioDesignData? design;
@override@JsonKey() final  bool pending;
/// Rendered in amber, not red — Zave has no red, and a failed turn is
/// "this needs your attention", not a destructive state.
@override@JsonKey() final  bool failed;

/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDesignerTurnCopyWith<_AiDesignerTurn> get copyWith => __$AiDesignerTurnCopyWithImpl<_AiDesignerTurn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDesignerTurn&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.design, design) || other.design == design)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,design,pending,failed);

@override
String toString() {
  return 'AiDesignerTurn(id: $id, role: $role, content: $content, design: $design, pending: $pending, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$AiDesignerTurnCopyWith<$Res> implements $AiDesignerTurnCopyWith<$Res> {
  factory _$AiDesignerTurnCopyWith(_AiDesignerTurn value, $Res Function(_AiDesignerTurn) _then) = __$AiDesignerTurnCopyWithImpl;
@override @useResult
$Res call({
 String id, AiDesignerRole role, String content, StudioDesignData? design, bool pending, bool failed
});


@override $StudioDesignDataCopyWith<$Res>? get design;

}
/// @nodoc
class __$AiDesignerTurnCopyWithImpl<$Res>
    implements _$AiDesignerTurnCopyWith<$Res> {
  __$AiDesignerTurnCopyWithImpl(this._self, this._then);

  final _AiDesignerTurn _self;
  final $Res Function(_AiDesignerTurn) _then;

/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? design = freezed,Object? pending = null,Object? failed = null,}) {
  return _then(_AiDesignerTurn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiDesignerRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,design: freezed == design ? _self.design : design // ignore: cast_nullable_to_non_nullable
as StudioDesignData?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AiDesignerTurn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudioDesignDataCopyWith<$Res>? get design {
    if (_self.design == null) {
    return null;
  }

  return $StudioDesignDataCopyWith<$Res>(_self.design!, (value) {
    return _then(_self.copyWith(design: value));
  });
}
}

// dart format on
