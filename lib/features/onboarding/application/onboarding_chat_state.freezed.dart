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
/// True once a LinkedIn connect attempt has failed or been cancelled.
///
/// Gates the "I'll connect later" escape on the connect step — the ONE
/// place this flow knowingly differs from the web, which has no escape at
/// all. Connecting stays mandatory until the OAuth trip has actually been
/// tried and not worked: requiring it unconditionally would trap a user
/// whose browser hand-off fails (the app's LinkedIn redirect depends on a
/// portal setting the web does not) behind a step they cannot pass.
 bool get connectFailed;/// The connected LinkedIn profile's name, for the web's
/// "Connected as {name}" line.
 String? get linkedinName;/// What the plan step offers. Null until the region and the autopay
/// switch have both been read — the button stays disabled until then,
/// because a guess here does not fail, it succeeds at the wrong price.
 PlanOffer? get planOffer;/// The region or the autopay switch could not be read. The step offers a
/// retry and nothing else: starting without them could put the user on
/// the wrong plan.
 bool get planOfferFailed;/// What the State picker starts on — the State on record, else the
/// server's reading of the region. Never saved until the buyer taps.
 String? get billingStatePreset;/// A State is being saved (the State step, or the plan step's inline
/// ask).
 bool get billingStateSaving;/// Why the last State save did not go through, in one sentence.
 String? get billingStateError;/// The plan step's button found no State on record — the State step
/// stepped aside because a read failed — so the panel asks it inline,
/// and the checkout runs once it is saved. Never a wall: an unreadable
/// State lets the payment go ahead.
 bool get planAskingState;/// The Razorpay sheet is open, or its result is being verified.
 bool get planBusy;/// Why the last attempt did not finish, in one sentence. Not set when the
/// sheet was simply closed.
 String? get planError;/// A UPI AutoPay sheet was opened on this step and did not finish —
/// closed, or failed. The panel then names the way out, since the step
/// has no skip and a UPI app that never opened looks exactly like this.
 bool get planSheetUnfinished; bool get finaliseError;/// The preferences write succeeded. The page watches this and hands over to
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.step, step) || other.step == step)&&(identical(other.isBotTyping, isBotTyping) || other.isBotTyping == isBotTyping)&&(identical(other.answers, answers) || other.answers == answers)&&(identical(other.voiceDraft, voiceDraft) || other.voiceDraft == voiceDraft)&&(identical(other.isFinalising, isFinalising) || other.isFinalising == isFinalising)&&(identical(other.connectFailed, connectFailed) || other.connectFailed == connectFailed)&&(identical(other.linkedinName, linkedinName) || other.linkedinName == linkedinName)&&(identical(other.planOffer, planOffer) || other.planOffer == planOffer)&&(identical(other.planOfferFailed, planOfferFailed) || other.planOfferFailed == planOfferFailed)&&(identical(other.billingStatePreset, billingStatePreset) || other.billingStatePreset == billingStatePreset)&&(identical(other.billingStateSaving, billingStateSaving) || other.billingStateSaving == billingStateSaving)&&(identical(other.billingStateError, billingStateError) || other.billingStateError == billingStateError)&&(identical(other.planAskingState, planAskingState) || other.planAskingState == planAskingState)&&(identical(other.planBusy, planBusy) || other.planBusy == planBusy)&&(identical(other.planError, planError) || other.planError == planError)&&(identical(other.planSheetUnfinished, planSheetUnfinished) || other.planSheetUnfinished == planSheetUnfinished)&&(identical(other.finaliseError, finaliseError) || other.finaliseError == finaliseError)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.hasUserSent, hasUserSent) || other.hasUserSent == hasUserSent)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}


@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(messages),step,isBotTyping,answers,voiceDraft,isFinalising,connectFailed,linkedinName,planOffer,planOfferFailed,billingStatePreset,billingStateSaving,billingStateError,planAskingState,planBusy,planError,planSheetUnfinished,finaliseError,completed,hasUserSent,firstName]);

@override
String toString() {
  return 'OnboardingChatState(messages: $messages, step: $step, isBotTyping: $isBotTyping, answers: $answers, voiceDraft: $voiceDraft, isFinalising: $isFinalising, connectFailed: $connectFailed, linkedinName: $linkedinName, planOffer: $planOffer, planOfferFailed: $planOfferFailed, billingStatePreset: $billingStatePreset, billingStateSaving: $billingStateSaving, billingStateError: $billingStateError, planAskingState: $planAskingState, planBusy: $planBusy, planError: $planError, planSheetUnfinished: $planSheetUnfinished, finaliseError: $finaliseError, completed: $completed, hasUserSent: $hasUserSent, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class $OnboardingChatStateCopyWith<$Res>  {
  factory $OnboardingChatStateCopyWith(OnboardingChatState value, $Res Function(OnboardingChatState) _then) = _$OnboardingChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, OnboardingStep step, bool isBotTyping, OnboardingAnswers answers, String voiceDraft, bool isFinalising, bool connectFailed, String? linkedinName, PlanOffer? planOffer, bool planOfferFailed, String? billingStatePreset, bool billingStateSaving, String? billingStateError, bool planAskingState, bool planBusy, String? planError, bool planSheetUnfinished, bool finaliseError, bool completed, bool hasUserSent, String? firstName
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
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? step = null,Object? isBotTyping = null,Object? answers = null,Object? voiceDraft = null,Object? isFinalising = null,Object? connectFailed = null,Object? linkedinName = freezed,Object? planOffer = freezed,Object? planOfferFailed = null,Object? billingStatePreset = freezed,Object? billingStateSaving = null,Object? billingStateError = freezed,Object? planAskingState = null,Object? planBusy = null,Object? planError = freezed,Object? planSheetUnfinished = null,Object? finaliseError = null,Object? completed = null,Object? hasUserSent = null,Object? firstName = freezed,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,isBotTyping: null == isBotTyping ? _self.isBotTyping : isBotTyping // ignore: cast_nullable_to_non_nullable
as bool,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as OnboardingAnswers,voiceDraft: null == voiceDraft ? _self.voiceDraft : voiceDraft // ignore: cast_nullable_to_non_nullable
as String,isFinalising: null == isFinalising ? _self.isFinalising : isFinalising // ignore: cast_nullable_to_non_nullable
as bool,connectFailed: null == connectFailed ? _self.connectFailed : connectFailed // ignore: cast_nullable_to_non_nullable
as bool,linkedinName: freezed == linkedinName ? _self.linkedinName : linkedinName // ignore: cast_nullable_to_non_nullable
as String?,planOffer: freezed == planOffer ? _self.planOffer : planOffer // ignore: cast_nullable_to_non_nullable
as PlanOffer?,planOfferFailed: null == planOfferFailed ? _self.planOfferFailed : planOfferFailed // ignore: cast_nullable_to_non_nullable
as bool,billingStatePreset: freezed == billingStatePreset ? _self.billingStatePreset : billingStatePreset // ignore: cast_nullable_to_non_nullable
as String?,billingStateSaving: null == billingStateSaving ? _self.billingStateSaving : billingStateSaving // ignore: cast_nullable_to_non_nullable
as bool,billingStateError: freezed == billingStateError ? _self.billingStateError : billingStateError // ignore: cast_nullable_to_non_nullable
as String?,planAskingState: null == planAskingState ? _self.planAskingState : planAskingState // ignore: cast_nullable_to_non_nullable
as bool,planBusy: null == planBusy ? _self.planBusy : planBusy // ignore: cast_nullable_to_non_nullable
as bool,planError: freezed == planError ? _self.planError : planError // ignore: cast_nullable_to_non_nullable
as String?,planSheetUnfinished: null == planSheetUnfinished ? _self.planSheetUnfinished : planSheetUnfinished // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool connectFailed,  String? linkedinName,  PlanOffer? planOffer,  bool planOfferFailed,  String? billingStatePreset,  bool billingStateSaving,  String? billingStateError,  bool planAskingState,  bool planBusy,  String? planError,  bool planSheetUnfinished,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.connectFailed,_that.linkedinName,_that.planOffer,_that.planOfferFailed,_that.billingStatePreset,_that.billingStateSaving,_that.billingStateError,_that.planAskingState,_that.planBusy,_that.planError,_that.planSheetUnfinished,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool connectFailed,  String? linkedinName,  PlanOffer? planOffer,  bool planOfferFailed,  String? billingStatePreset,  bool billingStateSaving,  String? billingStateError,  bool planAskingState,  bool planBusy,  String? planError,  bool planSheetUnfinished,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)  $default,) {final _that = this;
switch (_that) {
case _OnboardingChatState():
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.connectFailed,_that.linkedinName,_that.planOffer,_that.planOfferFailed,_that.billingStatePreset,_that.billingStateSaving,_that.billingStateError,_that.planAskingState,_that.planBusy,_that.planError,_that.planSheetUnfinished,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> messages,  OnboardingStep step,  bool isBotTyping,  OnboardingAnswers answers,  String voiceDraft,  bool isFinalising,  bool connectFailed,  String? linkedinName,  PlanOffer? planOffer,  bool planOfferFailed,  String? billingStatePreset,  bool billingStateSaving,  String? billingStateError,  bool planAskingState,  bool planBusy,  String? planError,  bool planSheetUnfinished,  bool finaliseError,  bool completed,  bool hasUserSent,  String? firstName)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingChatState() when $default != null:
return $default(_that.messages,_that.step,_that.isBotTyping,_that.answers,_that.voiceDraft,_that.isFinalising,_that.connectFailed,_that.linkedinName,_that.planOffer,_that.planOfferFailed,_that.billingStatePreset,_that.billingStateSaving,_that.billingStateError,_that.planAskingState,_that.planBusy,_that.planError,_that.planSheetUnfinished,_that.finaliseError,_that.completed,_that.hasUserSent,_that.firstName);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingChatState extends OnboardingChatState {
  const _OnboardingChatState({final  List<ChatMessage> messages = const <ChatMessage>[], this.step = OnboardingStep.welcome, this.isBotTyping = false, this.answers = const OnboardingAnswers(), this.voiceDraft = '', this.isFinalising = false, this.connectFailed = false, this.linkedinName, this.planOffer, this.planOfferFailed = false, this.billingStatePreset, this.billingStateSaving = false, this.billingStateError, this.planAskingState = false, this.planBusy = false, this.planError, this.planSheetUnfinished = false, this.finaliseError = false, this.completed = false, this.hasUserSent = false, this.firstName}): _messages = messages,super._();
  

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
/// True once a LinkedIn connect attempt has failed or been cancelled.
///
/// Gates the "I'll connect later" escape on the connect step — the ONE
/// place this flow knowingly differs from the web, which has no escape at
/// all. Connecting stays mandatory until the OAuth trip has actually been
/// tried and not worked: requiring it unconditionally would trap a user
/// whose browser hand-off fails (the app's LinkedIn redirect depends on a
/// portal setting the web does not) behind a step they cannot pass.
@override@JsonKey() final  bool connectFailed;
/// The connected LinkedIn profile's name, for the web's
/// "Connected as {name}" line.
@override final  String? linkedinName;
/// What the plan step offers. Null until the region and the autopay
/// switch have both been read — the button stays disabled until then,
/// because a guess here does not fail, it succeeds at the wrong price.
@override final  PlanOffer? planOffer;
/// The region or the autopay switch could not be read. The step offers a
/// retry and nothing else: starting without them could put the user on
/// the wrong plan.
@override@JsonKey() final  bool planOfferFailed;
/// What the State picker starts on — the State on record, else the
/// server's reading of the region. Never saved until the buyer taps.
@override final  String? billingStatePreset;
/// A State is being saved (the State step, or the plan step's inline
/// ask).
@override@JsonKey() final  bool billingStateSaving;
/// Why the last State save did not go through, in one sentence.
@override final  String? billingStateError;
/// The plan step's button found no State on record — the State step
/// stepped aside because a read failed — so the panel asks it inline,
/// and the checkout runs once it is saved. Never a wall: an unreadable
/// State lets the payment go ahead.
@override@JsonKey() final  bool planAskingState;
/// The Razorpay sheet is open, or its result is being verified.
@override@JsonKey() final  bool planBusy;
/// Why the last attempt did not finish, in one sentence. Not set when the
/// sheet was simply closed.
@override final  String? planError;
/// A UPI AutoPay sheet was opened on this step and did not finish —
/// closed, or failed. The panel then names the way out, since the step
/// has no skip and a UPI app that never opened looks exactly like this.
@override@JsonKey() final  bool planSheetUnfinished;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.step, step) || other.step == step)&&(identical(other.isBotTyping, isBotTyping) || other.isBotTyping == isBotTyping)&&(identical(other.answers, answers) || other.answers == answers)&&(identical(other.voiceDraft, voiceDraft) || other.voiceDraft == voiceDraft)&&(identical(other.isFinalising, isFinalising) || other.isFinalising == isFinalising)&&(identical(other.connectFailed, connectFailed) || other.connectFailed == connectFailed)&&(identical(other.linkedinName, linkedinName) || other.linkedinName == linkedinName)&&(identical(other.planOffer, planOffer) || other.planOffer == planOffer)&&(identical(other.planOfferFailed, planOfferFailed) || other.planOfferFailed == planOfferFailed)&&(identical(other.billingStatePreset, billingStatePreset) || other.billingStatePreset == billingStatePreset)&&(identical(other.billingStateSaving, billingStateSaving) || other.billingStateSaving == billingStateSaving)&&(identical(other.billingStateError, billingStateError) || other.billingStateError == billingStateError)&&(identical(other.planAskingState, planAskingState) || other.planAskingState == planAskingState)&&(identical(other.planBusy, planBusy) || other.planBusy == planBusy)&&(identical(other.planError, planError) || other.planError == planError)&&(identical(other.planSheetUnfinished, planSheetUnfinished) || other.planSheetUnfinished == planSheetUnfinished)&&(identical(other.finaliseError, finaliseError) || other.finaliseError == finaliseError)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.hasUserSent, hasUserSent) || other.hasUserSent == hasUserSent)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}


@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_messages),step,isBotTyping,answers,voiceDraft,isFinalising,connectFailed,linkedinName,planOffer,planOfferFailed,billingStatePreset,billingStateSaving,billingStateError,planAskingState,planBusy,planError,planSheetUnfinished,finaliseError,completed,hasUserSent,firstName]);

@override
String toString() {
  return 'OnboardingChatState(messages: $messages, step: $step, isBotTyping: $isBotTyping, answers: $answers, voiceDraft: $voiceDraft, isFinalising: $isFinalising, connectFailed: $connectFailed, linkedinName: $linkedinName, planOffer: $planOffer, planOfferFailed: $planOfferFailed, billingStatePreset: $billingStatePreset, billingStateSaving: $billingStateSaving, billingStateError: $billingStateError, planAskingState: $planAskingState, planBusy: $planBusy, planError: $planError, planSheetUnfinished: $planSheetUnfinished, finaliseError: $finaliseError, completed: $completed, hasUserSent: $hasUserSent, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class _$OnboardingChatStateCopyWith<$Res> implements $OnboardingChatStateCopyWith<$Res> {
  factory _$OnboardingChatStateCopyWith(_OnboardingChatState value, $Res Function(_OnboardingChatState) _then) = __$OnboardingChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, OnboardingStep step, bool isBotTyping, OnboardingAnswers answers, String voiceDraft, bool isFinalising, bool connectFailed, String? linkedinName, PlanOffer? planOffer, bool planOfferFailed, String? billingStatePreset, bool billingStateSaving, String? billingStateError, bool planAskingState, bool planBusy, String? planError, bool planSheetUnfinished, bool finaliseError, bool completed, bool hasUserSent, String? firstName
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
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? step = null,Object? isBotTyping = null,Object? answers = null,Object? voiceDraft = null,Object? isFinalising = null,Object? connectFailed = null,Object? linkedinName = freezed,Object? planOffer = freezed,Object? planOfferFailed = null,Object? billingStatePreset = freezed,Object? billingStateSaving = null,Object? billingStateError = freezed,Object? planAskingState = null,Object? planBusy = null,Object? planError = freezed,Object? planSheetUnfinished = null,Object? finaliseError = null,Object? completed = null,Object? hasUserSent = null,Object? firstName = freezed,}) {
  return _then(_OnboardingChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,isBotTyping: null == isBotTyping ? _self.isBotTyping : isBotTyping // ignore: cast_nullable_to_non_nullable
as bool,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as OnboardingAnswers,voiceDraft: null == voiceDraft ? _self.voiceDraft : voiceDraft // ignore: cast_nullable_to_non_nullable
as String,isFinalising: null == isFinalising ? _self.isFinalising : isFinalising // ignore: cast_nullable_to_non_nullable
as bool,connectFailed: null == connectFailed ? _self.connectFailed : connectFailed // ignore: cast_nullable_to_non_nullable
as bool,linkedinName: freezed == linkedinName ? _self.linkedinName : linkedinName // ignore: cast_nullable_to_non_nullable
as String?,planOffer: freezed == planOffer ? _self.planOffer : planOffer // ignore: cast_nullable_to_non_nullable
as PlanOffer?,planOfferFailed: null == planOfferFailed ? _self.planOfferFailed : planOfferFailed // ignore: cast_nullable_to_non_nullable
as bool,billingStatePreset: freezed == billingStatePreset ? _self.billingStatePreset : billingStatePreset // ignore: cast_nullable_to_non_nullable
as String?,billingStateSaving: null == billingStateSaving ? _self.billingStateSaving : billingStateSaving // ignore: cast_nullable_to_non_nullable
as bool,billingStateError: freezed == billingStateError ? _self.billingStateError : billingStateError // ignore: cast_nullable_to_non_nullable
as String?,planAskingState: null == planAskingState ? _self.planAskingState : planAskingState // ignore: cast_nullable_to_non_nullable
as bool,planBusy: null == planBusy ? _self.planBusy : planBusy // ignore: cast_nullable_to_non_nullable
as bool,planError: freezed == planError ? _self.planError : planError // ignore: cast_nullable_to_non_nullable
as String?,planSheetUnfinished: null == planSheetUnfinished ? _self.planSheetUnfinished : planSheetUnfinished // ignore: cast_nullable_to_non_nullable
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
