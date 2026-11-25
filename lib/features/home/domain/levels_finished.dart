import 'package:freezed_annotation/freezed_annotation.dart';

part 'levels_finished.freezed.dart';
part 'levels_finished.g.dart';

/// How much of one day's levels the user finished — the figure on a roadmap
/// day row (owner, 25 Nov 2026). Mirrors `LevelsFinishedDay` in the web's
/// `lib/levels-finished.ts`.
///
/// The server counts it off the levels path's own builder, so the app never
/// recomputes it: finished (done or approved) ÷ offered among that day's own
/// levels, `percent` floored.
@freezed
abstract class LevelsFinishedDay with _$LevelsFinishedDay {
  const factory LevelsFinishedDay({
    /// The journey day — the same numbering as `/roadmap/progress`
    /// `currentDay`, so it is the row the figure belongs on.
    required int day,

    /// The levels path day it was read from, `YYYY-MM-DD` in the round's
    /// timezone. Not drawn; kept for parity with the web.
    @Default('') String dayKey,
    @Default(0) int done,
    @Default(0) int offered,

    /// floor(100 × done ÷ offered).
    @Default(0) int percent,
  }) = _LevelsFinishedDay;

  factory LevelsFinishedDay.fromJson(Map<String, dynamic> json) =>
      _$LevelsFinishedDayFromJson(json);
}

/// `GET /roadmap/levels-finished` → `{ days }`.
///
/// A row with no figure is ABSENT, never sent as 0% — a day before the
/// learner was entered, outside the round, or with nothing counted. An empty
/// list is a normal answer.
@freezed
abstract class LevelsFinished with _$LevelsFinished {
  const LevelsFinished._();

  const factory LevelsFinished({
    /// Oldest first.
    @Default(<LevelsFinishedDay>[]) List<LevelsFinishedDay> days,
  }) = _LevelsFinished;

  factory LevelsFinished.fromJson(Map<String, dynamic> json) =>
      _$LevelsFinishedFromJson(json);

  /// The figures by journey day. An entry with nothing offered is dropped —
  /// "0/0" is not a figure.
  Map<int, LevelsFinishedDay> get byDay => <int, LevelsFinishedDay>{
    for (final LevelsFinishedDay d in days)
      if (d.offered > 0) d.day: d,
  };
}

/// The row's words, as the web's `levelsFinishedWords`: [short] is what it
/// shows ("3/5 levels · 60%"), [spoken] what a screen reader hears instead
/// ("3 of 5 levels finished, 60%") — a slash read aloud is "3 slash 5".
({String short, String spoken}) levelsFinishedWords(LevelsFinishedDay d) {
  final String noun = d.offered == 1 ? 'level' : 'levels';
  return (
    short: '${d.done}/${d.offered} $noun · ${d.percent}%',
    spoken: '${d.done} of ${d.offered} $noun finished, ${d.percent}%',
  );
}
