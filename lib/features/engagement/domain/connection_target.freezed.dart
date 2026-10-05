// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectionTarget {

 String get role; String get company;/// What to type into LinkedIn's people search.
 String get searchQuery;/// The server's deep link to that search, stamped with
/// `origin=SWITCH_SEARCH_VERTICAL` by `findConnections()`.
///
/// Read through [searchUrl], never directly — it carries `@Default('')`,
/// so a server that omits it hands the UI an empty string rather than
/// null, and an empty string is not a link.
 String get linkedinSearchUrl;/// The connection note / DM body, ready to paste.
 String get note; bool get isDirectMessage;/// Copied at least once. Local only — the server has no per-target state,
/// and copying is the last thing this app can observe before the user
/// leaves for LinkedIn.
@JsonKey(includeFromJson: false, includeToJson: false) bool get isSent;
/// Create a copy of ConnectionTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionTargetCopyWith<ConnectionTarget> get copyWith => _$ConnectionTargetCopyWithImpl<ConnectionTarget>(this as ConnectionTarget, _$identity);

  /// Serializes this ConnectionTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionTarget&&(identical(other.role, role) || other.role == role)&&(identical(other.company, company) || other.company == company)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.linkedinSearchUrl, linkedinSearchUrl) || other.linkedinSearchUrl == linkedinSearchUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDirectMessage, isDirectMessage) || other.isDirectMessage == isDirectMessage)&&(identical(other.isSent, isSent) || other.isSent == isSent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,company,searchQuery,linkedinSearchUrl,note,isDirectMessage,isSent);

@override
String toString() {
  return 'ConnectionTarget(role: $role, company: $company, searchQuery: $searchQuery, linkedinSearchUrl: $linkedinSearchUrl, note: $note, isDirectMessage: $isDirectMessage, isSent: $isSent)';
}


}

/// @nodoc
abstract mixin class $ConnectionTargetCopyWith<$Res>  {
  factory $ConnectionTargetCopyWith(ConnectionTarget value, $Res Function(ConnectionTarget) _then) = _$ConnectionTargetCopyWithImpl;
@useResult
$Res call({
 String role, String company, String searchQuery, String linkedinSearchUrl, String note, bool isDirectMessage,@JsonKey(includeFromJson: false, includeToJson: false) bool isSent
});




}
/// @nodoc
class _$ConnectionTargetCopyWithImpl<$Res>
    implements $ConnectionTargetCopyWith<$Res> {
  _$ConnectionTargetCopyWithImpl(this._self, this._then);

  final ConnectionTarget _self;
  final $Res Function(ConnectionTarget) _then;

/// Create a copy of ConnectionTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? company = null,Object? searchQuery = null,Object? linkedinSearchUrl = null,Object? note = null,Object? isDirectMessage = null,Object? isSent = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,linkedinSearchUrl: null == linkedinSearchUrl ? _self.linkedinSearchUrl : linkedinSearchUrl // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isDirectMessage: null == isDirectMessage ? _self.isDirectMessage : isDirectMessage // ignore: cast_nullable_to_non_nullable
as bool,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionTarget].
extension ConnectionTargetPatterns on ConnectionTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionTarget value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionTarget value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String company,  String searchQuery,  String linkedinSearchUrl,  String note,  bool isDirectMessage, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionTarget() when $default != null:
return $default(_that.role,_that.company,_that.searchQuery,_that.linkedinSearchUrl,_that.note,_that.isDirectMessage,_that.isSent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String company,  String searchQuery,  String linkedinSearchUrl,  String note,  bool isDirectMessage, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent)  $default,) {final _that = this;
switch (_that) {
case _ConnectionTarget():
return $default(_that.role,_that.company,_that.searchQuery,_that.linkedinSearchUrl,_that.note,_that.isDirectMessage,_that.isSent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String company,  String searchQuery,  String linkedinSearchUrl,  String note,  bool isDirectMessage, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionTarget() when $default != null:
return $default(_that.role,_that.company,_that.searchQuery,_that.linkedinSearchUrl,_that.note,_that.isDirectMessage,_that.isSent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectionTarget extends ConnectionTarget {
  const _ConnectionTarget({this.role = '', this.company = '', this.searchQuery = '', this.linkedinSearchUrl = '', this.note = '', this.isDirectMessage = false, @JsonKey(includeFromJson: false, includeToJson: false) this.isSent = false}): super._();
  factory _ConnectionTarget.fromJson(Map<String, dynamic> json) => _$ConnectionTargetFromJson(json);

@override@JsonKey() final  String role;
@override@JsonKey() final  String company;
/// What to type into LinkedIn's people search.
@override@JsonKey() final  String searchQuery;
/// The server's deep link to that search, stamped with
/// `origin=SWITCH_SEARCH_VERTICAL` by `findConnections()`.
///
/// Read through [searchUrl], never directly — it carries `@Default('')`,
/// so a server that omits it hands the UI an empty string rather than
/// null, and an empty string is not a link.
@override@JsonKey() final  String linkedinSearchUrl;
/// The connection note / DM body, ready to paste.
@override@JsonKey() final  String note;
@override@JsonKey() final  bool isDirectMessage;
/// Copied at least once. Local only — the server has no per-target state,
/// and copying is the last thing this app can observe before the user
/// leaves for LinkedIn.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isSent;

/// Create a copy of ConnectionTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionTargetCopyWith<_ConnectionTarget> get copyWith => __$ConnectionTargetCopyWithImpl<_ConnectionTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectionTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionTarget&&(identical(other.role, role) || other.role == role)&&(identical(other.company, company) || other.company == company)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.linkedinSearchUrl, linkedinSearchUrl) || other.linkedinSearchUrl == linkedinSearchUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDirectMessage, isDirectMessage) || other.isDirectMessage == isDirectMessage)&&(identical(other.isSent, isSent) || other.isSent == isSent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,company,searchQuery,linkedinSearchUrl,note,isDirectMessage,isSent);

@override
String toString() {
  return 'ConnectionTarget(role: $role, company: $company, searchQuery: $searchQuery, linkedinSearchUrl: $linkedinSearchUrl, note: $note, isDirectMessage: $isDirectMessage, isSent: $isSent)';
}


}

/// @nodoc
abstract mixin class _$ConnectionTargetCopyWith<$Res> implements $ConnectionTargetCopyWith<$Res> {
  factory _$ConnectionTargetCopyWith(_ConnectionTarget value, $Res Function(_ConnectionTarget) _then) = __$ConnectionTargetCopyWithImpl;
@override @useResult
$Res call({
 String role, String company, String searchQuery, String linkedinSearchUrl, String note, bool isDirectMessage,@JsonKey(includeFromJson: false, includeToJson: false) bool isSent
});




}
/// @nodoc
class __$ConnectionTargetCopyWithImpl<$Res>
    implements _$ConnectionTargetCopyWith<$Res> {
  __$ConnectionTargetCopyWithImpl(this._self, this._then);

  final _ConnectionTarget _self;
  final $Res Function(_ConnectionTarget) _then;

/// Create a copy of ConnectionTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? company = null,Object? searchQuery = null,Object? linkedinSearchUrl = null,Object? note = null,Object? isDirectMessage = null,Object? isSent = null,}) {
  return _then(_ConnectionTarget(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,linkedinSearchUrl: null == linkedinSearchUrl ? _self.linkedinSearchUrl : linkedinSearchUrl // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isDirectMessage: null == isDirectMessage ? _self.isDirectMessage : isDirectMessage // ignore: cast_nullable_to_non_nullable
as bool,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConnectionBatch {

 List<ConnectionTarget> get connections;/// The profession the server aimed the batch at — the user's LinkedIn
/// headline, falling back to their stated profession.
 String get profession;/// True when this is today's stored batch, replayed at no cost.
 bool get cached;/// What a fresh batch would cost. Null until the server has priced one.
 int? get xpCost;
/// Create a copy of ConnectionBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionBatchCopyWith<ConnectionBatch> get copyWith => _$ConnectionBatchCopyWithImpl<ConnectionBatch>(this as ConnectionBatch, _$identity);

  /// Serializes this ConnectionBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionBatch&&const DeepCollectionEquality().equals(other.connections, connections)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.xpCost, xpCost) || other.xpCost == xpCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(connections),profession,cached,xpCost);

@override
String toString() {
  return 'ConnectionBatch(connections: $connections, profession: $profession, cached: $cached, xpCost: $xpCost)';
}


}

/// @nodoc
abstract mixin class $ConnectionBatchCopyWith<$Res>  {
  factory $ConnectionBatchCopyWith(ConnectionBatch value, $Res Function(ConnectionBatch) _then) = _$ConnectionBatchCopyWithImpl;
@useResult
$Res call({
 List<ConnectionTarget> connections, String profession, bool cached, int? xpCost
});




}
/// @nodoc
class _$ConnectionBatchCopyWithImpl<$Res>
    implements $ConnectionBatchCopyWith<$Res> {
  _$ConnectionBatchCopyWithImpl(this._self, this._then);

  final ConnectionBatch _self;
  final $Res Function(ConnectionBatch) _then;

/// Create a copy of ConnectionBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connections = null,Object? profession = null,Object? cached = null,Object? xpCost = freezed,}) {
  return _then(_self.copyWith(
connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as List<ConnectionTarget>,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,xpCost: freezed == xpCost ? _self.xpCost : xpCost // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionBatch].
extension ConnectionBatchPatterns on ConnectionBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionBatch value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionBatch value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ConnectionTarget> connections,  String profession,  bool cached,  int? xpCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionBatch() when $default != null:
return $default(_that.connections,_that.profession,_that.cached,_that.xpCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ConnectionTarget> connections,  String profession,  bool cached,  int? xpCost)  $default,) {final _that = this;
switch (_that) {
case _ConnectionBatch():
return $default(_that.connections,_that.profession,_that.cached,_that.xpCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ConnectionTarget> connections,  String profession,  bool cached,  int? xpCost)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionBatch() when $default != null:
return $default(_that.connections,_that.profession,_that.cached,_that.xpCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectionBatch extends ConnectionBatch {
  const _ConnectionBatch({final  List<ConnectionTarget> connections = const <ConnectionTarget>[], this.profession = '', this.cached = false, this.xpCost}): _connections = connections,super._();
  factory _ConnectionBatch.fromJson(Map<String, dynamic> json) => _$ConnectionBatchFromJson(json);

 final  List<ConnectionTarget> _connections;
@override@JsonKey() List<ConnectionTarget> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}

/// The profession the server aimed the batch at — the user's LinkedIn
/// headline, falling back to their stated profession.
@override@JsonKey() final  String profession;
/// True when this is today's stored batch, replayed at no cost.
@override@JsonKey() final  bool cached;
/// What a fresh batch would cost. Null until the server has priced one.
@override final  int? xpCost;

/// Create a copy of ConnectionBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionBatchCopyWith<_ConnectionBatch> get copyWith => __$ConnectionBatchCopyWithImpl<_ConnectionBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectionBatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionBatch&&const DeepCollectionEquality().equals(other._connections, _connections)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.xpCost, xpCost) || other.xpCost == xpCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_connections),profession,cached,xpCost);

@override
String toString() {
  return 'ConnectionBatch(connections: $connections, profession: $profession, cached: $cached, xpCost: $xpCost)';
}


}

/// @nodoc
abstract mixin class _$ConnectionBatchCopyWith<$Res> implements $ConnectionBatchCopyWith<$Res> {
  factory _$ConnectionBatchCopyWith(_ConnectionBatch value, $Res Function(_ConnectionBatch) _then) = __$ConnectionBatchCopyWithImpl;
@override @useResult
$Res call({
 List<ConnectionTarget> connections, String profession, bool cached, int? xpCost
});




}
/// @nodoc
class __$ConnectionBatchCopyWithImpl<$Res>
    implements _$ConnectionBatchCopyWith<$Res> {
  __$ConnectionBatchCopyWithImpl(this._self, this._then);

  final _ConnectionBatch _self;
  final $Res Function(_ConnectionBatch) _then;

/// Create a copy of ConnectionBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connections = null,Object? profession = null,Object? cached = null,Object? xpCost = freezed,}) {
  return _then(_ConnectionBatch(
connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<ConnectionTarget>,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,xpCost: freezed == xpCost ? _self.xpCost : xpCost // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
