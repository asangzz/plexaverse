// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposeContextState {

 UserPreferences get preferences; List<LinkedinAccount> get accounts;
/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeContextStateCopyWith<ComposeContextState> get copyWith => _$ComposeContextStateCopyWithImpl<ComposeContextState>(this as ComposeContextState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeContextState&&(identical(other.preferences, preferences) || other.preferences == preferences)&&const DeepCollectionEquality().equals(other.accounts, accounts));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,const DeepCollectionEquality().hash(accounts));

@override
String toString() {
  return 'ComposeContextState(preferences: $preferences, accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class $ComposeContextStateCopyWith<$Res>  {
  factory $ComposeContextStateCopyWith(ComposeContextState value, $Res Function(ComposeContextState) _then) = _$ComposeContextStateCopyWithImpl;
@useResult
$Res call({
 UserPreferences preferences, List<LinkedinAccount> accounts
});


$UserPreferencesCopyWith<$Res> get preferences;

}
/// @nodoc
class _$ComposeContextStateCopyWithImpl<$Res>
    implements $ComposeContextStateCopyWith<$Res> {
  _$ComposeContextStateCopyWithImpl(this._self, this._then);

  final ComposeContextState _self;
  final $Res Function(ComposeContextState) _then;

/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preferences = null,Object? accounts = null,}) {
  return _then(_self.copyWith(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<LinkedinAccount>,
  ));
}
/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComposeContextState].
extension ComposeContextStatePatterns on ComposeContextState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComposeContextState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComposeContextState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComposeContextState value)  $default,){
final _that = this;
switch (_that) {
case _ComposeContextState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComposeContextState value)?  $default,){
final _that = this;
switch (_that) {
case _ComposeContextState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserPreferences preferences,  List<LinkedinAccount> accounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComposeContextState() when $default != null:
return $default(_that.preferences,_that.accounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserPreferences preferences,  List<LinkedinAccount> accounts)  $default,) {final _that = this;
switch (_that) {
case _ComposeContextState():
return $default(_that.preferences,_that.accounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserPreferences preferences,  List<LinkedinAccount> accounts)?  $default,) {final _that = this;
switch (_that) {
case _ComposeContextState() when $default != null:
return $default(_that.preferences,_that.accounts);case _:
  return null;

}
}

}

/// @nodoc


class _ComposeContextState extends ComposeContextState {
  const _ComposeContextState({this.preferences = UserPreferences.empty, final  List<LinkedinAccount> accounts = const <LinkedinAccount>[]}): _accounts = accounts,super._();
  

@override@JsonKey() final  UserPreferences preferences;
 final  List<LinkedinAccount> _accounts;
@override@JsonKey() List<LinkedinAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}


/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComposeContextStateCopyWith<_ComposeContextState> get copyWith => __$ComposeContextStateCopyWithImpl<_ComposeContextState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComposeContextState&&(identical(other.preferences, preferences) || other.preferences == preferences)&&const DeepCollectionEquality().equals(other._accounts, _accounts));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,const DeepCollectionEquality().hash(_accounts));

@override
String toString() {
  return 'ComposeContextState(preferences: $preferences, accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class _$ComposeContextStateCopyWith<$Res> implements $ComposeContextStateCopyWith<$Res> {
  factory _$ComposeContextStateCopyWith(_ComposeContextState value, $Res Function(_ComposeContextState) _then) = __$ComposeContextStateCopyWithImpl;
@override @useResult
$Res call({
 UserPreferences preferences, List<LinkedinAccount> accounts
});


@override $UserPreferencesCopyWith<$Res> get preferences;

}
/// @nodoc
class __$ComposeContextStateCopyWithImpl<$Res>
    implements _$ComposeContextStateCopyWith<$Res> {
  __$ComposeContextStateCopyWithImpl(this._self, this._then);

  final _ComposeContextState _self;
  final $Res Function(_ComposeContextState) _then;

/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? accounts = null,}) {
  return _then(_ComposeContextState(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<LinkedinAccount>,
  ));
}

/// Create a copy of ComposeContextState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}

// dart format on
