// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One visit to today's lesson.
///
/// ## The open comes first, and is waited for
///
/// Building this POSTs the open, and nothing can be answered until it lands.
/// The day's first open writes the learner's own questions with a model call;
/// an answer that reached the server first would create the day's row
/// without them, and the open only writes them while nothing is answered —
/// so the day would be the set questions alone, for good. If the open fails,
/// the read stands in, and the set questions are the lesson: a model hiccup
/// never costs a streak.
///
/// ## One open per visit
///
/// The open is held alive while it runs. Backing out mid-open and coming
/// straight back finds the same run still waiting on the same request — a
/// second POST would claim a second attempt and pay for a second model call
/// for the same five questions. Once it lands, leaving disposes the run, and
/// the next visit opens again (cheaply: the questions are already written).
///
/// ## Answers in order, as text
///
/// [answer] sends the option's TEXT — each learner sees their own order, so
/// an index would re-point — for the first unanswered question only, and only
/// while it is the one on screen. The reveal is the reply: a replay shows the
/// RECORDED answer, never this device's pick.

@ProviderFor(LessonRun)
final lessonRunProvider = LessonRunProvider._();

/// One visit to today's lesson.
///
/// ## The open comes first, and is waited for
///
/// Building this POSTs the open, and nothing can be answered until it lands.
/// The day's first open writes the learner's own questions with a model call;
/// an answer that reached the server first would create the day's row
/// without them, and the open only writes them while nothing is answered —
/// so the day would be the set questions alone, for good. If the open fails,
/// the read stands in, and the set questions are the lesson: a model hiccup
/// never costs a streak.
///
/// ## One open per visit
///
/// The open is held alive while it runs. Backing out mid-open and coming
/// straight back finds the same run still waiting on the same request — a
/// second POST would claim a second attempt and pay for a second model call
/// for the same five questions. Once it lands, leaving disposes the run, and
/// the next visit opens again (cheaply: the questions are already written).
///
/// ## Answers in order, as text
///
/// [answer] sends the option's TEXT — each learner sees their own order, so
/// an index would re-point — for the first unanswered question only, and only
/// while it is the one on screen. The reveal is the reply: a replay shows the
/// RECORDED answer, never this device's pick.
final class LessonRunProvider
    extends $NotifierProvider<LessonRun, LessonRunState> {
  /// One visit to today's lesson.
  ///
  /// ## The open comes first, and is waited for
  ///
  /// Building this POSTs the open, and nothing can be answered until it lands.
  /// The day's first open writes the learner's own questions with a model call;
  /// an answer that reached the server first would create the day's row
  /// without them, and the open only writes them while nothing is answered —
  /// so the day would be the set questions alone, for good. If the open fails,
  /// the read stands in, and the set questions are the lesson: a model hiccup
  /// never costs a streak.
  ///
  /// ## One open per visit
  ///
  /// The open is held alive while it runs. Backing out mid-open and coming
  /// straight back finds the same run still waiting on the same request — a
  /// second POST would claim a second attempt and pay for a second model call
  /// for the same five questions. Once it lands, leaving disposes the run, and
  /// the next visit opens again (cheaply: the questions are already written).
  ///
  /// ## Answers in order, as text
  ///
  /// [answer] sends the option's TEXT — each learner sees their own order, so
  /// an index would re-point — for the first unanswered question only, and only
  /// while it is the one on screen. The reveal is the reply: a replay shows the
  /// RECORDED answer, never this device's pick.
  LessonRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonRunHash();

  @$internal
  @override
  LessonRun create() => LessonRun();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonRunState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonRunState>(value),
    );
  }
}

String _$lessonRunHash() => r'f4eccdda17fea8a941fbe8f8e0c52eeba5ecaa7f';

/// One visit to today's lesson.
///
/// ## The open comes first, and is waited for
///
/// Building this POSTs the open, and nothing can be answered until it lands.
/// The day's first open writes the learner's own questions with a model call;
/// an answer that reached the server first would create the day's row
/// without them, and the open only writes them while nothing is answered —
/// so the day would be the set questions alone, for good. If the open fails,
/// the read stands in, and the set questions are the lesson: a model hiccup
/// never costs a streak.
///
/// ## One open per visit
///
/// The open is held alive while it runs. Backing out mid-open and coming
/// straight back finds the same run still waiting on the same request — a
/// second POST would claim a second attempt and pay for a second model call
/// for the same five questions. Once it lands, leaving disposes the run, and
/// the next visit opens again (cheaply: the questions are already written).
///
/// ## Answers in order, as text
///
/// [answer] sends the option's TEXT — each learner sees their own order, so
/// an index would re-point — for the first unanswered question only, and only
/// while it is the one on screen. The reveal is the reply: a replay shows the
/// RECORDED answer, never this device's pick.

abstract class _$LessonRun extends $Notifier<LessonRunState> {
  LessonRunState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LessonRunState, LessonRunState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LessonRunState, LessonRunState>,
              LessonRunState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
