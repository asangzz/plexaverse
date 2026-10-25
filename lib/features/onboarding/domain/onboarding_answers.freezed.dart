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

 BrandChoice? get brand;/// The LinkedIn profile PDF was imported. Sent as `cvUploaded`.
 bool get usedCvUpload;/// The parsed CV — or, when the CV was skipped, just the role the user
/// picked, as `profession`. The web keeps both in one `parsedCV`.
 ParsedCv? get cv; String? get companyPageId; String? get companyPageName;/// The parsed company document, merged with the details form.
 CompanyDoc? get companyDoc; String? get companyLogoUrl; PosterStyle? get posterStyle;
/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingAnswersCopyWith<OnboardingAnswers> get copyWith => _$OnboardingAnswersCopyWithImpl<OnboardingAnswers>(this as OnboardingAnswers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingAnswers&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.usedCvUpload, usedCvUpload) || other.usedCvUpload == usedCvUpload)&&(identical(other.cv, cv) || other.cv == cv)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDoc, companyDoc) || other.companyDoc == companyDoc)&&(identical(other.companyLogoUrl, companyLogoUrl) || other.companyLogoUrl == companyLogoUrl)&&(identical(other.posterStyle, posterStyle) || other.posterStyle == posterStyle));
}


@override
int get hashCode => Object.hash(runtimeType,brand,usedCvUpload,cv,companyPageId,companyPageName,companyDoc,companyLogoUrl,posterStyle);

@override
String toString() {
  return 'OnboardingAnswers(brand: $brand, usedCvUpload: $usedCvUpload, cv: $cv, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDoc: $companyDoc, companyLogoUrl: $companyLogoUrl, posterStyle: $posterStyle)';
}


}

/// @nodoc
abstract mixin class $OnboardingAnswersCopyWith<$Res>  {
  factory $OnboardingAnswersCopyWith(OnboardingAnswers value, $Res Function(OnboardingAnswers) _then) = _$OnboardingAnswersCopyWithImpl;
@useResult
$Res call({
 BrandChoice? brand, bool usedCvUpload, ParsedCv? cv, String? companyPageId, String? companyPageName, CompanyDoc? companyDoc, String? companyLogoUrl, PosterStyle? posterStyle
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
@pragma('vm:prefer-inline') @override $Res call({Object? brand = freezed,Object? usedCvUpload = null,Object? cv = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDoc = freezed,Object? companyLogoUrl = freezed,Object? posterStyle = freezed,}) {
  return _then(_self.copyWith(
brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandChoice?,usedCvUpload: null == usedCvUpload ? _self.usedCvUpload : usedCvUpload // ignore: cast_nullable_to_non_nullable
as bool,cv: freezed == cv ? _self.cv : cv // ignore: cast_nullable_to_non_nullable
as ParsedCv?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDoc: freezed == companyDoc ? _self.companyDoc : companyDoc // ignore: cast_nullable_to_non_nullable
as CompanyDoc?,companyLogoUrl: freezed == companyLogoUrl ? _self.companyLogoUrl : companyLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,posterStyle: freezed == posterStyle ? _self.posterStyle : posterStyle // ignore: cast_nullable_to_non_nullable
as PosterStyle?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BrandChoice? brand,  bool usedCvUpload,  ParsedCv? cv,  String? companyPageId,  String? companyPageName,  CompanyDoc? companyDoc,  String? companyLogoUrl,  PosterStyle? posterStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.brand,_that.usedCvUpload,_that.cv,_that.companyPageId,_that.companyPageName,_that.companyDoc,_that.companyLogoUrl,_that.posterStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BrandChoice? brand,  bool usedCvUpload,  ParsedCv? cv,  String? companyPageId,  String? companyPageName,  CompanyDoc? companyDoc,  String? companyLogoUrl,  PosterStyle? posterStyle)  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers():
return $default(_that.brand,_that.usedCvUpload,_that.cv,_that.companyPageId,_that.companyPageName,_that.companyDoc,_that.companyLogoUrl,_that.posterStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BrandChoice? brand,  bool usedCvUpload,  ParsedCv? cv,  String? companyPageId,  String? companyPageName,  CompanyDoc? companyDoc,  String? companyLogoUrl,  PosterStyle? posterStyle)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingAnswers() when $default != null:
return $default(_that.brand,_that.usedCvUpload,_that.cv,_that.companyPageId,_that.companyPageName,_that.companyDoc,_that.companyLogoUrl,_that.posterStyle);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingAnswers extends OnboardingAnswers {
  const _OnboardingAnswers({this.brand, this.usedCvUpload = false, this.cv, this.companyPageId, this.companyPageName, this.companyDoc, this.companyLogoUrl, this.posterStyle}): super._();
  

@override final  BrandChoice? brand;
/// The LinkedIn profile PDF was imported. Sent as `cvUploaded`.
@override@JsonKey() final  bool usedCvUpload;
/// The parsed CV — or, when the CV was skipped, just the role the user
/// picked, as `profession`. The web keeps both in one `parsedCV`.
@override final  ParsedCv? cv;
@override final  String? companyPageId;
@override final  String? companyPageName;
/// The parsed company document, merged with the details form.
@override final  CompanyDoc? companyDoc;
@override final  String? companyLogoUrl;
@override final  PosterStyle? posterStyle;

/// Create a copy of OnboardingAnswers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingAnswersCopyWith<_OnboardingAnswers> get copyWith => __$OnboardingAnswersCopyWithImpl<_OnboardingAnswers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingAnswers&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.usedCvUpload, usedCvUpload) || other.usedCvUpload == usedCvUpload)&&(identical(other.cv, cv) || other.cv == cv)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDoc, companyDoc) || other.companyDoc == companyDoc)&&(identical(other.companyLogoUrl, companyLogoUrl) || other.companyLogoUrl == companyLogoUrl)&&(identical(other.posterStyle, posterStyle) || other.posterStyle == posterStyle));
}


@override
int get hashCode => Object.hash(runtimeType,brand,usedCvUpload,cv,companyPageId,companyPageName,companyDoc,companyLogoUrl,posterStyle);

@override
String toString() {
  return 'OnboardingAnswers(brand: $brand, usedCvUpload: $usedCvUpload, cv: $cv, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDoc: $companyDoc, companyLogoUrl: $companyLogoUrl, posterStyle: $posterStyle)';
}


}

/// @nodoc
abstract mixin class _$OnboardingAnswersCopyWith<$Res> implements $OnboardingAnswersCopyWith<$Res> {
  factory _$OnboardingAnswersCopyWith(_OnboardingAnswers value, $Res Function(_OnboardingAnswers) _then) = __$OnboardingAnswersCopyWithImpl;
@override @useResult
$Res call({
 BrandChoice? brand, bool usedCvUpload, ParsedCv? cv, String? companyPageId, String? companyPageName, CompanyDoc? companyDoc, String? companyLogoUrl, PosterStyle? posterStyle
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
@override @pragma('vm:prefer-inline') $Res call({Object? brand = freezed,Object? usedCvUpload = null,Object? cv = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDoc = freezed,Object? companyLogoUrl = freezed,Object? posterStyle = freezed,}) {
  return _then(_OnboardingAnswers(
brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandChoice?,usedCvUpload: null == usedCvUpload ? _self.usedCvUpload : usedCvUpload // ignore: cast_nullable_to_non_nullable
as bool,cv: freezed == cv ? _self.cv : cv // ignore: cast_nullable_to_non_nullable
as ParsedCv?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDoc: freezed == companyDoc ? _self.companyDoc : companyDoc // ignore: cast_nullable_to_non_nullable
as CompanyDoc?,companyLogoUrl: freezed == companyLogoUrl ? _self.companyLogoUrl : companyLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,posterStyle: freezed == posterStyle ? _self.posterStyle : posterStyle // ignore: cast_nullable_to_non_nullable
as PosterStyle?,
  ));
}


}

// dart format on
