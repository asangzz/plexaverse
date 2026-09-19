// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'festive_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FestiveTemplate {

 String get id; String get name; String? get description; String get category; String get previewUrl;/// `'1:1'`, `'4:5'`, … The gallery tile and the customizer preview both
/// size themselves from this rather than assuming a square.
 String get aspectRatio; String? get figmaNodeId;
/// Create a copy of FestiveTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestiveTemplateCopyWith<FestiveTemplate> get copyWith => _$FestiveTemplateCopyWithImpl<FestiveTemplate>(this as FestiveTemplate, _$identity);

  /// Serializes this FestiveTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestiveTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.figmaNodeId, figmaNodeId) || other.figmaNodeId == figmaNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,previewUrl,aspectRatio,figmaNodeId);

@override
String toString() {
  return 'FestiveTemplate(id: $id, name: $name, description: $description, category: $category, previewUrl: $previewUrl, aspectRatio: $aspectRatio, figmaNodeId: $figmaNodeId)';
}


}

/// @nodoc
abstract mixin class $FestiveTemplateCopyWith<$Res>  {
  factory $FestiveTemplateCopyWith(FestiveTemplate value, $Res Function(FestiveTemplate) _then) = _$FestiveTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String category, String previewUrl, String aspectRatio, String? figmaNodeId
});




}
/// @nodoc
class _$FestiveTemplateCopyWithImpl<$Res>
    implements $FestiveTemplateCopyWith<$Res> {
  _$FestiveTemplateCopyWithImpl(this._self, this._then);

  final FestiveTemplate _self;
  final $Res Function(FestiveTemplate) _then;

/// Create a copy of FestiveTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = null,Object? previewUrl = null,Object? aspectRatio = null,Object? figmaNodeId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,previewUrl: null == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String,figmaNodeId: freezed == figmaNodeId ? _self.figmaNodeId : figmaNodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FestiveTemplate].
extension FestiveTemplatePatterns on FestiveTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestiveTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestiveTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestiveTemplate value)  $default,){
final _that = this;
switch (_that) {
case _FestiveTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestiveTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _FestiveTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String category,  String previewUrl,  String aspectRatio,  String? figmaNodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestiveTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.previewUrl,_that.aspectRatio,_that.figmaNodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String category,  String previewUrl,  String aspectRatio,  String? figmaNodeId)  $default,) {final _that = this;
switch (_that) {
case _FestiveTemplate():
return $default(_that.id,_that.name,_that.description,_that.category,_that.previewUrl,_that.aspectRatio,_that.figmaNodeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String category,  String previewUrl,  String aspectRatio,  String? figmaNodeId)?  $default,) {final _that = this;
switch (_that) {
case _FestiveTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.previewUrl,_that.aspectRatio,_that.figmaNodeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FestiveTemplate implements FestiveTemplate {
  const _FestiveTemplate({required this.id, required this.name, this.description, this.category = 'general', this.previewUrl = '', this.aspectRatio = '1:1', this.figmaNodeId});
  factory _FestiveTemplate.fromJson(Map<String, dynamic> json) => _$FestiveTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String previewUrl;
/// `'1:1'`, `'4:5'`, … The gallery tile and the customizer preview both
/// size themselves from this rather than assuming a square.
@override@JsonKey() final  String aspectRatio;
@override final  String? figmaNodeId;

/// Create a copy of FestiveTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestiveTemplateCopyWith<_FestiveTemplate> get copyWith => __$FestiveTemplateCopyWithImpl<_FestiveTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestiveTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestiveTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.figmaNodeId, figmaNodeId) || other.figmaNodeId == figmaNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,previewUrl,aspectRatio,figmaNodeId);

@override
String toString() {
  return 'FestiveTemplate(id: $id, name: $name, description: $description, category: $category, previewUrl: $previewUrl, aspectRatio: $aspectRatio, figmaNodeId: $figmaNodeId)';
}


}

/// @nodoc
abstract mixin class _$FestiveTemplateCopyWith<$Res> implements $FestiveTemplateCopyWith<$Res> {
  factory _$FestiveTemplateCopyWith(_FestiveTemplate value, $Res Function(_FestiveTemplate) _then) = __$FestiveTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String category, String previewUrl, String aspectRatio, String? figmaNodeId
});




}
/// @nodoc
class __$FestiveTemplateCopyWithImpl<$Res>
    implements _$FestiveTemplateCopyWith<$Res> {
  __$FestiveTemplateCopyWithImpl(this._self, this._then);

  final _FestiveTemplate _self;
  final $Res Function(_FestiveTemplate) _then;

/// Create a copy of FestiveTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = null,Object? previewUrl = null,Object? aspectRatio = null,Object? figmaNodeId = freezed,}) {
  return _then(_FestiveTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,previewUrl: null == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String,figmaNodeId: freezed == figmaNodeId ? _self.figmaNodeId : figmaNodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FestiveGallery {

 List<FestiveTemplate> get templates; List<String> get categories;
/// Create a copy of FestiveGallery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestiveGalleryCopyWith<FestiveGallery> get copyWith => _$FestiveGalleryCopyWithImpl<FestiveGallery>(this as FestiveGallery, _$identity);

  /// Serializes this FestiveGallery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestiveGallery&&const DeepCollectionEquality().equals(other.templates, templates)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(templates),const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'FestiveGallery(templates: $templates, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $FestiveGalleryCopyWith<$Res>  {
  factory $FestiveGalleryCopyWith(FestiveGallery value, $Res Function(FestiveGallery) _then) = _$FestiveGalleryCopyWithImpl;
@useResult
$Res call({
 List<FestiveTemplate> templates, List<String> categories
});




}
/// @nodoc
class _$FestiveGalleryCopyWithImpl<$Res>
    implements $FestiveGalleryCopyWith<$Res> {
  _$FestiveGalleryCopyWithImpl(this._self, this._then);

  final FestiveGallery _self;
  final $Res Function(FestiveGallery) _then;

/// Create a copy of FestiveGallery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templates = null,Object? categories = null,}) {
  return _then(_self.copyWith(
templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<FestiveTemplate>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FestiveGallery].
extension FestiveGalleryPatterns on FestiveGallery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestiveGallery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestiveGallery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestiveGallery value)  $default,){
final _that = this;
switch (_that) {
case _FestiveGallery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestiveGallery value)?  $default,){
final _that = this;
switch (_that) {
case _FestiveGallery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FestiveTemplate> templates,  List<String> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestiveGallery() when $default != null:
return $default(_that.templates,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FestiveTemplate> templates,  List<String> categories)  $default,) {final _that = this;
switch (_that) {
case _FestiveGallery():
return $default(_that.templates,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FestiveTemplate> templates,  List<String> categories)?  $default,) {final _that = this;
switch (_that) {
case _FestiveGallery() when $default != null:
return $default(_that.templates,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FestiveGallery implements FestiveGallery {
  const _FestiveGallery({final  List<FestiveTemplate> templates = const <FestiveTemplate>[], final  List<String> categories = const <String>[]}): _templates = templates,_categories = categories;
  factory _FestiveGallery.fromJson(Map<String, dynamic> json) => _$FestiveGalleryFromJson(json);

 final  List<FestiveTemplate> _templates;
@override@JsonKey() List<FestiveTemplate> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of FestiveGallery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestiveGalleryCopyWith<_FestiveGallery> get copyWith => __$FestiveGalleryCopyWithImpl<_FestiveGallery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestiveGalleryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestiveGallery&&const DeepCollectionEquality().equals(other._templates, _templates)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_templates),const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'FestiveGallery(templates: $templates, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$FestiveGalleryCopyWith<$Res> implements $FestiveGalleryCopyWith<$Res> {
  factory _$FestiveGalleryCopyWith(_FestiveGallery value, $Res Function(_FestiveGallery) _then) = __$FestiveGalleryCopyWithImpl;
@override @useResult
$Res call({
 List<FestiveTemplate> templates, List<String> categories
});




}
/// @nodoc
class __$FestiveGalleryCopyWithImpl<$Res>
    implements _$FestiveGalleryCopyWith<$Res> {
  __$FestiveGalleryCopyWithImpl(this._self, this._then);

  final _FestiveGallery _self;
  final $Res Function(_FestiveGallery) _then;

/// Create a copy of FestiveGallery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templates = null,Object? categories = null,}) {
  return _then(_FestiveGallery(
templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<FestiveTemplate>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$FestiveCustomizations {

 String get companyName;/// Replaces the template's title, e.g. "Happy Diwali".
 String get eventName;/// Replaces the template's subtitle.
 String get additionalText; DateTime? get date;/// The user's brand colour as `#RRGGBB`. The web's default is `#7000ff`,
/// which is a legacy gradient colour rather than a brand token; it is kept
/// verbatim because it is the value the server composites with, and
/// changing it would silently change every poster generated from the app.
 String get primaryColor;/// The uploaded logo, as the URL `/upload/image` returned. Null means no
/// logo, which the server composites around rather than failing on.
 String? get logoUrl;
/// Create a copy of FestiveCustomizations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestiveCustomizationsCopyWith<FestiveCustomizations> get copyWith => _$FestiveCustomizationsCopyWithImpl<FestiveCustomizations>(this as FestiveCustomizations, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestiveCustomizations&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.additionalText, additionalText) || other.additionalText == additionalText)&&(identical(other.date, date) || other.date == date)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,eventName,additionalText,date,primaryColor,logoUrl);

@override
String toString() {
  return 'FestiveCustomizations(companyName: $companyName, eventName: $eventName, additionalText: $additionalText, date: $date, primaryColor: $primaryColor, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $FestiveCustomizationsCopyWith<$Res>  {
  factory $FestiveCustomizationsCopyWith(FestiveCustomizations value, $Res Function(FestiveCustomizations) _then) = _$FestiveCustomizationsCopyWithImpl;
@useResult
$Res call({
 String companyName, String eventName, String additionalText, DateTime? date, String primaryColor, String? logoUrl
});




}
/// @nodoc
class _$FestiveCustomizationsCopyWithImpl<$Res>
    implements $FestiveCustomizationsCopyWith<$Res> {
  _$FestiveCustomizationsCopyWithImpl(this._self, this._then);

  final FestiveCustomizations _self;
  final $Res Function(FestiveCustomizations) _then;

/// Create a copy of FestiveCustomizations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? eventName = null,Object? additionalText = null,Object? date = freezed,Object? primaryColor = null,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,additionalText: null == additionalText ? _self.additionalText : additionalText // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FestiveCustomizations].
extension FestiveCustomizationsPatterns on FestiveCustomizations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestiveCustomizations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestiveCustomizations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestiveCustomizations value)  $default,){
final _that = this;
switch (_that) {
case _FestiveCustomizations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestiveCustomizations value)?  $default,){
final _that = this;
switch (_that) {
case _FestiveCustomizations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String eventName,  String additionalText,  DateTime? date,  String primaryColor,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestiveCustomizations() when $default != null:
return $default(_that.companyName,_that.eventName,_that.additionalText,_that.date,_that.primaryColor,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String eventName,  String additionalText,  DateTime? date,  String primaryColor,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _FestiveCustomizations():
return $default(_that.companyName,_that.eventName,_that.additionalText,_that.date,_that.primaryColor,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String eventName,  String additionalText,  DateTime? date,  String primaryColor,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _FestiveCustomizations() when $default != null:
return $default(_that.companyName,_that.eventName,_that.additionalText,_that.date,_that.primaryColor,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _FestiveCustomizations extends FestiveCustomizations {
  const _FestiveCustomizations({this.companyName = '', this.eventName = '', this.additionalText = '', this.date, this.primaryColor = '#7000FF', this.logoUrl}): super._();
  

@override@JsonKey() final  String companyName;
/// Replaces the template's title, e.g. "Happy Diwali".
@override@JsonKey() final  String eventName;
/// Replaces the template's subtitle.
@override@JsonKey() final  String additionalText;
@override final  DateTime? date;
/// The user's brand colour as `#RRGGBB`. The web's default is `#7000ff`,
/// which is a legacy gradient colour rather than a brand token; it is kept
/// verbatim because it is the value the server composites with, and
/// changing it would silently change every poster generated from the app.
@override@JsonKey() final  String primaryColor;
/// The uploaded logo, as the URL `/upload/image` returned. Null means no
/// logo, which the server composites around rather than failing on.
@override final  String? logoUrl;

/// Create a copy of FestiveCustomizations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestiveCustomizationsCopyWith<_FestiveCustomizations> get copyWith => __$FestiveCustomizationsCopyWithImpl<_FestiveCustomizations>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestiveCustomizations&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.additionalText, additionalText) || other.additionalText == additionalText)&&(identical(other.date, date) || other.date == date)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,eventName,additionalText,date,primaryColor,logoUrl);

@override
String toString() {
  return 'FestiveCustomizations(companyName: $companyName, eventName: $eventName, additionalText: $additionalText, date: $date, primaryColor: $primaryColor, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$FestiveCustomizationsCopyWith<$Res> implements $FestiveCustomizationsCopyWith<$Res> {
  factory _$FestiveCustomizationsCopyWith(_FestiveCustomizations value, $Res Function(_FestiveCustomizations) _then) = __$FestiveCustomizationsCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String eventName, String additionalText, DateTime? date, String primaryColor, String? logoUrl
});




}
/// @nodoc
class __$FestiveCustomizationsCopyWithImpl<$Res>
    implements _$FestiveCustomizationsCopyWith<$Res> {
  __$FestiveCustomizationsCopyWithImpl(this._self, this._then);

  final _FestiveCustomizations _self;
  final $Res Function(_FestiveCustomizations) _then;

/// Create a copy of FestiveCustomizations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? eventName = null,Object? additionalText = null,Object? date = freezed,Object? primaryColor = null,Object? logoUrl = freezed,}) {
  return _then(_FestiveCustomizations(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,additionalText: null == additionalText ? _self.additionalText : additionalText // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FestivePoster {

 String get imageUrl; String get templateName;
/// Create a copy of FestivePoster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivePosterCopyWith<FestivePoster> get copyWith => _$FestivePosterCopyWithImpl<FestivePoster>(this as FestivePoster, _$identity);

  /// Serializes this FestivePoster to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivePoster&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.templateName, templateName) || other.templateName == templateName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,templateName);

@override
String toString() {
  return 'FestivePoster(imageUrl: $imageUrl, templateName: $templateName)';
}


}

/// @nodoc
abstract mixin class $FestivePosterCopyWith<$Res>  {
  factory $FestivePosterCopyWith(FestivePoster value, $Res Function(FestivePoster) _then) = _$FestivePosterCopyWithImpl;
@useResult
$Res call({
 String imageUrl, String templateName
});




}
/// @nodoc
class _$FestivePosterCopyWithImpl<$Res>
    implements $FestivePosterCopyWith<$Res> {
  _$FestivePosterCopyWithImpl(this._self, this._then);

  final FestivePoster _self;
  final $Res Function(FestivePoster) _then;

/// Create a copy of FestivePoster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,Object? templateName = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,templateName: null == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FestivePoster].
extension FestivePosterPatterns on FestivePoster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivePoster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivePoster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivePoster value)  $default,){
final _that = this;
switch (_that) {
case _FestivePoster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivePoster value)?  $default,){
final _that = this;
switch (_that) {
case _FestivePoster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String imageUrl,  String templateName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivePoster() when $default != null:
return $default(_that.imageUrl,_that.templateName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String imageUrl,  String templateName)  $default,) {final _that = this;
switch (_that) {
case _FestivePoster():
return $default(_that.imageUrl,_that.templateName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String imageUrl,  String templateName)?  $default,) {final _that = this;
switch (_that) {
case _FestivePoster() when $default != null:
return $default(_that.imageUrl,_that.templateName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FestivePoster implements FestivePoster {
  const _FestivePoster({this.imageUrl = '', this.templateName = ''});
  factory _FestivePoster.fromJson(Map<String, dynamic> json) => _$FestivePosterFromJson(json);

@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String templateName;

/// Create a copy of FestivePoster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivePosterCopyWith<_FestivePoster> get copyWith => __$FestivePosterCopyWithImpl<_FestivePoster>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestivePosterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivePoster&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.templateName, templateName) || other.templateName == templateName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,templateName);

@override
String toString() {
  return 'FestivePoster(imageUrl: $imageUrl, templateName: $templateName)';
}


}

/// @nodoc
abstract mixin class _$FestivePosterCopyWith<$Res> implements $FestivePosterCopyWith<$Res> {
  factory _$FestivePosterCopyWith(_FestivePoster value, $Res Function(_FestivePoster) _then) = __$FestivePosterCopyWithImpl;
@override @useResult
$Res call({
 String imageUrl, String templateName
});




}
/// @nodoc
class __$FestivePosterCopyWithImpl<$Res>
    implements _$FestivePosterCopyWith<$Res> {
  __$FestivePosterCopyWithImpl(this._self, this._then);

  final _FestivePoster _self;
  final $Res Function(_FestivePoster) _then;

/// Create a copy of FestivePoster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,Object? templateName = null,}) {
  return _then(_FestivePoster(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,templateName: null == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FestivePosterState {

 FestivePosterBusy get busy; FestivePoster? get poster;/// The storage URL, once the poster has been saved.
 String? get savedUrl;/// Rendered in amber, never red.
 String? get error;/// 402. The remedy is topping up, so the UI must not offer a retry.
 bool get insufficientXp;
/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivePosterStateCopyWith<FestivePosterState> get copyWith => _$FestivePosterStateCopyWithImpl<FestivePosterState>(this as FestivePosterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivePosterState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.savedUrl, savedUrl) || other.savedUrl == savedUrl)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp));
}


@override
int get hashCode => Object.hash(runtimeType,busy,poster,savedUrl,error,insufficientXp);

@override
String toString() {
  return 'FestivePosterState(busy: $busy, poster: $poster, savedUrl: $savedUrl, error: $error, insufficientXp: $insufficientXp)';
}


}

/// @nodoc
abstract mixin class $FestivePosterStateCopyWith<$Res>  {
  factory $FestivePosterStateCopyWith(FestivePosterState value, $Res Function(FestivePosterState) _then) = _$FestivePosterStateCopyWithImpl;
@useResult
$Res call({
 FestivePosterBusy busy, FestivePoster? poster, String? savedUrl, String? error, bool insufficientXp
});


$FestivePosterCopyWith<$Res>? get poster;

}
/// @nodoc
class _$FestivePosterStateCopyWithImpl<$Res>
    implements $FestivePosterStateCopyWith<$Res> {
  _$FestivePosterStateCopyWithImpl(this._self, this._then);

  final FestivePosterState _self;
  final $Res Function(FestivePosterState) _then;

/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? poster = freezed,Object? savedUrl = freezed,Object? error = freezed,Object? insufficientXp = null,}) {
  return _then(_self.copyWith(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as FestivePosterBusy,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as FestivePoster?,savedUrl: freezed == savedUrl ? _self.savedUrl : savedUrl // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivePosterCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $FestivePosterCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}
}


/// Adds pattern-matching-related methods to [FestivePosterState].
extension FestivePosterStatePatterns on FestivePosterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivePosterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivePosterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivePosterState value)  $default,){
final _that = this;
switch (_that) {
case _FestivePosterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivePosterState value)?  $default,){
final _that = this;
switch (_that) {
case _FestivePosterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FestivePosterBusy busy,  FestivePoster? poster,  String? savedUrl,  String? error,  bool insufficientXp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivePosterState() when $default != null:
return $default(_that.busy,_that.poster,_that.savedUrl,_that.error,_that.insufficientXp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FestivePosterBusy busy,  FestivePoster? poster,  String? savedUrl,  String? error,  bool insufficientXp)  $default,) {final _that = this;
switch (_that) {
case _FestivePosterState():
return $default(_that.busy,_that.poster,_that.savedUrl,_that.error,_that.insufficientXp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FestivePosterBusy busy,  FestivePoster? poster,  String? savedUrl,  String? error,  bool insufficientXp)?  $default,) {final _that = this;
switch (_that) {
case _FestivePosterState() when $default != null:
return $default(_that.busy,_that.poster,_that.savedUrl,_that.error,_that.insufficientXp);case _:
  return null;

}
}

}

/// @nodoc


class _FestivePosterState extends FestivePosterState {
  const _FestivePosterState({this.busy = FestivePosterBusy.idle, this.poster, this.savedUrl, this.error, this.insufficientXp = false}): super._();
  

@override@JsonKey() final  FestivePosterBusy busy;
@override final  FestivePoster? poster;
/// The storage URL, once the poster has been saved.
@override final  String? savedUrl;
/// Rendered in amber, never red.
@override final  String? error;
/// 402. The remedy is topping up, so the UI must not offer a retry.
@override@JsonKey() final  bool insufficientXp;

/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivePosterStateCopyWith<_FestivePosterState> get copyWith => __$FestivePosterStateCopyWithImpl<_FestivePosterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivePosterState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.savedUrl, savedUrl) || other.savedUrl == savedUrl)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp));
}


@override
int get hashCode => Object.hash(runtimeType,busy,poster,savedUrl,error,insufficientXp);

@override
String toString() {
  return 'FestivePosterState(busy: $busy, poster: $poster, savedUrl: $savedUrl, error: $error, insufficientXp: $insufficientXp)';
}


}

/// @nodoc
abstract mixin class _$FestivePosterStateCopyWith<$Res> implements $FestivePosterStateCopyWith<$Res> {
  factory _$FestivePosterStateCopyWith(_FestivePosterState value, $Res Function(_FestivePosterState) _then) = __$FestivePosterStateCopyWithImpl;
@override @useResult
$Res call({
 FestivePosterBusy busy, FestivePoster? poster, String? savedUrl, String? error, bool insufficientXp
});


@override $FestivePosterCopyWith<$Res>? get poster;

}
/// @nodoc
class __$FestivePosterStateCopyWithImpl<$Res>
    implements _$FestivePosterStateCopyWith<$Res> {
  __$FestivePosterStateCopyWithImpl(this._self, this._then);

  final _FestivePosterState _self;
  final $Res Function(_FestivePosterState) _then;

/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? poster = freezed,Object? savedUrl = freezed,Object? error = freezed,Object? insufficientXp = null,}) {
  return _then(_FestivePosterState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as FestivePosterBusy,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as FestivePoster?,savedUrl: freezed == savedUrl ? _self.savedUrl : savedUrl // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FestivePosterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivePosterCopyWith<$Res>? get poster {
    if (_self.poster == null) {
    return null;
  }

  return $FestivePosterCopyWith<$Res>(_self.poster!, (value) {
    return _then(_self.copyWith(poster: value));
  });
}
}

// dart format on
