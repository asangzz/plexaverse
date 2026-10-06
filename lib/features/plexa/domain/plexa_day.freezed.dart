// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plexa_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayItem {

 String get id;@JsonKey(unknownEnumValue: PlexaLane.comments) PlexaLane get lane;/// What the user is being pointed at.
 String get headline;/// The sub-line: an author, a company, the context for the headline.
 String? get context;/// The thing Plexa wrote, copied to the clipboard on open.
 String get draft;/// Where "open" goes.
 String get url;/// Set only for Top Voices rows, which have their own durable stamp.
 String? get topVoiceId;
/// Create a copy of DayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayItemCopyWith<DayItem> get copyWith => _$DayItemCopyWithImpl<DayItem>(this as DayItem, _$identity);

  /// Serializes this DayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.lane, lane) || other.lane == lane)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.context, context) || other.context == context)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.url, url) || other.url == url)&&(identical(other.topVoiceId, topVoiceId) || other.topVoiceId == topVoiceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lane,headline,context,draft,url,topVoiceId);

@override
String toString() {
  return 'DayItem(id: $id, lane: $lane, headline: $headline, context: $context, draft: $draft, url: $url, topVoiceId: $topVoiceId)';
}


}

/// @nodoc
abstract mixin class $DayItemCopyWith<$Res>  {
  factory $DayItemCopyWith(DayItem value, $Res Function(DayItem) _then) = _$DayItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PlexaLane.comments) PlexaLane lane, String headline, String? context, String draft, String url, String? topVoiceId
});




}
/// @nodoc
class _$DayItemCopyWithImpl<$Res>
    implements $DayItemCopyWith<$Res> {
  _$DayItemCopyWithImpl(this._self, this._then);

  final DayItem _self;
  final $Res Function(DayItem) _then;

/// Create a copy of DayItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lane = null,Object? headline = null,Object? context = freezed,Object? draft = null,Object? url = null,Object? topVoiceId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lane: null == lane ? _self.lane : lane // ignore: cast_nullable_to_non_nullable
as PlexaLane,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,topVoiceId: freezed == topVoiceId ? _self.topVoiceId : topVoiceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayItem].
extension DayItemPatterns on DayItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayItem value)  $default,){
final _that = this;
switch (_that) {
case _DayItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayItem value)?  $default,){
final _that = this;
switch (_that) {
case _DayItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PlexaLane.comments)  PlexaLane lane,  String headline,  String? context,  String draft,  String url,  String? topVoiceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayItem() when $default != null:
return $default(_that.id,_that.lane,_that.headline,_that.context,_that.draft,_that.url,_that.topVoiceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PlexaLane.comments)  PlexaLane lane,  String headline,  String? context,  String draft,  String url,  String? topVoiceId)  $default,) {final _that = this;
switch (_that) {
case _DayItem():
return $default(_that.id,_that.lane,_that.headline,_that.context,_that.draft,_that.url,_that.topVoiceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: PlexaLane.comments)  PlexaLane lane,  String headline,  String? context,  String draft,  String url,  String? topVoiceId)?  $default,) {final _that = this;
switch (_that) {
case _DayItem() when $default != null:
return $default(_that.id,_that.lane,_that.headline,_that.context,_that.draft,_that.url,_that.topVoiceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayItem extends DayItem {
  const _DayItem({this.id = '', @JsonKey(unknownEnumValue: PlexaLane.comments) this.lane = PlexaLane.comments, this.headline = '', this.context, this.draft = '', this.url = '', this.topVoiceId}): super._();
  factory _DayItem.fromJson(Map<String, dynamic> json) => _$DayItemFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(unknownEnumValue: PlexaLane.comments) final  PlexaLane lane;
/// What the user is being pointed at.
@override@JsonKey() final  String headline;
/// The sub-line: an author, a company, the context for the headline.
@override final  String? context;
/// The thing Plexa wrote, copied to the clipboard on open.
@override@JsonKey() final  String draft;
/// Where "open" goes.
@override@JsonKey() final  String url;
/// Set only for Top Voices rows, which have their own durable stamp.
@override final  String? topVoiceId;

/// Create a copy of DayItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayItemCopyWith<_DayItem> get copyWith => __$DayItemCopyWithImpl<_DayItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayItem&&(identical(other.id, id) || other.id == id)&&(identical(other.lane, lane) || other.lane == lane)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.context, context) || other.context == context)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.url, url) || other.url == url)&&(identical(other.topVoiceId, topVoiceId) || other.topVoiceId == topVoiceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lane,headline,context,draft,url,topVoiceId);

@override
String toString() {
  return 'DayItem(id: $id, lane: $lane, headline: $headline, context: $context, draft: $draft, url: $url, topVoiceId: $topVoiceId)';
}


}

/// @nodoc
abstract mixin class _$DayItemCopyWith<$Res> implements $DayItemCopyWith<$Res> {
  factory _$DayItemCopyWith(_DayItem value, $Res Function(_DayItem) _then) = __$DayItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PlexaLane.comments) PlexaLane lane, String headline, String? context, String draft, String url, String? topVoiceId
});




}
/// @nodoc
class __$DayItemCopyWithImpl<$Res>
    implements _$DayItemCopyWith<$Res> {
  __$DayItemCopyWithImpl(this._self, this._then);

  final _DayItem _self;
  final $Res Function(_DayItem) _then;

/// Create a copy of DayItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lane = null,Object? headline = null,Object? context = freezed,Object? draft = null,Object? url = null,Object? topVoiceId = freezed,}) {
  return _then(_DayItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lane: null == lane ? _self.lane : lane // ignore: cast_nullable_to_non_nullable
as PlexaLane,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,topVoiceId: freezed == topVoiceId ? _self.topVoiceId : topVoiceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PlexaSession {

 List<String> get comments; List<String> get connections;
/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<PlexaSession> get copyWith => _$PlexaSessionCopyWithImpl<PlexaSession>(this as PlexaSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaSession&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.connections, connections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'PlexaSession(comments: $comments, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $PlexaSessionCopyWith<$Res>  {
  factory $PlexaSessionCopyWith(PlexaSession value, $Res Function(PlexaSession) _then) = _$PlexaSessionCopyWithImpl;
@useResult
$Res call({
 List<String> comments, List<String> connections
});




}
/// @nodoc
class _$PlexaSessionCopyWithImpl<$Res>
    implements $PlexaSessionCopyWith<$Res> {
  _$PlexaSessionCopyWithImpl(this._self, this._then);

  final PlexaSession _self;
  final $Res Function(PlexaSession) _then;

/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? connections = null,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaSession].
extension PlexaSessionPatterns on PlexaSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaSession value)  $default,){
final _that = this;
switch (_that) {
case _PlexaSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaSession value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> comments,  List<String> connections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
return $default(_that.comments,_that.connections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> comments,  List<String> connections)  $default,) {final _that = this;
switch (_that) {
case _PlexaSession():
return $default(_that.comments,_that.connections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> comments,  List<String> connections)?  $default,) {final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
return $default(_that.comments,_that.connections);case _:
  return null;

}
}

}

/// @nodoc


class _PlexaSession extends PlexaSession {
  const _PlexaSession({final  List<String> comments = const <String>[], final  List<String> connections = const <String>[]}): _comments = comments,_connections = connections,super._();
  

 final  List<String> _comments;
@override@JsonKey() List<String> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<String> _connections;
@override@JsonKey() List<String> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaSessionCopyWith<_PlexaSession> get copyWith => __$PlexaSessionCopyWithImpl<_PlexaSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaSession&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._connections, _connections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'PlexaSession(comments: $comments, connections: $connections)';
}


}

/// @nodoc
abstract mixin class _$PlexaSessionCopyWith<$Res> implements $PlexaSessionCopyWith<$Res> {
  factory _$PlexaSessionCopyWith(_PlexaSession value, $Res Function(_PlexaSession) _then) = __$PlexaSessionCopyWithImpl;
@override @useResult
$Res call({
 List<String> comments, List<String> connections
});




}
/// @nodoc
class __$PlexaSessionCopyWithImpl<$Res>
    implements _$PlexaSessionCopyWith<$Res> {
  __$PlexaSessionCopyWithImpl(this._self, this._then);

  final _PlexaSession _self;
  final $Res Function(_PlexaSession) _then;

/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? connections = null,}) {
  return _then(_PlexaSession(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>,connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlexaReady {

 bool get comments; bool get connections; bool get topVoices;
/// Create a copy of PlexaReady
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaReadyCopyWith<PlexaReady> get copyWith => _$PlexaReadyCopyWithImpl<PlexaReady>(this as PlexaReady, _$identity);

  /// Serializes this PlexaReady to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaReady&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.topVoices, topVoices) || other.topVoices == topVoices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comments,connections,topVoices);

@override
String toString() {
  return 'PlexaReady(comments: $comments, connections: $connections, topVoices: $topVoices)';
}


}

/// @nodoc
abstract mixin class $PlexaReadyCopyWith<$Res>  {
  factory $PlexaReadyCopyWith(PlexaReady value, $Res Function(PlexaReady) _then) = _$PlexaReadyCopyWithImpl;
@useResult
$Res call({
 bool comments, bool connections, bool topVoices
});




}
/// @nodoc
class _$PlexaReadyCopyWithImpl<$Res>
    implements $PlexaReadyCopyWith<$Res> {
  _$PlexaReadyCopyWithImpl(this._self, this._then);

  final PlexaReady _self;
  final $Res Function(PlexaReady) _then;

/// Create a copy of PlexaReady
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? connections = null,Object? topVoices = null,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as bool,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as bool,topVoices: null == topVoices ? _self.topVoices : topVoices // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaReady].
extension PlexaReadyPatterns on PlexaReady {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaReady value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaReady() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaReady value)  $default,){
final _that = this;
switch (_that) {
case _PlexaReady():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaReady value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaReady() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool comments,  bool connections,  bool topVoices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaReady() when $default != null:
return $default(_that.comments,_that.connections,_that.topVoices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool comments,  bool connections,  bool topVoices)  $default,) {final _that = this;
switch (_that) {
case _PlexaReady():
return $default(_that.comments,_that.connections,_that.topVoices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool comments,  bool connections,  bool topVoices)?  $default,) {final _that = this;
switch (_that) {
case _PlexaReady() when $default != null:
return $default(_that.comments,_that.connections,_that.topVoices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlexaReady extends PlexaReady {
  const _PlexaReady({this.comments = false, this.connections = false, this.topVoices = false}): super._();
  factory _PlexaReady.fromJson(Map<String, dynamic> json) => _$PlexaReadyFromJson(json);

@override@JsonKey() final  bool comments;
@override@JsonKey() final  bool connections;
@override@JsonKey() final  bool topVoices;

/// Create a copy of PlexaReady
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaReadyCopyWith<_PlexaReady> get copyWith => __$PlexaReadyCopyWithImpl<_PlexaReady>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlexaReadyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaReady&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.topVoices, topVoices) || other.topVoices == topVoices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comments,connections,topVoices);

@override
String toString() {
  return 'PlexaReady(comments: $comments, connections: $connections, topVoices: $topVoices)';
}


}

/// @nodoc
abstract mixin class _$PlexaReadyCopyWith<$Res> implements $PlexaReadyCopyWith<$Res> {
  factory _$PlexaReadyCopyWith(_PlexaReady value, $Res Function(_PlexaReady) _then) = __$PlexaReadyCopyWithImpl;
@override @useResult
$Res call({
 bool comments, bool connections, bool topVoices
});




}
/// @nodoc
class __$PlexaReadyCopyWithImpl<$Res>
    implements _$PlexaReadyCopyWith<$Res> {
  __$PlexaReadyCopyWithImpl(this._self, this._then);

  final _PlexaReady _self;
  final $Res Function(_PlexaReady) _then;

/// Create a copy of PlexaReady
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? connections = null,Object? topVoices = null,}) {
  return _then(_PlexaReady(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as bool,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as bool,topVoices: null == topVoices ? _self.topVoices : topVoices // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PlexaDay {

 PlexaSession get session; List<DayItem> get items; PlexaReady get ready;/// The topic today's comments were written around.
 String get topic;
/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaDayCopyWith<PlexaDay> get copyWith => _$PlexaDayCopyWithImpl<PlexaDay>(this as PlexaDay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaDay&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(items),ready,topic);

@override
String toString() {
  return 'PlexaDay(session: $session, items: $items, ready: $ready, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $PlexaDayCopyWith<$Res>  {
  factory $PlexaDayCopyWith(PlexaDay value, $Res Function(PlexaDay) _then) = _$PlexaDayCopyWithImpl;
@useResult
$Res call({
 PlexaSession session, List<DayItem> items, PlexaReady ready, String topic
});


$PlexaSessionCopyWith<$Res> get session;$PlexaReadyCopyWith<$Res> get ready;

}
/// @nodoc
class _$PlexaDayCopyWithImpl<$Res>
    implements $PlexaDayCopyWith<$Res> {
  _$PlexaDayCopyWithImpl(this._self, this._then);

  final PlexaDay _self;
  final $Res Function(PlexaDay) _then;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? items = null,Object? ready = null,Object? topic = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlexaSession,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DayItem>,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as PlexaReady,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<$Res> get session {
  
  return $PlexaSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaReadyCopyWith<$Res> get ready {
  
  return $PlexaReadyCopyWith<$Res>(_self.ready, (value) {
    return _then(_self.copyWith(ready: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlexaDay].
extension PlexaDayPatterns on PlexaDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaDay value)  $default,){
final _that = this;
switch (_that) {
case _PlexaDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaDay value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlexaSession session,  List<DayItem> items,  PlexaReady ready,  String topic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
return $default(_that.session,_that.items,_that.ready,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlexaSession session,  List<DayItem> items,  PlexaReady ready,  String topic)  $default,) {final _that = this;
switch (_that) {
case _PlexaDay():
return $default(_that.session,_that.items,_that.ready,_that.topic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlexaSession session,  List<DayItem> items,  PlexaReady ready,  String topic)?  $default,) {final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
return $default(_that.session,_that.items,_that.ready,_that.topic);case _:
  return null;

}
}

}

/// @nodoc


class _PlexaDay extends PlexaDay {
  const _PlexaDay({this.session = const PlexaSession(), final  List<DayItem> items = const <DayItem>[], this.ready = const PlexaReady(), this.topic = ''}): _items = items,super._();
  

@override@JsonKey() final  PlexaSession session;
 final  List<DayItem> _items;
@override@JsonKey() List<DayItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  PlexaReady ready;
/// The topic today's comments were written around.
@override@JsonKey() final  String topic;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaDayCopyWith<_PlexaDay> get copyWith => __$PlexaDayCopyWithImpl<_PlexaDay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaDay&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_items),ready,topic);

@override
String toString() {
  return 'PlexaDay(session: $session, items: $items, ready: $ready, topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$PlexaDayCopyWith<$Res> implements $PlexaDayCopyWith<$Res> {
  factory _$PlexaDayCopyWith(_PlexaDay value, $Res Function(_PlexaDay) _then) = __$PlexaDayCopyWithImpl;
@override @useResult
$Res call({
 PlexaSession session, List<DayItem> items, PlexaReady ready, String topic
});


@override $PlexaSessionCopyWith<$Res> get session;@override $PlexaReadyCopyWith<$Res> get ready;

}
/// @nodoc
class __$PlexaDayCopyWithImpl<$Res>
    implements _$PlexaDayCopyWith<$Res> {
  __$PlexaDayCopyWithImpl(this._self, this._then);

  final _PlexaDay _self;
  final $Res Function(_PlexaDay) _then;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? items = null,Object? ready = null,Object? topic = null,}) {
  return _then(_PlexaDay(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlexaSession,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DayItem>,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as PlexaReady,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<$Res> get session {
  
  return $PlexaSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaReadyCopyWith<$Res> get ready {
  
  return $PlexaReadyCopyWith<$Res>(_self.ready, (value) {
    return _then(_self.copyWith(ready: value));
  });
}
}

// dart format on
