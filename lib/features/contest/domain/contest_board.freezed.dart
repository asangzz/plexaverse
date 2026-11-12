// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoardRow {

 int get rank;/// Null unless this entrant agreed to be named (`contest_leaderboard`),
/// or it is the viewer — and always null for a viewer who has not
/// joined. Drawn as "Participant", never as a blank.
 String? get name; String? get image; bool get isViewer; int get total;/// The live daily lesson streak, on the contest's clock.
 int get streak; String get level;
/// Create a copy of BoardRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardRowCopyWith<BoardRow> get copyWith => _$BoardRowCopyWithImpl<BoardRow>(this as BoardRow, _$identity);

  /// Serializes this BoardRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardRow&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.isViewer, isViewer) || other.isViewer == isViewer)&&(identical(other.total, total) || other.total == total)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,name,image,isViewer,total,streak,level);

@override
String toString() {
  return 'BoardRow(rank: $rank, name: $name, image: $image, isViewer: $isViewer, total: $total, streak: $streak, level: $level)';
}


}

/// @nodoc
abstract mixin class $BoardRowCopyWith<$Res>  {
  factory $BoardRowCopyWith(BoardRow value, $Res Function(BoardRow) _then) = _$BoardRowCopyWithImpl;
@useResult
$Res call({
 int rank, String? name, String? image, bool isViewer, int total, int streak, String level
});




}
/// @nodoc
class _$BoardRowCopyWithImpl<$Res>
    implements $BoardRowCopyWith<$Res> {
  _$BoardRowCopyWithImpl(this._self, this._then);

  final BoardRow _self;
  final $Res Function(BoardRow) _then;

/// Create a copy of BoardRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? name = freezed,Object? image = freezed,Object? isViewer = null,Object? total = null,Object? streak = null,Object? level = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,isViewer: null == isViewer ? _self.isViewer : isViewer // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardRow].
extension BoardRowPatterns on BoardRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardRow value)  $default,){
final _that = this;
switch (_that) {
case _BoardRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardRow value)?  $default,){
final _that = this;
switch (_that) {
case _BoardRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String? name,  String? image,  bool isViewer,  int total,  int streak,  String level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardRow() when $default != null:
return $default(_that.rank,_that.name,_that.image,_that.isViewer,_that.total,_that.streak,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String? name,  String? image,  bool isViewer,  int total,  int streak,  String level)  $default,) {final _that = this;
switch (_that) {
case _BoardRow():
return $default(_that.rank,_that.name,_that.image,_that.isViewer,_that.total,_that.streak,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String? name,  String? image,  bool isViewer,  int total,  int streak,  String level)?  $default,) {final _that = this;
switch (_that) {
case _BoardRow() when $default != null:
return $default(_that.rank,_that.name,_that.image,_that.isViewer,_that.total,_that.streak,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardRow implements BoardRow {
  const _BoardRow({this.rank = 0, this.name, this.image, this.isViewer = false, this.total = 0, this.streak = 0, this.level = 'B2'});
  factory _BoardRow.fromJson(Map<String, dynamic> json) => _$BoardRowFromJson(json);

@override@JsonKey() final  int rank;
/// Null unless this entrant agreed to be named (`contest_leaderboard`),
/// or it is the viewer — and always null for a viewer who has not
/// joined. Drawn as "Participant", never as a blank.
@override final  String? name;
@override final  String? image;
@override@JsonKey() final  bool isViewer;
@override@JsonKey() final  int total;
/// The live daily lesson streak, on the contest's clock.
@override@JsonKey() final  int streak;
@override@JsonKey() final  String level;

/// Create a copy of BoardRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardRowCopyWith<_BoardRow> get copyWith => __$BoardRowCopyWithImpl<_BoardRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardRow&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.isViewer, isViewer) || other.isViewer == isViewer)&&(identical(other.total, total) || other.total == total)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,name,image,isViewer,total,streak,level);

@override
String toString() {
  return 'BoardRow(rank: $rank, name: $name, image: $image, isViewer: $isViewer, total: $total, streak: $streak, level: $level)';
}


}

/// @nodoc
abstract mixin class _$BoardRowCopyWith<$Res> implements $BoardRowCopyWith<$Res> {
  factory _$BoardRowCopyWith(_BoardRow value, $Res Function(_BoardRow) _then) = __$BoardRowCopyWithImpl;
@override @useResult
$Res call({
 int rank, String? name, String? image, bool isViewer, int total, int streak, String level
});




}
/// @nodoc
class __$BoardRowCopyWithImpl<$Res>
    implements _$BoardRowCopyWith<$Res> {
  __$BoardRowCopyWithImpl(this._self, this._then);

  final _BoardRow _self;
  final $Res Function(_BoardRow) _then;

/// Create a copy of BoardRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? name = freezed,Object? image = freezed,Object? isViewer = null,Object? total = null,Object? streak = null,Object? level = null,}) {
  return _then(_BoardRow(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,isViewer: null == isViewer ? _self.isViewer : isViewer // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BoardSelf {

 int get total; int get streak; String get level;
/// Create a copy of BoardSelf
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardSelfCopyWith<BoardSelf> get copyWith => _$BoardSelfCopyWithImpl<BoardSelf>(this as BoardSelf, _$identity);

  /// Serializes this BoardSelf to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardSelf&&(identical(other.total, total) || other.total == total)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,streak,level);

@override
String toString() {
  return 'BoardSelf(total: $total, streak: $streak, level: $level)';
}


}

/// @nodoc
abstract mixin class $BoardSelfCopyWith<$Res>  {
  factory $BoardSelfCopyWith(BoardSelf value, $Res Function(BoardSelf) _then) = _$BoardSelfCopyWithImpl;
@useResult
$Res call({
 int total, int streak, String level
});




}
/// @nodoc
class _$BoardSelfCopyWithImpl<$Res>
    implements $BoardSelfCopyWith<$Res> {
  _$BoardSelfCopyWithImpl(this._self, this._then);

  final BoardSelf _self;
  final $Res Function(BoardSelf) _then;

/// Create a copy of BoardSelf
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? streak = null,Object? level = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardSelf].
extension BoardSelfPatterns on BoardSelf {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardSelf value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardSelf() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardSelf value)  $default,){
final _that = this;
switch (_that) {
case _BoardSelf():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardSelf value)?  $default,){
final _that = this;
switch (_that) {
case _BoardSelf() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int streak,  String level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardSelf() when $default != null:
return $default(_that.total,_that.streak,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int streak,  String level)  $default,) {final _that = this;
switch (_that) {
case _BoardSelf():
return $default(_that.total,_that.streak,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int streak,  String level)?  $default,) {final _that = this;
switch (_that) {
case _BoardSelf() when $default != null:
return $default(_that.total,_that.streak,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardSelf implements BoardSelf {
  const _BoardSelf({this.total = 0, this.streak = 0, this.level = 'B2'});
  factory _BoardSelf.fromJson(Map<String, dynamic> json) => _$BoardSelfFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int streak;
@override@JsonKey() final  String level;

/// Create a copy of BoardSelf
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardSelfCopyWith<_BoardSelf> get copyWith => __$BoardSelfCopyWithImpl<_BoardSelf>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardSelfToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardSelf&&(identical(other.total, total) || other.total == total)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,streak,level);

@override
String toString() {
  return 'BoardSelf(total: $total, streak: $streak, level: $level)';
}


}

/// @nodoc
abstract mixin class _$BoardSelfCopyWith<$Res> implements $BoardSelfCopyWith<$Res> {
  factory _$BoardSelfCopyWith(_BoardSelf value, $Res Function(_BoardSelf) _then) = __$BoardSelfCopyWithImpl;
@override @useResult
$Res call({
 int total, int streak, String level
});




}
/// @nodoc
class __$BoardSelfCopyWithImpl<$Res>
    implements _$BoardSelfCopyWith<$Res> {
  __$BoardSelfCopyWithImpl(this._self, this._then);

  final _BoardSelf _self;
  final $Res Function(_BoardSelf) _then;

/// Create a copy of BoardSelf
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? streak = null,Object? level = null,}) {
  return _then(_BoardSelf(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BoardResult {

 bool get revealed;/// `YYYY-MM-DD`, contest timezone. Empty when there is no contest.
 String get revealsOn; int get revealDay; List<BoardRow> get rows;/// The caller's row, which may sit outside [rows].
 BoardRow? get viewer;/// Null when the caller is not an entrant.
 BoardSelf? get self;
/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardResultCopyWith<BoardResult> get copyWith => _$BoardResultCopyWithImpl<BoardResult>(this as BoardResult, _$identity);

  /// Serializes this BoardResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardResult&&(identical(other.revealed, revealed) || other.revealed == revealed)&&(identical(other.revealsOn, revealsOn) || other.revealsOn == revealsOn)&&(identical(other.revealDay, revealDay) || other.revealDay == revealDay)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.viewer, viewer) || other.viewer == viewer)&&(identical(other.self, self) || other.self == self));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revealed,revealsOn,revealDay,const DeepCollectionEquality().hash(rows),viewer,self);

@override
String toString() {
  return 'BoardResult(revealed: $revealed, revealsOn: $revealsOn, revealDay: $revealDay, rows: $rows, viewer: $viewer, self: $self)';
}


}

/// @nodoc
abstract mixin class $BoardResultCopyWith<$Res>  {
  factory $BoardResultCopyWith(BoardResult value, $Res Function(BoardResult) _then) = _$BoardResultCopyWithImpl;
@useResult
$Res call({
 bool revealed, String revealsOn, int revealDay, List<BoardRow> rows, BoardRow? viewer, BoardSelf? self
});


$BoardRowCopyWith<$Res>? get viewer;$BoardSelfCopyWith<$Res>? get self;

}
/// @nodoc
class _$BoardResultCopyWithImpl<$Res>
    implements $BoardResultCopyWith<$Res> {
  _$BoardResultCopyWithImpl(this._self, this._then);

  final BoardResult _self;
  final $Res Function(BoardResult) _then;

/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revealed = null,Object? revealsOn = null,Object? revealDay = null,Object? rows = null,Object? viewer = freezed,Object? self = freezed,}) {
  return _then(_self.copyWith(
revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,revealsOn: null == revealsOn ? _self.revealsOn : revealsOn // ignore: cast_nullable_to_non_nullable
as String,revealDay: null == revealDay ? _self.revealDay : revealDay // ignore: cast_nullable_to_non_nullable
as int,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<BoardRow>,viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as BoardRow?,self: freezed == self ? _self.self : self // ignore: cast_nullable_to_non_nullable
as BoardSelf?,
  ));
}
/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardRowCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $BoardRowCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardSelfCopyWith<$Res>? get self {
    if (_self.self == null) {
    return null;
  }

  return $BoardSelfCopyWith<$Res>(_self.self!, (value) {
    return _then(_self.copyWith(self: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoardResult].
extension BoardResultPatterns on BoardResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardResult value)  $default,){
final _that = this;
switch (_that) {
case _BoardResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardResult value)?  $default,){
final _that = this;
switch (_that) {
case _BoardResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool revealed,  String revealsOn,  int revealDay,  List<BoardRow> rows,  BoardRow? viewer,  BoardSelf? self)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardResult() when $default != null:
return $default(_that.revealed,_that.revealsOn,_that.revealDay,_that.rows,_that.viewer,_that.self);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool revealed,  String revealsOn,  int revealDay,  List<BoardRow> rows,  BoardRow? viewer,  BoardSelf? self)  $default,) {final _that = this;
switch (_that) {
case _BoardResult():
return $default(_that.revealed,_that.revealsOn,_that.revealDay,_that.rows,_that.viewer,_that.self);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool revealed,  String revealsOn,  int revealDay,  List<BoardRow> rows,  BoardRow? viewer,  BoardSelf? self)?  $default,) {final _that = this;
switch (_that) {
case _BoardResult() when $default != null:
return $default(_that.revealed,_that.revealsOn,_that.revealDay,_that.rows,_that.viewer,_that.self);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardResult extends BoardResult {
  const _BoardResult({this.revealed = false, this.revealsOn = '', this.revealDay = 1, final  List<BoardRow> rows = const <BoardRow>[], this.viewer, this.self}): _rows = rows,super._();
  factory _BoardResult.fromJson(Map<String, dynamic> json) => _$BoardResultFromJson(json);

@override@JsonKey() final  bool revealed;
/// `YYYY-MM-DD`, contest timezone. Empty when there is no contest.
@override@JsonKey() final  String revealsOn;
@override@JsonKey() final  int revealDay;
 final  List<BoardRow> _rows;
@override@JsonKey() List<BoardRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// The caller's row, which may sit outside [rows].
@override final  BoardRow? viewer;
/// Null when the caller is not an entrant.
@override final  BoardSelf? self;

/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardResultCopyWith<_BoardResult> get copyWith => __$BoardResultCopyWithImpl<_BoardResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardResult&&(identical(other.revealed, revealed) || other.revealed == revealed)&&(identical(other.revealsOn, revealsOn) || other.revealsOn == revealsOn)&&(identical(other.revealDay, revealDay) || other.revealDay == revealDay)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.viewer, viewer) || other.viewer == viewer)&&(identical(other.self, self) || other.self == self));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revealed,revealsOn,revealDay,const DeepCollectionEquality().hash(_rows),viewer,self);

@override
String toString() {
  return 'BoardResult(revealed: $revealed, revealsOn: $revealsOn, revealDay: $revealDay, rows: $rows, viewer: $viewer, self: $self)';
}


}

/// @nodoc
abstract mixin class _$BoardResultCopyWith<$Res> implements $BoardResultCopyWith<$Res> {
  factory _$BoardResultCopyWith(_BoardResult value, $Res Function(_BoardResult) _then) = __$BoardResultCopyWithImpl;
@override @useResult
$Res call({
 bool revealed, String revealsOn, int revealDay, List<BoardRow> rows, BoardRow? viewer, BoardSelf? self
});


@override $BoardRowCopyWith<$Res>? get viewer;@override $BoardSelfCopyWith<$Res>? get self;

}
/// @nodoc
class __$BoardResultCopyWithImpl<$Res>
    implements _$BoardResultCopyWith<$Res> {
  __$BoardResultCopyWithImpl(this._self, this._then);

  final _BoardResult _self;
  final $Res Function(_BoardResult) _then;

/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revealed = null,Object? revealsOn = null,Object? revealDay = null,Object? rows = null,Object? viewer = freezed,Object? self = freezed,}) {
  return _then(_BoardResult(
revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,revealsOn: null == revealsOn ? _self.revealsOn : revealsOn // ignore: cast_nullable_to_non_nullable
as String,revealDay: null == revealDay ? _self.revealDay : revealDay // ignore: cast_nullable_to_non_nullable
as int,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<BoardRow>,viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as BoardRow?,self: freezed == self ? _self.self : self // ignore: cast_nullable_to_non_nullable
as BoardSelf?,
  ));
}

/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardRowCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $BoardRowCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}/// Create a copy of BoardResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardSelfCopyWith<$Res>? get self {
    if (_self.self == null) {
    return null;
  }

  return $BoardSelfCopyWith<$Res>(_self.self!, (value) {
    return _then(_self.copyWith(self: value));
  });
}
}

// dart format on
