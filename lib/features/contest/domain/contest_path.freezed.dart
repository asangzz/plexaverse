// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NodePart {

 int get index; int get total; int? get start; int? get end;
/// Create a copy of NodePart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodePartCopyWith<NodePart> get copyWith => _$NodePartCopyWithImpl<NodePart>(this as NodePart, _$identity);

  /// Serializes this NodePart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodePart&&(identical(other.index, index) || other.index == index)&&(identical(other.total, total) || other.total == total)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,total,start,end);

@override
String toString() {
  return 'NodePart(index: $index, total: $total, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $NodePartCopyWith<$Res>  {
  factory $NodePartCopyWith(NodePart value, $Res Function(NodePart) _then) = _$NodePartCopyWithImpl;
@useResult
$Res call({
 int index, int total, int? start, int? end
});




}
/// @nodoc
class _$NodePartCopyWithImpl<$Res>
    implements $NodePartCopyWith<$Res> {
  _$NodePartCopyWithImpl(this._self, this._then);

  final NodePart _self;
  final $Res Function(NodePart) _then;

/// Create a copy of NodePart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? total = null,Object? start = freezed,Object? end = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NodePart].
extension NodePartPatterns on NodePart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NodePart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NodePart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NodePart value)  $default,){
final _that = this;
switch (_that) {
case _NodePart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NodePart value)?  $default,){
final _that = this;
switch (_that) {
case _NodePart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  int total,  int? start,  int? end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NodePart() when $default != null:
return $default(_that.index,_that.total,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  int total,  int? start,  int? end)  $default,) {final _that = this;
switch (_that) {
case _NodePart():
return $default(_that.index,_that.total,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  int total,  int? start,  int? end)?  $default,) {final _that = this;
switch (_that) {
case _NodePart() when $default != null:
return $default(_that.index,_that.total,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NodePart implements NodePart {
  const _NodePart({this.index = 1, this.total = 1, this.start, this.end});
  factory _NodePart.fromJson(Map<String, dynamic> json) => _$NodePartFromJson(json);

@override@JsonKey() final  int index;
@override@JsonKey() final  int total;
@override final  int? start;
@override final  int? end;

/// Create a copy of NodePart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodePartCopyWith<_NodePart> get copyWith => __$NodePartCopyWithImpl<_NodePart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodePartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NodePart&&(identical(other.index, index) || other.index == index)&&(identical(other.total, total) || other.total == total)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,total,start,end);

@override
String toString() {
  return 'NodePart(index: $index, total: $total, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$NodePartCopyWith<$Res> implements $NodePartCopyWith<$Res> {
  factory _$NodePartCopyWith(_NodePart value, $Res Function(_NodePart) _then) = __$NodePartCopyWithImpl;
@override @useResult
$Res call({
 int index, int total, int? start, int? end
});




}
/// @nodoc
class __$NodePartCopyWithImpl<$Res>
    implements _$NodePartCopyWith<$Res> {
  __$NodePartCopyWithImpl(this._self, this._then);

  final _NodePart _self;
  final $Res Function(_NodePart) _then;

/// Create a copy of NodePart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? total = null,Object? start = freezed,Object? end = freezed,}) {
  return _then(_NodePart(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$NodeClaim {

@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind get kind;/// Opaque. Sent back unchanged with the link — `"<week>:<journey>"` for
/// the article and `"<week>:<journey>:<day>"` for a video today, but the
/// shape is the server's to change.
 String get occurrence;
/// Create a copy of NodeClaim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeClaimCopyWith<NodeClaim> get copyWith => _$NodeClaimCopyWithImpl<NodeClaim>(this as NodeClaim, _$identity);

  /// Serializes this NodeClaim to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodeClaim&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurrence, occurrence) || other.occurrence == occurrence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,occurrence);

@override
String toString() {
  return 'NodeClaim(kind: $kind, occurrence: $occurrence)';
}


}

/// @nodoc
abstract mixin class $NodeClaimCopyWith<$Res>  {
  factory $NodeClaimCopyWith(NodeClaim value, $Res Function(NodeClaim) _then) = _$NodeClaimCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind kind, String occurrence
});




}
/// @nodoc
class _$NodeClaimCopyWithImpl<$Res>
    implements $NodeClaimCopyWith<$Res> {
  _$NodeClaimCopyWithImpl(this._self, this._then);

  final NodeClaim _self;
  final $Res Function(NodeClaim) _then;

/// Create a copy of NodeClaim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? occurrence = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ClaimKind,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NodeClaim].
extension NodeClaimPatterns on NodeClaim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NodeClaim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NodeClaim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NodeClaim value)  $default,){
final _that = this;
switch (_that) {
case _NodeClaim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NodeClaim value)?  $default,){
final _that = this;
switch (_that) {
case _NodeClaim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NodeClaim() when $default != null:
return $default(_that.kind,_that.occurrence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence)  $default,) {final _that = this;
switch (_that) {
case _NodeClaim():
return $default(_that.kind,_that.occurrence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence)?  $default,) {final _that = this;
switch (_that) {
case _NodeClaim() when $default != null:
return $default(_that.kind,_that.occurrence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NodeClaim implements NodeClaim {
  const _NodeClaim({@JsonKey(unknownEnumValue: ClaimKind.unknown) this.kind = ClaimKind.unknown, this.occurrence = ''});
  factory _NodeClaim.fromJson(Map<String, dynamic> json) => _$NodeClaimFromJson(json);

@override@JsonKey(unknownEnumValue: ClaimKind.unknown) final  ClaimKind kind;
/// Opaque. Sent back unchanged with the link — `"<week>:<journey>"` for
/// the article and `"<week>:<journey>:<day>"` for a video today, but the
/// shape is the server's to change.
@override@JsonKey() final  String occurrence;

/// Create a copy of NodeClaim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeClaimCopyWith<_NodeClaim> get copyWith => __$NodeClaimCopyWithImpl<_NodeClaim>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodeClaimToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NodeClaim&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurrence, occurrence) || other.occurrence == occurrence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,occurrence);

@override
String toString() {
  return 'NodeClaim(kind: $kind, occurrence: $occurrence)';
}


}

/// @nodoc
abstract mixin class _$NodeClaimCopyWith<$Res> implements $NodeClaimCopyWith<$Res> {
  factory _$NodeClaimCopyWith(_NodeClaim value, $Res Function(_NodeClaim) _then) = __$NodeClaimCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind kind, String occurrence
});




}
/// @nodoc
class __$NodeClaimCopyWithImpl<$Res>
    implements _$NodeClaimCopyWith<$Res> {
  __$NodeClaimCopyWithImpl(this._self, this._then);

  final _NodeClaim _self;
  final $Res Function(_NodeClaim) _then;

/// Create a copy of NodeClaim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? occurrence = null,}) {
  return _then(_NodeClaim(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ClaimKind,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PathNode {

/// Opaque and stable within the path: `<day>:lesson:<k>`, `<day>:<kind>`,
/// and `<day>:<kind>:<occurrence>` for a claim.
 String get id;@JsonKey(unknownEnumValue: PathNodeKind.unknown) PathNodeKind get kind;/// Forced to [PathNodeState.locked] for an [PathNodeKind.unknown] kind,
/// whatever the server said — see [PathNodeKind.unknown].
@JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked) PathNodeState get state;/// The server's copy: "Lesson · part 2 of 3", "Comment on a top voice".
 String get title;/// A promise while the level is open, a receipt once it is closed — what
/// it pays, still could pay, or did pay. Never recomputed here.
 int get points;/// Null when there is nothing to open. A WEB path — see the class doc.
@JsonKey(readValue: _hrefUnlessUnknown) String? get href;/// One line: "5 questions", "2 of 5 answered", "Unlocks after Lesson part
/// 3 of 3", "Rejected: …", "Removed: … — −80 XP".
 String? get detail;/// Today's work already part done (some of the day's feed comments
/// sent): the button says Continue, and [points] is what is left.
 bool get started;/// Lesson nodes only.
 NodePart? get part;/// Claim nodes only.
 NodeClaim? get claim;/// The one level Skip may be pressed on: today's open level (the gate's
/// first node still holding the chain, in state today or rejected). On at
/// most one node, and absent everywhere else. Forced false for an
/// [PathNodeKind.unknown] kind — a level this build cannot open is not
/// one to pass over either.
@JsonKey(readValue: _canSkipUnlessUnknown) bool get canSkip;
/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathNodeCopyWith<PathNode> get copyWith => _$PathNodeCopyWithImpl<PathNode>(this as PathNode, _$identity);

  /// Serializes this PathNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathNode&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.title, title) || other.title == title)&&(identical(other.points, points) || other.points == points)&&(identical(other.href, href) || other.href == href)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.started, started) || other.started == started)&&(identical(other.part, part) || other.part == part)&&(identical(other.claim, claim) || other.claim == claim)&&(identical(other.canSkip, canSkip) || other.canSkip == canSkip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,state,title,points,href,detail,started,part,claim,canSkip);

@override
String toString() {
  return 'PathNode(id: $id, kind: $kind, state: $state, title: $title, points: $points, href: $href, detail: $detail, started: $started, part: $part, claim: $claim, canSkip: $canSkip)';
}


}

/// @nodoc
abstract mixin class $PathNodeCopyWith<$Res>  {
  factory $PathNodeCopyWith(PathNode value, $Res Function(PathNode) _then) = _$PathNodeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PathNodeKind.unknown) PathNodeKind kind,@JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked) PathNodeState state, String title, int points,@JsonKey(readValue: _hrefUnlessUnknown) String? href, String? detail, bool started, NodePart? part, NodeClaim? claim,@JsonKey(readValue: _canSkipUnlessUnknown) bool canSkip
});


$NodePartCopyWith<$Res>? get part;$NodeClaimCopyWith<$Res>? get claim;

}
/// @nodoc
class _$PathNodeCopyWithImpl<$Res>
    implements $PathNodeCopyWith<$Res> {
  _$PathNodeCopyWithImpl(this._self, this._then);

  final PathNode _self;
  final $Res Function(PathNode) _then;

/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? state = null,Object? title = null,Object? points = null,Object? href = freezed,Object? detail = freezed,Object? started = null,Object? part = freezed,Object? claim = freezed,Object? canSkip = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PathNodeKind,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PathNodeState,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as NodePart?,claim: freezed == claim ? _self.claim : claim // ignore: cast_nullable_to_non_nullable
as NodeClaim?,canSkip: null == canSkip ? _self.canSkip : canSkip // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodePartCopyWith<$Res>? get part {
    if (_self.part == null) {
    return null;
  }

  return $NodePartCopyWith<$Res>(_self.part!, (value) {
    return _then(_self.copyWith(part: value));
  });
}/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodeClaimCopyWith<$Res>? get claim {
    if (_self.claim == null) {
    return null;
  }

  return $NodeClaimCopyWith<$Res>(_self.claim!, (value) {
    return _then(_self.copyWith(claim: value));
  });
}
}


/// Adds pattern-matching-related methods to [PathNode].
extension PathNodePatterns on PathNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathNode value)  $default,){
final _that = this;
switch (_that) {
case _PathNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathNode value)?  $default,){
final _that = this;
switch (_that) {
case _PathNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PathNodeKind.unknown)  PathNodeKind kind, @JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked)  PathNodeState state,  String title,  int points, @JsonKey(readValue: _hrefUnlessUnknown)  String? href,  String? detail,  bool started,  NodePart? part,  NodeClaim? claim, @JsonKey(readValue: _canSkipUnlessUnknown)  bool canSkip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathNode() when $default != null:
return $default(_that.id,_that.kind,_that.state,_that.title,_that.points,_that.href,_that.detail,_that.started,_that.part,_that.claim,_that.canSkip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PathNodeKind.unknown)  PathNodeKind kind, @JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked)  PathNodeState state,  String title,  int points, @JsonKey(readValue: _hrefUnlessUnknown)  String? href,  String? detail,  bool started,  NodePart? part,  NodeClaim? claim, @JsonKey(readValue: _canSkipUnlessUnknown)  bool canSkip)  $default,) {final _that = this;
switch (_that) {
case _PathNode():
return $default(_that.id,_that.kind,_that.state,_that.title,_that.points,_that.href,_that.detail,_that.started,_that.part,_that.claim,_that.canSkip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: PathNodeKind.unknown)  PathNodeKind kind, @JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked)  PathNodeState state,  String title,  int points, @JsonKey(readValue: _hrefUnlessUnknown)  String? href,  String? detail,  bool started,  NodePart? part,  NodeClaim? claim, @JsonKey(readValue: _canSkipUnlessUnknown)  bool canSkip)?  $default,) {final _that = this;
switch (_that) {
case _PathNode() when $default != null:
return $default(_that.id,_that.kind,_that.state,_that.title,_that.points,_that.href,_that.detail,_that.started,_that.part,_that.claim,_that.canSkip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathNode extends PathNode {
  const _PathNode({this.id = '', @JsonKey(unknownEnumValue: PathNodeKind.unknown) this.kind = PathNodeKind.unknown, @JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked) this.state = PathNodeState.locked, this.title = '', this.points = 0, @JsonKey(readValue: _hrefUnlessUnknown) this.href, this.detail, this.started = false, this.part, this.claim, @JsonKey(readValue: _canSkipUnlessUnknown) this.canSkip = false}): super._();
  factory _PathNode.fromJson(Map<String, dynamic> json) => _$PathNodeFromJson(json);

/// Opaque and stable within the path: `<day>:lesson:<k>`, `<day>:<kind>`,
/// and `<day>:<kind>:<occurrence>` for a claim.
@override@JsonKey() final  String id;
@override@JsonKey(unknownEnumValue: PathNodeKind.unknown) final  PathNodeKind kind;
/// Forced to [PathNodeState.locked] for an [PathNodeKind.unknown] kind,
/// whatever the server said — see [PathNodeKind.unknown].
@override@JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked) final  PathNodeState state;
/// The server's copy: "Lesson · part 2 of 3", "Comment on a top voice".
@override@JsonKey() final  String title;
/// A promise while the level is open, a receipt once it is closed — what
/// it pays, still could pay, or did pay. Never recomputed here.
@override@JsonKey() final  int points;
/// Null when there is nothing to open. A WEB path — see the class doc.
@override@JsonKey(readValue: _hrefUnlessUnknown) final  String? href;
/// One line: "5 questions", "2 of 5 answered", "Unlocks after Lesson part
/// 3 of 3", "Rejected: …", "Removed: … — −80 XP".
@override final  String? detail;
/// Today's work already part done (some of the day's feed comments
/// sent): the button says Continue, and [points] is what is left.
@override@JsonKey() final  bool started;
/// Lesson nodes only.
@override final  NodePart? part;
/// Claim nodes only.
@override final  NodeClaim? claim;
/// The one level Skip may be pressed on: today's open level (the gate's
/// first node still holding the chain, in state today or rejected). On at
/// most one node, and absent everywhere else. Forced false for an
/// [PathNodeKind.unknown] kind — a level this build cannot open is not
/// one to pass over either.
@override@JsonKey(readValue: _canSkipUnlessUnknown) final  bool canSkip;

/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathNodeCopyWith<_PathNode> get copyWith => __$PathNodeCopyWithImpl<_PathNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathNode&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.title, title) || other.title == title)&&(identical(other.points, points) || other.points == points)&&(identical(other.href, href) || other.href == href)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.started, started) || other.started == started)&&(identical(other.part, part) || other.part == part)&&(identical(other.claim, claim) || other.claim == claim)&&(identical(other.canSkip, canSkip) || other.canSkip == canSkip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,state,title,points,href,detail,started,part,claim,canSkip);

@override
String toString() {
  return 'PathNode(id: $id, kind: $kind, state: $state, title: $title, points: $points, href: $href, detail: $detail, started: $started, part: $part, claim: $claim, canSkip: $canSkip)';
}


}

/// @nodoc
abstract mixin class _$PathNodeCopyWith<$Res> implements $PathNodeCopyWith<$Res> {
  factory _$PathNodeCopyWith(_PathNode value, $Res Function(_PathNode) _then) = __$PathNodeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PathNodeKind.unknown) PathNodeKind kind,@JsonKey(readValue: _stateUnlessUnknown, unknownEnumValue: PathNodeState.locked) PathNodeState state, String title, int points,@JsonKey(readValue: _hrefUnlessUnknown) String? href, String? detail, bool started, NodePart? part, NodeClaim? claim,@JsonKey(readValue: _canSkipUnlessUnknown) bool canSkip
});


@override $NodePartCopyWith<$Res>? get part;@override $NodeClaimCopyWith<$Res>? get claim;

}
/// @nodoc
class __$PathNodeCopyWithImpl<$Res>
    implements _$PathNodeCopyWith<$Res> {
  __$PathNodeCopyWithImpl(this._self, this._then);

  final _PathNode _self;
  final $Res Function(_PathNode) _then;

/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? state = null,Object? title = null,Object? points = null,Object? href = freezed,Object? detail = freezed,Object? started = null,Object? part = freezed,Object? claim = freezed,Object? canSkip = null,}) {
  return _then(_PathNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PathNodeKind,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PathNodeState,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,part: freezed == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as NodePart?,claim: freezed == claim ? _self.claim : claim // ignore: cast_nullable_to_non_nullable
as NodeClaim?,canSkip: null == canSkip ? _self.canSkip : canSkip // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodePartCopyWith<$Res>? get part {
    if (_self.part == null) {
    return null;
  }

  return $NodePartCopyWith<$Res>(_self.part!, (value) {
    return _then(_self.copyWith(part: value));
  });
}/// Create a copy of PathNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodeClaimCopyWith<$Res>? get claim {
    if (_self.claim == null) {
    return null;
  }

  return $NodeClaimCopyWith<$Res>(_self.claim!, (value) {
    return _then(_self.copyWith(claim: value));
  });
}
}


/// @nodoc
mixin _$PathDay {

 int get dayNumber;/// `YYYY-MM-DD` in the CONTEST's timezone. Read as a calendar date; a
/// weekday computed from the device's clock can be a day off.
 String get dayKey;/// 0 = Sunday … 6 = Saturday, from the server.
 int get weekday; bool get isToday; List<PathNode> get nodes;
/// Create a copy of PathDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathDayCopyWith<PathDay> get copyWith => _$PathDayCopyWithImpl<PathDay>(this as PathDay, _$identity);

  /// Serializes this PathDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathDay&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.isToday, isToday) || other.isToday == isToday)&&const DeepCollectionEquality().equals(other.nodes, nodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayNumber,dayKey,weekday,isToday,const DeepCollectionEquality().hash(nodes));

@override
String toString() {
  return 'PathDay(dayNumber: $dayNumber, dayKey: $dayKey, weekday: $weekday, isToday: $isToday, nodes: $nodes)';
}


}

/// @nodoc
abstract mixin class $PathDayCopyWith<$Res>  {
  factory $PathDayCopyWith(PathDay value, $Res Function(PathDay) _then) = _$PathDayCopyWithImpl;
@useResult
$Res call({
 int dayNumber, String dayKey, int weekday, bool isToday, List<PathNode> nodes
});




}
/// @nodoc
class _$PathDayCopyWithImpl<$Res>
    implements $PathDayCopyWith<$Res> {
  _$PathDayCopyWithImpl(this._self, this._then);

  final PathDay _self;
  final $Res Function(PathDay) _then;

/// Create a copy of PathDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayNumber = null,Object? dayKey = null,Object? weekday = null,Object? isToday = null,Object? nodes = null,}) {
  return _then(_self.copyWith(
dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,isToday: null == isToday ? _self.isToday : isToday // ignore: cast_nullable_to_non_nullable
as bool,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<PathNode>,
  ));
}

}


/// Adds pattern-matching-related methods to [PathDay].
extension PathDayPatterns on PathDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathDay value)  $default,){
final _that = this;
switch (_that) {
case _PathDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathDay value)?  $default,){
final _that = this;
switch (_that) {
case _PathDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayNumber,  String dayKey,  int weekday,  bool isToday,  List<PathNode> nodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathDay() when $default != null:
return $default(_that.dayNumber,_that.dayKey,_that.weekday,_that.isToday,_that.nodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayNumber,  String dayKey,  int weekday,  bool isToday,  List<PathNode> nodes)  $default,) {final _that = this;
switch (_that) {
case _PathDay():
return $default(_that.dayNumber,_that.dayKey,_that.weekday,_that.isToday,_that.nodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayNumber,  String dayKey,  int weekday,  bool isToday,  List<PathNode> nodes)?  $default,) {final _that = this;
switch (_that) {
case _PathDay() when $default != null:
return $default(_that.dayNumber,_that.dayKey,_that.weekday,_that.isToday,_that.nodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathDay implements PathDay {
  const _PathDay({this.dayNumber = 0, this.dayKey = '', this.weekday = 0, this.isToday = false, final  List<PathNode> nodes = const <PathNode>[]}): _nodes = nodes;
  factory _PathDay.fromJson(Map<String, dynamic> json) => _$PathDayFromJson(json);

@override@JsonKey() final  int dayNumber;
/// `YYYY-MM-DD` in the CONTEST's timezone. Read as a calendar date; a
/// weekday computed from the device's clock can be a day off.
@override@JsonKey() final  String dayKey;
/// 0 = Sunday … 6 = Saturday, from the server.
@override@JsonKey() final  int weekday;
@override@JsonKey() final  bool isToday;
 final  List<PathNode> _nodes;
@override@JsonKey() List<PathNode> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}


/// Create a copy of PathDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathDayCopyWith<_PathDay> get copyWith => __$PathDayCopyWithImpl<_PathDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathDay&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.isToday, isToday) || other.isToday == isToday)&&const DeepCollectionEquality().equals(other._nodes, _nodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayNumber,dayKey,weekday,isToday,const DeepCollectionEquality().hash(_nodes));

@override
String toString() {
  return 'PathDay(dayNumber: $dayNumber, dayKey: $dayKey, weekday: $weekday, isToday: $isToday, nodes: $nodes)';
}


}

/// @nodoc
abstract mixin class _$PathDayCopyWith<$Res> implements $PathDayCopyWith<$Res> {
  factory _$PathDayCopyWith(_PathDay value, $Res Function(_PathDay) _then) = __$PathDayCopyWithImpl;
@override @useResult
$Res call({
 int dayNumber, String dayKey, int weekday, bool isToday, List<PathNode> nodes
});




}
/// @nodoc
class __$PathDayCopyWithImpl<$Res>
    implements _$PathDayCopyWith<$Res> {
  __$PathDayCopyWithImpl(this._self, this._then);

  final _PathDay _self;
  final $Res Function(_PathDay) _then;

/// Create a copy of PathDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayNumber = null,Object? dayKey = null,Object? weekday = null,Object? isToday = null,Object? nodes = null,}) {
  return _then(_PathDay(
dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,isToday: null == isToday ? _self.isToday : isToday // ignore: cast_nullable_to_non_nullable
as bool,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<PathNode>,
  ));
}


}


/// @nodoc
mixin _$PostClaim {

@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind get kind;/// Sent back unchanged with the link.
 String get occurrence; String get title;/// The planner day it goes out, in the USER's timezone (the planner's),
/// not the contest's — which is why a user outside India can see it a
/// day early. Null when unknown.
 String? get postingDayKey;/// The first day a link is accepted: the posting day itself.
 String? get opensOnKey;/// An unknown status reads as not ready: nothing to share yet.
@JsonKey(unknownEnumValue: ClaimStatus.notReady) ClaimStatus get status;/// The link sent, normalised by the server. Null until one is.
 String? get postUrl;/// What an approval pays.
 int get points; String? get rejectReason;
/// Create a copy of PostClaim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostClaimCopyWith<PostClaim> get copyWith => _$PostClaimCopyWithImpl<PostClaim>(this as PostClaim, _$identity);

  /// Serializes this PostClaim to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostClaim&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurrence, occurrence) || other.occurrence == occurrence)&&(identical(other.title, title) || other.title == title)&&(identical(other.postingDayKey, postingDayKey) || other.postingDayKey == postingDayKey)&&(identical(other.opensOnKey, opensOnKey) || other.opensOnKey == opensOnKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.points, points) || other.points == points)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,occurrence,title,postingDayKey,opensOnKey,status,postUrl,points,rejectReason);

@override
String toString() {
  return 'PostClaim(kind: $kind, occurrence: $occurrence, title: $title, postingDayKey: $postingDayKey, opensOnKey: $opensOnKey, status: $status, postUrl: $postUrl, points: $points, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class $PostClaimCopyWith<$Res>  {
  factory $PostClaimCopyWith(PostClaim value, $Res Function(PostClaim) _then) = _$PostClaimCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind kind, String occurrence, String title, String? postingDayKey, String? opensOnKey,@JsonKey(unknownEnumValue: ClaimStatus.notReady) ClaimStatus status, String? postUrl, int points, String? rejectReason
});




}
/// @nodoc
class _$PostClaimCopyWithImpl<$Res>
    implements $PostClaimCopyWith<$Res> {
  _$PostClaimCopyWithImpl(this._self, this._then);

  final PostClaim _self;
  final $Res Function(PostClaim) _then;

/// Create a copy of PostClaim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? occurrence = null,Object? title = null,Object? postingDayKey = freezed,Object? opensOnKey = freezed,Object? status = null,Object? postUrl = freezed,Object? points = null,Object? rejectReason = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ClaimKind,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postingDayKey: freezed == postingDayKey ? _self.postingDayKey : postingDayKey // ignore: cast_nullable_to_non_nullable
as String?,opensOnKey: freezed == opensOnKey ? _self.opensOnKey : opensOnKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,postUrl: freezed == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostClaim].
extension PostClaimPatterns on PostClaim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostClaim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostClaim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostClaim value)  $default,){
final _that = this;
switch (_that) {
case _PostClaim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostClaim value)?  $default,){
final _that = this;
switch (_that) {
case _PostClaim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence,  String title,  String? postingDayKey,  String? opensOnKey, @JsonKey(unknownEnumValue: ClaimStatus.notReady)  ClaimStatus status,  String? postUrl,  int points,  String? rejectReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostClaim() when $default != null:
return $default(_that.kind,_that.occurrence,_that.title,_that.postingDayKey,_that.opensOnKey,_that.status,_that.postUrl,_that.points,_that.rejectReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence,  String title,  String? postingDayKey,  String? opensOnKey, @JsonKey(unknownEnumValue: ClaimStatus.notReady)  ClaimStatus status,  String? postUrl,  int points,  String? rejectReason)  $default,) {final _that = this;
switch (_that) {
case _PostClaim():
return $default(_that.kind,_that.occurrence,_that.title,_that.postingDayKey,_that.opensOnKey,_that.status,_that.postUrl,_that.points,_that.rejectReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ClaimKind.unknown)  ClaimKind kind,  String occurrence,  String title,  String? postingDayKey,  String? opensOnKey, @JsonKey(unknownEnumValue: ClaimStatus.notReady)  ClaimStatus status,  String? postUrl,  int points,  String? rejectReason)?  $default,) {final _that = this;
switch (_that) {
case _PostClaim() when $default != null:
return $default(_that.kind,_that.occurrence,_that.title,_that.postingDayKey,_that.opensOnKey,_that.status,_that.postUrl,_that.points,_that.rejectReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostClaim extends PostClaim {
  const _PostClaim({@JsonKey(unknownEnumValue: ClaimKind.unknown) this.kind = ClaimKind.unknown, this.occurrence = '', this.title = '', this.postingDayKey, this.opensOnKey, @JsonKey(unknownEnumValue: ClaimStatus.notReady) this.status = ClaimStatus.notReady, this.postUrl, this.points = 0, this.rejectReason}): super._();
  factory _PostClaim.fromJson(Map<String, dynamic> json) => _$PostClaimFromJson(json);

@override@JsonKey(unknownEnumValue: ClaimKind.unknown) final  ClaimKind kind;
/// Sent back unchanged with the link.
@override@JsonKey() final  String occurrence;
@override@JsonKey() final  String title;
/// The planner day it goes out, in the USER's timezone (the planner's),
/// not the contest's — which is why a user outside India can see it a
/// day early. Null when unknown.
@override final  String? postingDayKey;
/// The first day a link is accepted: the posting day itself.
@override final  String? opensOnKey;
/// An unknown status reads as not ready: nothing to share yet.
@override@JsonKey(unknownEnumValue: ClaimStatus.notReady) final  ClaimStatus status;
/// The link sent, normalised by the server. Null until one is.
@override final  String? postUrl;
/// What an approval pays.
@override@JsonKey() final  int points;
@override final  String? rejectReason;

/// Create a copy of PostClaim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostClaimCopyWith<_PostClaim> get copyWith => __$PostClaimCopyWithImpl<_PostClaim>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostClaimToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostClaim&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurrence, occurrence) || other.occurrence == occurrence)&&(identical(other.title, title) || other.title == title)&&(identical(other.postingDayKey, postingDayKey) || other.postingDayKey == postingDayKey)&&(identical(other.opensOnKey, opensOnKey) || other.opensOnKey == opensOnKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.points, points) || other.points == points)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,occurrence,title,postingDayKey,opensOnKey,status,postUrl,points,rejectReason);

@override
String toString() {
  return 'PostClaim(kind: $kind, occurrence: $occurrence, title: $title, postingDayKey: $postingDayKey, opensOnKey: $opensOnKey, status: $status, postUrl: $postUrl, points: $points, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class _$PostClaimCopyWith<$Res> implements $PostClaimCopyWith<$Res> {
  factory _$PostClaimCopyWith(_PostClaim value, $Res Function(_PostClaim) _then) = __$PostClaimCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ClaimKind.unknown) ClaimKind kind, String occurrence, String title, String? postingDayKey, String? opensOnKey,@JsonKey(unknownEnumValue: ClaimStatus.notReady) ClaimStatus status, String? postUrl, int points, String? rejectReason
});




}
/// @nodoc
class __$PostClaimCopyWithImpl<$Res>
    implements _$PostClaimCopyWith<$Res> {
  __$PostClaimCopyWithImpl(this._self, this._then);

  final _PostClaim _self;
  final $Res Function(_PostClaim) _then;

/// Create a copy of PostClaim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? occurrence = null,Object? title = null,Object? postingDayKey = freezed,Object? opensOnKey = freezed,Object? status = null,Object? postUrl = freezed,Object? points = null,Object? rejectReason = freezed,}) {
  return _then(_PostClaim(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ClaimKind,occurrence: null == occurrence ? _self.occurrence : occurrence // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postingDayKey: freezed == postingDayKey ? _self.postingDayKey : postingDayKey // ignore: cast_nullable_to_non_nullable
as String?,opensOnKey: freezed == opensOnKey ? _self.opensOnKey : opensOnKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,postUrl: freezed == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeedCommentsRule {

/// How many links the day asks for.
 int get perDay;/// What the five pay IN TOTAL.
 int get points;/// What a false claim costs on top of taking back what it paid.
 int get penalty;
/// Create a copy of FeedCommentsRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCommentsRuleCopyWith<FeedCommentsRule> get copyWith => _$FeedCommentsRuleCopyWithImpl<FeedCommentsRule>(this as FeedCommentsRule, _$identity);

  /// Serializes this FeedCommentsRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedCommentsRule&&(identical(other.perDay, perDay) || other.perDay == perDay)&&(identical(other.points, points) || other.points == points)&&(identical(other.penalty, penalty) || other.penalty == penalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,perDay,points,penalty);

@override
String toString() {
  return 'FeedCommentsRule(perDay: $perDay, points: $points, penalty: $penalty)';
}


}

/// @nodoc
abstract mixin class $FeedCommentsRuleCopyWith<$Res>  {
  factory $FeedCommentsRuleCopyWith(FeedCommentsRule value, $Res Function(FeedCommentsRule) _then) = _$FeedCommentsRuleCopyWithImpl;
@useResult
$Res call({
 int perDay, int points, int penalty
});




}
/// @nodoc
class _$FeedCommentsRuleCopyWithImpl<$Res>
    implements $FeedCommentsRuleCopyWith<$Res> {
  _$FeedCommentsRuleCopyWithImpl(this._self, this._then);

  final FeedCommentsRule _self;
  final $Res Function(FeedCommentsRule) _then;

/// Create a copy of FeedCommentsRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? perDay = null,Object? points = null,Object? penalty = null,}) {
  return _then(_self.copyWith(
perDay: null == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,penalty: null == penalty ? _self.penalty : penalty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedCommentsRule].
extension FeedCommentsRulePatterns on FeedCommentsRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedCommentsRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedCommentsRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedCommentsRule value)  $default,){
final _that = this;
switch (_that) {
case _FeedCommentsRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedCommentsRule value)?  $default,){
final _that = this;
switch (_that) {
case _FeedCommentsRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int perDay,  int points,  int penalty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedCommentsRule() when $default != null:
return $default(_that.perDay,_that.points,_that.penalty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int perDay,  int points,  int penalty)  $default,) {final _that = this;
switch (_that) {
case _FeedCommentsRule():
return $default(_that.perDay,_that.points,_that.penalty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int perDay,  int points,  int penalty)?  $default,) {final _that = this;
switch (_that) {
case _FeedCommentsRule() when $default != null:
return $default(_that.perDay,_that.points,_that.penalty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedCommentsRule implements FeedCommentsRule {
  const _FeedCommentsRule({this.perDay = 5, this.points = 0, this.penalty = 0});
  factory _FeedCommentsRule.fromJson(Map<String, dynamic> json) => _$FeedCommentsRuleFromJson(json);

/// How many links the day asks for.
@override@JsonKey() final  int perDay;
/// What the five pay IN TOTAL.
@override@JsonKey() final  int points;
/// What a false claim costs on top of taking back what it paid.
@override@JsonKey() final  int penalty;

/// Create a copy of FeedCommentsRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCommentsRuleCopyWith<_FeedCommentsRule> get copyWith => __$FeedCommentsRuleCopyWithImpl<_FeedCommentsRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedCommentsRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedCommentsRule&&(identical(other.perDay, perDay) || other.perDay == perDay)&&(identical(other.points, points) || other.points == points)&&(identical(other.penalty, penalty) || other.penalty == penalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,perDay,points,penalty);

@override
String toString() {
  return 'FeedCommentsRule(perDay: $perDay, points: $points, penalty: $penalty)';
}


}

/// @nodoc
abstract mixin class _$FeedCommentsRuleCopyWith<$Res> implements $FeedCommentsRuleCopyWith<$Res> {
  factory _$FeedCommentsRuleCopyWith(_FeedCommentsRule value, $Res Function(_FeedCommentsRule) _then) = __$FeedCommentsRuleCopyWithImpl;
@override @useResult
$Res call({
 int perDay, int points, int penalty
});




}
/// @nodoc
class __$FeedCommentsRuleCopyWithImpl<$Res>
    implements _$FeedCommentsRuleCopyWith<$Res> {
  __$FeedCommentsRuleCopyWithImpl(this._self, this._then);

  final _FeedCommentsRule _self;
  final $Res Function(_FeedCommentsRule) _then;

/// Create a copy of FeedCommentsRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? perDay = null,Object? points = null,Object? penalty = null,}) {
  return _then(_FeedCommentsRule(
perDay: null == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,penalty: null == penalty ? _self.penalty : penalty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeekReward {

/// What the week pays (the contest's rule).
 int get points;/// Every lesson the week asks for is finished.
 bool get earned;/// What the ledger paid; null when not earned, or earned while scoring
/// was paused.
 int? get paid;/// A day the week asked for went unfinished: it can no longer be earned.
 bool get missedDay;
/// Create a copy of WeekReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekRewardCopyWith<WeekReward> get copyWith => _$WeekRewardCopyWithImpl<WeekReward>(this as WeekReward, _$identity);

  /// Serializes this WeekReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekReward&&(identical(other.points, points) || other.points == points)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.missedDay, missedDay) || other.missedDay == missedDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,earned,paid,missedDay);

@override
String toString() {
  return 'WeekReward(points: $points, earned: $earned, paid: $paid, missedDay: $missedDay)';
}


}

/// @nodoc
abstract mixin class $WeekRewardCopyWith<$Res>  {
  factory $WeekRewardCopyWith(WeekReward value, $Res Function(WeekReward) _then) = _$WeekRewardCopyWithImpl;
@useResult
$Res call({
 int points, bool earned, int? paid, bool missedDay
});




}
/// @nodoc
class _$WeekRewardCopyWithImpl<$Res>
    implements $WeekRewardCopyWith<$Res> {
  _$WeekRewardCopyWithImpl(this._self, this._then);

  final WeekReward _self;
  final $Res Function(WeekReward) _then;

/// Create a copy of WeekReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? earned = null,Object? paid = freezed,Object? missedDay = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,paid: freezed == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as int?,missedDay: null == missedDay ? _self.missedDay : missedDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekReward].
extension WeekRewardPatterns on WeekReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekReward value)  $default,){
final _that = this;
switch (_that) {
case _WeekReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekReward value)?  $default,){
final _that = this;
switch (_that) {
case _WeekReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points,  bool earned,  int? paid,  bool missedDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekReward() when $default != null:
return $default(_that.points,_that.earned,_that.paid,_that.missedDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points,  bool earned,  int? paid,  bool missedDay)  $default,) {final _that = this;
switch (_that) {
case _WeekReward():
return $default(_that.points,_that.earned,_that.paid,_that.missedDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points,  bool earned,  int? paid,  bool missedDay)?  $default,) {final _that = this;
switch (_that) {
case _WeekReward() when $default != null:
return $default(_that.points,_that.earned,_that.paid,_that.missedDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekReward implements WeekReward {
  const _WeekReward({this.points = 0, this.earned = false, this.paid, this.missedDay = false});
  factory _WeekReward.fromJson(Map<String, dynamic> json) => _$WeekRewardFromJson(json);

/// What the week pays (the contest's rule).
@override@JsonKey() final  int points;
/// Every lesson the week asks for is finished.
@override@JsonKey() final  bool earned;
/// What the ledger paid; null when not earned, or earned while scoring
/// was paused.
@override final  int? paid;
/// A day the week asked for went unfinished: it can no longer be earned.
@override@JsonKey() final  bool missedDay;

/// Create a copy of WeekReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekRewardCopyWith<_WeekReward> get copyWith => __$WeekRewardCopyWithImpl<_WeekReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekReward&&(identical(other.points, points) || other.points == points)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.missedDay, missedDay) || other.missedDay == missedDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,earned,paid,missedDay);

@override
String toString() {
  return 'WeekReward(points: $points, earned: $earned, paid: $paid, missedDay: $missedDay)';
}


}

/// @nodoc
abstract mixin class _$WeekRewardCopyWith<$Res> implements $WeekRewardCopyWith<$Res> {
  factory _$WeekRewardCopyWith(_WeekReward value, $Res Function(_WeekReward) _then) = __$WeekRewardCopyWithImpl;
@override @useResult
$Res call({
 int points, bool earned, int? paid, bool missedDay
});




}
/// @nodoc
class __$WeekRewardCopyWithImpl<$Res>
    implements _$WeekRewardCopyWith<$Res> {
  __$WeekRewardCopyWithImpl(this._self, this._then);

  final _WeekReward _self;
  final $Res Function(_WeekReward) _then;

/// Create a copy of WeekReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? earned = null,Object? paid = freezed,Object? missedDay = null,}) {
  return _then(_WeekReward(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,paid: freezed == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as int?,missedDay: null == missedDay ? _self.missedDay : missedDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ContestPath {

@JsonKey(unknownEnumValue: ContestPathStatus.noContest) ContestPathStatus get status; String? get contestId;/// Today's contest day (1 = the start date). Shown as "Day D" — never
/// beside [finalDay].
 int? get dayNumber;/// The last day's number. **Never rendered**: no "Day D of N".
 int? get finalDay;/// The contest week shown — 1 is the Sunday-to-Saturday week the contest
/// starts in. Shown as "Week W".
 int? get weekNumber;/// This calendar week, SUNDAY to Saturday in the contest's timezone,
/// clipped to the contest. Empty unless [status] is running.
 List<PathDay> get days;/// This planner week's article and videos, plus last week's still
/// unpaid ones. The week card lists claims from here, not from nodes.
 List<PostClaim> get claims; FeedCommentsRule? get feedComments; WeekReward? get weekReward;
/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestPathCopyWith<ContestPath> get copyWith => _$ContestPathCopyWithImpl<ContestPath>(this as ContestPath, _$identity);

  /// Serializes this ContestPath to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestPath&&(identical(other.status, status) || other.status == status)&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.finalDay, finalDay) || other.finalDay == finalDay)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&const DeepCollectionEquality().equals(other.days, days)&&const DeepCollectionEquality().equals(other.claims, claims)&&(identical(other.feedComments, feedComments) || other.feedComments == feedComments)&&(identical(other.weekReward, weekReward) || other.weekReward == weekReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,contestId,dayNumber,finalDay,weekNumber,const DeepCollectionEquality().hash(days),const DeepCollectionEquality().hash(claims),feedComments,weekReward);

@override
String toString() {
  return 'ContestPath(status: $status, contestId: $contestId, dayNumber: $dayNumber, finalDay: $finalDay, weekNumber: $weekNumber, days: $days, claims: $claims, feedComments: $feedComments, weekReward: $weekReward)';
}


}

/// @nodoc
abstract mixin class $ContestPathCopyWith<$Res>  {
  factory $ContestPathCopyWith(ContestPath value, $Res Function(ContestPath) _then) = _$ContestPathCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ContestPathStatus.noContest) ContestPathStatus status, String? contestId, int? dayNumber, int? finalDay, int? weekNumber, List<PathDay> days, List<PostClaim> claims, FeedCommentsRule? feedComments, WeekReward? weekReward
});


$FeedCommentsRuleCopyWith<$Res>? get feedComments;$WeekRewardCopyWith<$Res>? get weekReward;

}
/// @nodoc
class _$ContestPathCopyWithImpl<$Res>
    implements $ContestPathCopyWith<$Res> {
  _$ContestPathCopyWithImpl(this._self, this._then);

  final ContestPath _self;
  final $Res Function(ContestPath) _then;

/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? contestId = freezed,Object? dayNumber = freezed,Object? finalDay = freezed,Object? weekNumber = freezed,Object? days = null,Object? claims = null,Object? feedComments = freezed,Object? weekReward = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContestPathStatus,contestId: freezed == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String?,dayNumber: freezed == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int?,finalDay: freezed == finalDay ? _self.finalDay : finalDay // ignore: cast_nullable_to_non_nullable
as int?,weekNumber: freezed == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<PathDay>,claims: null == claims ? _self.claims : claims // ignore: cast_nullable_to_non_nullable
as List<PostClaim>,feedComments: freezed == feedComments ? _self.feedComments : feedComments // ignore: cast_nullable_to_non_nullable
as FeedCommentsRule?,weekReward: freezed == weekReward ? _self.weekReward : weekReward // ignore: cast_nullable_to_non_nullable
as WeekReward?,
  ));
}
/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCommentsRuleCopyWith<$Res>? get feedComments {
    if (_self.feedComments == null) {
    return null;
  }

  return $FeedCommentsRuleCopyWith<$Res>(_self.feedComments!, (value) {
    return _then(_self.copyWith(feedComments: value));
  });
}/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekRewardCopyWith<$Res>? get weekReward {
    if (_self.weekReward == null) {
    return null;
  }

  return $WeekRewardCopyWith<$Res>(_self.weekReward!, (value) {
    return _then(_self.copyWith(weekReward: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContestPath].
extension ContestPathPatterns on ContestPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestPath value)  $default,){
final _that = this;
switch (_that) {
case _ContestPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestPath value)?  $default,){
final _that = this;
switch (_that) {
case _ContestPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ContestPathStatus.noContest)  ContestPathStatus status,  String? contestId,  int? dayNumber,  int? finalDay,  int? weekNumber,  List<PathDay> days,  List<PostClaim> claims,  FeedCommentsRule? feedComments,  WeekReward? weekReward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestPath() when $default != null:
return $default(_that.status,_that.contestId,_that.dayNumber,_that.finalDay,_that.weekNumber,_that.days,_that.claims,_that.feedComments,_that.weekReward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ContestPathStatus.noContest)  ContestPathStatus status,  String? contestId,  int? dayNumber,  int? finalDay,  int? weekNumber,  List<PathDay> days,  List<PostClaim> claims,  FeedCommentsRule? feedComments,  WeekReward? weekReward)  $default,) {final _that = this;
switch (_that) {
case _ContestPath():
return $default(_that.status,_that.contestId,_that.dayNumber,_that.finalDay,_that.weekNumber,_that.days,_that.claims,_that.feedComments,_that.weekReward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ContestPathStatus.noContest)  ContestPathStatus status,  String? contestId,  int? dayNumber,  int? finalDay,  int? weekNumber,  List<PathDay> days,  List<PostClaim> claims,  FeedCommentsRule? feedComments,  WeekReward? weekReward)?  $default,) {final _that = this;
switch (_that) {
case _ContestPath() when $default != null:
return $default(_that.status,_that.contestId,_that.dayNumber,_that.finalDay,_that.weekNumber,_that.days,_that.claims,_that.feedComments,_that.weekReward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestPath extends ContestPath {
  const _ContestPath({@JsonKey(unknownEnumValue: ContestPathStatus.noContest) this.status = ContestPathStatus.noContest, this.contestId, this.dayNumber, this.finalDay, this.weekNumber, final  List<PathDay> days = const <PathDay>[], final  List<PostClaim> claims = const <PostClaim>[], this.feedComments, this.weekReward}): _days = days,_claims = claims,super._();
  factory _ContestPath.fromJson(Map<String, dynamic> json) => _$ContestPathFromJson(json);

@override@JsonKey(unknownEnumValue: ContestPathStatus.noContest) final  ContestPathStatus status;
@override final  String? contestId;
/// Today's contest day (1 = the start date). Shown as "Day D" — never
/// beside [finalDay].
@override final  int? dayNumber;
/// The last day's number. **Never rendered**: no "Day D of N".
@override final  int? finalDay;
/// The contest week shown — 1 is the Sunday-to-Saturday week the contest
/// starts in. Shown as "Week W".
@override final  int? weekNumber;
/// This calendar week, SUNDAY to Saturday in the contest's timezone,
/// clipped to the contest. Empty unless [status] is running.
 final  List<PathDay> _days;
/// This calendar week, SUNDAY to Saturday in the contest's timezone,
/// clipped to the contest. Empty unless [status] is running.
@override@JsonKey() List<PathDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

/// This planner week's article and videos, plus last week's still
/// unpaid ones. The week card lists claims from here, not from nodes.
 final  List<PostClaim> _claims;
/// This planner week's article and videos, plus last week's still
/// unpaid ones. The week card lists claims from here, not from nodes.
@override@JsonKey() List<PostClaim> get claims {
  if (_claims is EqualUnmodifiableListView) return _claims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_claims);
}

@override final  FeedCommentsRule? feedComments;
@override final  WeekReward? weekReward;

/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestPathCopyWith<_ContestPath> get copyWith => __$ContestPathCopyWithImpl<_ContestPath>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestPathToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestPath&&(identical(other.status, status) || other.status == status)&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.finalDay, finalDay) || other.finalDay == finalDay)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&const DeepCollectionEquality().equals(other._days, _days)&&const DeepCollectionEquality().equals(other._claims, _claims)&&(identical(other.feedComments, feedComments) || other.feedComments == feedComments)&&(identical(other.weekReward, weekReward) || other.weekReward == weekReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,contestId,dayNumber,finalDay,weekNumber,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_claims),feedComments,weekReward);

@override
String toString() {
  return 'ContestPath(status: $status, contestId: $contestId, dayNumber: $dayNumber, finalDay: $finalDay, weekNumber: $weekNumber, days: $days, claims: $claims, feedComments: $feedComments, weekReward: $weekReward)';
}


}

/// @nodoc
abstract mixin class _$ContestPathCopyWith<$Res> implements $ContestPathCopyWith<$Res> {
  factory _$ContestPathCopyWith(_ContestPath value, $Res Function(_ContestPath) _then) = __$ContestPathCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ContestPathStatus.noContest) ContestPathStatus status, String? contestId, int? dayNumber, int? finalDay, int? weekNumber, List<PathDay> days, List<PostClaim> claims, FeedCommentsRule? feedComments, WeekReward? weekReward
});


@override $FeedCommentsRuleCopyWith<$Res>? get feedComments;@override $WeekRewardCopyWith<$Res>? get weekReward;

}
/// @nodoc
class __$ContestPathCopyWithImpl<$Res>
    implements _$ContestPathCopyWith<$Res> {
  __$ContestPathCopyWithImpl(this._self, this._then);

  final _ContestPath _self;
  final $Res Function(_ContestPath) _then;

/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? contestId = freezed,Object? dayNumber = freezed,Object? finalDay = freezed,Object? weekNumber = freezed,Object? days = null,Object? claims = null,Object? feedComments = freezed,Object? weekReward = freezed,}) {
  return _then(_ContestPath(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContestPathStatus,contestId: freezed == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String?,dayNumber: freezed == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int?,finalDay: freezed == finalDay ? _self.finalDay : finalDay // ignore: cast_nullable_to_non_nullable
as int?,weekNumber: freezed == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<PathDay>,claims: null == claims ? _self._claims : claims // ignore: cast_nullable_to_non_nullable
as List<PostClaim>,feedComments: freezed == feedComments ? _self.feedComments : feedComments // ignore: cast_nullable_to_non_nullable
as FeedCommentsRule?,weekReward: freezed == weekReward ? _self.weekReward : weekReward // ignore: cast_nullable_to_non_nullable
as WeekReward?,
  ));
}

/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCommentsRuleCopyWith<$Res>? get feedComments {
    if (_self.feedComments == null) {
    return null;
  }

  return $FeedCommentsRuleCopyWith<$Res>(_self.feedComments!, (value) {
    return _then(_self.copyWith(feedComments: value));
  });
}/// Create a copy of ContestPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekRewardCopyWith<$Res>? get weekReward {
    if (_self.weekReward == null) {
    return null;
  }

  return $WeekRewardCopyWith<$Res>(_self.weekReward!, (value) {
    return _then(_self.copyWith(weekReward: value));
  });
}
}

// dart format on
