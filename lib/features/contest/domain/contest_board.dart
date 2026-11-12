import 'package:freezed_annotation/freezed_annotation.dart';

part 'contest_board.freezed.dart';
part 'contest_board.g.dart';

/// One place on the board. Mirrors `BoardRow` in the web's
/// `lib/services/contest.service.ts`.
@freezed
abstract class BoardRow with _$BoardRow {
  const factory BoardRow({
    @Default(0) int rank,

    /// Null unless this entrant agreed to be named (`contest_leaderboard`),
    /// or it is the viewer — and always null for a viewer who has not
    /// joined. Drawn as "Participant", never as a blank.
    String? name,
    String? image,
    @Default(false) bool isViewer,
    @Default(0) int total,

    /// The live daily lesson streak, on the contest's clock.
    @Default(0) int streak,
    @Default('B2') String level,
  }) = _BoardRow;

  factory BoardRow.fromJson(Map<String, dynamic> json) =>
      _$BoardRowFromJson(json);
}

/// The viewer's own figures, which are theirs to see before the reveal too.
@freezed
abstract class BoardSelf with _$BoardSelf {
  const factory BoardSelf({
    @Default(0) int total,
    @Default(0) int streak,
    @Default('B2') String level,
  }) = _BoardSelf;

  factory BoardSelf.fromJson(Map<String, dynamic> json) =>
      _$BoardSelfFromJson(json);
}

/// `GET /contest/board?limit=` — the board, bare inside `data`. Mirrors
/// `BoardResult`.
///
/// Before the reveal there are NO rows and no [viewer] (a viewer row would
/// carry a rank); [self] is all a learner gets. An admin's token gets the
/// rows early while [revealed] stays the entrants' truth, so the page can
/// still say when they will see it.
@freezed
abstract class BoardResult with _$BoardResult {
  const BoardResult._();

  const factory BoardResult({
    @Default(false) bool revealed,

    /// `YYYY-MM-DD`, contest timezone. Empty when there is no contest.
    @Default('') String revealsOn,
    @Default(1) int revealDay,
    @Default(<BoardRow>[]) List<BoardRow> rows,

    /// The caller's row, which may sit outside [rows].
    BoardRow? viewer,

    /// Null when the caller is not an entrant.
    BoardSelf? self,
  }) = _BoardResult;

  factory BoardResult.fromJson(Map<String, dynamic> json) =>
      _$BoardResultFromJson(json);

  /// The board is hidden for now: the server sent nothing to rank because
  /// the reveal has not come. The web's `locked` test, word for word — with
  /// no reveal date there is no contest to wait for, which is the plain
  /// empty board, not a hidden one.
  bool get isLocked => !revealed && rows.isEmpty && revealsOn.isNotEmpty;

  /// The viewer's row is not among [rows] and is pinned below them.
  bool get viewerOutsideRows =>
      viewer != null && !rows.any((BoardRow r) => r.isViewer);
}
