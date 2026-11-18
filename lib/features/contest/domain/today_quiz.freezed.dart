// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_quiz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicQuizItem {

/// A bank question's `qz-b1-0001`, or `ai-<day>-<n>` for one written for
/// this learner. Sent back with the answer.
 String get id;@JsonKey(unknownEnumValue: QuizSkill.other) QuizSkill get skill;/// Reading questions only: a short workplace text.
 String? get passage; String get prompt;/// Four, in THIS learner's order (shuffled per learner, stable across
/// reloads). The answer travels back as the option's TEXT — never its
/// index, which would re-point under another learner's order.
 List<String> get options;
/// Create a copy of PublicQuizItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicQuizItemCopyWith<PublicQuizItem> get copyWith => _$PublicQuizItemCopyWithImpl<PublicQuizItem>(this as PublicQuizItem, _$identity);

  /// Serializes this PublicQuizItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicQuizItem&&(identical(other.id, id) || other.id == id)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,skill,passage,prompt,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'PublicQuizItem(id: $id, skill: $skill, passage: $passage, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class $PublicQuizItemCopyWith<$Res>  {
  factory $PublicQuizItemCopyWith(PublicQuizItem value, $Res Function(PublicQuizItem) _then) = _$PublicQuizItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: QuizSkill.other) QuizSkill skill, String? passage, String prompt, List<String> options
});




}
/// @nodoc
class _$PublicQuizItemCopyWithImpl<$Res>
    implements $PublicQuizItemCopyWith<$Res> {
  _$PublicQuizItemCopyWithImpl(this._self, this._then);

  final PublicQuizItem _self;
  final $Res Function(PublicQuizItem) _then;

/// Create a copy of PublicQuizItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? skill = null,Object? passage = freezed,Object? prompt = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as QuizSkill,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicQuizItem].
extension PublicQuizItemPatterns on PublicQuizItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicQuizItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicQuizItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicQuizItem value)  $default,){
final _that = this;
switch (_that) {
case _PublicQuizItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicQuizItem value)?  $default,){
final _that = this;
switch (_that) {
case _PublicQuizItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: QuizSkill.other)  QuizSkill skill,  String? passage,  String prompt,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicQuizItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: QuizSkill.other)  QuizSkill skill,  String? passage,  String prompt,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _PublicQuizItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: QuizSkill.other)  QuizSkill skill,  String? passage,  String prompt,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _PublicQuizItem() when $default != null:
return $default(_that.id,_that.skill,_that.passage,_that.prompt,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicQuizItem extends PublicQuizItem {
  const _PublicQuizItem({this.id = '', @JsonKey(unknownEnumValue: QuizSkill.other) this.skill = QuizSkill.other, this.passage, this.prompt = '', final  List<String> options = const <String>[]}): _options = options,super._();
  factory _PublicQuizItem.fromJson(Map<String, dynamic> json) => _$PublicQuizItemFromJson(json);

/// A bank question's `qz-b1-0001`, or `ai-<day>-<n>` for one written for
/// this learner. Sent back with the answer.
@override@JsonKey() final  String id;
@override@JsonKey(unknownEnumValue: QuizSkill.other) final  QuizSkill skill;
/// Reading questions only: a short workplace text.
@override final  String? passage;
@override@JsonKey() final  String prompt;
/// Four, in THIS learner's order (shuffled per learner, stable across
/// reloads). The answer travels back as the option's TEXT — never its
/// index, which would re-point under another learner's order.
 final  List<String> _options;
/// Four, in THIS learner's order (shuffled per learner, stable across
/// reloads). The answer travels back as the option's TEXT — never its
/// index, which would re-point under another learner's order.
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of PublicQuizItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicQuizItemCopyWith<_PublicQuizItem> get copyWith => __$PublicQuizItemCopyWithImpl<_PublicQuizItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicQuizItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicQuizItem&&(identical(other.id, id) || other.id == id)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,skill,passage,prompt,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PublicQuizItem(id: $id, skill: $skill, passage: $passage, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PublicQuizItemCopyWith<$Res> implements $PublicQuizItemCopyWith<$Res> {
  factory _$PublicQuizItemCopyWith(_PublicQuizItem value, $Res Function(_PublicQuizItem) _then) = __$PublicQuizItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: QuizSkill.other) QuizSkill skill, String? passage, String prompt, List<String> options
});




}
/// @nodoc
class __$PublicQuizItemCopyWithImpl<$Res>
    implements _$PublicQuizItemCopyWith<$Res> {
  __$PublicQuizItemCopyWithImpl(this._self, this._then);

  final _PublicQuizItem _self;
  final $Res Function(_PublicQuizItem) _then;

/// Create a copy of PublicQuizItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? skill = null,Object? passage = freezed,Object? prompt = null,Object? options = null,}) {
  return _then(_PublicQuizItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as QuizSkill,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$QuizAnswerView {

 String get itemId;/// The option text the record holds.
 String get value; bool get correct; String get correctOption; String get explain;/// What the ledger paid this answer — its own event, read from the
/// ledger, never inferred from whether scoring is paused now. NULL means
/// it was given while scoring was paused and is never paid: "Not
/// scored", not "0 XP".
 int? get pointsApplied;
/// Create a copy of QuizAnswerView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerViewCopyWith<QuizAnswerView> get copyWith => _$QuizAnswerViewCopyWithImpl<QuizAnswerView>(this as QuizAnswerView, _$identity);

  /// Serializes this QuizAnswerView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerView&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,value,correct,correctOption,explain,pointsApplied);

@override
String toString() {
  return 'QuizAnswerView(itemId: $itemId, value: $value, correct: $correct, correctOption: $correctOption, explain: $explain, pointsApplied: $pointsApplied)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerViewCopyWith<$Res>  {
  factory $QuizAnswerViewCopyWith(QuizAnswerView value, $Res Function(QuizAnswerView) _then) = _$QuizAnswerViewCopyWithImpl;
@useResult
$Res call({
 String itemId, String value, bool correct, String correctOption, String explain, int? pointsApplied
});




}
/// @nodoc
class _$QuizAnswerViewCopyWithImpl<$Res>
    implements $QuizAnswerViewCopyWith<$Res> {
  _$QuizAnswerViewCopyWithImpl(this._self, this._then);

  final QuizAnswerView _self;
  final $Res Function(QuizAnswerView) _then;

/// Create a copy of QuizAnswerView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? value = null,Object? correct = null,Object? correctOption = null,Object? explain = null,Object? pointsApplied = freezed,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,explain: null == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerView].
extension QuizAnswerViewPatterns on QuizAnswerView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerView value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerView value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String value,  bool correct,  String correctOption,  String explain,  int? pointsApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerView() when $default != null:
return $default(_that.itemId,_that.value,_that.correct,_that.correctOption,_that.explain,_that.pointsApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String value,  bool correct,  String correctOption,  String explain,  int? pointsApplied)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerView():
return $default(_that.itemId,_that.value,_that.correct,_that.correctOption,_that.explain,_that.pointsApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String value,  bool correct,  String correctOption,  String explain,  int? pointsApplied)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerView() when $default != null:
return $default(_that.itemId,_that.value,_that.correct,_that.correctOption,_that.explain,_that.pointsApplied);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerView implements QuizAnswerView {
  const _QuizAnswerView({this.itemId = '', this.value = '', this.correct = false, this.correctOption = '', this.explain = '', this.pointsApplied});
  factory _QuizAnswerView.fromJson(Map<String, dynamic> json) => _$QuizAnswerViewFromJson(json);

@override@JsonKey() final  String itemId;
/// The option text the record holds.
@override@JsonKey() final  String value;
@override@JsonKey() final  bool correct;
@override@JsonKey() final  String correctOption;
@override@JsonKey() final  String explain;
/// What the ledger paid this answer — its own event, read from the
/// ledger, never inferred from whether scoring is paused now. NULL means
/// it was given while scoring was paused and is never paid: "Not
/// scored", not "0 XP".
@override final  int? pointsApplied;

/// Create a copy of QuizAnswerView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerViewCopyWith<_QuizAnswerView> get copyWith => __$QuizAnswerViewCopyWithImpl<_QuizAnswerView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerView&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,value,correct,correctOption,explain,pointsApplied);

@override
String toString() {
  return 'QuizAnswerView(itemId: $itemId, value: $value, correct: $correct, correctOption: $correctOption, explain: $explain, pointsApplied: $pointsApplied)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerViewCopyWith<$Res> implements $QuizAnswerViewCopyWith<$Res> {
  factory _$QuizAnswerViewCopyWith(_QuizAnswerView value, $Res Function(_QuizAnswerView) _then) = __$QuizAnswerViewCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String value, bool correct, String correctOption, String explain, int? pointsApplied
});




}
/// @nodoc
class __$QuizAnswerViewCopyWithImpl<$Res>
    implements _$QuizAnswerViewCopyWith<$Res> {
  __$QuizAnswerViewCopyWithImpl(this._self, this._then);

  final _QuizAnswerView _self;
  final $Res Function(_QuizAnswerView) _then;

/// Create a copy of QuizAnswerView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? value = null,Object? correct = null,Object? correctOption = null,Object? explain = null,Object? pointsApplied = freezed,}) {
  return _then(_QuizAnswerView(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,explain: null == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuizScore {

 int get correct; int get wrong; int get points;
/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizScoreCopyWith<QuizScore> get copyWith => _$QuizScoreCopyWithImpl<QuizScore>(this as QuizScore, _$identity);

  /// Serializes this QuizScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizScore&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,wrong,points);

@override
String toString() {
  return 'QuizScore(correct: $correct, wrong: $wrong, points: $points)';
}


}

/// @nodoc
abstract mixin class $QuizScoreCopyWith<$Res>  {
  factory $QuizScoreCopyWith(QuizScore value, $Res Function(QuizScore) _then) = _$QuizScoreCopyWithImpl;
@useResult
$Res call({
 int correct, int wrong, int points
});




}
/// @nodoc
class _$QuizScoreCopyWithImpl<$Res>
    implements $QuizScoreCopyWith<$Res> {
  _$QuizScoreCopyWithImpl(this._self, this._then);

  final QuizScore _self;
  final $Res Function(QuizScore) _then;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? wrong = null,Object? points = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizScore].
extension QuizScorePatterns on QuizScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizScore value)  $default,){
final _that = this;
switch (_that) {
case _QuizScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizScore value)?  $default,){
final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correct,  int wrong,  int points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
return $default(_that.correct,_that.wrong,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correct,  int wrong,  int points)  $default,) {final _that = this;
switch (_that) {
case _QuizScore():
return $default(_that.correct,_that.wrong,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correct,  int wrong,  int points)?  $default,) {final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
return $default(_that.correct,_that.wrong,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizScore implements QuizScore {
  const _QuizScore({this.correct = 0, this.wrong = 0, this.points = 0});
  factory _QuizScore.fromJson(Map<String, dynamic> json) => _$QuizScoreFromJson(json);

@override@JsonKey() final  int correct;
@override@JsonKey() final  int wrong;
@override@JsonKey() final  int points;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizScoreCopyWith<_QuizScore> get copyWith => __$QuizScoreCopyWithImpl<_QuizScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizScore&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,wrong,points);

@override
String toString() {
  return 'QuizScore(correct: $correct, wrong: $wrong, points: $points)';
}


}

/// @nodoc
abstract mixin class _$QuizScoreCopyWith<$Res> implements $QuizScoreCopyWith<$Res> {
  factory _$QuizScoreCopyWith(_QuizScore value, $Res Function(_QuizScore) _then) = __$QuizScoreCopyWithImpl;
@override @useResult
$Res call({
 int correct, int wrong, int points
});




}
/// @nodoc
class __$QuizScoreCopyWithImpl<$Res>
    implements _$QuizScoreCopyWith<$Res> {
  __$QuizScoreCopyWithImpl(this._self, this._then);

  final _QuizScore _self;
  final $Res Function(_QuizScore) _then;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? wrong = null,Object? points = null,}) {
  return _then(_QuizScore(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinishBonus {

 int get points; int get minCorrect;
/// Create a copy of FinishBonus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishBonusCopyWith<FinishBonus> get copyWith => _$FinishBonusCopyWithImpl<FinishBonus>(this as FinishBonus, _$identity);

  /// Serializes this FinishBonus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishBonus&&(identical(other.points, points) || other.points == points)&&(identical(other.minCorrect, minCorrect) || other.minCorrect == minCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,minCorrect);

@override
String toString() {
  return 'FinishBonus(points: $points, minCorrect: $minCorrect)';
}


}

/// @nodoc
abstract mixin class $FinishBonusCopyWith<$Res>  {
  factory $FinishBonusCopyWith(FinishBonus value, $Res Function(FinishBonus) _then) = _$FinishBonusCopyWithImpl;
@useResult
$Res call({
 int points, int minCorrect
});




}
/// @nodoc
class _$FinishBonusCopyWithImpl<$Res>
    implements $FinishBonusCopyWith<$Res> {
  _$FinishBonusCopyWithImpl(this._self, this._then);

  final FinishBonus _self;
  final $Res Function(FinishBonus) _then;

/// Create a copy of FinishBonus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? minCorrect = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,minCorrect: null == minCorrect ? _self.minCorrect : minCorrect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishBonus].
extension FinishBonusPatterns on FinishBonus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishBonus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishBonus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishBonus value)  $default,){
final _that = this;
switch (_that) {
case _FinishBonus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishBonus value)?  $default,){
final _that = this;
switch (_that) {
case _FinishBonus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points,  int minCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishBonus() when $default != null:
return $default(_that.points,_that.minCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points,  int minCorrect)  $default,) {final _that = this;
switch (_that) {
case _FinishBonus():
return $default(_that.points,_that.minCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points,  int minCorrect)?  $default,) {final _that = this;
switch (_that) {
case _FinishBonus() when $default != null:
return $default(_that.points,_that.minCorrect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishBonus implements FinishBonus {
  const _FinishBonus({this.points = 0, this.minCorrect = 0});
  factory _FinishBonus.fromJson(Map<String, dynamic> json) => _$FinishBonusFromJson(json);

@override@JsonKey() final  int points;
@override@JsonKey() final  int minCorrect;

/// Create a copy of FinishBonus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishBonusCopyWith<_FinishBonus> get copyWith => __$FinishBonusCopyWithImpl<_FinishBonus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishBonusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishBonus&&(identical(other.points, points) || other.points == points)&&(identical(other.minCorrect, minCorrect) || other.minCorrect == minCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,minCorrect);

@override
String toString() {
  return 'FinishBonus(points: $points, minCorrect: $minCorrect)';
}


}

/// @nodoc
abstract mixin class _$FinishBonusCopyWith<$Res> implements $FinishBonusCopyWith<$Res> {
  factory _$FinishBonusCopyWith(_FinishBonus value, $Res Function(_FinishBonus) _then) = __$FinishBonusCopyWithImpl;
@override @useResult
$Res call({
 int points, int minCorrect
});




}
/// @nodoc
class __$FinishBonusCopyWithImpl<$Res>
    implements _$FinishBonusCopyWith<$Res> {
  __$FinishBonusCopyWithImpl(this._self, this._then);

  final _FinishBonus _self;
  final $Res Function(_FinishBonus) _then;

/// Create a copy of FinishBonus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? minCorrect = null,}) {
  return _then(_FinishBonus(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,minCorrect: null == minCorrect ? _self.minCorrect : minCorrect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TodayQuiz {

@JsonKey(unknownEnumValue: QuizStatus.noQuizToday) QuizStatus get status;/// Every status but `ready`.
@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) QuizReason? get reason; String? get contestId;/// The contest day the questions belong to — sent back with every
/// answer, so a lesson left open past midnight is refused NOT_TODAY.
 int? get day;/// The band the questions are drawn at (`A1`…`C2`).
 String? get band;/// Today's band is fixed for the day.
 bool get bandLocked;/// Will there be a lesson tomorrow at today's band? Null when the server
/// has not said — and then nothing is promised.
 bool? get tomorrow;/// The lesson has been opened (`POST`), so its personal questions are in
/// [questions] if they were written. False on a fresh day: the player
/// opens it and waits before the first answer.
 bool? get started;/// How many of [questions] were written for this learner; 0 when that
/// failed, and the lesson is the set questions alone.
 int get ownQuestions;/// All of today's questions, answered or not, in lesson order.
 List<PublicQuizItem> get questions;/// In the order they were answered.
 List<QuizAnswerView> get answered; bool get completed; QuizScore? get score; FinishBonus? get finishBonus;/// An answer given NOW earns nothing, ever. Says nothing about answers
/// already given — each carries what the ledger paid it.
 bool get scoringPaused;/// Today's contest day key (`YYYY-MM-DD`, the contest's timezone), sent
/// only while `ready`: a lesson part's node id — what Skip is keyed on —
/// is `<dayKey>:lesson:<k>`. Null from a server before Skip, and then the
/// player offers no "Skip this part".
 String? get dayKey;/// Lesson parts (1-based, sorted) skipped today. Each stays open beside
/// the next part until the day ends.
 List<int> get skippedParts;
/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayQuizCopyWith<TodayQuiz> get copyWith => _$TodayQuizCopyWithImpl<TodayQuiz>(this as TodayQuiz, _$identity);

  /// Serializes this TodayQuiz to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayQuiz&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.day, day) || other.day == day)&&(identical(other.band, band) || other.band == band)&&(identical(other.bandLocked, bandLocked) || other.bandLocked == bandLocked)&&(identical(other.tomorrow, tomorrow) || other.tomorrow == tomorrow)&&(identical(other.started, started) || other.started == started)&&(identical(other.ownQuestions, ownQuestions) || other.ownQuestions == ownQuestions)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.answered, answered)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.score, score) || other.score == score)&&(identical(other.finishBonus, finishBonus) || other.finishBonus == finishBonus)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&const DeepCollectionEquality().equals(other.skippedParts, skippedParts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,contestId,day,band,bandLocked,tomorrow,started,ownQuestions,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(answered),completed,score,finishBonus,scoringPaused,dayKey,const DeepCollectionEquality().hash(skippedParts));

@override
String toString() {
  return 'TodayQuiz(status: $status, reason: $reason, contestId: $contestId, day: $day, band: $band, bandLocked: $bandLocked, tomorrow: $tomorrow, started: $started, ownQuestions: $ownQuestions, questions: $questions, answered: $answered, completed: $completed, score: $score, finishBonus: $finishBonus, scoringPaused: $scoringPaused, dayKey: $dayKey, skippedParts: $skippedParts)';
}


}

/// @nodoc
abstract mixin class $TodayQuizCopyWith<$Res>  {
  factory $TodayQuizCopyWith(TodayQuiz value, $Res Function(TodayQuiz) _then) = _$TodayQuizCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: QuizStatus.noQuizToday) QuizStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) QuizReason? reason, String? contestId, int? day, String? band, bool bandLocked, bool? tomorrow, bool? started, int ownQuestions, List<PublicQuizItem> questions, List<QuizAnswerView> answered, bool completed, QuizScore? score, FinishBonus? finishBonus, bool scoringPaused, String? dayKey, List<int> skippedParts
});


$QuizScoreCopyWith<$Res>? get score;$FinishBonusCopyWith<$Res>? get finishBonus;

}
/// @nodoc
class _$TodayQuizCopyWithImpl<$Res>
    implements $TodayQuizCopyWith<$Res> {
  _$TodayQuizCopyWithImpl(this._self, this._then);

  final TodayQuiz _self;
  final $Res Function(TodayQuiz) _then;

/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? contestId = freezed,Object? day = freezed,Object? band = freezed,Object? bandLocked = null,Object? tomorrow = freezed,Object? started = freezed,Object? ownQuestions = null,Object? questions = null,Object? answered = null,Object? completed = null,Object? score = freezed,Object? finishBonus = freezed,Object? scoringPaused = null,Object? dayKey = freezed,Object? skippedParts = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuizStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as QuizReason?,contestId: freezed == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as String?,bandLocked: null == bandLocked ? _self.bandLocked : bandLocked // ignore: cast_nullable_to_non_nullable
as bool,tomorrow: freezed == tomorrow ? _self.tomorrow : tomorrow // ignore: cast_nullable_to_non_nullable
as bool?,started: freezed == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool?,ownQuestions: null == ownQuestions ? _self.ownQuestions : ownQuestions // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<PublicQuizItem>,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerView>,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as QuizScore?,finishBonus: freezed == finishBonus ? _self.finishBonus : finishBonus // ignore: cast_nullable_to_non_nullable
as FinishBonus?,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,dayKey: freezed == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String?,skippedParts: null == skippedParts ? _self.skippedParts : skippedParts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizScoreCopyWith<$Res>? get score {
    if (_self.score == null) {
    return null;
  }

  return $QuizScoreCopyWith<$Res>(_self.score!, (value) {
    return _then(_self.copyWith(score: value));
  });
}/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinishBonusCopyWith<$Res>? get finishBonus {
    if (_self.finishBonus == null) {
    return null;
  }

  return $FinishBonusCopyWith<$Res>(_self.finishBonus!, (value) {
    return _then(_self.copyWith(finishBonus: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayQuiz].
extension TodayQuizPatterns on TodayQuiz {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayQuiz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayQuiz() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayQuiz value)  $default,){
final _that = this;
switch (_that) {
case _TodayQuiz():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayQuiz value)?  $default,){
final _that = this;
switch (_that) {
case _TodayQuiz() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: QuizStatus.noQuizToday)  QuizStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  QuizReason? reason,  String? contestId,  int? day,  String? band,  bool bandLocked,  bool? tomorrow,  bool? started,  int ownQuestions,  List<PublicQuizItem> questions,  List<QuizAnswerView> answered,  bool completed,  QuizScore? score,  FinishBonus? finishBonus,  bool scoringPaused,  String? dayKey,  List<int> skippedParts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayQuiz() when $default != null:
return $default(_that.status,_that.reason,_that.contestId,_that.day,_that.band,_that.bandLocked,_that.tomorrow,_that.started,_that.ownQuestions,_that.questions,_that.answered,_that.completed,_that.score,_that.finishBonus,_that.scoringPaused,_that.dayKey,_that.skippedParts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: QuizStatus.noQuizToday)  QuizStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  QuizReason? reason,  String? contestId,  int? day,  String? band,  bool bandLocked,  bool? tomorrow,  bool? started,  int ownQuestions,  List<PublicQuizItem> questions,  List<QuizAnswerView> answered,  bool completed,  QuizScore? score,  FinishBonus? finishBonus,  bool scoringPaused,  String? dayKey,  List<int> skippedParts)  $default,) {final _that = this;
switch (_that) {
case _TodayQuiz():
return $default(_that.status,_that.reason,_that.contestId,_that.day,_that.band,_that.bandLocked,_that.tomorrow,_that.started,_that.ownQuestions,_that.questions,_that.answered,_that.completed,_that.score,_that.finishBonus,_that.scoringPaused,_that.dayKey,_that.skippedParts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: QuizStatus.noQuizToday)  QuizStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  QuizReason? reason,  String? contestId,  int? day,  String? band,  bool bandLocked,  bool? tomorrow,  bool? started,  int ownQuestions,  List<PublicQuizItem> questions,  List<QuizAnswerView> answered,  bool completed,  QuizScore? score,  FinishBonus? finishBonus,  bool scoringPaused,  String? dayKey,  List<int> skippedParts)?  $default,) {final _that = this;
switch (_that) {
case _TodayQuiz() when $default != null:
return $default(_that.status,_that.reason,_that.contestId,_that.day,_that.band,_that.bandLocked,_that.tomorrow,_that.started,_that.ownQuestions,_that.questions,_that.answered,_that.completed,_that.score,_that.finishBonus,_that.scoringPaused,_that.dayKey,_that.skippedParts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodayQuiz extends TodayQuiz {
  const _TodayQuiz({@JsonKey(unknownEnumValue: QuizStatus.noQuizToday) this.status = QuizStatus.noQuizToday, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.reason, this.contestId, this.day, this.band, this.bandLocked = false, this.tomorrow, this.started, this.ownQuestions = 0, final  List<PublicQuizItem> questions = const <PublicQuizItem>[], final  List<QuizAnswerView> answered = const <QuizAnswerView>[], this.completed = false, this.score, this.finishBonus, this.scoringPaused = false, this.dayKey, final  List<int> skippedParts = const <int>[]}): _questions = questions,_answered = answered,_skippedParts = skippedParts,super._();
  factory _TodayQuiz.fromJson(Map<String, dynamic> json) => _$TodayQuizFromJson(json);

@override@JsonKey(unknownEnumValue: QuizStatus.noQuizToday) final  QuizStatus status;
/// Every status but `ready`.
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  QuizReason? reason;
@override final  String? contestId;
/// The contest day the questions belong to — sent back with every
/// answer, so a lesson left open past midnight is refused NOT_TODAY.
@override final  int? day;
/// The band the questions are drawn at (`A1`…`C2`).
@override final  String? band;
/// Today's band is fixed for the day.
@override@JsonKey() final  bool bandLocked;
/// Will there be a lesson tomorrow at today's band? Null when the server
/// has not said — and then nothing is promised.
@override final  bool? tomorrow;
/// The lesson has been opened (`POST`), so its personal questions are in
/// [questions] if they were written. False on a fresh day: the player
/// opens it and waits before the first answer.
@override final  bool? started;
/// How many of [questions] were written for this learner; 0 when that
/// failed, and the lesson is the set questions alone.
@override@JsonKey() final  int ownQuestions;
/// All of today's questions, answered or not, in lesson order.
 final  List<PublicQuizItem> _questions;
/// All of today's questions, answered or not, in lesson order.
@override@JsonKey() List<PublicQuizItem> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

/// In the order they were answered.
 final  List<QuizAnswerView> _answered;
/// In the order they were answered.
@override@JsonKey() List<QuizAnswerView> get answered {
  if (_answered is EqualUnmodifiableListView) return _answered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answered);
}

@override@JsonKey() final  bool completed;
@override final  QuizScore? score;
@override final  FinishBonus? finishBonus;
/// An answer given NOW earns nothing, ever. Says nothing about answers
/// already given — each carries what the ledger paid it.
@override@JsonKey() final  bool scoringPaused;
/// Today's contest day key (`YYYY-MM-DD`, the contest's timezone), sent
/// only while `ready`: a lesson part's node id — what Skip is keyed on —
/// is `<dayKey>:lesson:<k>`. Null from a server before Skip, and then the
/// player offers no "Skip this part".
@override final  String? dayKey;
/// Lesson parts (1-based, sorted) skipped today. Each stays open beside
/// the next part until the day ends.
 final  List<int> _skippedParts;
/// Lesson parts (1-based, sorted) skipped today. Each stays open beside
/// the next part until the day ends.
@override@JsonKey() List<int> get skippedParts {
  if (_skippedParts is EqualUnmodifiableListView) return _skippedParts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skippedParts);
}


/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayQuizCopyWith<_TodayQuiz> get copyWith => __$TodayQuizCopyWithImpl<_TodayQuiz>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayQuizToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayQuiz&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.day, day) || other.day == day)&&(identical(other.band, band) || other.band == band)&&(identical(other.bandLocked, bandLocked) || other.bandLocked == bandLocked)&&(identical(other.tomorrow, tomorrow) || other.tomorrow == tomorrow)&&(identical(other.started, started) || other.started == started)&&(identical(other.ownQuestions, ownQuestions) || other.ownQuestions == ownQuestions)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._answered, _answered)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.score, score) || other.score == score)&&(identical(other.finishBonus, finishBonus) || other.finishBonus == finishBonus)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&const DeepCollectionEquality().equals(other._skippedParts, _skippedParts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,contestId,day,band,bandLocked,tomorrow,started,ownQuestions,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_answered),completed,score,finishBonus,scoringPaused,dayKey,const DeepCollectionEquality().hash(_skippedParts));

@override
String toString() {
  return 'TodayQuiz(status: $status, reason: $reason, contestId: $contestId, day: $day, band: $band, bandLocked: $bandLocked, tomorrow: $tomorrow, started: $started, ownQuestions: $ownQuestions, questions: $questions, answered: $answered, completed: $completed, score: $score, finishBonus: $finishBonus, scoringPaused: $scoringPaused, dayKey: $dayKey, skippedParts: $skippedParts)';
}


}

/// @nodoc
abstract mixin class _$TodayQuizCopyWith<$Res> implements $TodayQuizCopyWith<$Res> {
  factory _$TodayQuizCopyWith(_TodayQuiz value, $Res Function(_TodayQuiz) _then) = __$TodayQuizCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: QuizStatus.noQuizToday) QuizStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) QuizReason? reason, String? contestId, int? day, String? band, bool bandLocked, bool? tomorrow, bool? started, int ownQuestions, List<PublicQuizItem> questions, List<QuizAnswerView> answered, bool completed, QuizScore? score, FinishBonus? finishBonus, bool scoringPaused, String? dayKey, List<int> skippedParts
});


@override $QuizScoreCopyWith<$Res>? get score;@override $FinishBonusCopyWith<$Res>? get finishBonus;

}
/// @nodoc
class __$TodayQuizCopyWithImpl<$Res>
    implements _$TodayQuizCopyWith<$Res> {
  __$TodayQuizCopyWithImpl(this._self, this._then);

  final _TodayQuiz _self;
  final $Res Function(_TodayQuiz) _then;

/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? contestId = freezed,Object? day = freezed,Object? band = freezed,Object? bandLocked = null,Object? tomorrow = freezed,Object? started = freezed,Object? ownQuestions = null,Object? questions = null,Object? answered = null,Object? completed = null,Object? score = freezed,Object? finishBonus = freezed,Object? scoringPaused = null,Object? dayKey = freezed,Object? skippedParts = null,}) {
  return _then(_TodayQuiz(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuizStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as QuizReason?,contestId: freezed == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as String?,bandLocked: null == bandLocked ? _self.bandLocked : bandLocked // ignore: cast_nullable_to_non_nullable
as bool,tomorrow: freezed == tomorrow ? _self.tomorrow : tomorrow // ignore: cast_nullable_to_non_nullable
as bool?,started: freezed == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool?,ownQuestions: null == ownQuestions ? _self.ownQuestions : ownQuestions // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PublicQuizItem>,answered: null == answered ? _self._answered : answered // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerView>,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as QuizScore?,finishBonus: freezed == finishBonus ? _self.finishBonus : finishBonus // ignore: cast_nullable_to_non_nullable
as FinishBonus?,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,dayKey: freezed == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String?,skippedParts: null == skippedParts ? _self._skippedParts : skippedParts // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizScoreCopyWith<$Res>? get score {
    if (_self.score == null) {
    return null;
  }

  return $QuizScoreCopyWith<$Res>(_self.score!, (value) {
    return _then(_self.copyWith(score: value));
  });
}/// Create a copy of TodayQuiz
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinishBonusCopyWith<$Res>? get finishBonus {
    if (_self.finishBonus == null) {
    return null;
  }

  return $FinishBonusCopyWith<$Res>(_self.finishBonus!, (value) {
    return _then(_self.copyWith(finishBonus: value));
  });
}
}


/// @nodoc
mixin _$QuizAnswerResult {

/// The option text the RECORD holds — on a replay, the first attempt's,
/// which may not be the one just sent. Shown instead of the local pick.
 String get value; bool get correct; String get correctOption; String get explain;/// Every question of today is now answered.
 bool get completed;/// A first attempt: ALL the XP this request moved — the answer, plus the
/// day credit, the finishing bonus and the week's bonus when it brought
/// them. A replay: the first attempt's own event only.
 int get pointsApplied;/// Whether the ledger pays this answer at all; false when it was recorded
/// while scoring was paused.
 bool get scored;/// This answer completed the contest week: what the week's bonus paid
/// (already inside [pointsApplied]), 0 while paused. Null otherwise, and
/// always on a replay.
 int? get weekBonus;/// Already answered elsewhere (another device, a lost reply): this is
/// that answer read back, and nothing was recorded or paid now.
 bool get replay;
/// Create a copy of QuizAnswerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerResultCopyWith<QuizAnswerResult> get copyWith => _$QuizAnswerResultCopyWithImpl<QuizAnswerResult>(this as QuizAnswerResult, _$identity);

  /// Serializes this QuizAnswerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerResult&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.scored, scored) || other.scored == scored)&&(identical(other.weekBonus, weekBonus) || other.weekBonus == weekBonus)&&(identical(other.replay, replay) || other.replay == replay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,correct,correctOption,explain,completed,pointsApplied,scored,weekBonus,replay);

@override
String toString() {
  return 'QuizAnswerResult(value: $value, correct: $correct, correctOption: $correctOption, explain: $explain, completed: $completed, pointsApplied: $pointsApplied, scored: $scored, weekBonus: $weekBonus, replay: $replay)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerResultCopyWith<$Res>  {
  factory $QuizAnswerResultCopyWith(QuizAnswerResult value, $Res Function(QuizAnswerResult) _then) = _$QuizAnswerResultCopyWithImpl;
@useResult
$Res call({
 String value, bool correct, String correctOption, String explain, bool completed, int pointsApplied, bool scored, int? weekBonus, bool replay
});




}
/// @nodoc
class _$QuizAnswerResultCopyWithImpl<$Res>
    implements $QuizAnswerResultCopyWith<$Res> {
  _$QuizAnswerResultCopyWithImpl(this._self, this._then);

  final QuizAnswerResult _self;
  final $Res Function(QuizAnswerResult) _then;

/// Create a copy of QuizAnswerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? correct = null,Object? correctOption = null,Object? explain = null,Object? completed = null,Object? pointsApplied = null,Object? scored = null,Object? weekBonus = freezed,Object? replay = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,explain: null == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,scored: null == scored ? _self.scored : scored // ignore: cast_nullable_to_non_nullable
as bool,weekBonus: freezed == weekBonus ? _self.weekBonus : weekBonus // ignore: cast_nullable_to_non_nullable
as int?,replay: null == replay ? _self.replay : replay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerResult].
extension QuizAnswerResultPatterns on QuizAnswerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerResult value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerResult value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  bool correct,  String correctOption,  String explain,  bool completed,  int pointsApplied,  bool scored,  int? weekBonus,  bool replay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerResult() when $default != null:
return $default(_that.value,_that.correct,_that.correctOption,_that.explain,_that.completed,_that.pointsApplied,_that.scored,_that.weekBonus,_that.replay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  bool correct,  String correctOption,  String explain,  bool completed,  int pointsApplied,  bool scored,  int? weekBonus,  bool replay)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerResult():
return $default(_that.value,_that.correct,_that.correctOption,_that.explain,_that.completed,_that.pointsApplied,_that.scored,_that.weekBonus,_that.replay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  bool correct,  String correctOption,  String explain,  bool completed,  int pointsApplied,  bool scored,  int? weekBonus,  bool replay)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerResult() when $default != null:
return $default(_that.value,_that.correct,_that.correctOption,_that.explain,_that.completed,_that.pointsApplied,_that.scored,_that.weekBonus,_that.replay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerResult implements QuizAnswerResult {
  const _QuizAnswerResult({this.value = '', this.correct = false, this.correctOption = '', this.explain = '', this.completed = false, this.pointsApplied = 0, this.scored = true, this.weekBonus, this.replay = false});
  factory _QuizAnswerResult.fromJson(Map<String, dynamic> json) => _$QuizAnswerResultFromJson(json);

/// The option text the RECORD holds — on a replay, the first attempt's,
/// which may not be the one just sent. Shown instead of the local pick.
@override@JsonKey() final  String value;
@override@JsonKey() final  bool correct;
@override@JsonKey() final  String correctOption;
@override@JsonKey() final  String explain;
/// Every question of today is now answered.
@override@JsonKey() final  bool completed;
/// A first attempt: ALL the XP this request moved — the answer, plus the
/// day credit, the finishing bonus and the week's bonus when it brought
/// them. A replay: the first attempt's own event only.
@override@JsonKey() final  int pointsApplied;
/// Whether the ledger pays this answer at all; false when it was recorded
/// while scoring was paused.
@override@JsonKey() final  bool scored;
/// This answer completed the contest week: what the week's bonus paid
/// (already inside [pointsApplied]), 0 while paused. Null otherwise, and
/// always on a replay.
@override final  int? weekBonus;
/// Already answered elsewhere (another device, a lost reply): this is
/// that answer read back, and nothing was recorded or paid now.
@override@JsonKey() final  bool replay;

/// Create a copy of QuizAnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerResultCopyWith<_QuizAnswerResult> get copyWith => __$QuizAnswerResultCopyWithImpl<_QuizAnswerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerResult&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.explain, explain) || other.explain == explain)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.scored, scored) || other.scored == scored)&&(identical(other.weekBonus, weekBonus) || other.weekBonus == weekBonus)&&(identical(other.replay, replay) || other.replay == replay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,correct,correctOption,explain,completed,pointsApplied,scored,weekBonus,replay);

@override
String toString() {
  return 'QuizAnswerResult(value: $value, correct: $correct, correctOption: $correctOption, explain: $explain, completed: $completed, pointsApplied: $pointsApplied, scored: $scored, weekBonus: $weekBonus, replay: $replay)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerResultCopyWith<$Res> implements $QuizAnswerResultCopyWith<$Res> {
  factory _$QuizAnswerResultCopyWith(_QuizAnswerResult value, $Res Function(_QuizAnswerResult) _then) = __$QuizAnswerResultCopyWithImpl;
@override @useResult
$Res call({
 String value, bool correct, String correctOption, String explain, bool completed, int pointsApplied, bool scored, int? weekBonus, bool replay
});




}
/// @nodoc
class __$QuizAnswerResultCopyWithImpl<$Res>
    implements _$QuizAnswerResultCopyWith<$Res> {
  __$QuizAnswerResultCopyWithImpl(this._self, this._then);

  final _QuizAnswerResult _self;
  final $Res Function(_QuizAnswerResult) _then;

/// Create a copy of QuizAnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? correct = null,Object? correctOption = null,Object? explain = null,Object? completed = null,Object? pointsApplied = null,Object? scored = null,Object? weekBonus = freezed,Object? replay = null,}) {
  return _then(_QuizAnswerResult(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,explain: null == explain ? _self.explain : explain // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,scored: null == scored ? _self.scored : scored // ignore: cast_nullable_to_non_nullable
as bool,weekBonus: freezed == weekBonus ? _self.weekBonus : weekBonus // ignore: cast_nullable_to_non_nullable
as int?,replay: null == replay ? _self.replay : replay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
