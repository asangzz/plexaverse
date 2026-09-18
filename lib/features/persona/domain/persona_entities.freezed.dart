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
mixin _$PersonaSnapshot {

 PersonaIdentity get identity; PersonaAudience get audience;
/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonaSnapshotCopyWith<PersonaSnapshot> get copyWith => _$PersonaSnapshotCopyWithImpl<PersonaSnapshot>(this as PersonaSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonaSnapshot&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.audience, audience) || other.audience == audience));
}


@override
int get hashCode => Object.hash(runtimeType,identity,audience);

@override
String toString() {
  return 'PersonaSnapshot(identity: $identity, audience: $audience)';
}


}

/// @nodoc
abstract mixin class $PersonaSnapshotCopyWith<$Res>  {
  factory $PersonaSnapshotCopyWith(PersonaSnapshot value, $Res Function(PersonaSnapshot) _then) = _$PersonaSnapshotCopyWithImpl;
@useResult
$Res call({
 PersonaIdentity identity, PersonaAudience audience
});


$PersonaIdentityCopyWith<$Res> get identity;$PersonaAudienceCopyWith<$Res> get audience;

}
/// @nodoc
class _$PersonaSnapshotCopyWithImpl<$Res>
    implements $PersonaSnapshotCopyWith<$Res> {
  _$PersonaSnapshotCopyWithImpl(this._self, this._then);

  final PersonaSnapshot _self;
  final $Res Function(PersonaSnapshot) _then;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identity = null,Object? audience = null,}) {
  return _then(_self.copyWith(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as PersonaIdentity,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as PersonaAudience,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonaIdentity identity,  PersonaAudience audience)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
return $default(_that.identity,_that.audience);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonaIdentity identity,  PersonaAudience audience)  $default,) {final _that = this;
switch (_that) {
case _PersonaSnapshot():
return $default(_that.identity,_that.audience);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonaIdentity identity,  PersonaAudience audience)?  $default,) {final _that = this;
switch (_that) {
case _PersonaSnapshot() when $default != null:
return $default(_that.identity,_that.audience);case _:
  return null;

}
}

}

/// @nodoc


class _PersonaSnapshot extends PersonaSnapshot {
  const _PersonaSnapshot({required this.identity, this.audience = const PersonaAudience()}): super._();
  

@override final  PersonaIdentity identity;
@override@JsonKey() final  PersonaAudience audience;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonaSnapshotCopyWith<_PersonaSnapshot> get copyWith => __$PersonaSnapshotCopyWithImpl<_PersonaSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonaSnapshot&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.audience, audience) || other.audience == audience));
}


@override
int get hashCode => Object.hash(runtimeType,identity,audience);

@override
String toString() {
  return 'PersonaSnapshot(identity: $identity, audience: $audience)';
}


}

/// @nodoc
abstract mixin class _$PersonaSnapshotCopyWith<$Res> implements $PersonaSnapshotCopyWith<$Res> {
  factory _$PersonaSnapshotCopyWith(_PersonaSnapshot value, $Res Function(_PersonaSnapshot) _then) = __$PersonaSnapshotCopyWithImpl;
@override @useResult
$Res call({
 PersonaIdentity identity, PersonaAudience audience
});


@override $PersonaIdentityCopyWith<$Res> get identity;@override $PersonaAudienceCopyWith<$Res> get audience;

}
/// @nodoc
class __$PersonaSnapshotCopyWithImpl<$Res>
    implements _$PersonaSnapshotCopyWith<$Res> {
  __$PersonaSnapshotCopyWithImpl(this._self, this._then);

  final _PersonaSnapshot _self;
  final $Res Function(_PersonaSnapshot) _then;

/// Create a copy of PersonaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identity = null,Object? audience = null,}) {
  return _then(_PersonaSnapshot(
identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as PersonaIdentity,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as PersonaAudience,
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
}
}

// dart format on
