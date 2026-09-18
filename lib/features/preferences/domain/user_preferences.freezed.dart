// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferences {

/// False when the server has no preferences row for this user yet. A
/// brand-new account, so onboarding has not started.
 bool get exists; bool get onboardingCompleted;/// `'personal'` | `'company'`. Defaulted rather than nullable because the
/// server column defaults to `'personal'`.
 String? get brandType; int get currentSeason; DateTime? get roadmapStartedAt; DateTime? get seasonStartedAt;// ── Cadence ──
 int get postsPerWeek; List<int> get preferredDays; String get preferredTime; String get timezone; bool get autoPostEnabled;// ── Voice / strategy ──
 String get contentStyle; String get contentMode; String? get priority; String? get targetRole; String? get profession; String? get industry; String? get headline; String? get summary; List<String> get goals; List<String> get postCategories; List<String> get skills;/// Self-reported; nothing syncs it because nothing can. Null means "no
/// newsletter yet", which is what triggers the first-article naming flow.
/// The consultant-practice audience fields. Real preferences columns that
/// the mobile PATCH accepts, and what the persona screen's audience
/// section reads and writes.
 String? get serveRole; String? get serveIndustry; String? get problemSolved; String? get newsletterName;// ── Company brand (all null for a personal brand) ──
 String? get companyPageId; String? get companyPageName; String? get companyDescription; String? get companyIndustry; String? get companyTagline; String? get companyLogoUrl; String? get companyWebsite; List<String> get companyFeatures; String get approvalChannel;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.brandType, brandType) || other.brandType == brandType)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.roadmapStartedAt, roadmapStartedAt) || other.roadmapStartedAt == roadmapStartedAt)&&(identical(other.seasonStartedAt, seasonStartedAt) || other.seasonStartedAt == seasonStartedAt)&&(identical(other.postsPerWeek, postsPerWeek) || other.postsPerWeek == postsPerWeek)&&const DeepCollectionEquality().equals(other.preferredDays, preferredDays)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.autoPostEnabled, autoPostEnabled) || other.autoPostEnabled == autoPostEnabled)&&(identical(other.contentStyle, contentStyle) || other.contentStyle == contentStyle)&&(identical(other.contentMode, contentMode) || other.contentMode == contentMode)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.targetRole, targetRole) || other.targetRole == targetRole)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.goals, goals)&&const DeepCollectionEquality().equals(other.postCategories, postCategories)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.serveRole, serveRole) || other.serveRole == serveRole)&&(identical(other.serveIndustry, serveIndustry) || other.serveIndustry == serveIndustry)&&(identical(other.problemSolved, problemSolved) || other.problemSolved == problemSolved)&&(identical(other.newsletterName, newsletterName) || other.newsletterName == newsletterName)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyTagline, companyTagline) || other.companyTagline == companyTagline)&&(identical(other.companyLogoUrl, companyLogoUrl) || other.companyLogoUrl == companyLogoUrl)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&const DeepCollectionEquality().equals(other.companyFeatures, companyFeatures)&&(identical(other.approvalChannel, approvalChannel) || other.approvalChannel == approvalChannel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,exists,onboardingCompleted,brandType,currentSeason,roadmapStartedAt,seasonStartedAt,postsPerWeek,const DeepCollectionEquality().hash(preferredDays),preferredTime,timezone,autoPostEnabled,contentStyle,contentMode,priority,targetRole,profession,industry,headline,summary,const DeepCollectionEquality().hash(goals),const DeepCollectionEquality().hash(postCategories),const DeepCollectionEquality().hash(skills),serveRole,serveIndustry,problemSolved,newsletterName,companyPageId,companyPageName,companyDescription,companyIndustry,companyTagline,companyLogoUrl,companyWebsite,const DeepCollectionEquality().hash(companyFeatures),approvalChannel]);

@override
String toString() {
  return 'UserPreferences(exists: $exists, onboardingCompleted: $onboardingCompleted, brandType: $brandType, currentSeason: $currentSeason, roadmapStartedAt: $roadmapStartedAt, seasonStartedAt: $seasonStartedAt, postsPerWeek: $postsPerWeek, preferredDays: $preferredDays, preferredTime: $preferredTime, timezone: $timezone, autoPostEnabled: $autoPostEnabled, contentStyle: $contentStyle, contentMode: $contentMode, priority: $priority, targetRole: $targetRole, profession: $profession, industry: $industry, headline: $headline, summary: $summary, goals: $goals, postCategories: $postCategories, skills: $skills, serveRole: $serveRole, serveIndustry: $serveIndustry, problemSolved: $problemSolved, newsletterName: $newsletterName, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDescription: $companyDescription, companyIndustry: $companyIndustry, companyTagline: $companyTagline, companyLogoUrl: $companyLogoUrl, companyWebsite: $companyWebsite, companyFeatures: $companyFeatures, approvalChannel: $approvalChannel)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 bool exists, bool onboardingCompleted, String? brandType, int currentSeason, DateTime? roadmapStartedAt, DateTime? seasonStartedAt, int postsPerWeek, List<int> preferredDays, String preferredTime, String timezone, bool autoPostEnabled, String contentStyle, String contentMode, String? priority, String? targetRole, String? profession, String? industry, String? headline, String? summary, List<String> goals, List<String> postCategories, List<String> skills, String? serveRole, String? serveIndustry, String? problemSolved, String? newsletterName, String? companyPageId, String? companyPageName, String? companyDescription, String? companyIndustry, String? companyTagline, String? companyLogoUrl, String? companyWebsite, List<String> companyFeatures, String approvalChannel
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exists = null,Object? onboardingCompleted = null,Object? brandType = freezed,Object? currentSeason = null,Object? roadmapStartedAt = freezed,Object? seasonStartedAt = freezed,Object? postsPerWeek = null,Object? preferredDays = null,Object? preferredTime = null,Object? timezone = null,Object? autoPostEnabled = null,Object? contentStyle = null,Object? contentMode = null,Object? priority = freezed,Object? targetRole = freezed,Object? profession = freezed,Object? industry = freezed,Object? headline = freezed,Object? summary = freezed,Object? goals = null,Object? postCategories = null,Object? skills = null,Object? serveRole = freezed,Object? serveIndustry = freezed,Object? problemSolved = freezed,Object? newsletterName = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDescription = freezed,Object? companyIndustry = freezed,Object? companyTagline = freezed,Object? companyLogoUrl = freezed,Object? companyWebsite = freezed,Object? companyFeatures = null,Object? approvalChannel = null,}) {
  return _then(_self.copyWith(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,brandType: freezed == brandType ? _self.brandType : brandType // ignore: cast_nullable_to_non_nullable
as String?,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int,roadmapStartedAt: freezed == roadmapStartedAt ? _self.roadmapStartedAt : roadmapStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seasonStartedAt: freezed == seasonStartedAt ? _self.seasonStartedAt : seasonStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,postsPerWeek: null == postsPerWeek ? _self.postsPerWeek : postsPerWeek // ignore: cast_nullable_to_non_nullable
as int,preferredDays: null == preferredDays ? _self.preferredDays : preferredDays // ignore: cast_nullable_to_non_nullable
as List<int>,preferredTime: null == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,autoPostEnabled: null == autoPostEnabled ? _self.autoPostEnabled : autoPostEnabled // ignore: cast_nullable_to_non_nullable
as bool,contentStyle: null == contentStyle ? _self.contentStyle : contentStyle // ignore: cast_nullable_to_non_nullable
as String,contentMode: null == contentMode ? _self.contentMode : contentMode // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,targetRole: freezed == targetRole ? _self.targetRole : targetRole // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<String>,postCategories: null == postCategories ? _self.postCategories : postCategories // ignore: cast_nullable_to_non_nullable
as List<String>,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,serveRole: freezed == serveRole ? _self.serveRole : serveRole // ignore: cast_nullable_to_non_nullable
as String?,serveIndustry: freezed == serveIndustry ? _self.serveIndustry : serveIndustry // ignore: cast_nullable_to_non_nullable
as String?,problemSolved: freezed == problemSolved ? _self.problemSolved : problemSolved // ignore: cast_nullable_to_non_nullable
as String?,newsletterName: freezed == newsletterName ? _self.newsletterName : newsletterName // ignore: cast_nullable_to_non_nullable
as String?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyTagline: freezed == companyTagline ? _self.companyTagline : companyTagline // ignore: cast_nullable_to_non_nullable
as String?,companyLogoUrl: freezed == companyLogoUrl ? _self.companyLogoUrl : companyLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,companyFeatures: null == companyFeatures ? _self.companyFeatures : companyFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,approvalChannel: null == approvalChannel ? _self.approvalChannel : approvalChannel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool exists,  bool onboardingCompleted,  String? brandType,  int currentSeason,  DateTime? roadmapStartedAt,  DateTime? seasonStartedAt,  int postsPerWeek,  List<int> preferredDays,  String preferredTime,  String timezone,  bool autoPostEnabled,  String contentStyle,  String contentMode,  String? priority,  String? targetRole,  String? profession,  String? industry,  String? headline,  String? summary,  List<String> goals,  List<String> postCategories,  List<String> skills,  String? serveRole,  String? serveIndustry,  String? problemSolved,  String? newsletterName,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? companyLogoUrl,  String? companyWebsite,  List<String> companyFeatures,  String approvalChannel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.exists,_that.onboardingCompleted,_that.brandType,_that.currentSeason,_that.roadmapStartedAt,_that.seasonStartedAt,_that.postsPerWeek,_that.preferredDays,_that.preferredTime,_that.timezone,_that.autoPostEnabled,_that.contentStyle,_that.contentMode,_that.priority,_that.targetRole,_that.profession,_that.industry,_that.headline,_that.summary,_that.goals,_that.postCategories,_that.skills,_that.serveRole,_that.serveIndustry,_that.problemSolved,_that.newsletterName,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.companyLogoUrl,_that.companyWebsite,_that.companyFeatures,_that.approvalChannel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool exists,  bool onboardingCompleted,  String? brandType,  int currentSeason,  DateTime? roadmapStartedAt,  DateTime? seasonStartedAt,  int postsPerWeek,  List<int> preferredDays,  String preferredTime,  String timezone,  bool autoPostEnabled,  String contentStyle,  String contentMode,  String? priority,  String? targetRole,  String? profession,  String? industry,  String? headline,  String? summary,  List<String> goals,  List<String> postCategories,  List<String> skills,  String? serveRole,  String? serveIndustry,  String? problemSolved,  String? newsletterName,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? companyLogoUrl,  String? companyWebsite,  List<String> companyFeatures,  String approvalChannel)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.exists,_that.onboardingCompleted,_that.brandType,_that.currentSeason,_that.roadmapStartedAt,_that.seasonStartedAt,_that.postsPerWeek,_that.preferredDays,_that.preferredTime,_that.timezone,_that.autoPostEnabled,_that.contentStyle,_that.contentMode,_that.priority,_that.targetRole,_that.profession,_that.industry,_that.headline,_that.summary,_that.goals,_that.postCategories,_that.skills,_that.serveRole,_that.serveIndustry,_that.problemSolved,_that.newsletterName,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.companyLogoUrl,_that.companyWebsite,_that.companyFeatures,_that.approvalChannel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool exists,  bool onboardingCompleted,  String? brandType,  int currentSeason,  DateTime? roadmapStartedAt,  DateTime? seasonStartedAt,  int postsPerWeek,  List<int> preferredDays,  String preferredTime,  String timezone,  bool autoPostEnabled,  String contentStyle,  String contentMode,  String? priority,  String? targetRole,  String? profession,  String? industry,  String? headline,  String? summary,  List<String> goals,  List<String> postCategories,  List<String> skills,  String? serveRole,  String? serveIndustry,  String? problemSolved,  String? newsletterName,  String? companyPageId,  String? companyPageName,  String? companyDescription,  String? companyIndustry,  String? companyTagline,  String? companyLogoUrl,  String? companyWebsite,  List<String> companyFeatures,  String approvalChannel)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.exists,_that.onboardingCompleted,_that.brandType,_that.currentSeason,_that.roadmapStartedAt,_that.seasonStartedAt,_that.postsPerWeek,_that.preferredDays,_that.preferredTime,_that.timezone,_that.autoPostEnabled,_that.contentStyle,_that.contentMode,_that.priority,_that.targetRole,_that.profession,_that.industry,_that.headline,_that.summary,_that.goals,_that.postCategories,_that.skills,_that.serveRole,_that.serveIndustry,_that.problemSolved,_that.newsletterName,_that.companyPageId,_that.companyPageName,_that.companyDescription,_that.companyIndustry,_that.companyTagline,_that.companyLogoUrl,_that.companyWebsite,_that.companyFeatures,_that.approvalChannel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferences extends UserPreferences {
  const _UserPreferences({this.exists = false, this.onboardingCompleted = false, this.brandType = 'personal', this.currentSeason = 1, this.roadmapStartedAt, this.seasonStartedAt, this.postsPerWeek = 7, final  List<int> preferredDays = const <int>[1, 3, 5], this.preferredTime = '09:00', this.timezone = 'Asia/Kolkata', this.autoPostEnabled = true, this.contentStyle = 'professional', this.contentMode = 'authority', this.priority, this.targetRole, this.profession, this.industry, this.headline, this.summary, final  List<String> goals = const <String>[], final  List<String> postCategories = const <String>[], final  List<String> skills = const <String>[], this.serveRole, this.serveIndustry, this.problemSolved, this.newsletterName, this.companyPageId, this.companyPageName, this.companyDescription, this.companyIndustry, this.companyTagline, this.companyLogoUrl, this.companyWebsite, final  List<String> companyFeatures = const <String>[], this.approvalChannel = 'slack'}): _preferredDays = preferredDays,_goals = goals,_postCategories = postCategories,_skills = skills,_companyFeatures = companyFeatures,super._();
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

/// False when the server has no preferences row for this user yet. A
/// brand-new account, so onboarding has not started.
@override@JsonKey() final  bool exists;
@override@JsonKey() final  bool onboardingCompleted;
/// `'personal'` | `'company'`. Defaulted rather than nullable because the
/// server column defaults to `'personal'`.
@override@JsonKey() final  String? brandType;
@override@JsonKey() final  int currentSeason;
@override final  DateTime? roadmapStartedAt;
@override final  DateTime? seasonStartedAt;
// ── Cadence ──
@override@JsonKey() final  int postsPerWeek;
 final  List<int> _preferredDays;
@override@JsonKey() List<int> get preferredDays {
  if (_preferredDays is EqualUnmodifiableListView) return _preferredDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferredDays);
}

@override@JsonKey() final  String preferredTime;
@override@JsonKey() final  String timezone;
@override@JsonKey() final  bool autoPostEnabled;
// ── Voice / strategy ──
@override@JsonKey() final  String contentStyle;
@override@JsonKey() final  String contentMode;
@override final  String? priority;
@override final  String? targetRole;
@override final  String? profession;
@override final  String? industry;
@override final  String? headline;
@override final  String? summary;
 final  List<String> _goals;
@override@JsonKey() List<String> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}

 final  List<String> _postCategories;
@override@JsonKey() List<String> get postCategories {
  if (_postCategories is EqualUnmodifiableListView) return _postCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postCategories);
}

 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

/// Self-reported; nothing syncs it because nothing can. Null means "no
/// newsletter yet", which is what triggers the first-article naming flow.
/// The consultant-practice audience fields. Real preferences columns that
/// the mobile PATCH accepts, and what the persona screen's audience
/// section reads and writes.
@override final  String? serveRole;
@override final  String? serveIndustry;
@override final  String? problemSolved;
@override final  String? newsletterName;
// ── Company brand (all null for a personal brand) ──
@override final  String? companyPageId;
@override final  String? companyPageName;
@override final  String? companyDescription;
@override final  String? companyIndustry;
@override final  String? companyTagline;
@override final  String? companyLogoUrl;
@override final  String? companyWebsite;
 final  List<String> _companyFeatures;
@override@JsonKey() List<String> get companyFeatures {
  if (_companyFeatures is EqualUnmodifiableListView) return _companyFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companyFeatures);
}

@override@JsonKey() final  String approvalChannel;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.brandType, brandType) || other.brandType == brandType)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.roadmapStartedAt, roadmapStartedAt) || other.roadmapStartedAt == roadmapStartedAt)&&(identical(other.seasonStartedAt, seasonStartedAt) || other.seasonStartedAt == seasonStartedAt)&&(identical(other.postsPerWeek, postsPerWeek) || other.postsPerWeek == postsPerWeek)&&const DeepCollectionEquality().equals(other._preferredDays, _preferredDays)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.autoPostEnabled, autoPostEnabled) || other.autoPostEnabled == autoPostEnabled)&&(identical(other.contentStyle, contentStyle) || other.contentStyle == contentStyle)&&(identical(other.contentMode, contentMode) || other.contentMode == contentMode)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.targetRole, targetRole) || other.targetRole == targetRole)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._goals, _goals)&&const DeepCollectionEquality().equals(other._postCategories, _postCategories)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.serveRole, serveRole) || other.serveRole == serveRole)&&(identical(other.serveIndustry, serveIndustry) || other.serveIndustry == serveIndustry)&&(identical(other.problemSolved, problemSolved) || other.problemSolved == problemSolved)&&(identical(other.newsletterName, newsletterName) || other.newsletterName == newsletterName)&&(identical(other.companyPageId, companyPageId) || other.companyPageId == companyPageId)&&(identical(other.companyPageName, companyPageName) || other.companyPageName == companyPageName)&&(identical(other.companyDescription, companyDescription) || other.companyDescription == companyDescription)&&(identical(other.companyIndustry, companyIndustry) || other.companyIndustry == companyIndustry)&&(identical(other.companyTagline, companyTagline) || other.companyTagline == companyTagline)&&(identical(other.companyLogoUrl, companyLogoUrl) || other.companyLogoUrl == companyLogoUrl)&&(identical(other.companyWebsite, companyWebsite) || other.companyWebsite == companyWebsite)&&const DeepCollectionEquality().equals(other._companyFeatures, _companyFeatures)&&(identical(other.approvalChannel, approvalChannel) || other.approvalChannel == approvalChannel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,exists,onboardingCompleted,brandType,currentSeason,roadmapStartedAt,seasonStartedAt,postsPerWeek,const DeepCollectionEquality().hash(_preferredDays),preferredTime,timezone,autoPostEnabled,contentStyle,contentMode,priority,targetRole,profession,industry,headline,summary,const DeepCollectionEquality().hash(_goals),const DeepCollectionEquality().hash(_postCategories),const DeepCollectionEquality().hash(_skills),serveRole,serveIndustry,problemSolved,newsletterName,companyPageId,companyPageName,companyDescription,companyIndustry,companyTagline,companyLogoUrl,companyWebsite,const DeepCollectionEquality().hash(_companyFeatures),approvalChannel]);

@override
String toString() {
  return 'UserPreferences(exists: $exists, onboardingCompleted: $onboardingCompleted, brandType: $brandType, currentSeason: $currentSeason, roadmapStartedAt: $roadmapStartedAt, seasonStartedAt: $seasonStartedAt, postsPerWeek: $postsPerWeek, preferredDays: $preferredDays, preferredTime: $preferredTime, timezone: $timezone, autoPostEnabled: $autoPostEnabled, contentStyle: $contentStyle, contentMode: $contentMode, priority: $priority, targetRole: $targetRole, profession: $profession, industry: $industry, headline: $headline, summary: $summary, goals: $goals, postCategories: $postCategories, skills: $skills, serveRole: $serveRole, serveIndustry: $serveIndustry, problemSolved: $problemSolved, newsletterName: $newsletterName, companyPageId: $companyPageId, companyPageName: $companyPageName, companyDescription: $companyDescription, companyIndustry: $companyIndustry, companyTagline: $companyTagline, companyLogoUrl: $companyLogoUrl, companyWebsite: $companyWebsite, companyFeatures: $companyFeatures, approvalChannel: $approvalChannel)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool exists, bool onboardingCompleted, String? brandType, int currentSeason, DateTime? roadmapStartedAt, DateTime? seasonStartedAt, int postsPerWeek, List<int> preferredDays, String preferredTime, String timezone, bool autoPostEnabled, String contentStyle, String contentMode, String? priority, String? targetRole, String? profession, String? industry, String? headline, String? summary, List<String> goals, List<String> postCategories, List<String> skills, String? serveRole, String? serveIndustry, String? problemSolved, String? newsletterName, String? companyPageId, String? companyPageName, String? companyDescription, String? companyIndustry, String? companyTagline, String? companyLogoUrl, String? companyWebsite, List<String> companyFeatures, String approvalChannel
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exists = null,Object? onboardingCompleted = null,Object? brandType = freezed,Object? currentSeason = null,Object? roadmapStartedAt = freezed,Object? seasonStartedAt = freezed,Object? postsPerWeek = null,Object? preferredDays = null,Object? preferredTime = null,Object? timezone = null,Object? autoPostEnabled = null,Object? contentStyle = null,Object? contentMode = null,Object? priority = freezed,Object? targetRole = freezed,Object? profession = freezed,Object? industry = freezed,Object? headline = freezed,Object? summary = freezed,Object? goals = null,Object? postCategories = null,Object? skills = null,Object? serveRole = freezed,Object? serveIndustry = freezed,Object? problemSolved = freezed,Object? newsletterName = freezed,Object? companyPageId = freezed,Object? companyPageName = freezed,Object? companyDescription = freezed,Object? companyIndustry = freezed,Object? companyTagline = freezed,Object? companyLogoUrl = freezed,Object? companyWebsite = freezed,Object? companyFeatures = null,Object? approvalChannel = null,}) {
  return _then(_UserPreferences(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,brandType: freezed == brandType ? _self.brandType : brandType // ignore: cast_nullable_to_non_nullable
as String?,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int,roadmapStartedAt: freezed == roadmapStartedAt ? _self.roadmapStartedAt : roadmapStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seasonStartedAt: freezed == seasonStartedAt ? _self.seasonStartedAt : seasonStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,postsPerWeek: null == postsPerWeek ? _self.postsPerWeek : postsPerWeek // ignore: cast_nullable_to_non_nullable
as int,preferredDays: null == preferredDays ? _self._preferredDays : preferredDays // ignore: cast_nullable_to_non_nullable
as List<int>,preferredTime: null == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,autoPostEnabled: null == autoPostEnabled ? _self.autoPostEnabled : autoPostEnabled // ignore: cast_nullable_to_non_nullable
as bool,contentStyle: null == contentStyle ? _self.contentStyle : contentStyle // ignore: cast_nullable_to_non_nullable
as String,contentMode: null == contentMode ? _self.contentMode : contentMode // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,targetRole: freezed == targetRole ? _self.targetRole : targetRole // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<String>,postCategories: null == postCategories ? _self._postCategories : postCategories // ignore: cast_nullable_to_non_nullable
as List<String>,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,serveRole: freezed == serveRole ? _self.serveRole : serveRole // ignore: cast_nullable_to_non_nullable
as String?,serveIndustry: freezed == serveIndustry ? _self.serveIndustry : serveIndustry // ignore: cast_nullable_to_non_nullable
as String?,problemSolved: freezed == problemSolved ? _self.problemSolved : problemSolved // ignore: cast_nullable_to_non_nullable
as String?,newsletterName: freezed == newsletterName ? _self.newsletterName : newsletterName // ignore: cast_nullable_to_non_nullable
as String?,companyPageId: freezed == companyPageId ? _self.companyPageId : companyPageId // ignore: cast_nullable_to_non_nullable
as String?,companyPageName: freezed == companyPageName ? _self.companyPageName : companyPageName // ignore: cast_nullable_to_non_nullable
as String?,companyDescription: freezed == companyDescription ? _self.companyDescription : companyDescription // ignore: cast_nullable_to_non_nullable
as String?,companyIndustry: freezed == companyIndustry ? _self.companyIndustry : companyIndustry // ignore: cast_nullable_to_non_nullable
as String?,companyTagline: freezed == companyTagline ? _self.companyTagline : companyTagline // ignore: cast_nullable_to_non_nullable
as String?,companyLogoUrl: freezed == companyLogoUrl ? _self.companyLogoUrl : companyLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,companyWebsite: freezed == companyWebsite ? _self.companyWebsite : companyWebsite // ignore: cast_nullable_to_non_nullable
as String?,companyFeatures: null == companyFeatures ? _self._companyFeatures : companyFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,approvalChannel: null == approvalChannel ? _self.approvalChannel : approvalChannel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
