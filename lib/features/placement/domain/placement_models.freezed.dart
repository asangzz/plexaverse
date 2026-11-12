// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'placement_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WritingTask {

 String get prompt; String get hint; int get minChars; int get maxChars;
/// Create a copy of WritingTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingTaskCopyWith<WritingTask> get copyWith => _$WritingTaskCopyWithImpl<WritingTask>(this as WritingTask, _$identity);

  /// Serializes this WritingTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingTask&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.minChars, minChars) || other.minChars == minChars)&&(identical(other.maxChars, maxChars) || other.maxChars == maxChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prompt,hint,minChars,maxChars);

@override
String toString() {
  return 'WritingTask(prompt: $prompt, hint: $hint, minChars: $minChars, maxChars: $maxChars)';
}


}

/// @nodoc
abstract mixin class $WritingTaskCopyWith<$Res>  {
  factory $WritingTaskCopyWith(WritingTask value, $Res Function(WritingTask) _then) = _$WritingTaskCopyWithImpl;
@useResult
$Res call({
 String prompt, String hint, int minChars, int maxChars
});




}
/// @nodoc
class _$WritingTaskCopyWithImpl<$Res>
    implements $WritingTaskCopyWith<$Res> {
  _$WritingTaskCopyWithImpl(this._self, this._then);

  final WritingTask _self;
  final $Res Function(WritingTask) _then;

/// Create a copy of WritingTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompt = null,Object? hint = null,Object? minChars = null,Object? maxChars = null,}) {
  return _then(_self.copyWith(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,minChars: null == minChars ? _self.minChars : minChars // ignore: cast_nullable_to_non_nullable
as int,maxChars: null == maxChars ? _self.maxChars : maxChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingTask].
extension WritingTaskPatterns on WritingTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingTask value)  $default,){
final _that = this;
switch (_that) {
case _WritingTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingTask value)?  $default,){
final _that = this;
switch (_that) {
case _WritingTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String prompt,  String hint,  int minChars,  int maxChars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingTask() when $default != null:
return $default(_that.prompt,_that.hint,_that.minChars,_that.maxChars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String prompt,  String hint,  int minChars,  int maxChars)  $default,) {final _that = this;
switch (_that) {
case _WritingTask():
return $default(_that.prompt,_that.hint,_that.minChars,_that.maxChars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String prompt,  String hint,  int minChars,  int maxChars)?  $default,) {final _that = this;
switch (_that) {
case _WritingTask() when $default != null:
return $default(_that.prompt,_that.hint,_that.minChars,_that.maxChars);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingTask implements WritingTask {
  const _WritingTask({this.prompt = '', this.hint = '', this.minChars = 30, this.maxChars = 1200});
  factory _WritingTask.fromJson(Map<String, dynamic> json) => _$WritingTaskFromJson(json);

@override@JsonKey() final  String prompt;
@override@JsonKey() final  String hint;
@override@JsonKey() final  int minChars;
@override@JsonKey() final  int maxChars;

/// Create a copy of WritingTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingTaskCopyWith<_WritingTask> get copyWith => __$WritingTaskCopyWithImpl<_WritingTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingTask&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.minChars, minChars) || other.minChars == minChars)&&(identical(other.maxChars, maxChars) || other.maxChars == maxChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prompt,hint,minChars,maxChars);

@override
String toString() {
  return 'WritingTask(prompt: $prompt, hint: $hint, minChars: $minChars, maxChars: $maxChars)';
}


}

/// @nodoc
abstract mixin class _$WritingTaskCopyWith<$Res> implements $WritingTaskCopyWith<$Res> {
  factory _$WritingTaskCopyWith(_WritingTask value, $Res Function(_WritingTask) _then) = __$WritingTaskCopyWithImpl;
@override @useResult
$Res call({
 String prompt, String hint, int minChars, int maxChars
});




}
/// @nodoc
class __$WritingTaskCopyWithImpl<$Res>
    implements _$WritingTaskCopyWith<$Res> {
  __$WritingTaskCopyWithImpl(this._self, this._then);

  final _WritingTask _self;
  final $Res Function(_WritingTask) _then;

/// Create a copy of WritingTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompt = null,Object? hint = null,Object? minChars = null,Object? maxChars = null,}) {
  return _then(_WritingTask(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,minChars: null == minChars ? _self.minChars : minChars // ignore: cast_nullable_to_non_nullable
as int,maxChars: null == maxChars ? _self.maxChars : maxChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PublicPlacementItem {

/// The handle for THIS question in THIS attempt (`step-N`), not a bank
/// id. Never built or parsed here.
 String get id;@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? get skill;/// Reading questions only.
 String? get passage; String get prompt;/// Four, in the bank's order — placement options are not shuffled,
/// unlike the lesson's. The answer goes back as the option's TEXT.
 List<String> get options;
/// Create a copy of PublicPlacementItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicPlacementItemCopyWith<PublicPlacementItem> get copyWith => _$PublicPlacementItemCopyWithImpl<PublicPlacementItem>(this as PublicPlacementItem, _$identity);

  /// Serializes this PublicPlacementItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicPlacementItem&&(identical(other.id, id) || other.id == id)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,skill,passage,prompt,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'PublicPlacementItem(id: $id, skill: $skill, passage: $passage, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class $PublicPlacementItemCopyWith<$Res>  {
  factory $PublicPlacementItemCopyWith(PublicPlacementItem value, $Res Function(PublicPlacementItem) _then) = _$PublicPlacementItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? skill, String? passage, String prompt, List<String> options
});




}
/// @nodoc
class _$PublicPlacementItemCopyWithImpl<$Res>
    implements $PublicPlacementItemCopyWith<$Res> {
  _$PublicPlacementItemCopyWithImpl(this._self, this._then);

  final PublicPlacementItem _self;
  final $Res Function(PublicPlacementItem) _then;

/// Create a copy of PublicPlacementItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? skill = freezed,Object? passage = freezed,Object? prompt = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,skill: freezed == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as ObjectiveSkill?,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicPlacementItem].
extension PublicPlacementItemPatterns on PublicPlacementItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicPlacementItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicPlacementItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicPlacementItem value)  $default,){
final _that = this;
switch (_that) {
case _PublicPlacementItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicPlacementItem value)?  $default,){
final _that = this;
switch (_that) {
case _PublicPlacementItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  String? passage,  String prompt,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicPlacementItem() when $default != null:
return $default(_that.id,_that.skill,_that.passage,_that.prompt,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  String? passage,  String prompt,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _PublicPlacementItem():
return $default(_that.id,_that.skill,_that.passage,_that.prompt,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  String? passage,  String prompt,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _PublicPlacementItem() when $default != null:
return $default(_that.id,_that.skill,_that.passage,_that.prompt,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicPlacementItem implements PublicPlacementItem {
  const _PublicPlacementItem({this.id = '', @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) this.skill, this.passage, this.prompt = '', final  List<String> options = const <String>[]}): _options = options;
  factory _PublicPlacementItem.fromJson(Map<String, dynamic> json) => _$PublicPlacementItemFromJson(json);

/// The handle for THIS question in THIS attempt (`step-N`), not a bank
/// id. Never built or parsed here.
@override@JsonKey() final  String id;
@override@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) final  ObjectiveSkill? skill;
/// Reading questions only.
@override final  String? passage;
@override@JsonKey() final  String prompt;
/// Four, in the bank's order — placement options are not shuffled,
/// unlike the lesson's. The answer goes back as the option's TEXT.
 final  List<String> _options;
/// Four, in the bank's order — placement options are not shuffled,
/// unlike the lesson's. The answer goes back as the option's TEXT.
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of PublicPlacementItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicPlacementItemCopyWith<_PublicPlacementItem> get copyWith => __$PublicPlacementItemCopyWithImpl<_PublicPlacementItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicPlacementItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicPlacementItem&&(identical(other.id, id) || other.id == id)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,skill,passage,prompt,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PublicPlacementItem(id: $id, skill: $skill, passage: $passage, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PublicPlacementItemCopyWith<$Res> implements $PublicPlacementItemCopyWith<$Res> {
  factory _$PublicPlacementItemCopyWith(_PublicPlacementItem value, $Res Function(_PublicPlacementItem) _then) = __$PublicPlacementItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? skill, String? passage, String prompt, List<String> options
});




}
/// @nodoc
class __$PublicPlacementItemCopyWithImpl<$Res>
    implements _$PublicPlacementItemCopyWith<$Res> {
  __$PublicPlacementItemCopyWithImpl(this._self, this._then);

  final _PublicPlacementItem _self;
  final $Res Function(_PublicPlacementItem) _then;

/// Create a copy of PublicPlacementItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? skill = freezed,Object? passage = freezed,Object? prompt = null,Object? options = null,}) {
  return _then(_PublicPlacementItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,skill: freezed == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as ObjectiveSkill?,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlacementMeasured {

 bool get vocabulary; bool get grammar; bool get reading;
/// Create a copy of PlacementMeasured
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementMeasuredCopyWith<PlacementMeasured> get copyWith => _$PlacementMeasuredCopyWithImpl<PlacementMeasured>(this as PlacementMeasured, _$identity);

  /// Serializes this PlacementMeasured to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementMeasured&&(identical(other.vocabulary, vocabulary) || other.vocabulary == vocabulary)&&(identical(other.grammar, grammar) || other.grammar == grammar)&&(identical(other.reading, reading) || other.reading == reading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vocabulary,grammar,reading);

@override
String toString() {
  return 'PlacementMeasured(vocabulary: $vocabulary, grammar: $grammar, reading: $reading)';
}


}

/// @nodoc
abstract mixin class $PlacementMeasuredCopyWith<$Res>  {
  factory $PlacementMeasuredCopyWith(PlacementMeasured value, $Res Function(PlacementMeasured) _then) = _$PlacementMeasuredCopyWithImpl;
@useResult
$Res call({
 bool vocabulary, bool grammar, bool reading
});




}
/// @nodoc
class _$PlacementMeasuredCopyWithImpl<$Res>
    implements $PlacementMeasuredCopyWith<$Res> {
  _$PlacementMeasuredCopyWithImpl(this._self, this._then);

  final PlacementMeasured _self;
  final $Res Function(PlacementMeasured) _then;

/// Create a copy of PlacementMeasured
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vocabulary = null,Object? grammar = null,Object? reading = null,}) {
  return _then(_self.copyWith(
vocabulary: null == vocabulary ? _self.vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as bool,grammar: null == grammar ? _self.grammar : grammar // ignore: cast_nullable_to_non_nullable
as bool,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlacementMeasured].
extension PlacementMeasuredPatterns on PlacementMeasured {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementMeasured value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementMeasured() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementMeasured value)  $default,){
final _that = this;
switch (_that) {
case _PlacementMeasured():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementMeasured value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementMeasured() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool vocabulary,  bool grammar,  bool reading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementMeasured() when $default != null:
return $default(_that.vocabulary,_that.grammar,_that.reading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool vocabulary,  bool grammar,  bool reading)  $default,) {final _that = this;
switch (_that) {
case _PlacementMeasured():
return $default(_that.vocabulary,_that.grammar,_that.reading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool vocabulary,  bool grammar,  bool reading)?  $default,) {final _that = this;
switch (_that) {
case _PlacementMeasured() when $default != null:
return $default(_that.vocabulary,_that.grammar,_that.reading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementMeasured extends PlacementMeasured {
  const _PlacementMeasured({this.vocabulary = true, this.grammar = true, this.reading = true}): super._();
  factory _PlacementMeasured.fromJson(Map<String, dynamic> json) => _$PlacementMeasuredFromJson(json);

@override@JsonKey() final  bool vocabulary;
@override@JsonKey() final  bool grammar;
@override@JsonKey() final  bool reading;

/// Create a copy of PlacementMeasured
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementMeasuredCopyWith<_PlacementMeasured> get copyWith => __$PlacementMeasuredCopyWithImpl<_PlacementMeasured>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementMeasuredToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementMeasured&&(identical(other.vocabulary, vocabulary) || other.vocabulary == vocabulary)&&(identical(other.grammar, grammar) || other.grammar == grammar)&&(identical(other.reading, reading) || other.reading == reading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vocabulary,grammar,reading);

@override
String toString() {
  return 'PlacementMeasured(vocabulary: $vocabulary, grammar: $grammar, reading: $reading)';
}


}

/// @nodoc
abstract mixin class _$PlacementMeasuredCopyWith<$Res> implements $PlacementMeasuredCopyWith<$Res> {
  factory _$PlacementMeasuredCopyWith(_PlacementMeasured value, $Res Function(_PlacementMeasured) _then) = __$PlacementMeasuredCopyWithImpl;
@override @useResult
$Res call({
 bool vocabulary, bool grammar, bool reading
});




}
/// @nodoc
class __$PlacementMeasuredCopyWithImpl<$Res>
    implements _$PlacementMeasuredCopyWith<$Res> {
  __$PlacementMeasuredCopyWithImpl(this._self, this._then);

  final _PlacementMeasured _self;
  final $Res Function(_PlacementMeasured) _then;

/// Create a copy of PlacementMeasured
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vocabulary = null,Object? grammar = null,Object? reading = null,}) {
  return _then(_PlacementMeasured(
vocabulary: null == vocabulary ? _self.vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as bool,grammar: null == grammar ? _self.grammar : grammar // ignore: cast_nullable_to_non_nullable
as bool,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WritingFeedback {

 List<String> get strengths; List<String> get improvements;
/// Create a copy of WritingFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingFeedbackCopyWith<WritingFeedback> get copyWith => _$WritingFeedbackCopyWithImpl<WritingFeedback>(this as WritingFeedback, _$identity);

  /// Serializes this WritingFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingFeedback&&const DeepCollectionEquality().equals(other.strengths, strengths)&&const DeepCollectionEquality().equals(other.improvements, improvements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(strengths),const DeepCollectionEquality().hash(improvements));

@override
String toString() {
  return 'WritingFeedback(strengths: $strengths, improvements: $improvements)';
}


}

/// @nodoc
abstract mixin class $WritingFeedbackCopyWith<$Res>  {
  factory $WritingFeedbackCopyWith(WritingFeedback value, $Res Function(WritingFeedback) _then) = _$WritingFeedbackCopyWithImpl;
@useResult
$Res call({
 List<String> strengths, List<String> improvements
});




}
/// @nodoc
class _$WritingFeedbackCopyWithImpl<$Res>
    implements $WritingFeedbackCopyWith<$Res> {
  _$WritingFeedbackCopyWithImpl(this._self, this._then);

  final WritingFeedback _self;
  final $Res Function(WritingFeedback) _then;

/// Create a copy of WritingFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? strengths = null,Object? improvements = null,}) {
  return _then(_self.copyWith(
strengths: null == strengths ? _self.strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<String>,improvements: null == improvements ? _self.improvements : improvements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingFeedback].
extension WritingFeedbackPatterns on WritingFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingFeedback value)  $default,){
final _that = this;
switch (_that) {
case _WritingFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _WritingFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> strengths,  List<String> improvements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingFeedback() when $default != null:
return $default(_that.strengths,_that.improvements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> strengths,  List<String> improvements)  $default,) {final _that = this;
switch (_that) {
case _WritingFeedback():
return $default(_that.strengths,_that.improvements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> strengths,  List<String> improvements)?  $default,) {final _that = this;
switch (_that) {
case _WritingFeedback() when $default != null:
return $default(_that.strengths,_that.improvements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingFeedback extends WritingFeedback {
  const _WritingFeedback({final  List<String> strengths = const <String>[], final  List<String> improvements = const <String>[]}): _strengths = strengths,_improvements = improvements,super._();
  factory _WritingFeedback.fromJson(Map<String, dynamic> json) => _$WritingFeedbackFromJson(json);

 final  List<String> _strengths;
@override@JsonKey() List<String> get strengths {
  if (_strengths is EqualUnmodifiableListView) return _strengths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strengths);
}

 final  List<String> _improvements;
@override@JsonKey() List<String> get improvements {
  if (_improvements is EqualUnmodifiableListView) return _improvements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_improvements);
}


/// Create a copy of WritingFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingFeedbackCopyWith<_WritingFeedback> get copyWith => __$WritingFeedbackCopyWithImpl<_WritingFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingFeedback&&const DeepCollectionEquality().equals(other._strengths, _strengths)&&const DeepCollectionEquality().equals(other._improvements, _improvements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_strengths),const DeepCollectionEquality().hash(_improvements));

@override
String toString() {
  return 'WritingFeedback(strengths: $strengths, improvements: $improvements)';
}


}

/// @nodoc
abstract mixin class _$WritingFeedbackCopyWith<$Res> implements $WritingFeedbackCopyWith<$Res> {
  factory _$WritingFeedbackCopyWith(_WritingFeedback value, $Res Function(_WritingFeedback) _then) = __$WritingFeedbackCopyWithImpl;
@override @useResult
$Res call({
 List<String> strengths, List<String> improvements
});




}
/// @nodoc
class __$WritingFeedbackCopyWithImpl<$Res>
    implements _$WritingFeedbackCopyWith<$Res> {
  __$WritingFeedbackCopyWithImpl(this._self, this._then);

  final _WritingFeedback _self;
  final $Res Function(_WritingFeedback) _then;

/// Create a copy of WritingFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? strengths = null,Object? improvements = null,}) {
  return _then(_WritingFeedback(
strengths: null == strengths ? _self._strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<String>,improvements: null == improvements ? _self._improvements : improvements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlacementInProgress {

 String get attemptId; int get answered;/// When it closes on what it holds if nothing more is answered: 24 hours
/// after the last answer, never later than 48 hours after the start.
@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? get closesAt;
/// Create a copy of PlacementInProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementInProgressCopyWith<PlacementInProgress> get copyWith => _$PlacementInProgressCopyWithImpl<PlacementInProgress>(this as PlacementInProgress, _$identity);

  /// Serializes this PlacementInProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementInProgress&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,answered,closesAt);

@override
String toString() {
  return 'PlacementInProgress(attemptId: $attemptId, answered: $answered, closesAt: $closesAt)';
}


}

/// @nodoc
abstract mixin class $PlacementInProgressCopyWith<$Res>  {
  factory $PlacementInProgressCopyWith(PlacementInProgress value, $Res Function(PlacementInProgress) _then) = _$PlacementInProgressCopyWithImpl;
@useResult
$Res call({
 String attemptId, int answered,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt
});




}
/// @nodoc
class _$PlacementInProgressCopyWithImpl<$Res>
    implements $PlacementInProgressCopyWith<$Res> {
  _$PlacementInProgressCopyWithImpl(this._self, this._then);

  final PlacementInProgress _self;
  final $Res Function(PlacementInProgress) _then;

/// Create a copy of PlacementInProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? answered = null,Object? closesAt = freezed,}) {
  return _then(_self.copyWith(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlacementInProgress].
extension PlacementInProgressPatterns on PlacementInProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementInProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementInProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementInProgress value)  $default,){
final _that = this;
switch (_that) {
case _PlacementInProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementInProgress value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementInProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attemptId,  int answered, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementInProgress() when $default != null:
return $default(_that.attemptId,_that.answered,_that.closesAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attemptId,  int answered, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)  $default,) {final _that = this;
switch (_that) {
case _PlacementInProgress():
return $default(_that.attemptId,_that.answered,_that.closesAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attemptId,  int answered, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)?  $default,) {final _that = this;
switch (_that) {
case _PlacementInProgress() when $default != null:
return $default(_that.attemptId,_that.answered,_that.closesAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementInProgress implements PlacementInProgress {
  const _PlacementInProgress({this.attemptId = '', this.answered = 0, @JsonKey(fromJson: _instant, toJson: _instantWire) this.closesAt});
  factory _PlacementInProgress.fromJson(Map<String, dynamic> json) => _$PlacementInProgressFromJson(json);

@override@JsonKey() final  String attemptId;
@override@JsonKey() final  int answered;
/// When it closes on what it holds if nothing more is answered: 24 hours
/// after the last answer, never later than 48 hours after the start.
@override@JsonKey(fromJson: _instant, toJson: _instantWire) final  DateTime? closesAt;

/// Create a copy of PlacementInProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementInProgressCopyWith<_PlacementInProgress> get copyWith => __$PlacementInProgressCopyWithImpl<_PlacementInProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementInProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementInProgress&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,answered,closesAt);

@override
String toString() {
  return 'PlacementInProgress(attemptId: $attemptId, answered: $answered, closesAt: $closesAt)';
}


}

/// @nodoc
abstract mixin class _$PlacementInProgressCopyWith<$Res> implements $PlacementInProgressCopyWith<$Res> {
  factory _$PlacementInProgressCopyWith(_PlacementInProgress value, $Res Function(_PlacementInProgress) _then) = __$PlacementInProgressCopyWithImpl;
@override @useResult
$Res call({
 String attemptId, int answered,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt
});




}
/// @nodoc
class __$PlacementInProgressCopyWithImpl<$Res>
    implements _$PlacementInProgressCopyWith<$Res> {
  __$PlacementInProgressCopyWithImpl(this._self, this._then);

  final _PlacementInProgress _self;
  final $Res Function(_PlacementInProgress) _then;

/// Create a copy of PlacementInProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? answered = null,Object? closesAt = freezed,}) {
  return _then(_PlacementInProgress(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PlacementSummary {

 String get attemptId;@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? get completedAt;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get band;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get vocabularyBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get grammarBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get readingBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get writingBand; WritingFeedback? get writingFeedback;/// The three parts are done and no writing has been sent: the optional
/// writing step can still be taken for this result.
 bool get writingPending;/// Closed on what it held after the learner walked away, rather than
/// finished.
 bool get closedEarly; PlacementMeasured get measured;
/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementSummaryCopyWith<PlacementSummary> get copyWith => _$PlacementSummaryCopyWithImpl<PlacementSummary>(this as PlacementSummary, _$identity);

  /// Serializes this PlacementSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementSummary&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.band, band) || other.band == band)&&(identical(other.vocabularyBand, vocabularyBand) || other.vocabularyBand == vocabularyBand)&&(identical(other.grammarBand, grammarBand) || other.grammarBand == grammarBand)&&(identical(other.readingBand, readingBand) || other.readingBand == readingBand)&&(identical(other.writingBand, writingBand) || other.writingBand == writingBand)&&(identical(other.writingFeedback, writingFeedback) || other.writingFeedback == writingFeedback)&&(identical(other.writingPending, writingPending) || other.writingPending == writingPending)&&(identical(other.closedEarly, closedEarly) || other.closedEarly == closedEarly)&&(identical(other.measured, measured) || other.measured == measured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,completedAt,band,vocabularyBand,grammarBand,readingBand,writingBand,writingFeedback,writingPending,closedEarly,measured);

@override
String toString() {
  return 'PlacementSummary(attemptId: $attemptId, completedAt: $completedAt, band: $band, vocabularyBand: $vocabularyBand, grammarBand: $grammarBand, readingBand: $readingBand, writingBand: $writingBand, writingFeedback: $writingFeedback, writingPending: $writingPending, closedEarly: $closedEarly, measured: $measured)';
}


}

/// @nodoc
abstract mixin class $PlacementSummaryCopyWith<$Res>  {
  factory $PlacementSummaryCopyWith(PlacementSummary value, $Res Function(PlacementSummary) _then) = _$PlacementSummaryCopyWithImpl;
@useResult
$Res call({
 String attemptId,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? vocabularyBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand, WritingFeedback? writingFeedback, bool writingPending, bool closedEarly, PlacementMeasured measured
});


$WritingFeedbackCopyWith<$Res>? get writingFeedback;$PlacementMeasuredCopyWith<$Res> get measured;

}
/// @nodoc
class _$PlacementSummaryCopyWithImpl<$Res>
    implements $PlacementSummaryCopyWith<$Res> {
  _$PlacementSummaryCopyWithImpl(this._self, this._then);

  final PlacementSummary _self;
  final $Res Function(PlacementSummary) _then;

/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? completedAt = freezed,Object? band = freezed,Object? vocabularyBand = freezed,Object? grammarBand = freezed,Object? readingBand = freezed,Object? writingBand = freezed,Object? writingFeedback = freezed,Object? writingPending = null,Object? closedEarly = null,Object? measured = null,}) {
  return _then(_self.copyWith(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand?,vocabularyBand: freezed == vocabularyBand ? _self.vocabularyBand : vocabularyBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,grammarBand: freezed == grammarBand ? _self.grammarBand : grammarBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,readingBand: freezed == readingBand ? _self.readingBand : readingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingBand: freezed == writingBand ? _self.writingBand : writingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingFeedback: freezed == writingFeedback ? _self.writingFeedback : writingFeedback // ignore: cast_nullable_to_non_nullable
as WritingFeedback?,writingPending: null == writingPending ? _self.writingPending : writingPending // ignore: cast_nullable_to_non_nullable
as bool,closedEarly: null == closedEarly ? _self.closedEarly : closedEarly // ignore: cast_nullable_to_non_nullable
as bool,measured: null == measured ? _self.measured : measured // ignore: cast_nullable_to_non_nullable
as PlacementMeasured,
  ));
}
/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingFeedbackCopyWith<$Res>? get writingFeedback {
    if (_self.writingFeedback == null) {
    return null;
  }

  return $WritingFeedbackCopyWith<$Res>(_self.writingFeedback!, (value) {
    return _then(_self.copyWith(writingFeedback: value));
  });
}/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementMeasuredCopyWith<$Res> get measured {
  
  return $PlacementMeasuredCopyWith<$Res>(_self.measured, (value) {
    return _then(_self.copyWith(measured: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlacementSummary].
extension PlacementSummaryPatterns on PlacementSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementSummary value)  $default,){
final _that = this;
switch (_that) {
case _PlacementSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attemptId, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingPending,  bool closedEarly,  PlacementMeasured measured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementSummary() when $default != null:
return $default(_that.attemptId,_that.completedAt,_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingPending,_that.closedEarly,_that.measured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attemptId, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingPending,  bool closedEarly,  PlacementMeasured measured)  $default,) {final _that = this;
switch (_that) {
case _PlacementSummary():
return $default(_that.attemptId,_that.completedAt,_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingPending,_that.closedEarly,_that.measured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attemptId, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingPending,  bool closedEarly,  PlacementMeasured measured)?  $default,) {final _that = this;
switch (_that) {
case _PlacementSummary() when $default != null:
return $default(_that.attemptId,_that.completedAt,_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingPending,_that.closedEarly,_that.measured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementSummary extends PlacementSummary {
  const _PlacementSummary({this.attemptId = '', @JsonKey(fromJson: _instant, toJson: _instantWire) this.completedAt, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.writingBand, this.writingFeedback, this.writingPending = false, this.closedEarly = false, this.measured = const PlacementMeasured()}): super._();
  factory _PlacementSummary.fromJson(Map<String, dynamic> json) => _$PlacementSummaryFromJson(json);

@override@JsonKey() final  String attemptId;
@override@JsonKey(fromJson: _instant, toJson: _instantWire) final  DateTime? completedAt;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? band;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? vocabularyBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? grammarBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? readingBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? writingBand;
@override final  WritingFeedback? writingFeedback;
/// The three parts are done and no writing has been sent: the optional
/// writing step can still be taken for this result.
@override@JsonKey() final  bool writingPending;
/// Closed on what it held after the learner walked away, rather than
/// finished.
@override@JsonKey() final  bool closedEarly;
@override@JsonKey() final  PlacementMeasured measured;

/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementSummaryCopyWith<_PlacementSummary> get copyWith => __$PlacementSummaryCopyWithImpl<_PlacementSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementSummary&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.band, band) || other.band == band)&&(identical(other.vocabularyBand, vocabularyBand) || other.vocabularyBand == vocabularyBand)&&(identical(other.grammarBand, grammarBand) || other.grammarBand == grammarBand)&&(identical(other.readingBand, readingBand) || other.readingBand == readingBand)&&(identical(other.writingBand, writingBand) || other.writingBand == writingBand)&&(identical(other.writingFeedback, writingFeedback) || other.writingFeedback == writingFeedback)&&(identical(other.writingPending, writingPending) || other.writingPending == writingPending)&&(identical(other.closedEarly, closedEarly) || other.closedEarly == closedEarly)&&(identical(other.measured, measured) || other.measured == measured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,completedAt,band,vocabularyBand,grammarBand,readingBand,writingBand,writingFeedback,writingPending,closedEarly,measured);

@override
String toString() {
  return 'PlacementSummary(attemptId: $attemptId, completedAt: $completedAt, band: $band, vocabularyBand: $vocabularyBand, grammarBand: $grammarBand, readingBand: $readingBand, writingBand: $writingBand, writingFeedback: $writingFeedback, writingPending: $writingPending, closedEarly: $closedEarly, measured: $measured)';
}


}

/// @nodoc
abstract mixin class _$PlacementSummaryCopyWith<$Res> implements $PlacementSummaryCopyWith<$Res> {
  factory _$PlacementSummaryCopyWith(_PlacementSummary value, $Res Function(_PlacementSummary) _then) = __$PlacementSummaryCopyWithImpl;
@override @useResult
$Res call({
 String attemptId,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? vocabularyBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand, WritingFeedback? writingFeedback, bool writingPending, bool closedEarly, PlacementMeasured measured
});


@override $WritingFeedbackCopyWith<$Res>? get writingFeedback;@override $PlacementMeasuredCopyWith<$Res> get measured;

}
/// @nodoc
class __$PlacementSummaryCopyWithImpl<$Res>
    implements _$PlacementSummaryCopyWith<$Res> {
  __$PlacementSummaryCopyWithImpl(this._self, this._then);

  final _PlacementSummary _self;
  final $Res Function(_PlacementSummary) _then;

/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? completedAt = freezed,Object? band = freezed,Object? vocabularyBand = freezed,Object? grammarBand = freezed,Object? readingBand = freezed,Object? writingBand = freezed,Object? writingFeedback = freezed,Object? writingPending = null,Object? closedEarly = null,Object? measured = null,}) {
  return _then(_PlacementSummary(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand?,vocabularyBand: freezed == vocabularyBand ? _self.vocabularyBand : vocabularyBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,grammarBand: freezed == grammarBand ? _self.grammarBand : grammarBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,readingBand: freezed == readingBand ? _self.readingBand : readingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingBand: freezed == writingBand ? _self.writingBand : writingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingFeedback: freezed == writingFeedback ? _self.writingFeedback : writingFeedback // ignore: cast_nullable_to_non_nullable
as WritingFeedback?,writingPending: null == writingPending ? _self.writingPending : writingPending // ignore: cast_nullable_to_non_nullable
as bool,closedEarly: null == closedEarly ? _self.closedEarly : closedEarly // ignore: cast_nullable_to_non_nullable
as bool,measured: null == measured ? _self.measured : measured // ignore: cast_nullable_to_non_nullable
as PlacementMeasured,
  ));
}

/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingFeedbackCopyWith<$Res>? get writingFeedback {
    if (_self.writingFeedback == null) {
    return null;
  }

  return $WritingFeedbackCopyWith<$Res>(_self.writingFeedback!, (value) {
    return _then(_self.copyWith(writingFeedback: value));
  });
}/// Create a copy of PlacementSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementMeasuredCopyWith<$Res> get measured {
  
  return $PlacementMeasuredCopyWith<$Res>(_self.measured, (value) {
    return _then(_self.copyWith(measured: value));
  });
}
}


/// @nodoc
mixin _$PlacementStatus {

/// The band lessons are written at now. The server reports
/// [defaultBand] until a test completes, so a missing value reads as it
/// would have.
@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire) CefrBand get band; bool get hasPlacement; PlacementSummary? get latest;/// Open as of this read, not for good — see [PlacementInProgress.closesAt].
 PlacementInProgress? get inProgress;/// False only during the 30-day cooldown with nothing open.
 bool get canStart;@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? get nextRetakeAt;/// The learner has agreed to their writing being sent to a model
/// (`assessment_grading`), so the writing step need not ask.
 bool get writingConsent;
/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementStatusCopyWith<PlacementStatus> get copyWith => _$PlacementStatusCopyWithImpl<PlacementStatus>(this as PlacementStatus, _$identity);

  /// Serializes this PlacementStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementStatus&&(identical(other.band, band) || other.band == band)&&(identical(other.hasPlacement, hasPlacement) || other.hasPlacement == hasPlacement)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.canStart, canStart) || other.canStart == canStart)&&(identical(other.nextRetakeAt, nextRetakeAt) || other.nextRetakeAt == nextRetakeAt)&&(identical(other.writingConsent, writingConsent) || other.writingConsent == writingConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,hasPlacement,latest,inProgress,canStart,nextRetakeAt,writingConsent);

@override
String toString() {
  return 'PlacementStatus(band: $band, hasPlacement: $hasPlacement, latest: $latest, inProgress: $inProgress, canStart: $canStart, nextRetakeAt: $nextRetakeAt, writingConsent: $writingConsent)';
}


}

/// @nodoc
abstract mixin class $PlacementStatusCopyWith<$Res>  {
  factory $PlacementStatusCopyWith(PlacementStatus value, $Res Function(PlacementStatus) _then) = _$PlacementStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire) CefrBand band, bool hasPlacement, PlacementSummary? latest, PlacementInProgress? inProgress, bool canStart,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? nextRetakeAt, bool writingConsent
});


$PlacementSummaryCopyWith<$Res>? get latest;$PlacementInProgressCopyWith<$Res>? get inProgress;

}
/// @nodoc
class _$PlacementStatusCopyWithImpl<$Res>
    implements $PlacementStatusCopyWith<$Res> {
  _$PlacementStatusCopyWithImpl(this._self, this._then);

  final PlacementStatus _self;
  final $Res Function(PlacementStatus) _then;

/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? band = null,Object? hasPlacement = null,Object? latest = freezed,Object? inProgress = freezed,Object? canStart = null,Object? nextRetakeAt = freezed,Object? writingConsent = null,}) {
  return _then(_self.copyWith(
band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand,hasPlacement: null == hasPlacement ? _self.hasPlacement : hasPlacement // ignore: cast_nullable_to_non_nullable
as bool,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PlacementSummary?,inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as PlacementInProgress?,canStart: null == canStart ? _self.canStart : canStart // ignore: cast_nullable_to_non_nullable
as bool,nextRetakeAt: freezed == nextRetakeAt ? _self.nextRetakeAt : nextRetakeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,writingConsent: null == writingConsent ? _self.writingConsent : writingConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementSummaryCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $PlacementSummaryCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementInProgressCopyWith<$Res>? get inProgress {
    if (_self.inProgress == null) {
    return null;
  }

  return $PlacementInProgressCopyWith<$Res>(_self.inProgress!, (value) {
    return _then(_self.copyWith(inProgress: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlacementStatus].
extension PlacementStatusPatterns on PlacementStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementStatus value)  $default,){
final _that = this;
switch (_that) {
case _PlacementStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire)  CefrBand band,  bool hasPlacement,  PlacementSummary? latest,  PlacementInProgress? inProgress,  bool canStart, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? nextRetakeAt,  bool writingConsent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementStatus() when $default != null:
return $default(_that.band,_that.hasPlacement,_that.latest,_that.inProgress,_that.canStart,_that.nextRetakeAt,_that.writingConsent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire)  CefrBand band,  bool hasPlacement,  PlacementSummary? latest,  PlacementInProgress? inProgress,  bool canStart, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? nextRetakeAt,  bool writingConsent)  $default,) {final _that = this;
switch (_that) {
case _PlacementStatus():
return $default(_that.band,_that.hasPlacement,_that.latest,_that.inProgress,_that.canStart,_that.nextRetakeAt,_that.writingConsent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire)  CefrBand band,  bool hasPlacement,  PlacementSummary? latest,  PlacementInProgress? inProgress,  bool canStart, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? nextRetakeAt,  bool writingConsent)?  $default,) {final _that = this;
switch (_that) {
case _PlacementStatus() when $default != null:
return $default(_that.band,_that.hasPlacement,_that.latest,_that.inProgress,_that.canStart,_that.nextRetakeAt,_that.writingConsent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementStatus implements PlacementStatus {
  const _PlacementStatus({@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire) this.band = defaultBand, this.hasPlacement = false, this.latest, this.inProgress, this.canStart = true, @JsonKey(fromJson: _instant, toJson: _instantWire) this.nextRetakeAt, this.writingConsent = false});
  factory _PlacementStatus.fromJson(Map<String, dynamic> json) => _$PlacementStatusFromJson(json);

/// The band lessons are written at now. The server reports
/// [defaultBand] until a test completes, so a missing value reads as it
/// would have.
@override@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire) final  CefrBand band;
@override@JsonKey() final  bool hasPlacement;
@override final  PlacementSummary? latest;
/// Open as of this read, not for good — see [PlacementInProgress.closesAt].
@override final  PlacementInProgress? inProgress;
/// False only during the 30-day cooldown with nothing open.
@override@JsonKey() final  bool canStart;
@override@JsonKey(fromJson: _instant, toJson: _instantWire) final  DateTime? nextRetakeAt;
/// The learner has agreed to their writing being sent to a model
/// (`assessment_grading`), so the writing step need not ask.
@override@JsonKey() final  bool writingConsent;

/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementStatusCopyWith<_PlacementStatus> get copyWith => __$PlacementStatusCopyWithImpl<_PlacementStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementStatus&&(identical(other.band, band) || other.band == band)&&(identical(other.hasPlacement, hasPlacement) || other.hasPlacement == hasPlacement)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.canStart, canStart) || other.canStart == canStart)&&(identical(other.nextRetakeAt, nextRetakeAt) || other.nextRetakeAt == nextRetakeAt)&&(identical(other.writingConsent, writingConsent) || other.writingConsent == writingConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,hasPlacement,latest,inProgress,canStart,nextRetakeAt,writingConsent);

@override
String toString() {
  return 'PlacementStatus(band: $band, hasPlacement: $hasPlacement, latest: $latest, inProgress: $inProgress, canStart: $canStart, nextRetakeAt: $nextRetakeAt, writingConsent: $writingConsent)';
}


}

/// @nodoc
abstract mixin class _$PlacementStatusCopyWith<$Res> implements $PlacementStatusCopyWith<$Res> {
  factory _$PlacementStatusCopyWith(_PlacementStatus value, $Res Function(_PlacementStatus) _then) = __$PlacementStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _bandOrDefault, toJson: _bandWire) CefrBand band, bool hasPlacement, PlacementSummary? latest, PlacementInProgress? inProgress, bool canStart,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? nextRetakeAt, bool writingConsent
});


@override $PlacementSummaryCopyWith<$Res>? get latest;@override $PlacementInProgressCopyWith<$Res>? get inProgress;

}
/// @nodoc
class __$PlacementStatusCopyWithImpl<$Res>
    implements _$PlacementStatusCopyWith<$Res> {
  __$PlacementStatusCopyWithImpl(this._self, this._then);

  final _PlacementStatus _self;
  final $Res Function(_PlacementStatus) _then;

/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? band = null,Object? hasPlacement = null,Object? latest = freezed,Object? inProgress = freezed,Object? canStart = null,Object? nextRetakeAt = freezed,Object? writingConsent = null,}) {
  return _then(_PlacementStatus(
band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand,hasPlacement: null == hasPlacement ? _self.hasPlacement : hasPlacement // ignore: cast_nullable_to_non_nullable
as bool,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as PlacementSummary?,inProgress: freezed == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as PlacementInProgress?,canStart: null == canStart ? _self.canStart : canStart // ignore: cast_nullable_to_non_nullable
as bool,nextRetakeAt: freezed == nextRetakeAt ? _self.nextRetakeAt : nextRetakeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,writingConsent: null == writingConsent ? _self.writingConsent : writingConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementSummaryCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $PlacementSummaryCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}/// Create a copy of PlacementStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementInProgressCopyWith<$Res>? get inProgress {
    if (_self.inProgress == null) {
    return null;
  }

  return $PlacementInProgressCopyWith<$Res>(_self.inProgress!, (value) {
    return _then(_self.copyWith(inProgress: value));
  });
}
}


/// @nodoc
mixin _$PlacementStep {

 String get attemptId;@JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire) PlacementStage get stage;/// The part being tested. Null at the writing stage.
@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? get skill;/// Null at the writing stage.
 PublicPlacementItem? get item; int get answered;/// A progress figure, not a promise: the staircase decides the real
/// length.
 int get estimatedTotal;/// Set at the writing stage only.
 WritingTask? get writingTask;/// The same instant [PlacementInProgress.closesAt] reports; it moves with
/// each answer, up to the two-day cap. Null at the writing stage.
@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? get closesAt;
/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementStepCopyWith<PlacementStep> get copyWith => _$PlacementStepCopyWithImpl<PlacementStep>(this as PlacementStep, _$identity);

  /// Serializes this PlacementStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementStep&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.item, item) || other.item == item)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&(identical(other.writingTask, writingTask) || other.writingTask == writingTask)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,stage,skill,item,answered,estimatedTotal,writingTask,closesAt);

@override
String toString() {
  return 'PlacementStep(attemptId: $attemptId, stage: $stage, skill: $skill, item: $item, answered: $answered, estimatedTotal: $estimatedTotal, writingTask: $writingTask, closesAt: $closesAt)';
}


}

/// @nodoc
abstract mixin class $PlacementStepCopyWith<$Res>  {
  factory $PlacementStepCopyWith(PlacementStep value, $Res Function(PlacementStep) _then) = _$PlacementStepCopyWithImpl;
@useResult
$Res call({
 String attemptId,@JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire) PlacementStage stage,@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? skill, PublicPlacementItem? item, int answered, int estimatedTotal, WritingTask? writingTask,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt
});


$PublicPlacementItemCopyWith<$Res>? get item;$WritingTaskCopyWith<$Res>? get writingTask;

}
/// @nodoc
class _$PlacementStepCopyWithImpl<$Res>
    implements $PlacementStepCopyWith<$Res> {
  _$PlacementStepCopyWithImpl(this._self, this._then);

  final PlacementStep _self;
  final $Res Function(PlacementStep) _then;

/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? stage = null,Object? skill = freezed,Object? item = freezed,Object? answered = null,Object? estimatedTotal = null,Object? writingTask = freezed,Object? closesAt = freezed,}) {
  return _then(_self.copyWith(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as PlacementStage,skill: freezed == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as ObjectiveSkill?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PublicPlacementItem?,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as int,writingTask: freezed == writingTask ? _self.writingTask : writingTask // ignore: cast_nullable_to_non_nullable
as WritingTask?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicPlacementItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $PublicPlacementItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingTaskCopyWith<$Res>? get writingTask {
    if (_self.writingTask == null) {
    return null;
  }

  return $WritingTaskCopyWith<$Res>(_self.writingTask!, (value) {
    return _then(_self.copyWith(writingTask: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlacementStep].
extension PlacementStepPatterns on PlacementStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementStep value)  $default,){
final _that = this;
switch (_that) {
case _PlacementStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementStep value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attemptId, @JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire)  PlacementStage stage, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  PublicPlacementItem? item,  int answered,  int estimatedTotal,  WritingTask? writingTask, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementStep() when $default != null:
return $default(_that.attemptId,_that.stage,_that.skill,_that.item,_that.answered,_that.estimatedTotal,_that.writingTask,_that.closesAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attemptId, @JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire)  PlacementStage stage, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  PublicPlacementItem? item,  int answered,  int estimatedTotal,  WritingTask? writingTask, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)  $default,) {final _that = this;
switch (_that) {
case _PlacementStep():
return $default(_that.attemptId,_that.stage,_that.skill,_that.item,_that.answered,_that.estimatedTotal,_that.writingTask,_that.closesAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attemptId, @JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire)  PlacementStage stage, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire)  ObjectiveSkill? skill,  PublicPlacementItem? item,  int answered,  int estimatedTotal,  WritingTask? writingTask, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? closesAt)?  $default,) {final _that = this;
switch (_that) {
case _PlacementStep() when $default != null:
return $default(_that.attemptId,_that.stage,_that.skill,_that.item,_that.answered,_that.estimatedTotal,_that.writingTask,_that.closesAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementStep implements PlacementStep {
  const _PlacementStep({this.attemptId = '', @JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire) this.stage = PlacementStage.objective, @JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) this.skill, this.item, this.answered = 0, this.estimatedTotal = 0, this.writingTask, @JsonKey(fromJson: _instant, toJson: _instantWire) this.closesAt});
  factory _PlacementStep.fromJson(Map<String, dynamic> json) => _$PlacementStepFromJson(json);

@override@JsonKey() final  String attemptId;
@override@JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire) final  PlacementStage stage;
/// The part being tested. Null at the writing stage.
@override@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) final  ObjectiveSkill? skill;
/// Null at the writing stage.
@override final  PublicPlacementItem? item;
@override@JsonKey() final  int answered;
/// A progress figure, not a promise: the staircase decides the real
/// length.
@override@JsonKey() final  int estimatedTotal;
/// Set at the writing stage only.
@override final  WritingTask? writingTask;
/// The same instant [PlacementInProgress.closesAt] reports; it moves with
/// each answer, up to the two-day cap. Null at the writing stage.
@override@JsonKey(fromJson: _instant, toJson: _instantWire) final  DateTime? closesAt;

/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementStepCopyWith<_PlacementStep> get copyWith => __$PlacementStepCopyWithImpl<_PlacementStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementStep&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.item, item) || other.item == item)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&(identical(other.writingTask, writingTask) || other.writingTask == writingTask)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,stage,skill,item,answered,estimatedTotal,writingTask,closesAt);

@override
String toString() {
  return 'PlacementStep(attemptId: $attemptId, stage: $stage, skill: $skill, item: $item, answered: $answered, estimatedTotal: $estimatedTotal, writingTask: $writingTask, closesAt: $closesAt)';
}


}

/// @nodoc
abstract mixin class _$PlacementStepCopyWith<$Res> implements $PlacementStepCopyWith<$Res> {
  factory _$PlacementStepCopyWith(_PlacementStep value, $Res Function(_PlacementStep) _then) = __$PlacementStepCopyWithImpl;
@override @useResult
$Res call({
 String attemptId,@JsonKey(fromJson: PlacementStage.parse, toJson: _stageWire) PlacementStage stage,@JsonKey(fromJson: ObjectiveSkill.parse, toJson: _skillWire) ObjectiveSkill? skill, PublicPlacementItem? item, int answered, int estimatedTotal, WritingTask? writingTask,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? closesAt
});


@override $PublicPlacementItemCopyWith<$Res>? get item;@override $WritingTaskCopyWith<$Res>? get writingTask;

}
/// @nodoc
class __$PlacementStepCopyWithImpl<$Res>
    implements _$PlacementStepCopyWith<$Res> {
  __$PlacementStepCopyWithImpl(this._self, this._then);

  final _PlacementStep _self;
  final $Res Function(_PlacementStep) _then;

/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? stage = null,Object? skill = freezed,Object? item = freezed,Object? answered = null,Object? estimatedTotal = null,Object? writingTask = freezed,Object? closesAt = freezed,}) {
  return _then(_PlacementStep(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as PlacementStage,skill: freezed == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as ObjectiveSkill?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PublicPlacementItem?,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as int,writingTask: freezed == writingTask ? _self.writingTask : writingTask // ignore: cast_nullable_to_non_nullable
as WritingTask?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicPlacementItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $PublicPlacementItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of PlacementStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingTaskCopyWith<$Res>? get writingTask {
    if (_self.writingTask == null) {
    return null;
  }

  return $WritingTaskCopyWith<$Res>(_self.writingTask!, (value) {
    return _then(_self.copyWith(writingTask: value));
  });
}
}


/// @nodoc
mixin _$PlacementResult {

@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get band;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get vocabularyBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get grammarBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get readingBand;@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? get writingBand; WritingFeedback? get writingFeedback;/// Text was sent for grading, whether or not a grade came back.
 bool get writingSubmitted;/// When the band was set — the retake date counts from here, not from
/// whenever this screen is looked at.
@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? get completedAt; bool get closedEarly; PlacementMeasured get measured;
/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementResultCopyWith<PlacementResult> get copyWith => _$PlacementResultCopyWithImpl<PlacementResult>(this as PlacementResult, _$identity);

  /// Serializes this PlacementResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacementResult&&(identical(other.band, band) || other.band == band)&&(identical(other.vocabularyBand, vocabularyBand) || other.vocabularyBand == vocabularyBand)&&(identical(other.grammarBand, grammarBand) || other.grammarBand == grammarBand)&&(identical(other.readingBand, readingBand) || other.readingBand == readingBand)&&(identical(other.writingBand, writingBand) || other.writingBand == writingBand)&&(identical(other.writingFeedback, writingFeedback) || other.writingFeedback == writingFeedback)&&(identical(other.writingSubmitted, writingSubmitted) || other.writingSubmitted == writingSubmitted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.closedEarly, closedEarly) || other.closedEarly == closedEarly)&&(identical(other.measured, measured) || other.measured == measured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,vocabularyBand,grammarBand,readingBand,writingBand,writingFeedback,writingSubmitted,completedAt,closedEarly,measured);

@override
String toString() {
  return 'PlacementResult(band: $band, vocabularyBand: $vocabularyBand, grammarBand: $grammarBand, readingBand: $readingBand, writingBand: $writingBand, writingFeedback: $writingFeedback, writingSubmitted: $writingSubmitted, completedAt: $completedAt, closedEarly: $closedEarly, measured: $measured)';
}


}

/// @nodoc
abstract mixin class $PlacementResultCopyWith<$Res>  {
  factory $PlacementResultCopyWith(PlacementResult value, $Res Function(PlacementResult) _then) = _$PlacementResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? vocabularyBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand, WritingFeedback? writingFeedback, bool writingSubmitted,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt, bool closedEarly, PlacementMeasured measured
});


$WritingFeedbackCopyWith<$Res>? get writingFeedback;$PlacementMeasuredCopyWith<$Res> get measured;

}
/// @nodoc
class _$PlacementResultCopyWithImpl<$Res>
    implements $PlacementResultCopyWith<$Res> {
  _$PlacementResultCopyWithImpl(this._self, this._then);

  final PlacementResult _self;
  final $Res Function(PlacementResult) _then;

/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? band = freezed,Object? vocabularyBand = freezed,Object? grammarBand = freezed,Object? readingBand = freezed,Object? writingBand = freezed,Object? writingFeedback = freezed,Object? writingSubmitted = null,Object? completedAt = freezed,Object? closedEarly = null,Object? measured = null,}) {
  return _then(_self.copyWith(
band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand?,vocabularyBand: freezed == vocabularyBand ? _self.vocabularyBand : vocabularyBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,grammarBand: freezed == grammarBand ? _self.grammarBand : grammarBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,readingBand: freezed == readingBand ? _self.readingBand : readingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingBand: freezed == writingBand ? _self.writingBand : writingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingFeedback: freezed == writingFeedback ? _self.writingFeedback : writingFeedback // ignore: cast_nullable_to_non_nullable
as WritingFeedback?,writingSubmitted: null == writingSubmitted ? _self.writingSubmitted : writingSubmitted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedEarly: null == closedEarly ? _self.closedEarly : closedEarly // ignore: cast_nullable_to_non_nullable
as bool,measured: null == measured ? _self.measured : measured // ignore: cast_nullable_to_non_nullable
as PlacementMeasured,
  ));
}
/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingFeedbackCopyWith<$Res>? get writingFeedback {
    if (_self.writingFeedback == null) {
    return null;
  }

  return $WritingFeedbackCopyWith<$Res>(_self.writingFeedback!, (value) {
    return _then(_self.copyWith(writingFeedback: value));
  });
}/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementMeasuredCopyWith<$Res> get measured {
  
  return $PlacementMeasuredCopyWith<$Res>(_self.measured, (value) {
    return _then(_self.copyWith(measured: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlacementResult].
extension PlacementResultPatterns on PlacementResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacementResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacementResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacementResult value)  $default,){
final _that = this;
switch (_that) {
case _PlacementResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacementResult value)?  $default,){
final _that = this;
switch (_that) {
case _PlacementResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingSubmitted, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt,  bool closedEarly,  PlacementMeasured measured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacementResult() when $default != null:
return $default(_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingSubmitted,_that.completedAt,_that.closedEarly,_that.measured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingSubmitted, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt,  bool closedEarly,  PlacementMeasured measured)  $default,) {final _that = this;
switch (_that) {
case _PlacementResult():
return $default(_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingSubmitted,_that.completedAt,_that.closedEarly,_that.measured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire)  CefrBand? writingBand,  WritingFeedback? writingFeedback,  bool writingSubmitted, @JsonKey(fromJson: _instant, toJson: _instantWire)  DateTime? completedAt,  bool closedEarly,  PlacementMeasured measured)?  $default,) {final _that = this;
switch (_that) {
case _PlacementResult() when $default != null:
return $default(_that.band,_that.vocabularyBand,_that.grammarBand,_that.readingBand,_that.writingBand,_that.writingFeedback,_that.writingSubmitted,_that.completedAt,_that.closedEarly,_that.measured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacementResult extends PlacementResult {
  const _PlacementResult({@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.band, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.vocabularyBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.grammarBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.readingBand, @JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) this.writingBand, this.writingFeedback, this.writingSubmitted = false, @JsonKey(fromJson: _instant, toJson: _instantWire) this.completedAt, this.closedEarly = false, this.measured = const PlacementMeasured()}): super._();
  factory _PlacementResult.fromJson(Map<String, dynamic> json) => _$PlacementResultFromJson(json);

@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? band;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? vocabularyBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? grammarBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? readingBand;
@override@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) final  CefrBand? writingBand;
@override final  WritingFeedback? writingFeedback;
/// Text was sent for grading, whether or not a grade came back.
@override@JsonKey() final  bool writingSubmitted;
/// When the band was set — the retake date counts from here, not from
/// whenever this screen is looked at.
@override@JsonKey(fromJson: _instant, toJson: _instantWire) final  DateTime? completedAt;
@override@JsonKey() final  bool closedEarly;
@override@JsonKey() final  PlacementMeasured measured;

/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementResultCopyWith<_PlacementResult> get copyWith => __$PlacementResultCopyWithImpl<_PlacementResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacementResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacementResult&&(identical(other.band, band) || other.band == band)&&(identical(other.vocabularyBand, vocabularyBand) || other.vocabularyBand == vocabularyBand)&&(identical(other.grammarBand, grammarBand) || other.grammarBand == grammarBand)&&(identical(other.readingBand, readingBand) || other.readingBand == readingBand)&&(identical(other.writingBand, writingBand) || other.writingBand == writingBand)&&(identical(other.writingFeedback, writingFeedback) || other.writingFeedback == writingFeedback)&&(identical(other.writingSubmitted, writingSubmitted) || other.writingSubmitted == writingSubmitted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.closedEarly, closedEarly) || other.closedEarly == closedEarly)&&(identical(other.measured, measured) || other.measured == measured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,vocabularyBand,grammarBand,readingBand,writingBand,writingFeedback,writingSubmitted,completedAt,closedEarly,measured);

@override
String toString() {
  return 'PlacementResult(band: $band, vocabularyBand: $vocabularyBand, grammarBand: $grammarBand, readingBand: $readingBand, writingBand: $writingBand, writingFeedback: $writingFeedback, writingSubmitted: $writingSubmitted, completedAt: $completedAt, closedEarly: $closedEarly, measured: $measured)';
}


}

/// @nodoc
abstract mixin class _$PlacementResultCopyWith<$Res> implements $PlacementResultCopyWith<$Res> {
  factory _$PlacementResultCopyWith(_PlacementResult value, $Res Function(_PlacementResult) _then) = __$PlacementResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? band,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? vocabularyBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? grammarBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? readingBand,@JsonKey(fromJson: CefrBand.parse, toJson: _bandWire) CefrBand? writingBand, WritingFeedback? writingFeedback, bool writingSubmitted,@JsonKey(fromJson: _instant, toJson: _instantWire) DateTime? completedAt, bool closedEarly, PlacementMeasured measured
});


@override $WritingFeedbackCopyWith<$Res>? get writingFeedback;@override $PlacementMeasuredCopyWith<$Res> get measured;

}
/// @nodoc
class __$PlacementResultCopyWithImpl<$Res>
    implements _$PlacementResultCopyWith<$Res> {
  __$PlacementResultCopyWithImpl(this._self, this._then);

  final _PlacementResult _self;
  final $Res Function(_PlacementResult) _then;

/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? band = freezed,Object? vocabularyBand = freezed,Object? grammarBand = freezed,Object? readingBand = freezed,Object? writingBand = freezed,Object? writingFeedback = freezed,Object? writingSubmitted = null,Object? completedAt = freezed,Object? closedEarly = null,Object? measured = null,}) {
  return _then(_PlacementResult(
band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as CefrBand?,vocabularyBand: freezed == vocabularyBand ? _self.vocabularyBand : vocabularyBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,grammarBand: freezed == grammarBand ? _self.grammarBand : grammarBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,readingBand: freezed == readingBand ? _self.readingBand : readingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingBand: freezed == writingBand ? _self.writingBand : writingBand // ignore: cast_nullable_to_non_nullable
as CefrBand?,writingFeedback: freezed == writingFeedback ? _self.writingFeedback : writingFeedback // ignore: cast_nullable_to_non_nullable
as WritingFeedback?,writingSubmitted: null == writingSubmitted ? _self.writingSubmitted : writingSubmitted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedEarly: null == closedEarly ? _self.closedEarly : closedEarly // ignore: cast_nullable_to_non_nullable
as bool,measured: null == measured ? _self.measured : measured // ignore: cast_nullable_to_non_nullable
as PlacementMeasured,
  ));
}

/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WritingFeedbackCopyWith<$Res>? get writingFeedback {
    if (_self.writingFeedback == null) {
    return null;
  }

  return $WritingFeedbackCopyWith<$Res>(_self.writingFeedback!, (value) {
    return _then(_self.copyWith(writingFeedback: value));
  });
}/// Create a copy of PlacementResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlacementMeasuredCopyWith<$Res> get measured {
  
  return $PlacementMeasuredCopyWith<$Res>(_self.measured, (value) {
    return _then(_self.copyWith(measured: value));
  });
}
}

// dart format on
