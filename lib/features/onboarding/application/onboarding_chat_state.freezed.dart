// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingChatState {

 List<ChatMessage> get messages; OnboardingStep get step;/// Plexa is composing. Drives the typing bubble, and — on a panel step —
/// replaces the composer with the typing hint so nobody types into a
/// half-asked question.
 bool get isBotTyping; OnboardingAnswers get answers;/// The voice composer's text, hoisted out of the widget.
///
/// The web hoists it for a specific reason worth keeping: a too-short draft
/// is rejected by sending a bot line, which flips [isBotTyping], which
/// swaps the composer for the typing hint — wiping what the user typed and
/// asking them to retry into an emptied box.
 String get voiceDraft; bool get isFinalising;/// The finalise failed and the user is being offered a retry. The only
/// state that changes the finish step's lane.
 bool get finaliseError;/// The preferences write succeeded. The page watches this and hands over to
/// the router; nothing else is allowed to navigate.
 bool get completed;/// The user has sent at least one message. Only used to drop the "Tap to
/// send" hint above the first chip row, exactly as the web does.
 bool get hasUserSent;/// The greeting name. Null until `/auth/me` answers; the greeting falls
/// back to "there" the way the web's does with a nameless session.
 String? get firstName;
/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingChatStateCopyWith<OnboardingChatState> get copyWith => _$OnboardingChatStateCopyWithImpl<OnboardingChatState>(this as OnboardingChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.step, step) || other.step == step)&&(identical(other.isBotTyping, isBotTyping) || other.isBotTyping == isBotTyping)&&(identical(other.answers, answers) || other.answers == answers)&&(identical(other.voiceDraft, voiceDraft) || other.voiceDraft == voiceDraft)&&(identical(other.isFinalising, isFinalising) || other.isFinalising == isFinalising)&&(identical(other.finaliseError, finaliseError) || other.finaliseError == finaliseError)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.hasUserSent, hasUserSent) || other.hasUserSent == hasUserSent)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),step,isBotTyping,answers,voiceDraft,isFinalising,finaliseError,completed,hasUserSent,firstName);

@override
String toString() {
  return 'OnboardingChatState(messages: $messages, step: $step, isBotTyping: $isBotTyping, answers: $answers, voiceDraft: $voiceDraft, isFinalising: $isFinalising, finaliseError: $finaliseError, completed: $completed, hasUserSent: $hasUserSent, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class $OnboardingChatStateCopyWith<$Res>  {
  factory $OnboardingChatStateCopyWith(OnboardingChatState value, $Res Function(OnboardingChatState) _then) = _$OnboardingChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, OnboardingStep step, bool isBotTyping, OnboardingAnswers answers, String voiceDraft, bool isFinalising, bool finaliseError, bool completed, bool hasUserSent, String? firstName
});


$OnboardingAnswersCopyWith<$Res> get answers;

}
/// @nodoc
class _$OnboardingChatStateCopyWithImpl<$Res>
    implements $OnboardingChatStateCopyWith<$Res> {
  _$OnboardingChatStateCopyWithImpl(this._self, this._then);

  final OnboardingChatState _self;
  final $Res Function(OnboardingChatState) _then;

/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? step = null,Object? isBotTyping = null,Object? answers = null,Object? voiceDraft = null,Object? isFinalising = null,Object? finaliseError = null,Object? completed = null,Object? hasUserSent = null,Object? firstName = freezed,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,isBotTyping: null == isBotTyping ? _self.isBotTyping : isBotTyping // ignore: cast_nullable_to_non_nullable
as bool,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as OnboardingAnswers,voiceDraft: null == voiceDraft ? _self.voiceDraft : voiceDraft // ignore: cast_nullable_to_non_nullable
as String,isFinalising: null == isFinalising ? _self.isFinalising : isFinalising // ignore: cast_nullable_to_non_nullable
as bool,finaliseError: null == finaliseError ? _self.finaliseError : finaliseError // ignore: cast_nullable_to_non_nullable
as bool,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,hasUserSent: null == hasUserSent ? _self.hasUserSent : hasUserSent // ignore: cast_nullable_to_non_nullable
as bool,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingAnswersCopyWith<$Res> get answers {
  
  return $OnboardingAnswersCopyWith<$Res>(_self.answers, (value) {
    return _then(_self.copyWith(answers: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingChatState].
extension OnboardingChatStatePatterns on OnboardingChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingChatState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingChatState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)  $default,) {final _that = this;
switch (_that) {
case _OnboardingChatState():
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingChatState extends OnboardingChatState {
  const _OnboardingChatState({final  List<ChatMessage> messages = const <ChatMessage>[], this.step = OnboardingStep.welcome, this.isBotTyping = false, this.answers = const OnboardingAnswers(), this.voiceDraft = '', this.isFinalising = false, this.finaliseError = false, this.completed = false, this.hasUserSent = false, this.firstName}): _messages = messages,super._();
  

 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  OnboardingStep step;
/// Plexa is composing. Drives the typing bubble, and — on a panel step —
/// replaces the composer with the typing hint so nobody types into a
/// half-asked question.
@override@JsonKey() final  bool isBotTyping;
@override@JsonKey() final  OnboardingAnswers answers;
/// The voice composer's text, hoisted out of the widget.
///
/// The web hoists it for a specific reason worth keeping: a too-short draft
/// is rejected by sending a bot line, which flips [isBotTyping], which
/// swaps the composer for the typing hint — wiping what the user typed and
/// asking them to retry into an emptied box.
@override@JsonKey() final  String voiceDraft;
@override@JsonKey() final  bool isFinalising;
/// The finalise failed and the user is being offered a retry. The only
/// state that changes the finish step's lane.
@override@JsonKey() final  bool finaliseError;
/// The preferences write succeeded. The page watches this and hands over to
/// the router; nothing else is allowed to navigate.
@override@JsonKey() final  bool completed;
/// The user has sent at least one message. Only used to drop the "Tap to
/// send" hint above the first chip row, exactly as the web does.
@override@JsonKey() final  bool hasUserSent;
/// The greeting name. Null until `/auth/me` answers; the greeting falls
/// back to "there" the way the web's does with a nameless session.
@override final  String? firstName;

/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingChatStateCopyWith<_OnboardingChatState> get copyWith => __$OnboardingChatStateCopyWithImpl<_OnboardingChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.step, step) || other.step == step)&&(identical(other.isBotTyping, isBotTyping) || other.isBotTyping == isBotTyping)&&(identical(other.answers, answers) || other.answers == answers)&&(identical(other.voiceDraft, voiceDraft) || other.voiceDraft == voiceDraft)&&(identical(other.isFinalising, isFinalising) || other.isFinalising == isFinalising)&&(identical(other.finaliseError, finaliseError) || other.finaliseError == finaliseError)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.hasUserSent, hasUserSent) || other.hasUserSent == hasUserSent)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),step,isBotTyping,answers,voiceDraft,isFinalising,finaliseError,completed,hasUserSent,firstName);

@override
String toString() {
  return 'OnboardingChatState(messages: $messages, step: $step, isBotTyping: $isBotTyping, answers: $answers, voiceDraft: $voiceDraft, isFinalising: $isFinalising, finaliseError: $finaliseError, completed: $completed, hasUserSent: $hasUserSent, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class _$OnboardingChatStateCopyWith<$Res> implements $OnboardingChatStateCopyWith<$Res> {
  factory _$OnboardingChatStateCopyWith(_OnboardingChatState value, $Res Function(_OnboardingChatState) _then) = __$OnboardingChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, OnboardingStep step, bool isBotTyping, OnboardingAnswers answers, String voiceDraft, bool isFinalising, bool finaliseError, bool completed, bool hasUserSent, String? firstName
});


@override $OnboardingAnswersCopyWith<$Res> get answers;

}
/// @nodoc
class __$OnboardingChatStateCopyWithImpl<$Res>
    implements _$OnboardingChatStateCopyWith<$Res> {
  __$OnboardingChatStateCopyWithImpl(this._self, this._then);

  final _OnboardingChatState _self;
  final $Res Function(_OnboardingChatState) _then;

/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? step = null,Object? isBotTyping = null,Object? answers = null,Object? voiceDraft = null,Object? isFinalising = null,Object? finaliseError = null,Object? completed = null,Object? hasUserSent = null,Object? firstName = freezed,}) {
  return _then(_OnboardingChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,isBotTyping: null == isBotTyping ? _self.isBotTyping : isBotTyping // ignore: cast_nullable_to_non_nullable
as bool,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as OnboardingAnswers,voiceDraft: null == voiceDraft ? _self.voiceDraft : voiceDraft // ignore: cast_nullable_to_non_nullable
as String,isFinalising: null == isFinalising ? _self.isFinalising : isFinalising // ignore: cast_nullable_to_non_nullable
as bool,finaliseError: null == finaliseError ? _self.finaliseError : finaliseError // ignore: cast_nullable_to_non_nullable
as bool,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,hasUserSent: null == hasUserSent ? _self.hasUserSent : hasUserSent // ignore: cast_nullable_to_non_nullable
as bool,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OnboardingChatState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingAnswersCopyWith<$Res> get answers {
  
  return $OnboardingAnswersCopyWith<$Res>(_self.answers, (value) {
    return _then(_self.copyWith(answers: value));
  });
}
}

// dart format on
