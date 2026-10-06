// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persona_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonaIdentity {

/// From `/auth/me`; every other field is a preferences column.
 String get name; String? get profession; String? get headline; String? get industry; List<String> get skills;/// `postCategories` on the wire — what the week's topics are drawn from.
 List<String> get topics;/// The role the user is moving toward. Rendered "(transitioning)" when
/// [contentMode] is `transformation`, because in that mode the posts argue
/// FROM the target role rather than the current one.
 String? get targetRole; String get contentMode; bool get isCompany; String? get companyName; String? get companyIndustry; String? get companyDescription; List<String> get companyFeatures;
/// Create a copy of PersonaIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaIdentityCopyWith<PersonaIdentity> get copyWith => _$PersonaIdentityCopyWithImpl<PersonaIdentity>(this as PersonaIdentity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaIdentity&&(identical(other.name, name) || other.name == name)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.topics, topics)&&(identical(other.targetRole, targetRole) || other.targetRole == targetRole)&&(identical(other.contentMode, contentMode) || other.contentMode == contentMode)&&(identical(other.isCompany, isCompany) || other.isCompany == isCompany)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&const DeepCollectionEquality().equals(other.companyFeatures, companyFeatures));
}


@override
int get hashCode => Object.hash(runtimeType,name,profession,headline,industry,const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(topics),targetRole,contentMode,isCompany,companyName,companyIndustry,companyDescription,const DeepCollectionEquality().hash(companyFeatures));

@override
String toString() {
  return 'PersonaIdentity(name: $name, profession: $profession, headline: $headline, industry: $industry, skills: $skills, topics: $topics, targetRole: $targetRole, contentMode: $contentMode, isCompany: $isCompany, companyName: $companyName, companyIndustry: $companyIndustry, companyDescription: $companyDescription, companyFeatures: $companyFeatures)';
}


}

/// @nodoc
abstract mixin class $PersonaIdentityCopyWith<$Res>  {
  factory $PersonaIdentityCopyWith(PersonaIdentity value, $Res Function(PersonaIdentity) _then) = _$PersonaIdentityCopyWithImpl;
@useResult
$Res call({
 String name, String? profession, String? headline, String? industry, List<String> skills, List<String> topics, String? targetRole, String contentMode, bool isCompany, String? companyName, String? companyIndustry, String? companyDescription, List<String> companyFeatures
});




}
/// @nodoc
class _$PersonaIdentityCopyWithImpl<$Res>
    implements $PersonaIdentityCopyWith<$Res> {
  _$PersonaIdentityCopyWithImpl(this._self, this._then);

  final PersonaIdentity _self;
  final $Res Function(PersonaIdentity) _then;

/// Create a copy of PersonaIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? profession = freezed,Object? headline = freezed,Object? industry = freezed,Object? skills = null,Object? topics = null,Object? targetRole = freezed,Object? contentMode = null,Object? isCompany = null,Object? companyName = freezed,Object? companyIndustry = freezed,Object? companyDescription = freezed,Object? companyFeatures = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,targetRole: freezed == targetRole ? _self.targetRole : targetRole // ignore: cast_nullable_to_non_nullable
as String?,contentMode: null == contentMode ? _self.contentMode : contentMode // ignore: cast_nullable_to_non_nullable
as String,isCompany: null == isCompany ? _self.isCompany : isCompany // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyFeatures: null == companyFeatures ? _self.companyFeatures : companyFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonaIdentity].
extension PersonaIdentityPatterns on PersonaIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonaIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonaIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonaIdentity value)  $default,){
final _that = this;
switch (_that) {
case _PersonaIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonaIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _PersonaIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? profession,  String? headline,  String? industry,  List<String> skills,  List<String> topics,  String? targetRole,  String contentMode,  bool isCompany,  String? companyName,  String? companyIndustry,  String? companyDescription,  List<String> companyFeatures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaIdentity() when $default != null:
return $default(_that.name,_that.profession,_that.headline,_that.industry,_that.skills,_that.topics,_that.targetRole,_that.contentMode,_that.isCompany,_that.companyName,_that.companyIndustry,_that.companyDescription,_that.companyFeatures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? profession,  String? headline,  String? industry,  List<String> skills,  List<String> topics,  String? targetRole,  String contentMode,  bool isCompany,  String? companyName,  String? companyIndustry,  String? companyDescription,  List<String> companyFeatures)  $default,) {final _that = this;
switch (_that) {
case _PersonaIdentity():
return $default(_that.name,_that.profession,_that.headline,_that.industry,_that.skills,_that.topics,_that.targetRole,_that.contentMode,_that.isCompany,_that.companyName,_that.companyIndustry,_that.companyDescription,_that.companyFeatures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? profession,  String? headline,  String? industry,  List<String> skills,  List<String> topics,  String? targetRole,  String contentMode,  bool isCompany,  String? companyName,  String? companyIndustry,  String? companyDescription,  List<String> companyFeatures)?  $default,) {final _that = this;
switch (_that) {
case _PersonaIdentity() when $default != null:
return $default(_that.name,_that.profession,_that.headline,_that.industry,_that.skills,_that.topics,_that.targetRole,_that.contentMode,_that.isCompany,_that.companyName,_that.companyIndustry,_that.companyDescription,_that.companyFeatures);case _:
  return null;

}
}

}

/// @nodoc


class _PersonaIdentity extends PersonaIdentity {
  const _PersonaIdentity({this.name = '', this.profession, this.headline, this.industry, final  List<String> skills = const <String>[], final  List<String> topics = const <String>[], this.targetRole, this.contentMode = 'authority', this.isCompany = false, this.companyName, this.companyIndustry, this.companyDescription, final  List<String> companyFeatures = const <String>[]}): _skills = skills,_topics = topics,_companyFeatures = companyFeatures,super._();
  

/// From `/auth/me`; every other field is a preferences column.
@override@JsonKey() final  String name;
@override final  String? profession;
@override final  String? headline;
@override final  String? industry;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

/// `postCategories` on the wire — what the week's topics are drawn from.
 final  List<String> _topics;
/// `postCategories` on the wire — what the week's topics are drawn from.
@override@JsonKey() List<String> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

/// The role the user is moving toward. Rendered "(transitioning)" when
/// [contentMode] is `transformation`, because in that mode the posts argue
/// FROM the target role rather than the current one.
@override final  String? targetRole;
@override@JsonKey() final  String contentMode;
@override@JsonKey() final  bool isCompany;
@override final  String? companyName;
@override final  String? companyIndustry;
@override final  String? companyDescription;
 final  List<String> _companyFeatures;
@override@JsonKey() List<String> get companyFeatures {
  if (_companyFeatures is EqualUnmodifiableListView) return _companyFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companyFeatures);
}


/// Create a copy of PersonaIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaIdentityCopyWith<_PersonaIdentity> get copyWith => __$PersonaIdentityCopyWithImpl<_PersonaIdentity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaIdentity&&(identical(other.name, name) || other.name == name)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._topics, _topics)&&(identical(other.targetRole, targetRole) || other.targetRole == targetRole)&&(identical(other.contentMode, contentMode) || other.contentMode == contentMode)&&(identical(other.isCompany, isCompany) || other.isCompany == isCompany)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&const DeepCollectionEquality().equals(other._companyFeatures, _companyFeatures));
}


@override
int get hashCode => Object.hash(runtimeType,name,profession,headline,industry,const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_topics),targetRole,contentMode,isCompany,companyName,companyIndustry,companyDescription,const DeepCollectionEquality().hash(_companyFeatures));

@override
String toString() {
  return 'PersonaIdentity(name: $name, profession: $profession, headline: $headline, industry: $industry, skills: $skills, topics: $topics, targetRole: $targetRole, contentMode: $contentMode, isCompany: $isCompany, companyName: $companyName, companyIndustry: $companyIndustry, companyDescription: $companyDescription, companyFeatures: $companyFeatures)';
}


}

/// @nodoc
abstract mixin class _$PersonaIdentityCopyWith<$Res> implements $PersonaIdentityCopyWith<$Res> {
  factory _$PersonaIdentityCopyWith(_PersonaIdentity value, $Res Function(_PersonaIdentity) _then) = __$PersonaIdentityCopyWithImpl;
@override @useResult
$Res call({
 String name, String? profession, String? headline, String? industry, List<String> skills, List<String> topics, String? targetRole, String contentMode, bool isCompany, String? companyName, String? companyIndustry, String? companyDescription, List<String> companyFeatures
});




}
/// @nodoc
class __$PersonaIdentityCopyWithImpl<$Res>
    implements _$PersonaIdentityCopyWith<$Res> {
  __$PersonaIdentityCopyWithImpl(this._self, this._then);

  final _PersonaIdentity _self;
  final $Res Function(_PersonaIdentity) _then;

/// Create a copy of PersonaIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? profession = freezed,Object? headline = freezed,Object? industry = freezed,Object? skills = null,Object? topics = null,Object? targetRole = freezed,Object? contentMode = null,Object? isCompany = null,Object? companyName = freezed,Object? companyIndustry = freezed,Object? companyDescription = freezed,Object? companyFeatures = null,}) {
  return _then(_PersonaIdentity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,targetRole: freezed == targetRole ? _self.targetRole : targetRole // ignore: cast_nullable_to_non_nullable
as String?,contentMode: null == contentMode ? _self.contentMode : contentMode // ignore: cast_nullable_to_non_nullable
as String,isCompany: null == isCompany ? _self.isCompany : isCompany // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyFeatures: null == companyFeatures ? _self._companyFeatures : companyFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$PersonaAudience {

 String? get role; String? get industry; String? get problem;
/// Create a copy of PersonaAudience
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaAudienceCopyWith<PersonaAudience> get copyWith => _$PersonaAudienceCopyWithImpl<PersonaAudience>(this as PersonaAudience, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaAudience&&(identical(other.role, role) || other.role == role)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode => Object.hash(runtimeType,role,industry,problem);

@override
String toString() {
  return 'PersonaAudience(role: $role, industry: $industry, problem: $problem)';
}


}

/// @nodoc
abstract mixin class $PersonaAudienceCopyWith<$Res>  {
  factory $PersonaAudienceCopyWith(PersonaAudience value, $Res Function(PersonaAudience) _then) = _$PersonaAudienceCopyWithImpl;
@useResult
$Res call({
 String? role, String? industry, String? problem
});




}
/// @nodoc
class _$PersonaAudienceCopyWithImpl<$Res>
    implements $PersonaAudienceCopyWith<$Res> {
  _$PersonaAudienceCopyWithImpl(this._self, this._then);

  final PersonaAudience _self;
  final $Res Function(PersonaAudience) _then;

/// Create a copy of PersonaAudience
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? industry = freezed,Object? problem = freezed,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonaAudience].
extension PersonaAudiencePatterns on PersonaAudience {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonaAudience value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonaAudience() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonaAudience value)  $default,){
final _that = this;
switch (_that) {
case _PersonaAudience():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonaAudience value)?  $default,){
final _that = this;
switch (_that) {
case _PersonaAudience() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? role,  String? industry,  String? problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaAudience() when $default != null:
return $default(_that.role,_that.industry,_that.problem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? role,  String? industry,  String? problem)  $default,) {final _that = this;
switch (_that) {
case _PersonaAudience():
return $default(_that.role,_that.industry,_that.problem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? role,  String? industry,  String? problem)?  $default,) {final _that = this;
switch (_that) {
case _PersonaAudience() when $default != null:
return $default(_that.role,_that.industry,_that.problem);case _:
  return null;

}
}

}

/// @nodoc


class _PersonaAudience extends PersonaAudience {
  const _PersonaAudience({this.role, this.industry, this.problem}): super._();
  

@override final  String? role;
@override final  String? industry;
@override final  String? problem;

/// Create a copy of PersonaAudience
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaAudienceCopyWith<_PersonaAudience> get copyWith => __$PersonaAudienceCopyWithImpl<_PersonaAudience>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaAudience&&(identical(other.role, role) || other.role == role)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode => Object.hash(runtimeType,role,industry,problem);

@override
String toString() {
  return 'PersonaAudience(role: $role, industry: $industry, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$PersonaAudienceCopyWith<$Res> implements $PersonaAudienceCopyWith<$Res> {
  factory _$PersonaAudienceCopyWith(_PersonaAudience value, $Res Function(_PersonaAudience) _then) = __$PersonaAudienceCopyWithImpl;
@override @useResult
$Res call({
 String? role, String? industry, String? problem
});




}
/// @nodoc
class __$PersonaAudienceCopyWithImpl<$Res>
    implements _$PersonaAudienceCopyWith<$Res> {
  __$PersonaAudienceCopyWithImpl(this._self, this._then);

  final _PersonaAudience _self;
  final $Res Function(_PersonaAudience) _then;

/// Create a copy of PersonaAudience
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? industry = freezed,Object? problem = freezed,}) {
  return _then(_PersonaAudience(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SubstanceItem {

 String get id; String get kind; String get text; List<String> get entities; bool get hasNumber; String get source; DateTime? get happenedAt; DateTime? get usedAt; String? get usedInPostId;
/// Create a copy of SubstanceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubstanceItemCopyWith<SubstanceItem> get copyWith => _$SubstanceItemCopyWithImpl<SubstanceItem>(this as SubstanceItem, _$identity);

  /// Serializes this SubstanceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubstanceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.entities, entities)&&(identical(other.hasNumber, hasNumber) || other.hasNumber == hasNumber)&&(identical(other.source, source) || other.source == source)&&(identical(other.happenedAt, happenedAt) || other.happenedAt == happenedAt)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.usedInPostId, usedInPostId) || other.usedInPostId == usedInPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,text,const DeepCollectionEquality().hash(entities),hasNumber,source,happenedAt,usedAt,usedInPostId);

@override
String toString() {
  return 'SubstanceItem(id: $id, kind: $kind, text: $text, entities: $entities, hasNumber: $hasNumber, source: $source, happenedAt: $happenedAt, usedAt: $usedAt, usedInPostId: $usedInPostId)';
}


}

/// @nodoc
abstract mixin class $SubstanceItemCopyWith<$Res>  {
  factory $SubstanceItemCopyWith(SubstanceItem value, $Res Function(SubstanceItem) _then) = _$SubstanceItemCopyWithImpl;
@useResult
$Res call({
 String id, String kind, String text, List<String> entities, bool hasNumber, String source, DateTime? happenedAt, DateTime? usedAt, String? usedInPostId
});




}
/// @nodoc
class _$SubstanceItemCopyWithImpl<$Res>
    implements $SubstanceItemCopyWith<$Res> {
  _$SubstanceItemCopyWithImpl(this._self, this._then);

  final SubstanceItem _self;
  final $Res Function(SubstanceItem) _then;

/// Create a copy of SubstanceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? text = null,Object? entities = null,Object? hasNumber = null,Object? source = null,Object? happenedAt = freezed,Object? usedAt = freezed,Object? usedInPostId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,entities: null == entities ? _self.entities : entities // ignore: cast_nullable_to_non_nullable
as List<String>,hasNumber: null == hasNumber ? _self.hasNumber : hasNumber // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,happenedAt: freezed == happenedAt ? _self.happenedAt : happenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedInPostId: freezed == usedInPostId ? _self.usedInPostId : usedInPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubstanceItem].
extension SubstanceItemPatterns on SubstanceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubstanceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubstanceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubstanceItem value)  $default,){
final _that = this;
switch (_that) {
case _SubstanceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubstanceItem value)?  $default,){
final _that = this;
switch (_that) {
case _SubstanceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  String text,  List<String> entities,  bool hasNumber,  String source,  DateTime? happenedAt,  DateTime? usedAt,  String? usedInPostId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubstanceItem() when $default != null:
return $default(_that.id,_that.kind,_that.text,_that.entities,_that.hasNumber,_that.source,_that.happenedAt,_that.usedAt,_that.usedInPostId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  String text,  List<String> entities,  bool hasNumber,  String source,  DateTime? happenedAt,  DateTime? usedAt,  String? usedInPostId)  $default,) {final _that = this;
switch (_that) {
case _SubstanceItem():
return $default(_that.id,_that.kind,_that.text,_that.entities,_that.hasNumber,_that.source,_that.happenedAt,_that.usedAt,_that.usedInPostId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  String text,  List<String> entities,  bool hasNumber,  String source,  DateTime? happenedAt,  DateTime? usedAt,  String? usedInPostId)?  $default,) {final _that = this;
switch (_that) {
case _SubstanceItem() when $default != null:
return $default(_that.id,_that.kind,_that.text,_that.entities,_that.hasNumber,_that.source,_that.happenedAt,_that.usedAt,_that.usedInPostId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubstanceItem extends SubstanceItem {
  const _SubstanceItem({required this.id, this.kind = '', this.text = '', final  List<String> entities = const <String>[], this.hasNumber = false, this.source = '', this.happenedAt, this.usedAt, this.usedInPostId}): _entities = entities,super._();
  factory _SubstanceItem.fromJson(Map<String, dynamic> json) => _$SubstanceItemFromJson(json);

@override final  String id;
@override@JsonKey() final  String kind;
@override@JsonKey() final  String text;
 final  List<String> _entities;
@override@JsonKey() List<String> get entities {
  if (_entities is EqualUnmodifiableListView) return _entities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entities);
}

@override@JsonKey() final  bool hasNumber;
@override@JsonKey() final  String source;
@override final  DateTime? happenedAt;
@override final  DateTime? usedAt;
@override final  String? usedInPostId;

/// Create a copy of SubstanceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubstanceItemCopyWith<_SubstanceItem> get copyWith => __$SubstanceItemCopyWithImpl<_SubstanceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubstanceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubstanceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._entities, _entities)&&(identical(other.hasNumber, hasNumber) || other.hasNumber == hasNumber)&&(identical(other.source, source) || other.source == source)&&(identical(other.happenedAt, happenedAt) || other.happenedAt == happenedAt)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.usedInPostId, usedInPostId) || other.usedInPostId == usedInPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,text,const DeepCollectionEquality().hash(_entities),hasNumber,source,happenedAt,usedAt,usedInPostId);

@override
String toString() {
  return 'SubstanceItem(id: $id, kind: $kind, text: $text, entities: $entities, hasNumber: $hasNumber, source: $source, happenedAt: $happenedAt, usedAt: $usedAt, usedInPostId: $usedInPostId)';
}


}

/// @nodoc
abstract mixin class _$SubstanceItemCopyWith<$Res> implements $SubstanceItemCopyWith<$Res> {
  factory _$SubstanceItemCopyWith(_SubstanceItem value, $Res Function(_SubstanceItem) _then) = __$SubstanceItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, String text, List<String> entities, bool hasNumber, String source, DateTime? happenedAt, DateTime? usedAt, String? usedInPostId
});




}
/// @nodoc
class __$SubstanceItemCopyWithImpl<$Res>
    implements _$SubstanceItemCopyWith<$Res> {
  __$SubstanceItemCopyWithImpl(this._self, this._then);

  final _SubstanceItem _self;
  final $Res Function(_SubstanceItem) _then;

/// Create a copy of SubstanceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? text = null,Object? entities = null,Object? hasNumber = null,Object? source = null,Object? happenedAt = freezed,Object? usedAt = freezed,Object? usedInPostId = freezed,}) {
  return _then(_SubstanceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,entities: null == entities ? _self._entities : entities // ignore: cast_nullable_to_non_nullable
as List<String>,hasNumber: null == hasNumber ? _self.hasNumber : hasNumber // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,happenedAt: freezed == happenedAt ? _self.happenedAt : happenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedInPostId: freezed == usedInPostId ? _self.usedInPostId : usedInPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SubstanceBank {

 List<SubstanceItem> get available; List<SubstanceItem> get used; int get availableCount; int get usedCount;/// The bank could not be READ — a DB blip, not an empty bank.
///
/// Distinct from empty **on purpose**, and the distinction is the product
/// promise: an empty bank tells the user "Plexa won't invent a story to
/// fill the gap", which is true and actionable. Showing that when the read
/// simply failed is a lie, and it pushes the user to re-enter material
/// they already gave us.
 bool get unavailable;
/// Create a copy of SubstanceBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubstanceBankCopyWith<SubstanceBank> get copyWith => _$SubstanceBankCopyWithImpl<SubstanceBank>(this as SubstanceBank, _$identity);

  /// Serializes this SubstanceBank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubstanceBank&&const DeepCollectionEquality().equals(other.available, available)&&const DeepCollectionEquality().equals(other.used, used)&&(identical(other.availableCount, availableCount) || other.availableCount == availableCount)&&(identical(other.usedCount, usedCount) || other.usedCount == usedCount)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(available),const DeepCollectionEquality().hash(used),availableCount,usedCount,unavailable);

@override
String toString() {
  return 'SubstanceBank(available: $available, used: $used, availableCount: $availableCount, usedCount: $usedCount, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class $SubstanceBankCopyWith<$Res>  {
  factory $SubstanceBankCopyWith(SubstanceBank value, $Res Function(SubstanceBank) _then) = _$SubstanceBankCopyWithImpl;
@useResult
$Res call({
 List<SubstanceItem> available, List<SubstanceItem> used, int availableCount, int usedCount, bool unavailable
});




}
/// @nodoc
class _$SubstanceBankCopyWithImpl<$Res>
    implements $SubstanceBankCopyWith<$Res> {
  _$SubstanceBankCopyWithImpl(this._self, this._then);

  final SubstanceBank _self;
  final $Res Function(SubstanceBank) _then;

/// Create a copy of SubstanceBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? used = null,Object? availableCount = null,Object? usedCount = null,Object? unavailable = null,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as List<SubstanceItem>,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as List<SubstanceItem>,availableCount: null == availableCount ? _self.availableCount : availableCount // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubstanceBank].
extension SubstanceBankPatterns on SubstanceBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubstanceBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubstanceBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubstanceBank value)  $default,){
final _that = this;
switch (_that) {
case _SubstanceBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubstanceBank value)?  $default,){
final _that = this;
switch (_that) {
case _SubstanceBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubstanceItem> available,  List<SubstanceItem> used,  int availableCount,  int usedCount,  bool unavailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubstanceBank() when $default != null:
return $default(_that.available,_that.used,_that.availableCount,_that.usedCount,_that.unavailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubstanceItem> available,  List<SubstanceItem> used,  int availableCount,  int usedCount,  bool unavailable)  $default,) {final _that = this;
switch (_that) {
case _SubstanceBank():
return $default(_that.available,_that.used,_that.availableCount,_that.usedCount,_that.unavailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubstanceItem> available,  List<SubstanceItem> used,  int availableCount,  int usedCount,  bool unavailable)?  $default,) {final _that = this;
switch (_that) {
case _SubstanceBank() when $default != null:
return $default(_that.available,_that.used,_that.availableCount,_that.usedCount,_that.unavailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubstanceBank extends SubstanceBank {
  const _SubstanceBank({final  List<SubstanceItem> available = const <SubstanceItem>[], final  List<SubstanceItem> used = const <SubstanceItem>[], this.availableCount = 0, this.usedCount = 0, this.unavailable = false}): _available = available,_used = used,super._();
  factory _SubstanceBank.fromJson(Map<String, dynamic> json) => _$SubstanceBankFromJson(json);

 final  List<SubstanceItem> _available;
@override@JsonKey() List<SubstanceItem> get available {
  if (_available is EqualUnmodifiableListView) return _available;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_available);
}

 final  List<SubstanceItem> _used;
@override@JsonKey() List<SubstanceItem> get used {
  if (_used is EqualUnmodifiableListView) return _used;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_used);
}

@override@JsonKey() final  int availableCount;
@override@JsonKey() final  int usedCount;
/// The bank could not be READ — a DB blip, not an empty bank.
///
/// Distinct from empty **on purpose**, and the distinction is the product
/// promise: an empty bank tells the user "Plexa won't invent a story to
/// fill the gap", which is true and actionable. Showing that when the read
/// simply failed is a lie, and it pushes the user to re-enter material
/// they already gave us.
@override@JsonKey() final  bool unavailable;

/// Create a copy of SubstanceBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubstanceBankCopyWith<_SubstanceBank> get copyWith => __$SubstanceBankCopyWithImpl<_SubstanceBank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubstanceBankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubstanceBank&&const DeepCollectionEquality().equals(other._available, _available)&&const DeepCollectionEquality().equals(other._used, _used)&&(identical(other.availableCount, availableCount) || other.availableCount == availableCount)&&(identical(other.usedCount, usedCount) || other.usedCount == usedCount)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_available),const DeepCollectionEquality().hash(_used),availableCount,usedCount,unavailable);

@override
String toString() {
  return 'SubstanceBank(available: $available, used: $used, availableCount: $availableCount, usedCount: $usedCount, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class _$SubstanceBankCopyWith<$Res> implements $SubstanceBankCopyWith<$Res> {
  factory _$SubstanceBankCopyWith(_SubstanceBank value, $Res Function(_SubstanceBank) _then) = __$SubstanceBankCopyWithImpl;
@override @useResult
$Res call({
 List<SubstanceItem> available, List<SubstanceItem> used, int availableCount, int usedCount, bool unavailable
});




}
/// @nodoc
class __$SubstanceBankCopyWithImpl<$Res>
    implements _$SubstanceBankCopyWith<$Res> {
  __$SubstanceBankCopyWithImpl(this._self, this._then);

  final _SubstanceBank _self;
  final $Res Function(_SubstanceBank) _then;

/// Create a copy of SubstanceBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? used = null,Object? availableCount = null,Object? usedCount = null,Object? unavailable = null,}) {
  return _then(_SubstanceBank(
available: null == available ? _self._available : available // ignore: cast_nullable_to_non_nullable
as List<SubstanceItem>,used: null == used ? _self._used : used // ignore: cast_nullable_to_non_nullable
as List<SubstanceItem>,availableCount: null == availableCount ? _self.availableCount : availableCount // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PersonaSnapshot {

 PersonaIdentity get identity; PersonaAudience get audience; SubstanceBank get bank;/// How many writing samples the style memory holds. Drives the Voice row's
/// "Learned from N samples".
 int get voiceSampleCount;/// The latest follower count the user has told us, and when it was true.
///
/// Null means nothing has ever been recorded — by the `.xlsx` import or by
/// hand — which is the state the roadmap's checkpoint prompt exists for.
/// It was on the wire all along (`reach.followers`) and dropped on the
/// floor by the mapper below.
 FollowerReading? get followers;
/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaSnapshotCopyWith<PersonaSnapshot> get copyWith => _$PersonaSnapshotCopyWithImpl<PersonaSnapshot>(this as PersonaSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaSnapshot&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.voiceSampleCount, voiceSampleCount) || other.voiceSampleCount == voiceSampleCount)&&(identical(other.followers, followers) || other.followers == followers));
}


@override
int get hashCode => Object.hash(runtimeType,identity,audience,bank,voiceSampleCount,followers);

@override
String toString() {
  return 'PersonaSnapshot(identity: $identity, audience: $audience, bank: $bank, voiceSampleCount: $voiceSampleCount, followers: $followers)';
}


}

/// @nodoc
abstract mixin class $PersonaSnapshotCopyWith<$Res>  {
  factory $PersonaSnapshotCopyWith(PersonaSnapshot value, $Res Function(PersonaSnapshot) _then) = _$PersonaSnapshotCopyWithImpl;
@useResult
$Res call({
 PersonaIdentity identity, PersonaAudience audience, SubstanceBank bank, int voiceSampleCount, FollowerReading? followers
});


$PersonaIdentityCopyWith<$Res> get identity;$PersonaAudienceCopyWith<$Res> get audience;$SubstanceBankCopyWith<$Res> get bank;$FollowerReadingCopyWith<$Res>? get followers;

}
/// @nodoc
class _$PersonaSnapshotCopyWithImpl<$Res>
    implements $PersonaSnapshotCopyWith<$Res> {
  _$PersonaSnapshotCopyWithImpl(this._self, this._then);

  final PersonaSnapshot _self;
  final $Res Function(PersonaSnapshot) _then;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identity = null,Object? audience = null,Object? bank = null,Object? voiceSampleCount = null,Object? followers = freezed,}) {
  return _then(_self.copyWith(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as PersonaIdentity,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as PersonaAudience,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as SubstanceBank,voiceSampleCount: null == voiceSampleCount ? _self.voiceSampleCount : voiceSampleCount // ignore: cast_nullable_to_non_nullable
as int,followers: freezed == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as FollowerReading?,
  ));
}
/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonaIdentityCopyWith<$Res> get identity {
  
  return $PersonaIdentityCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonaAudienceCopyWith<$Res> get audience {
  
  return $PersonaAudienceCopyWith<$Res>(_self.audience, (value) {
    return _then(_self.copyWith(audience: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubstanceBankCopyWith<$Res> get bank {
  
  return $SubstanceBankCopyWith<$Res>(_self.bank, (value) {
    return _then(_self.copyWith(bank: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerReadingCopyWith<$Res>? get followers {
    if (_self.followers == null) {
    return null;
  }

  return $FollowerReadingCopyWith<$Res>(_self.followers!, (value) {
    return _then(_self.copyWith(followers: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonaSnapshot].
extension PersonaSnapshotPatterns on PersonaSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonaSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonaSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PersonaSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonaSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonaIdentity identity,  PersonaAudience audience,  SubstanceBank bank,  int voiceSampleCount,  FollowerReading? followers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
return $default(_that.identity,_that.audience,_that.bank,_that.voiceSampleCount,_that.followers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonaIdentity identity,  PersonaAudience audience,  SubstanceBank bank,  int voiceSampleCount,  FollowerReading? followers)  $default,) {final _that = this;
switch (_that) {
case _PersonaSnapshot():
return $default(_that.identity,_that.audience,_that.bank,_that.voiceSampleCount,_that.followers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonaIdentity identity,  PersonaAudience audience,  SubstanceBank bank,  int voiceSampleCount,  FollowerReading? followers)?  $default,) {final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
return $default(_that.identity,_that.audience,_that.bank,_that.voiceSampleCount,_that.followers);case _:
  return null;

}
}

}

/// @nodoc


class _PersonaSnapshot extends PersonaSnapshot {
  const _PersonaSnapshot({required this.identity, this.audience = const PersonaAudience(), this.bank = const SubstanceBank(), this.voiceSampleCount = 0, this.followers}): super._();
  

@override final  PersonaIdentity identity;
@override@JsonKey() final  PersonaAudience audience;
@override@JsonKey() final  SubstanceBank bank;
/// How many writing samples the style memory holds. Drives the Voice row's
/// "Learned from N samples".
@override@JsonKey() final  int voiceSampleCount;
/// The latest follower count the user has told us, and when it was true.
///
/// Null means nothing has ever been recorded — by the `.xlsx` import or by
/// hand — which is the state the roadmap's checkpoint prompt exists for.
/// It was on the wire all along (`reach.followers`) and dropped on the
/// floor by the mapper below.
@override final  FollowerReading? followers;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaSnapshotCopyWith<_PersonaSnapshot> get copyWith => __$PersonaSnapshotCopyWithImpl<_PersonaSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaSnapshot&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.voiceSampleCount, voiceSampleCount) || other.voiceSampleCount == voiceSampleCount)&&(identical(other.followers, followers) || other.followers == followers));
}


@override
int get hashCode => Object.hash(runtimeType,identity,audience,bank,voiceSampleCount,followers);

@override
String toString() {
  return 'PersonaSnapshot(identity: $identity, audience: $audience, bank: $bank, voiceSampleCount: $voiceSampleCount, followers: $followers)';
}


}

/// @nodoc
abstract mixin class _$PersonaSnapshotCopyWith<$Res> implements $PersonaSnapshotCopyWith<$Res> {
  factory _$PersonaSnapshotCopyWith(_PersonaSnapshot value, $Res Function(_PersonaSnapshot) _then) = __$PersonaSnapshotCopyWithImpl;
@override @useResult
$Res call({
 PersonaIdentity identity, PersonaAudience audience, SubstanceBank bank, int voiceSampleCount, FollowerReading? followers
});


@override $PersonaIdentityCopyWith<$Res> get identity;@override $PersonaAudienceCopyWith<$Res> get audience;@override $SubstanceBankCopyWith<$Res> get bank;@override $FollowerReadingCopyWith<$Res>? get followers;

}
/// @nodoc
class __$PersonaSnapshotCopyWithImpl<$Res>
    implements _$PersonaSnapshotCopyWith<$Res> {
  __$PersonaSnapshotCopyWithImpl(this._self, this._then);

  final _PersonaSnapshot _self;
  final $Res Function(_PersonaSnapshot) _then;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identity = null,Object? audience = null,Object? bank = null,Object? voiceSampleCount = null,Object? followers = freezed,}) {
  return _then(_PersonaSnapshot(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as PersonaIdentity,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as PersonaAudience,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as SubstanceBank,voiceSampleCount: null == voiceSampleCount ? _self.voiceSampleCount : voiceSampleCount // ignore: cast_nullable_to_non_nullable
as int,followers: freezed == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as FollowerReading?,
  ));
}

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonaIdentityCopyWith<$Res> get identity {
  
  return $PersonaIdentityCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonaAudienceCopyWith<$Res> get audience {
  
  return $PersonaAudienceCopyWith<$Res>(_self.audience, (value) {
    return _then(_self.copyWith(audience: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubstanceBankCopyWith<$Res> get bank {
  
  return $SubstanceBankCopyWith<$Res>(_self.bank, (value) {
    return _then(_self.copyWith(bank: value));
  });
}/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerReadingCopyWith<$Res>? get followers {
    if (_self.followers == null) {
    return null;
  }

  return $FollowerReadingCopyWith<$Res>(_self.followers!, (value) {
    return _then(_self.copyWith(followers: value));
  });
}
}


/// @nodoc
mixin _$FollowerReading {

 int get count;/// ISO 8601, as the server stored it.
 String get measuredAt;
/// Create a copy of FollowerReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerReadingCopyWith<FollowerReading> get copyWith => _$FollowerReadingCopyWithImpl<FollowerReading>(this as FollowerReading, _$identity);

  /// Serializes this FollowerReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerReading&&(identical(other.count, count) || other.count == count)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,measuredAt);

@override
String toString() {
  return 'FollowerReading(count: $count, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class $FollowerReadingCopyWith<$Res>  {
  factory $FollowerReadingCopyWith(FollowerReading value, $Res Function(FollowerReading) _then) = _$FollowerReadingCopyWithImpl;
@useResult
$Res call({
 int count, String measuredAt
});




}
/// @nodoc
class _$FollowerReadingCopyWithImpl<$Res>
    implements $FollowerReadingCopyWith<$Res> {
  _$FollowerReadingCopyWithImpl(this._self, this._then);

  final FollowerReading _self;
  final $Res Function(FollowerReading) _then;

/// Create a copy of FollowerReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? measuredAt = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowerReading].
extension FollowerReadingPatterns on FollowerReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerReading value)  $default,){
final _that = this;
switch (_that) {
case _FollowerReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerReading value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String measuredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerReading() when $default != null:
return $default(_that.count,_that.measuredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String measuredAt)  $default,) {final _that = this;
switch (_that) {
case _FollowerReading():
return $default(_that.count,_that.measuredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String measuredAt)?  $default,) {final _that = this;
switch (_that) {
case _FollowerReading() when $default != null:
return $default(_that.count,_that.measuredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowerReading extends FollowerReading {
  const _FollowerReading({this.count = 0, this.measuredAt = ''}): super._();
  factory _FollowerReading.fromJson(Map<String, dynamic> json) => _$FollowerReadingFromJson(json);

@override@JsonKey() final  int count;
/// ISO 8601, as the server stored it.
@override@JsonKey() final  String measuredAt;

/// Create a copy of FollowerReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerReadingCopyWith<_FollowerReading> get copyWith => __$FollowerReadingCopyWithImpl<_FollowerReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowerReadingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerReading&&(identical(other.count, count) || other.count == count)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,measuredAt);

@override
String toString() {
  return 'FollowerReading(count: $count, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class _$FollowerReadingCopyWith<$Res> implements $FollowerReadingCopyWith<$Res> {
  factory _$FollowerReadingCopyWith(_FollowerReading value, $Res Function(_FollowerReading) _then) = __$FollowerReadingCopyWithImpl;
@override @useResult
$Res call({
 int count, String measuredAt
});




}
/// @nodoc
class __$FollowerReadingCopyWithImpl<$Res>
    implements _$FollowerReadingCopyWith<$Res> {
  __$FollowerReadingCopyWithImpl(this._self, this._then);

  final _FollowerReading _self;
  final $Res Function(_FollowerReading) _then;

/// Create a copy of FollowerReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? measuredAt = null,}) {
  return _then(_FollowerReading(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PersonaReply {

 String get reply;/// Suggested edits to the persona. **Never applied by the chat turn** —
/// the user accepts them explicitly, which is why `apply` is its own call.
/// A conversation must not silently rewrite who the user says they are.
 List<PersonaProposal> get proposals;
/// Create a copy of PersonaReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaReplyCopyWith<PersonaReply> get copyWith => _$PersonaReplyCopyWithImpl<PersonaReply>(this as PersonaReply, _$identity);

  /// Serializes this PersonaReply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaReply&&(identical(other.reply, reply) || other.reply == reply)&&const DeepCollectionEquality().equals(other.proposals, proposals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,const DeepCollectionEquality().hash(proposals));

@override
String toString() {
  return 'PersonaReply(reply: $reply, proposals: $proposals)';
}


}

/// @nodoc
abstract mixin class $PersonaReplyCopyWith<$Res>  {
  factory $PersonaReplyCopyWith(PersonaReply value, $Res Function(PersonaReply) _then) = _$PersonaReplyCopyWithImpl;
@useResult
$Res call({
 String reply, List<PersonaProposal> proposals
});




}
/// @nodoc
class _$PersonaReplyCopyWithImpl<$Res>
    implements $PersonaReplyCopyWith<$Res> {
  _$PersonaReplyCopyWithImpl(this._self, this._then);

  final PersonaReply _self;
  final $Res Function(PersonaReply) _then;

/// Create a copy of PersonaReply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reply = null,Object? proposals = null,}) {
  return _then(_self.copyWith(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,proposals: null == proposals ? _self.proposals : proposals // ignore: cast_nullable_to_non_nullable
as List<PersonaProposal>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonaReply].
extension PersonaReplyPatterns on PersonaReply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonaReply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonaReply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonaReply value)  $default,){
final _that = this;
switch (_that) {
case _PersonaReply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonaReply value)?  $default,){
final _that = this;
switch (_that) {
case _PersonaReply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reply,  List<PersonaProposal> proposals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaReply() when $default != null:
return $default(_that.reply,_that.proposals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reply,  List<PersonaProposal> proposals)  $default,) {final _that = this;
switch (_that) {
case _PersonaReply():
return $default(_that.reply,_that.proposals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reply,  List<PersonaProposal> proposals)?  $default,) {final _that = this;
switch (_that) {
case _PersonaReply() when $default != null:
return $default(_that.reply,_that.proposals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonaReply extends PersonaReply {
  const _PersonaReply({this.reply = '', final  List<PersonaProposal> proposals = const <PersonaProposal>[]}): _proposals = proposals,super._();
  factory _PersonaReply.fromJson(Map<String, dynamic> json) => _$PersonaReplyFromJson(json);

@override@JsonKey() final  String reply;
/// Suggested edits to the persona. **Never applied by the chat turn** —
/// the user accepts them explicitly, which is why `apply` is its own call.
/// A conversation must not silently rewrite who the user says they are.
 final  List<PersonaProposal> _proposals;
/// Suggested edits to the persona. **Never applied by the chat turn** —
/// the user accepts them explicitly, which is why `apply` is its own call.
/// A conversation must not silently rewrite who the user says they are.
@override@JsonKey() List<PersonaProposal> get proposals {
  if (_proposals is EqualUnmodifiableListView) return _proposals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_proposals);
}


/// Create a copy of PersonaReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaReplyCopyWith<_PersonaReply> get copyWith => __$PersonaReplyCopyWithImpl<_PersonaReply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonaReplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaReply&&(identical(other.reply, reply) || other.reply == reply)&&const DeepCollectionEquality().equals(other._proposals, _proposals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,const DeepCollectionEquality().hash(_proposals));

@override
String toString() {
  return 'PersonaReply(reply: $reply, proposals: $proposals)';
}


}

/// @nodoc
abstract mixin class _$PersonaReplyCopyWith<$Res> implements $PersonaReplyCopyWith<$Res> {
  factory _$PersonaReplyCopyWith(_PersonaReply value, $Res Function(_PersonaReply) _then) = __$PersonaReplyCopyWithImpl;
@override @useResult
$Res call({
 String reply, List<PersonaProposal> proposals
});




}
/// @nodoc
class __$PersonaReplyCopyWithImpl<$Res>
    implements _$PersonaReplyCopyWith<$Res> {
  __$PersonaReplyCopyWithImpl(this._self, this._then);

  final _PersonaReply _self;
  final $Res Function(_PersonaReply) _then;

/// Create a copy of PersonaReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reply = null,Object? proposals = null,}) {
  return _then(_PersonaReply(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,proposals: null == proposals ? _self._proposals : proposals // ignore: cast_nullable_to_non_nullable
as List<PersonaProposal>,
  ));
}


}


/// @nodoc
mixin _$PersonaProposal {

 String get field; String get to; String? get from; String? get label;
/// Create a copy of PersonaProposal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaProposalCopyWith<PersonaProposal> get copyWith => _$PersonaProposalCopyWithImpl<PersonaProposal>(this as PersonaProposal, _$identity);

  /// Serializes this PersonaProposal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaProposal&&(identical(other.field, field) || other.field == field)&&(identical(other.to, to) || other.to == to)&&(identical(other.from, from) || other.from == from)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,to,from,label);

@override
String toString() {
  return 'PersonaProposal(field: $field, to: $to, from: $from, label: $label)';
}


}

/// @nodoc
abstract mixin class $PersonaProposalCopyWith<$Res>  {
  factory $PersonaProposalCopyWith(PersonaProposal value, $Res Function(PersonaProposal) _then) = _$PersonaProposalCopyWithImpl;
@useResult
$Res call({
 String field, String to, String? from, String? label
});




}
/// @nodoc
class _$PersonaProposalCopyWithImpl<$Res>
    implements $PersonaProposalCopyWith<$Res> {
  _$PersonaProposalCopyWithImpl(this._self, this._then);

  final PersonaProposal _self;
  final $Res Function(PersonaProposal) _then;

/// Create a copy of PersonaProposal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? to = null,Object? from = freezed,Object? label = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonaProposal].
extension PersonaProposalPatterns on PersonaProposal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonaProposal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonaProposal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonaProposal value)  $default,){
final _that = this;
switch (_that) {
case _PersonaProposal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonaProposal value)?  $default,){
final _that = this;
switch (_that) {
case _PersonaProposal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String to,  String? from,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaProposal() when $default != null:
return $default(_that.field,_that.to,_that.from,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String to,  String? from,  String? label)  $default,) {final _that = this;
switch (_that) {
case _PersonaProposal():
return $default(_that.field,_that.to,_that.from,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String to,  String? from,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _PersonaProposal() when $default != null:
return $default(_that.field,_that.to,_that.from,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonaProposal extends PersonaProposal {
  const _PersonaProposal({required this.field, this.to = '', this.from, this.label}): super._();
  factory _PersonaProposal.fromJson(Map<String, dynamic> json) => _$PersonaProposalFromJson(json);

@override final  String field;
@override@JsonKey() final  String to;
@override final  String? from;
@override final  String? label;

/// Create a copy of PersonaProposal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaProposalCopyWith<_PersonaProposal> get copyWith => __$PersonaProposalCopyWithImpl<_PersonaProposal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonaProposalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaProposal&&(identical(other.field, field) || other.field == field)&&(identical(other.to, to) || other.to == to)&&(identical(other.from, from) || other.from == from)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,to,from,label);

@override
String toString() {
  return 'PersonaProposal(field: $field, to: $to, from: $from, label: $label)';
}


}

/// @nodoc
abstract mixin class _$PersonaProposalCopyWith<$Res> implements $PersonaProposalCopyWith<$Res> {
  factory _$PersonaProposalCopyWith(_PersonaProposal value, $Res Function(_PersonaProposal) _then) = __$PersonaProposalCopyWithImpl;
@override @useResult
$Res call({
 String field, String to, String? from, String? label
});




}
/// @nodoc
class __$PersonaProposalCopyWithImpl<$Res>
    implements _$PersonaProposalCopyWith<$Res> {
  __$PersonaProposalCopyWithImpl(this._self, this._then);

  final _PersonaProposal _self;
  final $Res Function(_PersonaProposal) _then;

/// Create a copy of PersonaProposal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? to = null,Object? from = freezed,Object? label = freezed,}) {
  return _then(_PersonaProposal(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
