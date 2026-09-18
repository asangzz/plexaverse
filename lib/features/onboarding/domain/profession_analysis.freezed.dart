// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profession_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfessionAnalysis {

 String get profession; String get industry;/// Ids from the server's `PROFILE_CATEGORIES`. Written straight to
/// `preferences.postCategories`.
 List<String> get suggestedCategories; String get expertise; String get roadmapTitle;
/// Create a copy of ProfessionAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfessionAnalysisCopyWith<ProfessionAnalysis> get copyWith => _$ProfessionAnalysisCopyWithImpl<ProfessionAnalysis>(this as ProfessionAnalysis, _$identity);

  /// Serializes this ProfessionAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfessionAnalysis&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other.suggestedCategories, suggestedCategories)&&(identical(other.expertise, expertise) || other.expertise == expertise)&&(identical(other.roadmapTitle, roadmapTitle) || other.roadmapTitle == roadmapTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profession,industry,const DeepCollectionEquality().hash(suggestedCategories),expertise,roadmapTitle);

@override
String toString() {
  return 'ProfessionAnalysis(profession: $profession, industry: $industry, suggestedCategories: $suggestedCategories, expertise: $expertise, roadmapTitle: $roadmapTitle)';
}


}

/// @nodoc
abstract mixin class $ProfessionAnalysisCopyWith<$Res>  {
  factory $ProfessionAnalysisCopyWith(ProfessionAnalysis value, $Res Function(ProfessionAnalysis) _then) = _$ProfessionAnalysisCopyWithImpl;
@useResult
$Res call({
 String profession, String industry, List<String> suggestedCategories, String expertise, String roadmapTitle
});




}
/// @nodoc
class _$ProfessionAnalysisCopyWithImpl<$Res>
    implements $ProfessionAnalysisCopyWith<$Res> {
  _$ProfessionAnalysisCopyWithImpl(this._self, this._then);

  final ProfessionAnalysis _self;
  final $Res Function(ProfessionAnalysis) _then;

/// Create a copy of ProfessionAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profession = null,Object? industry = null,Object? suggestedCategories = null,Object? expertise = null,Object? roadmapTitle = null,}) {
  return _then(_self.copyWith(
profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,industry: null == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String,suggestedCategories: null == suggestedCategories ? _self.suggestedCategories : suggestedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,expertise: null == expertise ? _self.expertise : expertise // ignore: cast_nullable_to_non_nullable
as String,roadmapTitle: null == roadmapTitle ? _self.roadmapTitle : roadmapTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfessionAnalysis].
extension ProfessionAnalysisPatterns on ProfessionAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfessionAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfessionAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfessionAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _ProfessionAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfessionAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _ProfessionAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profession,  String industry,  List<String> suggestedCategories,  String expertise,  String roadmapTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfessionAnalysis() when $default != null:
return $default(_that.profession,_that.industry,_that.suggestedCategories,_that.expertise,_that.roadmapTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profession,  String industry,  List<String> suggestedCategories,  String expertise,  String roadmapTitle)  $default,) {final _that = this;
switch (_that) {
case _ProfessionAnalysis():
return $default(_that.profession,_that.industry,_that.suggestedCategories,_that.expertise,_that.roadmapTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profession,  String industry,  List<String> suggestedCategories,  String expertise,  String roadmapTitle)?  $default,) {final _that = this;
switch (_that) {
case _ProfessionAnalysis() when $default != null:
return $default(_that.profession,_that.industry,_that.suggestedCategories,_that.expertise,_that.roadmapTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfessionAnalysis implements ProfessionAnalysis {
  const _ProfessionAnalysis({this.profession = '', this.industry = '', final  List<String> suggestedCategories = const <String>[], this.expertise = '', this.roadmapTitle = ''}): _suggestedCategories = suggestedCategories;
  factory _ProfessionAnalysis.fromJson(Map<String, dynamic> json) => _$ProfessionAnalysisFromJson(json);

@override@JsonKey() final  String profession;
@override@JsonKey() final  String industry;
/// Ids from the server's `PROFILE_CATEGORIES`. Written straight to
/// `preferences.postCategories`.
 final  List<String> _suggestedCategories;
/// Ids from the server's `PROFILE_CATEGORIES`. Written straight to
/// `preferences.postCategories`.
@override@JsonKey() List<String> get suggestedCategories {
  if (_suggestedCategories is EqualUnmodifiableListView) return _suggestedCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedCategories);
}

@override@JsonKey() final  String expertise;
@override@JsonKey() final  String roadmapTitle;

/// Create a copy of ProfessionAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfessionAnalysisCopyWith<_ProfessionAnalysis> get copyWith => __$ProfessionAnalysisCopyWithImpl<_ProfessionAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfessionAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfessionAnalysis&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other._suggestedCategories, _suggestedCategories)&&(identical(other.expertise, expertise) || other.expertise == expertise)&&(identical(other.roadmapTitle, roadmapTitle) || other.roadmapTitle == roadmapTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profession,industry,const DeepCollectionEquality().hash(_suggestedCategories),expertise,roadmapTitle);

@override
String toString() {
  return 'ProfessionAnalysis(profession: $profession, industry: $industry, suggestedCategories: $suggestedCategories, expertise: $expertise, roadmapTitle: $roadmapTitle)';
}


}

/// @nodoc
abstract mixin class _$ProfessionAnalysisCopyWith<$Res> implements $ProfessionAnalysisCopyWith<$Res> {
  factory _$ProfessionAnalysisCopyWith(_ProfessionAnalysis value, $Res Function(_ProfessionAnalysis) _then) = __$ProfessionAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String profession, String industry, List<String> suggestedCategories, String expertise, String roadmapTitle
});




}
/// @nodoc
class __$ProfessionAnalysisCopyWithImpl<$Res>
    implements _$ProfessionAnalysisCopyWith<$Res> {
  __$ProfessionAnalysisCopyWithImpl(this._self, this._then);

  final _ProfessionAnalysis _self;
  final $Res Function(_ProfessionAnalysis) _then;

/// Create a copy of ProfessionAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profession = null,Object? industry = null,Object? suggestedCategories = null,Object? expertise = null,Object? roadmapTitle = null,}) {
  return _then(_ProfessionAnalysis(
profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,industry: null == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String,suggestedCategories: null == suggestedCategories ? _self._suggestedCategories : suggestedCategories // ignore: cast_nullable_to_non_nullable
as List<String>,expertise: null == expertise ? _self.expertise : expertise // ignore: cast_nullable_to_non_nullable
as String,roadmapTitle: null == roadmapTitle ? _self.roadmapTitle : roadmapTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
