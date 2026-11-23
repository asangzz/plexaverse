// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_featured.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturedPerson {

/// A stable key for today; derived from no figure and reversible to no id.
 String get key; String get name;/// An https photo link, or null.
 String? get image; String? get headline;/// `https://www.linkedin.com/in/<slug>`, or null. Re-checked with
/// `profileHref` before it is ever opened.
 String? get linkedinUrl;
/// Create a copy of FeaturedPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturedPersonCopyWith<FeaturedPerson> get copyWith => _$FeaturedPersonCopyWithImpl<FeaturedPerson>(this as FeaturedPerson, _$identity);

  /// Serializes this FeaturedPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturedPerson&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,image,headline,linkedinUrl);

@override
String toString() {
  return 'FeaturedPerson(key: $key, name: $name, image: $image, headline: $headline, linkedinUrl: $linkedinUrl)';
}


}

/// @nodoc
abstract mixin class $FeaturedPersonCopyWith<$Res>  {
  factory $FeaturedPersonCopyWith(FeaturedPerson value, $Res Function(FeaturedPerson) _then) = _$FeaturedPersonCopyWithImpl;
@useResult
$Res call({
 String key, String name, String? image, String? headline, String? linkedinUrl
});




}
/// @nodoc
class _$FeaturedPersonCopyWithImpl<$Res>
    implements $FeaturedPersonCopyWith<$Res> {
  _$FeaturedPersonCopyWithImpl(this._self, this._then);

  final FeaturedPerson _self;
  final $Res Function(FeaturedPerson) _then;

/// Create a copy of FeaturedPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? image = freezed,Object? headline = freezed,Object? linkedinUrl = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturedPerson].
extension FeaturedPersonPatterns on FeaturedPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturedPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturedPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturedPerson value)  $default,){
final _that = this;
switch (_that) {
case _FeaturedPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturedPerson value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturedPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String? image,  String? headline,  String? linkedinUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturedPerson() when $default != null:
return $default(_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String? image,  String? headline,  String? linkedinUrl)  $default,) {final _that = this;
switch (_that) {
case _FeaturedPerson():
return $default(_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String? image,  String? headline,  String? linkedinUrl)?  $default,) {final _that = this;
switch (_that) {
case _FeaturedPerson() when $default != null:
return $default(_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeaturedPerson implements FeaturedPerson {
  const _FeaturedPerson({this.key = '', this.name = '', this.image, this.headline, this.linkedinUrl});
  factory _FeaturedPerson.fromJson(Map<String, dynamic> json) => _$FeaturedPersonFromJson(json);

/// A stable key for today; derived from no figure and reversible to no id.
@override@JsonKey() final  String key;
@override@JsonKey() final  String name;
/// An https photo link, or null.
@override final  String? image;
@override final  String? headline;
/// `https://www.linkedin.com/in/<slug>`, or null. Re-checked with
/// `profileHref` before it is ever opened.
@override final  String? linkedinUrl;

/// Create a copy of FeaturedPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturedPersonCopyWith<_FeaturedPerson> get copyWith => __$FeaturedPersonCopyWithImpl<_FeaturedPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeaturedPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturedPerson&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,image,headline,linkedinUrl);

@override
String toString() {
  return 'FeaturedPerson(key: $key, name: $name, image: $image, headline: $headline, linkedinUrl: $linkedinUrl)';
}


}

/// @nodoc
abstract mixin class _$FeaturedPersonCopyWith<$Res> implements $FeaturedPersonCopyWith<$Res> {
  factory _$FeaturedPersonCopyWith(_FeaturedPerson value, $Res Function(_FeaturedPerson) _then) = __$FeaturedPersonCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String? image, String? headline, String? linkedinUrl
});




}
/// @nodoc
class __$FeaturedPersonCopyWithImpl<$Res>
    implements _$FeaturedPersonCopyWith<$Res> {
  __$FeaturedPersonCopyWithImpl(this._self, this._then);

  final _FeaturedPerson _self;
  final $Res Function(_FeaturedPerson) _then;

/// Create a copy of FeaturedPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? image = freezed,Object? headline = freezed,Object? linkedinUrl = freezed,}) {
  return _then(_FeaturedPerson(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LearnersOfWeek {

@JsonKey(unknownEnumValue: LearnersOfWeekState.none) LearnersOfWeekState get state;/// The week's Sunday and Saturday, `YYYY-MM-DD` in the contest's
/// timezone. Empty unless [state] is ready.
 String get weekStart; String get weekEnd;/// In the day's shuffle — an order that says nothing about who scored
/// more. Never numbered, never sorted.
 List<FeaturedPerson> get learners;
/// Create a copy of LearnersOfWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnersOfWeekCopyWith<LearnersOfWeek> get copyWith => _$LearnersOfWeekCopyWithImpl<LearnersOfWeek>(this as LearnersOfWeek, _$identity);

  /// Serializes this LearnersOfWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnersOfWeek&&(identical(other.state, state) || other.state == state)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other.learners, learners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,weekStart,weekEnd,const DeepCollectionEquality().hash(learners));

@override
String toString() {
  return 'LearnersOfWeek(state: $state, weekStart: $weekStart, weekEnd: $weekEnd, learners: $learners)';
}


}

/// @nodoc
abstract mixin class $LearnersOfWeekCopyWith<$Res>  {
  factory $LearnersOfWeekCopyWith(LearnersOfWeek value, $Res Function(LearnersOfWeek) _then) = _$LearnersOfWeekCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: LearnersOfWeekState.none) LearnersOfWeekState state, String weekStart, String weekEnd, List<FeaturedPerson> learners
});




}
/// @nodoc
class _$LearnersOfWeekCopyWithImpl<$Res>
    implements $LearnersOfWeekCopyWith<$Res> {
  _$LearnersOfWeekCopyWithImpl(this._self, this._then);

  final LearnersOfWeek _self;
  final $Res Function(LearnersOfWeek) _then;

/// Create a copy of LearnersOfWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? weekStart = null,Object? weekEnd = null,Object? learners = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LearnersOfWeekState,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String,learners: null == learners ? _self.learners : learners // ignore: cast_nullable_to_non_nullable
as List<FeaturedPerson>,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnersOfWeek].
extension LearnersOfWeekPatterns on LearnersOfWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnersOfWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnersOfWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnersOfWeek value)  $default,){
final _that = this;
switch (_that) {
case _LearnersOfWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnersOfWeek value)?  $default,){
final _that = this;
switch (_that) {
case _LearnersOfWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: LearnersOfWeekState.none)  LearnersOfWeekState state,  String weekStart,  String weekEnd,  List<FeaturedPerson> learners)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnersOfWeek() when $default != null:
return $default(_that.state,_that.weekStart,_that.weekEnd,_that.learners);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: LearnersOfWeekState.none)  LearnersOfWeekState state,  String weekStart,  String weekEnd,  List<FeaturedPerson> learners)  $default,) {final _that = this;
switch (_that) {
case _LearnersOfWeek():
return $default(_that.state,_that.weekStart,_that.weekEnd,_that.learners);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: LearnersOfWeekState.none)  LearnersOfWeekState state,  String weekStart,  String weekEnd,  List<FeaturedPerson> learners)?  $default,) {final _that = this;
switch (_that) {
case _LearnersOfWeek() when $default != null:
return $default(_that.state,_that.weekStart,_that.weekEnd,_that.learners);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearnersOfWeek extends LearnersOfWeek {
  const _LearnersOfWeek({@JsonKey(unknownEnumValue: LearnersOfWeekState.none) this.state = LearnersOfWeekState.none, this.weekStart = '', this.weekEnd = '', final  List<FeaturedPerson> learners = const <FeaturedPerson>[]}): _learners = learners,super._();
  factory _LearnersOfWeek.fromJson(Map<String, dynamic> json) => _$LearnersOfWeekFromJson(json);

@override@JsonKey(unknownEnumValue: LearnersOfWeekState.none) final  LearnersOfWeekState state;
/// The week's Sunday and Saturday, `YYYY-MM-DD` in the contest's
/// timezone. Empty unless [state] is ready.
@override@JsonKey() final  String weekStart;
@override@JsonKey() final  String weekEnd;
/// In the day's shuffle — an order that says nothing about who scored
/// more. Never numbered, never sorted.
 final  List<FeaturedPerson> _learners;
/// In the day's shuffle — an order that says nothing about who scored
/// more. Never numbered, never sorted.
@override@JsonKey() List<FeaturedPerson> get learners {
  if (_learners is EqualUnmodifiableListView) return _learners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_learners);
}


/// Create a copy of LearnersOfWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnersOfWeekCopyWith<_LearnersOfWeek> get copyWith => __$LearnersOfWeekCopyWithImpl<_LearnersOfWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearnersOfWeekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnersOfWeek&&(identical(other.state, state) || other.state == state)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other._learners, _learners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,weekStart,weekEnd,const DeepCollectionEquality().hash(_learners));

@override
String toString() {
  return 'LearnersOfWeek(state: $state, weekStart: $weekStart, weekEnd: $weekEnd, learners: $learners)';
}


}

/// @nodoc
abstract mixin class _$LearnersOfWeekCopyWith<$Res> implements $LearnersOfWeekCopyWith<$Res> {
  factory _$LearnersOfWeekCopyWith(_LearnersOfWeek value, $Res Function(_LearnersOfWeek) _then) = __$LearnersOfWeekCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: LearnersOfWeekState.none) LearnersOfWeekState state, String weekStart, String weekEnd, List<FeaturedPerson> learners
});




}
/// @nodoc
class __$LearnersOfWeekCopyWithImpl<$Res>
    implements _$LearnersOfWeekCopyWith<$Res> {
  __$LearnersOfWeekCopyWithImpl(this._self, this._then);

  final _LearnersOfWeek _self;
  final $Res Function(_LearnersOfWeek) _then;

/// Create a copy of LearnersOfWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? weekStart = null,Object? weekEnd = null,Object? learners = null,}) {
  return _then(_LearnersOfWeek(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LearnersOfWeekState,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String,learners: null == learners ? _self._learners : learners // ignore: cast_nullable_to_non_nullable
as List<FeaturedPerson>,
  ));
}


}


/// @nodoc
mixin _$HallOfFameWinner {

/// The place, or null: never drawn as a number then.
 int? get rank; String get key; String get name; String? get image; String? get headline; String? get linkedinUrl;
/// Create a copy of HallOfFameWinner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallOfFameWinnerCopyWith<HallOfFameWinner> get copyWith => _$HallOfFameWinnerCopyWithImpl<HallOfFameWinner>(this as HallOfFameWinner, _$identity);

  /// Serializes this HallOfFameWinner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallOfFameWinner&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,key,name,image,headline,linkedinUrl);

@override
String toString() {
  return 'HallOfFameWinner(rank: $rank, key: $key, name: $name, image: $image, headline: $headline, linkedinUrl: $linkedinUrl)';
}


}

/// @nodoc
abstract mixin class $HallOfFameWinnerCopyWith<$Res>  {
  factory $HallOfFameWinnerCopyWith(HallOfFameWinner value, $Res Function(HallOfFameWinner) _then) = _$HallOfFameWinnerCopyWithImpl;
@useResult
$Res call({
 int? rank, String key, String name, String? image, String? headline, String? linkedinUrl
});




}
/// @nodoc
class _$HallOfFameWinnerCopyWithImpl<$Res>
    implements $HallOfFameWinnerCopyWith<$Res> {
  _$HallOfFameWinnerCopyWithImpl(this._self, this._then);

  final HallOfFameWinner _self;
  final $Res Function(HallOfFameWinner) _then;

/// Create a copy of HallOfFameWinner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = freezed,Object? key = null,Object? name = null,Object? image = freezed,Object? headline = freezed,Object? linkedinUrl = freezed,}) {
  return _then(_self.copyWith(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HallOfFameWinner].
extension HallOfFameWinnerPatterns on HallOfFameWinner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallOfFameWinner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallOfFameWinner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallOfFameWinner value)  $default,){
final _that = this;
switch (_that) {
case _HallOfFameWinner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallOfFameWinner value)?  $default,){
final _that = this;
switch (_that) {
case _HallOfFameWinner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? rank,  String key,  String name,  String? image,  String? headline,  String? linkedinUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallOfFameWinner() when $default != null:
return $default(_that.rank,_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? rank,  String key,  String name,  String? image,  String? headline,  String? linkedinUrl)  $default,) {final _that = this;
switch (_that) {
case _HallOfFameWinner():
return $default(_that.rank,_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? rank,  String key,  String name,  String? image,  String? headline,  String? linkedinUrl)?  $default,) {final _that = this;
switch (_that) {
case _HallOfFameWinner() when $default != null:
return $default(_that.rank,_that.key,_that.name,_that.image,_that.headline,_that.linkedinUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HallOfFameWinner extends HallOfFameWinner {
  const _HallOfFameWinner({this.rank, this.key = '', this.name = '', this.image, this.headline, this.linkedinUrl}): super._();
  factory _HallOfFameWinner.fromJson(Map<String, dynamic> json) => _$HallOfFameWinnerFromJson(json);

/// The place, or null: never drawn as a number then.
@override final  int? rank;
@override@JsonKey() final  String key;
@override@JsonKey() final  String name;
@override final  String? image;
@override final  String? headline;
@override final  String? linkedinUrl;

/// Create a copy of HallOfFameWinner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallOfFameWinnerCopyWith<_HallOfFameWinner> get copyWith => __$HallOfFameWinnerCopyWithImpl<_HallOfFameWinner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HallOfFameWinnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallOfFameWinner&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,key,name,image,headline,linkedinUrl);

@override
String toString() {
  return 'HallOfFameWinner(rank: $rank, key: $key, name: $name, image: $image, headline: $headline, linkedinUrl: $linkedinUrl)';
}


}

/// @nodoc
abstract mixin class _$HallOfFameWinnerCopyWith<$Res> implements $HallOfFameWinnerCopyWith<$Res> {
  factory _$HallOfFameWinnerCopyWith(_HallOfFameWinner value, $Res Function(_HallOfFameWinner) _then) = __$HallOfFameWinnerCopyWithImpl;
@override @useResult
$Res call({
 int? rank, String key, String name, String? image, String? headline, String? linkedinUrl
});




}
/// @nodoc
class __$HallOfFameWinnerCopyWithImpl<$Res>
    implements _$HallOfFameWinnerCopyWith<$Res> {
  __$HallOfFameWinnerCopyWithImpl(this._self, this._then);

  final _HallOfFameWinner _self;
  final $Res Function(_HallOfFameWinner) _then;

/// Create a copy of HallOfFameWinner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = freezed,Object? key = null,Object? name = null,Object? image = freezed,Object? headline = freezed,Object? linkedinUrl = freezed,}) {
  return _then(_HallOfFameWinner(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HallOfFameEntry {

 String get contestId; String get title; String get prizeTitle; int get rewardTopN;/// Instants — shown on the viewer's clock.
 DateTime get finalisedAt; DateTime get featuredUntil;/// Only the winners who agreed to be featured: the placed ones in place
/// order, then the unplaced in the server's shuffle.
 List<HallOfFameWinner> get winners;
/// Create a copy of HallOfFameEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallOfFameEntryCopyWith<HallOfFameEntry> get copyWith => _$HallOfFameEntryCopyWithImpl<HallOfFameEntry>(this as HallOfFameEntry, _$identity);

  /// Serializes this HallOfFameEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HallOfFameEntry&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.title, title) || other.title == title)&&(identical(other.prizeTitle, prizeTitle) || other.prizeTitle == prizeTitle)&&(identical(other.rewardTopN, rewardTopN) || other.rewardTopN == rewardTopN)&&(identical(other.finalisedAt, finalisedAt) || other.finalisedAt == finalisedAt)&&(identical(other.featuredUntil, featuredUntil) || other.featuredUntil == featuredUntil)&&const DeepCollectionEquality().equals(other.winners, winners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contestId,title,prizeTitle,rewardTopN,finalisedAt,featuredUntil,const DeepCollectionEquality().hash(winners));

@override
String toString() {
  return 'HallOfFameEntry(contestId: $contestId, title: $title, prizeTitle: $prizeTitle, rewardTopN: $rewardTopN, finalisedAt: $finalisedAt, featuredUntil: $featuredUntil, winners: $winners)';
}


}

/// @nodoc
abstract mixin class $HallOfFameEntryCopyWith<$Res>  {
  factory $HallOfFameEntryCopyWith(HallOfFameEntry value, $Res Function(HallOfFameEntry) _then) = _$HallOfFameEntryCopyWithImpl;
@useResult
$Res call({
 String contestId, String title, String prizeTitle, int rewardTopN, DateTime finalisedAt, DateTime featuredUntil, List<HallOfFameWinner> winners
});




}
/// @nodoc
class _$HallOfFameEntryCopyWithImpl<$Res>
    implements $HallOfFameEntryCopyWith<$Res> {
  _$HallOfFameEntryCopyWithImpl(this._self, this._then);

  final HallOfFameEntry _self;
  final $Res Function(HallOfFameEntry) _then;

/// Create a copy of HallOfFameEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contestId = null,Object? title = null,Object? prizeTitle = null,Object? rewardTopN = null,Object? finalisedAt = null,Object? featuredUntil = null,Object? winners = null,}) {
  return _then(_self.copyWith(
contestId: null == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,prizeTitle: null == prizeTitle ? _self.prizeTitle : prizeTitle // ignore: cast_nullable_to_non_nullable
as String,rewardTopN: null == rewardTopN ? _self.rewardTopN : rewardTopN // ignore: cast_nullable_to_non_nullable
as int,finalisedAt: null == finalisedAt ? _self.finalisedAt : finalisedAt // ignore: cast_nullable_to_non_nullable
as DateTime,featuredUntil: null == featuredUntil ? _self.featuredUntil : featuredUntil // ignore: cast_nullable_to_non_nullable
as DateTime,winners: null == winners ? _self.winners : winners // ignore: cast_nullable_to_non_nullable
as List<HallOfFameWinner>,
  ));
}

}


/// Adds pattern-matching-related methods to [HallOfFameEntry].
extension HallOfFameEntryPatterns on HallOfFameEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HallOfFameEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HallOfFameEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HallOfFameEntry value)  $default,){
final _that = this;
switch (_that) {
case _HallOfFameEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HallOfFameEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HallOfFameEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contestId,  String title,  String prizeTitle,  int rewardTopN,  DateTime finalisedAt,  DateTime featuredUntil,  List<HallOfFameWinner> winners)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HallOfFameEntry() when $default != null:
return $default(_that.contestId,_that.title,_that.prizeTitle,_that.rewardTopN,_that.finalisedAt,_that.featuredUntil,_that.winners);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contestId,  String title,  String prizeTitle,  int rewardTopN,  DateTime finalisedAt,  DateTime featuredUntil,  List<HallOfFameWinner> winners)  $default,) {final _that = this;
switch (_that) {
case _HallOfFameEntry():
return $default(_that.contestId,_that.title,_that.prizeTitle,_that.rewardTopN,_that.finalisedAt,_that.featuredUntil,_that.winners);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contestId,  String title,  String prizeTitle,  int rewardTopN,  DateTime finalisedAt,  DateTime featuredUntil,  List<HallOfFameWinner> winners)?  $default,) {final _that = this;
switch (_that) {
case _HallOfFameEntry() when $default != null:
return $default(_that.contestId,_that.title,_that.prizeTitle,_that.rewardTopN,_that.finalisedAt,_that.featuredUntil,_that.winners);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HallOfFameEntry implements HallOfFameEntry {
  const _HallOfFameEntry({this.contestId = '', this.title = '', this.prizeTitle = '', this.rewardTopN = 0, required this.finalisedAt, required this.featuredUntil, final  List<HallOfFameWinner> winners = const <HallOfFameWinner>[]}): _winners = winners;
  factory _HallOfFameEntry.fromJson(Map<String, dynamic> json) => _$HallOfFameEntryFromJson(json);

@override@JsonKey() final  String contestId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String prizeTitle;
@override@JsonKey() final  int rewardTopN;
/// Instants — shown on the viewer's clock.
@override final  DateTime finalisedAt;
@override final  DateTime featuredUntil;
/// Only the winners who agreed to be featured: the placed ones in place
/// order, then the unplaced in the server's shuffle.
 final  List<HallOfFameWinner> _winners;
/// Only the winners who agreed to be featured: the placed ones in place
/// order, then the unplaced in the server's shuffle.
@override@JsonKey() List<HallOfFameWinner> get winners {
  if (_winners is EqualUnmodifiableListView) return _winners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_winners);
}


/// Create a copy of HallOfFameEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallOfFameEntryCopyWith<_HallOfFameEntry> get copyWith => __$HallOfFameEntryCopyWithImpl<_HallOfFameEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HallOfFameEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HallOfFameEntry&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.title, title) || other.title == title)&&(identical(other.prizeTitle, prizeTitle) || other.prizeTitle == prizeTitle)&&(identical(other.rewardTopN, rewardTopN) || other.rewardTopN == rewardTopN)&&(identical(other.finalisedAt, finalisedAt) || other.finalisedAt == finalisedAt)&&(identical(other.featuredUntil, featuredUntil) || other.featuredUntil == featuredUntil)&&const DeepCollectionEquality().equals(other._winners, _winners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contestId,title,prizeTitle,rewardTopN,finalisedAt,featuredUntil,const DeepCollectionEquality().hash(_winners));

@override
String toString() {
  return 'HallOfFameEntry(contestId: $contestId, title: $title, prizeTitle: $prizeTitle, rewardTopN: $rewardTopN, finalisedAt: $finalisedAt, featuredUntil: $featuredUntil, winners: $winners)';
}


}

/// @nodoc
abstract mixin class _$HallOfFameEntryCopyWith<$Res> implements $HallOfFameEntryCopyWith<$Res> {
  factory _$HallOfFameEntryCopyWith(_HallOfFameEntry value, $Res Function(_HallOfFameEntry) _then) = __$HallOfFameEntryCopyWithImpl;
@override @useResult
$Res call({
 String contestId, String title, String prizeTitle, int rewardTopN, DateTime finalisedAt, DateTime featuredUntil, List<HallOfFameWinner> winners
});




}
/// @nodoc
class __$HallOfFameEntryCopyWithImpl<$Res>
    implements _$HallOfFameEntryCopyWith<$Res> {
  __$HallOfFameEntryCopyWithImpl(this._self, this._then);

  final _HallOfFameEntry _self;
  final $Res Function(_HallOfFameEntry) _then;

/// Create a copy of HallOfFameEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contestId = null,Object? title = null,Object? prizeTitle = null,Object? rewardTopN = null,Object? finalisedAt = null,Object? featuredUntil = null,Object? winners = null,}) {
  return _then(_HallOfFameEntry(
contestId: null == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,prizeTitle: null == prizeTitle ? _self.prizeTitle : prizeTitle // ignore: cast_nullable_to_non_nullable
as String,rewardTopN: null == rewardTopN ? _self.rewardTopN : rewardTopN // ignore: cast_nullable_to_non_nullable
as int,finalisedAt: null == finalisedAt ? _self.finalisedAt : finalisedAt // ignore: cast_nullable_to_non_nullable
as DateTime,featuredUntil: null == featuredUntil ? _self.featuredUntil : featuredUntil // ignore: cast_nullable_to_non_nullable
as DateTime,winners: null == winners ? _self._winners : winners // ignore: cast_nullable_to_non_nullable
as List<HallOfFameWinner>,
  ));
}


}


/// @nodoc
mixin _$ContestFeatured {

 LearnersOfWeek get week; List<HallOfFameEntry> get hallOfFame;/// The viewer placed in a contest whose Hall of Fame is showing —
/// consented or not. The page then offers them the "Feature me" card even
/// outside that contest: by the time a result is fixed the page has
/// usually moved on, and the prize is only theirs if they say yes.
 bool get viewerPlaced;
/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestFeaturedCopyWith<ContestFeatured> get copyWith => _$ContestFeaturedCopyWithImpl<ContestFeatured>(this as ContestFeatured, _$identity);

  /// Serializes this ContestFeatured to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestFeatured&&(identical(other.week, week) || other.week == week)&&const DeepCollectionEquality().equals(other.hallOfFame, hallOfFame)&&(identical(other.viewerPlaced, viewerPlaced) || other.viewerPlaced == viewerPlaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,const DeepCollectionEquality().hash(hallOfFame),viewerPlaced);

@override
String toString() {
  return 'ContestFeatured(week: $week, hallOfFame: $hallOfFame, viewerPlaced: $viewerPlaced)';
}


}

/// @nodoc
abstract mixin class $ContestFeaturedCopyWith<$Res>  {
  factory $ContestFeaturedCopyWith(ContestFeatured value, $Res Function(ContestFeatured) _then) = _$ContestFeaturedCopyWithImpl;
@useResult
$Res call({
 LearnersOfWeek week, List<HallOfFameEntry> hallOfFame, bool viewerPlaced
});


$LearnersOfWeekCopyWith<$Res> get week;

}
/// @nodoc
class _$ContestFeaturedCopyWithImpl<$Res>
    implements $ContestFeaturedCopyWith<$Res> {
  _$ContestFeaturedCopyWithImpl(this._self, this._then);

  final ContestFeatured _self;
  final $Res Function(ContestFeatured) _then;

/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? week = null,Object? hallOfFame = null,Object? viewerPlaced = null,}) {
  return _then(_self.copyWith(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as LearnersOfWeek,hallOfFame: null == hallOfFame ? _self.hallOfFame : hallOfFame // ignore: cast_nullable_to_non_nullable
as List<HallOfFameEntry>,viewerPlaced: null == viewerPlaced ? _self.viewerPlaced : viewerPlaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearnersOfWeekCopyWith<$Res> get week {
  
  return $LearnersOfWeekCopyWith<$Res>(_self.week, (value) {
    return _then(_self.copyWith(week: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContestFeatured].
extension ContestFeaturedPatterns on ContestFeatured {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestFeatured value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestFeatured() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestFeatured value)  $default,){
final _that = this;
switch (_that) {
case _ContestFeatured():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestFeatured value)?  $default,){
final _that = this;
switch (_that) {
case _ContestFeatured() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LearnersOfWeek week,  List<HallOfFameEntry> hallOfFame,  bool viewerPlaced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestFeatured() when $default != null:
return $default(_that.week,_that.hallOfFame,_that.viewerPlaced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LearnersOfWeek week,  List<HallOfFameEntry> hallOfFame,  bool viewerPlaced)  $default,) {final _that = this;
switch (_that) {
case _ContestFeatured():
return $default(_that.week,_that.hallOfFame,_that.viewerPlaced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LearnersOfWeek week,  List<HallOfFameEntry> hallOfFame,  bool viewerPlaced)?  $default,) {final _that = this;
switch (_that) {
case _ContestFeatured() when $default != null:
return $default(_that.week,_that.hallOfFame,_that.viewerPlaced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestFeatured implements ContestFeatured {
  const _ContestFeatured({this.week = const LearnersOfWeek(), final  List<HallOfFameEntry> hallOfFame = const <HallOfFameEntry>[], this.viewerPlaced = false}): _hallOfFame = hallOfFame;
  factory _ContestFeatured.fromJson(Map<String, dynamic> json) => _$ContestFeaturedFromJson(json);

@override@JsonKey() final  LearnersOfWeek week;
 final  List<HallOfFameEntry> _hallOfFame;
@override@JsonKey() List<HallOfFameEntry> get hallOfFame {
  if (_hallOfFame is EqualUnmodifiableListView) return _hallOfFame;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hallOfFame);
}

/// The viewer placed in a contest whose Hall of Fame is showing —
/// consented or not. The page then offers them the "Feature me" card even
/// outside that contest: by the time a result is fixed the page has
/// usually moved on, and the prize is only theirs if they say yes.
@override@JsonKey() final  bool viewerPlaced;

/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestFeaturedCopyWith<_ContestFeatured> get copyWith => __$ContestFeaturedCopyWithImpl<_ContestFeatured>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestFeaturedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestFeatured&&(identical(other.week, week) || other.week == week)&&const DeepCollectionEquality().equals(other._hallOfFame, _hallOfFame)&&(identical(other.viewerPlaced, viewerPlaced) || other.viewerPlaced == viewerPlaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,const DeepCollectionEquality().hash(_hallOfFame),viewerPlaced);

@override
String toString() {
  return 'ContestFeatured(week: $week, hallOfFame: $hallOfFame, viewerPlaced: $viewerPlaced)';
}


}

/// @nodoc
abstract mixin class _$ContestFeaturedCopyWith<$Res> implements $ContestFeaturedCopyWith<$Res> {
  factory _$ContestFeaturedCopyWith(_ContestFeatured value, $Res Function(_ContestFeatured) _then) = __$ContestFeaturedCopyWithImpl;
@override @useResult
$Res call({
 LearnersOfWeek week, List<HallOfFameEntry> hallOfFame, bool viewerPlaced
});


@override $LearnersOfWeekCopyWith<$Res> get week;

}
/// @nodoc
class __$ContestFeaturedCopyWithImpl<$Res>
    implements _$ContestFeaturedCopyWith<$Res> {
  __$ContestFeaturedCopyWithImpl(this._self, this._then);

  final _ContestFeatured _self;
  final $Res Function(_ContestFeatured) _then;

/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? week = null,Object? hallOfFame = null,Object? viewerPlaced = null,}) {
  return _then(_ContestFeatured(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as LearnersOfWeek,hallOfFame: null == hallOfFame ? _self._hallOfFame : hallOfFame // ignore: cast_nullable_to_non_nullable
as List<HallOfFameEntry>,viewerPlaced: null == viewerPlaced ? _self.viewerPlaced : viewerPlaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ContestFeatured
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearnersOfWeekCopyWith<$Res> get week {
  
  return $LearnersOfWeekCopyWith<$Res>(_self.week, (value) {
    return _then(_self.copyWith(week: value));
  });
}
}


/// @nodoc
mixin _$ShoutoutSettings {

/// Whether the `contest_shoutout` consent is in force. False until they
/// agree: the box is drawn from this, so it is never pre-ticked.
 bool get featured;/// The profile link on record, or null. Erased when [featured] is
/// switched off.
 String? get linkedinUrl;/// Whether "I am 18 or older" is on record. False: the card asks for the
/// tick with the link, and sends it (`adult: true`).
 bool get adultDeclared;
/// Create a copy of ShoutoutSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoutoutSettingsCopyWith<ShoutoutSettings> get copyWith => _$ShoutoutSettingsCopyWithImpl<ShoutoutSettings>(this as ShoutoutSettings, _$identity);

  /// Serializes this ShoutoutSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoutoutSettings&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.adultDeclared, adultDeclared) || other.adultDeclared == adultDeclared));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,featured,linkedinUrl,adultDeclared);

@override
String toString() {
  return 'ShoutoutSettings(featured: $featured, linkedinUrl: $linkedinUrl, adultDeclared: $adultDeclared)';
}


}

/// @nodoc
abstract mixin class $ShoutoutSettingsCopyWith<$Res>  {
  factory $ShoutoutSettingsCopyWith(ShoutoutSettings value, $Res Function(ShoutoutSettings) _then) = _$ShoutoutSettingsCopyWithImpl;
@useResult
$Res call({
 bool featured, String? linkedinUrl, bool adultDeclared
});




}
/// @nodoc
class _$ShoutoutSettingsCopyWithImpl<$Res>
    implements $ShoutoutSettingsCopyWith<$Res> {
  _$ShoutoutSettingsCopyWithImpl(this._self, this._then);

  final ShoutoutSettings _self;
  final $Res Function(ShoutoutSettings) _then;

/// Create a copy of ShoutoutSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featured = null,Object? linkedinUrl = freezed,Object? adultDeclared = null,}) {
  return _then(_self.copyWith(
featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,adultDeclared: null == adultDeclared ? _self.adultDeclared : adultDeclared // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoutoutSettings].
extension ShoutoutSettingsPatterns on ShoutoutSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoutoutSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoutoutSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoutoutSettings value)  $default,){
final _that = this;
switch (_that) {
case _ShoutoutSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoutoutSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ShoutoutSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool featured,  String? linkedinUrl,  bool adultDeclared)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoutoutSettings() when $default != null:
return $default(_that.featured,_that.linkedinUrl,_that.adultDeclared);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool featured,  String? linkedinUrl,  bool adultDeclared)  $default,) {final _that = this;
switch (_that) {
case _ShoutoutSettings():
return $default(_that.featured,_that.linkedinUrl,_that.adultDeclared);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool featured,  String? linkedinUrl,  bool adultDeclared)?  $default,) {final _that = this;
switch (_that) {
case _ShoutoutSettings() when $default != null:
return $default(_that.featured,_that.linkedinUrl,_that.adultDeclared);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShoutoutSettings implements ShoutoutSettings {
  const _ShoutoutSettings({this.featured = false, this.linkedinUrl, this.adultDeclared = false});
  factory _ShoutoutSettings.fromJson(Map<String, dynamic> json) => _$ShoutoutSettingsFromJson(json);

/// Whether the `contest_shoutout` consent is in force. False until they
/// agree: the box is drawn from this, so it is never pre-ticked.
@override@JsonKey() final  bool featured;
/// The profile link on record, or null. Erased when [featured] is
/// switched off.
@override final  String? linkedinUrl;
/// Whether "I am 18 or older" is on record. False: the card asks for the
/// tick with the link, and sends it (`adult: true`).
@override@JsonKey() final  bool adultDeclared;

/// Create a copy of ShoutoutSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoutoutSettingsCopyWith<_ShoutoutSettings> get copyWith => __$ShoutoutSettingsCopyWithImpl<_ShoutoutSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShoutoutSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoutoutSettings&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.adultDeclared, adultDeclared) || other.adultDeclared == adultDeclared));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,featured,linkedinUrl,adultDeclared);

@override
String toString() {
  return 'ShoutoutSettings(featured: $featured, linkedinUrl: $linkedinUrl, adultDeclared: $adultDeclared)';
}


}

/// @nodoc
abstract mixin class _$ShoutoutSettingsCopyWith<$Res> implements $ShoutoutSettingsCopyWith<$Res> {
  factory _$ShoutoutSettingsCopyWith(_ShoutoutSettings value, $Res Function(_ShoutoutSettings) _then) = __$ShoutoutSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool featured, String? linkedinUrl, bool adultDeclared
});




}
/// @nodoc
class __$ShoutoutSettingsCopyWithImpl<$Res>
    implements _$ShoutoutSettingsCopyWith<$Res> {
  __$ShoutoutSettingsCopyWithImpl(this._self, this._then);

  final _ShoutoutSettings _self;
  final $Res Function(_ShoutoutSettings) _then;

/// Create a copy of ShoutoutSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featured = null,Object? linkedinUrl = freezed,Object? adultDeclared = null,}) {
  return _then(_ShoutoutSettings(
featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,adultDeclared: null == adultDeclared ? _self.adultDeclared : adultDeclared // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
