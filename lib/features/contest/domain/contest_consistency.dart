import 'package:freezed_annotation/freezed_annotation.dart';

import 'contest_path.dart';
import 'contest_words.dart';

part 'contest_consistency.freezed.dart';
part 'contest_consistency.g.dart';

// The consistency meter (owner, 17 Nov 2026): how much of the contest XP on
// offer the learner earned over their billing window. Mirrors
// `ConsistencyView` in the web's `lib/consistency.ts`; the copy is the web's
// `ConsistencyCard.tsx`, line for line.
//
// Measurement only. There is no price in this phase — mode `on` reads
// exactly like `shadow` — so nothing here, and nothing that draws it, ever
// names a rupee.

/// What the meter has to say. Mirrors `ConsistencyState`.
///
/// An unknown state reads as [off]: show nothing. A state this build cannot
/// interpret must never draw a percent the server did not mean.
enum ConsistencyState {
  off,
  @JsonValue('no_contest')
  noContest,
  @JsonValue('not_joined')
  notJoined,
  @JsonValue('no_tasks')
  noTasks,
  measuring;

  /// The card shows nothing at all for these — the meter is a quiet
  /// addition, never a wall. (`not_joined` never reaches the running page —
  /// a non-entrant gets the join card — but the API sends it.)
  bool get isHidden =>
      this == ConsistencyState.off ||
      this == ConsistencyState.noContest ||
      this == ConsistencyState.notJoined;
}

/// The admin's setting. `on` reads exactly as `shadow` in this phase.
enum ConsistencyMode { off, shadow, on }

/// The billing window the meter counts over, `[from, to)`. Mirrors the
/// view's `window`.
@freezed
abstract class ConsistencyWindow with _$ConsistencyWindow {
  const factory ConsistencyWindow({
    /// The first instant counted.
    required DateTime from,

    /// The EXCLUSIVE end. Shown as the instant before it — "until 16 Dec",
    /// never the day after.
    required DateTime to,

    /// `trial | subscription | pass | calendar`. Shown nowhere.
    @Default('') String basis,
    @Default(false) bool estimated,
  }) = _ConsistencyWindow;

  factory ConsistencyWindow.fromJson(Map<String, dynamic> json) =>
      _$ConsistencyWindowFromJson(json);
}

/// Today's share: what the day has paid against what it could.
@freezed
abstract class ConsistencyToday with _$ConsistencyToday {
  const factory ConsistencyToday({
    @Default('') String dayKey,
    @Default(0) int earned,
    @Default(0) int available,
  }) = _ConsistencyToday;

  factory ConsistencyToday.fromJson(Map<String, dynamic> json) =>
      _$ConsistencyTodayFromJson(json);
}

/// One counted contest day, keyed in the contest's timezone.
@freezed
abstract class ConsistencyDay with _$ConsistencyDay {
  const factory ConsistencyDay({
    @Default('') String dayKey,
    @Default(0) int available,
    @Default(0) int earned,
    @Default(0) int pending,
    @Default(false) bool paused,
    @Default(false) bool today,
  }) = _ConsistencyDay;

  factory ConsistencyDay.fromJson(Map<String, dynamic> json) =>
      _$ConsistencyDayFromJson(json);
}

/// `GET /contest/consistency` → `{consistency}`.
@freezed
abstract class ConsistencyView with _$ConsistencyView {
  const ConsistencyView._();

  const factory ConsistencyView({
    @JsonKey(unknownEnumValue: ConsistencyState.off)
    @Default(ConsistencyState.off)
    ConsistencyState state,
    @JsonKey(unknownEnumValue: ConsistencyMode.shadow)
    @Default(ConsistencyMode.shadow)
    ConsistencyMode mode,

    /// The line, in percent.
    @Default(75) int threshold,

    /// Floored. Null unless [state] is measuring.
    int? percent,

    /// Compare with this, never by re-deriving from [percent].
    bool? atOrAbove,
    @Default(0) int earned,
    @Default(0) int available,

    /// Waiting for review — not counted yet.
    @Default(0) int pending,

    /// Earned, but self-reported and not yet audited.
    @Default(0) int unaudited,

    /// XP more that puts the learner on the line.
    @Default(0) int toLine,
    @Default(0) int countedDays,
    ConsistencyWindow? window,
    ConsistencyToday? today,
    bool? joined,
    @Default(false) bool scoringPaused,

    /// No contest is running now: days without one don't count.
    @Default(false) bool noContestRunning,
    @Default(<ConsistencyDay>[]) List<ConsistencyDay> days,
  }) = _ConsistencyView;

  factory ConsistencyView.fromJson(Map<String, dynamic> json) =>
      _$ConsistencyViewFromJson(json);

  /// The stats bar's figure: only while the meter is measuring. The web's
  /// `consistencyFigure`.
  ConsistencyFigure? get figure {
    final int? p = percent;
    if (state != ConsistencyState.measuring || p == null) return null;
    return ConsistencyFigure(percent: p, atOrAbove: atOrAbove == true);
  }
}

/// The one figure the stats bar shows for the meter.
@immutable
class ConsistencyFigure {
  const ConsistencyFigure({required this.percent, required this.atOrAbove});

  final int percent;
  final bool atOrAbove;

  @override
  bool operator ==(Object other) =>
      other is ConsistencyFigure &&
      other.percent == percent &&
      other.atOrAbove == atOrAbove;

  @override
  int get hashCode => Object.hash(percent, atOrAbove);
}

/// "17 Nov", on India time — the billing clock, whatever the phone's. The
/// web's `shortIst`. [minus] comes off first: the window's end is
/// exclusive, so its last day is the instant before it.
String shortIst(DateTime instant, {Duration minus = Duration.zero}) {
  final DateTime ist = instant
      .toUtc()
      .subtract(minus)
      .add(const Duration(hours: 5, minutes: 30));
  return '${ist.day} ${_monthShort[ist.month - 1]}';
}

const List<String> _monthShort = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// The lines under the figure, in order — the web's `consistencyLines`,
/// word for word. [path] adds the two notes today's own levels call for: a
/// skipped level, and a comment with no topics.
List<String> consistencyLines(ConsistencyView view, [ContestPath? path]) {
  final List<String> lines = <String>[];
  final ConsistencyWindow? window = view.window;
  if (view.state == ConsistencyState.measuring && window != null) {
    lines.add(
      '${formatCount(view.earned)} of ${formatCount(view.available)} XP on '
      'offer since ${shortIst(window.from)}.',
    );
    final String until = shortIst(
      window.to,
      minus: const Duration(milliseconds: 1),
    );
    lines.add(
      view.atOrAbove == true
          ? 'You’re above the ${view.threshold}% line. Keep it there until '
                '$until.'
          : '${formatCount(view.toLine)} XP more puts you on the '
                '${view.threshold}% line.',
    );
  }
  if (view.state == ConsistencyState.noTasks) {
    lines.add(
      'Nothing on offer yet this month. Your % starts with your next contest '
      'day.',
    );
  }
  final ConsistencyToday? today = view.today;
  if (today != null && today.available > 0) {
    lines.add(
      'Today: ${formatCount(today.earned)} of '
      '${formatCount(today.available)} XP so far.',
    );
  }
  if (view.pending > 0) {
    lines.add(
      '${formatCount(view.pending)} XP waiting for review isn’t counted yet.',
    );
  }
  if (view.scoringPaused) {
    lines.add('Scoring is paused, so paused days are left out.');
  }
  final List<PathNode> nodes = path?.status == ContestPathStatus.running
      ? (path?.today?.nodes ?? const <PathNode>[])
      : const <PathNode>[];
  if (nodes.any((PathNode n) => n.state == PathNodeState.skipped)) {
    lines.add(
      'Skipped levels still count as on offer. Come back to them today.',
    );
  }
  if (nodes.any(
    (PathNode n) =>
        n.kind == PathNodeKind.comment &&
        n.state == PathNodeState.unavailable &&
        (n.detail ?? '').startsWith('Choose your post topics'),
  )) {
    lines.add(
      'Today’s comment still counts as on offer — choose your post topics in '
      'Settings to get one.',
    );
  }
  if (view.noContestRunning && view.days.isNotEmpty) {
    lines.add('No contest is running. Days without one don’t count.');
  }
  return lines;
}
