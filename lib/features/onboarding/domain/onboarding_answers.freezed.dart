// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_answers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingAnswers {

 BrandChoice? get brand;/// The `current-role` answer. Becomes `preferences.profession`.
 String? get role; OnboardingGoal? get goal;/// The writing sample. Saved separately to the style memory (it is an
/// embedding, not a preferences column), and kept here only so a failed
/// save can be retried without re-asking.
 String? get voiceSample;/// **Company brand only.** The LinkedIn page company posts publish to.
/// Without it `brandType: 'company'` is a setting with nowhere to act.
 String? get companyPageId; String? get companyPageName;/// **Company brand only.** The company document. These anchor every
/// generated company post, which is why the flow asks rather than
/// letting the model infer a company from its page name.
 String? get companyDescription; String? get companyIndustry; String? get companyTagline;/// Filled from `POST /ai/analyze-profession`, which the web calls with the
/// user's headline. Best-effort: all three stay null when the call fails,
/// and the finalise simply sends less.
 String? get profession; String? get industry; List<String> get postCategories;
/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingAnswersCopyWith<OnboardingAnswers> get copyWith => _$OnboardingAnswersCopyWithImpl<OnboardingAnswers>(this as OnboardingAnswers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingAnswers&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.role, role) || other.role == role)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.voiceSample, voiceSample) || other.voiceSample == voiceSample)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyTagline, companyTagline) || other.companyTagline == companyTagline)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other.postCategories, postCategories));
}


@override
int get hashCode => Object.hash(runtimeType,brand,role,goal,voiceSample,companyPageId,companyPageName,companyDescription,companyIndustry,companyTagline,profession,industry,const DeepCollectionEquality().hash(postCategories));

@override
String toString() {
  return 'OnboardingAnswers(brand: $brand, role: $role, goal: $goal, voiceSample: $voiceSample, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDescription: $companyDescription, companyIndustry: $companyIndustry, companyTagline: $companyTagline, profession: $profession, industry: $industry, postCategories: $postCategories)';
}


}

/// @nodoc
abstract mixin class $OnboardingAnswersCopyWith<$Res>  {
  factory $OnboardingAnswersCopyWith(OnboardingAnswers value, $Res Function(OnboardingAnswers) _then) = _$OnboardingAnswersCopyWithImpl;
@useResult
$Res call({
 BrandChoice? brand, String? role, OnboardingGoal? goal, String? voiceSample, String? companyPageId, String? companyPageName, String? companyDescription, String? companyIndustry, String? companyTagline, String? profession, String? industry, List<String> postCategories
});




}
/// @nodoc
class _$OnboardingAnswersCopyWithImpl<$Res>
    implements $OnboardingAnswersCopyWith<$Res> {
  _$OnboardingAnswersCopyWithImpl(this._self, this._then);

  final OnboardingAnswers _self;
  final $Res Function(OnboardingAnswers) _then;

/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brand = freezed,Object? role = freezed,Object? goal = freezed,Object? voiceSample = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDescription = freezed,Object? companyIndustry = freezed,Object? companyTagline = freezed,Object? profession = freezed,Object? industry = freezed,Object? postCategories = null,}) {
  return _then(_self.copyWith(
brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandChoice?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as OnboardingGoal?,voiceSample: freezed == voiceSample ? _self.voiceSample : voiceSample // ignore: cast_nullable_to_non_nullable
as String?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyTagline: freezed == companyTagline ? _self.companyTagline : companyTagline // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,postCategories: null == postCategories ? _self.postCategories : postCategories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingAnswers].
extension OnboardingAnswersPatterns on OnboardingAnswers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingAnswers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingAnswers value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingAnswers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingAnswers value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BrandChoice? brand,  String? role,  OnboardingGoal? goal,  String? voiceSample,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? profession,  String? industry,  List<String> postCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.brand,_that.role,_that.goal,_that.voiceSample,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.profession,_that.industry,_that.postCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BrandChoice? brand,  String? role,  OnboardingGoal? goal,  String? voiceSample,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? profession,  String? industry,  List<String> postCategories)  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers():
return $default(_that.brand,_that.role,_that.goal,_that.voiceSample,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.profession,_that.industry,_that.postCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BrandChoice? brand,  String? role,  OnboardingGoal? goal,  String? voiceSample,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? profession,  String? industry,  List<String> postCategories)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.brand,_that.role,_that.goal,_that.voiceSample,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.profession,_that.industry,_that.postCategories);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingAnswers extends OnboardingAnswers {
  const _OnboardingAnswers({this.brand, this.role, this.goal, this.voiceSample, this.companyPageId, this.companyPageName, this.companyDescription, this.companyIndustry, this.companyTagline, this.profession, this.industry, final  List<String> postCategories = const <String>[]}): _postCategories = postCategories,super._();
  

@override final  BrandChoice? brand;
/// The `current-role` answer. Becomes `preferences.profession`.
@override final  String? role;
@override final  OnboardingGoal? goal;
/// The writing sample. Saved separately to the style memory (it is an
/// embedding, not a preferences column), and kept here only so a failed
/// save can be retried without re-asking.
@override final  String? voiceSample;
/// **Company brand only.** The LinkedIn page company posts publish to.
/// Without it `brandType: 'company'` is a setting with nowhere to act.
@override final  String? companyPageId;
@override final  String? companyPageName;
/// **Company brand only.** The company document. These anchor every
/// generated company post, which is why the flow asks rather than
/// letting the model infer a company from its page name.
@override final  String? companyDescription;
@override final  String? companyIndustry;
@override final  String? companyTagline;
/// Filled from `POST /ai/analyze-profession`, which the web calls with the
/// user's headline. Best-effort: all three stay null when the call fails,
/// and the finalise simply sends less.
@override final  String? profession;
@override final  String? industry;
 final  List<String> _postCategories;
@override@JsonKey() List<String> get postCategories {
  if (_postCategories is EqualUnmodifiableListView) return _postCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postCategories);
}


/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingAnswersCopyWith<_OnboardingAnswers> get copyWith => __$OnboardingAnswersCopyWithImpl<_OnboardingAnswers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingAnswers&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.role, role) || other.role == role)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.voiceSample, voiceSample) || other.voiceSample == voiceSample)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyTagline, companyTagline) || other.companyTagline == companyTagline)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other._postCategories, _postCategories));
}


@override
int get hashCode => Object.hash(runtimeType,brand,role,goal,voiceSample,companyPageId,companyPageName,companyDescription,companyIndustry,companyTagline,profession,industry,const DeepCollectionEquality().hash(_postCategories));

@override
String toString() {
  return 'OnboardingAnswers(brand: $brand, role: $role, goal: $goal, voiceSample: $voiceSample, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDescription: $companyDescription, companyIndustry: $companyIndustry, companyTagline: $companyTagline, profession: $profession, industry: $industry, postCategories: $postCategories)';
}


}

/// @nodoc
abstract mixin class _$OnboardingAnswersCopyWith<$Res> implements $OnboardingAnswersCopyWith<$Res> {
  factory _$OnboardingAnswersCopyWith(_OnboardingAnswers value, $Res Function(_OnboardingAnswers) _then) = __$OnboardingAnswersCopyWithImpl;
@override @useResult
$Res call({
 BrandChoice? brand, String? role, OnboardingGoal? goal, String? voiceSample, String? companyPageId, String? companyPageName, String? companyDescription, String? companyIndustry, String? companyTagline, String? profession, String? industry, List<String> postCategories
});




}
/// @nodoc
class __$OnboardingAnswersCopyWithImpl<$Res>
    implements _$OnboardingAnswersCopyWith<$Res> {
  __$OnboardingAnswersCopyWithImpl(this._self, this._then);

  final _OnboardingAnswers _self;
  final $Res Function(_OnboardingAnswers) _then;

/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brand = freezed,Object? role = freezed,Object? goal = freezed,Object? voiceSample = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDescription = freezed,Object? companyIndustry = freezed,Object? companyTagline = freezed,Object? profession = freezed,Object? industry = freezed,Object? postCategories = null,}) {
  return _then(_OnboardingAnswers(
brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandChoice?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as OnboardingGoal?,voiceSample: freezed == voiceSample ? _self.voiceSample : voiceSample // ignore: cast_nullable_to_non_nullable
as String?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyTagline: freezed == companyTagline ? _self.companyTagline : companyTagline // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,postCategories: null == postCategories ? _self._postCategories : postCategories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
