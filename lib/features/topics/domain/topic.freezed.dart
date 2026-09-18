// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Topic {

 String get id; String get name;/// Nullable in the schema and genuinely optional in the UI — the web hides
/// the paragraph entirely when it is absent rather than printing a blank.
 String? get description; List<String> get keywords;/// The server defaults this to true on create. Nothing in the web UI can
/// change it; the card shows it as an Active / Inactive pill and that is
/// all. See `TopicsRepository.setActive` for why the endpoint still exists.
 bool get isActive;/// ISO timestamp. The list arrives newest-first from the server, so the
/// client never sorts on this.
 String? get createdAt;/// How many schedules point at this topic.
///
/// Prisma nests it as `_count.schedules`, which no key name can reach, so
/// a `readValue` digs it out. Flattening it beats modelling a `_count`
/// wrapper for a single integer that only ever gets counted.
@JsonKey(readValue: _readScheduleCount) int get scheduleCount;
/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCopyWith<Topic> get copyWith => _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.keywords, keywords)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduleCount, scheduleCount) || other.scheduleCount == scheduleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(keywords),isActive,createdAt,scheduleCount);

@override
String toString() {
  return 'Topic(id: $id, name: $name, description: $description, keywords: $keywords, isActive: $isActive, createdAt: $createdAt, scheduleCount: $scheduleCount)';
}


}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res>  {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) = _$TopicCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, List<String> keywords, bool isActive, String? createdAt,@JsonKey(readValue: _readScheduleCount) int scheduleCount
});




}
/// @nodoc
class _$TopicCopyWithImpl<$Res>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? keywords = null,Object? isActive = null,Object? createdAt = freezed,Object? scheduleCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,scheduleCount: null == scheduleCount ? _self.scheduleCount : scheduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Topic].
extension TopicPatterns on Topic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topic value)  $default,){
final _that = this;
switch (_that) {
case _Topic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topic value)?  $default,){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  List<String> keywords,  bool isActive,  String? createdAt, @JsonKey(readValue: _readScheduleCount)  int scheduleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.keywords,_that.isActive,_that.createdAt,_that.scheduleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  List<String> keywords,  bool isActive,  String? createdAt, @JsonKey(readValue: _readScheduleCount)  int scheduleCount)  $default,) {final _that = this;
switch (_that) {
case _Topic():
return $default(_that.id,_that.name,_that.description,_that.keywords,_that.isActive,_that.createdAt,_that.scheduleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  List<String> keywords,  bool isActive,  String? createdAt, @JsonKey(readValue: _readScheduleCount)  int scheduleCount)?  $default,) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.keywords,_that.isActive,_that.createdAt,_that.scheduleCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Topic extends Topic {
  const _Topic({required this.id, this.name = '', this.description, final  List<String> keywords = const <String>[], this.isActive = true, this.createdAt, @JsonKey(readValue: _readScheduleCount) this.scheduleCount = 0}): _keywords = keywords,super._();
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
/// Nullable in the schema and genuinely optional in the UI — the web hides
/// the paragraph entirely when it is absent rather than printing a blank.
@override final  String? description;
 final  List<String> _keywords;
@override@JsonKey() List<String> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}

/// The server defaults this to true on create. Nothing in the web UI can
/// change it; the card shows it as an Active / Inactive pill and that is
/// all. See `TopicsRepository.setActive` for why the endpoint still exists.
@override@JsonKey() final  bool isActive;
/// ISO timestamp. The list arrives newest-first from the server, so the
/// client never sorts on this.
@override final  String? createdAt;
/// How many schedules point at this topic.
///
/// Prisma nests it as `_count.schedules`, which no key name can reach, so
/// a `readValue` digs it out. Flattening it beats modelling a `_count`
/// wrapper for a single integer that only ever gets counted.
@override@JsonKey(readValue: _readScheduleCount) final  int scheduleCount;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCopyWith<_Topic> get copyWith => __$TopicCopyWithImpl<_Topic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._keywords, _keywords)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduleCount, scheduleCount) || other.scheduleCount == scheduleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_keywords),isActive,createdAt,scheduleCount);

@override
String toString() {
  return 'Topic(id: $id, name: $name, description: $description, keywords: $keywords, isActive: $isActive, createdAt: $createdAt, scheduleCount: $scheduleCount)';
}


}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) = __$TopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, List<String> keywords, bool isActive, String? createdAt,@JsonKey(readValue: _readScheduleCount) int scheduleCount
});




}
/// @nodoc
class __$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? keywords = null,Object? isActive = null,Object? createdAt = freezed,Object? scheduleCount = null,}) {
  return _then(_Topic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,scheduleCount: null == scheduleCount ? _self.scheduleCount : scheduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SuggestedTopic {

 String get name; String get description; List<String> get keywords;
/// Create a copy of SuggestedTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestedTopicCopyWith<SuggestedTopic> get copyWith => _$SuggestedTopicCopyWithImpl<SuggestedTopic>(this as SuggestedTopic, _$identity);

  /// Serializes this SuggestedTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestedTopic&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.keywords, keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(keywords));

@override
String toString() {
  return 'SuggestedTopic(name: $name, description: $description, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class $SuggestedTopicCopyWith<$Res>  {
  factory $SuggestedTopicCopyWith(SuggestedTopic value, $Res Function(SuggestedTopic) _then) = _$SuggestedTopicCopyWithImpl;
@useResult
$Res call({
 String name, String description, List<String> keywords
});




}
/// @nodoc
class _$SuggestedTopicCopyWithImpl<$Res>
    implements $SuggestedTopicCopyWith<$Res> {
  _$SuggestedTopicCopyWithImpl(this._self, this._then);

  final SuggestedTopic _self;
  final $Res Function(SuggestedTopic) _then;

/// Create a copy of SuggestedTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? keywords = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SuggestedTopic].
extension SuggestedTopicPatterns on SuggestedTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuggestedTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuggestedTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuggestedTopic value)  $default,){
final _that = this;
switch (_that) {
case _SuggestedTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuggestedTopic value)?  $default,){
final _that = this;
switch (_that) {
case _SuggestedTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  List<String> keywords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuggestedTopic() when $default != null:
return $default(_that.name,_that.description,_that.keywords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  List<String> keywords)  $default,) {final _that = this;
switch (_that) {
case _SuggestedTopic():
return $default(_that.name,_that.description,_that.keywords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  List<String> keywords)?  $default,) {final _that = this;
switch (_that) {
case _SuggestedTopic() when $default != null:
return $default(_that.name,_that.description,_that.keywords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuggestedTopic implements SuggestedTopic {
  const _SuggestedTopic({this.name = '', this.description = '', final  List<String> keywords = const <String>[]}): _keywords = keywords;
  factory _SuggestedTopic.fromJson(Map<String, dynamic> json) => _$SuggestedTopicFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
 final  List<String> _keywords;
@override@JsonKey() List<String> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}


/// Create a copy of SuggestedTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestedTopicCopyWith<_SuggestedTopic> get copyWith => __$SuggestedTopicCopyWithImpl<_SuggestedTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuggestedTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuggestedTopic&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._keywords, _keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(_keywords));

@override
String toString() {
  return 'SuggestedTopic(name: $name, description: $description, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class _$SuggestedTopicCopyWith<$Res> implements $SuggestedTopicCopyWith<$Res> {
  factory _$SuggestedTopicCopyWith(_SuggestedTopic value, $Res Function(_SuggestedTopic) _then) = __$SuggestedTopicCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, List<String> keywords
});




}
/// @nodoc
class __$SuggestedTopicCopyWithImpl<$Res>
    implements _$SuggestedTopicCopyWith<$Res> {
  __$SuggestedTopicCopyWithImpl(this._self, this._then);

  final _SuggestedTopic _self;
  final $Res Function(_SuggestedTopic) _then;

/// Create a copy of SuggestedTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? keywords = null,}) {
  return _then(_SuggestedTopic(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
