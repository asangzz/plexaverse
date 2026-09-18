import 'package:flutter/foundation.dart';

import '../domain/title_creator.dart';

/// Which of the three steps the Title Creator is on.
///
/// Matches the web's `step: 1 | 2 | 3` exactly, including the fact that
/// choosing a priority on step 2 advances to step 3 AND fires generation in
/// the same gesture — there is no separate "generate" button.
enum TitleStep { headline, priority, result }

/// The Title Creator wizard's whole state.
@immutable
class TitleCreatorState {
  const TitleCreatorState({
    this.step = TitleStep.headline,
    this.headline = '',
    this.analysis,
    this.priority,
    this.result,
    this.busy = false,
    this.error,
  });

  final TitleStep step;

  /// What the user typed on step 1. Kept so "Try again" can return to a
  /// pre-filled field rather than a blank one.
  final String headline;

  /// What the model read out of [headline]. Null until step 1 completes.
  final ProfessionAnalysis? analysis;

  final TitlePriority? priority;
  final TitleSuggestion? result;

  /// A request is in flight — analysing on step 1, generating on step 3.
  final bool busy;

  /// Shown in amber, never red.
  final String? error;

  TitleCreatorState copyWith({
    TitleStep? step,
    String? headline,
    ProfessionAnalysis? analysis,
    TitlePriority? priority,
    TitleSuggestion? result,
    bool? busy,
    String? error,
    bool clearError = false,
    bool clearResult = false,
  }) => TitleCreatorState(
    step: step ?? this.step,
    headline: headline ?? this.headline,
    analysis: analysis ?? this.analysis,
    priority: priority ?? this.priority,
    result: clearResult ? null : (result ?? this.result),
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
  );
}
