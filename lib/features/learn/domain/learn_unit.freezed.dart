// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learn_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get id; String get type; String get prompt;/// One of the five voice-coach upgrade kinds, so written and spoken
/// mistakes file under the same headings.
 String? get teaches;/// choice, gap
 List<String> get options; int? get correctIndex; String? get explain;/// gap — carries exactly one `___`.
 String? get sentence;/// rewrite — pre-filled so the user edits rather than stares.
 String? get starter; String? get modelAnswer;/// compose
 String? get placeholder; int get minChars;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.teaches, teaches) || other.teaches == teaches)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.sentence, sentence) || other.sentence == sentence)&&(identical(other.starter, starter) || other.starter == starter)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.minChars, minChars) || other.minChars == minChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,prompt,teaches,const DeepCollectionEquality().hash(options),correctIndex,explain,sentence,starter,modelAnswer,placeholder,minChars);

@override
String toString() {
  return 'Exercise(id: $id, type: $type, prompt: $prompt, teaches: $teaches, options: $options, correctIndex: $correctIndex, explain: $explain, sentence: $sentence, starter: $starter, modelAnswer: $modelAnswer, placeholder: $placeholder, minChars: $minChars)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String type, String prompt, String? teaches, List<String> options, int? correctIndex, String? explain, String? sentence, String? starter, String? modelAnswer, String? placeholder, int minChars
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? prompt = null,Object? teaches = freezed,Object? options = null,Object? correctIndex = freezed,Object? explain = freezed,Object? sentence = freezed,Object? starter = freezed,Object? modelAnswer = freezed,Object? placeholder = freezed,Object? minChars = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,teaches: freezed == teaches ? _self.teaches : teaches // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: freezed == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int?,explain: freezed == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String?,sentence: freezed == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String?,starter: freezed == starter ? _self.starter : starter // ignore: cast_nullable_to_non_nullable
as String?,modelAnswer: freezed == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,minChars: null == minChars ? _self.minChars : minChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String prompt,  String? teaches,  List<String> options,  int? correctIndex,  String? explain,  String? sentence,  String? starter,  String? modelAnswer,  String? placeholder,  int minChars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.type,_that.prompt,_that.teaches,_that.options,_that.correctIndex,_that.explain,_that.sentence,_that.starter,_that.modelAnswer,_that.placeholder,_that.minChars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String prompt,  String? teaches,  List<String> options,  int? correctIndex,  String? explain,  String? sentence,  String? starter,  String? modelAnswer,  String? placeholder,  int minChars)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.type,_that.prompt,_that.teaches,_that.options,_that.correctIndex,_that.explain,_that.sentence,_that.starter,_that.modelAnswer,_that.placeholder,_that.minChars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String prompt,  String? teaches,  List<String> options,  int? correctIndex,  String? explain,  String? sentence,  String? starter,  String? modelAnswer,  String? placeholder,  int minChars)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.type,_that.prompt,_that.teaches,_that.options,_that.correctIndex,_that.explain,_that.sentence,_that.starter,_that.modelAnswer,_that.placeholder,_that.minChars);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise extends Exercise {
  const _Exercise({required this.id, required this.type, required this.prompt, this.teaches, final  List<String> options = const <String>[], this.correctIndex, this.explain, this.sentence, this.starter, this.modelAnswer, this.placeholder, this.minChars = 0}): _options = options,super._();
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
@override final  String type;
@override final  String prompt;
/// One of the five voice-coach upgrade kinds, so written and spoken
/// mistakes file under the same headings.
@override final  String? teaches;
/// choice, gap
 final  List<String> _options;
/// choice, gap
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int? correctIndex;
@override final  String? explain;
/// gap — carries exactly one `___`.
@override final  String? sentence;
/// rewrite — pre-filled so the user edits rather than stares.
@override final  String? starter;
@override final  String? modelAnswer;
/// compose
@override final  String? placeholder;
@override@JsonKey() final  int minChars;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.teaches, teaches) || other.teaches == teaches)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.sentence, sentence) || other.sentence == sentence)&&(identical(other.starter, starter) || other.starter == starter)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.minChars, minChars) || other.minChars == minChars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,prompt,teaches,const DeepCollectionEquality().hash(_options),correctIndex,explain,sentence,starter,modelAnswer,placeholder,minChars);

@override
String toString() {
  return 'Exercise(id: $id, type: $type, prompt: $prompt, teaches: $teaches, options: $options, correctIndex: $correctIndex, explain: $explain, sentence: $sentence, starter: $starter, modelAnswer: $modelAnswer, placeholder: $placeholder, minChars: $minChars)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String prompt, String? teaches, List<String> options, int? correctIndex, String? explain, String? sentence, String? starter, String? modelAnswer, String? placeholder, int minChars
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? prompt = null,Object? teaches = freezed,Object? options = null,Object? correctIndex = freezed,Object? explain = freezed,Object? sentence = freezed,Object? starter = freezed,Object? modelAnswer = freezed,Object? placeholder = freezed,Object? minChars = null,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,teaches: freezed == teaches ? _self.teaches : teaches // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: freezed == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int?,explain: freezed == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String?,sentence: freezed == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String?,starter: freezed == starter ? _self.starter : starter // ignore: cast_nullable_to_non_nullable
as String?,modelAnswer: freezed == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,minChars: null == minChars ? _self.minChars : minChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TeachBlock {

 String get rule; String get why; String get before; String get after; String? get kind;
/// Create a copy of TeachBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeachBlockCopyWith<TeachBlock> get copyWith => _$TeachBlockCopyWithImpl<TeachBlock>(this as TeachBlock, _$identity);

  /// Serializes this TeachBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeachBlock&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.why, why) || other.why == why)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rule,why,before,after,kind);

@override
String toString() {
  return 'TeachBlock(rule: $rule, why: $why, before: $before, after: $after, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $TeachBlockCopyWith<$Res>  {
  factory $TeachBlockCopyWith(TeachBlock value, $Res Function(TeachBlock) _then) = _$TeachBlockCopyWithImpl;
@useResult
$Res call({
 String rule, String why, String before, String after, String? kind
});




}
/// @nodoc
class _$TeachBlockCopyWithImpl<$Res>
    implements $TeachBlockCopyWith<$Res> {
  _$TeachBlockCopyWithImpl(this._self, this._then);

  final TeachBlock _self;
  final $Res Function(TeachBlock) _then;

/// Create a copy of TeachBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rule = null,Object? why = null,Object? before = null,Object? after = null,Object? kind = freezed,}) {
  return _then(_self.copyWith(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeachBlock].
extension TeachBlockPatterns on TeachBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeachBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeachBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeachBlock value)  $default,){
final _that = this;
switch (_that) {
case _TeachBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeachBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TeachBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rule,  String why,  String before,  String after,  String? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeachBlock() when $default != null:
return $default(_that.rule,_that.why,_that.before,_that.after,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rule,  String why,  String before,  String after,  String? kind)  $default,) {final _that = this;
switch (_that) {
case _TeachBlock():
return $default(_that.rule,_that.why,_that.before,_that.after,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rule,  String why,  String before,  String after,  String? kind)?  $default,) {final _that = this;
switch (_that) {
case _TeachBlock() when $default != null:
return $default(_that.rule,_that.why,_that.before,_that.after,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeachBlock implements TeachBlock {
  const _TeachBlock({required this.rule, required this.why, required this.before, required this.after, this.kind});
  factory _TeachBlock.fromJson(Map<String, dynamic> json) => _$TeachBlockFromJson(json);

@override final  String rule;
@override final  String why;
@override final  String before;
@override final  String after;
@override final  String? kind;

/// Create a copy of TeachBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeachBlockCopyWith<_TeachBlock> get copyWith => __$TeachBlockCopyWithImpl<_TeachBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeachBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeachBlock&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.why, why) || other.why == why)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rule,why,before,after,kind);

@override
String toString() {
  return 'TeachBlock(rule: $rule, why: $why, before: $before, after: $after, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$TeachBlockCopyWith<$Res> implements $TeachBlockCopyWith<$Res> {
  factory _$TeachBlockCopyWith(_TeachBlock value, $Res Function(_TeachBlock) _then) = __$TeachBlockCopyWithImpl;
@override @useResult
$Res call({
 String rule, String why, String before, String after, String? kind
});




}
/// @nodoc
class __$TeachBlockCopyWithImpl<$Res>
    implements _$TeachBlockCopyWith<$Res> {
  __$TeachBlockCopyWithImpl(this._self, this._then);

  final _TeachBlock _self;
  final $Res Function(_TeachBlock) _then;

/// Create a copy of TeachBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rule = null,Object? why = null,Object? before = null,Object? after = null,Object? kind = freezed,}) {
  return _then(_TeachBlock(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LevelAnswer {

 String get exerciseId; String get value;/// Absent for `compose`, which is not graded.
 bool? get correct;
/// Create a copy of LevelAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelAnswerCopyWith<LevelAnswer> get copyWith => _$LevelAnswerCopyWithImpl<LevelAnswer>(this as LevelAnswer, _$identity);

  /// Serializes this LevelAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelAnswer&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseId,value,correct);

@override
String toString() {
  return 'LevelAnswer(exerciseId: $exerciseId, value: $value, correct: $correct)';
}


}

/// @nodoc
abstract mixin class $LevelAnswerCopyWith<$Res>  {
  factory $LevelAnswerCopyWith(LevelAnswer value, $Res Function(LevelAnswer) _then) = _$LevelAnswerCopyWithImpl;
@useResult
$Res call({
 String exerciseId, String value, bool? correct
});




}
/// @nodoc
class _$LevelAnswerCopyWithImpl<$Res>
    implements $LevelAnswerCopyWith<$Res> {
  _$LevelAnswerCopyWithImpl(this._self, this._then);

  final LevelAnswer _self;
  final $Res Function(LevelAnswer) _then;

/// Create a copy of LevelAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? value = null,Object? correct = freezed,}) {
  return _then(_self.copyWith(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelAnswer].
extension LevelAnswerPatterns on LevelAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelAnswer value)  $default,){
final _that = this;
switch (_that) {
case _LevelAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _LevelAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  String value,  bool? correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelAnswer() when $default != null:
return $default(_that.exerciseId,_that.value,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  String value,  bool? correct)  $default,) {final _that = this;
switch (_that) {
case _LevelAnswer():
return $default(_that.exerciseId,_that.value,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  String value,  bool? correct)?  $default,) {final _that = this;
switch (_that) {
case _LevelAnswer() when $default != null:
return $default(_that.exerciseId,_that.value,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LevelAnswer implements LevelAnswer {
  const _LevelAnswer({required this.exerciseId, required this.value, this.correct});
  factory _LevelAnswer.fromJson(Map<String, dynamic> json) => _$LevelAnswerFromJson(json);

@override final  String exerciseId;
@override final  String value;
/// Absent for `compose`, which is not graded.
@override final  bool? correct;

/// Create a copy of LevelAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelAnswerCopyWith<_LevelAnswer> get copyWith => __$LevelAnswerCopyWithImpl<_LevelAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelAnswer&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseId,value,correct);

@override
String toString() {
  return 'LevelAnswer(exerciseId: $exerciseId, value: $value, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$LevelAnswerCopyWith<$Res> implements $LevelAnswerCopyWith<$Res> {
  factory _$LevelAnswerCopyWith(_LevelAnswer value, $Res Function(_LevelAnswer) _then) = __$LevelAnswerCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, String value, bool? correct
});




}
/// @nodoc
class __$LevelAnswerCopyWithImpl<$Res>
    implements _$LevelAnswerCopyWith<$Res> {
  __$LevelAnswerCopyWithImpl(this._self, this._then);

  final _LevelAnswer _self;
  final $Res Function(_LevelAnswer) _then;

/// Create a copy of LevelAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? value = null,Object? correct = freezed,}) {
  return _then(_LevelAnswer(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$LearnLevel {

 int get index;@JsonKey(name: 'kind', fromJson: LevelKind.parse) LevelKind get kind; String get title; TeachBlock? get teach; List<Exercise> get exercises;@JsonKey(name: 'status', fromJson: LevelStatus.parse) LevelStatus get status; List<LevelAnswer> get answers; String? get completedAt;
/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnLevelCopyWith<LearnLevel> get copyWith => _$LearnLevelCopyWithImpl<LearnLevel>(this as LearnLevel, _$identity);

  /// Serializes this LearnLevel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnLevel&&(identical(other.index, index) || other.index == index)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.teach, teach) || other.teach == teach)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,kind,title,teach,const DeepCollectionEquality().hash(exercises),status,const DeepCollectionEquality().hash(answers),completedAt);

@override
String toString() {
  return 'LearnLevel(index: $index, kind: $kind, title: $title, teach: $teach, exercises: $exercises, status: $status, answers: $answers, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $LearnLevelCopyWith<$Res>  {
  factory $LearnLevelCopyWith(LearnLevel value, $Res Function(LearnLevel) _then) = _$LearnLevelCopyWithImpl;
@useResult
$Res call({
 int index,@JsonKey(name: 'kind', fromJson: LevelKind.parse) LevelKind kind, String title, TeachBlock? teach, List<Exercise> exercises,@JsonKey(name: 'status', fromJson: LevelStatus.parse) LevelStatus status, List<LevelAnswer> answers, String? completedAt
});


$TeachBlockCopyWith<$Res>? get teach;

}
/// @nodoc
class _$LearnLevelCopyWithImpl<$Res>
    implements $LearnLevelCopyWith<$Res> {
  _$LearnLevelCopyWithImpl(this._self, this._then);

  final LearnLevel _self;
  final $Res Function(LearnLevel) _then;

/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? kind = null,Object? title = null,Object? teach = freezed,Object? exercises = null,Object? status = null,Object? answers = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LevelKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,teach: freezed == teach ? _self.teach : teach // ignore: cast_nullable_to_non_nullable
as TeachBlock?,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LevelStatus,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<LevelAnswer>,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeachBlockCopyWith<$Res>? get teach {
    if (_self.teach == null) {
    return null;
  }

  return $TeachBlockCopyWith<$Res>(_self.teach!, (value) {
    return _then(_self.copyWith(teach: value));
  });
}
}


/// Adds pattern-matching-related methods to [LearnLevel].
extension LearnLevelPatterns on LearnLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnLevel value)  $default,){
final _that = this;
switch (_that) {
case _LearnLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnLevel value)?  $default,){
final _that = this;
switch (_that) {
case _LearnLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index, @JsonKey(name: 'kind', fromJson: LevelKind.parse)  LevelKind kind,  String title,  TeachBlock? teach,  List<Exercise> exercises, @JsonKey(name: 'status', fromJson: LevelStatus.parse)  LevelStatus status,  List<LevelAnswer> answers,  String? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnLevel() when $default != null:
return $default(_that.index,_that.kind,_that.title,_that.teach,_that.exercises,_that.status,_that.answers,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index, @JsonKey(name: 'kind', fromJson: LevelKind.parse)  LevelKind kind,  String title,  TeachBlock? teach,  List<Exercise> exercises, @JsonKey(name: 'status', fromJson: LevelStatus.parse)  LevelStatus status,  List<LevelAnswer> answers,  String? completedAt)  $default,) {final _that = this;
switch (_that) {
case _LearnLevel():
return $default(_that.index,_that.kind,_that.title,_that.teach,_that.exercises,_that.status,_that.answers,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index, @JsonKey(name: 'kind', fromJson: LevelKind.parse)  LevelKind kind,  String title,  TeachBlock? teach,  List<Exercise> exercises, @JsonKey(name: 'status', fromJson: LevelStatus.parse)  LevelStatus status,  List<LevelAnswer> answers,  String? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LearnLevel() when $default != null:
return $default(_that.index,_that.kind,_that.title,_that.teach,_that.exercises,_that.status,_that.answers,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnLevel extends LearnLevel {
  const _LearnLevel({required this.index, @JsonKey(name: 'kind', fromJson: LevelKind.parse) required this.kind, required this.title, this.teach, final  List<Exercise> exercises = const <Exercise>[], @JsonKey(name: 'status', fromJson: LevelStatus.parse) this.status = LevelStatus.locked, final  List<LevelAnswer> answers = const <LevelAnswer>[], this.completedAt}): _exercises = exercises,_answers = answers,super._();
  factory _LearnLevel.fromJson(Map<String, dynamic> json) => _$LearnLevelFromJson(json);

@override final  int index;
@override@JsonKey(name: 'kind', fromJson: LevelKind.parse) final  LevelKind kind;
@override final  String title;
@override final  TeachBlock? teach;
 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey(name: 'status', fromJson: LevelStatus.parse) final  LevelStatus status;
 final  List<LevelAnswer> _answers;
@override@JsonKey() List<LevelAnswer> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

@override final  String? completedAt;

/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnLevelCopyWith<_LearnLevel> get copyWith => __$LearnLevelCopyWithImpl<_LearnLevel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnLevelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnLevel&&(identical(other.index, index) || other.index == index)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.teach, teach) || other.teach == teach)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,kind,title,teach,const DeepCollectionEquality().hash(_exercises),status,const DeepCollectionEquality().hash(_answers),completedAt);

@override
String toString() {
  return 'LearnLevel(index: $index, kind: $kind, title: $title, teach: $teach, exercises: $exercises, status: $status, answers: $answers, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LearnLevelCopyWith<$Res> implements $LearnLevelCopyWith<$Res> {
  factory _$LearnLevelCopyWith(_LearnLevel value, $Res Function(_LearnLevel) _then) = __$LearnLevelCopyWithImpl;
@override @useResult
$Res call({
 int index,@JsonKey(name: 'kind', fromJson: LevelKind.parse) LevelKind kind, String title, TeachBlock? teach, List<Exercise> exercises,@JsonKey(name: 'status', fromJson: LevelStatus.parse) LevelStatus status, List<LevelAnswer> answers, String? completedAt
});


@override $TeachBlockCopyWith<$Res>? get teach;

}
/// @nodoc
class __$LearnLevelCopyWithImpl<$Res>
    implements _$LearnLevelCopyWith<$Res> {
  __$LearnLevelCopyWithImpl(this._self, this._then);

  final _LearnLevel _self;
  final $Res Function(_LearnLevel) _then;

/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? kind = null,Object? title = null,Object? teach = freezed,Object? exercises = null,Object? status = null,Object? answers = null,Object? completedAt = freezed,}) {
  return _then(_LearnLevel(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LevelKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,teach: freezed == teach ? _self.teach : teach // ignore: cast_nullable_to_non_nullable
as TeachBlock?,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LevelStatus,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<LevelAnswer>,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LearnLevel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeachBlockCopyWith<$Res>? get teach {
    if (_self.teach == null) {
    return null;
  }

  return $TeachBlockCopyWith<$Res>(_self.teach!, (value) {
    return _then(_self.copyWith(teach: value));
  });
}
}


/// @nodoc
mixin _$LearnUnit {

 String get id; int get season; int get weekNumber; int get dayIndex;@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind get kind; String get title;/// The week's topic, above the day's own title.
 String get unitTitle; List<LearnLevel> get levels;@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus get status; int get nextLevelIndex;/// The post this unit writes, once `draft` has run.
 String? get postId; String? get postContent; String? get imageUrl;
/// Create a copy of LearnUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnUnitCopyWith<LearnUnit> get copyWith => _$LearnUnitCopyWithImpl<LearnUnit>(this as LearnUnit, _$identity);

  /// Serializes this LearnUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.season, season) || other.season == season)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.unitTitle, unitTitle) || other.unitTitle == unitTitle)&&const DeepCollectionEquality().equals(other.levels, levels)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextLevelIndex, nextLevelIndex) || other.nextLevelIndex == nextLevelIndex)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,season,weekNumber,dayIndex,kind,title,unitTitle,const DeepCollectionEquality().hash(levels),status,nextLevelIndex,postId,postContent,imageUrl);

@override
String toString() {
  return 'LearnUnit(id: $id, season: $season, weekNumber: $weekNumber, dayIndex: $dayIndex, kind: $kind, title: $title, unitTitle: $unitTitle, levels: $levels, status: $status, nextLevelIndex: $nextLevelIndex, postId: $postId, postContent: $postContent, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $LearnUnitCopyWith<$Res>  {
  factory $LearnUnitCopyWith(LearnUnit value, $Res Function(LearnUnit) _then) = _$LearnUnitCopyWithImpl;
@useResult
$Res call({
 String id, int season, int weekNumber, int dayIndex,@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind kind, String title, String unitTitle, List<LearnLevel> levels,@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus status, int nextLevelIndex, String? postId, String? postContent, String? imageUrl
});




}
/// @nodoc
class _$LearnUnitCopyWithImpl<$Res>
    implements $LearnUnitCopyWith<$Res> {
  _$LearnUnitCopyWithImpl(this._self, this._then);

  final LearnUnit _self;
  final $Res Function(LearnUnit) _then;

/// Create a copy of LearnUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? season = null,Object? weekNumber = null,Object? dayIndex = null,Object? kind = null,Object? title = null,Object? unitTitle = null,Object? levels = null,Object? status = null,Object? nextLevelIndex = null,Object? postId = freezed,Object? postContent = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,unitTitle: null == unitTitle ? _self.unitTitle : unitTitle // ignore: cast_nullable_to_non_nullable
as String,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as List<LearnLevel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,nextLevelIndex: null == nextLevelIndex ? _self.nextLevelIndex : nextLevelIndex // ignore: cast_nullable_to_non_nullable
as int,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,postContent: freezed == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnUnit].
extension LearnUnitPatterns on LearnUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnUnit value)  $default,){
final _that = this;
switch (_that) {
case _LearnUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnUnit value)?  $default,){
final _that = this;
switch (_that) {
case _LearnUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int season,  int weekNumber,  int dayIndex, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title,  String unitTitle,  List<LearnLevel> levels, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int nextLevelIndex,  String? postId,  String? postContent,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnUnit() when $default != null:
return $default(_that.id,_that.season,_that.weekNumber,_that.dayIndex,_that.kind,_that.title,_that.unitTitle,_that.levels,_that.status,_that.nextLevelIndex,_that.postId,_that.postContent,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int season,  int weekNumber,  int dayIndex, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title,  String unitTitle,  List<LearnLevel> levels, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int nextLevelIndex,  String? postId,  String? postContent,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _LearnUnit():
return $default(_that.id,_that.season,_that.weekNumber,_that.dayIndex,_that.kind,_that.title,_that.unitTitle,_that.levels,_that.status,_that.nextLevelIndex,_that.postId,_that.postContent,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int season,  int weekNumber,  int dayIndex, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title,  String unitTitle,  List<LearnLevel> levels, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int nextLevelIndex,  String? postId,  String? postContent,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _LearnUnit() when $default != null:
return $default(_that.id,_that.season,_that.weekNumber,_that.dayIndex,_that.kind,_that.title,_that.unitTitle,_that.levels,_that.status,_that.nextLevelIndex,_that.postId,_that.postContent,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnUnit extends LearnUnit {
  const _LearnUnit({required this.id, required this.season, required this.weekNumber, required this.dayIndex, @JsonKey(name: 'kind', fromJson: DayKind.parse) required this.kind, required this.title, this.unitTitle = '', final  List<LearnLevel> levels = const <LearnLevel>[], @JsonKey(name: 'status', fromJson: UnitStatus.parse) this.status = UnitStatus.available, this.nextLevelIndex = 0, this.postId, this.postContent, this.imageUrl}): _levels = levels,super._();
  factory _LearnUnit.fromJson(Map<String, dynamic> json) => _$LearnUnitFromJson(json);

@override final  String id;
@override final  int season;
@override final  int weekNumber;
@override final  int dayIndex;
@override@JsonKey(name: 'kind', fromJson: DayKind.parse) final  DayKind kind;
@override final  String title;
/// The week's topic, above the day's own title.
@override@JsonKey() final  String unitTitle;
 final  List<LearnLevel> _levels;
@override@JsonKey() List<LearnLevel> get levels {
  if (_levels is EqualUnmodifiableListView) return _levels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_levels);
}

@override@JsonKey(name: 'status', fromJson: UnitStatus.parse) final  UnitStatus status;
@override@JsonKey() final  int nextLevelIndex;
/// The post this unit writes, once `draft` has run.
@override final  String? postId;
@override final  String? postContent;
@override final  String? imageUrl;

/// Create a copy of LearnUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnUnitCopyWith<_LearnUnit> get copyWith => __$LearnUnitCopyWithImpl<_LearnUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnUnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.season, season) || other.season == season)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.unitTitle, unitTitle) || other.unitTitle == unitTitle)&&const DeepCollectionEquality().equals(other._levels, _levels)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextLevelIndex, nextLevelIndex) || other.nextLevelIndex == nextLevelIndex)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,season,weekNumber,dayIndex,kind,title,unitTitle,const DeepCollectionEquality().hash(_levels),status,nextLevelIndex,postId,postContent,imageUrl);

@override
String toString() {
  return 'LearnUnit(id: $id, season: $season, weekNumber: $weekNumber, dayIndex: $dayIndex, kind: $kind, title: $title, unitTitle: $unitTitle, levels: $levels, status: $status, nextLevelIndex: $nextLevelIndex, postId: $postId, postContent: $postContent, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$LearnUnitCopyWith<$Res> implements $LearnUnitCopyWith<$Res> {
  factory _$LearnUnitCopyWith(_LearnUnit value, $Res Function(_LearnUnit) _then) = __$LearnUnitCopyWithImpl;
@override @useResult
$Res call({
 String id, int season, int weekNumber, int dayIndex,@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind kind, String title, String unitTitle, List<LearnLevel> levels,@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus status, int nextLevelIndex, String? postId, String? postContent, String? imageUrl
});




}
/// @nodoc
class __$LearnUnitCopyWithImpl<$Res>
    implements _$LearnUnitCopyWith<$Res> {
  __$LearnUnitCopyWithImpl(this._self, this._then);

  final _LearnUnit _self;
  final $Res Function(_LearnUnit) _then;

/// Create a copy of LearnUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? season = null,Object? weekNumber = null,Object? dayIndex = null,Object? kind = null,Object? title = null,Object? unitTitle = null,Object? levels = null,Object? status = null,Object? nextLevelIndex = null,Object? postId = freezed,Object? postContent = freezed,Object? imageUrl = freezed,}) {
  return _then(_LearnUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,unitTitle: null == unitTitle ? _self.unitTitle : unitTitle // ignore: cast_nullable_to_non_nullable
as String,levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as List<LearnLevel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,nextLevelIndex: null == nextLevelIndex ? _self.nextLevelIndex : nextLevelIndex // ignore: cast_nullable_to_non_nullable
as int,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,postContent: freezed == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LearnPathDay {

 int get dayIndex;/// Monday … Sunday, for the node label.
 String get day;@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind get kind; String get title;@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus get status; int get levelCount; int get completedCount;/// False means opening this day will GENERATE its ladder — a model call,
/// so the client must expect the first open to be slow.
 bool get started;
/// Create a copy of LearnPathDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnPathDayCopyWith<LearnPathDay> get copyWith => _$LearnPathDayCopyWithImpl<LearnPathDay>(this as LearnPathDay, _$identity);

  /// Serializes this LearnPathDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnPathDay&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.day, day) || other.day == day)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.levelCount, levelCount) || other.levelCount == levelCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.started, started) || other.started == started));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayIndex,day,kind,title,status,levelCount,completedCount,started);

@override
String toString() {
  return 'LearnPathDay(dayIndex: $dayIndex, day: $day, kind: $kind, title: $title, status: $status, levelCount: $levelCount, completedCount: $completedCount, started: $started)';
}


}

/// @nodoc
abstract mixin class $LearnPathDayCopyWith<$Res>  {
  factory $LearnPathDayCopyWith(LearnPathDay value, $Res Function(LearnPathDay) _then) = _$LearnPathDayCopyWithImpl;
@useResult
$Res call({
 int dayIndex, String day,@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind kind, String title,@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus status, int levelCount, int completedCount, bool started
});




}
/// @nodoc
class _$LearnPathDayCopyWithImpl<$Res>
    implements $LearnPathDayCopyWith<$Res> {
  _$LearnPathDayCopyWithImpl(this._self, this._then);

  final LearnPathDay _self;
  final $Res Function(LearnPathDay) _then;

/// Create a copy of LearnPathDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayIndex = null,Object? day = null,Object? kind = null,Object? title = null,Object? status = null,Object? levelCount = null,Object? completedCount = null,Object? started = null,}) {
  return _then(_self.copyWith(
dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,levelCount: null == levelCount ? _self.levelCount : levelCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnPathDay].
extension LearnPathDayPatterns on LearnPathDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnPathDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnPathDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnPathDay value)  $default,){
final _that = this;
switch (_that) {
case _LearnPathDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnPathDay value)?  $default,){
final _that = this;
switch (_that) {
case _LearnPathDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayIndex,  String day, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int levelCount,  int completedCount,  bool started)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnPathDay() when $default != null:
return $default(_that.dayIndex,_that.day,_that.kind,_that.title,_that.status,_that.levelCount,_that.completedCount,_that.started);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayIndex,  String day, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int levelCount,  int completedCount,  bool started)  $default,) {final _that = this;
switch (_that) {
case _LearnPathDay():
return $default(_that.dayIndex,_that.day,_that.kind,_that.title,_that.status,_that.levelCount,_that.completedCount,_that.started);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayIndex,  String day, @JsonKey(name: 'kind', fromJson: DayKind.parse)  DayKind kind,  String title, @JsonKey(name: 'status', fromJson: UnitStatus.parse)  UnitStatus status,  int levelCount,  int completedCount,  bool started)?  $default,) {final _that = this;
switch (_that) {
case _LearnPathDay() when $default != null:
return $default(_that.dayIndex,_that.day,_that.kind,_that.title,_that.status,_that.levelCount,_that.completedCount,_that.started);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnPathDay extends LearnPathDay {
  const _LearnPathDay({required this.dayIndex, required this.day, @JsonKey(name: 'kind', fromJson: DayKind.parse) required this.kind, required this.title, @JsonKey(name: 'status', fromJson: UnitStatus.parse) this.status = UnitStatus.locked, this.levelCount = 0, this.completedCount = 0, this.started = false}): super._();
  factory _LearnPathDay.fromJson(Map<String, dynamic> json) => _$LearnPathDayFromJson(json);

@override final  int dayIndex;
/// Monday … Sunday, for the node label.
@override final  String day;
@override@JsonKey(name: 'kind', fromJson: DayKind.parse) final  DayKind kind;
@override final  String title;
@override@JsonKey(name: 'status', fromJson: UnitStatus.parse) final  UnitStatus status;
@override@JsonKey() final  int levelCount;
@override@JsonKey() final  int completedCount;
/// False means opening this day will GENERATE its ladder — a model call,
/// so the client must expect the first open to be slow.
@override@JsonKey() final  bool started;

/// Create a copy of LearnPathDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnPathDayCopyWith<_LearnPathDay> get copyWith => __$LearnPathDayCopyWithImpl<_LearnPathDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnPathDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnPathDay&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.day, day) || other.day == day)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.levelCount, levelCount) || other.levelCount == levelCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.started, started) || other.started == started));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayIndex,day,kind,title,status,levelCount,completedCount,started);

@override
String toString() {
  return 'LearnPathDay(dayIndex: $dayIndex, day: $day, kind: $kind, title: $title, status: $status, levelCount: $levelCount, completedCount: $completedCount, started: $started)';
}


}

/// @nodoc
abstract mixin class _$LearnPathDayCopyWith<$Res> implements $LearnPathDayCopyWith<$Res> {
  factory _$LearnPathDayCopyWith(_LearnPathDay value, $Res Function(_LearnPathDay) _then) = __$LearnPathDayCopyWithImpl;
@override @useResult
$Res call({
 int dayIndex, String day,@JsonKey(name: 'kind', fromJson: DayKind.parse) DayKind kind, String title,@JsonKey(name: 'status', fromJson: UnitStatus.parse) UnitStatus status, int levelCount, int completedCount, bool started
});




}
/// @nodoc
class __$LearnPathDayCopyWithImpl<$Res>
    implements _$LearnPathDayCopyWith<$Res> {
  __$LearnPathDayCopyWithImpl(this._self, this._then);

  final _LearnPathDay _self;
  final $Res Function(_LearnPathDay) _then;

/// Create a copy of LearnPathDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayIndex = null,Object? day = null,Object? kind = null,Object? title = null,Object? status = null,Object? levelCount = null,Object? completedCount = null,Object? started = null,}) {
  return _then(_LearnPathDay(
dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,levelCount: null == levelCount ? _self.levelCount : levelCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LearnPath {

 int get season; int get weekNumber;/// This week's topic from the season roadmap — the unit heading.
 String get unitTitle;/// The phase, for the section label above it.
 String get phase; List<LearnPathDay> get days;/// Where "Start" points. Null when the week is finished.
///
/// A `dayIndex`, NOT a position in [days] — the list omits rest days, so
/// the two do not line up. Look it up, do not index with it.
 int? get nextDayIndex;
/// Create a copy of LearnPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnPathCopyWith<LearnPath> get copyWith => _$LearnPathCopyWithImpl<LearnPath>(this as LearnPath, _$identity);

  /// Serializes this LearnPath to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnPath&&(identical(other.season, season) || other.season == season)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.unitTitle, unitTitle) || other.unitTitle == unitTitle)&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.nextDayIndex, nextDayIndex) || other.nextDayIndex == nextDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,weekNumber,unitTitle,phase,const DeepCollectionEquality().hash(days),nextDayIndex);

@override
String toString() {
  return 'LearnPath(season: $season, weekNumber: $weekNumber, unitTitle: $unitTitle, phase: $phase, days: $days, nextDayIndex: $nextDayIndex)';
}


}

/// @nodoc
abstract mixin class $LearnPathCopyWith<$Res>  {
  factory $LearnPathCopyWith(LearnPath value, $Res Function(LearnPath) _then) = _$LearnPathCopyWithImpl;
@useResult
$Res call({
 int season, int weekNumber, String unitTitle, String phase, List<LearnPathDay> days, int? nextDayIndex
});




}
/// @nodoc
class _$LearnPathCopyWithImpl<$Res>
    implements $LearnPathCopyWith<$Res> {
  _$LearnPathCopyWithImpl(this._self, this._then);

  final LearnPath _self;
  final $Res Function(LearnPath) _then;

/// Create a copy of LearnPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? weekNumber = null,Object? unitTitle = null,Object? phase = null,Object? days = null,Object? nextDayIndex = freezed,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,unitTitle: null == unitTitle ? _self.unitTitle : unitTitle // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<LearnPathDay>,nextDayIndex: freezed == nextDayIndex ? _self.nextDayIndex : nextDayIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnPath].
extension LearnPathPatterns on LearnPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnPath value)  $default,){
final _that = this;
switch (_that) {
case _LearnPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnPath value)?  $default,){
final _that = this;
switch (_that) {
case _LearnPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int season,  int weekNumber,  String unitTitle,  String phase,  List<LearnPathDay> days,  int? nextDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnPath() when $default != null:
return $default(_that.season,_that.weekNumber,_that.unitTitle,_that.phase,_that.days,_that.nextDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int season,  int weekNumber,  String unitTitle,  String phase,  List<LearnPathDay> days,  int? nextDayIndex)  $default,) {final _that = this;
switch (_that) {
case _LearnPath():
return $default(_that.season,_that.weekNumber,_that.unitTitle,_that.phase,_that.days,_that.nextDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int season,  int weekNumber,  String unitTitle,  String phase,  List<LearnPathDay> days,  int? nextDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _LearnPath() when $default != null:
return $default(_that.season,_that.weekNumber,_that.unitTitle,_that.phase,_that.days,_that.nextDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnPath extends LearnPath {
  const _LearnPath({required this.season, required this.weekNumber, this.unitTitle = '', this.phase = '', final  List<LearnPathDay> days = const <LearnPathDay>[], this.nextDayIndex}): _days = days,super._();
  factory _LearnPath.fromJson(Map<String, dynamic> json) => _$LearnPathFromJson(json);

@override final  int season;
@override final  int weekNumber;
/// This week's topic from the season roadmap — the unit heading.
@override@JsonKey() final  String unitTitle;
/// The phase, for the section label above it.
@override@JsonKey() final  String phase;
 final  List<LearnPathDay> _days;
@override@JsonKey() List<LearnPathDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

/// Where "Start" points. Null when the week is finished.
///
/// A `dayIndex`, NOT a position in [days] — the list omits rest days, so
/// the two do not line up. Look it up, do not index with it.
@override final  int? nextDayIndex;

/// Create a copy of LearnPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnPathCopyWith<_LearnPath> get copyWith => __$LearnPathCopyWithImpl<_LearnPath>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnPathToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnPath&&(identical(other.season, season) || other.season == season)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.unitTitle, unitTitle) || other.unitTitle == unitTitle)&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.nextDayIndex, nextDayIndex) || other.nextDayIndex == nextDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,season,weekNumber,unitTitle,phase,const DeepCollectionEquality().hash(_days),nextDayIndex);

@override
String toString() {
  return 'LearnPath(season: $season, weekNumber: $weekNumber, unitTitle: $unitTitle, phase: $phase, days: $days, nextDayIndex: $nextDayIndex)';
}


}

/// @nodoc
abstract mixin class _$LearnPathCopyWith<$Res> implements $LearnPathCopyWith<$Res> {
  factory _$LearnPathCopyWith(_LearnPath value, $Res Function(_LearnPath) _then) = __$LearnPathCopyWithImpl;
@override @useResult
$Res call({
 int season, int weekNumber, String unitTitle, String phase, List<LearnPathDay> days, int? nextDayIndex
});




}
/// @nodoc
class __$LearnPathCopyWithImpl<$Res>
    implements _$LearnPathCopyWith<$Res> {
  __$LearnPathCopyWithImpl(this._self, this._then);

  final _LearnPath _self;
  final $Res Function(_LearnPath) _then;

/// Create a copy of LearnPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? weekNumber = null,Object? unitTitle = null,Object? phase = null,Object? days = null,Object? nextDayIndex = freezed,}) {
  return _then(_LearnPath(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,unitTitle: null == unitTitle ? _self.unitTitle : unitTitle // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<LearnPathDay>,nextDayIndex: freezed == nextDayIndex ? _self.nextDayIndex : nextDayIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ExerciseResult {

 String get exerciseId; bool get correct; String get message;
/// Create a copy of ExerciseResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseResultCopyWith<ExerciseResult> get copyWith => _$ExerciseResultCopyWithImpl<ExerciseResult>(this as ExerciseResult, _$identity);

  /// Serializes this ExerciseResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseResult&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseId,correct,message);

@override
String toString() {
  return 'ExerciseResult(exerciseId: $exerciseId, correct: $correct, message: $message)';
}


}

/// @nodoc
abstract mixin class $ExerciseResultCopyWith<$Res>  {
  factory $ExerciseResultCopyWith(ExerciseResult value, $Res Function(ExerciseResult) _then) = _$ExerciseResultCopyWithImpl;
@useResult
$Res call({
 String exerciseId, bool correct, String message
});




}
/// @nodoc
class _$ExerciseResultCopyWithImpl<$Res>
    implements $ExerciseResultCopyWith<$Res> {
  _$ExerciseResultCopyWithImpl(this._self, this._then);

  final ExerciseResult _self;
  final $Res Function(ExerciseResult) _then;

/// Create a copy of ExerciseResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? correct = null,Object? message = null,}) {
  return _then(_self.copyWith(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseResult].
extension ExerciseResultPatterns on ExerciseResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseResult value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseResult value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  bool correct,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseResult() when $default != null:
return $default(_that.exerciseId,_that.correct,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  bool correct,  String message)  $default,) {final _that = this;
switch (_that) {
case _ExerciseResult():
return $default(_that.exerciseId,_that.correct,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  bool correct,  String message)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseResult() when $default != null:
return $default(_that.exerciseId,_that.correct,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseResult implements ExerciseResult {
  const _ExerciseResult({required this.exerciseId, required this.correct, this.message = ''});
  factory _ExerciseResult.fromJson(Map<String, dynamic> json) => _$ExerciseResultFromJson(json);

@override final  String exerciseId;
@override final  bool correct;
@override@JsonKey() final  String message;

/// Create a copy of ExerciseResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseResultCopyWith<_ExerciseResult> get copyWith => __$ExerciseResultCopyWithImpl<_ExerciseResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseResult&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseId,correct,message);

@override
String toString() {
  return 'ExerciseResult(exerciseId: $exerciseId, correct: $correct, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ExerciseResultCopyWith<$Res> implements $ExerciseResultCopyWith<$Res> {
  factory _$ExerciseResultCopyWith(_ExerciseResult value, $Res Function(_ExerciseResult) _then) = __$ExerciseResultCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, bool correct, String message
});




}
/// @nodoc
class __$ExerciseResultCopyWithImpl<$Res>
    implements _$ExerciseResultCopyWith<$Res> {
  __$ExerciseResultCopyWithImpl(this._self, this._then);

  final _ExerciseResult _self;
  final $Res Function(_ExerciseResult) _then;

/// Create a copy of ExerciseResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? correct = null,Object? message = null,}) {
  return _then(_ExerciseResult(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SubmitResult {

 LearnUnit get unit; List<ExerciseResult> get results;
/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitResultCopyWith<SubmitResult> get copyWith => _$SubmitResultCopyWithImpl<SubmitResult>(this as SubmitResult, _$identity);

  /// Serializes this SubmitResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitResult&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unit,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SubmitResult(unit: $unit, results: $results)';
}


}

/// @nodoc
abstract mixin class $SubmitResultCopyWith<$Res>  {
  factory $SubmitResultCopyWith(SubmitResult value, $Res Function(SubmitResult) _then) = _$SubmitResultCopyWithImpl;
@useResult
$Res call({
 LearnUnit unit, List<ExerciseResult> results
});


$LearnUnitCopyWith<$Res> get unit;

}
/// @nodoc
class _$SubmitResultCopyWithImpl<$Res>
    implements $SubmitResultCopyWith<$Res> {
  _$SubmitResultCopyWithImpl(this._self, this._then);

  final SubmitResult _self;
  final $Res Function(SubmitResult) _then;

/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? results = null,}) {
  return _then(_self.copyWith(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as LearnUnit,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ExerciseResult>,
  ));
}
/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearnUnitCopyWith<$Res> get unit {
  
  return $LearnUnitCopyWith<$Res>(_self.unit, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubmitResult].
extension SubmitResultPatterns on SubmitResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitResult value)  $default,){
final _that = this;
switch (_that) {
case _SubmitResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitResult value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LearnUnit unit,  List<ExerciseResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
return $default(_that.unit,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LearnUnit unit,  List<ExerciseResult> results)  $default,) {final _that = this;
switch (_that) {
case _SubmitResult():
return $default(_that.unit,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LearnUnit unit,  List<ExerciseResult> results)?  $default,) {final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
return $default(_that.unit,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmitResult extends SubmitResult {
  const _SubmitResult({required this.unit, final  List<ExerciseResult> results = const <ExerciseResult>[]}): _results = results,super._();
  factory _SubmitResult.fromJson(Map<String, dynamic> json) => _$SubmitResultFromJson(json);

@override final  LearnUnit unit;
 final  List<ExerciseResult> _results;
@override@JsonKey() List<ExerciseResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitResultCopyWith<_SubmitResult> get copyWith => __$SubmitResultCopyWithImpl<_SubmitResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitResult&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unit,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SubmitResult(unit: $unit, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SubmitResultCopyWith<$Res> implements $SubmitResultCopyWith<$Res> {
  factory _$SubmitResultCopyWith(_SubmitResult value, $Res Function(_SubmitResult) _then) = __$SubmitResultCopyWithImpl;
@override @useResult
$Res call({
 LearnUnit unit, List<ExerciseResult> results
});


@override $LearnUnitCopyWith<$Res> get unit;

}
/// @nodoc
class __$SubmitResultCopyWithImpl<$Res>
    implements _$SubmitResultCopyWith<$Res> {
  __$SubmitResultCopyWithImpl(this._self, this._then);

  final _SubmitResult _self;
  final $Res Function(_SubmitResult) _then;

/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? results = null,}) {
  return _then(_SubmitResult(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as LearnUnit,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ExerciseResult>,
  ));
}

/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearnUnitCopyWith<$Res> get unit {
  
  return $LearnUnitCopyWith<$Res>(_self.unit, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
